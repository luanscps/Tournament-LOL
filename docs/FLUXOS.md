# Fluxos de Negócio — GerenciadorDeTorneios-BRLOL

> **Fonte de verdade:** [`BRLOL-DOCS-UNIFICADO.md`](./BRLOL-DOCS-UNIFICADO.md) — seções 6, 7 e 9.
> Em caso de divergência, o código em `lib/actions/` e `app/api/` prevalece.

---

## 1. Cadastro e Login

```
Usuário acessa /login
  → Supabase Auth (email/password ou OAuth)
  → Callback em app/api/auth/callback
  → Criação automática de registro em `profiles` (trigger no banco)
  → Redirect para /dashboard
```

- Proteção via `middleware.ts` (Edge Runtime): rotas `/dashboard`, `/admin`, `/torneios/inscrever`.
- Verificação de `is_admin` feita no `layout.tsx` de `/admin` (Server Component), **não no middleware**.

---

## 2. Vinculação de Conta Riot

```
Usuário informa Riot ID (Nome#TAG) em /profile
  → Server Action em lib/actions/usuario.ts
  → getAccountByRiotId(gameName, tagLine) → puuid  [lib/riot.ts]
  → getSummonerByPuuid(puuid) → summonerId, iconId, level
  → getLeagueEntriesByPuuid(puuid) → tier, rank, LP
  → Upsert em `riot_accounts` + `rank_snapshots`
  → revalidatePath('/profile')
```

---

## 3. Criação de Time

```
Usuário cria time em /times/criar
  → Server Action em lib/actions/roster.ts
  → Zod valida dados (lib/validations/index.ts)
  → INSERT em `teams` (organizer_id = user.id)
  → INSERT em `team_members` (role = 'captain', status = 'accepted')
  → INSERT em `active_team` (vincula time ao usuário)
  → revalidatePath('/times')
```

---

## 4. Inscrição em Torneio

```
Capitão acessa /torneios/[slug] e clica em "Inscrever"
  → Verificação: torneio com status OPEN + vagas disponíveis
  → Server Action em lib/actions/inscricao.ts
  → INSERT em `inscricoes` (status = PENDING)
  → Organizador aprova/rejeita em /organizador/torneios/[id]/inscricoes
    → UPDATE `inscricoes` (status → APPROVED | REJECTED)
```

> ⚠️ A rota do painel do organizador é `/organizador/` (PT-BR) — **não** `/organizer/`.

---

## 5. Geração de Chave (Bracket)

```
Organizador em /organizador/torneios/[id]/fases
  → Cria tournament_stages (bracket_type: SINGLE_ELIMINATION | DOUBLE_ELIMINATION | ROUND_ROBIN | SWISS)
  → Server Action em lib/actions/fase.ts
  → Gera matches automaticamente com base nas inscrições aprovadas + seedings
  → INSERT em `matches` (status = SCHEDULED)
  → INSERT em `seedings` (posição inicial de cada time)
```

---

## 6. Registro de Resultado de Partida

```
Organizador / Riot callback registra resultado
  → Via Server Action lib/actions/partida.ts  OU
  → Via callback Riot Tournament API → app/api/internal/riot-callback
      (tournament_code recebido → lookup em matches.tournament_codes)
  → INSERT em `match_games` (vencedor, duração)
  → INSERT em `player_stats` (KDA, CS, dano, visão, MVP)
  → Se série completa: UPDATE `matches` (status = FINISHED, winner_team_id)
  → revalidatePath('/torneios/[slug]')
```

### Fluxo de ingestão de dados da Riot API

```
lib/actions/ingest-match.ts
  → Recebe matchId (formato BR1_XXXXXXXX)
  → getMatchById(matchId) via lib/riot.ts
  → Mapeia participants → player_stats
  → Rate limit via lib/riot-rate-limiter.ts
  → Upsert em match_games + player_stats
```

---

## 7. Leaderboards e Estatísticas

```
/ranking                  → v_player_leaderboard (view Supabase)
/torneios/[slug]/stats    → v_player_tournament_kda + v_stage_standings
Recharts consome os dados via Server Component → props para Client Component
```

---

## 8. Sincronização Automática (Cron)

```
Vercel Cron (vercel.json) → /api/cron/check-riot-status
  → Autenticado via header CRON_SECRET
  → Consulta Status-V4 da Riot API
  → Atualiza rank_snapshots de jogadores ativos
  → rate-limit via lib/riot-rate-limiter.ts
```

---

## 9. Integração Riot Tournament API

```
Organizador ativa integração Riot em /organizador/torneios/[id]/configuracoes
  → lib/riot-tournament.ts registra torneio na Riot
  → INSERT em riot_tournament_registrations (riot_provider_id, riot_tournament_id)
  → Gera tournament_codes por partida → stored em matches.tournament_codes (JSONB)
  → Riot envia callback POST → app/api/internal/riot-callback
  → tournament_code resolvido → match_game inserido automaticamente
```

---

## Resumo de Server Actions

| Arquivo | Responsabilidade |
|---|---|
| `lib/actions/usuario.ts` | Perfil, vinculação Riot ID |
| `lib/actions/roster.ts` | CRUD de times, membros, convites |
| `lib/actions/team_invite.ts` | Enviar/aceitar/recusar convites |
| `lib/actions/inscricao.ts` | Inscrição de times em torneios |
| `lib/actions/tournament.ts` | CRUD de torneios |
| `lib/actions/fase.ts` | Criação e gestão de fases |
| `lib/actions/partida.ts` | CRUD e resultado de partidas |
| `lib/actions/ingest-match.ts` | Ingestão de dados Riot API → banco |

> Para exemplos de código e padrões de implementação, consulte
> **[`BRLOL-DOCS-UNIFICADO.md`](./BRLOL-DOCS-UNIFICADO.md)** — seções 7 e 9.
