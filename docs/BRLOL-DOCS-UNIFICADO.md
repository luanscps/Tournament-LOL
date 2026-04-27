# BRLOL Tournament Manager — Documentação Unificada

> Versão 2026-04-27 · Backend 100% Supabase · Frontend Next.js em desenvolvimento

Esta documentação substitui e unifica as descrições espalhadas em `docs/`, `docs/api/`, `docs/sql/`, `sql/` e `supabase/migrations/`.
Ela descreve a arquitetura atual, o schema real do banco (Supabase), as integrações com a Riot API, as Edge Functions e os fluxos principais de torneio.

---

## Visão geral da arquitetura

O GerenciadorDeTorneios-BRLOL é uma aplicação de gerenciamento de torneios de League of Legends com a seguinte stack:

- **Frontend:** Next.js (App Router), React, Tailwind; consumo direto da API do Supabase e rotas internas `/api/riot/*` para proxy da Riot API.
- **Backend primário:** Postgres gerenciado pelo Supabase (`schema public`), com RLS forte, funções SQL e triggers para auditoria, timestamps e automatizações de torneio.
- **Auth:** Supabase Auth, com tabela `profiles` espelhando `auth.users` e função `is_admin(uuid)` para RBAC.
- **Edge Functions Supabase:**
  - `bracket-generator`: gera chaves (single elimination, round robin, swiss) a partir de times aprovados e/ou seedings.
  - `send-email`: dispara emails via Resend para eventos como inscrição pendente/aprovada/rejeitada, partida agendada e resultado final.
  - `riot-api-sync`: sincroniza jogadores com a Riot API (tier, LP, vitórias, derrotas, ícone, nível).
  - `discord-webhook`: posta eventos de torneio (inscrições, partidas, início de torneio) em um canal via Webhook do Discord.
- **Integrações externas:**
  - Riot Games API (Account-V1, Summoner-V4, League-V4, Match-V5, Champion-Mastery-V4, Spectator-V5).
  - Data Dragon (assets estáticos de campeões, itens, ícones, runas).
  - Resend (e-mail transacional) via Edge Function.
  - Discord Webhooks para notificações de torneio.

Toda a lógica de negócio crítica (RLS, integridade referencial, audit log, seedings, standings, KDA, etc.) está implementada no banco; o foco atual do projeto é concluir o frontend (Fases 3 e 4).

---

## Modelo de dados — schema público Supabase

### Enums de domínio

Definidos nas primeiras migrações (`001_initial_schema.sql`):

- `tournament_status`: `DRAFT`, `OPEN`, `IN_PROGRESS`, `FINISHED`, `CANCELLED`.
- `bracket_type`: `SINGLE_ELIMINATION`, `DOUBLE_ELIMINATION`, `ROUND_ROBIN`, `SWISS`.
- `match_status`: `SCHEDULED`, `IN_PROGRESS`, `FINISHED`.
- `inscricao_status`: `PENDING`, `APPROVED`, `REJECTED`.
- `player_role`: `TOP`, `JUNGLE`, `MID`, `ADC`, `SUPPORT`.

Algumas colunas usam `text` com default baseado nesses enums, mas a semântica esperada é sempre esse conjunto de valores.

### profiles

Espelha `auth.users` com metadados de perfil.

- PK: `id uuid` (FK para `auth.users.id`).
- Campos principais: `email`, `full_name`, `avatar_url`, `is_admin`, `is_banned`, `riot_game_name`, `riot_tag_line`, `created_at`, `updated_at`.
- Trigger `handle_new_user` cria automaticamente um profile ao registrar usuário.
- Função `is_admin(uid uuid)` centraliza checagem de admin e é usada em policies de RLS.

### tournaments

Tabela principal de torneios.

