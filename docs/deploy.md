# 🚀 Manual de Deploy — GerenciadorDeTorneios BRLOL

> Stack: Next.js 14 · TypeScript · Tailwind CSS · Supabase · Riot API · Vercel

---

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Node.js** >= 18.x → https://nodejs.org
- **npm** >= 9.x (vem com o Node)
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
# Obtenha em: https://developer.riotgames.com
RIOT_API_KEY=RGAPI-xxxxxxxxxxxxxxxxxxxxxxxxxxxx
RIOT_REGION=br1
RIOT_REGIONAL_HOST=americas

# ─── App ─────────────────────────────────────────────────
NEXT_PUBLIC_SITE_URL=http://localhost:3000
```

### Como obter as chaves do Supabase

1. Acesse https://supabase.com e faça login
2. Crie um novo projeto (ou abra o existente)
3. Vá em **Settings → API**
4. Copie:
   - `Project URL` → `NEXT_PUBLIC_SUPABASE_URL`
   - `anon public` → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `service_role secret` → `SUPABASE_SERVICE_ROLE_KEY` ⚠️ **Nunca exponha esta chave no frontend**

### Como obter a chave da Riot API

1. Acesse https://developer.riotgames.com
2. Faça login com sua conta Riot
3. Gere uma **Development API Key** (válida por 24h) ou solicite uma **Production Key**
4. Cole em `RIOT_API_KEY`

> ⚠️ **Atenção:** Chaves de desenvolvimento expiram a cada 24 horas. Para produção, solicite uma chave permanente pela Riot.

---

## 4️⃣ Configurar o Supabase (Banco de Dados)

### 4.1 — Criar o projeto no Supabase

1. Acesse https://app.supabase.com
2. Clique em **New Project**
3. Escolha organização, nome do projeto, senha do banco e região (recomendado: **South America - São Paulo**)
4. Aguarde o projeto inicializar (~2 minutos)

### 4.2 — Executar as Migrations

No **SQL Editor** do Supabase (menu lateral), execute os scripts de criação de tabelas do projeto. Caso existam arquivos de migration na pasta `supabase/migrations/`, execute na ordem:

```bash
# Se tiver Supabase CLI instalado:
npx supabase db push

# Ou manualmente no SQL Editor do painel Supabase
```

### 4.3 — Configurar Auth (Autenticação)

1. Vá em **Authentication → Settings**
2. Em **Site URL**, coloque: `https://SEU_DOMINIO.vercel.app`
3. Em **Redirect URLs**, adicione:
   - `https://SEU_DOMINIO.vercel.app/auth/callback`
   - `http://localhost:3000/auth/callback` (para desenvolvimento)
4. Ative os provedores de login desejados (Email, Google, Discord, etc.)

### 4.4 — Configurar Row Level Security (RLS)

Certifique-se de que as políticas de RLS estão ativas nas tabelas sensíveis. No SQL Editor:

```sql
-- Exemplo: habilitar RLS na tabela de torneios
ALTER TABLE torneios ENABLE ROW LEVEL SECURITY;

-- Exemplo: apenas admins podem criar torneios
CREATE POLICY "Admins podem criar torneios"
ON torneios FOR INSERT
TO authenticated
USING (auth.jwt() ->> 'role' = 'admin');
```

---

## 5️⃣ Rodar Localmente

```bash
npm run dev
```

Acesse: http://localhost:3000

### Scripts disponíveis

| Comando | Descrição |
|---|---|
| `npm run dev` | Inicia servidor de desenvolvimento |
| `npm run build` | Gera build de produção |
| `npm run start` | Inicia servidor de produção local |
| `npm run lint` | Verifica erros de código (ESLint) |

---

## 6️⃣ Deploy na Vercel

### 6.1 — Via Interface Web (Recomendado para primeiro deploy)

1. Acesse https://vercel.com e faça login com sua conta GitHub
2. Clique em **Add New → Project**
3. Importe o repositório `GerenciadorDeTorneios-BRLOL`
4. Na tela de configuração:
   - **Framework Preset:** Next.js (detectado automaticamente)
   - **Build Command:** `next build`
   - **Output Directory:** `.next`
   - **Install Command:** `npm install`
