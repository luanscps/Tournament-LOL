# Arquitetura — GerenciadorDeTorneios BRLOL

> Atualizado em: 2026-04-23 (pós migration 012)

## Stack

| Camada      | Tecnologia                  |
|-------------|-----------------------------|
| Frontend    | Next.js 14+ (App Router)    |
| Backend     | Supabase (Postgres + Auth)  |
| Edge Fn     | Supabase Edge Functions     |
| Riot API    | Via Edge Function (server)  |
| Deploy      | Vercel                      |
| CSS         | Tailwind CSS v3             |

---

## Modelo de Rotas Dinâmicas

### Convenção atual (pós Fase 2)

| Entidade  | Pasta              | Parâmetro | Tipo de valor na URL | Consulta no banco          |
|-----------|--------------------|-----------|----------------------|----------------------------|
| Torneios  | `app/torneios/[slug]`          | `slug` | slug textual real (`lol-cup-abril-2026`) | `.eq("slug", slug)` |
| Torneios admin | `app/admin/torneios/[slug]` | `slug` | slug textual real | `.eq("slug", slug)` |
| Times     | `app/times/[slug]` | `slug` | UUID (ainda)         | `.eq("id", slug)`          |
| Admin Jogadores | `app/admin/jogadores/[slug]` | `slug` | UUID | `.eq("id", slug)` |
| Admin Usuários  | `app/admin/usuarios/[slug]` | `slug` | UUID | `.eq("id", slug)` |

**Regra**: A partir do slug, a página sempre extrai `tournamentId = t.id` (UUID) e usa esse id
em todas as queries relacionais (tournament_teams, matches, etc). Nunca passa o slug textual
para uma FK.

---

## Banco de Dados — Tabelas principais

### `tournaments`
- `id` uuid PK
- `slug` text NOT NULL UNIQUE — chave semântica para URLs
- `name`, `description`, `status`, `max_teams`, `bracket_type`, `queue_type`
- `starts_at`, `created_at`, `created_by`

### `teams`
- `id` uuid PK (**slug real não implementado ainda — previsto em 013**)
- `name`, `tag`, `logo_url`, `description`
- `captain_id` → profiles.id
- `tournament_id` → tournaments.id

### `players`
- `id` uuid PK
- `summoner_name`, `tag_line`, `puuid`
- `tier`, `rank`, `lp`, `wins`, `losses`, `role`
- `team_id` → teams.id

### `profiles`
- `id` uuid PK (= auth.users.id)
- `email`, `full_name`, `avatar_url`
- `is_admin`, `is_banned`

### `tournament_teams`
- `tournament_id` → tournaments.id
- `team_id` → teams.id
- `status` enum: pending | approved | rejected | eliminated
- `seed`, `checked_in_at`

### `matches`
- `id` uuid PK
- `tournament_id` → tournaments.id
- `team_a_id`, `team_b_id` → teams.id
- `winner_team_id` → teams.id
- `score_a`, `score_b`, `status`, `round`, `match_number`

---

## Migrations

| Arquivo | Descrição |
|---------|-----------|
| `001_initial_schema.sql` | Schema base: profiles, tournaments, teams, players, matches |
| `002_schema_expansion.sql` | Expansão de campos e enums |
| `003_audit_log.sql` | Tabela de auditoria |
| `004_seedings_players_triggers.sql` | Triggers de seed e players |
| `005_demo_seed.sql` | Dados de demonstração |
| `006_demo_phases3-4.sql` | Fases 3 e 4 do torneio |
| `007_notifications_table.sql` | Tabela de notificações |
| `008_fix_core_schema.sql` | Normalização pós-snapshot 23/04 |
| `009_create_riot_accounts.sql` | Tabela riot_accounts e vínculos |
| `010_fix_notifications.sql` | Correções em notifications |
| `011_fix_triggers_and_functions.sql` | Triggers e funções revisados |
| `012_ensure_tournament_slug.sql` | Garante slug único e NOT NULL em tournaments |

---

## Edge Functions

| Função | Trigger | Descrição |
|--------|---------|-----------|
| `bracket-generator` | Admin → POST | Gera partidas do torneio em single elimination |
| `riot-api-sync` | Agendado/manual | Sincroniza dados de rank via Riot API |
| `discord-webhook` | Eventos do torneio | Notifica canal Discord |
| `send-email` | Inscricao aprovada/rejeitada | Email transacional |

---

## Padrão de Server Actions

- `lib/actions/tournament.ts` → createTournament, updateTournament
- `lib/actions/inscricao.ts` → aprovarInscricao, rejeitarInscricao
- `lib/actions/partida.ts` → editarResultadoPartida

Após cada action bem-sucedida, usa `revalidatePath` para invalidar o cache da rota afetada.

---

## Próximos passos previstos

- [ ] `013_teams_slug.sql` — adicionar coluna `slug` em `teams` com backfill e unique index
- [ ] Migrar `app/times/[slug]` para usar slug real em teams
- [ ] Migrar listagens de times nos admin para links com slug
- [ ] Revisar `players` para considerar summonername-tagline como identificador de rota (opcional)
