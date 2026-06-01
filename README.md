# ⚔️ ArenaGG — GerenciadorDeTorneios-BRLOL

> Plataforma completa para torneios casuais de **League of Legends 5v5**
> com integração real à **Riot Games API v5**, backend em **Supabase** e frontend em **Next.js 16**.

[![Next.js](https://img.shields.io/badge/Next.js-16.2.6-black)](https://nextjs.org)
[![React](https://img.shields.io/badge/React-19.0.1-blue)](https://react.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-2.43.1-green)](https://supabase.com)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue)](https://typescriptlang.org)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-3.4.1-38bdf8)](https://tailwindcss.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

🌐 **Produção:** [arenagg.com.br](https://arenagg.com.br)

---

## 📚 Documentação técnica

| Arquivo | Conteúdo |
|---|---|
| [`docs/api/fluxos.md`](docs/api/fluxos.md) | Fluxos completos de negócio (auth, partida, inscrição, chaveamento, convites) |
| [`docs/api/REFERENCIA-API-RIOT.md`](docs/api/REFERENCIA-API-RIOT.md) | Todos os endpoints Riot usados, rate limiting, CDragon, callbacks |
| [`docs/api/SERVER-ACTIONS.md`](docs/api/SERVER-ACTIONS.md) | Todas as Server Actions (`'use server'`), tipos e padrões de retorno |
| [`docs/api/rotas-api.md`](docs/api/rotas-api.md) | Route Handlers (`app/api/**`) — contratos de request/response |
| [`docs/api/supabase.md`](docs/api/supabase.md) | Clientes Supabase (server/client/service), helpers de auth |
| [`docs/api/rate-limiting.md`](docs/api/rate-limiting.md) | Estratégia de rate limit para Riot API |
| [`docs/api/cron-monitoramento.md`](docs/api/cron-monitoramento.md) | Jobs cron (Vercel Cron Jobs), endpoints de monitoramento |
| [`docs/SCHEMA.md`](docs/SCHEMA.md) | Schema completo do banco (tabelas, enums, views, RPCs, RLS) |
| [`docs/ARQUITETURA-ATUAL.md`](docs/ARQUITETURA-ATUAL.md) | Stack e estrutura de pastas atualizada |
| [`docs/deploy.md`](docs/deploy.md) | Guia completo de deploy na Vercel |
| [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) | Problemas conhecidos e soluções |
| [`docs/PLANO-DE-TESTES.md`](docs/PLANO-DE-TESTES.md) | Estratégia de testes por módulo |

> ⚠️ **Fonte de verdade do banco:** `lib/database.types.ts` — sempre preferir sobre qualquer `.md`.

---

## 🎯 Visão geral do produto

O ArenaGG resolve o problema de organizar torneios casuais de LoL sem depender de plataformas externas pagas ou engessadas.

Principais capacidades:

- Vincular contas reais via **Riot ID** (`Nome#TAG`) com verificação de `puuid` na Riot API.
- Sincronizar elo/LP automaticamente via `rank_snapshots` e manter histórico de posição.
- Gerenciar **times, inscrições (`inscricoes`), seedings e chaveamentos** em 4 formatos: Single Elimination, Double Elimination, Round Robin e Swiss.
- Registrar resultados por jogo individualmente (`match_games`) com KDA, CS, dano, visão e MVP.
- Gerar **leaderboards** por torneio (`v_tournament_standings`) e globais (`v_player_leaderboard`).
- Integração com **Riot Tournament API** para geração de `tournament_codes` por partida e recebimento de callbacks automáticos de resultado.
- **RLS** em todas as tabelas, trilha de auditoria via `audit_log` e RPCs com controle de acesso (`is_admin`, `is_organizer_or_admin`).

---

## 🛠️ Stack tecnológica

| Camada | Tecnologia | Versão (package.json) |
|---|---|---|
| Framework web | Next.js — App Router + Server Components | `^16.2.6` |
| UI | React / React DOM | `^19.0.1` |
| Linguagem | TypeScript | `^5` |
| Backend / DB | Supabase — PostgreSQL + Auth + RLS + Edge Functions | `@supabase/supabase-js ^2.43.1` |
| Auth SSR | @supabase/ssr | `^0.6.1` |
| Estilização | Tailwind CSS + tailwind-merge + class-variance-authority | `^3.4.1` |
| Animações | framer-motion | `^11.3.0` |
| Formulários | React Hook Form + Zod | `^7.51.4` / `^3.23.8` |
| Resolvers | @hookform/resolvers | `^3.4.0` |
| Ícones | lucide-react | `^0.511.0` |
| Gráficos | Recharts | `^2.12.7` |
| Datas | date-fns | `^3.6.0` |
| Utilitários CSS | clsx + autoprefixer + postcss | `^2.1.1` / `^10.4.19` |
| API externa | Riot Games API v5 | — |
| Runtime | Node.js 24.x | Vercel |
| Dev bundler | Turbopack (`next dev --turbo`) | — |
| Tipos dev | tsx, @types/node, @types/react | `^4.21.0` / `^20` / `^19` |
| Linter | ESLint 9 + eslint-config-next | `^9.0.0` / `^16.0.0` |

---

## 🏗️ Arquitetura de rotas

O projeto usa **Next.js App Router** com 3 contextos de acesso distintos:

```
app/
├── (auth)/                      ← Login / registro (route group sem layout)
├── page.tsx                     ← Home pública
├── torneios/
│   └── [slug]/                  ← Página pública de torneio (qualquer usuário)
├── dashboard/                   ← Painel do jogador autenticado
├── profile/                     ← Perfil + vinculação de conta Riot
├── times/                       ← Listagem e gestão de times
│   └── [id]/
├── jogadores/                   ← Perfis públicos de jogadores
│   └── [id]/
├── ranking/                     ← Leaderboard global
├── organizador/                 ← Painel do organizador (guard: organizer_id OU is_admin)
│   └── torneios/[id]/**         ← Gestão completa do torneio
├── admin/                       ← Painel administrativo (guard: is_admin === true)
└── api/                         ← Route Handlers (server-side)
    ├── auth/callback/           ← OAuth callback Supabase
    ├── riot/                    ← Proxy Riot API (account, summoner, rank, mastery)
    ├── tournament/callback/     ← Webhook Riot Tournament API
    ├── internal/process-match/  ← Processamento interno de resultado de partida
    ├── teams/                   ← CRUD de times e membros
    ├── cron/                    ← Jobs agendados (Vercel Cron)
    └── status/                  ← Health check
```

### Regra de acesso ao painel de gestão

Guard aplicado via middleware/server component:

```
tournament.organizer_id === user.id  OU  profile.is_admin === true
→ senão: redirect('/torneios?error=sem_permissao')
```

---

## 🗄️ Banco de dados (Supabase)

Schema `public` com RLS habilitado em todas as tabelas. Fonte de verdade: `lib/database.types.ts`.

### Tabelas principais

| Grupo | Tabelas |
|---|---|
| **Usuários** | `profiles`, `riot_accounts`, `rank_snapshots`, `champion_masteries` |
| **Times** | `teams`, `team_members`, `team_invites`, `active_team` |
| **Torneios** | `tournaments`, `tournament_stages`, `tournament_rules`, `inscricoes`, `seedings`, `prize_distribution` |
| **Partidas** | `matches`, `match_games`, `player_stats`, `disputes` |
| **Riot Integration** | `riot_tournament_registrations`, `tournament_match_results` |
| **Sistema** | `notifications`, `audit_log`, `site_terms_acceptance` |

### Views disponíveis

- `profiles_with_riot` — perfil + conta Riot vinculada
- `v_tournament_standings` — classificação geral do torneio
- `v_stage_standings` — classificação por fase
- `v_player_leaderboard` — ranking global de jogadores
- `v_player_tournament_kda` — KDA do jogador por torneio

### RPCs (funções PostgreSQL)

| Função | Propósito |
|---|---|
| `is_admin` | Verifica se o usuário autenticado é admin |
| `is_current_user_admin` | Variante para uso em políticas RLS |
| `is_organizer_or_admin` | Organizador do torneio OU admin global |
| `is_tournament_organizer` | Somente organizador do torneio |
| `accept_team_invite` | Aceita convite e insere em `team_members` atomicamente |
| `log_admin_action` | Insere entrada em `audit_log` |

### Enums confirmados

| Enum | Valores |
|---|---|
| `tournament_status` | `DRAFT` · `OPEN` · `IN_PROGRESS` · `FINISHED` · `CANCELLED` |
| `bracket_type` | `SINGLE_ELIMINATION` · `DOUBLE_ELIMINATION` · `ROUND_ROBIN` · `SWISS` |
| `match_status` | `SCHEDULED` · `IN_PROGRESS` · `FINISHED` · `CANCELLED` · `WALKOVER` |
| `inscricao_status` | `PENDING` · `APPROVED` · `REJECTED` |
| `player_role` | `TOP` · `JUNGLE` · `MID` · `ADC` · `SUPPORT` |
| `team_member_role` | `captain` · `member` · `substitute` |
| `team_member_status` | `pending` · `accepted` · `rejected` · `left` |
| `invite_status` | `PENDING` · `ACCEPTED` · `DECLINED` · `EXPIRED` |
| `user_role` | `player` · `organizer` · `admin` |
| `dispute_status` | `OPEN` · `UNDER_REVIEW` · `RESOLVED` · `DISMISSED` |

---

## 🎮 Riot Games API

Integração implementada em `lib/riot.ts`, `lib/riot-cache.ts` e `lib/riot-rate-limiter.ts`.

| Endpoint | Região | Uso |
|---|---|---|
| `account-v1 /by-riot-id/{name}/{tag}` | `americas` | Resolver `puuid` na vinculação de conta |
| `summoner-v4 /by-puuid/{puuid}` | `br1` | Nível de invocador e ícone |
| `league-v4 /entries/by-summoner/{id}` | `br1` | Elo Solo/Flex — tier, rank, LP |
| `match-v5 /by-puuid/{puuid}/ids` | `americas` | Histórico de partidas |
| `match-v5 /matches/{matchId}` | `americas` | Detalhes completos da partida |
| `champion-mastery-v4 /by-puuid/{puuid}/top` | `br1` | Top 10 campeões |
| `tournament-v5` (ou stub) | `americas` | Registro de torneio + geração de `tournament_codes` |
| `status-v4` | `br1` | Health check via cron |

### Assets CDragon

```
# Ícone de perfil
https://raw.communitydragon.org/16.10/plugins/rcp-be-lol-game-data/global/default/v1/profile-icons/{id}.jpg

# Splash de campeão
https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/champion-splashes/{championId}/{skinId}.jpg

# Ícone quadrado
https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/champion-icons/{championId}.png

# Item
https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/full-item-images/{itemId}.png
```

---

## 🔐 Variáveis de ambiente

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...        # ⚠️ nunca expor ao browser

# Riot Games
RIOT_API_KEY=RGAPI-xxxx-xxxx-xxxx-xxxx # ⚠️ nunca expor ao browser
RIOT_REGION=br1
RIOT_REGIONAL_HOST=americas

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
CRON_SECRET=string-aleatoria-longa      # ⚠️ valida chamadas de cron
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/...

# Riot Tournament (produção)
RIOT_TOURNAMENT_CALLBACK_URL=https://arenagg.com.br/api/tournament/callback
```

> Copie `.env.example` para `.env.local` e nunca commite `.env.local`.

---

## 🚀 Desenvolvimento local

**Pré-requisitos:** Node.js 24.x, conta Supabase, chave Riot API (Development ou Tournament).

```bash
# 1. Clonar
git clone https://github.com/luanscps/GerenciadorDeTorneios-BRLOL.git
cd GerenciadorDeTorneios-BRLOL

# 2. Instalar dependências
npm install

# 3. Configurar ambiente
cp .env.example .env.local
# Preencher .env.local com as chaves

# 4. Aplicar migrations no Supabase
npx supabase db push

# 5. Rodar em desenvolvimento (Turbopack)
npm run dev
# → http://localhost:3000
```

### Scripts disponíveis

| Script | Descrição |
|---|---|
| `npm run dev` | Servidor de desenvolvimento com Turbopack |
| `npm run build` | Build de produção |
| `npm run start` | Serve o build de produção localmente |
| `npm run lint` | ESLint 9 com regras Next.js |

---

## ☁️ Deploy

Consulte [`docs/deploy.md`](docs/deploy.md) para o guia completo.

**Resumo rápido:**
1. Importar repositório em [vercel.com/new](https://vercel.com/new)
2. Configurar todas as variáveis de ambiente no painel da Vercel
3. Push na branch `main` → deploy automático
4. Configurar Vercel Cron Jobs para os endpoints em `app/api/cron/`

**Links do projeto:**

- 🌐 Produção: [arenagg.com.br](https://arenagg.com.br)
- 📊 Supabase: [supabase.com/dashboard/project/awbieglbwhfavxlghuvy](https://supabase.com/dashboard/project/awbieglbwhfavxlghuvy)
- 🚀 Vercel: [vercel.com/ludevbr/gerenciador-de-torneios-brlol](https://vercel.com/ludevbr/gerenciador-de-torneios-brlol)

---

## 📄 Licença

MIT © [Luan](https://github.com/luanscps)