- PK: `id uuid` (default `uuid_generate_v4()`).
- Campos:
  - `name text` — nome exibido.
  - `description text` — descrição longa.
  - `status tournament_status` — fase do torneio.
  - `bracket_type bracket_type` — tipo de chave.
  - `max_teams integer` — limite de times, com check `>= 2`.
  - `prize_pool text` — premiação.
  - `start_date timestamptz`, `end_date timestamptz`.
  - `created_by uuid` — FK para `profiles.id` (admin criador).
  - `min_tier text` — elo mínimo recomendado/obrigatório para inscrição.
  - `discord_webhook_url text` — URL de webhook para notificações no Discord.
  - `slug text` — NOT NULL, UNIQUE; preenchido por trigger automática.
  - `featured boolean` — destaque na vitrine.
  - `banner_url text` — banner do torneio.
  - `registration_deadline timestamptz` — data limite de inscrição.
  - `created_at timestamptz`, `updated_at timestamptz` (com trigger `set_updated_at`).

RLS: leitura pública; criação/edição/remoção restritas a admins via `is_admin(auth.uid())`.

### teams

Times inscritos em um torneio.

- PK: `id uuid`.
- FKs: `tournament_id → tournaments.id`, `owner_id → profiles.id`.
- Campos: `name`, `tag` (única por torneio, ex.: ABC), `logo_url`, `is_eliminated boolean`, timestamps.

### players

Jogadores (summoners) vinculados a times e usados para estatísticas.

- PK: `id uuid`.
- FKs: `team_id → teams.id` (nullable).
- Campos Riot: `summoner_name`, `tag_line` (corrigido por migration dedicada), `puuid`, `profile_icon`, `summoner_level`.
- Elo atual: `tier`, `rank`, `lp`, `wins`, `losses`.
- Outros: `role player_role`, `last_synced timestamptz`, timestamps.
- Índices importantes em `puuid`, `team_id` e combinações usadas em views de leaderboard.

O vínculo sempre é por `team_id` (UUID real), nunca por slug.

### inscricoes

Pedidos de inscrição de times em torneios.

- PK: `id uuid`.
- FKs: `tournament_id → tournaments.id`, `team_id → teams.id`, `requested_by → profiles.id`, `reviewed_by → profiles.id`.
- Campos: `status inscricao_status`, `notes`, `checked_in_at`, timestamps.
- Índices de apoio em `team_id`, `tournament_id`, `requested_by`, `(tournament_id, status)`.

### tournament_stages

Fases de um torneio (Grupos, Quartas, Semis, Final...).

- PK: `id uuid`.
- FK: `tournament_id → tournaments.id`.
- Campos: `name`, `stage_order`, `bracket_type`, `best_of`, timestamps.

### matches

Partidas (séries) entre dois times.

- PK: `id uuid`.
- FKs: `tournament_id → tournaments.id`, `team_a_id/team_b_id/winner_id → teams.id`, `stage_id → tournament_stages.id`.
- Campos: `round`, `match_order`, `status match_status`, `score_a`, `score_b`, `format` (`BO1`, `BO3`, `BO5`), `riot_match_id`, `scheduled_at`, `played_at`, `notes`, timestamps.

### match_games

Jogos individuais dentro de uma série.

- PK: `id uuid`.
- FKs: `match_id → matches.id`, `winner_id → teams.id`.
- Campos: `game_number`, `riot_game_id`, `duration_sec`, `picks_bans jsonb`, `played_at`, `created_at`.

### player_stats

Estatísticas por jogador por jogo.

- PK: `id uuid`.
- FKs: `game_id → match_games.id`, `player_id → players.id`, `team_id → teams.id`.
- Campos: `champion`, `kills`, `deaths`, `assists`, `cs`, `vision_score`, `damage_dealt`, `is_mvp`, `created_at`.

Base para as views de KDA/leaderboard.

### notifications

Notificações in-app por usuário.

- PK: `id uuid`.
- FK: `user_id → profiles.id`.
- Campos: `type`, `title`, `body`, `read`, `metadata jsonb`, `expires_at`, `created_at`, `message`, `link`.

