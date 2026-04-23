# Code Review & Análise de Estado Atual

> **Data:** 2025-07  
> **Revisado por:** Comet (AI Assistant)  
> **Projeto:** GerenciadorDeTorneios-BRLOL  
> **Branch:** main

---

## 1. O que foi feito até agora

### Fase 1 — Backend (100% Completa)
- **Banco de dados:** Todas as tabelas criadas via migrations Supabase
  - `tournaments`, `teams`, `players`, `inscricoes`, `matches`, `seedings`, `audit_log`, `player_leaderboard`
- **Triggers/Views:** RLS ativado, views de ranking funcionando
- **Edge Functions implementadas:**
  - `bracket-generator` — Gera bracket (SINGLE_ELIMINATION, ROUND_ROBIN, SWISS)
  - `riot-api-sync` — Sincroniza tier/rank/LP via Riot API v5
  - `discord-webhook` — Notificações via Discord embeds
  - `send-email` — Templates HTML via Resend
- **Demo seed:** 40 jogadores fictícios + 4 times + 1 torneio inseridos com sucesso
- **Fix crítico:** Extensão `unaccent` substituída por `translate()` nativo no PostgreSQL

### Fase 2 — Frontend Base (Completa)
- **Páginas públicas:** `/torneios`, `/torneios/[id]`, `/ranking`, `/times`
- **Páginas autenticadas:** `/dashboard`, `/profile`
- **Painel Admin:** `/admin` com sub-páginas: `audit`, `jogadores`, `torneios`, `usuarios`
- **BracketView:** Componente com Realtime subscriptions (Supabase Channels)
- **Página pública de torneio:** `/t/[slug]` com bracket, times e resultados recentes

### Infraestrutura
- Vercel: 96+ deploys, build funcionando
- `.vercelignore`: pasta `docs/` excluída do build
- `tsconfig.json`: `supabase/functions/` excluído para evitar erros de tipo Deno
- Supabase: RLS configurado, Edge Functions prontas

---

## 2. Páginas habilitadas no projeto

| Rota | Tipo | Status |
|------|------|--------|
| `/` | Pública | ✅ Home |
| `/torneios` | Pública | ✅ Lista de torneios |
| `/torneios/[id]` | Pública | ✅ Detalhe do torneio |
| `/t/[slug]` | Pública | ✅ Página pública com bracket |
| `/ranking` | Pública | ✅ Ranking de invocadores |
| `/times` | Pública | ✅ Lista de times |
| `/jogadores` | Pública | ✅ Lista de jogadores |
| `/dashboard` | Autenticado | ✅ Dashboard do usuário |
| `/profile` | Autenticado | ✅ Perfil do usuário |
| `/admin` | Admin | ✅ Painel admin |
| `/admin/audit` | Admin | ✅ Log de auditoria |
| `/admin/jogadores` | Admin | ✅ Gerenciar jogadores |
| `/admin/torneios` | Admin | ✅ Gerenciar torneios |
| `/admin/torneios/[id]` | Admin | ✅ Detalhe admin torneio |
| `/admin/torneios/[id]/partidas` | Admin | ✅ Partidas do torneio |
| `/admin/usuarios` | Admin | ✅ Gerenciar usuários |
| `/admin/inscricoes` | Admin | ✅ Gerenciar inscrições |

---

## 3. Análise de Código — Pontos de Atenção

### 3.1 BracketView (components/tournament/BracketView.tsx)
**Problema detectado:** `window.location.reload()` em caso de INSERT é frágil em produção.  
**Sugestão:** Usar `router.refresh()` do Next.js ou refetch via SWR/React Query ao invés de reload completo.

```tsx
// ❌ Atual
window.location.reload()

// ✅ Recomendado
import { useRouter } from 'next/navigation'
const router = useRouter()
router.refresh()
```

### 3.2 Middleware (middleware.ts)
**Status:** Funcionando com `CookieOptions` explícito.  
**Sugestão:** Garantir que o matcher exclua rotas públicas `/t/[slug]` para performance:

```ts
export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico|t/).*)'],
}
```

