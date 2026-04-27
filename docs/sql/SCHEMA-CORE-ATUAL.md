# Schema core atual — Supabase (schema `public`)

> Fonte: dump `sql/2026-04-25_122855.sql` + migrations até `020_team_roster.sql`.
> Para visão funcional e de negócio do modelo, consulte [`../BRLOL-DOCS-UNIFICADO.md`](../BRLOL-DOCS-UNIFICADO.md).

---

## Legenda de RLS

| Símbolo | Significado |
|---|---|
| 🟢 | RLS ativado — policies de domínio aplicadas |
| 🟡 | RLS ativado — acesso restrito a admins (`is_admin`) |
| ⚪ | Tabela de infra/suporte sem RLS de domínio (acesso via função ou service role) |

---

## Enums

```sql
CREATE TYPE tournament_status  AS ENUM ('DRAFT','OPEN','IN_PROGRESS','FINISHED','CANCELLED');
CREATE TYPE bracket_type       AS ENUM ('SINGLE_ELIMINATION','DOUBLE_ELIMINATION','ROUND_ROBIN','SWISS');
CREATE TYPE match_status       AS ENUM ('SCHEDULED','IN_PROGRESS','FINISHED');
CREATE TYPE inscricao_status   AS ENUM ('PENDING','APPROVED','REJECTED');
CREATE TYPE player_role        AS ENUM ('TOP','JUNGLE','MID','ADC','SUPPORT');
```

> Algumas colunas usam `text` com DEFAULT alinhado ao enum (ex.: `tournaments.status`).

---

## profiles 🟢

Espelha `auth.users` com metadados de perfil. Trigger `handle_new_user` cria automaticamente ao inserir em `auth.users`.

| Coluna | Tipo | Constraints | RLS / Notas |
|---|---|---|---|
| `id` | `uuid` | PK, FK → `auth.users.id` | Leitura pública; update apenas pelo próprio usuário |
| `email` | `text` | NOT NULL | |
| `full_name` | `text` | | |
| `avatar_url` | `text` | | |
| `is_admin` | `boolean` | NOT NULL DEFAULT `false` | Usado em função `is_admin(uid)` para policies |
| `is_banned` | `boolean` | NOT NULL DEFAULT `false` | |
| `riot_game_name` | `text` | | |
| `riot_tag_line` | `text` | | |
| `created_at` | `timestamptz` | NOT NULL DEFAULT `now()` | |
| `updated_at` | `timestamptz` | NOT NULL DEFAULT `now()` | Trigger genérica |

---

## tournaments 🟢

Tabela principal de torneios. Leitura pública; insert/update/delete restritos a `is_admin`.

| Coluna | Tipo | Constraints | Notas |
|---|---|---|---|
| `id` | `uuid` | PK, `uuid_generate_v4()` | |
| `name` | `text` | NOT NULL | |
| `description` | `text` | | |
| `status` | `text` | NOT NULL DEFAULT `'DRAFT'` | Coerente com `tournament_status` |
| `bracket_type` | `bracket_type` | NOT NULL DEFAULT `SINGLE_ELIMINATION` | |
| `max_teams` | `integer` | NOT NULL DEFAULT 8, `>= 2` | |
| `prize_pool` | `text` | | |
| `start_date` / `end_date` | `timestamptz` | | |
| `created_by` | `uuid` | FK → `profiles.id` nullable | |
| `min_tier` | `text` | | Elo mínimo |
| `discord_webhook_url` | `text` | | |
| `slug` | `text` | NOT NULL, UNIQUE | URLs semânticas (migration 012) |
| `featured` | `boolean` | DEFAULT `false` | |
| `banner_url` | `text` | | |
| `registration_deadline` | `timestamptz` | | |
| `starts_at` | `timestamptz` | GENERATED ALWAYS AS (`start_date`) STORED | Alias para queries |
| `created_at` / `updated_at` | `timestamptz` | NOT NULL DEFAULT `now()` | |