RLS garante que o usuário só acesse suas próprias notificações.

### audit_log

Trilha de auditoria de ações administrativas.

- PK: `id uuid`.
- FK: `admin_id → profiles.id`.
- Campos: `action`, `table_name`, `record_id`, `old_data jsonb`, `new_data jsonb`, `ip_address`, `user_agent`, `created_at`.

Leitura restrita a admins.

### riot_accounts, rank_snapshots, champion_masteries

Camada de persistência da integração com a Riot API.

#### riot_accounts

- PK: `id uuid`.
- FK: `profile_id → profiles.id`.
- Campos: `puuid UNIQUE`, `game_name`, `tagline`, `summoner_id`, `summoner_level`, `profile_icon_id`, `is_primary`, `created_at`, `updated_at`, além de uma coluna legada `tag_line`.
- Trigger garante no máximo uma conta primária por `profile_id`.

#### rank_snapshots

- PK: `id uuid`.
- FK: `riot_account_id → riot_accounts.id`.
- Campos: `queue_type`, `tier`, `rank`, `lp`, `wins`, `losses`, `hot_streak`, `snapshotted_at`.

#### champion_masteries

- PK: `id uuid`.
- FK: `riot_account_id → riot_accounts.id`.
- Campos: `champion_id`, `champion_name`, `mastery_level`, `mastery_points`, `last_play_time`, timestamps.

### prize_distribution, seedings, team_invites, disputes, tournament_rules

Tabelas extras para premiação, seedings, convites, disputas e regras de torneio.

- `prize_distribution`: faixas de premiação por torneio (posição, descrição, valor). Leitura pública; escrita apenas admin.
- `seedings`: seed sugerida/final por time em torneio. Leitura pública; escrita apenas admin (painel de seedings).
- `team_invites`: convites para jogadores entrarem em times. Visíveis ao owner do time e admins; policies garantem que só owners/admins criem/gerenciem convites.
- `disputes`: disputas/denúncias registradas por usuários autenticados; apenas o autor vê as próprias disputas; admins podem ler e atuar.
- `tournament_rules`: conjunto de regras por torneio; leitura pública, escrita apenas admin.

### Views principais

- `v_stage_standings`: standings de times por stage (wins, losses, winrate, pontos). Usa `security_invoker = true`.
- `v_player_tournament_kda`: KDA agregado por jogador em um torneio (kills, deaths, assists, kda_ratio, mvp_count), também com `security_invoker`.
- `v_player_leaderboard`: leaderboard global filtrável (tier, role, KDA, MVPs).

---

## Segurança, RLS e funções SQL auxiliares

### RLS por domínio

Após as migrations recentes de correção:

- Tabelas sensíveis (`notifications`, `audit_log`, `disputes`, `team_invites`) têm policies específicas por usuário/admin; não existe mais `INSERT ... USING (true)` aberto.
- Tabelas públicas (`tournaments`, `teams`, `prize_distribution`, `tournament_rules`, parte de `seedings`) são legíveis por todos; escrita apenas por admins.
- RLS de times/inscrições (`teams`, `inscricoes`) garante que capitão/owner gerencia seu próprio time/inscrição; admins podem ver e editar tudo.

### Funções SQL chave

- `handle_new_user()`: trigger em `auth.users` que cria `profiles`.
- `is_admin(uid uuid) returns boolean`: helper de RLS, baseado em `profiles.is_admin`.
- `set_updated_at()`: trigger genérica que atualiza `updated_at` em várias tabelas.
- `audit_matches_changes()`: usada para gravar diffs de `matches` em `audit_log`.
- `log_admin_action(p_action text, p_table_name text, p_record_id text, p_old_data jsonb, p_new_data jsonb)`: RPC central para auditoria.

