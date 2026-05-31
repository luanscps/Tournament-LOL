# 📚 Documentação Unificada — GerenciadorDeTorneios-BRLOL

Este documento serve como a fonte principal e unificada de toda a documentação técnica e arquitetural do projeto GerenciadorDeTorneios-BRLOL. Ele consolida informações sobre a stack, arquitetura, padrões de código, integrações e diretrizes de desenvolvimento.

---

## 1. Contexto do Projeto

Este é um sistema web de gerenciamento de torneios de League of Legends voltado para o Brasil (BRLOL). A aplicação é full-stack, com backend via **Supabase** (PostgreSQL + Auth + RLS) e deploy na **Vercel** com **Next.js App Router**. Toda interação com dados de jogadores é feita via **Riot Games API** (região `br1`, regional `americas`).

O projeto é **open-source**, em desenvolvimento ativo, e o desenvolvedor principal é o único mantenedor.

---

## 2. Stack Técnica Exata

| Camada | Tecnologia | Versão |
|---|---|---|
| Framework | Next.js (App Router) | ^16.2.6 |
| UI | React / React DOM | ^19.0.1 |
| Linguagem | TypeScript | ^5 |
| Banco de dados | Supabase (PostgreSQL) | @supabase/supabase-js ^2.43.1 |
| Auth SSR | @supabase/ssr | ^0.6.1 |
| Estilo | Tailwind CSS | ^3.4.1 |
| Utilição de classes | tailwind-merge + clsx + CVA | ^2.3.0 / ^2.1.1 / ^0.7.0 |
| Animações | framer-motion | ^11.3.0 |
| Formulários | React Hook Form + Zod | ^7.51.4 / ^3.23.8 |
| Validação | @hookform/resolvers | ^3.4.0 |
| Ícones | lucide-react | ^0.511.0 |
| Gráficos | Recharts | ^2.12.7 |
| Datas | date-fns | ^3.6.0 |
| Deploy | Vercel (Node.js 24.x) | — |

> Fonte de verdade para versões: `package.json`. Nunca atualizar esta tabela sem conferir o arquivo.

---

## 3. Arquitetura e Estrutura de Pastas

```
GerenciadorDeTorneios-BRLOL/
├── app/                         # Next.js App Router
│   ├── (auth)/                  # Grupo de rotas: login, registro, callback
│   ├── admin/                   # Painel administrativo (requer is_admin = true)
│   ├── api/
│   │   ├── admin/               # Endpoints admin protegidos
│   │   ├── auth/                # Callback OAuth Supabase
│   │   ├── cron/                # Jobs agendados (Vercel Cron)
│   │   ├── internal/            # Endpoints internos (server-to-server)
│   │   ├── jogadores/           # Busca de jogadores via Riot API
│   │   ├── player/              # Perfil de jogador
│   │   ├── profile/             # Perfil do usuário autenticado
│   │   └── riot/                # Proxy Riot API
│   ├── dashboard/               # Dashboard do usuário logado
│   ├── jogadores/               # Listagem e perfil público de jogadores
│   ├── organizador/             # ⚠️ Área do organizador (PT-BR — não /organizer/)
│   ├── profile/                 # Perfil do usuário
│   ├── ranking/                 # Ranking geral
│   ├── times/                   # Gerenciamento de times
│   └── torneios/                # Listagem, detalhes e inscrição em torneios
├── components/
│   ├── admin/                   # Componentes do painel admin
│   ├── layout/                  # Header, Sidebar, Footer
│   ├── match/                   # Componentes de partidas
│   ├── profile/                 # Componentes de perfil de jogador
│   ├── times/                   # Componentes de times
│   ├── tournament/              # Componentes de torneios
│   └── ProfileIcon.tsx          # Ícone de perfil com borda animada por nível
├── lib/
│   ├── actions/                 # Server Actions do Next.js
│   │   ├── fase.ts              # Ações de fases do torneio
│   │   ├── ingest-match.ts      # Ingestão de partidas da Riot API → Supabase
│   │   ├── inscricao.ts         # Inscrição de times em torneios
│   │   ├── partida.ts           # CRUD de partidas
│   │   ├── roster.ts            # Gerenciamento de roster de times
│   │   ├── team_invite.ts       # Convites para times
│   │   ├── tournament.ts        # CRUD de torneios
│   │   └── usuario.ts           # Ações de usuário (perfil, etc.)
│   ├── supabase/
│   │   ├── client.ts            # Cliente browser (createBrowserClient)
│   │   ├── server.ts            # Cliente server (createServerClient + cookies)
│   │   └── admin.ts             # Cliente admin (service_role — uso restrito)
│   ├── types/
│   │   └── tournament.ts        # Tipos TypeScript do domínio
│   ├── validations/
│   │   └── index.ts             # Schemas Zod centralizados
│   ├── database.types.ts        # Tipos gerados automaticamente pelo Supabase CLI
│   ├── riot.ts                  # Todas as chamadas à Riot API + interfaces TypeScript
│   ├── riot-cache.ts            # Cache em memória para respostas da Riot API
│   ├── riot-rate-limiter.ts     # Rate limiter para a Riot API
│   ├── riot-tournament.ts       # Integração Riot Tournament API
│   ├── rate-limit.ts            # Rate limit genérico de endpoints
│   └── utils.ts                 # Funções utilitárias (cn, formatação, etc.)
├── middleware.ts                # Auth guard SSR via Supabase (edge runtime)
└── .env.example                  # Variáveis de ambiente necessárias
```

