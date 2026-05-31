# 🚀 Manual de Deploy — GerenciadorDeTorneios BRLOL

> Stack: Next.js ^16.2.6 · TypeScript · Tailwind CSS · Supabase · Riot API · Vercel

---

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Node.js** 24.x → https://nodejs.org (versão usada na Vercel em produção)
- **npm** >= 10.x (incluído no Node.js 24)
- **Git** → https://git-scm.com
- Conta no **Supabase** → https://supabase.com
- Conta na **Vercel** → https://vercel.com
- Chave de API da **Riot Games** → https://developer.riotgames.com

---

## 1️⃣ Clonar o Repositório

```bash
git clone https://github.com/luanscps/GerenciadorDeTorneios-BRLOL.git
cd GerenciadorDeTorneios-BRLOL
```

---

## 2️⃣ Instalar Dependências

```bash
npm install
```

---

## 3️⃣ Configurar Variáveis de Ambiente

Crie um arquivo `.env.local` na raiz do projeto copiando o exemplo:

```bash
cp .env.example .env.local
```

Edite o `.env.local` com seus valores reais:

```env
# ─── Supabase ────────────────────────────────────────────
NEXT_PUBLIC_SUPABASE_URL=https://SEU_PROJECT_ID.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=sua_anon_key_aqui
SUPABASE_SERVICE_ROLE_KEY=sua_service_role_key_aqui

# ─── Riot Games API ──────────────────────────────────────
RIOT_API_KEY=RGAPI-xxxxxxxxxxxxxxxxxxxxxxxxxxxx
RIOT_REGION=br1
RIOT_REGIONAL_HOST=americas

# ─── App ────────────────────────────────────────────────
NEXT_PUBLIC_APP_URL=http://localhost:3000

# ─── Cron / Webhooks (server-only) ─────────────────────────
CRON_SECRET=string-aleatoria-grande
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/...
```

> ⚠️ **Nunca commitar o `.env.local`** — ele já está no `.gitignore`.

### Como obter as chaves do Supabase

1. Acesse https://supabase.com e faça login
2. Crie um novo projeto ou abra o existente
3. Vá em **Settings → API**
4. Copie:
   - `Project URL` → `NEXT_PUBLIC_SUPABASE_URL`
   - `anon public` → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `service_role secret` → `SUPABASE_SERVICE_ROLE_KEY` ⚠️ **Nunca exponha no frontend**

### Como obter a chave da Riot API

1. Acesse https://developer.riotgames.com
2. Faça login com sua conta Riot
3. Gere uma **Development API Key** (válida 24h) ou solicite **Production Key**
4. Cole em `RIOT_API_KEY`

> ⚠️ Chaves de desenvolvimento expiram a cada 24 horas. Para produção, solicite chave permanente.

---

## 4️⃣ Configurar o Supabase (Banco de Dados)

### 4.1 — Criar o projeto no Supabase

1. Acesse https://app.supabase.com
2. Clique em **New Project**
3. Escolha organização, nome, senha e região (**South America — São Paulo** recomendado)
4. Aguarde inicializar (~2 minutos)

### 4.2 — Executar as Migrations

```bash
# Com Supabase CLI instalado:
npx supabase db push

# Ou manualmente no SQL Editor do painel Supabase
# Execute os arquivos em supabase/migrations/ na ordem
```

### 4.3 — Configurar Auth

1. Vá em **Authentication → URL Configuration**
2. Em **Site URL**, coloque: `https://SEU_DOMINIO.vercel.app`
3. Em **Redirect URLs**, adicione:
   - `https://SEU_DOMINIO.vercel.app/auth/callback`
   - `http://localhost:3000/auth/callback` (para desenvolvimento)

### 4.4 — RLS

O RLS já é aplicado via migrations do projeto. **Não execute policies manualmente** — use sempre os arquivos em `supabase/migrations/`.

Regra crítica: nunca fazer INSERT/UPDATE sem policy RLS correspondente. Consulte [`docs/BANCO-DE-DADOS.md`](./BANCO-DE-DADOS.md) para referência completa.

---

## 5️⃣ Rodar Localmente

```bash
npm run dev
```

> O servidor usa **Turbopack** automaticamente (`next dev --turbo` no `package.json`).

Acesse: http://localhost:3000

### Scripts disponíveis

| Comando | Descrição |
|---|---|
| `npm run dev` | Servidor de desenvolvimento (com Turbopack) |
| `npm run build` | Gera build de produção |
| `npm run start` | Serve o build localmente |
| `npm run lint` | Verifica erros de código (ESLint) |

---

## 6️⃣ Deploy na Vercel