### 3.3 Edge Functions — riot-api-sync
**Ponto de atenção:** A função faz até 20 players por execução com `await new Promise(r => setTimeout(r, 100))` como rate limiting. Isso é adequado para o plano gratuito da Riot API mas pode causar timeout nas Edge Functions (limite de 2s no plano free da Supabase).  
**Sugestão:** Reduzir o limite para 5-10 players por execução e usar um cron job agendado.

### 3.4 send-email — Template HTML
**Ponto de atenção:** O HTML inline pode ser rejeitado por alguns clientes de email (Outlook).  
**Sugestão:** Usar `mjml` ou mover para templates em arquivos separados futuramente.

### 3.5 Admin Panel — Falta de confirmação de ações destrutivas
**Sugestão:** Adicionar modal de confirmação antes de ações como deletar torneio, rejeitar inscrição, banir usuário.

```tsx
// Exemplo pattern sugerido
const [confirm, setConfirm] = useState<string | null>(null)
// Exibir AlertDialog antes de executar ação
```

### 3.6 generate_tournament_slug (Migration 005)
**Fix aplicado:** Função reescrita usando `translate()` nativo do PostgreSQL ao invés de `unaccent` para evitar erro de extensão não instalada.  
**Status:** ✅ Resolvido e testado.

---

## 4. Sugestões de Melhorias Prioritárias

### Alta Prioridade
1. **Adicionar resultado de partida no Admin** — Página `/admin/torneios/[id]/partidas` deve permitir registrar placar (score_a, score_b, winner_team_id) diretamente
2. **Checkin de jogadores** — Implementar fluxo de check-in antes do torneio começar
3. **Gerar bracket via botão no Admin** — Botão que chama a Edge Function `bracket-generator` a partir do painel admin

### Média Prioridade
4. **Filtros no ranking** — Filtrar por tier (CHALLENGER, GRANDMASTER, etc.) e por posição
5. **Histórico de partidas por jogador** — Na página `/jogadores/[id]`, listar partidas disputadas
6. **Exportar dados** — Botão para exportar CSV de inscrições, resultados

### Baixa Prioridade
7. **Picks & Bans** — Tabela `picks_bans` já estruturada no banco; implementar UI
8. **MVP por partida** — Campo `mvp_player_id` já existe na tabela `matches`
9. **Notificações in-app** — Usar Supabase Realtime para alertas ao vivo no dashboard

---

## 5. O que ainda está pendente (Fases 3 e 4)

### Fase 3 — Resultados e Gestão de Partidas
- [ ] UI para registrar resultado de partida (admin)
- [ ] UI para registrar picks & bans por partida
- [ ] Validação: não permitir iniciar torneio com < 2 times aprovados
- [ ] Geração de bracket via botão (integração com Edge Function)

### Fase 4 — Estatísticas, Filtros e UX
- [ ] Filtros na lista de torneios (status, bracket_type, data)
- [ ] Stats de jogadores (winrate, KDA médio via picks_bans)
- [ ] Exportar inscrições para CSV
- [ ] Notificações in-app (Supabase Realtime)
- [ ] Página de times `/times/[id]` com roster e histórico

---

## 6. Dados de Demo Inseridos (005_demo_seed.sql)

| Entidade | Quantidade |
|----------|------------|
| Torneio | 1 |
| Times | 4 |
| Jogadores | 40 |
| Inscrições | 4 |
| Seedings | 4 |

**Times criados:**
- Dragões do Abismo (DBA)
- Fênix Relentless (FNX)
- Lobos da Névoa (LNV)
- Titãs Eternos (TTE)

---

## 7. Referências Técnicas

- Supabase Project ID: `awbieglbwhfavxlghuvy`
- Vercel: [gerenciador-de-torneios-brlol.vercel.app](https://gerenciador-de-torneios-brlol.vercel.app)
- GitHub: [luanscps/GerenciadorDeTorneios-BRLOL](https://github.com/luanscps/GerenciadorDeTorneios-BRLOL)
- Stack: Next.js 15, Supabase (PostgreSQL + Edge Functions), Vercel, Resend, Tailwind CSS
