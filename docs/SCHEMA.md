# Schema Real do Banco — GerenciadorDeTorneios-BRLOL

> **Fonte:** Supabase projeto `awbieglbwhfavxlghuvy` — gerado direto do banco via `information_schema` e `pg_enum`.  
> **Regra:** Este arquivo é a fonte da verdade. Não seguir README, .txt ou .sql antigos.

---

## Enums (valores reais)

| Enum | Valores |
|---|---|
| `bracket_type` | `SINGLE_ELIMINATION` \| `DOUBLE_ELIMINATION` \| `ROUND_ROBIN` \| `SWISS` |
| `dispute_status` | `OPEN` \| `UNDER_REVIEW` \| `RESOLVED` \| `DISMISSED` |
| `inscricao_status` | `PENDING` \| `APPROVED` \| `REJECTED` |
| `invite_status` | `PENDING` \| `ACCEPTED` \| `DECLINED` \| `EXPIRED` |
| `match_status` | `SCHEDULED` \| `IN_PROGRESS` \| `FINISHED` \| `CANCELLED` \| `WALKOVER` |
| `player_role` | `TOP` \| `JUNGLE` \| `MID` \| `ADC` \| `SUPPORT` |
| `team_member_role` | `captain` \| `member` \| `substitute` |
| `team_member_status` | `pending` \| `accepted` \| `rejected` \| `left` |
| `tournament_status` | `DRAFT` \| `OPEN` \| `IN_PROGRESS` \| `FINISHED` \| `CANCELLED` |
| `user_role` | `player` \| `organizer` \| `admin` |

---

## Tabelas

### `profiles`
Espelha `auth.users`. Um registro por usuário autenticado.

| Coluna | Tipo | Nullable | Default |
|---|---|---|---|
| `id` | uuid | NO | `auth.uid()` |
| `email` | text | YES | — |
| `username` | text | YES | — |
| `display_name` | text | YES | — |
| `avatar_url` | text | YES | — |
| `role` | `user_role` | YES | `'player'` |
| `is_admin` | bool | YES | `false` |
| `is_banned` | bool | YES | `false` |
| `riot_game_name` | text | YES | — |
| `riot_tag_line` | text | YES | — |
| `created_at` | timestamptz | YES | `now()` |
| `updated_at` | timestamptz | YES | `now()` |

---

### `riot_accounts`
Contas Riot vinculadas a um perfil (uma pode ser primária).

| Coluna | Tipo | Nullable | Default |
|---|---|---|---|
| `id` | uuid | NO | `gen_random_uuid()` |
| `profile_id` | uuid | YES | — → FK `profiles.id` |
| `puuid` | text | YES | — |
| `game_name` | text | YES | — |
| `tag_line` | text | YES | — |
| `summoner_id` | text | YES | — |
| `account_id` | text | YES | — |
| `is_primary` | bool | YES | `false` |
| `is_locked` | bool | YES | `false` |
| `locked_by` | uuid | YES | — → FK `profiles.id` |
| `locked_at` | timestamptz | YES | — |
| `region` | text | YES | — |
| `created_at` | timestamptz | YES | `now()` |
| `updated_at` | timestamptz | YES | `now()` |

---

### `riot_account_lock_logs`
Auditoria de bloqueio/desbloqueio de contas Riot.

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `riot_account_id` | uuid | YES → FK `riot_accounts.id` |
| `changed_by` | uuid | YES → FK `profiles.id` |
| `action` | text | YES |
| `reason` | text | YES |
| `created_at` | timestamptz | YES |

---

### `players`
Dados de jogador sincronizados via Riot API (summoner + rank snapshot atual).

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `riot_account_id` | uuid | YES → FK `riot_accounts.id` |
| `summoner_name` | text | YES |
| `tag_line` | text | YES |
| `summoner_level` | int4 | YES |
| `profile_icon_id` | int4 | YES |
| `tier` | text | YES |
| `rank` | text | YES |
| `lp` | int4 | YES |
| `wins` | int4 | YES |
| `losses` | int4 | YES |
| `role` | text | YES |
| `profile_id` | uuid | YES |
| `created_at` | timestamptz | YES |
| `updated_at` | timestamptz | YES |

