# Arquitetura Atual — GerenciadorDeTorneios BRLOL

> Atualizado em: **2026-04-26**  
> Branch de referência: `main`  
> Migrations aplicadas: `001` → `012`

---

## Stack

| Camada | Tecnologia |
|---|---|
| Frontend | Next.js 15.2.6 (App Router) |
| UI | React 19 + Tailwind CSS 3.4 |
| Auth / Banco | Supabase (Postgres 17, RLS habilitado) |
| Realtime | Supabase Realtime |
| Edge / Jobs | Supabase Edge Functions |
| Deploy | Vercel |
| Formulários | react-hook-form + zod |
| Charts | Recharts |
| HTTP Client | fetch nativo (Next.js server actions) |

---

## Modelo de Rotas Dinâmicas

| Entidade | Pasta | Parâmetro | Tipo de valor | Consulta no banco |
|---|---|---|---|---|
| Torneio (público) | `app/torneios/[slug]` | `slug` | slug textual (`lol-cup-abril-2026`) | `.eq("slug", slug)` |
| Torneio (organizador) | `app/organizador/torneios/[id]` | `id` | UUID | `.eq("id", id)` |
| Torneio (admin) | `app/admin/torneios/[slug]` | `slug` | slug textual | `.eq("slug", slug)` |
| Time (público) | `app/times/[slug]` | `slug` | UUID (slug real previsto em 013) | `.eq("id", slug)` |
| Admin Jogadores | `app/admin/jogadores/[slug]` | `slug` | UUID | `.eq("id", slug)` |
| Admin Usuários | `app/admin/usuarios/[slug]` | `slug` | UUID | `.eq("id", slug)` |

**Regra:** Sempre extraia `tournamentId = t.id` (UUID) a partir do slug e use esse UUID em todas as queries relacionais. Nunca passe o slug textual como FK.

---

## Banco de Dados — Tabelas Principais

### `profiles`
- `id` uuid PK (= `auth.users.id`)
- `email`, `full_name`, `avatar_url`
- `is_admin` boolean, `is_banned` boolean
- `riot_nick` text — nick padrão da Riot vinculado ao perfil

### `tournaments`
- `id` uuid PK
- `slug` text NOT NULL UNIQUE — chave semântica para URLs
- `name`, `description`, `status` (draft | open | ongoing | finished | cancelled)
- `max_teams`, `bracket_type`, `queue_type`
- `start_date` timestamptz, `end_date` timestamptz — colunas reais para escrita
- `starts_at`, `ends_at` — **GENERATED** a partir de `start_date`/`end_date` (somente leitura)
- `banner_url`, `featured` boolean
- `created_by` uuid → profiles.id

> ⚠️ **Importante:** Sempre use `start_date`/`end_date` em INSERTs e UPDATEs.  
> `starts_at`/`ends_at` são GENERATED e causam erro se incluídos no payload de update.

### `teams`
- `id` uuid PK
- `name`, `tag`, `logo_url`, `description`
- `captain_id` → profiles.id
- `tournament_id` → tournaments.id (FK obrigatória)
- Slug real em times: **previsto na migration 013** (não aplicada ainda)

### `players`
- `id` uuid PK
- `summoner_name` text, `tag_line` text (**com underscore** — colunas corretas no banco)
- `puuid` text
- `tier`, `rank`, `lp`, `wins`, `losses`, `role`
- `team_id` → teams.id (opcional)

> ⚠️ Atenção: migrations antigas escreviam `summonername`/`tagline` (sem underscore). Use sempre `summoner_name`/`tag_line`.

### `inscricoes`
- `id` uuid PK
- `tournament_id` → tournaments.id
- `team_id` → teams.id
- `status` text: `pending` | `approved` | `rejected` | `eliminated`
- `seed` int
- `checked_in_at` timestamptz

> ⚠️ Esta é a tabela real de inscrições. A tabela `tournament_teams` descrita em documentação antiga **não existe mais** no schema atual. Qualquer referência a ela deve ser migrada para `inscricoes`.

### `tournament_stages`
- `id` uuid PK
- `tournament_id` → tournaments.id
- `name`, `stage_type` (groups | playoffs | etc.), `order`

### `matches`
- `id` uuid PK
- `tournament_id` → tournaments.id
- `stage_id` → tournament_stages.id
- `team_a_id`, `team_b_id` → teams.id
- `winner_team_id` → teams.id
- `score_a`, `score_b`
- `status` text: `pending` | `ongoing` | `finished`
- `round`, `match_number`, `format` (BO1 | BO3 | BO5)

### `match_games`
- `id` uuid PK
- `match_id` → matches.id
- `game_number` int
- `winner_team_id` → teams.id
- `duration_seconds` int
- `riot_match_id` text — ID da partida na Riot API

### `player_stats`
- `id` uuid PK
- `game_id` → match_games.id
- `player_id` → players.id
- `kills`, `deaths`, `assists` int
- `champion`, `role`, `cs`, `gold_earned` etc.

### `notifications`
- `id` uuid PK
- `user_id` → profiles.id
- `type`, `message`, `read` boolean
- `created_at` timestamptz

### `audit_log`
- `id` uuid PK
- `action`, `target_table`, `target_id`, `performed_by`
- `details` jsonb, `created_at`

### `riot_accounts`
- `id` uuid PK
- `profile_id` → profiles.id
- `puuid`, `game_name`, `tagline`, `summoner_id`
- `is_primary` boolean