Todas as funções tiveram `search_path` corrigido para evitar schema hijacking (tipicamente `public` ou `public,extensions`).

---

## Riot Games API — visão unificada

Abaixo está a visão consolidada da integração com a Riot, combinando documentação e implementação.

### Autenticação e rate limits

- Header obrigatório: `X-Riot-Token: RIOT_API_KEY`.
- Tipos de chave: `Development`, `Personal`, `Production` (Tournament API exige Production).
- Rate limits típicos (Development): ~20 req/1s, ~100 req/2min.
- Estratégia do projeto:
  - Cache em memória (Next.js `fetch` com `revalidate` + módulo `riot-cache`) para reduzir chamadas repetidas.
  - Edge Function `riot-api-sync` faz batch limitado (até 20 jogadores a cada 6 horas) para respeitar limites.

### Regiões

- Plataforma (servidor de jogo): `br1.api.riotgames.com` para Summoner, League, Mastery, Spectator.
- Regional (continental): `americas.api.riotgames.com` para Account-V1 e Match-V5.

### Endpoints utilizados

- **Account-V1** (host regional):
  - `GET /riot/account/v1/accounts/by-riot-id/{gameName}/{tagLine}` → `puuid`.
  - `GET /riot/account/v1/accounts/by-puuid/{puuid}` → usado para detectar mudança de nick.

- **Summoner-V4** (host plataforma):
  - `GET /lol/summoner/v4/summoners/by-puuid/{puuid}` → `profileIconId`, `summonerLevel`, `id` (summonerId).

- **League-V4** (host plataforma):
  - `GET /lol/league/v4/entries/by-summoner/{summonerId}` → entradas por fila (`RANKED_SOLO_5x5`, `RANKED_FLEX_SR`).

- **Match-V5** (host regional):
  - `GET /lol/match/v5/matches/by-puuid/{puuid}/ids` → lista de matchIds.
  - `GET /lol/match/v5/matches/{matchId}` → detalhes completos; mapeados para `match_games` e `player_stats`.
  - `GET /lol/match/v5/matches/{matchId}/timeline` → timeline (opcional, usado apenas no frontend).

- **Champion-Mastery-V4**:
  - `GET /lol/champion-mastery/v4/champion-masteries/by-puuid/{puuid}` e variante `/top` → maestrias usadas em perfil e stats.

- **Spectator-V5**:
  - `GET /lol/spectator/v5/active-games/by-summoner/{encryptedPUUID}` → usado em check-in (saber se jogador está em partida).

- **LOL-Status-V4**:
  - `GET /lol/status/v4/platform-data` → ver manutenção da Riot (painel admin).

### Data Dragon

- Versão configurada em `DD_VERSION` e usada para:
  - Ícone de campeão: `/cdn/{ver}/img/champion/{Champion}.png`.
  - Profile icon: `/cdn/{ver}/img/profileicon/{id}.png`.
  - Ícone de item: `/cdn/{ver}/img/item/{id}.png`.
  - Lista de campeões: `/cdn/{ver}/data/pt_BR/champion.json`.

---

## Edge Functions Supabase

As funções ficam em `supabase/functions/*` e são chamadas pelo backend ou por triggers SQL.

### bracket-generator

- Entrada: JSON `{ tournamentid: uuid, stageid?: uuid }`.
- Fluxo:
  1. Lê torneio em `tournaments` e stage principal em `tournament_stages`.
  2. Busca times aprovados (`inscricoes.status = APPROVED`) e, se existir, ordena por `seedings`; caso contrário, randomiza.
  3. Gera `matches` de acordo com `bracket_type` (single elim, round robin, swiss), tratando BYEs.
  4. Deleta matches existentes da stage antes de recriar.
  5. Registra ação em `audit_log` via `log_admin_action`.

### send-email