---

## teams 🟢

| Coluna | Tipo | Constraints | Notas |
|---|---|---|---|
| `id` | `uuid` | PK | |
| `tournament_id` | `uuid` | NOT NULL, FK → `tournaments.id` | |
| `name` | `text` | NOT NULL | |
| `tag` | `text` | NOT NULL, length 1–6 | UNIQUE com `tournament_id` |
| `logo_url` | `text` | | |
| `owner_id` | `uuid` | FK → `profiles.id` nullable | |
| `is_eliminated` | `boolean` | NOT NULL DEFAULT `false` | |
| `created_at` | `timestamptz` | NOT NULL DEFAULT `now()` | |

---

## players 🟢

Jogadores vinculados a times. Vínculo sempre por UUID (`team_id`), nunca por slug.

| Coluna | Tipo | Constraints | Notas |
|---|---|---|---|
| `id` | `uuid` | PK | |
| `team_id` | `uuid` | FK → `teams.id` nullable | |
| `summoner_name` | `text` | NOT NULL | |
| `tag_line` | `text` | NOT NULL DEFAULT `'BR1'` | |
| `puuid` | `text` | Índice GIN + simples | Sincronizado com Riot API |
| `role` | `player_role` | | |
| `tier` / `rank` | `text` | NOT NULL DEFAULT `UNRANKED`/`''` | |
| `lp` / `wins` / `losses` | `integer` | NOT NULL DEFAULT 0, `>= 0` | |
| `profile_icon` | `integer` | | |
| `summoner_level` | `integer` | | |
| `last_synced` | `timestamptz` | | Última sync com Riot |
| `created_at` / `updated_at` | `timestamptz` | NOT NULL DEFAULT `now()` | |

---

## inscricoes 🟢

Pedido de inscrição de um time em um torneio.

| Coluna | Tipo | Constraints | Notas |
|---|---|---|---|
| `id` | `uuid` | PK | |
| `tournament_id` | `uuid` | NOT NULL, FK → `tournaments.id` | Índice em `(tournament_id, status)` |
| `team_id` | `uuid` | NOT NULL, FK → `teams.id` | |
| `requested_by` | `uuid` | FK → `profiles.id` nullable | Índice em `(requested_by, status)` |
| `status` | `inscricao_status` | NOT NULL DEFAULT `PENDING` | |
| `reviewed_by` | `uuid` | FK → `profiles.id` nullable | Admin que aprovou/rejeitou |
| `reviewed_at` | `timestamptz` | | |
| `notes` | `text` | | |
| `checked_in_at` | `timestamptz` | | Check-in no evento |
| `created_at` | `timestamptz` | NOT NULL DEFAULT `now()` | |

---

## matches 🟢

| Coluna | Tipo | Constraints | Notas |
|---|---|---|---|
| `id` | `uuid` | PK | |
| `tournament_id` | `uuid` | NOT NULL, FK → `tournaments.id` | Índice em `(tournament_id, round)` |
| `stage_id` | `uuid` | FK → `tournament_stages.id` nullable | |
| `round` | `integer` | NOT NULL DEFAULT 1, `>= 1` | |
| `match_order` | `integer` | NOT NULL DEFAULT 1 | |
| `status` | `match_status` | NOT NULL DEFAULT `SCHEDULED` | |
| `team_a_id` / `team_b_id` / `winner_id` | `uuid` | FK → `teams.id` nullable | |
| `score_a` / `score_b` | `integer` | `>= 0` | |
| `format` | `text` | NOT NULL DEFAULT `BO1`, in (`BO1`,`BO3`,`BO5`) | |
| `riot_match_id` | `text` | | ID de partida na Riot |
| `scheduled_at` / `played_at` | `timestamptz` | | |
| `notes` | `text` | | |
| `created_at` / `updated_at` | `timestamptz` | NOT NULL DEFAULT `now()` | |

---

## tournament_stages 🟢

