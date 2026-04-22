# Arquitetura — Tournament-LOL

> Documentação técnica completa das integrações
> Backend · Frontend · API Riot Games v5
> Repositório: https://github.com/luanscps/Tournament-LOL

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Índice

  1. Visão Macro do Sistema
  2. Camada Frontend (Next.js)
  3. Camada Backend (API Routes + Supabase)
  4. Integração Riot Games API v5
  5. Fluxo Completo de Dados
  6. Autenticação e Segurança
  7. Sistema de Cache e Rate Limit
  8. Banco de Dados — Supabase
  9. Deploy e Infraestrutura

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 1. VISÃO MACRO DO SISTEMA

```
                        ┌─────────────────────────────┐
                        │      USUÁRIO / BROWSER       │
                        └──────────────┬──────────────┘
                                       │ HTTPS / TLS
                        ┌──────────────▼──────────────┐
                        │    VERCEL EDGE NETWORK       │
                        │    (CDN + Edge Functions)    │
                        └──────┬──────────────┬────────┘
                               │              │
               ┌───────────────▼───┐    ┌─────▼──────────────────┐
               │   FRONTEND         │    │   BACKEND               │
               │                   │    │                         │
               │  Next.js 14       │    │  API Routes             │
               │  App Router       │    │  /api/riot/summoner     │
               │  Server + Client  │    │  /api/riot/matches      │
               │  Components       │    │  /api/riot/match/[id]   │
               │  Tailwind CSS     │    │  /api/player/refresh    │
               │  shadcn/ui        │    │                         │
               └───────┬───────────┘    └──────┬──────────────────┘
                       │                       │
          ┌────────────▼──────┐     ┌──────────▼──────────────┐
          │    SUPABASE        │     │   RIOT GAMES API v5     │
          │                   │     │                         │
          │  PostgreSQL 15    │     │  americas.api.riotgames  │
          │  Auth (JWT)       │     │  br1.api.riotgames       │
          │  RLS Policies     │     │                         │
          │  14 Tabelas       │     │  account-v1             │
          │  2 Views SQL      │     │  summoner-v4            │
          │  Edge Functions   │     │  league-v4              │
          └───────────────────┘     │  match-v5               │
                                    │  mastery-v4             │
          ┌───────────────────┐     └─────────────────────────┘
          │  IN-MEMORY CACHE  │
          │  Map<key,{        │
          │    data, TTL      │
          │  }>               │
          └───────────────────┘
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 2. CAMADA FRONTEND (Next.js 14 App Router)

```
app/
│
├── (public) ─────────────────────────────────────────────
│   ├── /                    Home: torneios ativos + stats
│   ├── /ranking             Top 50 por elo via Supabase
│   └── /torneios
│       ├── /                Lista + filtros de status
│       └── /[slug]          Bracket + Standings + Times
│
├── (auth) ────────────────────────────────────────────────
│   ├── /login               signInWithPassword()
│   └── /register            signUp() + metadata
│
├── (protected) ───────────────────────────────────────────
│   └── /dashboard
│       ├── /                Perfil + times + histórico
│       └── /jogador/registrar  Vincular Riot ID
│
└── (admin) ───────────────────────────────────────────────
    └── /admin
        ├── /                KPIs gerais
        └── /torneios/criar  Formulário novo torneio
```

### Renderização por Rota

```
┌──────────────────────┬─────────────────┬────────────────────┐
│ Rota                 │ Estratégia      │ Motivo             │
├──────────────────────┼─────────────────┼────────────────────┤
│ /                    │ SSR             │ Torneios dinâmicos  │
│ /torneios            │ SSR             │ Lista atualizada    │
│ /torneios/[slug]     │ SSR + ISR       │ Bracket em tempo   │
│                      │                 │ real               │
│ /ranking             │ SSR             │ Rank ao vivo       │
│ /dashboard           │ SSR (auth)      │ Dados do usuário   │
│ /admin               │ SSR (is_admin)  │ Guard server-side  │
└──────────────────────┴─────────────────┴────────────────────┘
```

### Componentes e Responsabilidades

```
components/
│
├── layout/
│   └── Navbar.tsx
│       ├── onAuthStateChange()  → detecta login/logout
│       ├── profiles.is_admin    → exibe link /admin
│       └── supabase.auth.signOut()
│
└── tournament/
    ├── BracketView.tsx
    │   ├── Props: matches[]
    │   ├── Agrupa por round
    │   ├── Gap visual: 2^round × 12px
    │   └── Vencedor: gold #C8A84B
    │
    ├── StandingsTable.tsx
    │   ├── Props: standings[]
    │   ├── Fonte: VIEW v_tournament_standings
    │   ├── Colunas: # · Time · V · D · GW · GL · Pts
    │   └── Eliminados: opacity-40
    │
    ├── TeamsList.tsx
    │   ├── Props: teams[]
    │   ├── Exibe: tag · nome · capitão · membros
    │   └── Badges: check-in · eliminado
    │
    └── TournamentCard.tsx
        ├── Props: tournament{}
        ├── Badge status colorido por estado
        └── Link: /torneios/{slug}
