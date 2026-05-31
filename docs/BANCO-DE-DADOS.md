# Banco de Dados — GerenciadorDeTorneios-BRLOL

> **Fonte de verdade absoluta:** `lib/database.types.ts` (gerado pelo Supabase CLI).
> **Documentação detalhada:** [`BRLOL-DOCS-UNIFICADO.md`](./BRLOL-DOCS-UNIFICADO.md) — seção 8.
> Em caso de divergência entre este arquivo e `database.types.ts`, o arquivo de tipos prevalece.

---

## Tecnologia

- **Supabase** (PostgreSQL gerenciado) com RLS ativo em todas as tabelas.
- Schema: `public` (único schema utilizado).
- Tipos TypeScript gerados via `supabase gen types typescript`.
- **Nunca editar `lib/database.types.ts` manualmente.**

---

## Tabelas Principais

| Tabela | Descrição |
|---|---|
| `profiles` | Espelha `auth.users`; guarda `is_admin`, dados básicos e Riot ID padrão |
| `riot_accounts` | Contas Riot vinculadas (`puuid`, `game_name`, `tag_line`) |
| `players` | Dados de jogador (posição, elo atual, referência ao perfil) |
| `teams` | Times cadastrados na plataforma |
| `team_members` | Membros de cada time (roles: `captain`, `member`, `substitute`) |
| `team_invites` | Convites para entrada em times |
| `tournaments` | Torneios (slug, status, bracket_type, max_teams, datas, regras) |
| `tournament_stages` | Fases de cada torneio |
| `inscricoes` | Pedidos de inscrição de times em torneios |
| `matches` | Partidas/séries entre times |
| `match_games` | Jogos individuais de cada partida |
| `player_stats` | Estatísticas por jogo (KDA, CS, dano, visão, MVP) |
| `champion_masteries` | Maestria de campeões por conta Riot |
| `rank_snapshots` | Histórico de elo/LP por jogador |
| `disputes` | Disputas de resultados de partidas |
| `notifications` | Notificações in-app por usuário |
| `prize_distribution` | Distribuição de premiação por torneio |
| `tournament_rules` | Regras específicas de cada torneio |
| `seedings` | Seedings de times por fase |
| `audit_log` | Trilha de auditoria de ações administrativas |
| `riot_tournament_registrations` | Registro de torneios na Riot Tournament API |
| `tournament_match_results` | Callbacks recebidos da Riot (tournament codes) |
| `active_team` | Time ativo atual do usuário |
| `site_terms_acceptance` | Aceites dos termos de uso |

---

## Views

| View | Descrição |
|---|---|
| `profiles_with_riot` | Join de `profiles` + `riot_accounts` |
| `v_tournament_standings` | Classificação geral de um torneio |
| `v_stage_standings` | Classificação por fase |
| `v_player_leaderboard` | Leaderboard global de jogadores |
| `v_player_tournament_kda` | KDA de jogadores por torneio |

---

## Enums

| Enum | Valores |
|---|---|
| `tournament_status` | `DRAFT` \| `OPEN` \| `IN_PROGRESS` \| `FINISHED` \| `CANCELLED` |
| `bracket_type` | `SINGLE_ELIMINATION` \| `DOUBLE_ELIMINATION` \| `ROUND_ROBIN` \| `SWISS` |
| `match_status` | `SCHEDULED` \| `IN_PROGRESS` \| `FINISHED` \| `CANCELLED` \| `WALKOVER` |
| `inscricao_status` | `PENDING` \| `APPROVED` \| `REJECTED` |
| `player_role` | `TOP` \| `JUNGLE` \| `MID` \| `ADC` \| `SUPPORT` |
| `team_member_role` | `captain` \| `member` \| `substitute` |
| `team_member_status` | `pending` \| `accepted` \| `rejected` \| `left` |
| `invite_status` | `PENDING` \| `ACCEPTED` \| `DECLINED` \| `EXPIRED` |
| `user_role` | `player` \| `organizer` \| `admin` |
| `dispute_status` | `OPEN` \| `UNDER_REVIEW` \| `RESOLVED` \| `DISMISSED` |

---

## Funções RPC

| Função | Descrição |
|---|---|
| `is_admin` | Retorna `true` se o usuário atual é admin global |
| `is_current_user_admin` | Alias de `is_admin` para uso em policies RLS |
| `is_organizer_or_admin` | `true` se organizador do torneio OU admin |
| `is_tournament_organizer` | `true` se o usuário é organizador do torneio informado |
| `accept_team_invite` | Aceita convite de time e atualiza `team_members` |
| `log_admin_action` | Registra ação administrativa em `audit_log` |

---

## Regras de Acesso (RLS)

- RLS ativo em **todas as tabelas públicas**.
- Nunca fazer INSERT/UPDATE sem política RLS correspondente.
- Usar **sempre** `supabase.auth.getUser()` no server-side (não `getSession()`).
- Cliente `admin` (service_role) só em `app/api/admin/` — nunca expor ao browser.

---

> Para o schema completo coluna a coluna (tipos, constraints, FKs), consulte
> [`docs/sql/`](./sql/) e a seção 8 do **[`BRLOL-DOCS-UNIFICADO.md`](./BRLOL-DOCS-UNIFICADO.md)**.