---

## 4. Padrões de Código Obrigatórios

### 4.1 Supabase — Clientes

Existem **três clientes distintos** — nunca misturar:

- **`lib/supabase/client.ts`** → `createBrowserClient()` — usar **apenas em Client Components** (`'use client'`). Nunca em Server Components, Actions ou Route Handlers.
- **`lib/supabase/server.ts`** → `createServerClient()` com `cookies()` do `next/headers` — usar em **Server Components, Route Handlers e Server Actions**. A função `setAll` **não tem try/catch** propositalmente (para não silenciar erros de token).
- **`lib/supabase/admin.ts`** → `createClient()` com `service_role` key — usar **apenas em Route Handlers server-side protegidos** (ex: `app/api/admin/`) e **nunca em Client Components ou expor para o browser**.

### 4.2 Autenticação e Middleware

- O `middleware.ts` roda no **Edge Runtime** e protege as rotas `/dashboard`, `/admin` e `/torneios/inscrever`.
- A checagem de `is_admin` **não é feita no middleware** (evita latência no edge); ela é feita no `layout.tsx` do grupo `/admin` via Server Component.
- O `redirectTo` é preservado via `searchParams` no redirect para `/login`.
- Ao modificar rotas protegidas, **atualizar o array `protectedRoutes`** no `middleware.ts`.

### 4.3 Server Actions

- Todas ficam em `lib/actions/`.
- Devem começar com `'use server'`.
- Validação sempre com **Zod** (schemas em `lib/validations/index.ts`).
- Autenticação verificada no início de cada action com `createClient()` do server.
- Erros retornam `{ error: string }` — nunca lançar exceções para o client.
- Usar `revalidatePath()` ou `revalidateTag()` após mutações.

### 4.4 Riot API

- **Nunca chamar a Riot API diretamente de Client Components**. Sempre via Route Handler (`app/api/riot/`) ou Server Action.
- Região padrão: `br1` (configurada em `RIOT_REGION`). O mapa `REGION_TO_REGIONAL` em `lib/riot.ts` resolve para `americas`.
- Cache em memória via `lib/riot-cache.ts` com TTLs definidos por endpoint:
  - `account`: 600s
  - `summoner`, `league`, `matchids`: 300s
  - `match` individual: 3600s
  - Versão DataDragon (`dd:version`): 3600s
- Rate limiter em `lib/riot-rate-limiter.ts` — usar para chamadas em batch.
- Assets de campeões: preferir **CommunityDragon** (`championIconByCDragon(id)`) ao DataDragon por nome, pois é mais confiável.
- Data Dragon com locale `pt_BR` (`getAllChampions()` usa `pt_BR`).

### 4.5 TypeScript

- Tipos do banco gerados pelo Supabase CLI em `lib/database.types.ts` — **não editar manualmente**.
- Tipos de domínio ficam em `lib/types/`.
- Interfaces da Riot API ficam em `lib/riot.ts` (junto das funções).
- Nunca usar `any` — usar `unknown` e narrowing quando necessário.

### 4.6 Componentes

- Client Components: `'use client'` no topo, formulários com `react-hook-form` + `zod`.
- Server Components: busca de dados diretamente com o cliente Supabase server.
- Ícones: **somente `lucide-react`**.
- Gráficos: **somente `recharts`**.
- Datas: **somente `date-fns`** (versão 3.x — API de imports diretos, não default).
- Animações: **somente `framer-motion`**.
- Estilo: **Tailwind CSS** — sem CSS-in-JS, sem styled-components.
- Combinação de classes: `cn()` de `lib/utils.ts` (usa `clsx` + `tailwind-merge`).

---

## 5. Variáveis de Ambiente

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=           # URL pública do projeto Supabase
NEXT_PUBLIC_SUPABASE_ANON_KEY=      # Chave anon (segura para o browser)
SUPABASE_SERVICE_ROLE_KEY=          # Chave service_role (NUNCA expor ao browser)

