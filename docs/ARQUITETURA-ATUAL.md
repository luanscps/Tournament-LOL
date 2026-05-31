# Arquitetura Atual — GerenciadorDeTorneios-BRLOL

> **Fonte de verdade:** [`BRLOL-DOCS-UNIFICADO.md`](./BRLOL-DOCS-UNIFICADO.md) — seções 2, 3 e 10.
> Este arquivo existe para navegação rápida. Em caso de divergência, o código-fonte prevalece.

---

## Stack Tecnológica (resumo)

| Camada | Tecnologia | Versão |
|---|---|---|
| Framework | Next.js (App Router) | ^16.2.6 |
| UI | React / React DOM | ^19.0.1 |
| Linguagem | TypeScript | ^5 |
| Banco / Auth | Supabase (PostgreSQL + RLS) | @supabase/supabase-js ^2.43.1 |
| Auth SSR | @supabase/ssr | ^0.6.1 |
| Estilo | Tailwind CSS + tailwind-merge + CVA | ^3.4.1 |
| Animações | framer-motion | ^11.3.0 |
| Formulários | React Hook Form + Zod | ^7.51.4 / ^3.23.8 |
| Ícones | lucide-react | ^0.511.0 |
| Gráficos | Recharts | ^2.12.7 |
| Datas | date-fns | ^3.6.0 |
| Deploy | Vercel (Node.js 24.x) | — |

> Para a tabela completa com todas as dependências, veja `package.json`.

---

## Estrutura de Pastas (top-level)

```
GerenciadorDeTorneios-BRLOL/
├── app/                    # Next.js App Router
│   ├── (auth)/             # Login, registro, callback OAuth
│   ├── admin/              # Painel admin (is_admin = true)
│   ├── api/                # Route Handlers (riot, cron, admin, internal)
│   ├── dashboard/          # Dashboard do usuário logado
│   ├── jogadores/          # Listagem e perfil público de jogadores
│   ├── organizador/        # ⚠️ Área do organizador (pasta em PT-BR)
│   ├── profile/            # Perfil do usuário autenticado
│   ├── ranking/            # Ranking geral
│   ├── times/              # Gerenciamento de times
│   └── torneios/           # Listagem, detalhe e inscrição em torneios
├── components/             # Componentes React reutilizáveis
├── lib/
│   ├── actions/            # Server Actions ('use server')
│   ├── supabase/           # Clientes Supabase (client, server, admin)
│   ├── types/              # Tipos TypeScript de domínio
│   ├── validations/        # Schemas Zod centralizados
│   ├── database.types.ts   # Tipos gerados pelo Supabase CLI (não editar)
│   ├── riot.ts             # Chamadas à Riot API v5
│   ├── riot-cache.ts       # Cache em memória para Riot API
│   ├── riot-rate-limiter.ts
│   ├── riot-tournament.ts  # Integração Riot Tournament API
│   ├── rate-limit.ts
│   └── utils.ts
├── middleware.ts            # Auth guard SSR (Edge Runtime)
├── next.config.*
├── vercel.json             # Cron jobs da Vercel
└── .env.example
```

### ⚠️ Correção de nomenclatura — rota do organizador

Alguns documentos antigos referenciam `/organizer/` (inglês). **O caminho real no código é `/organizador/`** (PT-BR).

- ✅ Correto: `app/organizador/torneios/[id]/**`
- ❌ Errado (legado): `app/organizer/torneios/[id]/**`

---

## Três Contextos de Acesso

| Contexto | Rota base | Guard |
|---|---|---|
| Público | `/torneios/[slug]`, `/jogadores/`, `/ranking` | Nenhum |
| Organizador | `/organizador/torneios/[id]/**` | `organizer_id === user.id` OU `is_admin` |
| Admin global | `/admin/**` | `is_admin = true` (verificado no layout server-side) |

O middleware (`middleware.ts`) roda no **Edge Runtime** e protege `/dashboard`, `/admin` e `/torneios/inscrever`. A checagem de `is_admin` **não é feita no middleware** — ocorre no `layout.tsx` do grupo `/admin`.

---

## Diagrama Simplificado

```text
USUÁRIO / BROWSER
        │
        ▼
Next.js App Router (Vercel — Node.js 24.x)
  ├── Server Components → Supabase (server client)
  ├── Client Components → Supabase (browser client)
  ├── Server Actions    → lib/actions/
  └── Route Handlers   → app/api/
        │
        ├── Supabase (PostgreSQL + Auth + RLS)
        │     profiles, tournaments, teams, players,
        │     inscricoes, matches, match_games, player_stats,
        │     riot_accounts, rank_snapshots, champion_masteries…
        │
        └── Riot Games API v5
              account-v1 (americas) · summoner-v4 (br1)
              league-v4 · match-v5 · champion-mastery-v4
```

---

> Para detalhes de RLS, views de leaderboard, triggers, padrões de código e "O Que Nunca Fazer",
> consulte **[`BRLOL-DOCS-UNIFICADO.md`](./BRLOL-DOCS-UNIFICADO.md)**.