| Coluna | Tipo | Constraints | Notas |
|---|---|---|---|
| `id` | `uuid` | PK | |
| `tournament_id` | `uuid` | NOT NULL, FK → `tournaments.id` | |
| `name` | `text` | NOT NULL | Ex.: "Quartas", "Grupos A" |
| `stage_order` | `integer` | NOT NULL DEFAULT 1 | |
| `bracket_type` | `bracket_type` | | Tipo específico da fase |
| `best_of` | `integer` | NOT NULL DEFAULT 1, in (1,3,5) | |
| `created_at` / `updated_at` | `timestamptz` | NOT NULL DEFAULT `now()` | |

---

## match_games 🟢

Cada jogo individual dentro de uma série (BO3/BO5).

| Coluna | Tipo | Constraints | Notas |
|---|---|---|---|
| `id` | `uuid` | PK | |
| `match_id` | `uuid` | NOT NULL, FK → `matches.id` | |
| `game_number` | `integer` | NOT NULL, `>= 1` | |
| `winner_id` | `uuid` | FK → `teams.id` nullable | |
| `riot_game_id` | `text` | | |
| `duration_sec` | `integer` | `>= 0` | |
| `picks_bans` | `jsonb` | | Draft completo |
| `played_at` | `timestamptz` | | |
| `created_at` | `timestamptz` | NOT NULL DEFAULT `now()` | |

---

## player_stats 🟢

Estatísticas por jogador por jogo. Alimenta as views `v_player_tournament_kda` e `v_stage_standings`.

| Coluna | Tipo | Constraints |
|---|---|---|
| `id` | `uuid` | PK |
| `game_id` | `uuid` | NOT NULL, FK → `match_games.id` |
| `player_id` | `uuid` | FK → `players.id` nullable |
| `team_id` | `uuid` | FK → `teams.id` nullable |
| `champion` | `text` | |
| `kills` / `deaths` / `assists` | `integer` | NOT NULL DEFAULT 0, `>= 0` |
| `cs` / `vision_score` / `damage_dealt` | `integer` | NOT NULL DEFAULT 0, `>= 0` |
| `is_mvp` | `boolean` | NOT NULL DEFAULT `false` |
| `created_at` | `timestamptz` | NOT NULL DEFAULT `now()` |

---

## notifications 🟢

RLS garante que o usuário logado só lê/altera suas próprias notificações.

| Coluna | Tipo | Constraints |
|---|---|---|
| `id` | `uuid` | PK |
| `user_id` | `uuid` | NOT NULL, FK → `profiles.id` |
| `type` | `text` | NOT NULL |
| `title` | `text` | NOT NULL |
| `body` | `text` | |
| `read` | `boolean` | NOT NULL DEFAULT `false` |
| `metadata` | `jsonb` | |
| `expires_at` | `timestamptz` | |
| `message` | `text` | Campo legado de compatibilidade |
| `link` | `text` | |
| `created_at` | `timestamptz` | NOT NULL DEFAULT `now()` |

---

## audit_log 🟡

Leitura restrita a `is_admin = true`. Nunca acessível por usuários comuns.

| Coluna | Tipo | Constraints |
|---|---|---|
| `id` | `uuid` | PK, `gen_random_uuid()` |
| `created_at` | `timestamptz` | NOT NULL DEFAULT `now()` |
| `admin_id` | `uuid` | FK → `profiles.id` nullable |
| `action` | `text` | NOT NULL |
| `table_name` | `text` | NOT NULL |
| `record_id` | `text` | |
| `old_data` / `new_data` | `jsonb` | |
| `ip_address` | `inet` | |
| `user_agent` | `text` | |

---

## riot_accounts 🟢

Contas Riot vinculadas a profiles. Trigger `ensure_single_primary_riot_account` garante no máximo uma conta primária por `profile_id`.

