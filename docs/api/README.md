# Documentação da API — BRLOL Gerenciador de Torneios

> **Versão:** 2.0.0 · **Atualizado em:** Abril 2026  
> **Repositório:** [luanscps/GerenciadorDeTorneios-BRLOL](https://github.com/luanscps/GerenciadorDeTorneios-BRLOL)  
> **Deploy:** [gerenciador-de-torneios-brlol.vercel.app](https://gerenciador-de-torneios-brlol.vercel.app)

---

## Antes de tudo: documento unificado de arquitetura

Se você está chegando agora no projeto e quer entender **arquitetura, banco Supabase, Riot API, Edge Functions e fluxos de negócio**, comece por aqui:

- [`docs/BRLOL-DOCS-UNIFICADO.md`](../BRLOL-DOCS-UNIFICADO.md)

Este arquivo contém a visão de alto nível de:

- modelo de dados (tabelas, enums, FKs) alinhado ao Supabase;
- integrações Riot API (endpoints reais usados pelo código);
- Edge Functions (`bracket-generator`, `send-email`, `riot-api-sync`, `discord-webhook`);
- fluxos principais (inscrição, seedings, geração de chave, registro de resultados, leaderboards).

Os documentos abaixo em `docs/api/` aprofundam em **detalhes de API e implementação** (rotas HTTP, cron jobs, rate limiting).

---

## Índice

| Documento | Descrição |
|---|---|
| [visao-geral.md](./visao-geral.md) | Arquitetura da camada de API, estrutura das rotas Next.js |
| [riot-api.md](./riot-api.md) | Detalhes de integração com a Riot API (conceitos, endpoints, assets) |
| [rate-limiting.md](./rate-limiting.md) | Sistema de rate limiting — camadas, chaves e proteção contra abuso |
| [tournament-stub.md](./tournament-stub.md) | tournament-stub-v5: fluxo completo, codes, eventos, uso atual/futuro |
| [rotas-api.md](./rotas-api.md) | Referência de endpoints REST internos (`/api/…`) do projeto |
| [supabase.md](./supabase.md) | Clientes Supabase na API, webhooks e autenticação, ligação com o schema real |
| [cron-monitoramento.md](./cron-monitoramento.md) | Cron de status da Riot API, notificação Discord e monitoração de saúde |

> Para detalhes de **schema** e **domínio de torneios**, sempre conferir primeiro o `BRLOL-DOCS-UNIFICADO.md` e depois voltar para estes arquivos quando precisar de detalhes de implementação.

---

## Visão rápida do sistema

```
Browser / Admin
     │
     ▼
Next.js App Router (Vercel)
     │
     ├── /app/api/riot/summoner           → Busca dados de jogador
     ├── /app/api/riot/matches            → Histórico de partidas + stats
     ├── /app/api/riot/match/[id]         → Detalhe de partida específica
     ├── /app/api/riot/tournament         → Integração tournament(-stub) v5
     ├── /app/api/riot/tournament/codes   → Geração/consulta de tournament codes
     ├── /app/api/riot/tournament/events  → Lobby events (polling)
     ├── /app/api/riot/tournament/callback → Webhook Riot → Supabase
     ├── /app/api/admin/*                 → Endpoints administrativos
     └── /app/api/cron/check-riot-status  → Monitor periódico
     │
     ├── lib/riot.ts                  → Cliente geral (account, summoner, league, match)
     ├── lib/riot-cache.ts            → Cache em memória (TTL por endpoint)
     ├── lib/riot-rate-limiter.ts     → Rate limiting multi‑camada
     ├── lib/riot-tournament.ts       → Cliente tournament(-stub)-v5
     └── lib/supabase/*               → Clientes Supabase (browser/server/service-role)
     │
     ▼
┌─────────────────┐     ┌──────────────────────────┐
│  Riot Games API │     │  Supabase (PostgreSQL)    │
│  br1.api...     │     │  profiles, tournaments,   │
│  americas.api...│     │  matches, stats, etc.     │
└─────────────────┘     └──────────────────────────┘
```

---

## Requisitos de configuração (resumo)

Variáveis de ambiente obrigatórias no Vercel Dashboard (`Settings → Environment Variables`):

```bash
# Riot Games
RIOT_API_KEY=RGAPI-xxxx-xxxx-xxxx   # NÃO usar NEXT_PUBLIC_ — apenas servidor
RIOT_REGION=br1                      # opcional, padrão: br1

# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...     # para webhooks e rotas de serviço

# Opcionais
NEXT_PUBLIC_APP_URL=https://gerenciador-de-torneios-brlol.vercel.app
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/...
CRON_SECRET=string-aleatoria-segura
```

> ⚠️ Nunca prefixar `RIOT_API_KEY` ou `SUPABASE_SERVICE_ROLE_KEY` com `NEXT_PUBLIC_`. Essas chaves devem ficar estritamente no lado servidor.
