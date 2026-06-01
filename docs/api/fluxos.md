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
Recebe o webhook da Riot Tournament API, persiste o resultado bruto, e aciona a ingestão completa (match_games, player_stats, bracket advance).

### Arquivos participantes
| Arquivo | Responsabilidade |
|---|---|
| `app/api/tournament/callback/route.ts` | Recebe POST da Riot, valida HMAC, insere `tournament_match_results` |
| `app/api/internal/process-match/route.ts` | Endpoint interno chamado assincronamente |
| `lib/actions/ingest-match.ts` | `finalizeMatchIngestion()` — lógica completa de ingestão |
| `lib/bracket-utils.ts` | `calcularPlacar()`, `avancarVencedor()` |
| `lib/riot.ts` | `getMatchById(matchId)` → match-v5 |

### Fluxo

```
Riot API
  │
  └─ POST /api/tournament/callback
         ├─ Valida X-Riot-Token (HMAC-SHA256)
         ├─ INSERT tournament_match_results { tournament_code, game_id, game_data }
         └─ Fire-and-forget → POST /api/internal/process-match
                │
                └─ finalizeMatchIngestion(tournamentCode, gameId)
                       ├─ Busca tournament_match_results (verifica !processed)
                       ├─ GET match-v5: americas/match/v5/matches/{BR1_gameId}
                       ├─ Resolve localMatchId via matches.tournament_code
                       ├─ Resolve game_number via matches.tournament_codes[] JSONB
                       ├─ INSERT match_games { match_id, game_number, riot_game_id, duration_sec }
                       ├─ Para cada participant:
                       │     ├─ resolve riot_accounts via puuid
                       │     ├─ resolve players via riot_account_id
                       │     ├─ resolve team_id via team_members (status=accepted)
                       │     └─ INSERT player_stats { kills, deaths, assists, gold, cs, ... }
                       ├─ UPDATE match_games.winner_id (por win=true)
                       ├─ calcularPlacar(matchId, teamAId, teamBId) → scoreA, scoreB
                       ├─ Se scoreX >= ceil(bestOf/2):
                       │     ├─ UPDATE matches { status=FINISHED, winner_id, score_a, score_b }
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
               └─ INSERT rank_snapshots {
                     player_id, tier, rank, lp, wins, losses,
                     snapshotted_at = now()
                   }
```

### Tabelas / Enums usados
- `riot_accounts` — `puuid`, `game_name`, `tag_line`, `summoner_id`
- `players` — `current_rank`, `current_tier`, `current_lp`
- `rank_snapshots` — snapshot temporal de rank/LP
- Enum `player_role`: TOP | JUNGLE | MID | ADC | SUPPORT

---

## 4. Inscrição de Time em Torneio

### O que faz
Permite que um capitão inscreva seu time em um torneio aberto (status=OPEN), passando por validações de elegibilidade, e aguarda aprovação do organizador.

### Arquivos participantes
| Arquivo | Responsabilidade |
|---|---|
| `lib/actions/teams.ts` | `inscreverTime()` — Server Action principal |
| `lib/actions/tournaments.ts` | `aprovarInscricao()`, `rejeitarInscricao()` |
| `app/organizer/torneios/[id]/inscricoes/page.tsx` | UI de aprovação |

### Fluxo

```
Capitão do time
  │
  └─ inscreverTime(teamId, tournamentId)  [lib/actions/teams.ts]
         ├─ Valida: usuário é captain do time (team_members.role=captain, status=accepted)
         ├─ Valida: torneio.status = OPEN
         ├─ Valida: time tem entre 5 e 8 membros com status=accepted
         ├─ Valida: inscrição duplicada não existe
         ├─ INSERT inscricoes { team_id, tournament_id, status=PENDING }
         └─ INSERT notifications (para o organizador)

Organizador
  │
  ├─ aprovarInscricao(inscricaoId)  [lib/actions/tournaments.ts]
  │     ├─ Guard: is_organizer_or_admin(tournamentId)
  │     ├─ UPDATE inscricoes.status = APPROVED
  │     └─ INSERT notifications (para o capitão)
  │
  └─ rejeitarInscricao(inscricaoId, motivo)
        ├─ Guard: is_organizer_or_admin(tournamentId)
        ├─ UPDATE inscricoes.status = REJECTED
        └─ INSERT notifications (para o capitão)
```

### Tabelas / Enums usados
- `inscricoes` — `status`: PENDING | APPROVED | REJECTED
- `team_members` — `role`: captain | member | substitute; `status`: pending | accepted | rejected | left
- `tournaments` — `status`: OPEN (enum `tournament_status`)
- `notifications`

---

## 5. Geração de Chaveamento (Bracket)

### O que faz
O organizador aciona a geração do bracket. O sistema busca as inscrições aprovadas, gera as partidas e transita o torneio para IN_PROGRESS.

### Arquivos participantes
| Arquivo | Responsabilidade |
|---|---|
| `lib/actions/tournaments.ts` | `gerarChaveamento()` — Server Action |
| `supabase/functions/bracket-generator/index.ts` | Edge Function com algoritmo de geração |
| `lib/bracket-utils.ts` | `calcularPlacar()`, `avancarVencedor()` |

### Fluxo