---

### `rank_snapshots`
Histórico de tier/rank/LP por conta Riot ao longo do tempo.

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `riot_account_id` | uuid | YES → FK `riot_accounts.id` |
| `queue_type` | text | YES |
| `tier` | text | YES |
| `rank` | text | YES |
| `lp` | int4 | YES |
| `wins` | int4 | YES |
| `losses` | int4 | YES |
| `captured_at` | timestamptz | YES |

---

### `champion_masteries`
Maestrias de campeões sincronizadas da Riot API.

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `riot_account_id` | uuid | YES → FK `riot_accounts.id` |
| `champion_id` | int4 | YES |
| `champion_name` | text | YES |
| `mastery_level` | int4 | YES |
| `mastery_points` | int8 | YES |
| `last_play_time` | timestamptz | YES |
| `created_at` | timestamptz | YES |
| `updated_at` | timestamptz | YES |

---

### `teams`
Times cadastrados na plataforma.

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `name` | text | NO |
| `tag` | text | NO |
| `logo_url` | text | YES |
| `banner_url` | text | YES |
| `owner_id` | uuid | YES → FK `profiles.id` |
| `tournament_id` | uuid | YES → FK `tournaments.id` |
| `region` | text | YES |
| `is_active` | bool | YES |
| `is_eliminated` | bool | YES |
| `created_at` | timestamptz | YES |
| `updated_at` | timestamptz | YES |

---

### `team_members`
Relacionamento jogador ↔ time com papel e status.

| Coluna | Tipo / Enum | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `team_id` | uuid | YES → FK `teams.id` |
| `profile_id` | uuid | YES → FK `profiles.id` |
| `riot_account_id` | uuid | YES → FK `riot_accounts.id` |
| `team_role` | `team_member_role` (`captain`\|`member`\|`substitute`) | YES |
| `lane` | `player_role` (`TOP`\|`JUNGLE`\|`MID`\|`ADC`\|`SUPPORT`) | YES |
| `status` | `team_member_status` (`pending`\|`accepted`\|`rejected`\|`left`) | YES |
| `invited_by` | uuid | YES → FK `profiles.id` |
| `invited_at` | timestamptz | YES |
| `responded_at` | timestamptz | YES |
| `created_at` | timestamptz | YES |

---

### `team_invites`
Convites enviados para jogadores entrarem em times.

| Coluna | Tipo / Enum | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `team_id` | uuid | YES → FK `teams.id` |
| `invited_by` | uuid | YES → FK `profiles.id` |
| `invited_profile_id` | uuid | YES → FK `profiles.id` |
| `summoner_name` | text | YES |
| `tag_line` | text | YES |
| `role` | `team_member_role` | YES |
| `is_reserve` | bool | YES |
| `status` | `invite_status` (`PENDING`\|`ACCEPTED`\|`DECLINED`\|`EXPIRED`) | YES |
| `expires_at` | timestamptz | YES |
| `created_at` | timestamptz | YES |

---

### `active_team`
Define qual time está "ativo" para um dado perfil.

| Coluna | Tipo | Nullable |
|---|---|---|
| `profile_id` | uuid | NO → FK `profiles.id` |
| `team_id` | uuid | YES → FK `teams.id` |
| `updated_at` | timestamptz | YES |

---

### `tournaments`
Torneios cadastrados na plataforma.

