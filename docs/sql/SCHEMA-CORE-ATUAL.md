# Schema core atual — Supabase (schema `public`)

> Fonte: dump `sql/2026-04-25_122855.sql` e migrations `001_initial_schema.sql`, `002_schema_expansion.sql`, `009_create_riot_accounts.sql`.[cite:22][cite:31][cite:32][cite:33]

Este documento descreve as entidades principais do domínio BRLOL no banco Postgres/Supabase, com foco em chaves primárias, chaves estrangeiras por UUID (opção **A**, sem FKs "por slug") e relacionamentos entre tabelas.

---

## Enums

Definidos em `001_initial_schema.sql`:[cite:31]

- `tournament_status` = `DRAFT`, `OPEN`, `IN_PROGRESS`, `FINISHED`, `CANCELLED`.
- `bracket_type` = `SINGLE_ELIMINATION`, `DOUBLE_ELIMINATION`, `ROUND_ROBIN`, `SWISS`.
- `match_status` = `SCHEDULED`, `IN_PROGRESS`, `FINISHED`.
- `inscricao_status` = `PENDING`, `APPROVED`, `REJECTED`.
- `player_role` = `TOP`, `JUNGLE`, `MID`, `ADC`, `SUPPORT`.

Na prática, algumas colunas usam o tipo `text` com default baseado no enum (ex.: `tournaments.status`), mas a semântica esperada continua sendo esses conjuntos de valores.[cite:31]

---

## profiles

Espelha `auth.users` com metadados de perfil.[cite:31]

| Coluna         | Tipo      | Constraints                       | Descrição                          |
|----------------|-----------|-----------------------------------|------------------------------------|
| `id`           | `uuid`    | PK, FK → `auth.users.id`         | Identificador do usuário.          |
| `email`        | `text`    | NOT NULL                         | Email principal.                   |
| `full_name`    | `text`    |                                   | Nome completo.                     |
| `avatar_url`   | `text`    |                                   | URL do avatar.                     |
| `is_admin`     | `boolean` | NOT NULL DEFAULT `false`         | Flag de administrador.             |
| `is_banned`    | `boolean` | NOT NULL DEFAULT `false`         | Flag de banimento lógico.          |
| `riot_game_name` | `text`  |                                   | Nick padrão Riot (gameName).       |
| `riot_tag_line`  | `text`  |                                   | Tag padrão Riot (tagLine).         |
| `created_at`   | `timestamptz` | NOT NULL DEFAULT `now()`     | Data de criação.                   |
| `updated_at`   | `timestamptz` | NOT NULL DEFAULT `now()`     | Atualizado via trigger genérica.   |

Trigger `handle_new_user` cria automaticamente um `profile` ao inserir em `auth.users`; a função `is_admin(uid)` é usada em diversas policies de RLS.[cite:31]

---

## tournaments

Tabela principal de torneios.[cite:31][cite:32]

| Coluna                | Tipo            | Constraints                               | Descrição                                         |
|-----------------------|-----------------|-------------------------------------------|---------------------------------------------------|
| `id`                  | `uuid`         | PK, DEFAULT `uuid_generate_v4()`          | Identificador do torneio.                         |
| `name`                | `text`         | NOT NULL                                  | Nome exibido.                                     |
| `description`         | `text`         |                                           | Descrição longa.                                  |
| `status`              | `text`         | NOT NULL DEFAULT `'DRAFT'::tournament_status` | Fase do torneio (coerente com enum).         |
| `bracket_type`        | `bracket_type` | NOT NULL DEFAULT `SINGLE_ELIMINATION`     | Tipo de chave.                                    |
| `max_teams`           | `integer`      | NOT NULL DEFAULT 8, `>= 2`                | Limite de times.                                  |
| `prize_pool`          | `text`         |                                           | Premiação livre.                                  |
| `start_date`          | `timestamptz`  |                                           | Data/hora inicial planejada.                      |
| `end_date`            | `timestamptz`  |                                           | Data/hora de término.                             |
| `created_by`          | `uuid`         | FK → `profiles.id` (nullable)             | Admin criador.                                    |
| `created_at`          | `timestamptz`  | NOT NULL DEFAULT `now()`                  | Quando foi criado.                                |
| `updated_at`          | `timestamptz`  | NOT NULL DEFAULT `now()`                  | Atualizado via trigger.                           |
| `min_tier`            | `text`         |                                           | Elo mínimo recomendado/obrigatório.               |
| `discord_webhook_url` | `text`         |                                           | Webhook Discord associado.                        |
| `slug`                | `text`         | NOT NULL, UNIQUE (por migration 012)      | Identificador semântico para URLs.                |
| `featured`            | `boolean`      | DEFAULT `false`                           | Destacado na vitrine.                             |
| `banner_url`          | `text`         |                                           | Banner do torneio.                                |
| `registration_deadline` | `timestamptz` |                                           | Data limite de inscrição.                         |
| `starts_at`           | `timestamptz`  | GENERATED ALWAYS AS (`start_date`) STORED | Coluna derivada para facilitar queries.           |