| Coluna | Tipo | Constraints | Notas |
|---|---|---|---|
| `id` | `uuid` | PK | |
| `profile_id` | `uuid` | NOT NULL, FK → `profiles.id` | |
| `puuid` | `text` | NOT NULL, UNIQUE | |
| `game_name` | `text` | NOT NULL | |
| `tagline` | `text` | NOT NULL | |
| `summoner_id` | `text` | | |
| `summoner_level` | `integer` | | |
| `profile_icon_id` | `integer` | | |
| `is_primary` | `boolean` | NOT NULL DEFAULT `false` | |
| `tag_line` | `text` | | Coluna legada (duplica `tagline`) |
| `created_at` / `updated_at` | `timestamptz` | NOT NULL DEFAULT `now()` | |

---

## rank_snapshots ⚪

Histórico de rank por conta Riot. Acesso via service role ou Edge Function de sync.

| Coluna | Tipo | Constraints |
|---|---|---|
| `id` | `uuid` | PK |
| `riot_account_id` | `uuid` | NOT NULL, FK → `riot_accounts.id` |
| `queue_type` | `text` | NOT NULL |
| `tier` / `rank` | `text` | NOT NULL |
| `lp` / `wins` / `losses` | `integer` | NOT NULL DEFAULT 0 |
| `hot_streak` | `boolean` | NOT NULL DEFAULT `false` |
| `snapshotted_at` | `timestamptz` | NOT NULL DEFAULT `now()` |

---

## champion_masteries ⚪

Maestrias por conta Riot. Atualizado pela Edge Function `riot-api-sync`.

| Coluna | Tipo | Constraints |
|---|---|---|
| `id` | `uuid` | PK |
| `riot_account_id` | `uuid` | NOT NULL, FK → `riot_accounts.id` |
| `champion_id` | `integer` | NOT NULL |
| `champion_name` | `text` | |
| `mastery_level` | `integer` | NOT NULL DEFAULT 0 |
| `mastery_points` | `integer` | NOT NULL DEFAULT 0 |
| `last_play_time` | `timestamptz` | |
| `created_at` / `updated_at` | `timestamptz` | NOT NULL DEFAULT `now()` |

---

## Resumo de FKs por UUID (opção A)

Todas as relações são feitas por UUID real. **Nunca por slug ou string de URL.**

```
profiles.id            ↔ auth.users.id
tournaments.created_by → profiles.id
teams.tournament_id    → tournaments.id
teams.owner_id         → profiles.id
players.team_id        → teams.id
inscricoes.tournament_id, team_id → tournaments.id, teams.id
inscricoes.requested_by, reviewed_by → profiles.id
matches.tournament_id  → tournaments.id
matches.team_a_id / team_b_id / winner_id → teams.id
matches.stage_id       → tournament_stages.id
tournament_stages.tournament_id → tournaments.id
match_games.match_id   → matches.id
match_games.winner_id  → teams.id
player_stats.game_id   → match_games.id
player_stats.player_id → players.id
player_stats.team_id   → teams.id
notifications.user_id  → profiles.id
audit_log.admin_id     → profiles.id
riot_accounts.profile_id → profiles.id
rank_snapshots.riot_account_id → riot_accounts.id
champion_masteries.riot_account_id → riot_accounts.id
```

---

## Funções SQL auxiliares

| Função | Uso |
|---|---|
| `is_admin(uid uuid)` | Retorna `boolean` — usada em todas as policies de admin |
| `handle_new_user()` | Trigger `AFTER INSERT ON auth.users` — cria `profiles` autom. |
| `ensure_single_primary_riot_account()` | Trigger em `riot_accounts` — no máximo 1 conta primária por profile |

## Views

| View | Base | Uso |
|---|---|---|
| `v_stage_standings` | `tournament_stages`, `matches`, `teams` | Classificação por fase |
| `v_player_tournament_kda` | `player_stats`, `match_games`, `matches` | KDA agregado por torneio |
| `v_player_leaderboard` | `players`, `rank_snapshots` | Ranking geral de jogadores |