# Riot Games API
RIOT_API_KEY=                       # Chave da Riot (servidor apenas)
RIOT_REGION=br1                     # Plataforma padrão
RIOT_REGIONAL_HOST=americas         # Regional host (derivado do RIOT_REGION)

# App
NEXT_PUBLIC_APP_URL=                # URL pública da aplicação

# Cron / Webhooks (server-only)
CRON_SECRET=                        # Segredo para autenticação dos cron jobs
DISCORD_WEBHOOK_URL=                # Webhook Discord (opcional)
```

**Regra crítica:** variáveis sem prefixo `NEXT_PUBLIC_` são **server-only**. Nunca referenciar `SUPABASE_SERVICE_ROLE_KEY`, `RIOT_API_KEY` ou `CRON_SECRET` em código client-side.

---

## 6. Convenções de Rotas e API

| Rota | Tipo | Proteção |
|---|---|---|
| `/` | Public Page | Nenhuma |
| `/torneios/[slug]` | Public Page | Nenhuma |
| `/jogadores/[gameName]/[tagLine]` | Public Page | Nenhuma |
| `/ranking` | Public Page | Nenhuma |
| `/dashboard` | Protected Page | Middleware (user logado) |
| `/profile` | Protected Page | Middleware (user logado) |
| `/torneios/inscrever` | Protected Page | Middleware (user logado) |
| `/organizador/**` | Protected Page | Guard dual: `organizer_id === user.id` OU `is_admin` |
| `/admin/**` | Protected Page | Middleware + layout `is_admin` |
| `app/api/riot/**` | Route Handler | Server-only |
| `app/api/admin/**` | Route Handler | `service_role` + `is_admin` |
| `app/api/cron/**` | Route Handler | `CRON_SECRET` header |
| `app/api/internal/**` | Route Handler | Internal token |

> ⚠️ A rota do organizador é **`/organizador/`** (PT-BR). Documentações antigas com `/organizer/` estão incorretas.

---

## 7. Fluxo de Dados e Padrões de Busca

### Leitura de dados (Server Component):
```typescript
// ✅ Correto — Server Component
import { createClient } from '@/lib/supabase/server'

export default async function Page() {
  const supabase = await createClient()
  const { data, error } = await supabase.from('tournaments').select('*')
  // ...
}
```

### Mutação (Server Action):
```typescript
'use server'
import { createClient } from '@/lib/supabase/server'
import { TorneioSchema } from '@/lib/validations'

export async function criarTorneio(formData: FormData) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'Não autenticado' }

  const parsed = TorneioSchema.safeParse(Object.fromEntries(formData))
  if (!parsed.success) return { error: parsed.error.flatten() }

  const { error } = await supabase.from('tournaments').insert(parsed.data)
  if (error) return { error: error.message }

  revalidatePath('/torneios')
  return { success: true }
}
```

### Dados de Riot API (Route Handler):
```typescript
// app/api/riot/player/route.ts
import { getAccountByRiotId } from '@/lib/riot'

export async function GET(req: Request) {
  const { searchParams } = new URL(req.url)
  const gameName = searchParams.get('gameName')
  const tagLine = searchParams.get('tagLine')
  const account = await getAccountByRiotId(gameName!, tagLine!)
  return Response.json(account)
}
```

---

## 8. Banco de Dados — Supabase / PostgreSQL

- O schema tipado completo está em [`lib/database.types.ts`](lib/database.types.ts) — consultar sempre antes de criar queries.
- RLS (Row Level Security) está **ativo** — sempre usar o cliente correto (anon vs service_role).
- **Nunca editar `lib/database.types.ts` manualmente** — gerado via `supabase gen types typescript`.
- Ao adicionar novas tabelas ou colunas: rodar o comando e commitar o arquivo atualizado.

Para o schema detalhado (colunas, tipos, constraints, FKs, views e funções RPC), consulte [`docs/BANCO-DE-DADOS.md`](./BANCO-DE-DADOS.md) e [`docs/sql/`](./sql/).

**Tabelas Principais:** `profiles`, `tournaments`, `teams`, `players`, `riot_accounts`, `matches`, `match_games`, `tournament_stages`, `inscricoes`, `team_members`, `team_invites`, `player_stats`, `champion_masteries`, `rank_snapshots`, `notifications`, `disputes`, `audit_log`, `seedings`, `prize_distribution`, `site_terms_acceptance`, `tournament_match_results`, `tournament_rules`, `active_team`, `riot_tournament_registrations`

**Views:** `profiles_with_riot`, `v_tournament_standings`, `v_stage_standings`, `v_player_leaderboard`, `v_player_tournament_kda`

**Funções RPC:** `accept_team_invite`, `is_admin`, `is_current_user_admin`, `is_organizer_or_admin`, `is_tournament_organizer`, `log_admin_action`

**Enums:** `bracket_type`, `match_status`, `inscricao_status`, `invite_status`, `player_role`, `team_member_role`, `team_member_status`, `user_role`, `dispute_status`, `tournament_status`

---

## 9. Integração Riot API — Regras Específicas

- **Endpoint principal de busca de conta:** `getAccountByRiotId(gameName, tagLine)` → retorna `puuid`.
- **Fluxo padrão de lookup de jogador:**
  1. `getAccountByRiotId(gameName, tagLine)` → `puuid`
  2. `getSummonerByPuuid(puuid)` → `summonerId`, `profileIconId`, `summonerLevel`
  3. `getLeagueEntriesByPuuid(puuid)` → rank, LP, W/L
  4. `getTopMasteriesByPuuid(puuid)` → campeões mais jogados
- **Assets:**
  - Ícone de perfil: `profileIconUrl(id)` (DataDragon)
  - Ícone de campeão: `championIconByCDragon(championId)` (preferido) ou `championIconUrl(name)` (fallback)
  - Emblema de rank: `rankEmblemUrl(tier)` (CommunityDragon)
  - Borda de nível do perfil: `profileIconBorderStyle(level)` retorna `{ color, glow, label }` — aplicar via CSS inline
- **Rate limit:** usar `lib/riot-rate-limiter.ts` em operações de ingestão em batch (`lib/actions/ingest-match.ts`).

---

## 10. Deploy — Vercel

- Framework: **Next.js** com App Router.
- Node.js: **24.x** (configurado na Vercel).
- Dev local: `npm run dev` usa **Turbopack** automaticamente (`next dev --turbo`).
- Funções serverless: Route Handlers em `app/api/`.
- **Vercel Cron Jobs:** endpoints em `app/api/cron/` — configurados no `vercel.json`.
- Edge Runtime: apenas o `middleware.ts` roda no edge (sem Node.js APIs).
- Variáveis de ambiente: configuradas no painel Vercel (Production, Preview, Development separados).
- **Não usar `fs`, `path` ou APIs Node.js nativas** em código que possa rodar no edge.

Para instruções detalhadas de deploy, consulte [`docs/deploy.md`](./deploy.md).

---

## 11. O Que Nunca Fazer

- ❌ Usar `supabase.auth.getSession()` para verificar autenticação em server-side — usar sempre `supabase.auth.getUser()` (mais seguro).
- ❌ Importar `lib/supabase/admin.ts` em Client Components.
- ❌ Expor `RIOT_API_KEY`, `SUPABASE_SERVICE_ROLE_KEY` ou `CRON_SECRET` ao browser.
- ❌ Adicionar `try/catch` no `setAll` de cookies no `lib/supabase/server.ts` (já foi removido intencionalmente).
- ❌ Usar `localStorage` ou `sessionStorage` (bloqueado no contexto de deploy Vercel com SSR).
- ❌ Editar `lib/database.types.ts` manualmente.
- ❌ Chamar Riot API direto de Client Component.
- ❌ Usar qualquer biblioteca de datas que não seja `date-fns` v3.
- ❌ Usar qualquer biblioteca de animações que não seja `framer-motion`.
- ❌ Usar `any` no TypeScript.
- ❌ Criar CSS-in-JS, usar `styled-components` ou similares.
- ❌ Duplicar schemas Zod fora de `lib/validations/index.ts`.
- ❌ Referenciar rota `/organizer/` — o caminho correto é `/organizador/`.

---

## 12. Comandos Úteis

```bash
# Desenvolvimento local (Turbopack)
npm run dev

# Gerar tipos do Supabase (rodar após mudanças no schema do banco)
npx supabase gen types typescript --project-id awbieglbwhfavxlghuvy > lib/database.types.ts

# Build de produção
npm run build

# Lint
npm run lint
```

---

## Mandatos Críticos (Hard Gates)

1. **Segurança Primeiro:** NUNCA sugira um INSERT ou UPDATE sem uma política de RLS correspondente.
2. **Sincronia Riot:** Qualquer alteração em dados de jogadores deve considerar o delay de sincronização e o impacto nos créditos da API.
3. **Tradução:** Mantenha os termos de domínio do torneio conforme o banco (ex: `inscricoes` para o modelo, mas pode usar labels em PT-BR na UI).
4. **Nomenclatura de rotas:** A pasta do organizador é `app/organizador/` — não confundir com `/organizer/` de documentações antigas.