RLS: leitura pública; insert/update/delete restritos a admins via função `is_admin`.[cite:31]

---

## teams

Times inscritos em um torneio.[cite:31]

| Coluna         | Tipo       | Constraints                              | Descrição                                  |
|----------------|------------|------------------------------------------|--------------------------------------------|
| `id`           | `uuid`     | PK, DEFAULT `uuid_generate_v4()`         | Identificador do time.                     |
| `tournament_id`| `uuid`     | NOT NULL, FK → `tournaments.id`          | Torneio ao qual o time pertence.           |
| `name`         | `text`     | NOT NULL                                 | Nome do time.                              |
| `tag`          | `text`     | NOT NULL, `length 1..6`                  | Tag curta para exibição (ex.: ABC).        |
| `logo_url`     | `text`     |                                          | Logo opcional.                             |
| `owner_id`     | `uuid`     | FK → `profiles.id` (nullable)            | Dono do time no app.                       |
| `created_at`   | `timestamptz` | NOT NULL DEFAULT `now()`              | Data de criação.                           |
| `is_eliminated`| `boolean`  | NOT NULL DEFAULT `false`                 | Flag de eliminação no torneio.             |

Índices importantes: `UNIQUE (tournament_id, tag)` e índices auxiliares nas colunas de relacionamento (via migrations).[cite:31][cite:32]

---

## players

Jogadores (summoners) vinculados a times e usados para estatísticas.[cite:31]

| Coluna          | Tipo         | Constraints                         | Descrição                                     |
|-----------------|--------------|-------------------------------------|-----------------------------------------------|
| `id`            | `uuid`       | PK, DEFAULT `uuid_generate_v4()`    | Identificador do jogador.                     |
| `team_id`       | `uuid`       | FK → `teams.id` (nullable)          | Time atual dentro do torneio.                 |
| `summoner_name` | `text`       | NOT NULL                            | Nome do invocador.                            |
| `tag_line`      | `text`       | NOT NULL DEFAULT `'BR1'`            | Tag da Riot (região/identificador).          |
| `puuid`         | `text`       | Índice GIN + índice simples         | Identificador global da Riot.                 |
| `role`          | `player_role`|                                     | Rota preferida (TOP/JUNGLE/etc.).            |
| `tier`          | `text`       | NOT NULL DEFAULT `UNRANKED`         | Tier textual mais recente.                    |
| `rank`          | `text`       | NOT NULL DEFAULT `''`               | Divisão (ex.: I, II, etc.).                   |
| `lp`            | `integer`    | NOT NULL DEFAULT 0, `>= 0`          | League Points.                                |
| `wins`          | `integer`    | NOT NULL DEFAULT 0, `>= 0`          | Vitórias registradas.                         |
| `losses`        | `integer`    | NOT NULL DEFAULT 0, `>= 0`          | Derrotas registradas.                         |
| `profile_icon`  | `integer`    |                                     | ID do ícone de perfil.                       |
| `summoner_level`| `integer`    |                                     | Nível da conta.                              |
| `last_synced`   | `timestamptz`|                                     | Última sincronização com a Riot API.         |
| `created_at`    | `timestamptz`| NOT NULL DEFAULT `now()`            | Data de criação.                             |
| `updated_at`    | `timestamptz`| NOT NULL DEFAULT `now()`            | Atualizado via trigger.                      |