- Entrada: `{ type, to, data }` com `type` em: `inscricao_pendente`, `inscricao_aprovada`, `inscricao_rejeitada`, `partida_agendada`, `resultado_final`.
- Usa Resend (`RESEND_API_KEY`) com templates HTML.
- Tipicamente chamada por triggers que reagem a mudanças em `inscricoes` e `matches`.

### riot-api-sync

- Entrada opcional: `{ playerid }` para sincronizar um jogador específico; sem body, roda em batch.
- Fluxo em batch:
  1. Seleciona até 20 jogadores de `players` com `last_synced IS NULL` ou desatualizados (>6h).
  2. Resolve `puuid` via Account-V1 se faltando.
  3. Busca Summoner-V4 e League-V4 e atualiza `profile_icon`, `summoner_level`, `tier`, `rank`, `lp`, `wins`, `losses`, `last_synced`.

### discord-webhook

- Entrada: `{ type, tournamentid, data }` com tipos como `inscricao_aprovada`, `inscricao_rejeitada`, `partida_iniciada`, `partida_finalizada`, `torneio_iniciado`.
- Fluxo:
  1. Busca `discord_webhook_url` em `tournaments`.
  2. Monta embed JSON com campos dependentes de `type`.
  3. Dá POST no webhook do Discord.

---

## Fluxos principais de negócio

### 1. Cadastro e login

1. Usuário registra no Supabase Auth.
2. Trigger `handle_new_user` cria registro em `profiles` com `is_admin = false`.
3. Migration específica (`014_set_admin_luanscps.sql`) marca o dono do projeto como admin inicial.

### 2. Criação de torneio

1. Admin cria registro em `tournaments` com `name`, `bracket_type`, `max_teams`, datas, premiação.
2. Trigger/constraint garante `slug` único.
3. Admin cadastra `tournament_rules` e `prize_distribution`.

### 3. Times e roster

1. Usuário cria `teams` dentro de um torneio (quando permitido).
2. Adiciona jogadores em `players` com `summoner_name` e `tag_line`.
3. `riot-api-sync` pode preencher elo e ícone automaticamente.

### 4. Inscrição e check-in

1. Capitão cria `inscricoes` apontando para `team_id` e `tournament_id`.
2. Admin revisa (status, notas; `reviewed_by`, `reviewed_at`), disparando emails e webhooks.
3. No dia, capitão faz check-in (`checked_in_at`); admin acompanha em tempo real.

### 5. Seedings e geração de chave

1. Admin usa `seedings` + views de leaderboard para definir seeds.
2. Chama `bracket-generator` para gerar `matches` da fase.

### 6. Registro de resultados de partida

1. Para cada `match`, painel admin registra resultados por jogo:
   - Inserções em `match_games` com `game_number`, `winner_id`, `duration_sec`, `riot_game_id`, `picks_bans`.
   - 10 linhas em `player_stats` com KDA, CS, damage, vision, `is_mvp`.
2. Ao fechar a série, atualiza `matches.status`, `score_a`, `score_b`, `winner_id`; triggers alimentam `audit_log` e notificações.

### 7. Leaderboards e estatísticas

- `v_stage_standings`: standings por stage (vitórias, derrotas, pontos).
- `v_player_tournament_kda`: ranking de jogadores por torneio (KDA, MVPs, CS, damage).
- `v_player_leaderboard`: ranking global com filtros de tier, role, KDA, MVP, etc.

---

## Como esta documentação se relaciona com os demais arquivos em /docs

- Este arquivo é a **fonte única de verdade** sobre arquitetura, banco e integrações.
- Arquivos mais antigos em `docs/`, `docs/api/` e `docs/sql/` podem ser reduzidos para resumos focados e links para seções deste documento.
- Novos desenvolvedores devem começar lendo este arquivo antes de ir para planos de frontend (Fases 3/4) ou testes.

---

## Apêndice — Referência técnica de RLS e infra Supabase

### A.1 Visão geral de RLS no schema `public`