```

### Fluxo de Dados no Frontend

```
Server Component (SSR)
        │
        ▼
createServerClient()  ←── Cookie JWT do browser
        │
        ▼
Supabase query direto (sem passar pela API Route)
        │
        ▼
Props passados para Client Components
        │
        ▼
Client Component hidrata com useState/useEffect
        │
        ▼  (se precisar de dados Riot)
fetch('/api/riot/summoner?riotId=...')
        │
        ▼
Exibe dados ao usuário
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 3. CAMADA BACKEND (API Routes + Supabase)

### Mapa das API Routes

```
app/api/
│
├── riot/
│   ├── summoner/route.ts
│   │   ├── Método  : GET
│   │   ├── Param   : ?riotId=Nome%23TAG
│   │   ├── Ações   : account-v1 → PUUID
│   │   │             Promise.all([summoner, league, mastery])
│   │   ├── Cache   : por chave "account:{riotId}"
│   │   └── Retorna : { account, summoner, entries, masteries }
│   │
│   ├── matches/route.ts
│   │   ├── Método  : GET
│   │   ├── Params  : ?puuid=...&count=20&queue=420
│   │   ├── Ações   : match-v5 IDs → detalhes em paralelo
│   │   └── Retorna : matches[]
│   │
│   └── match/[matchId]/route.ts
│       ├── Método  : GET
│       ├── Param   : matchId no path
│       └── Retorna : dados completos da partida
│
└── player/
    └── refresh-rank/route.ts
        ├── Método  : POST
        ├── Auth    : cookie JWT obrigatório
        ├── Body    : { puuid }
        ├── Ações   : league-v4 → INSERT rank_snapshots
        └── Retorna : { updated: true }
```

### Pipeline de uma API Route

```
Request chega em /api/riot/summoner
        │
        ▼
┌── Middleware (rate-limit.ts) ──────────────────────────────┐
│   rateLimit(ip, 30, 60000)                                 │
│   ├── BLOQUEADO ──► return 429                             │
│   └── OK ──────────────────────────────────────────────►  │
└────────────────────────────────────────────────────────────┘
        │
        ▼
Valida parâmetros (Zod)
  ├── Inválido ──► return 400
  └── OK
        │
        ▼
getCached("account:faker#kr1")
  ├── HIT ──► return 200 (cache)
  └── MISS
        │
        ▼
riotClient.getAccountByRiotId(name, tag)
        │
        ▼
Promise.all([
  getSummonerByPuuid(puuid),
  getLeagueEntriesByPuuid(puuid),
  getTopMasteriesByPuuid(puuid)
])
        │
        ▼
setCached("account:faker#kr1", data, 600)
        │
        ▼
return NextResponse.json(data, { status: 200 })
```

### Interação com Supabase no Backend

```
lib/supabase/
│
├── client.ts   ──► createBrowserClient()
│                   Usado em Client Components
│                   Lê/escreve com anon key
│                   Respeitado pelo RLS
│
├── server.ts   ──► createServerClient(cookies())
│                   Usado em Server Components e API Routes
│                   Passa o cookie JWT do usuário
│                   Respeitado pelo RLS
│
└── admin.ts    ──► createClient(url, SERVICE_ROLE_KEY)
                    Usado apenas em API Routes privilegiadas
                    IGNORA o RLS (superuser)
                    Usado em: refresh-rank, triggers admin
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 4. INTEGRAÇÃO RIOT GAMES API v5

### Mapa de Hosts

```
┌─────────────────────────────────────────────────────────────┐
│                    lib/riot.ts                              │
│                                                             │
│  PLATFORM_HOST = https://br1.api.riotgames.com             │
│  REGIONAL_HOST = https://americas.api.riotgames.com        │
│                                                             │
│  Headers: { "X-Riot-Token": process.env.RIOT_API_KEY }     │
└─────────────────────────────────────────────────────────────┘

