# Arquitetura atual — GerenciadorDeTorneios BRLOL

> Snapshot baseado no dump `sql/2026-04-25_122855.sql`, nas migrations Supabase `001`–`012` e no código da branch `main` (commit 90be28d3…).[cite:22][cite:24][cite:26][cite:31][cite:32][cite:33]

## Stack

| Camada      | Tecnologia                                      |
|-------------|-------------------------------------------------|
| Frontend    | Next.js 15.2.6 (App Router)                     |
| UI          | React 19 + Tailwind CSS 3.4                     |
| Auth/Banco  | Supabase (Postgres 17, RLS habilitado)          |
| Realtime    | Supabase Realtime                               |
| Edge/Jobs   | Supabase Edge Functions                         |
| Deploy      | Vercel                                          |
| Forms/Validação | react-hook-form + zod                       |
| Charts      | Recharts                                       |

As versões de Next.js, React, Tailwind e dependências vêm de `package.json`.[cite:38]

---

## Domínio principal

Entidades centrais do sistema (apenas schema `public`):[cite:31][cite:32][cite:33]

- `profiles` — espelha `auth.users` e guarda metadados do usuário (admin, banimento, nick Riot padrão).
- `tournaments` — torneios de LoL com slug, status, configurações de chave, datas e metadados visuais.
- `teams` — times inscritos em um torneio específico (FK obrigatória `tournament_id`).
- `players` — jogadores (summoner) vinculados opcionalmente a um time e usados para stats.
- `inscricoes` — pedido de inscrição de um time em um torneio, com status e check-in.
- `matches` — partidas de um torneio (inclui round, ordem, formato BO1/3/5 e times A/B).
- `tournament_stages` — fases de um torneio (grupos, playoffs, etc.), usadas para organizar `matches`.
- `match_games` — cada jogo individual dentro de uma série (ex.: BO3), ligado a `matches`.
- `player_stats` — estatísticas por jogador por jogo (`kills`, `deaths`, `assists`, etc.).
- `notifications` — notificações in‑app por usuário, integradas ao Realtime.
- `audit_log` — trilha de auditoria de ações administrativas.
- `riot_accounts` — contas Riot vinculadas a um `profile`, com controle de conta primária.
- `rank_snapshots` — snapshots de elo/rank por conta Riot e fila.
- `champion_masteries` — maestria de campeões por conta Riot.

Há também views derivadas para standings por fase (`v_stage_standings`) e KDA médio por torneio (`v_player_tournament_kda`).[cite:32]

---

## Rotas principais (App Router)

Estrutura de pastas sob `app/`:[cite:27]

- Público geral
  - `app/page.tsx` — landing page do projeto.
  - `app/torneios` — listagem e páginas públicas de torneios.
  - `app/times` — listagem e páginas públicas de times.
  - `app/ranking` — telas de ranking/estatísticas globais.
  - `app/jogadores` — consulta pública de jogadores.
- Dashboard do usuário autenticado
  - `app/dashboard/page.tsx` — visão geral pessoal (meus torneios/times/convites).[cite:39]
  - `app/dashboard/times` — gerenciamento de times do usuário.
  - `app/dashboard/jogador` — visão de conta Riot/jogador vinculada ao profile.
- Área de autenticação
  - `app/(auth)/login`, `app/(auth)/register`, etc. — fluxo de login/registro.
- Console administrativo
  - `app/admin/page.tsx` — visão geral administrativa.[cite:40]
  - `app/admin/torneios` — CRUD de torneios, fases e partidas.
  - `app/admin/jogadores` — ferramentas administrativas para jogadores.
  - `app/admin/usuarios` — gestão de profiles/admins.
  - `app/admin/audit` — visualização de `audit_log`.

As rotas usam o padrão App Router, com layouts específicos para as seções pública, dashboard e admin (`app/layout.tsx`, `app/admin/layout.tsx`).[cite:27][cite:40]

---

## Acesso ao Supabase

A camada de acesso ao Supabase está centralizada em `lib/supabase/*`:[cite:29]

- `client.ts` — cria o client de browser (chave `anon`, usado em componentes client‑side).
- `server.ts` — instancia um client "por request" no servidor, reaproveitando cookies de sessão.
- `admin.ts` — client com role de serviço (service role), usado apenas em contexts seguros (Edge Functions, scripts) para operações privilegiadas.

A autenticação usa `supabase.auth.getUser()` nas server actions e páginas server‑side para obter o usuário autenticado e garantir RLS correta.[cite:34][cite:35]

---

## Server Actions

Server Actions ficam em `lib/actions/*` e encapsulam operações de escrita, com validação e `revalidatePath`.

### Torneios (`lib/actions/tournament.ts`)

- `TournamentSchema` (zod) valida `name`, `slug`, `max_teams`, `starts_at` e `status` antes de escrever.[cite:34]
- `requireAdmin()` carrega o usuário via `supabase.auth.getUser()` e garante que `profiles.is_admin = true` antes de permitir a action.[cite:34]
- `createTournament(formData)` insere em `public.tournaments` os campos validados (incluindo `slug`), retorna `id` e `slug` e chama `revalidatePath("/admin/torneios")`.
- `updateTournament(id, formData)` atualiza o registro existente e invalida o cache tanto da listagem quanto da página de detalhes (`/admin/torneios/[id]`).
- `deleteTournament(id)` remove o torneio e invalida a listagem.

