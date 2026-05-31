# ⚔️ GerenciadorDeTorneios-BRLOL

> Plataforma completa para torneios casuais de **League of Legends 5v5**
> com integração real à **Riot Games API v5**, backend em **Supabase** e frontend em **Next.js**.

[![Next.js](https://img.shields.io/badge/Next.js-16-black)](https://nextjs.org)
[![React](https://img.shields.io/badge/React-19-blue)](https://react.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-green)](https://supabase.com)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue)](https://typescriptlang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📚 Documentação principal

Toda a documentação técnica do projeto foi unificada em:

- [`docs/BRLOL-DOCS-UNIFICADO.md`](docs/BRLOL-DOCS-UNIFICADO.md)

Lá você encontra:

- Visão geral da arquitetura (Next.js + Supabase + Riot API);
- Modelo de dados completo do Supabase (tabelas, enums, FKs, RLS);
- Integrações com a Riot Games API (endpoints usados, Data Dragon, fluxos);
- Fluxos principais de negócio (inscrição, seedings, geração de chave, resultados, leaderboards).

Outros documentos úteis:

- [`docs/SERVER-ACTIONS.md`](docs/SERVER-ACTIONS.md) — referência de Server Actions
- [`docs/ARQUITETURA-ATUAL.md`](docs/ARQUITETURA-ATUAL.md) — stack e estrutura de pastas
- [`docs/BANCO-DE-DADOS.md`](docs/BANCO-DE-DADOS.md) — tabelas, views, enums, RPC
- [`docs/FLUXOS.md`](docs/FLUXOS.md) — fluxos de negócio detalhados
- [`docs/deploy.md`](docs/deploy.md) — guia completo de deploy

---

## 🎯 Visão geral do produto

O BRLOL resolve o problema de organizar torneios casuais de LoL sem depender de plataformas externas pagas ou engessadas.

Principais capacidades:

- Vincular contas reais via **Riot ID** (`Nome#TAG`) e manter elo/LP atualizados automaticamente.
- Gerenciar **times, inscrições, check-in, seedings** e chaves (single elim, double elim, round robin, swiss).
- Registrar resultados por jogo (KDA, CS, dano, visão, MVP) e gerar **leaderboards** por torneio e globais.
- Aplicar **RLS forte** no Supabase, com trilha de auditoria (`audit_log`) para ações administrativas.

---

## 🛠️ Stack tecnológica

| Camada | Tecnologia | Versão |
|---|---|---|
| Framework web | Next.js (App Router) | ^16.2.6 |
| UI | React / React DOM | ^19.0.1 |
| Linguagem | TypeScript | ^5 |
| Backend / DB | Supabase (PostgreSQL + Auth + RLS) | @supabase/supabase-js ^2.43.1 |
| Auth SSR | @supabase/ssr | ^0.6.1 |
| Estilização | Tailwind CSS + tailwind-merge + CVA | ^3.4.1 |
| Animações | framer-motion | ^11.3.0 |
| Formulários | React Hook Form + Zod | ^7.51.4 / ^3.23.8 |
| Validação | @hookform/resolvers | ^3.4.0 |
| Ícones | lucide-react | ^0.511.0 |
| Gráficos | Recharts | ^2.12.7 |
| Datas | date-fns | ^3.6.0 |
| API externa | Riot Games API v5 | — |
| Deploy | Vercel (Node.js 24.x) | — |

---

## 🏗️ Arquitetura resumida

```text
USUÁRIO / BROWSER
        │
        ▼
Next.js (App Router, Vercel — Node.js 24.x)
  ├── Páginas / dashboard / admin / torneios
  ├── /organizador/**     ← área do organizador (PT-BR)
  └── Rotas /api/* (server-side)
        │
        ├── Supabase (Postgres + Auth + RLS)
        │     profiles, tournaments, teams, players,
        │     inscricoes, matches, match_games, player_stats,
        │     riot_accounts, rank_snapshots, champion_masteries…
        │
        └── Riot Games API v5
              account-v1 (americas) · summoner-v4 (br1)
              league-v4 · match-v5 · champion-mastery-v4
```

---

## 🗄️ Banco de dados (Supabase)

O banco roda em um projeto Supabase, usando apenas o schema `public` com RLS habilitado.

Entidades principais:

- **profiles** — espelha `auth.users`, guarda `is_admin`, dados básicos e Riot ID padrão.
- **tournaments** — torneios (slug, status, bracket_type, max_teams, datas, regras, webhook Discord).
- **teams / players / inscricoes** — times, jogadores e pedidos de inscrição em torneios.
- **matches / match_games / player_stats** — partidas (séries), jogos individuais e estatísticas detalhadas.
- **riot_accounts / rank_snapshots / champion_masteries** — camada de persistência da Riot API.
- **prize_distribution / seedings / team_invites / disputes / tournament_rules** — premiação, seedings, convites, disputas e regras.

Para o schema completo, consulte [`docs/BANCO-DE-DADOS.md`](docs/BANCO-DE-DADOS.md) e [`docs/sql/`](docs/sql/).

---

## 🎮 Riot Games API

A integração com a Riot API é feita via Route Handlers e helpers em `lib/riot.ts` + `lib/riot-cache.ts` + `lib/rate-limit.ts`.

Endpoints usados:

- **Account-V1 (REGIONAL, americas)** — resolve `puuid` a partir de `Nome#TAG`.
- **Summoner-V4 (PLATFORM, br1)** — nível e ícone do invocador.
- **League-V4 (PLATFORM)** — elo Solo/Flex (tier, rank, LP, wins, losses).
- **Match-V5 (REGIONAL)** — histórico de partidas e detalhes completos.
- **Champion-Mastery-V4 (PLATFORM)** — campeões mais jogados.
- **Status-V4 (PLATFORM)** — monitoramento via cron.

---

## 🔐 Variáveis de ambiente (resumo)

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...

# Riot Games
RIOT_API_KEY=RGAPI-xxxx-xxxx-xxxx-xxxx
RIOT_REGION=br1
RIOT_REGIONAL_HOST=americas

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
CRON_SECRET=string-aleatoria-grande
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/...
```

> **Nunca** expor `SUPABASE_SERVICE_ROLE_KEY`, `RIOT_API_KEY` ou `CRON_SECRET` ao browser.

---

## 🚀 Desenvolvimento local

Pré-requisitos: **Node.js 24.x**, conta Supabase, chave Riot API.

```bash
# 1. Clonar
git clone https://github.com/luanscps/GerenciadorDeTorneios-BRLOL.git
cd GerenciadorDeTorneios-BRLOL

# 2. Instalar dependências
npm install

# 3. Configurar ambiente
cp .env.example .env.local
# Preencher .env.local com as chaves do Supabase e da Riot

# 4. Aplicar schema/migrations no Supabase
npx supabase db push

# 5. Rodar em desenvolvimento (Turbopack)
npm run dev
# http://localhost:3000
```

Scripts:

- `npm run dev` — servidor de desenvolvimento com Turbopack.
- `npm run build` — build de produção.
- `npm run start` — serve o build.
- `npm run lint` — análise estática.

---

## ☁️ Deploy na Vercel

Consulte o guia completo em [`docs/deploy.md`](docs/deploy.md).

Resumo:
1. Importar repositório em [vercel.com/new](https://vercel.com/new).
2. Configurar variáveis de ambiente no painel.
3. Push na `main` → deploy automático em produção.

---

## 📄 Licença

MIT © [Luan](https://github.com/luanscps)
