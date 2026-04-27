# Supabase — Banco de Dados e Autenticação

> Esta página descreve apenas os **clientes** Supabase usados na API e como o serviço é configurado.  
> O modelo de dados completo (tabelas, enums, relacionamentos, RLS) está documentado em `docs/BRLOL-DOCS-UNIFICADO.md` na seção "Modelo de dados — schema público Supabase".

---

## Clientes Supabase no projeto

| Contexto | Função | Bypassa RLS? |
|---|---|---|
| Browser | `createBrowserClient()` | ❌ Não |
| Server (Route Handlers) | `createServerClient()` com cookies | ❌ Não |
| Webhook / Admin / Jobs | `createClient(url, serviceRoleKey)` | ✅ Sim |

> ⚠️ `SUPABASE_SERVICE_ROLE_KEY` bypassa todas as políticas de RLS. Use somente em contextos servidor‑para‑servidor (webhooks, crons, edge functions). Nunca prefixe com `NEXT_PUBLIC_`.

### Padrão de uso em rotas da API (server-side)

```typescript
import { createServerClient } from "@supabase/auth-helpers-nextjs";

export async function GET(req: NextRequest) {
  const supabase = createServerClient({
    cookies: () => req.cookies,
  });

  const { data: { user } } = await supabase.auth.getUser();
  // ... usar user.id para consultar profiles, tournaments, etc.
}
```

---

## Variáveis de ambiente Supabase

| Variável | Onde usar | Segura no cliente? |
|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Client + Server | ✅ Sim |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Client + Server | ✅ Sim (sujeita ao RLS) |
| `SUPABASE_SERVICE_ROLE_KEY` | Server apenas | ❌ Nunca no cliente |

Exemplo de configuração `.env.local` para desenvolvimento:

```bash
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...
```

---

## Webhook de resultados de torneio (Riot → Supabase)

A rota `/app/api/riot/tournament/callback` recebe eventos da Riot após o término de partidas de torneio.
Ela usa o client com `SERVICE_ROLE_KEY` para inserir/atualizar registros em tabelas internas.

> O schema detalhado das tabelas envolvidas (ex.: `matches`, `match_games`, `player_stats`, `audit_log`) está descrito no documento unificado de arquitetura.