REGIONAL (americas)                PLATFORM (br1)
───────────────────                ──────────────
account-v1                         summoner-v4
match-v5 (IDs + detalhes)          league-v4
                                   champion-mastery-v4
```

### Cadeia de Dependências entre Endpoints

```
[Riot ID: Faker#KR1]
        │
        ▼
account-v1 /by-riot-id/Faker/KR1
        │
        └──► puuid: "a1b2c3d4..."
                      │
        ┌─────────────┼─────────────┐
        ▼             ▼             ▼
  summoner-v4    league-v4    mastery-v4
  /by-puuid      /by-puuid    /by-puuid/top
        │             │             │
  summonerId    [entries]      [masteries]
  level                           top 5
  iconId
        │
  (opcional)
  match-v5 IDs
  /by-puuid/ids
        │
        └──► [matchIds]
                  │
                  ▼
          match-v5 Detail
          /matches/{matchId}
                  │
                  └──► participantes · duração · objetivos
```

### TTL e Estratégia de Cache por Endpoint

```
┌────────────────────────────────┬───────┬────────────────────┐
│ Endpoint                       │  TTL  │ Justificativa       │
├────────────────────────────────┼───────┼────────────────────┤
│ account-v1  (Riot ID → PUUID)  │ 600s  │ Muda raramente     │
│ summoner-v4 (nível + ícone)    │ 300s  │ Muda pouco         │
│ league-v4   (rank + LP)        │ 300s  │ Muda após partidas │
│ mastery-v4  (top campeões)     │ 600s  │ Acumulativo        │
│ match-v5    (IDs histórico)    │ 120s  │ Novas partidas     │
│ match-v5    (detalhe partida)  │ 3600s │ Imutável           │
└────────────────────────────────┴───────┴────────────────────┘
```

### Tratamento de Erros da Riot API

```
Riot API responde
        │
        ├── 200 ──► setCached() + return dados
        │
        ├── 400 ──► "Bad request" → log + return 400
        │
        ├── 401 ──► API Key inválida → log + return 401
        │
        ├── 403 ──► API Key expirada → log + return 403
        │
        ├── 404 ──► Invocador não encontrado → return 404
        │
        ├── 429 ──► Rate limit Riot → aguarda Retry-After
        │           return 429 para o cliente
        │
        └── 5xx ──► Erro Riot → return 503
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 5. FLUXO COMPLETO DE DADOS

### Fluxo A — Vincular Conta Riot

```
Browser                 Next.js                  Riot API         Supabase
   │                       │                        │                │
   │  digita Faker#KR1      │                        │                │
   ├──────────────────────►│                        │                │
   │                       │  GET account-v1        │                │
   │                       ├───────────────────────►│                │
   │                       │  { puuid }             │                │
   │                       │◄───────────────────────┤                │
   │                       │                        │                │
   │                       │  Promise.all           │                │
   │                       ├──── summoner-v4 ───────►                │
   │                       ├──── league-v4  ────────►                │
   │                       ├──── mastery-v4 ────────►                │
   │                       │◄─── resultados ─────────                │
   │                       │                        │                │
   │  exibe prévia dados    │                        │                │
   │◄──────────────────────┤                        │                │
   │                       │                        │                │
   │  confirma vincular    │                        │                │
   ├──────────────────────►│                        │                │
   │                       │  upsert riot_accounts  │                │
   │                       ├────────────────────────────────────────►│
   │                       │  insert rank_snapshots │                │
   │                       ├────────────────────────────────────────►│
   │                       │  upsert champion_masteries              │
   │                       ├────────────────────────────────────────►│
   │                       │                        │                │
   │  redirect /dashboard  │                        │                │
   │◄──────────────────────┤                        │                │
```

### Fluxo B — Carregar Página do Torneio

```
Browser                 Next.js (SSR)                    Supabase
   │                        │                               │
   │  GET /torneios/slug    │                               │
   ├───────────────────────►│                               │
   │                        │  createServerClient(cookies) │
   │                        │──────────────────────────────►│
   │                        │                               │
   │                        │  SELECT tournaments           │
   │                        │  WHERE slug = 'slug'          │
   │                        │──────────────────────────────►│
   │                        │◄──────────────────────────────┤
   │                        │                               │
   │                        │  SELECT matches               │
   │                        │  WHERE tournament_id = ...    │
   │                        │──────────────────────────────►│
   │                        │◄──────────────────────────────┤
   │                        │                               │
   │                        │  SELECT v_tournament_standings│
   │                        │──────────────────────────────►│
   │                        │◄──────────────────────────────┤
   │                        │                               │
   │  HTML renderizado      │                               │
   │◄───────────────────────┤                               │
   │                        │                               │
   │  React hidrata         │                               │
   │  BracketView           │                               │
   │  StandingsTable        │                               │
   │  TeamsList             │                               │
```

### Fluxo C — Atualizar Rank do Jogador

```
Browser           API Route             Riot API          Supabase
   │                  │                    │                 │
   │  POST /api/      │                    │                 │
   │  player/refresh  │                    │                 │
   ├─────────────────►│                    │                 │
   │                  │ valida JWT cookie  │                 │
   │                  │ extrai user.id     │                 │
   │                  │                    │                 │
   │                  │ SELECT puuid FROM  │                 │
   │                  │ riot_accounts      │                 │
   │                  ├────────────────────────────────────►│
   │                  │◄────────────────────────────────────┤
   │                  │                    │                 │
   │                  │ GET league-v4      │                 │
   │                  ├───────────────────►│                 │
   │                  │◄───────────────────┤                 │
   │                  │                    │                 │
   │                  │ INSERT rank_snapshots               │
   │                  ├────────────────────────────────────►│
   │                  │◄────────────────────────────────────┤
   │                  │                    │                 │
   │  { updated:true }│                    │                 │
   │◄─────────────────┤                    │                 │
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 6. AUTENTICAÇÃO E SEGURANÇA

### Arquitetura de Auth

```
┌────────────────────────────────────────────────────────────┐
│                   SUPABASE AUTH                            │
│                                                            │
│  Provider: Email + Password                                │
│  Token: JWT (HS256)                                        │
│  Storage: Cookie httpOnly via @supabase/ssr                │
│  Refresh: automático pelo SDK                              │
└──────────────────────────┬─────────────────────────────────┘
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
   middleware.ts    Server Component   API Route
   (edge)           (RSC)              (Node.js)
          │                │                │
   valida JWT        lê sessão        valida sessão
   redireciona       server-side      extrai user.id
```

### Middleware — Lógica de Proteção

```
Request
   │
   ▼
middleware.ts (executa em toda request)
   │
   ├── Rota pública? (/, /torneios/*, /ranking, /login, /register)
   │     └── Passa sem verificação ──────────────────────► Response
   │
   └── Rota protegida? (/dashboard/*, /admin/*)
         │
         ▼
   supabase.auth.getUser()
         │
         ├── Erro / sem sessão ──► NextResponse.redirect('/login')
         │
         └── Sessão válida
               │
               ├── /dashboard/* ──► Libera ──────────────► Response
               │
               └── /admin/*
                     │
                     ▼
               SELECT is_admin FROM profiles
               WHERE id = user.id
                     │
                     ├── false ──► redirect('/')
                     └── true  ──► Libera ───────────────► Response
```

### RLS — Row Level Security

```
Tabela: profiles
  SELECT: auth.uid() = id           (apenas o próprio usuário)
  UPDATE: auth.uid() = id

Tabela: riot_accounts
  SELECT: auth.uid() = profile_id   (apenas o dono)
  INSERT: auth.uid() = profile_id
  UPDATE: auth.uid() = profile_id

Tabela: rank_snapshots
  SELECT: auth.uid() = profile_id
  INSERT: auth.uid() = profile_id   (ou service_role)

Tabela: tournaments
  SELECT: true                      (pública para todos)
  INSERT: is_admin(auth.uid())
  UPDATE: is_admin(auth.uid())

Tabela: teams
  SELECT: true                      (pública)
  INSERT: auth.uid() IS NOT NULL    (qualquer logado)
  UPDATE: auth.uid() = captain_id

Tabela: matches
  SELECT: true                      (pública)
  UPDATE: is_admin(auth.uid())
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 7. SISTEMA DE CACHE E RATE LIMIT

### Cache — Estrutura Interna

```
lib/riot-cache.ts

const cache = new Map<string, {
  data      : unknown
  expiresAt : number   // Date.now() + TTL ms
}>()

function getCached(key: string): unknown | null {
  const entry = cache.get(key)
  if (!entry) return null
  if (Date.now() > entry.expiresAt) {
    cache.delete(key)
    return null
  }
  return entry.data
}

function setCached(key: string, data: unknown, ttlSec: number) {
  cache.set(key, {
    data,
    expiresAt: Date.now() + ttlSec * 1000
  })
}
```

### Formato das Chaves de Cache

```
┌──────────────────────────────┬───────────────────────────────┐
│ Padrão da Chave              │ Exemplo                       │
├──────────────────────────────┼───────────────────────────────┤
│ account:{name}#{tag}         │ account:faker#kr1             │
│ summoner:{puuid}             │ summoner:a1b2c3d4...          │
│ league:{puuid}               │ league:a1b2c3d4...            │
│ mastery:{puuid}              │ mastery:a1b2c3d4...           │
│ matchids:{puuid}:{n}:{queue} │ matchids:a1b2...:20:420       │
│ match:{matchId}              │ match:BR1_1234567890          │
└──────────────────────────────┴───────────────────────────────┘
```

### Rate Limiter — Algoritmo Sliding Window

```
lib/rate-limit.ts

const requests = new Map<string, number[]>()
// chave: IP do cliente
// valor: array de timestamps das requests

function rateLimit(ip, limit=30, windowMs=60000): boolean {
  const now     = Date.now()
  const history = requests.get(ip) ?? []

  // Remove timestamps fora da janela
  const recent = history.filter(t => now - t < windowMs)

  if (recent.length >= limit) return false  // bloqueado

  recent.push(now)
  requests.set(ip, recent)
  return true  // permitido
}
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 8. BANCO DE DADOS — SUPABASE

### Diagrama Completo das Tabelas

```
┌──────────────────────────────────────────────────────────────┐
│  auth.users  (gerenciado pelo Supabase Auth)                 │
│  id · email · encrypted_password · created_at               │
└──────────────────────┬───────────────────────────────────────┘
                       │ TRIGGER: handle_new_user()
                       │ ON INSERT → cria row em profiles
                       ▼
┌──────────────────────────────────────────────────────────────┐
│  profiles                                                    │
│  id(pk,fk) · username · display_name · avatar_url           │
│  is_admin · created_at                                       │
└──────┬───────────────────────────────────────────────────────┘
       │                                      │ created_by (fk)
       │ 1:N                                  ▼
       │                       ┌──────────────────────────────┐
       │                       │  tournaments                 │
       │                       │  id · slug · name · status   │
       │                       │  queue_type · bracket_type   │
       │                       │  max_teams · prize_pool      │
       │                       │  starts_at · created_at      │
       │                       └────────────────┬─────────────┘
       │                                        │ 1:N
       ▼                                        ▼
┌──────────────────────┐           ┌────────────────────────────┐
│  riot_accounts        │           │  teams                     │
│  id · profile_id(fk)  │           │  id · tournament_id(fk)    │
│  puuid · game_name    │           │  captain_id(fk→profiles)   │
│  tag_line             │           │  name · tag · seed         │
│  summoner_id          │           │  wins · losses · status    │
│  summoner_level       │           └────────────────┬───────────┘
│  profile_icon_id      │                            │ 1:N
│  is_primary           │           ┌────────────────▼───────────┐
└──────┬────────────────┘           │  team_members              │
       │                            │  id · team_id(fk)          │
       ├── 1:N                      │  profile_id(fk)            │
       ▼                            │  role · position           │
┌──────────────────────┐            └────────────────────────────┘
│  rank_snapshots       │
│  id · riot_acc_id(fk) │           ┌────────────────────────────┐
│  queue_type · tier    │           │  matches                   │
│  rank · lp            │           │  id · tournament_id(fk)    │
│  wins · losses        │           │  team_a_id · team_b_id(fk) │
│  snapshotted_at       │           │  winner_id(fk) · round     │
└──────────────────────┘            │  match_number · score_a/b  │
                                    │  status · scheduled_at     │
┌──────────────────────┐            └────────────────┬───────────┘
│  champion_masteries   │                            │ 1:N
│  id · riot_acc_id(fk) │           ┌────────────────▼───────────┐
│  champion_id          │           │  match_reports             │
│  mastery_level        │           │  id · match_id(fk)         │
│  mastery_points       │           │  reporter_id(fk)           │
│  last_play_time       │           │  winner_id · status        │
└──────────────────────┘            │  screenshot_url            │
                                    └────────────────────────────┘
```

### Views SQL

```sql
-- v_tournament_standings
-- Classificação calculada automaticamente por torneio

CREATE VIEW v_tournament_standings AS
SELECT
  t.tournament_id,
  t.id                              AS team_id,
  t.name                            AS team_name,
  t.tag,
  t.wins,
  t.losses,
  SUM(m.score_a + m.score_b)        AS games_won,
  COUNT(m.id)                       AS games_lost,
  (t.wins * 3)                      AS points,
  ROW_NUMBER() OVER (
    PARTITION BY t.tournament_id
    ORDER BY t.wins DESC, points DESC
  )                                 AS position
FROM teams t
LEFT JOIN matches m ON (
  m.team_a_id = t.id OR m.team_b_id = t.id
)
GROUP BY t.id, t.tournament_id;

-- v_player_kda
-- KDA médio de cada jogador por conta Riot

CREATE VIEW v_player_kda AS
SELECT
  ra.profile_id,
  ra.game_name,
  ra.tag_line,
  ROUND(AVG(kills), 2)   AS avg_kills,
  ROUND(AVG(deaths), 2)  AS avg_deaths,
  ROUND(AVG(assists), 2) AS avg_assists
FROM riot_accounts ra
JOIN match_participants mp ON mp.puuid = ra.puuid
GROUP BY ra.profile_id, ra.game_name, ra.tag_line;
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 9. DEPLOY E INFRAESTRUTURA

### Pipeline de Deploy

```
Developer
   │
   │  git push origin main
   ▼
GitHub Repository
   │
   │  Webhook automático
   ▼
Vercel Build Pipeline
   │
   ├── npm install
   ├── next build
   │     ├── Compila Server Components
   │     ├── Compila Client Components
   │     ├── Gera páginas estáticas (ISR)
   │     └── Compila API Routes (Edge/Node)
   │
   └── Deploy para Edge Network
         │
         ├── CDN: assets estáticos (JS/CSS/imagens)
         ├── Edge: middleware (auth guard)
         └── Node: API Routes serverless
```

### Ambientes

```
┌─────────────────────┬─────────────────────┬──────────────────┐
│ Ambiente            │ URL                 │ Branch           │
├─────────────────────┼─────────────────────┼──────────────────┤
│ Production          │ *.vercel.app        │ main             │
│ Preview             │ *-git-*.vercel.app  │ qualquer PR/push │
│ Development         │ localhost:3000      │ local            │
└─────────────────────┴─────────────────────┴──────────────────┘
```

### Variáveis de Ambiente por Camada

```
┌────────────────────────────────┬────────┬────────┬──────────┐
│ Variável                       │ Build  │ Server │ Browser  │
├────────────────────────────────┼────────┼────────┼──────────┤
│ NEXT_PUBLIC_SUPABASE_URL       │  sim   │  sim   │   sim    │
│ NEXT_PUBLIC_SUPABASE_ANON_KEY  │  sim   │  sim   │   sim    │
│ SUPABASE_SERVICE_ROLE_KEY      │  não   │  sim   │   NÃO    │
│ RIOT_API_KEY                   │  não   │  sim   │   NÃO    │
│ RIOT_REGION                    │  não   │  sim   │   NÃO    │
│ RIOT_REGIONAL_HOST             │  não   │  sim   │   NÃO    │
│ NEXT_PUBLIC_SITE_URL           │  sim   │  sim   │   sim    │
└────────────────────────────────┴────────┴────────┴──────────┘

ATENÇÃO: Variáveis sem NEXT_PUBLIC_ NUNCA chegam ao browser.
```

### Configuração vercel.json

```json
{
  "framework": "nextjs",
  "buildCommand": "npm run build",
  "devCommand": "npm run dev",
  "installCommand": "npm install",
  "regions": ["gru1"],
  "functions": {
    "app/api/**": {
      "maxDuration": 10
    }
  }
}
```

### Configuração next.config.ts

```typescript
const nextConfig = {
  images: {
    remotePatterns: [
      {
        // Data Dragon — assets League of Legends
        protocol: 'https',
        hostname: 'ddragon.leagueoflegends.com',
        pathname: '/cdn/**'
      },
      {
        // Avatars do Supabase Storage
        protocol: 'https',
        hostname: '*.supabase.co',
        pathname: '/storage/v1/object/public/**'
      }
    ]
  }
}
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

MIT © Luan — https://github.com/luanscps
"""