| Coluna | Tipo / Enum | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `name` | text | NO |
| `slug` | text | YES |
| `description` | text | YES |
| `status` | `tournament_status` (`DRAFT`\|`OPEN`\|`IN_PROGRESS`\|`FINISHED`\|`CANCELLED`) | YES |
| `bracket_type` | `bracket_type` | YES |
| `max_teams` | int4 | YES |
| `min_members` | int4 | YES |
| `max_members` | int4 | YES |
| `min_tier` | text | YES |
| `start_date` | timestamptz | YES |
| `end_date` | timestamptz | YES |
| `rules` | text | YES |
| `prize_pool` | text | YES |
| `banner_url` | text | YES |
| `is_featured` | bool | YES |
| `discord_webhook` | text | YES |
| `organizer_id` | uuid | YES → FK `profiles.id` |
| `created_by` | uuid | YES → FK `profiles.id` |
| `created_at` | timestamptz | YES |
| `updated_at` | timestamptz | YES |

---

### `tournament_rules`
Seções de regras detalhadas por torneio.

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `tournament_id` | uuid | YES → FK `tournaments.id` |
| `section` | text | YES |
| `content` | text | YES |
| `order` | int4 | YES |
| `created_at` | timestamptz | YES |

---

### `tournament_stages`
Fases de um torneio (grupos, quartas, semifinais, etc.).

| Coluna | Tipo / Enum | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `tournament_id` | uuid | YES → FK `tournaments.id` |
| `name` | text | YES |
| `stage_order` | int4 | YES |
| `bracket_type` | `bracket_type` | YES |
| `best_of` | int4 | YES |
| `is_current` | bool | YES |
| `created_at` | timestamptz | YES |

---

### `seedings`
Seed numérico de cada time por torneio.

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `tournament_id` | uuid | YES → FK `tournaments.id` |
| `team_id` | uuid | YES → FK `teams.id` |
| `seed` | int4 | YES |
| `method` | text | YES | `-- MANUAL | RANKING | RANDOM` |
| `created_at` | timestamptz | YES |

---

### `inscricoes`
Inscrições de times em torneios.

| Coluna | Tipo / Enum | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `tournament_id` | uuid | YES → FK `tournaments.id` |
| `team_id` | uuid | YES → FK `teams.id` |
| `status` | `inscricao_status` (`PENDING`\|`APPROVED`\|`REJECTED`) | YES |
| `requested_by` | uuid | YES → FK `profiles.id` |
| `reviewed_by` | uuid | YES → FK `profiles.id` |
| `checked_in` | bool | YES |
| `checked_in_at` | timestamptz | YES |
| `checked_in_by` | uuid | YES |
| `created_at` | timestamptz | YES |
| `updated_at` | timestamptz | YES |

---

### `matches`
Séries (BO1/3/5) dentro de uma fase do torneio.

| Coluna | Tipo / Enum | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `tournament_id` | uuid | YES → FK `tournaments.id` |
| `stage_id` | uuid | YES → FK `tournament_stages.id` |
| `team_a_id` | uuid | YES → FK `teams.id` |
| `team_b_id` | uuid | YES → FK `teams.id` |
| `winner_id` | uuid | YES → FK `teams.id` |
| `status` | `match_status` (`SCHEDULED`\|`IN_PROGRESS`\|`FINISHED`\|`CANCELLED`\|`WALKOVER`) | YES |
| `best_of` | int4 | YES |
| `round` | int4 | YES |
| `match_number` | int4 | YES |
| `score_a` | int4 | YES |
| `score_b` | int4 | YES |
| `scheduled_at` | timestamptz | YES |
| `started_at` | timestamptz | YES |
| `finished_at` | timestamptz | YES |
| `tournament_code` | text | YES |
| `created_at` | timestamptz | YES |

---

### `match_games`
Jogos individuais dentro de uma série (cada game de um BO3, por ex.).

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `match_id` | uuid | YES → FK `matches.id` |
| `game_number` | int4 | YES |
| `winner_id` | uuid | YES → FK `teams.id` |
| `riot_game_id` | text | YES |
| `duration` | int4 | YES |
| `played_at` | timestamptz | YES |
| `created_at` | timestamptz | YES |