Opção **A**: o vínculo com times é sempre via `team_id` (UUID real), **nunca por slug**.[cite:31]

---

## inscricoes

Modela o pedido de inscrição de um time em um torneio, com status e check‑in.[cite:31][cite:36]

| Coluna         | Tipo               | Constraints                         | Descrição                                             |
|----------------|--------------------|-------------------------------------|-------------------------------------------------------|
| `id`           | `uuid`             | PK, DEFAULT `uuid_generate_v4()`    | Identificador da inscrição.                           |
| `tournament_id`| `uuid`             | NOT NULL, FK → `tournaments.id`     | Torneio alvo.                                         |
| `team_id`      | `uuid`             | NOT NULL, FK → `teams.id`           | Time que está se inscrevendo.                         |
| `requested_by` | `uuid`             | FK → `profiles.id` (nullable)       | Usuário que fez o pedido.                             |
| `status`       | `inscricao_status` | NOT NULL DEFAULT `PENDING`          | `PENDING` / `APPROVED` / `REJECTED`.                  |
| `reviewed_by`  | `uuid`             | FK → `profiles.id` (nullable)       | Admin que aprovou/rejeitou.                           |
| `reviewed_at`  | `timestamptz`      |                                     | Momento da revisão.                                   |
| `notes`        | `text`             |                                     | Observações internas.                                 |
| `created_at`   | `timestamptz`      | NOT NULL DEFAULT `now()`            | Data de criação.                                      |
| `checked_in_at`| `timestamptz`      |                                     | Momento de check‑in do time no evento.               |

Índices de apoio em `(team_id)`, `(tournament_id)`, `(requested_by)`, `(tournament_id, status)` e `(requested_by, status)`.[cite:36]

---

## matches

Partidas agendadas ou concluídas em um torneio.[cite:31][cite:32]

| Coluna        | Tipo           | Constraints                            | Descrição                                                 |
|---------------|----------------|----------------------------------------|-----------------------------------------------------------|
| `id`          | `uuid`         | PK, DEFAULT `uuid_generate_v4()`       | Identificador da partida.                                 |
| `tournament_id`| `uuid`        | NOT NULL, FK → `tournaments.id`        | Torneio ao qual a partida pertence.                       |
| `round`       | `integer`      | NOT NULL DEFAULT 1, `>= 1`             | Rodada (1, 2, 3...).                                      |
| `match_order` | `integer`      | NOT NULL DEFAULT 1                     | Ordem dentro da rodada.                                  |
| `status`      | `match_status` | NOT NULL DEFAULT `SCHEDULED`           | Status da partida.                                       |
| `team_a_id`   | `uuid`         | FK → `teams.id` (nullable)             | Time A.                                                   |
| `team_b_id`   | `uuid`         | FK → `teams.id` (nullable)             | Time B.                                                   |
| `winner_id`   | `uuid`         | FK → `teams.id` (nullable)             | Time vencedor.                                           |
| `score_a`     | `integer`      | `>= 0`                                 | Placar do time A.                                       |
| `score_b`     | `integer`      | `>= 0`                                 | Placar do time B.                                       |
| `riot_match_id`| `text`        |                                        | ID de partida na Riot (se houver).                       |
| `scheduled_at`| `timestamptz`  |                                        | Data/hora agendada.                                      |
| `played_at`   | `timestamptz`  |                                        | Data/hora em que foi jogada.                             |
| `notes`       | `text`         |                                        | Observações.                                             |
| `created_at`  | `timestamptz`  | NOT NULL DEFAULT `now()`               | Criação.                                                 |
| `updated_at`  | `timestamptz`  | NOT NULL DEFAULT `now()`               | Atualizado via trigger.                                  |
| `format`      | `text`         | NOT NULL DEFAULT `BO1`, in (`BO1`,`BO3`,`BO5`) | Formato da série.                               |
| `stage_id`    | `uuid`         | FK → `tournament_stages.id` (nullable) | Fase do torneio à qual a partida pertence.               |

Índices em `(tournament_id)` e `(tournament_id, round)` facilitam geração e consulta de chaves.[cite:32]

