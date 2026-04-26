# Rotas e Permissões — GerenciadorDeTorneios BRLOL

> Atualizado em: **2026-04-26**

Mapa completo de rotas, quem pode acessar e como a proteção é implementada.

---

## Níveis de Acesso

| Nível | Critério |
|---|---|
| **Público** | Qualquer visitante, sem login |
| **Autenticado** | Usuário com sessão válida (`auth.users`) |
| **Organizador** | Autenticado + criador do torneio (`tournaments.created_by = auth.uid()`) |
| **Admin** | `profiles.is_admin = true` |

---

## Mapa de Rotas

### Rotas Públicas

| Rota | Descrição | Acesso |
|---|---|---|
| `/` | Landing page | Público |
| `/torneios` | Listagem de torneios | Público |
| `/torneios/[slug]` | Detalhe do torneio | Público |
| `/torneios/[slug]/inscricoes` | Inscrições abertas | Público (leitura) |
| `/times` | Listagem de times | Público |
| `/times/[slug]` | Detalhe do time | Público |
| `/jogadores` | Consulta de jogadores | Público |
| `/ranking` | Rankings e estatísticas | Público |

### Rotas Autenticadas (Dashboard)

| Rota | Descrição | Acesso |
|---|---|---|
| `/dashboard` | Overview pessoal | Autenticado |
| `/dashboard/times` | Meus times | Autenticado |
| `/dashboard/times/criar` | Criar time + inscrever em torneio | Autenticado |
| `/dashboard/jogador/registrar` | Vincular conta Riot | Autenticado |

### Rotas de Organizador

| Rota | Descrição | Acesso |
|---|---|---|
| `/organizador/torneios/novo` | Criar torneio | Autenticado (admin ou organizador) |
| `/organizador/torneios/[id]` | Editar torneio | Criador do torneio ou Admin |
| `/organizador/torneios/[id]/inscricoes` | Gerenciar inscrições | Criador do torneio ou Admin |

### Rotas Admin

| Rota | Descrição | Acesso |
|---|---|---|
| `/admin` | Painel admin geral | Admin |
| `/admin/torneios` | Gestão de torneios | Admin |
| `/admin/torneios/[slug]` | Detalhe admin do torneio | Admin |
| `/admin/jogadores` | Gestão de jogadores | Admin |
| `/admin/usuarios` | Gestão de usuários/perfis | Admin |
| `/admin/audit` | Visualização do `audit_log` | Admin |

---

## Como a Proteção é Implementada

### Middleware (Next.js)

O arquivo `middleware.ts` intercepta todas as rotas e redireciona:
- `/dashboard/*` → `/login` se não houver sessão Supabase válida.
- `/admin/*` → `/` se `profiles.is_admin !== true`.
- `/organizador/*` → `/dashboard` se não tiver permissão.

### RLS (Row Level Security) no Postgres

Mesmo com middleware, todas as tabelas têm RLS habilitado. Mesmo que um usuário burle o frontend, o banco bloqueia operações não autorizadas no nível da query.

Políticas críticas:
- `inscricoes`: só o capitão do time pode inserir.
- `teams`: só o capitão pode atualizar seu time.
- `tournaments`: admins e o `created_by` podem atualizar.
- `player_stats`, `match_games`: só admins e Edge Functions com `service_role` podem inserir.

### Server Actions

Actions em `lib/actions/` chamam `requireAdmin()` que verifica `profiles.is_admin` no servidor antes de qualquer operação privilegiada.

---

## Query Params Relevantes

| Param | Rota | Uso |
|---|---|---|
| `?tournament={uuid}` | `/dashboard/times/criar` | Pré-seleciona o torneio na tela de inscrição |
| `?inscrito=true` | `/torneios/[slug]` | Exibe banner de confirmação pós-inscrição |
| `?criado=true` | *(removido)* | Era usado no fluxo antigo de criação de torneio |