---

### `tournament_match_results`
Payload bruto JSON retornado pela Riot Tournament API após cada jogo.

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `match_id` | uuid | YES → FK `matches.id` |
| `tournament_code` | text | YES |
| `riot_match_id` | text | YES |
| `game_data` | jsonb | YES |
| `processed` | bool | YES |
| `created_at` | timestamptz | YES |

---

### `player_stats`
Estatísticas de um jogador por game individual.

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `game_id` | uuid | YES → FK `match_games.id` |
| `player_id` | uuid | YES → FK `players.id` |
| `riot_account_id` | uuid | YES → FK `riot_accounts.id` |
| `team_id` | uuid | YES → FK `teams.id` |
| `kills` | int4 | YES |
| `deaths` | int4 | YES |
| `assists` | int4 | YES |
| `cs` | int4 | YES |
| `damage` | int4 | YES |
| `vision_score` | int4 | YES |
| `gold` | int4 | YES |
| `wards_placed` | int4 | YES |
| `win` | bool | YES |
| `role` | text | YES |
| `champion_id` | int4 | YES |
| `champion_name` | text | YES |
| `is_mvp` | bool | YES |
| `created_at` | timestamptz | YES |

---

### `disputes`
Disputas de resultado abertas por capitão, resolvidas por organizador/admin.

| Coluna | Tipo / Enum | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `match_id` | uuid | YES → FK `matches.id` |
| `reported_by` | uuid | YES → FK `profiles.id` |
| `resolved_by` | uuid | YES → FK `profiles.id` |
| `status` | `dispute_status` (`OPEN`\|`UNDER_REVIEW`\|`RESOLVED`\|`DISMISSED`) | YES |
| `reason` | text | YES |
| `evidence_url` | text | YES |
| `resolution_notes` | text | YES |
| `resolved_at` | timestamptz | YES |
| `created_at` | timestamptz | YES |

> **Atenção:** a FK real em `disputes` usa `reported_by` (não `opened_by`).  
> Os actions `disputa.ts` precisam usar `reported_by` ao inserir.

---

### `prize_distribution`
Distribuição de prêmios por colocação.

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `tournament_id` | uuid | YES → FK `tournaments.id` |
| `placement` | int4 | YES |
| `description` | text | YES |
| `created_at` | timestamptz | YES |

---

### `notifications`
Notificações por usuário, protegidas por RLS.

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `user_id` | uuid | YES → FK `profiles.id` |
| `title` | text | YES |
| `body` | text | YES |
| `link` | text | YES |
| `metadata` | jsonb | YES |
| `read` | bool | YES |
| `created_at` | timestamptz | YES |

---

### `site_terms_acceptance`
Registro de aceite dos termos da plataforma.

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `profile_id` | uuid | YES → FK `profiles.id` |
| `accepted_at` | timestamptz | YES |
| `ip_address` | text | YES |
| `user_agent` | text | YES |

---

### `riot_tournament_registrations`
Registros de provider/tournament criados na Riot Tournament API v5.

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `tournament_id` | uuid | YES → FK `tournaments.id` |
| `created_by` | uuid | YES → FK `profiles.id` |
| `riot_provider_id` | int4 | YES |
| `riot_tournament_id` | int4 | YES |
| `region` | text | YES |
| `callback_url` | text | YES |
| `created_at` | timestamptz | YES |

---

### `tournament_announcements` \_(nova)_
Comunicados do organizador para os times do torneio.

| Coluna | Tipo | Nullable |
|---|---|---|
| `id` | uuid | NO |
| `tournament_id` | uuid | NO → FK `tournaments.id` |
| `sent_by` | uuid | YES → FK `profiles.id` |
| `title` | text | NO | `5“150 chars` |
| `body` | text | NO | `10–2000 chars` |
| `channel` | text[] | NO | `default '{email}'` |
| `target` | text | NO | `'all'\|'active'\|'eliminated'` |
| `sent_at` | timestamptz | NO | `now()` |
| `created_at` | timestamptz | NO | `now()` |

