# Fluxos Principais — GerenciadorDeTorneios BRLOL

> Atualizado em: **2026-04-26**

Este documento descreve os fluxos completos de cada ação relevante do sistema, do clique do usuário até o banco.

---

## 1. Criar Torneio (Organizador)

```
Usuário (organizador/admin)
  └─ acessa /organizador/torneios/novo
      └─ preenche formulário (name, description, max_teams, bracket_type, start_date, end_date, etc.)
          └─ submit → lib/actions/tournament.ts → createTournament()
              ├─ valida com zod
              ├─ checa requireAdmin() ou permissão de organizador
              ├─ INSERT em tournaments (usa start_date/end_date — NÃO starts_at/ends_at)
              └─ router.push("/torneios/{torneio.id}/inscricoes")
```

**Resultado:** Torneio criado, usuário é levado diretamente para a tela de inscrições daquele torneio.

---

## 2. Editar Torneio (Organizador)

```
Usuário
  └─ acessa /organizador/torneios/[id]
      └─ useEffect carrega torneio via .eq("id", id)
          ├─ preenche campos com start_date / end_date (NÃO starts_at/ends_at)
          └─ submit → handleSave()
              └─ UPDATE tournaments SET { name, description, start_date, end_date, ... }
                  (NUNCA inclui starts_at/ends_at no payload)
```

> ⚠️ `starts_at` e `ends_at` são colunas GENERATED. Se incluídas no UPDATE, causam erro:  
> `column "starts_at" can only be updated to DEFAULT`

---

## 3. Inscrever Time em Torneio (Usuário)

```
Usuário
  └─ acessa página pública do torneio (/torneios/[slug])
      └─ clica em "+ Inscrever meu time"
          └─ redireciona para /dashboard/times/criar?tournament={tournamentId}
              └─ preenche dados do time (name, tag, logo_url)
                  └─ INSERT em teams (com tournament_id = tournamentId)
                      └─ INSERT em inscricoes (tournament_id, team_id, status = 'pending')
                          └─ router.push("/torneios/{tournamentId}?inscrito=true")
```

> ⚠️ O link deve usar `/dashboard/times/criar` (plural). O singular `/dashboard/time/criar` retorna 404.

---

## 4. Aprovar / Rejeitar Inscrição (Organizador/Admin)

```
Organizador
  └─ acessa /organizador/torneios/[id]/inscricoes
      └─ lista inscricoes WHERE tournament_id = id
          └─ clica em Aprovar ou Rejeitar
              └─ lib/actions/inscricao.ts → aprovarInscricao(id) / rejeitarInscricao(id)
                  ├─ UPDATE inscricoes SET status = 'approved' | 'rejected'
                  ├─ INSERT em notifications (para o capitão do time)
                  └─ revalidatePath("/organizador/torneios/[id]/inscricoes")
```

---

## 5. Registrar Conta Riot (Usuário)

```
Usuário
  └─ acessa /dashboard/jogador/registrar
      └─ informa game_name + tagline
          └─ Edge Function riot-api-sync valida o PUUID via Riot API
              └─ INSERT em riot_accounts (profile_id, puuid, game_name, tagline, is_primary)
                  └─ Job agendado cria rank_snapshots e champion_masteries periodicamente
```

---

## 6. Gerar Chaveamento (Admin)

```
Admin
  └─ acessa /admin/torneios/[slug]
      └─ clica em "Gerar Chaveamento"
          └─ POST para Edge Function bracket-generator
              ├─ lê inscricoes aprovadas do torneio
              ├─ embaralha/ordena por seed
              ├─ INSERT em tournament_stages (ex.: "Playoffs")
              └─ INSERT em matches (team_a_id, team_b_id, round, match_number)
```

---

## 7. Registrar Resultado de Partida (Admin)

```
Admin
  └─ acessa /admin/torneios/[slug] → seção de partidas
      └─ preenche score_a, score_b, winner_team_id
          └─ lib/actions/partida.ts → editarResultadoPartida()
              ├─ UPDATE matches SET { score_a, score_b, winner_team_id, status: 'finished' }
              ├─ INSERT em match_games (se BO3/BO5, um registro por jogo)
              └─ revalidatePath()
```

---

## 8. Notificações em Tempo Real

```
Supabase Realtime
  └─ subscription em notifications WHERE user_id = session.user.id
      └─ ao INSERT de nova notificação → componente NotificationBell atualiza badge
          └─ usuário clica → marca as notificações como read = true
```
