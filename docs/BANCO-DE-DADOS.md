# Banco de Dados — GerenciadorDeTorneios BRLOL

> Atualizado em: **2026-04-26**  
> Postgres 17 via Supabase. RLS habilitado em todas as tabelas públicas.

---

## Diagrama de Entidades (simplificado)

```
auth.users
    │
    └── profiles (1:1)
            │
            ├── riot_accounts (1:N)
            │       ├── rank_snapshots (1:N)
            │       └── champion_masteries (1:N)
            │
            └── teams [captain_id] (1:N)
                    │
                    └── tournament_id → tournaments
                    │
                    ├── players (1:N via team_id)
                    └── inscricoes (N:N via tournament_id + team_id)

tournaments
    ├── tournament_stages (1:N)
    │       └── matches (1:N via stage_id)
    │               ├── match_games (1:N)
    │               │       └── player_stats (1:N)
    │               ├── team_a_id → teams
    │               └── team_b_id → teams
    └── inscricoes (1:N)

profiles
    └── notifications (1:N)
    └── audit_log [performed_by] (1:N)
```

---

## Colunas Críticas por Tabela

### `tournaments`

| Coluna | Tipo | Observação |
|---|---|---|
| `id` | uuid | PK |
| `slug` | text | NOT NULL UNIQUE — chave semântica |
| `status` | text | `draft` \| `open` \| `ongoing` \| `finished` \| `cancelled` |
| `start_date` | timestamptz | Escrever aqui nos UPDATEs |
| `end_date` | timestamptz | Escrever aqui nos UPDATEs |
| `starts_at` | timestamptz | **GENERATED** — somente leitura |
| `ends_at` | timestamptz | **GENERATED** — somente leitura |
| `max_teams` | int | Limite de vagas |
| `bracket_type` | text | `single_elimination` \| `double_elimination` \| `groups` |

### `players`

| Coluna | Tipo | Observação |
|---|---|---|
| `summoner_name` | text | Com underscore (correto) |
| `tag_line` | text | Com underscore (correto) |
| `puuid` | text | ID único Riot |
| `tier` | text | `IRON` \| `BRONZE` \| … \| `CHALLENGER` |

### `inscricoes`

| Coluna | Tipo | Observação |
|---|---|---|
| `status` | text | `pending` \| `approved` \| `rejected` \| `eliminated` |
| `seed` | int | Seeding do time na chave |
| `checked_in_at` | timestamptz | null se não fez check-in |

---

## Triggers Ativos

| Trigger | Tabela | Evento | Função |
|---|---|---|---|
| `before_insert_tournament_slug` | `tournaments` | BEFORE INSERT | `generate_tournament_slug()` — gera slug a partir de `name` |
| `after_inscricao_approved` | `inscricoes` | AFTER UPDATE | Insere notificação para o capitão do time |
| `audit_tournaments` | `tournaments` | AFTER INSERT/UPDATE/DELETE | Registra em `audit_log` |
| `audit_inscricoes` | `inscricoes` | AFTER UPDATE | Registra mudanças de status em `audit_log` |

---

## Views

### `v_stage_standings`
Classificação por fase do torneio — agrega wins/losses dos `matches` por time e fase.

```sql
-- Exemplo de uso
SELECT * FROM v_stage_standings
WHERE tournament_id = '{uuid}'
ORDER BY stage_order, wins DESC;
```

### `v_player_tournament_kda`
KDA médio por jogador em cada torneio — agrega `player_stats` via `match_games` → `matches`.

```sql
-- Exemplo de uso
SELECT * FROM v_player_tournament_kda
WHERE tournament_id = '{uuid}'
ORDER BY avg_kda DESC;
```

---

## RLS — Políticas por Tabela

| Tabela | Operação | Policy |
|---|---|---|
| `tournaments` | SELECT | Público (qualquer um) |
| `tournaments` | INSERT/UPDATE | Admin ou `created_by = auth.uid()` |
| `teams` | SELECT | Público |
| `teams` | INSERT | Autenticado |
| `teams` | UPDATE | `captain_id = auth.uid()` ou Admin |
| `inscricoes` | SELECT | Público |
| `inscricoes` | INSERT | Capitão do time (`teams.captain_id = auth.uid()`) |
| `inscricoes` | UPDATE | Admin ou `created_by` do torneio |
| `players` | SELECT | Público |
| `player_stats` | INSERT/UPDATE | Admin / service_role |
| `notifications` | SELECT/UPDATE | `user_id = auth.uid()` |
| `audit_log` | SELECT | Admin |
| `riot_accounts` | SELECT/INSERT | `profile_id = auth.uid()` |