O projeto usa Row Level Security (RLS) de forma agressiva em praticamente todas as tabelas de domínio do schema `public` (profiles, tournaments, teams, players, inscrições, partidas, estatísticas, notificações, disputas, convites, etc.).
As policies foram desenhadas para garantir três princípios:

- **Leitura aberta quando faz sentido de produto** (ex.: lista de torneios, standings, regras), mesmo com RLS habilitado.
- **Mutação restrita ao “dono” lógico do registro** (jogador, capitão de time, organizador) com exceções explícitas para admins via funções `is_admin(...)` e `is_current_user_admin()`.
- **Administração sempre auditada**: updates sensíveis (ex.: em `matches`) geram registros em `audit_log` via triggers como `audit_matches_changes()` e funções como `log_admin_action(...)`.

A combinação usual é:

- `ALTER TABLE ... ENABLE ROW LEVEL SECURITY;`
- Policies do tipo `USING` e `WITH CHECK` referenciando `auth.uid()` e/ou funções `public.is_admin`, `public.is_organizer_or_admin` e `public.is_tournament_organizer`.

---

### A.2 Matriz resumida de RLS por tabela de domínio

A tabela abaixo resume o comportamento **esperado** de RLS nas principais tabelas do schema `public`, conforme o estado atual das migrations e do dump de produção (2026‑04‑27).

| Tabela                  | Leitura (SELECT)                                                                 | Escrita (INSERT/UPDATE/DELETE)                                                                                                   |
|-------------------------|-----------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| `profiles`              | Usuário lê apenas o próprio perfil; admins podem ler todos.                      | Apenas o próprio usuário pode atualizar campos não sensíveis (nome, avatar); flags administrativas (`is_admin`, `is_banned`) só admin. |
| `tournaments`           | Leitura pública (lista de torneios, detalhes).                                   | Criação/edição/remoção restritas a admins/organizadores, usando `is_admin(auth.uid())` e `is_organizer_or_admin(auth.uid())`.   |
| `tournament_stages`     | Leitura pública (usada para exibir fases).                                       | Apenas admins/organizadores do torneio podem criar/editar/remover fases.                                                         |
| `teams`                 | Leitura pública limitada ao necessário (lista de times por torneio, roster).     | INSERT/UPDATE/DELETE restritos ao owner (`owner_id = auth.uid()`) ou admin; RLS impede jogadores de alterarem times alheios.    |
| `team_members`          | Membros de um time veem apenas o próprio time; admins veem todos.                | Convites/aceites gerenciados por owner/admin; convidado só consegue sair (`status = left`) do time próprio.                     |
| `active_team`           | Usuário lê apenas a própria linha (`profile_id = auth.uid()`).                   | Atualizada principalmente por triggers (`auto_add_captain_as_member`, `accept_team_invite`); updates diretos são restritos.     |
| `players`               | Leitura pública (stats de jogadores, quando permitido pela UI).                  | Escrita feita por backend/admin e pela Edge Function `riot-api-sync`; policies evitam que usuário normal altere elo manualmente.|
| `inscricoes`            | Capitão/owner vê as próprias inscrições; admins veem todas.                      | INSERT permitido ao capitão/time; mudança de `status` (`PENDING`→`APPROVED/REJECTED`) restrita a admins/organizadores.          |
| `seedings`              | Leitura pública (para exibir seeds no bracket).                                  | Escrita apenas por admins/organizadores (definição de seeds manualmente ou via painel).                                         |
| `matches`               | Leitura pública (chave do torneio; scoreboard).                                  | Criação/edição/remoção restritas ao backend/organizador/admin; usada por `bracket-generator` e painel admin.                   |
| `match_games`           | Leitura pública (histórico de jogos).                                            | Escrita restrita a backend/admin (registro de jogos individuais, Riot ingest).                                                  |
| `player_stats`          | Leitura pública (leaderboards, KDA).                                             | Escrita restrita a backend/admin (ingest de stats de cada jogo).                                                                |
| `notifications`         | Usuário vê apenas notificações onde `user_id = auth.uid()`.                      | Escritas por triggers de domínio (`fn_notify_inscricao`, `trg_inscricao_*`) e por backend; usuário não insere linhas arbitrárias. |
| `audit_log`             | Apenas admins podem ler; usuários comuns não têm acesso.                         | Inserção via funções/trigger (`log_admin_action`, `audit_matches_changes`); não há UPDATE/DELETE direto para usuários comuns.   |
| `riot_accounts`         | Usuário lê somente contas vinculadas ao próprio profile; admins podem ler todas. | Escrita feita pela UI (vincular conta) e por sincronização, sempre filtrada por `profile_id = auth.uid()` ou admin.            |
| `rank_snapshots`        | Leitura pública para estatísticas; gravação interna.                             | Inserts feitos pelo backend/Edge Function; policies impedem alteração por usuário final.                                        |
| `champion_masteries`    | Leitura pública (visualização de maestrias).                                     | Escrita restrita ao backend/Edge Function.                                                                                      |
| `team_invites`          | Convidado e owner/admin veem convites relevantes; demais usuários não veem.      | Criação/gerência de convites apenas por owners/admin; convidado pode aceitar/recusar o próprio convite.                         |
| `disputes`              | Autor vê as próprias disputas; admins veem todas.                                | Criação por usuários autenticados; mudança de `status` (`OPEN`→`UNDER_REVIEW`/`RESOLVED`/`DISMISSED`) restrita a admins.       |
| `tournament_rules`      | Leitura pública (regras do torneio).                                             | Escrita apenas por admins/organizadores.                                                                                        |
| `site_terms_acceptance` | Usuário vê apenas seus próprios registros de aceite; admins podem inspecionar.   | Inserts normalmente feitos pela UI no primeiro acesso; não há atualização posterior, apenas novos registros de versão.         |
| `tournament_match_results` | Leitura restrita a admin/backoffice (dados brutos da Riot/Tournament Code).  | Escrita por ingest automática (Edge Function/processo backend); usuário final não insere/edita diretamente.                    |

