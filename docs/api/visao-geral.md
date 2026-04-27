# Visão Geral da Arquitetura da API

> Para visão de arquitetura completa (frontend + backend + banco Supabase + Riot + Edge Functions), consulte primeiro `docs/BRLOL-DOCS-UNIFICADO.md` e depois volte aqui para detalhes específicos da camada de API.

## Stack tecnológico

| Camada | Tecnologia | Versão |
|---|---|---|
| Framework | Next.js (App Router) | 14+ |
| Deploy | Vercel | — |
| Banco de dados | Supabase (PostgreSQL) | — |
| Autenticação | Supabase Auth | — |
| API externa | Riot Games API | v5 |
| Linguagem | TypeScript | 5+ |
| Estilo | Tailwind CSS | 3+ |

---

## Estrutura de pastas relevante

```
GerenciadorDeTorneios-BRLOL/
│
├── app/
│   └── api/
│       ├── admin/              ← Rotas administrativas internas
│       ├── auth/               ← Autenticação Supabase
│       ├── jogadores/          ← CRUD de jogadores
│       ├── player/             ← Perfil detalhado de jogador
│       ├── profile/            ← Dados de perfil do usuário logado
│       └── riot/
│           ├── match/          ← Detalhes de partida
│           ├── matches/        ← Histórico de partidas
│           ├── summoner/       ← Dados agregados do invocador
│           └── tournament/
│               ├── route.ts        ← Setup de torneio (stub/produção)
│               ├── codes/          ← Tournament codes
│               ├── events/         ← Lobby events (polling)
│               └── callback/       ← Webhook Riot → Supabase
│
├── lib/
│   ├── riot.ts                 ← Cliente geral da Riot API
│   ├── riot-rate-limiter.ts    ← Rate limiting multi‑camada
│   ├── riot-tournament.ts      ← Cliente tournament(-stub)-v5
│   ├── riot-cache.ts           ← Cache TTL em memória
│   ├── rate-limit.ts           ← Rate limit por IP (para rotas públicas)
│   └── supabase/               ← Clientes Supabase (server/client/service)
│
├── app/api/cron/
│   └── check-riot-status/      ← Monitor periódico de status da Riot API
│
├── vercel.json                 ← Configuração de crons
└── docs/api/                   ← Esta documentação
```

---

## Autenticação e autorização na API

Todas as rotas que alteram dados de torneios (POST, PUT, DELETE) conferem se o usuário logado é admin via Supabase (`profiles.is_admin = true`). A camada de RLS no banco reforça as mesmas regras.

Exemplo de padrão de verificação (pseudocódigo simplificado):

```typescript
async function requireAdmin() {
  const supabase = createServerClient(...);
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error("Unauthorized");

  const { data: profile } = await supabase
    .from("profiles")
    .select("is_admin")
    .eq("id", user.id)
    .single();

  if (!profile?.is_admin) throw new Error("Forbidden");
}
```

- **Rotas públicas**: consulta de summoner, histórico de partidas, status de torneio.
- **Rotas protegidas (admin)**: criação/edição de torneios, seedings, geração de tournament codes, gerenciamento de partidas.

---

## Ciclo de vida de um deploy

1. Push para `main` → Vercel detecta e dispara build.
2. Vercel executa `next build` com as variáveis de ambiente configuradas.
3. Deploy em edge CDN global.
4. Rotas de API passam a rodar com o novo código (Serverless/Edge Functions da Vercel).
5. Crons são (re)agendados conforme `vercel.json`.