```
Organizador
  │
  └─ gerarChaveamento(tournamentId)  [lib/actions/tournaments.ts]
         ├─ Guard: is_organizer_or_admin(tournamentId)
         ├─ Valida: torneio.status = OPEN
         ├─ Conta inscricoes APPROVED (mínimo 2)
         ├─ Invoca Edge Function bracket-generator via supabase.functions.invoke()
         │
         └─ supabase/functions/bracket-generator/index.ts
                ├─ SELECT inscricoes APPROVED → lista de teams
                ├─ Aplica seedings (tabela seedings se existir, senão aleatório)
                ├─ Gera tournament_stages (ROUND_ROBIN / SINGLE_ELIMINATION / etc.)
                ├─ INSERT matches[] {
                │     tournament_id, stage_id,
                │     team_a_id, team_b_id,
                │     round, match_number,
                │     status = SCHEDULED,
                │     best_of
                │   }
                ├─ Para cada match: gera tournament_codes via Riot Tournament API
                │     POST /lol/tournament/v5/codes?tournamentId={riot_tournament_id}
                │     → armazena em matches.tournament_codes (JSONB)
                └─ UPDATE tournaments.status = IN_PROGRESS
```

### Tabelas / Enums usados
- `tournament_stages` — `bracket_type`: SINGLE_ELIMINATION | DOUBLE_ELIMINATION | ROUND_ROBIN | SWISS
- `matches` — `status` (SCHEDULED), `tournament_codes` (JSONB), `best_of`
- `inscricoes` — filtra `status = APPROVED`
- `seedings` — ordem preferencial (opcional)
- `riot_tournament_registrations` — `riot_tournament_id` para geração de codes
- Enum `tournament_status`: OPEN → IN_PROGRESS

---

## 6. Convite de Membro de Time

### O que faz
O capitão convida um usuário para o time. O convidado aceita ou recusa via RPC. O time é limitado a 8 membros (5 titulares + subs).

### Arquivos participantes
| Arquivo | Responsabilidade |
|---|---|
| `lib/actions/teams.ts` | `convidarMembro()`, `responderConvite()` |
| Supabase RPC | `accept_team_invite(invite_id)` — atômica |
| `supabase/functions/send-email/index.ts` | Notificação por e-mail (opcional) |

### Fluxo

```
Capitão
  │
  └─ convidarMembro(teamId, profileId)  [lib/actions/teams.ts]
         ├─ Guard: usuário é captain (team_members.role=captain, status=accepted)
         ├─ Valida: time tem < 8 membros com status=accepted
         ├─ Valida: profileId não é membro ativo
         ├─ INSERT team_invites {
         │     team_id,
         │     invited_profile_id,   ← campo real (não invited_user_id)
         │     invited_by,
         │     status = PENDING,
         │     expires_at = now() + 7 days
         │   }
         └─ INSERT notifications (para o convidado)

Convidado
  │
  ├─ responderConvite(inviteId, 'ACCEPTED')
  │     ├─ Valida: invite.status = PENDING e not expired
  │     ├─ RPC accept_team_invite(inviteId) ← atômica
  │     │     ├─ UPDATE team_invites.status = ACCEPTED
  │     │     └─ INSERT team_members { role=member, status=accepted }
  │     └─ INSERT notifications (para o capitão)
  │
  └─ responderConvite(inviteId, 'DECLINED')
        ├─ UPDATE team_invites.status = DECLINED
        └─ INSERT notifications (para o capitão)
```

### Tabelas / Enums usados
- `team_invites` — `invited_profile_id`, `status`: PENDING | ACCEPTED | DECLINED | EXPIRED
- `team_members` — `role`: captain | member | substitute; `status`: pending | accepted | rejected | left
- RPC `accept_team_invite`

---

## 7. Check-in de Partida (Spectator)

### O que faz
Antes do início de uma partida agendada, verifica via spectator-v5 se a partida já começou na plataforma Riot, atualizando o status para IN_PROGRESS e registrando dados de espectador.

### Arquivos participantes
| Arquivo | Responsabilidade |
|---|---|
| `lib/riot.ts` | `getActiveGame(puuid)` → spectator-v5 |
| `lib/actions/matches.ts` | `checkInPartida(matchId)` — Server Action |

### Fluxo

```
Organizador / Cron
  │
  └─ checkInPartida(matchId)  [lib/actions/matches.ts]
         ├─ Guard: is_organizer_or_admin(tournamentId)
         ├─ Valida: match.status = SCHEDULED
         ├─ Busca um participant (via team_members → riot_accounts → puuid)
         ├─ GET spectator-v5:
         │     /lol/spectator/v5/active-games/by-summoner/{encryptedPuuid}
         │
         ├─ Se jogo ativo encontrado:
         │     ├─ UPDATE matches.status = IN_PROGRESS
         │     └─ Armazena gameId em matches (para correlação futura)
         │
         └─ Se não encontrado:
               └─ Retorna { success: false, error: 'Partida ainda não iniciada na plataforma' }
```

### Tabelas / Enums usados
- `matches` — `status`: SCHEDULED → IN_PROGRESS (enum `match_status`)
- `team_members` — resolve participants para busca do puuid
- `riot_accounts` — `puuid` para chamada spectator-v5