---

## tournament_stages

Fases de um torneio (ex.: Grupos A/B, Quartas, Semis, Final).[cite:32]

| Coluna        | Tipo            | Constraints                          | Descrição                           |
|---------------|-----------------|--------------------------------------|-------------------------------------|
| `id`          | `uuid`          | PK, DEFAULT `uuid_generate_v4()`     | Identificador da fase.              |
| `tournament_id`| `uuid`         | NOT NULL, FK → `tournaments.id`      | Torneio pai.                        |
| `name`        | `text`          | NOT NULL                             | Nome da fase.                       |
| `stage_order` | `integer`       | NOT NULL DEFAULT 1                   | Ordem de exibição/execução.        |
| `bracket_type`| `bracket_type`  |                                      | Tipo de chave específica da fase.  |
| `best_of`     | `integer`       | NOT NULL DEFAULT 1, in (1,3,5)       | Formato padrão de série da fase.   |
| `created_at`  | `timestamptz`   | NOT NULL DEFAULT `now()`             | Criação.                            |
| `updated_at`  | `timestamptz`   | NOT NULL DEFAULT `now()`             | Atualizado via trigger.            |

---

## match_games

Cada jogo individual dentro de uma série (BO3/BO5).[_cite32]

| Coluna       | Tipo        | Constraints                        | Descrição                              |
|--------------|-------------|------------------------------------|----------------------------------------|
| `id`         | `uuid`      | PK, DEFAULT `uuid_generate_v4()`   | Identificador do jogo.                 |
| `match_id`   | `uuid`      | NOT NULL, FK → `matches.id`        | Partida à qual o jogo pertence.        |
| `game_number`| `integer`   | NOT NULL, `>= 1`                   | Número do jogo na série (1,2,3...).    |
| `winner_id`  | `uuid`      | FK → `teams.id` (nullable)         | Time vencedor do jogo.                 |
| `riot_game_id`| `text`     |                                    | ID do jogo na Riot.                    |
| `duration_sec`| `integer`  | `>= 0`                             | Duração do jogo em segundos.           |
| `picks_bans` | `jsonb`     |                                    | Draft completo (picks/bans).           |
| `played_at`  | `timestamptz`|                                   | Data/hora em que terminou.             |
| `created_at` | `timestamptz`| NOT NULL DEFAULT `now()`          | Criação.                               |

---

## player_stats

Estatísticas por jogador por jogo.[cite:32]

| Coluna        | Tipo       | Constraints                        | Descrição                           |
|---------------|------------|------------------------------------|-------------------------------------|
| `id`          | `uuid`     | PK, DEFAULT `uuid_generate_v4()`   | Identificador da linha de stats.    |
| `game_id`     | `uuid`     | NOT NULL, FK → `match_games.id`    | Jogo ao qual se refere.             |
| `player_id`   | `uuid`     | FK → `players.id` (nullable)       | Jogador.                            |
| `team_id`     | `uuid`     | FK → `teams.id` (nullable)         | Time do jogador naquele jogo.       |
| `champion`    | `text`     |                                    | Campeão jogado.                     |
| `kills`       | `integer`  | NOT NULL DEFAULT 0, `>= 0`         | Abates.                             |
| `deaths`      | `integer`  | NOT NULL DEFAULT 0, `>= 0`         | Mortes.                             |
| `assists`     | `integer`  | NOT NULL DEFAULT 0, `>= 0`         | Assistências.                       |
| `cs`          | `integer`  | NOT NULL DEFAULT 0, `>= 0`         | Tropas abatidas.                    |
| `vision_score`| `integer`  | NOT NULL DEFAULT 0, `>= 0`         | Score de visão.                     |
| `damage_dealt`| `integer`  | NOT NULL DEFAULT 0, `>= 0`         | Dano causado.                       |
| `is_mvp`      | `boolean`  | NOT NULL DEFAULT `false`           | Flag de MVP daquele jogo.          |
| `created_at`  | `timestamptz`| NOT NULL DEFAULT `now()`         | Criação.                            |