5. Adicione todas as variáveis de ambiente (seção **Environment Variables**):
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
RIOT_API_KEY
RIOT_REGION
RIOT_REGIONAL_HOST
NEXT_PUBLIC_SITE_URL

text
6. Clique em **Deploy**

### 6.2 — Via Vercel CLI

```bash
# Instalar Vercel CLI globalmente
npm install -g vercel

# Login
vercel login

# Deploy de preview
vercel

# Deploy de produção
vercel --prod
```

### 6.3 — Deploy Automático (CI/CD via GitHub)

Após conectar o repositório à Vercel:

- **Push na branch `main`** → Deploy automático em produção
- **Pull Request aberto** → Deploy de preview gerado automaticamente com URL única

---

## 7️⃣ Configurar Domínio Customizado (Opcional)

1. No painel da Vercel, vá em **Settings → Domains**
2. Adicione seu domínio (ex: `torneios.seudominio.com.br`)
3. Aponte o DNS no seu registrador:
- Tipo `A` → `76.76.21.21`
- Ou tipo `CNAME` → `cname.vercel-dns.com`
4. Aguarde propagação DNS (até 48h)
5. Atualize `NEXT_PUBLIC_SITE_URL` e as URLs do Supabase Auth com o novo domínio

---

## 8️⃣ Variáveis de Ambiente na Vercel

| Variável | Ambiente | Descrição |
|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Production + Preview | URL do projeto Supabase |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Production + Preview | Chave pública do Supabase |
| `SUPABASE_SERVICE_ROLE_KEY` | Production only | Chave secreta — só em server-side |
| `RIOT_API_KEY` | Production + Preview | Chave da Riot Games API |
| `RIOT_REGION` | Production + Preview | Região (`br1` para Brasil) |
| `RIOT_REGIONAL_HOST` | Production + Preview | Host regional (`americas`) |
| `NEXT_PUBLIC_SITE_URL` | Production | URL final da aplicação |

> ⚠️ Variáveis com prefixo `NEXT_PUBLIC_` são expostas no browser. **Nunca coloque secrets nelas.**

---

## 9️⃣ Checklist Pré-Deploy de Produção

- [ ] `.env.local` configurado e **NÃO commitado** no Git (verifique `.gitignore`)
- [ ] Todas as variáveis adicionadas na Vercel
- [ ] Supabase Auth com URL de produção configurada
- [ ] RLS ativado nas tabelas do banco
- [ ] `NEXT_PUBLIC_SITE_URL` apontando para URL de produção
- [ ] `npm run build` executado localmente sem erros
- [ ] Riot API Key de produção (não a de desenvolvimento de 24h)
- [ ] Domínio customizado apontado (se aplicável)

---

## 🐛 Troubleshooting

### Erro: `NEXT_PUBLIC_SUPABASE_URL` not defined
- Verifique se o `.env.local` existe e tem as variáveis corretas
- Reinicie o servidor com `npm run dev` após editar o `.env`

### Erro de CORS no Supabase
- Adicione a URL do seu app em **Supabase → Settings → API → CORS allowed origins**

### Build falha na Vercel
- Confirme que todas as variáveis de ambiente estão configuradas no painel da Vercel
- Rode `npm run build` localmente para reproduzir o erro antes do deploy

### Riot API retorna 403
- A Development Key expirou (válida 24h) — regenere em https://developer.riotgames.com
- Verifique se `RIOT_REGION=br1` e `RIOT_REGIONAL_HOST=americas` estão corretos

### Auth callback não funciona
- Confirme que `https://SEU_DOMINIO/auth/callback` está na lista de Redirect URLs do Supabase Auth

---

## 📚 Referências

- [Next.js Docs](https://nextjs.org/docs)
- [Supabase Docs](https://supabase.com/docs)
- [Vercel Docs](https://vercel.com/docs)
- [Riot Developer Portal](https://developer.riotgames.com)
- [Supabase Auth com Next.js](https://supabase.com/docs/guides/auth/server-side/nextjs)
