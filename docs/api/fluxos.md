# Fluxos do Sistema — ArenaGG (GerenciadorDeTorneios-BRLOL)

> **Fonte de verdade:** código-fonte. Este documento reflete os arquivos em `lib/actions/`, `app/api/`, `supabase/functions/` e `lib/database.types.ts`.
> Última revisão: 2026-06-01

---

## Índice

1. [Autenticação (Discord OAuth)](#1-autenticação-discord-oauth)
2. [Resultado de Partida (Riot Callback)](#2-resultado-de-partida-riot-callback)
3. [Sincronização de Rank (Edge Function)](#3-sincronização-de-rank-edge-function)
4. [Inscrição de Time em Torneio](#4-inscrição-de-time-em-torneio)
5. [Geração de Chaveamento (Bracket)](#5-geração-de-chaveamento-bracket)
6. [Convite de Membro de Time](#6-convite-de-membro-de-time)
7. [Check-in de Partida (Spectator)](#7-check-in-de-partida-spectator)

---

## 1. Autenticação (Discord OAuth)

### O que faz
Autentica o usuário via Discord OAuth2 usando Supabase Auth, criando o registro em `profiles` caso ainda não exista.

### Arquivos participantes
| Arquivo | Responsabilidade |
|---|---|
| `middleware.ts` | Refresh de sessão SSR em toda requisição |
| `app/api/auth/callback/route.ts` | Troca code → session, upsert em `profiles` |
| `lib/supabase/server.ts` | `createServerClient` com cookies |
| `lib/supabase/middleware.ts` | `createServerClient` para middleware |

### Fluxo

```
Browser
  │
  ├─ GET /auth/discord
  │      └─ Supabase redireciona → Discord OAuth
  │
  ├─ Discord callback → GET /api/auth/callback?code=xxx
  │      ├─ supabase.auth.exchangeCodeForSession(code)
  │      ├─ upsert profiles { id, email, display_name, avatar_url }
  │      └─ redirect → /dashboard (ou returnTo)
  │
  └─ Toda requisição SSR passa pelo middleware
         └─ supabase.auth.getUser() → renova session se necessário
```

### Tabelas / Enums usados
- `profiles` — `id` (uuid = auth.users.id), `display_name`, `avatar_url`, `is_admin`

---

## 2. Resultado de Partida (Riot Callback)

### O que faz
Recebe o webhook da Riot Tournament API, persiste o resultado bruto, e aciona o pipeline de ingestão completo (5 etapas) que grava `match_games`, `player_stats` e avança o chaveamento.

### Arquivos participantes
| Arquivo | Responsabilidade |
|---|---|
| `app/api/tournament/callback/route.ts` | Recebe POST da Riot, valida HMAC, insere `tournament_match_results` |
| `app/api/internal/process-match/route.ts` | Endpoint interno chamado assincronamente |
| `lib/actions/ingest-match.ts` | Pipeline de ingestão em 5 etapas sequenciais |
| `lib/bracket-utils.ts` | `calcularPlacar()`, `avancarVencedor()` |
| `lib/riot.ts` | `getMatchById(matchId)` → match-v5 |

### Fluxo

```
Riot API
  │
  └─ POST /api/tournament/callback
         ├─ Valida X-Riot-Token (HMAC-SHA256 com RIOT_HMAC_SECRET)
         ├─ INSERT tournament_match_results { tournament_code, game_id, game_data }
         └─ Fire-and-forget → POST /api/internal/process-match
                │
                └─ lib/actions/ingest-match.ts  (5 etapas sequenciais)
                │
                ├─ 1. processMatchResult(tournamentCode)
                │      → SELECT tournament_match_results WHERE tournament_code
                │      → Normaliza game_data (JSON do callback Riot)
                │
                ├─ 2. fetchAndResolveMatch(gameId, tournamentId)
                │      → GET match-v5: /lol/match/v5/matches/BR1_{gameId}
                │      → Resolve localMatchId via matches.tournament_codes @> [tournamentCode]
                │      → Determina game_number (count match_games existentes + 1)
                │
                ├─ 3. persistMatchGame(localMatchId, gameData, gameNumber)
                │      → INSERT match_games { match_id, game_number, game_data JSONB,
                │                            duration_sec, winner_team_id }
                │
                ├─ 4. persistPlayerStats(matchGameId, participants[])
                │      → Resolve profile_id via riot_accounts.puuid
                │      → INSERT player_stats (10 registros — 5v5)
                │        { kills, deaths, assists, gold_earned, cs, vision_score,
                │          damage_dealt, win, champion }
                │
                └─ 5. finalizeMatchIngestion(localMatchId, tournamentId)
                       → Conta match_games FINISHED para determinar vencedor do best_of
                       → calcularPlacar(matchId, teamAId, teamBId) → scoreA, scoreB
                       → Se scoreX >= ceil(bestOf/2):
                       │     ├─ UPDATE matches { status=FINISHED, winner_id,
                       │     │                   score_a, score_b, finished_at }
                       │     └─ avancarVencedor() → cria/preenche próxima partida
                       └─ UPDATE tournament_match_results.processed = true
```

### Tabelas / Enums usados
- `tournament_match_results` — `tournament_code`, `game_id`, `game_data` (JSONB), `processed`
- `matches` — `status` (SCHEDULED→IN_PROGRESS→FINISHED), `winner_id`, `score_a`, `score_b`, `tournament_codes` (JSONB)
- `match_games` — `game_number`, `riot_game_id`, `duration_sec`, `winner_id`
- `player_stats` — `kills`, `deaths`, `assists`, `gold_earned`, `cs`, `vision_score`, `damage_dealt`, `win`, `champion`
- `team_members` — `status` = `accepted`

---

## 3. Sincronização de Rank (Edge Function)

### O que faz
Busca dados atualizados de rank/LP na Riot API para todos os players com `riot_account_id` e atualiza `players` e `rank_snapshots`.

### Arquivos participantes
| Arquivo | Responsabilidade |
|---|---|
| `supabase/functions/riot-api-sync/index.ts` | Edge Function orquestradora |
| `lib/riot.ts` | Wrappers tipados para account-v1, summoner-v4, league-v4 |
| `lib/riot-rate-limiter.ts` | Fila com delay entre chamadas (respeita 20req/1s, 100req/2min) |

### Fluxo

```
Cron (ou chamada manual)
  │
  └─ supabase/functions/riot-api-sync
         ├─ SELECT players JOIN riot_accounts WHERE riot_account_id IS NOT NULL
         │
         └─ Para cada player:
               ├─ GET account-v1: /riot/account/v1/accounts/by-puuid/{puuid}
               ├─ GET summoner-v4: /lol/summoner/v4/summoners/by-puuid/{puuid}
               ├─ GET league-v4:   /lol/league/v4/entries/by-summoner/{summonerId}
               │
               ├─ UPDATE players {
               │     current_rank, current_lp, current_tier,
               │     wins, losses, hot_streak, veteran, inactive
               │   }
               │
               └─ INSERT rank_snapshots por queue
                     ├─ RANKED_SOLO_5x5 (se existir na resposta)
                     ├─ RANKED_FLEX_SR  (se existir na resposta)
                     └─ campos: player_id, tier, rank, lp, wins, losses, snapshotted_at
```

### Tabelas / Enums usados
- `riot_accounts` — `puuid`, `game_name`, `tag_line`, `summoner_id`
- `players` — `current_rank`, `current_tier`, `current_lp`
- `rank_snapshots` — snapshot temporal de rank/LP (ambas as filas: SOLO e FLEX)
- Enum `player_role`: TOP | JUNGLE | MID | ADC | SUPPORT

---

## 4. Inscrição de Time em Torneio

### O que faz
Permite que um capitão inscreva seu time em um torneio aberto (status=OPEN), passando por validações de elegibilidade, e aguarda aprovação do organizador.

### Arquivos participantes
| Arquivo | Responsabilidade |
|---|---|
| `lib/actions/inscricao.ts` | `criarInscricao()` (alias `inscreverTime()`) — Server Action principal |
| `lib/actions/inscricao.ts` | `aprovarInscricao()`, `rejeitarInscricao()` — usam chave composta |
| `app/organizer/torneios/[id]/inscricoes/page.tsx` | UI de aprovação |

### Fluxo

```
Capitão do time
  │
  └─ criarInscricao(teamId, tournamentId)   [lib/actions/inscricao.ts]
     alias: inscreverTime(tournamentId, teamId)  ← atenção: ordem invertida no alias
         ├─ Guard: requireAuth()
         ├─ INSERT inscricoes { team_id, tournament_id, status='PENDING',
         │                     requested_by = profile.id }
         └─ revalidatePath('/dashboard'), revalidatePath('/torneios/${tournamentId}')

Organizador
  │
  ├─ aprovarInscricao(teamId, tournamentId)  [lib/actions/inscricao.ts]
  │     ← chave composta (teamId + tournamentId), NÃO um inscricaoId único
  │     ├─ Guard: requireTournamentOrganizerOrAdmin(tournamentId)
  │     └─ UPDATE inscricoes SET { status='APPROVED', reviewed_by, reviewed_at }
  │           WHERE team_id = teamId AND tournament_id = tournamentId
  │
  └─ rejeitarInscricao(teamId, tournamentId, notes)  [lib/actions/inscricao.ts]
        ← chave composta (teamId + tournamentId), NÃO um inscricaoId único
        ├─ Guard: requireTournamentOrganizerOrAdmin(tournamentId)
        └─ UPDATE inscricoes SET { status='REJECTED', reviewed_by, reviewed_at, notes }
```

### Tabelas / Enums usados
- `inscricoes` — `status`: PENDING | APPROVED | REJECTED
- `team_members` — `role`: captain | member | substitute; `status`: pending | accepted | rejected | left
- `tournaments` — `status`: OPEN (enum `tournament_status`)
- `notifications`

---

## 5. Geração de Chaveamento (Bracket)

### O que faz
O organizador aciona a geração do bracket. O sistema busca as inscrições aprovadas e gera as partidas **inline** (sem Edge Function). A transição de `tournament_status` para `IN_PROGRESS` **não é automática** — deve ser feita manualmente via `updateTournament`.

### Arquivos participantes
| Arquivo | Responsabilidade |
|---|---|
| `lib/actions/partida.ts` | `gerarChaveamento()` — geração inline, sem Edge Function |
| `lib/bracket-utils.ts` | `calcularPlacar()`, `avancarVencedor()` |

> ⚠️ **Não existe** invocação de Edge Function `bracket-generator` via `supabase.functions.invoke()`. A geração acontece inteiramente dentro da Server Action em `lib/actions/partida.ts`.

### Fluxo

```
Organizador
  │
  └─ gerarChaveamento(tournamentId, faseId?)  [lib/actions/partida.ts]
         ├─ Guard: requireTournamentOrganizerOrAdmin(tournamentId)
         ├─ Se faseId: lê best_of da fase em tournament_stages
         ├─ SELECT inscricoes WHERE tournament_id AND status='APPROVED'
         ├─ Valida: count >= 2
         ├─ Embaralha times (Math.random), calcula nextPow2 para eliminiação
         ├─ INSERT matches[] {
         │     tournament_id, stage_id (se faseId),
         │     team_a_id, team_b_id,
         │     round=1, match_number,
         │     status = 'SCHEDULED',
         │     best_of (da fase ou default=1)
         │   }
         ├─ revalidatePath: /partidas, /bracket, /torneios
         └─ Retorno: { success: true, data: Match[] }

  ← tournament_status NÃO é alterado aqui.
  ← Organizador deve manualmente: updateTournament(id, { status: 'IN_PROGRESS' })
```

### Tabelas / Enums usados
- `tournament_stages` — `bracket_type`: SINGLE_ELIMINATION | DOUBLE_ELIMINATION | ROUND_ROBIN | SWISS
- `matches` — `status` (SCHEDULED), `best_of`
- `inscricoes` — filtra `status = APPROVED`
- `seedings` — ordem preferencial (opcional, se existir)
- Enum `tournament_status`: OPEN → IN_PROGRESS (transição **manual**)

---

## 6. Convite de Membro de Time

### O que faz
O capitão convida um usuário para o time. O convidado aceita ou recusa. O time é limitado a 8 membros (5 titulares + subs).

### Arquivos participantes
| Arquivo | Responsabilidade |
|---|---|
| `lib/actions/team_invite.ts` | `convidarMembro()`, `responderConvite()`, `cancelarConvite()` |
| Supabase RPC | `accept_team_invite(invite_id)` — atômica (se usada) |
| `supabase/functions/send-email/index.ts` | Notificação por e-mail (opcional) |

### Fluxo

```
Capitão
  │
  └─ convidarMembro(teamId, profileId)  [lib/actions/team_invite.ts]
         ├─ Guard: owner_id = profile.id
         ├─ Valida: time tem < 8 membros com status=accepted
         ├─ Valida: profileId não é membro ativo
         ├─ INSERT team_invites {
         │     team_id,
         │     invited_profile_id,   ← campo real (não invited_user_id)
         │     invited_by,
         │     status = 'PENDING',
         │     expires_at = now() + 7 days
         │   }
         └─ INSERT notifications (para o convidado)

Convidado
  │
  ├─ responderConvite(inviteId, true)   → status = 'ACCEPTED'
  │     [lib/actions/team_invite.ts]
  │     ├─ Valida: invite.status = 'PENDING' e not expired
  │     ├─ UPDATE team_invites.status = 'ACCEPTED'
  │     ├─ INSERT team_members { role='member', status='accepted' }
  │     └─ INSERT notifications (para o capitão)
  │
  ├─ responderConvite(inviteId, false)  → status = 'DECLINED'
  │     ├─ UPDATE team_invites.status = 'DECLINED'
  │     └─ INSERT notifications (para o capitão)
  │
  └─ (capitão pode cancelar convite pendente)
        cancelarConvite(inviteId)
        └─ UPDATE team_invites.status = 'DECLINED' (ou DELETE)
```

### Tabelas / Enums usados
- `team_invites` — `invited_profile_id`, `status`: PENDING | ACCEPTED | DECLINED | EXPIRED
- `team_members` — `role`: captain | member | substitute; `status`: pending | accepted | rejected | left

---

## 7. Check-in de Partida (Spectator)

### O que faz
Antes do início de uma partida, o organizador confirma via spectator-v5 que os jogadores estão em jogo na plataforma Riot. Há **dupla barreira**: verificação no cliente (UX) e re-verificação no servidor (fonte de verdade).

### Arquivos participantes
| Arquivo | Responsabilidade |
|---|---|
| `lib/actions/inscricao.ts` | `fazerCheckinOrganizador(inscricaoId)` — Server Action real |
| `components/checkin-client.tsx` | Verificação prévia no cliente via spectator-v5 (UX) |
| `lib/riot.ts` | `getActiveGame(puuid)` → spectator-v5 |

> ⚠️ A action se chama `fazerCheckinOrganizador(inscricaoId)` e está em `lib/actions/inscricao.ts`, **não** `checkInPartida(matchId)` em `lib/actions/matches.ts`.

### Fluxo

```
Organizador
  │
  └─ fazerCheckinOrganizador(inscricaoId)  [lib/actions/inscricao.ts]
         ├─ Guard: requireAuth() + requireTournamentOrganizerOrAdmin(tournament_id)
         ├─ Valida: inscricao.status = 'APPROVED'
         │
         ├─ DUPLA BARREIRA:
         │     Camada 1 (cliente — checkin-client.tsx):
         │       → Verifica spectator-v5 antes de chamar a action (feedback UX)
         │
         │     Camada 2 (servidor — fonte de verdade):
         │       → Promise.allSettled: GET spectator-v5 para cada membro
         │         /lol/spectator/v5/active-games/by-summoner/{puuid}
         │       → Se qualquer membro inGame: retorna erro
         │       → Se Riot API offline: não penaliza (considera válido)
         │
         ├─ UPDATE inscricoes SET {
         │     checked_in = true,
         │     checked_in_at = now(),
         │     checked_in_by = profile.id
         │   }
         └─ Retorno: { success: true } | { error: string }
```

### Tabelas / Enums usados
- `inscricoes` — `checked_in`, `checked_in_at`, `checked_in_by`
- `team_members` — resolve participantes para busca do puuid
- `riot_accounts` — `puuid` para chamada spectator-v5