> Observação: os nomes exatos de policies podem variar entre ambientes, mas o comportamento efetivo é o descrito acima.

---

### A.3 Funções auxiliares de RLS e papel de cada uma

Algumas funções SQL do schema `public` são usadas de forma recorrente em policies de RLS e triggers.

- `public.is_admin(uid uuid) returns boolean`  
  Retorna `true` se o usuário com `id = uid` tem permissão de administrador (via coluna booleana ou enum de `profiles`). Usada em policies do tipo “admin pode tudo”.

- `public.is_current_user_admin() returns boolean`  
  Atalho específico para `auth.uid()`; evita repetição de subqueries em policies. Ajuda a simplificar regras como “se for admin, ignora filtros adicionais”.

- `public.is_organizer_or_admin(uid uuid)`  
  Usa `profiles.role` (`user_role`) para permitir ações a organizadores e admins, por exemplo criação/edição de torneios e fases.

- `public.is_tournament_organizer(uid uuid, tid uuid)`  
  Verifica se o usuário é organizador (ou criador) de um torneio específico ou se é admin, usada em policies de `tournaments`, `tournament_stages`, `matches` e tabelas correlatas.

- `auth.uid()` / `auth.jwt()`  
  Helpers padrão do Supabase para acessar o usuário/autorização atual; aparecem nas policies como fonte de `uid` para funções acima.

Essas funções são todas `SECURITY DEFINER` e tiveram o `search_path` ajustado nas migrations para evitar ataques de hijacking de schema (permitindo que sejam usadas com segurança em policies).

---

### A.4 Infra Supabase: schemas `auth`, `realtime`, `storage`, `supabase_migrations`