---

## Mapa de Foreign Keys

| Tabela | Coluna | Referencia |
|---|---|---|
| `active_team` | `profile_id` | `profiles.id` |
| `active_team` | `team_id` | `teams.id` |
| `champion_masteries` | `riot_account_id` | `riot_accounts.id` |
| `disputes` | `match_id` | `matches.id` |
| `disputes` | `reported_by` | `profiles.id` |
| `disputes` | `resolved_by` | `profiles.id` |
| `inscricoes` | `requested_by` | `profiles.id` |
| `inscricoes` | `reviewed_by` | `profiles.id` |
| `inscricoes` | `team_id` | `teams.id` |
| `inscricoes` | `tournament_id` | `tournaments.id` |
| `match_games` | `match_id` | `matches.id` |
| `match_games` | `winner_id` | `teams.id` |
| `matches` | `stage_id` | `tournament_stages.id` |
| `matches` | `team_a_id` | `teams.id` |
| `matches` | `team_b_id` | `teams.id` |
| `matches` | `tournament_id` | `tournaments.id` |
| `matches` | `winner_id` | `teams.id` |
| `notifications` | `user_id` | `profiles.id` |
| `player_stats` | `game_id` | `match_games.id` |
| `player_stats` | `player_id` | `players.id` |
| `player_stats` | `riot_account_id` | `riot_accounts.id` |
| `player_stats` | `team_id` | `teams.id` |
| `players` | `riot_account_id` | `riot_accounts.id` |
| `prize_distribution` | `tournament_id` | `tournaments.id` |
| `rank_snapshots` | `riot_account_id` | `riot_accounts.id` |
| `riot_account_lock_logs` | `changed_by` | `profiles.id` |
| `riot_account_lock_logs` | `riot_account_id` | `riot_accounts.id` |
| `riot_accounts` | `locked_by` | `profiles.id` |
| `riot_accounts` | `profile_id` | `profiles.id` |
| `riot_tournament_registrations` | `created_by` | `profiles.id` |
| `riot_tournament_registrations` | `tournament_id` | `tournaments.id` |
| `seedings` | `team_id` | `teams.id` |
| `seedings` | `tournament_id` | `tournaments.id` |
| `site_terms_acceptance` | `profile_id` | `profiles.id` |
| `team_invites` | `invited_by` | `profiles.id` |
| `team_invites` | `invited_profile_id` | `profiles.id` |
| `team_invites` | `team_id` | `teams.id` |
| `team_members` | `invited_by` | `profiles.id` |
| `team_members` | `profile_id` | `profiles.id` |
| `team_members` | `riot_account_id` | `riot_accounts.id` |
| `team_members` | `team_id` | `teams.id` |
| `teams` | `owner_id` | `profiles.id` |
| `teams` | `tournament_id` | `tournaments.id` |
| `tournament_announcements` | `sent_by` | `profiles.id` |
| `tournament_announcements` | `tournament_id` | `tournaments.id` |
| `tournament_match_results` | `match_id` | `matches.id` |
| `tournament_rules` | `tournament_id` | `tournaments.id` |
| `tournament_stages` | `tournament_id` | `tournaments.id` |
| `tournaments` | `created_by` | `profiles.id` |
| `tournaments` | `organizer_id` | `profiles.id` |

---

## Bug conhecido nos actions commitados

Ao gerar o schema real, foi identificado que `disputes` usa `reported_by` como FK (não `opened_by`).  
O arquivo `lib/actions/disputa.ts` usa `opened_by` no INSERT — isso precisa ser corrigido no próximo commit.

```ts
// ERRADO (atual em disputa.ts)
opened_by: profile.id

// CORRETO (conforme FK real do banco)
reported_by: profile.id
```