Views `v_player_tournament_kda` e `v_stage_standings` se apoiam em `player_stats`, `match_games`, `matches`, `tournament_stages` e `teams` para gerar rankings agregados.[cite:32]

---

## notifications

Notificações in‑app por usuário.[cite:32]

| Coluna       | Tipo        | Constraints                        | Descrição                                   |
|--------------|-------------|------------------------------------|---------------------------------------------|
| `id`         | `uuid`      | PK, DEFAULT `uuid_generate_v4()`   | Identificador da notificação.               |
| `user_id`    | `uuid`      | NOT NULL, FK → `profiles.id`       | Usuário destinatário.                      |
| `type`       | `text`      | NOT NULL                           | Tipo lógico (ex.: `"inscricao"`, `"sistema"`). |
| `title`      | `text`      | NOT NULL                           | Título curto.                               |
| `body`       | `text`      |                                    | Corpo/mensagem.                             |
| `read`       | `boolean`   | NOT NULL DEFAULT `false`           | Flag de lida.                               |
| `metadata`   | `jsonb`     |                                    | Payload adicional estruturado.              |
| `expires_at` | `timestamptz`|                                   | Expiração opcional.                         |
| `created_at` | `timestamptz`| NOT NULL DEFAULT `now()`          | Criação.                                    |
| `message`    | `text`      |                                    | Campo de compatibilidade legado.           |
| `link`       | `text`      |                                    | URL opcional associada.                     |

RLS garante que o usuário logado só consegue ler/alterar suas próprias notificações.[cite:32]

---

## audit_log

Trilha de auditoria de ações administrativas.[cite:32]

| Coluna      | Tipo        | Constraints                           | Descrição                                      |
|-------------|-------------|---------------------------------------|------------------------------------------------|
| `id`        | `uuid`      | PK, DEFAULT `gen_random_uuid()`       | Identificador do registro de auditoria.        |
| `created_at`| `timestamptz`| NOT NULL DEFAULT `now()`             | Momento da ação.                               |
| `admin_id`  | `uuid`      | FK → `profiles.id` (nullable)         | Admin responsável.                             |
| `action`    | `text`      | NOT NULL                              | Nome lógico da ação.                           |
| `table_name`| `text`      | NOT NULL                              | Tabela alvo.                                   |
| `record_id` | `text`      |                                       | ID do registro alterado (como texto).         |
| `old_data`  | `jsonb`     |                                       | Snapshot anterior.                             |
| `new_data`  | `jsonb`     |                                       | Snapshot posterior.                            |
| `ip_address`| `inet`      |                                       | IP de origem.                                  |
| `user_agent`| `text`      |                                       | User Agent HTTP.                               |

RLS restringe leitura a admins (`is_admin(auth.uid()) = true`).[cite:32]

---

## riot_accounts, rank_snapshots, champion_masteries

Camada de persistência da integração com a Riot API.[cite:33]

### riot_accounts