Além do schema de domínio `public`, o Supabase mantém schemas auxiliares que **não devem ser alterados manualmente** via migrations de aplicação, salvo se você souber exatamente o que está fazendo.

#### A.4.1 Schema `auth`

Responsável por autenticação e identidade dos usuários:

- Tabelas principais:  
  - `auth.users` (usuários, credenciais, e‑mail, metadados).  
  - `auth.sessions`, `auth.refresh_tokens`, `auth.identities` (sessões, tokens de refresh, logins de provedores).  
  - Tabelas auxiliares de MFA e OAuth (`mfa_*`, `oauth_*`, `flow_state`, etc.).
- Funções utilitárias:  
  - `auth.uid()`, `auth.jwt()`, `auth.role()`, `auth.email()` — expõem dados de JWT para o banco; usadas nas policies de RLS do schema `public`.

**Boas práticas:**

- **Nunca** altere diretamente o schema de `auth` nas migrations de domínio; use as configurações do painel do Supabase para OAuth, providers e MFA.  
- Toda lógica de permissão entre usuários deve ser construída em `public.profiles` + funções `is_admin` / `is_organizer_or_admin`.

#### A.4.2 Schema `realtime`

Atende ao serviço de realtime do Supabase:

- Tipos e funções como `realtime.wal_column`, `realtime.apply_rls`, `realtime.list_changes`, `realtime.send`, `realtime.subscription_check_filters` são responsáveis por consumir o WAL e publicar mudanças em canais websockets.  
- Tabelas internas (`realtime.messages`, `realtime.subscription`, etc.) não são usadas diretamente pela aplicação.

**Boas práticas:**

- Não criar migrations alterando diretamente o comportamento de `realtime.*`; se precisar de realtime, use a interface do Supabase (channels, listeners) e configure apenas quais tabelas de `public` participam disso.

#### A.4.3 Schema `storage`

É o backend do Supabase Storage (buckets e arquivos):

- Tabelas centrais:  
  - `storage.buckets` — metadados de buckets.  
  - `storage.objects` — arquivos (chave, metadados, timestamps).
- Funções utilitárias:  
  - `storage.search_v2`, `storage.list_objects_with_delimiter`, `storage.allow_only_operation`, `storage.operation()`, etc.

**Boas práticas:**

- Não deletar/alterar diretamente linhas de `storage.objects`; use a API de Storage do Supabase para criar/listar/deletar arquivos.  
- Se precisar ajustar permissões de arquivos, crie policies específicas em `storage.objects` usando o painel ou migrations muito bem testadas.

#### A.4.4 Schema `supabase_migrations`

Schema interno usado pelo Supabase CLI para rastrear migrations aplicadas:

- Tabelas de controle (`schema_migrations` etc.) usadas para saber quais migrations já foram executadas.

**Boas práticas:**

- Nunca crie migrations que alterem o conteúdo de `supabase_migrations`; apenas deixe o CLI gerenciá-lo.  
- Para mudanças no banco, sempre crie migrations novas em `supabase/migrations/` e deixe o Supabase CLI aplicar/registrar essas mudanças.

---

### A.5 Recomendações práticas para evolução do schema

- **Novas tabelas de domínio**:  
  - Crie sempre no schema `public`.  
  - Habilite RLS assim que criar a tabela (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY`).  
  - Defina policies em termos de `auth.uid()` + funções auxiliares (`is_admin`, `is_organizer_or_admin`), nunca usando IDs “hardcoded”.

- **Novas funções SQL**:  
  - Defina `search_path` explicitamente (`SET search_path TO 'public'` ou `'public','extensions'`).  
  - Use `SECURITY DEFINER` apenas quando a função for usada em RLS ou precisar elevar privilégios; caso contrário, deixe como execução normal.

- **Auditoria e logs**:  
  - Prefira centralizar logs sensíveis em `audit_log` usando `log_admin_action(...)` e triggers dedicadas, mantendo o histórico consistente.