### `rank_snapshots`
- `id` uuid PK
- `riot_account_id` → riot_accounts.id
- `queue_type`, `tier`, `rank`, `lp`, `wins`, `losses`
- `snapshot_at` timestamptz

### `champion_masteries`
- `id` uuid PK
- `riot_account_id` → riot_accounts.id
- `champion_id`, `champion_name`, `mastery_level`, `mastery_points`

### Views
- `v_stage_standings` — classificação por fase do torneio
- `v_player_tournament_kda` — KDA médio por jogador por torneio

---

## Rotas Principais (App Router)

```
app/
├── page.tsx                          # Landing pública
├── torneios/
│   ├── page.tsx                      # Listagem pública de torneios
│   └── [slug]/
│       ├── page.tsx                  # Detalhe público do torneio
│       └── inscricoes/               # Inscrições abertas do torneio
├── times/
│   ├── page.tsx                      # Listagem pública de times
│   └── [slug]/page.tsx               # Detalhe público do time
├── jogadores/page.tsx                # Consulta pública de jogadores
├── ranking/page.tsx                  # Rankings e estatísticas globais
├── (auth)/
│   ├── login/page.tsx
│   ├── register/page.tsx
│   └── recuperar/page.tsx
├── dashboard/
│   ├── page.tsx                      # Overview pessoal do usuário logado
│   ├── times/
│   │   ├── page.tsx                  # Meus times
│   │   └── criar/page.tsx            # Criar time + inscrever em torneio
│   └── jogador/
│       └── registrar/page.tsx        # Vincular conta Riot ao profile
├── organizador/
│   └── torneios/
│       ├── novo/page.tsx             # Criar torneio
│       └── [id]/
│           ├── page.tsx              # Editar torneio
│           └── inscricoes/page.tsx   # Gerenciar inscrições
└── admin/
    ├── page.tsx                      # Overview admin
    ├── layout.tsx                    # Layout protegido (requer is_admin)
    ├── torneios/
    │   ├── page.tsx
    │   └── [slug]/page.tsx
    ├── jogadores/
    │   ├── page.tsx
    │   └── [slug]/page.tsx
    ├── usuarios/
    │   ├── page.tsx
    │   └── [slug]/page.tsx
    └── audit/page.tsx
```

---

## Acesso ao Supabase

`lib/supabase/` contém três clients:

| Arquivo | Uso | Chave |
|---|---|---|
| `client.ts` | Componentes client-side (browser) | `anon` |
| `server.ts` | Server Components e Actions (lê cookies de sessão) | `anon` + auth session |
| `admin.ts` | Edge Functions e scripts internos | `service_role` |

Nunca use o `admin.ts` em contextos expostos ao browser.

---

## Server Actions

`lib/actions/`:

| Arquivo | Actions |
|---|---|
| `tournament.ts` | `createTournament`, `updateTournament`, `deleteTournament` — valida com zod, exige `requireAdmin()` |
| `inscricao.ts` | `aprovarInscricao`, `rejeitarInscricao` — opera na tabela `inscricoes` |
| `partida.ts` | `editarResultadoPartida`, `atualizarStatusPartida` |
| `usuario.ts` | `banirUsuario`, `promoverAdmin`, `revogarAdmin` |

Após cada action bem-sucedida, usa `revalidatePath()` para invalidar o cache da rota afetada.

---

## Edge Functions

| Função | Trigger | Descrição |
|---|---|---|
| `bracket-generator` | POST admin | Gera partidas em single elimination |
| `riot-api-sync` | Agendado / manual | Sincroniza rank, maestrias e histórico via Riot API |
| `discord-webhook` | Eventos de torneio | Notifica canal Discord |
| `send-email` | Inscrição aprovada/rejeitada | Email transacional |

---

## Migrations

| Arquivo | Descrição |
|---|---|
| `001_initial_schema.sql` | Schema base: profiles, tournaments, teams, players, matches |
| `002_schema_expansion.sql` | Expansão de campos e enums |
| `003_audit_log.sql` | Tabela de auditoria |
| `004_seedings_players_triggers.sql` | Triggers de seed e jogadores |
| `005_demo_seed.sql` | Dados de demonstração |
| `006_demo_phases3-4.sql` | Fases 3 e 4 do torneio demo |
| `007_notifications_table.sql` | Tabela de notificações |
| `008_fix_core_schema.sql` | Normalização pós-snapshot 23/04 |
| `009_create_riot_accounts.sql` | Tabela `riot_accounts` e vínculos |
| `010_fix_notifications.sql` | Correções em `notifications` |
| `011_fix_triggers_and_functions.sql` | Triggers e funções revisados |
| `012_ensure_tournament_slug.sql` | Garante `slug` único e NOT NULL em `tournaments` |

### Próximas Migrations Previstas

| Arquivo | Descrição |
|---|---|
| `013_teams_slug.sql` | Adicionar `slug` em `teams` com backfill + unique index |

---

## Débitos Técnicos Mapeados

| Item | Situação |
|---|---|
| `tournament_teams` referenciada em `lib/actions/inscricao.ts` | ❌ Tabela não existe. Substituir por `inscricoes`. |
| Players com `summonername`/`tagline` (sem underscore) em código antigo | ❌ Usar `summoner_name`/`tag_line`. |
| `starts_at`/`ends_at` no payload de update | ❌ São GENERATED. Usar `start_date`/`end_date`. |
| Slug real para `teams` | ⏳ Previsto em `013_teams_slug.sql`. |
| `status` de torneios como string solta vs enum rígido | ⏳ Padronizar para minúsculo consistente ou enum. |