| Coluna          | Tipo        | Constraints                             | Descrição                                   |
|-----------------|-------------|-----------------------------------------|---------------------------------------------|
| `id`            | `uuid`      | PK, DEFAULT `uuid_generate_v4()`        | Identificador da conta Riot.                |
| `profile_id`    | `uuid`      | NOT NULL, FK → `profiles.id`           | Usuário dono da conta.                      |
| `puuid`         | `text`      | NOT NULL, UNIQUE                        | PUUID global da Riot.                       |
| `game_name`     | `text`      | NOT NULL                                | Nome da conta (gameName).                   |
| `tagline`       | `text`      | NOT NULL                                | Tagline (BR1, #1234, etc.).                 |
| `summoner_id`   | `text`      |                                         | ID interno da Riot (summonerId).            |
| `summoner_level`| `integer`   |                                         | Nível atual.                                |
| `profile_icon_id`| `integer`  |                                         | Ícone de perfil.                            |
| `is_primary`    | `boolean`   | NOT NULL DEFAULT `false`                | Marca conta primária daquele profile.       |
| `created_at`    | `timestamptz`| NOT NULL DEFAULT `now()`              | Criação.                                    |
| `updated_at`    | `timestamptz`| NOT NULL DEFAULT `now()`              | Atualizada via trigger.                     |
| `tag_line`      | `text`      |                                         | Coluna legada (duplicação de `tagline`).    |

Triggers garantem que exista no máximo uma conta primária por `profile_id` (`ensure_single_primary_riot_account`).[cite:33]

### rank_snapshots

| Coluna        | Tipo        | Constraints                             | Descrição                                    |
|---------------|-------------|-----------------------------------------|----------------------------------------------|
| `id`          | `uuid`      | PK, DEFAULT `uuid_generate_v4()`        | Identificador do snapshot.                   |
| `riot_account_id`| `uuid`   | NOT NULL, FK → `riot_accounts.id`       | Conta Riot alvo.                             |
| `queue_type`  | `text`      | NOT NULL                                | Fila (solo/duo, flex, etc.).                 |
| `tier`        | `text`      | NOT NULL                                | Tier.                                        |
| `rank`        | `text`      | NOT NULL                                | Divisão.                                     |
| `lp`          | `integer`   | NOT NULL DEFAULT 0                      | LP.                                          |
| `wins`        | `integer`   | NOT NULL DEFAULT 0                      | Vitórias acumuladas.                         |
| `losses`      | `integer`   | NOT NULL DEFAULT 0                      | Derrotas acumuladas.                         |
| `hot_streak`  | `boolean`   | NOT NULL DEFAULT `false`                | Se está em winstreak.                        |
| `snapshotted_at`| `timestamptz`| NOT NULL DEFAULT `now()`             | Momento do snapshot.                         |

### champion_masteries

| Coluna          | Tipo        | Constraints                             | Descrição                                    |
|-----------------|-------------|-----------------------------------------|----------------------------------------------|
| `id`            | `uuid`      | PK, DEFAULT `uuid_generate_v4()`        | Identificador da linha de maestria.          |
| `riot_account_id`| `uuid`     | NOT NULL, FK → `riot_accounts.id`       | Conta Riot.                                  |
| `champion_id`   | `integer`   | NOT NULL                                | ID do campeão.                               |
| `champion_name` | `text`      |                                         | Nome do campeão.                             |
| `mastery_level` | `integer`   | NOT NULL DEFAULT 0                      | Nível de maestria.                           |
| `mastery_points`| `integer`   | NOT NULL DEFAULT 0                      | Pontos de maestria.                          |
| `last_play_time`| `timestamptz`|                                        | Última vez jogado.                           |
| `created_at`    | `timestamptz`| NOT NULL DEFAULT `now()`              | Criação.                                     |
| `updated_at`    | `timestamptz`| NOT NULL DEFAULT `now()`              | Atualizada via trigger.                      |

---

## Resumo de relacionamentos (FKs por UUID — opção A)

- `profiles.id` ↔ `auth.users.id`.
- `tournaments.created_by` → `profiles.id`.
- `teams.tournament_id` → `tournaments.id`.
- `teams.owner_id` → `profiles.id`.
- `players.team_id` → `teams.id`.
- `inscricoes.tournament_id` → `tournaments.id`.
- `inscricoes.team_id` → `teams.id`.
- `inscricoes.requested_by` / `reviewed_by` → `profiles.id`.
- `matches.tournament_id` → `tournaments.id`.
- `matches.team_a_id` / `team_b_id` / `winner_id` → `teams.id`.
- `tournament_stages.tournament_id` → `tournaments.id`.
- `matches.stage_id` → `tournament_stages.id`.
- `match_games.match_id` → `matches.id`.
- `match_games.winner_id` → `teams.id`.
- `player_stats.game_id` → `match_games.id`.
- `player_stats.player_id` → `players.id`.
- `player_stats.team_id` → `teams.id`.
- `notifications.user_id` → `profiles.id`.
- `audit_log.admin_id` → `profiles.id`.
- `riot_accounts.profile_id` → `profiles.id`.
- `rank_snapshots.riot_account_id` → `riot_accounts.id`.
- `champion_masteries.riot_account_id` → `riot_accounts.id`.

Ou seja, **todas as relações fortes são feitas via UUID real**, garantindo integridade referencial e evitando FKs baseadas em slug ou strings de URL.[cite:31][cite:32][cite:33]