Observação: o campo `status` na tabela é `text` com default `'DRAFT'::tournament_status` e aceita text arbitrário; a action utiliza valores minúsculos (`"draft"`, `"open"`, `"checkin"`, `"ongoing"`, `"finished"`), que são coerentes com o tipo text mas diferentes do enum original maiúsculo.[cite:31][cite:34]

### Inscrições (`lib/actions/inscricao.ts`)

- `requireAdmin()` repete o padrão de verificar `profiles.is_admin` antes de qualquer alteração.[cite:35]
- `aprovarInscricao(teamId, tournamentId)` e `rejeitarInscricao(teamId, tournamentId)` fazem `update` em uma tabela chamada `tournament_teams`, mudando a coluna `status` para `"approved"` ou `"rejected"` e revalidando `/admin/torneios/[id]/inscricoes`.[cite:35]

**Divergência importante**: no schema atual do banco **não existe** a tabela `public.tournament_teams`; o relacionamento torneio–time é modelado por:[cite:31][cite:36]

- `teams.tournament_id` (FK obrigatória para `tournaments.id`).
- `inscricoes` (`tournament_id`, `team_id`, `status`, `checked_in_at`).

Isso significa que as actions atuais de inscrição não afetam o modelo real de inscrições (`inscricoes`) e podem ser a causa de telas vazias ou dados "sumindo" na dashboard ao mudar status, pois atualizam uma tabela inexistente.

### Outras actions

- `lib/actions/partida.ts` — atualiza resultado de partidas (`matches`) e possivelmente gera jogos em `match_games` e stats em `player_stats`.
- `lib/actions/usuario.ts` — atualiza dados de profile (nome completo, flags de admin/banimento etc.).[cite:30]

---

## Integração Riot API

A integração com a Riot API é feita via:

- `lib/riot.ts` — client HTTP de alto nível para endpoints da Riot (summoner, ranked, match history), com tipos utilitários para respostas.[cite:28]
- `lib/riot-cache.ts` — camada de cache in‑memory para evitar estouro de rate limit em chamadas repetidas.[cite:28]
- Edge Functions (em `supabase/functions`) expostas como webhooks/cron para sincronização assíncrona com a Riot API (rank snapshots, masteries, etc.).[cite:25]
- Tabelas `riot_accounts`, `rank_snapshots` e `champion_masteries` no banco para persistir dados consolidados da Riot.[cite:33]

`riot_accounts` mantém o vínculo entre `profiles` e contas Riot, com:

- `profile_id` → `profiles.id` (FK por UUID real).
- Colunas de identificação: `puuid`, `game_name`, `tagline`, `summoner_id`.
- Flags de controle: `is_primary` (garantido via trigger `ensure_single_primary_riot_account`).[cite:33]

`rank_snapshots` guarda snapshots de elo/rank por conta e fila (`queue_type`), enquanto `champion_masteries` registra maestria por campeão para aquela conta.[cite:33]

---

## Pontos de atenção / divergências código × banco

1. **Tabela `tournament_teams` vs `inscricoes`**  
   - A documentação antiga (`docs/arquitetura.md`) e `lib/actions/inscricao.ts` assumem uma tabela intermediária `tournament_teams` com colunas `status`, `seed`, `checked_in_at`.[cite:35][cite:37]
   - O dump atual do banco não possui `public.tournament_teams`; no lugar, existem `teams.tournament_id` e a tabela `inscricoes` com `(tournament_id, team_id, status, checked_in_at)` como fonte da verdade.[cite:31][cite:36]
   - Qualquer tela que dependa de `tournament_teams` precisa ser migrada para usar `inscricoes`/`teams` com FKs por UUID.

2. **Nome de colunas em `players`**  
   - O schema atual usa `tag_line` (com underscore) para o sufixo da conta Riot, conforme o dump (`CREATE TABLE public.players`).[cite:31]
   - A migration `008_fix_core_schema.sql` assume colunas `tagline` e `tagline_` e cria índices em `summonername`; isso não reflete o estado atual (colunas se chamam `summoner_name` e `tag_line`).[cite:36]
   - Qualquer código que use `players.tagline` ou `players.summonername` em vez de `tag_line` / `summoner_name` vai quebrar.

3. **Documentação antiga de arquitetura**  
   - `docs/arquitetura.md` ainda descreve `tournament_teams` e um subconjunto de colunas em `tournaments`/`teams` que não bate mais com o dump mais recente (por exemplo, não cita `featured`, `banner_url`, `registration_deadline`, `riot_game_name`, `riot_tag_line`).[cite:31][cite:32][cite:37]
   - Este arquivo (`ARQUITETURA-ATUAL.md`) deve ser considerado a referência de arquitetura atual; o antigo fica apenas como histórico.

4. **Enums vs strings em `tournaments.status`**  
   - O tipo no banco é `text` com default referenciando o enum `tournament_status` (`'DRAFT'::tournament_status`), mas não há constraint de enum no dump; o app escreve valores minúsculos.[cite:31][cite:34]
   - Padronizar isso (ou para enum forte, ou para strings minúsculas) é importante para evitar estados inconsistentes.

Este documento serve como base para refatorar server actions, corrigir queries e alinhar a documentação com o estado real do código + banco em 25/04/2026.