### 6.1 — Via Interface Web (primeiro deploy)

1. Acesse https://vercel.com e faça login com GitHub
2. Clique em **Add New → Project**
3. Importe o repositório `GerenciadorDeTorneios-BRLOL`
4. Configurações detectadas automaticamente:
   - **Framework Preset:** Next.js
   - **Build Command:** `next build`
   - **Output Directory:** `.next`
   - **Install Command:** `npm install`
5. Adicione as variáveis de ambiente (tabela na seção 8 abaixo)
6. Clique em **Deploy**

### 6.2 — Via Vercel CLI

```bash
npm install -g vercel
vercel login

# Deploy de preview
vercel

# Deploy de produção
vercel --prod
```

### 6.3 — CI/CD automático via GitHub

- **Push na `main`** → deploy automático em produção
- **Pull Request aberto** → preview deployment com URL única

---

## 7️⃣ Domínio Customizado (Opcional)

1. No painel Vercel: **Settings → Domains**
2. Adicione seu domínio (ex: `arenagg.com.br`)
3. Aponte o DNS:
   - Tipo `A` → `76.76.21.21`
   - Ou tipo `CNAME` → `cname.vercel-dns.com`
4. Aguarde propagação DNS (até 48h)
5. Atualize `NEXT_PUBLIC_APP_URL` e as URLs do Supabase Auth com o novo domínio

---

## 8️⃣ Variáveis de Ambiente na Vercel

| Variável | Ambiente | Descrição |
|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Production + Preview | URL do projeto Supabase |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Production + Preview | Chave pública do Supabase |
| `SUPABASE_SERVICE_ROLE_KEY` | Production only | Chave secreta — apenas server-side |
| `RIOT_API_KEY` | Production + Preview | Chave da Riot Games API |
| `RIOT_REGION` | Production + Preview | Região (`br1`) |
| `RIOT_REGIONAL_HOST` | Production + Preview | Host regional (`americas`) |
| `NEXT_PUBLIC_APP_URL` | Production + Preview | URL final da aplicação |
| `CRON_SECRET` | Production only | Segredo para autenticação dos cron jobs |
| `DISCORD_WEBHOOK_URL` | Production + Preview | Webhook Discord (opcional) |

> ⚠️ Variáveis com prefixo `NEXT_PUBLIC_` são expostas no browser. **Nunca coloque secrets nelas.**

---

## 9️⃣ Checklist Pré-Deploy de Produção

- [ ] `.env.local` configurado e **NÃO commitado** no Git
- [ ] Todas as variáveis adicionadas na Vercel (ver tabela acima)
- [ ] Supabase Auth com URL de produção configurada
- [ ] RLS aplicado via migrations (não manualmente)
- [ ] `NEXT_PUBLIC_APP_URL` apontando para URL de produção
- [ ] `npm run build` executado localmente sem erros
- [ ] Riot API Key de produção (não a de desenvolvimento de 24h)
- [ ] Domínio customizado apontado (se aplicável)
- [ ] Callback `/auth/callback` na lista de Redirect URLs do Supabase

---

## 🐛 Troubleshooting

### `NEXT_PUBLIC_SUPABASE_URL` not defined
- Verifique se o `.env.local` existe e tem as variáveis corretas
- Reinicie o servidor com `npm run dev` após editar o `.env`

### Erro de CORS no Supabase
- Adicione a URL do app em **Supabase → Settings → API → CORS allowed origins**

### Build falha na Vercel
- Confirme que **todas** as variáveis de ambiente estão configuradas no painel
- Rode `npm run build` localmente para reproduzir antes do deploy

### Riot API retorna 403
- Development Key expirou (24h) — regenere em https://developer.riotgames.com
- Verifique `RIOT_REGION=br1` e `RIOT_REGIONAL_HOST=americas`

### Auth callback não funciona
- Confirme que `https://SEU_DOMINIO/auth/callback` está nas Redirect URLs do Supabase Auth
- A rota de callback fica em `app/(auth)/auth/callback/route.ts`

### Cron job não executa
- Verifique se `CRON_SECRET` está definido na Vercel
- Confirme a configuração em `vercel.json`

---

## 📚 Referências

- [Next.js Docs](https://nextjs.org/docs)
- [Supabase Docs](https://supabase.com/docs)
- [Vercel Docs](https://vercel.com/docs)
- [Riot Developer Portal](https://developer.riotgames.com)
- [Supabase Auth com Next.js](https://supabase.com/docs/guides/auth/server-side/nextjs)
- [Arquitetura do projeto](./ARQUITETURA-ATUAL.md)
- [Banco de dados](./BANCO-DE-DADOS.md)
