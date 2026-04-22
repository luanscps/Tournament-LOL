# ⚔️ Tournament-LOL

> Plataforma completa para torneios casuais de **League of Legends 5v5**  
> com integração real à **Riot Games API v5**, bracket automático, ranking de invocadores e painel administrativo.

[![Deploy on Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/luanscps/Tournament-LOL)
[![Next.js](https://img.shields.io/badge/Next.js-14-black)](https://nextjs.org)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-green)](https://supabase.com)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue)](https://typescriptlang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📋 Índice

1. [Visão Geral](#-visão-geral)
2. [Stack Tecnológica](#-stack-tecnológica)
3. [Arquitetura do Sistema](#-arquitetura-do-sistema)
4. [Fluxos Principais](#-fluxos-principais)
5. [Estrutura de Pastas](#-estrutura-de-pastas)
6. [Banco de Dados](#-banco-de-dados)
7. [Riot Games API](#-riot-games-api)
8. [API Routes](#-api-routes)
9. [Componentes](#-componentes)
10. [Funções Utilitárias](#-funções-utilitárias)
11. [Sistema de Cache](#-sistema-de-cache)
12. [Rate Limiting](#-rate-limiting)
13. [Variáveis de Ambiente](#-variáveis-de-ambiente)
14. [Instalação e Execução](#-instalação-e-execução)
15. [Autenticação e Segurança](#-autenticação-e-segurança)
16. [Deploy na Vercel](#-deploy-na-vercel)
17. [Roadmap](#-roadmap)

---

## 🎯 Visão Geral

Tournament-LOL resolve o problema de organizar torneios casuais de LoL sem depender de plataformas externas pagas.

- ✔ Vincula contas reais via **Riot ID** (`Nome#TAG`)
- ✔ Bracket **single/double elimination**, Round Robin e Swiss
- ✔ Rank, maestrias, KDA e histórico via Riot API oficial
- ✔ **Row Level Security (RLS)** no Supabase
- ✔ Deploy automático na Vercel a cada push na `main`

---

## 🛠️ Stack Tecnológica

| Camada | Tecnologia | Versão |
|---|---|---|
| Framework | Next.js (App Router) | 14.2.x |
| Linguagem | TypeScript | 5.x |
| Estilização | Tailwind CSS | 3.4.x |
| Banco de Dados | Supabase (PostgreSQL 15) | latest |
| Autenticação | Supabase Auth (JWT + Cookie) | 2.x |
| API Externa | Riot Games API | v5 |
| Validação | Zod + React Hook Form | 3.x |
| Deploy | Vercel Edge Network | latest |
| Cache | In-Memory Map (TTL custom) | — |

---

## 🏗️ Arquitetura do Sistema

```text
┌──────────────────────────────────────────────────────────────┐
│                     USUÁRIO / BROWSER                        │
└───────────────────────────┬──────────────────────────────────┘
                            │ HTTPS
┌───────────────────────────▼──────────────────────────────────┐
│                  VERCEL EDGE NETWORK                         │
│                                                              │
│  ┌────────────────────┐  ┌─────────────┐  ┌──────────────┐  │
│  │  Server Components │  │   Client    │  │  API Routes  │  │
│  │    (RSC / SSR)     │  │  Components │  │  /api/riot/* │  │
│  └──────────┬─────────┘  └──────┬──────┘  └──────┬───────┘  │
└─────────────┼────────────────────┼────────────────┼──────────┘
              │                    │                │
              ▼                    ▼                ▼
┌─────────────────────────┐      ┌─────────────────────────────┐
│        SUPABASE          │      │     RIOT GAMES API v5       │
│                         │      │                             │
│  PostgreSQL 15          │      │  account-v1   (REGIONAL)    │
│  Auth JWT + Cookie      │      │  summoner-v4  (PLATFORM)    │
│  RLS Policies           │      │  league-v4    (PLATFORM)    │
│  14 Tabelas             │      │  match-v5     (REGIONAL)    │
│  2 Views SQL            │      │  mastery-v4   (PLATFORM)    │
└─────────────────────────┘      └─────────────────────────────┘
              ▲
┌─────────────┴───────────┐
│    IN-MEMORY CACHE       │
│  Map<key,{data,TTL}>    │
└─────────────────────────┘
```

---

## 🔄 Fluxos Principais

### Fluxo 1 — Vincular Conta Riot

```text
[Usuário digita Faker#KR1]
        │
        ▼
GET /api/riot/summoner?riotId=Faker%23KR1
        │
        ▼
┌──────────────┐  HIT   ┌─────────────────────────────┐
│ Cache Lookup ├───────►│ Retorna dados cacheados      │
└──────┬───────┘        └─────────────────────────────┘
    MISS│
        ▼
account-v1 → PUUID lookup
        │
        ▼  Promise.all (paralelo)
┌───────┬──────────┬────────────┐
▼       ▼          ▼            │
summ   league   mastery         │
 v4      v4       v4            │
nível  rank    top 5 camps      │
               └────────────────┘
        │
        ▼
Usuário confirma vincular conta
        │
        ▼
riot_accounts.upsert()
  ├── rank_snapshots     INSERT
  └── champion_masteries UPSERT
        │
        ▼
✅ Conta vinculada → Redirect /dashboard
```

### Fluxo 2 — Autenticação e Rotas Protegidas

```text
[Request chega no servidor]
        │
        ▼
middleware.ts executa primeiro
        │
        ▼
Rota protegida? (/dashboard ou /admin)
  ├── NÃO ──► Passa direto ✅
  └── SIM ──► Lê Cookie JWT
                  │
                  ▼
            JWT válido?
             ├── NÃO ──► 🔴 Redirect /login
             └── SIM ──► Rota /admin?
                           ├── NÃO ──► ✅ /dashboard liberado
                           └── SIM ──► profiles.is_admin = true?
                                         ├── NÃO ──► 🔴 Redirect /
                                         └── SIM ──► ✅ /admin liberado
```

### Fluxo 3 — Ciclo de Vida do Torneio

```text
[draft] ──► [open] ──► [checkin] ──► [ongoing] ──► [finished]
 📝 Criado   📋 Inscrições  ✅ Check-in   ⚔️ Ativo     🏆 Fim
                 │               │
                 └───────────────┴──► [cancelled] ❌
                                       Admin cancela
```

### Fluxo 4 — Cache + Rate Limit

```text
[Request GET /api/riot/*]
        │
        ▼
Rate Limiter por IP (sliding window)
  ├── EXCEDEU ──► 🔴 HTTP 429
  └── OK ──► Cache Lookup
               ├── HIT + TTL válido ──► ✅ Retorna cache
               └── MISS ou expirado
                        │
                        ▼
                  Riot API fetch real
                  ┌──────┴──────┐
                  ▼             ▼
               Sucesso      Erro (404/429)
                  │              │
                  ▼              └──► 🔴 Repassa erro
            setCached(TTL)
                  │
                  ▼
            ✅ Retorna dados
```

---

## 📁 Estrutura de Pastas

```text
tournament-lol/
│
├── app/
│   ├── (auth)/
│   │   ├── login/page.tsx              Login email/senha
│   │   └── register/page.tsx           Cadastro + metadados
│   ├── admin/
│   │   ├── layout.tsx                  Guard is_admin + sidebar
│   │   ├── page.tsx                    Dashboard KPIs
│   │   └── torneios/criar/page.tsx     Formulário novo torneio
│   ├── api/
│   │   ├── riot/summoner/route.ts      GET invocador completo
│   │   ├── riot/matches/route.ts       GET histórico partidas
│   │   ├── riot/match/[matchId]/       GET partida única
│   │   └── player/refresh-rank/        POST atualiza rank DB
│   ├── dashboard/
│   │   ├── page.tsx                    Perfil + times + torneios
│   │   └── jogador/registrar/          Vincular Riot ID
│   ├── ranking/page.tsx                Top 50 invocadores
│   ├── torneios/
│   │   ├── page.tsx                    Listagem + filtros status
│   │   └── [slug]/page.tsx             Bracket + standings + times
│   ├── globals.css                     Tema dark LoL + Tailwind layers
│   ├── layout.tsx                      Root: metadata + Navbar
│   └── page.tsx                        Home pública
│
├── components/
│   ├── layout/
│   │   └── Navbar.tsx                  Navbar responsiva + auth state
│   └── tournament/
│       ├── BracketView.tsx             Bracket visual por rounds
│       ├── StandingsTable.tsx          Tabela via SQL view
│       ├── TeamsList.tsx               Lista de times inscritos
│       └── TournamentCard.tsx          Card para grids
│
├── lib/
│   ├── riot.ts                         Endpoints Riot API v5
│   ├── riot-cache.ts                   Cache in-memory com TTL
│   ├── rate-limit.ts                   Rate limiter sliding window
│   ├── utils.ts                        formatRank, getTierColor, calcKDA
│   ├── validations/index.ts            Schemas Zod
│   └── supabase/
│       ├── client.ts                   createBrowserClient()
│       ├── server.ts                   createServerClient() + cookies
│       └── admin.ts                    Service Role bypass RLS
│
├── supabase/
│   └── schema.sql                      DDL: 14 tabelas + views + RLS
│
├── middleware.ts                        Auth guard rotas privadas
├── next.config.ts                       Remote images config
├── tailwind.config.ts                   Tema gold #C8A84B + dark #050D1A
├── vercel.json                          Deploy config
└── .env.example                         Template variáveis de ambiente
```

---

## 🗄️ Banco de Dados

Execute `supabase/schema.sql` no **SQL Editor** do Supabase.

### Diagrama das Tabelas

```text
[auth.users]
     │  trigger on signup
     ▼
[profiles]──────────────────────────────────────────┐
 id · username · display_name · is_admin            │
     │                            │ created_by      │
     │ 1:N                        ▼                 │
     │                     [tournaments]            │
     ▼                      slug · name · status    │
[riot_accounts]               queue_type · max_teams│
 puuid · game_name                 │ 1:N            │
 tag_line · summoner_level         ▼                │
 profile_icon_id             [teams] ◄──────────────┘
     │                        name · tag · seed  (captain)
     ├──► [rank_snapshots]         wins · losses
     │     tier · rank · lp             │ 1:N
     │     wins · losses                ▼
     │                          [team_members]
     └──► [champion_masteries]    role · position
           champion_id                  │
           mastery_level           [matches]
           mastery_points           round · score_a/b
                                    team_a/b · winner
── VIEWS SQL ──────────────────────────── │ 1:N ──
                                          ▼
v_tournament_standings              [match_reports]
 position · wins · points            status · screenshot

v_player_kda
 avg_kills · avg_deaths · avg_assists
```

### Tabelas — Colunas Principais

**`profiles`**
| Coluna | Tipo | Descrição |
|---|---|---|
| `id` | uuid | FK → auth.users.id |
| `username` | text | Único, min 3 chars |
| `display_name` | text | Nome público |
| `is_admin` | boolean | Acesso ao painel admin |

**`riot_accounts`**
| Coluna | Tipo | Descrição |
|---|---|---|
| `puuid` | text | ID único global Riot |
| `game_name` | text | Nome no Riot ID |
| `tag_line` | text | Tag (ex: BR1, KR1) |
| `summoner_level` | int | Nível da conta |
| `is_primary` | boolean | Conta principal do perfil |

**`rank_snapshots`**
| Coluna | Tipo | Descrição |
|---|---|---|
| `queue_type` | text | RANKED_SOLO_5x5 ou RANKED_FLEX_SR |
| `tier` | text | IRON → CHALLENGER |
| `rank` | text | I → IV |
| `lp` | int | League Points |
| `wins / losses` | int | Vitórias / derrotas |

**`tournaments`**
| Coluna | Tipo | Descrição |
|---|---|---|
| `slug` | text | URL amigável único |
| `status` | text | draft→open→checkin→ongoing→finished |
| `bracket_type` | text | single_elimination, double_elimination, round_robin, swiss |
| `max_teams` | int | 4–64 times |

**`matches`**
| Coluna | Tipo | Descrição |
|---|---|---|
| `round` | int | Número da rodada |
| `match_number` | int | Posição dentro da rodada |
| `score_a / score_b` | int | Placar de cada time |
| `status` | text | pending / ongoing / finished |

### RLS Policies

| Tabela | Leitura | Escrita |
|---|---|---|
| `tournaments` | Pública | is_admin = true |
| `teams · matches` | Pública | Owner do time |
| `riot_accounts` | Apenas owner | Apenas owner |
| `rank_snapshots` | Apenas owner | Sistema (API Route) |

---

## 🎮 Riot Games API

> Obtenha sua chave em: https://developer.riotgames.com

| Tipo | Rate Limit | Validade |
|---|---|---|
| Development Key | 20 req/s · 100 req/2min | 24h renovável |
| Production Key | 500 req/s (aprovação) | Permanente |

### Hosts por Região

```text
PLATFORM → https://{region}.api.riotgames.com
           br1 | na1 | euw1 | kr | eun1 | la1 | la2

REGIONAL → https://{host}.api.riotgames.com
           americas → br1, na1, la1, la2
           europe   → euw1, eun1, tr1, ru
           asia     → kr, jp1
```

### Endpoints Consumidos

```text
┌─ 1. account-v1 (REGIONAL) ────────────────────────────────┐
│ GET /riot/account/v1/accounts/by-riot-id/{name}/{tag}      │
│ Uso : Faker#KR1 → { puuid, gameName, tagLine }             │
│ TTL : 600s                                                 │
└────────────────────────────────────────────────────────────┘

┌─ 2. summoner-v4 (PLATFORM) ───────────────────────────────┐
│ GET /lol/summoner/v4/summoners/by-puuid/{puuid}            │
│ Ret : { id, profileIconId, summonerLevel }                 │
│ TTL : 300s                                                 │
└────────────────────────────────────────────────────────────┘

┌─ 3. league-v4 (PLATFORM) ─────────────────────────────────┐
│ GET /lol/league/v4/entries/by-summoner/{summonerId}        │
│ Ret : [{ queueType, tier, rank, lp, wins, losses }]        │
│ TTL : 300s                                                 │
└────────────────────────────────────────────────────────────┘

┌─ 4. champion-mastery-v4 (PLATFORM) ───────────────────────┐
│ GET /lol/champion-mastery/v4/.../top?count=5               │
│ Ret : [{ championId, championLevel, championPoints }]      │
│ TTL : 600s                                                 │
└────────────────────────────────────────────────────────────┘

┌─ 5. match-v5 IDs (REGIONAL) ──────────────────────────────┐
│ GET /lol/match/v5/matches/by-puuid/{puuid}/ids             │
│     ?count=20&queue=420                                    │
│ Queue IDs: 420=Solo · 440=Flex · 400=Normal · 450=ARAM     │
│ TTL : 120s                                                 │
└────────────────────────────────────────────────────────────┘

┌─ 6. match-v5 Detail (REGIONAL) ───────────────────────────┐
│ GET /lol/match/v5/matches/{matchId}                        │
│ Ret : 10 participantes com kills/deaths/assists/win        │
│ TTL : 3600s (dados históricos imutáveis)                   │
└────────────────────────────────────────────────────────────┘
```

### Interfaces TypeScript

```typescript
interface RiotAccount {
  puuid    : string
  gameName : string
  tagLine  : string
}

interface Summoner {
  id            : string
  profileIconId : number
  summonerLevel : number
}

interface LeagueEntry {
  queueType    : string   // "RANKED_SOLO_5x5"
  tier         : string   // "IRON" ... "CHALLENGER"
  rank         : string   // "I" | "II" | "III" | "IV"
  leaguePoints : number
  wins         : number
  losses       : number
  hotStreak    : boolean
}

interface ChampionMastery {
  championId     : number
  championLevel  : number   // 1–7
  championPoints : number
}

interface MatchParticipant {
  puuid              : string
  championName       : string
  kills              : number
  deaths             : number
  assists            : number
  win                : boolean
  teamId             : number   // 100=blue | 200=red
  individualPosition : string   // TOP|JUNGLE|MIDDLE|BOTTOM|UTILITY
}
```

### Data Dragon — Assets Estáticos

```text
Base: https://ddragon.leagueoflegends.com/cdn/14.10.1

Ícone perfil  → /img/profileicon/{profileIconId}.png
Ícone campeão → /img/champion/{championName}.png
Splash art    → /img/champion/splash/{championName}_0.jpg
```

---

## 🔌 API Routes

### `GET /api/riot/summoner?riotId=Nome%23TAG`

Busca account + summoner + rank + masteries em paralelo (`Promise.all`).

**Resposta 200:**
```json
{
  "account"  : { "puuid": "...", "gameName": "Faker", "tagLine": "KR1" },
  "summoner" : { "profileIconId": 6, "summonerLevel": 284 },
  "entries"  : [{ "queueType": "RANKED_SOLO_5x5", "tier": "CHALLENGER", "leaguePoints": 1432 }],
  "masteries": [{ "championId": 238, "championName": "Zed", "championLevel": 7 }]
}
```

| Status | Causa |
|---|---|
| `400` | Formato inválido — falta o `#` |
| `404` | Invocador não encontrado |
| `429` | Rate limit atingido |

### `GET /api/riot/matches?puuid=...&count=10&queue=420`
Retorna IDs + dados das últimas partidas (máx. 20).

### `GET /api/riot/match/[matchId]`
Dados completos de 1 partida: 10 participantes, duração, objetivos.

### `POST /api/player/refresh-rank`
Atualiza rank do jogador logado. Requer cookie de sessão.
```json
{ "puuid": "..." }
```

---

## 🧩 Componentes

| Componente | Descrição |
|---|---|
| `<Navbar />` | Auth state em tempo real, link admin condicional, logout |
| `<TournamentCard />` | Badge de status colorido, link para `/torneios/{slug}` |
| `<BracketView />` | Rounds visuais, gap `2^round × 12px`, vencedor em gold |
| `<StandingsTable />` | Colunas V/D/GW/GL/Pts via view SQL, eliminados em opacidade |
| `<TeamsList />` | Tag, capitão, membros, badges check-in e eliminado |

---

## 🛠️ Funções Utilitárias — `lib/utils.ts`

```typescript
formatRank("GOLD", "II", 75)          // → "GOLD II — 75 LP"
formatRank("CHALLENGER", "I", 1432)   // → "CHALLENGER 1432 LP"

getTierColor("CHALLENGER")  // → "#00D4FF"
getTierColor("DIAMOND")     // → "#99CCFF"
getTierColor("GOLD")        // → "#FFD700"
getTierColor("SILVER")      // → "#C0C0C0"
getTierColor("IRON")        // → "#8B7A6B"

getWinRate(30, 20)                    // → 60 (%)
getQueueLabel("RANKED_SOLO_5x5")      // → "Ranqueada Solo/Duo"
formatDuration(1842)                  // → "30m 42s"
calcKDA(8, 2, 12)                     // → "10.00"
calcKDA(5, 0, 3)                      // → "Perfect"
```

---

## ⚡ Sistema de Cache — `lib/riot-cache.ts`

```text
lib/riot.ts chama getCached(chave)
        │
   HIT + TTL válido ──────────────► ✅ Sem chamar a API
        │
   MISS ou expirado
        │
        ▼
   Riot API fetch (X-Riot-Token)
        │
        ▼
   setCached(chave, dados, TTL)
        │
        ▼
   ✅ Retorna dados frescos
```

| Função | TTL | Motivo |
|---|---|---|
| `getAccountByRiotId` | 600s | Riot ID muda raramente |
| `getSummonerByPuuid` | 300s | Nível e ícone mudam pouco |
| `getLeagueEntriesByPuuid` | 300s | Rank muda após partidas |
| `getTopMasteriesByPuuid` | 600s | Maestrias são acumulativas |
| `getMatchIdsByPuuid` | 120s | Novas partidas são frequentes |
| `getMatchById` | 3600s | Histórico é imutável |

---

## 🛡️ Rate Limiting — `lib/rate-limit.ts`

```typescript
rateLimit(ip, limit = 30, windowMs = 60_000)
// true  → request permitido
// false → HTTP 429
```

| Rota | Limite | Janela |
|---|---|---|
| `/api/riot/summoner` | 30 req | 60s |
| `/api/riot/matches` | 20 req | 60s |

---

## 🔐 Variáveis de Ambiente

Renomeie `.env.example` → `.env.local`:

```env
# SUPABASE — Dashboard → Settings → API
NEXT_PUBLIC_SUPABASE_URL=https://xxxxxxxxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIs...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIs...

# RIOT GAMES — developer.riotgames.com
RIOT_API_KEY=RGAPI-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
RIOT_REGION=br1
RIOT_REGIONAL_HOST=americas

# APP
NEXT_PUBLIC_SITE_URL=http://localhost:3000
```

> ⚠️ Nunca exponha `SUPABASE_SERVICE_ROLE_KEY` ou `RIOT_API_KEY` no frontend.

| Variável | Arquivo | Uso |
|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | `lib/supabase/*.ts` | URL base Supabase |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | `lib/supabase/client.ts` | Auth browser |
| `SUPABASE_SERVICE_ROLE_KEY` | `lib/supabase/admin.ts` | Bypass RLS |
| `RIOT_API_KEY` | `lib/riot.ts` | Header X-Riot-Token |
| `RIOT_REGION` | `lib/riot.ts` | Host plataforma |
| `RIOT_REGIONAL_HOST` | `lib/riot.ts` | Host regional |

---

## 🚀 Instalação e Execução

**Pré-requisitos:** Node.js 18+ · Supabase · Riot API Key

```bash
# 1. Clone
git clone https://github.com/luanscps/Tournament-LOL.git
cd Tournament-LOL

# 2. Dependências
npm install

# 3. Variáveis de ambiente
cp .env.example .env.local
# Edite .env.local com suas chaves

# 4. Schema SQL
# Supabase Dashboard → SQL Editor → cole supabase/schema.sql

# 5. Inicie
npm run dev
# http://localhost:3000
```

| Script | Descrição |
|---|---|
| `npm run dev` | Desenvolvimento com hot-reload |
| `npm run build` | Build de produção |
| `npm run start` | Serve o build gerado |
| `npm run lint` | ESLint em todo o projeto |

---

## 🔒 Autenticação e Segurança

```text
[signUp email + password]
        │
        ▼
Supabase Auth → email de confirmação
        │
        ▼  trigger automático
INSERT INTO profiles (id, username, display_name)
        │
        ▼
[Usuário confirma email]
        │
        ▼
signInWithPassword()
        │
        ▼
Cookie JWT httpOnly via @supabase/ssr
        │
        ▼
middleware.ts verifica em cada request
  ├── /dashboard → valida JWT
  └── /admin     → valida JWT + is_admin = true
```

---

## ☁️ Deploy na Vercel

```bash
npm i -g vercel
vercel login
vercel --prod
```

Ou importe em [vercel.com/new](https://vercel.com/new) e configure as variáveis:

```text
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
RIOT_API_KEY
RIOT_REGION
RIOT_REGIONAL_HOST
NEXT_PUBLIC_SITE_URL   ← URL da Vercel em produção
```

Cada push na `main` gera deploy automático. PRs geram **Preview Deployments**.

---

## 📌 Roadmap

- [ ] Página de inscrição de time (`/dashboard/time/criar`)
- [ ] Painel do capitão — gerenciar membros e check-in
- [ ] Report de resultado com upload de screenshot
- [ ] Geração automática de bracket ao fechar inscrições
- [ ] Notificações por email (Resend) para início de partidas
- [ ] Perfil público do jogador com histórico de torneios
- [ ] Webhook Discord com resultados em tempo real
- [ ] Sistema de ELO interno por torneio
- [ ] App mobile (Expo + React Native)

---

## 📄 Licença

MIT © [Luan](https://github.com/luanscps)
"""
