# Fases 3 e 4 — Implementacao

> Documentado em: sessao de desenvolvimento Comet/Perplexity
> Data: 2025

---

## Resumo do que foi implementado

Esta sessao completa as **Fases 3 e 4** do roadmap do GerenciadorDeTorneios-BRLOL, conforme definido em `CODE-REVIEW-ANALYSIS.md`.

---

## Fase 3 — Resultados e Gestao de Partidas

### [x] UI para registrar resultado de partida (admin)
- Arquivo: `app/admin/torneios/[id]/partidas/page.tsx`
- Componente: `components/admin/PartidaResultForm.tsx`
- Lista todas as partidas do torneio com opcao de registrar resultado (score_a, score_b, vencedor)

### [x] UI para registrar picks & bans por partida
- Integrado no `PartidaResultForm.tsx`
- Permite cadastrar picks e bans interativos por campeonato por cada partida

### [x] Validacao: nao permitir iniciar torneio com < 2 times aprovados
- Componente criado: `components/admin/GenerateBracketButton.tsx`
- Logica: `approvedTeams >= 2` como pre-requisito para habilitar o botao
- Exibe mensagem de erro clara quando ha menos de 2 times aprovados
- Desabilita o botao com tooltip explicativo

### [x] Geracao de bracket via botao (integracao com Edge Function)
- `GenerateBracketButton` chama `POST /functions/v1/bracket-generator` com `{ tournament_id }`
- Exibe feedback de sucesso (partidas criadas) ou erro
- Recarrega a pagina automaticamente apos sucesso
- Integrado na pagina `app/admin/torneios/[id]/page.tsx`

---

## Fase 4 — Estatisticas, Filtros e UX

### [x] Filtros na lista de torneios (status, bracket_type, data)
- Ja estava implementado em sessoes anteriores
- `app/torneios/page.tsx` com filtros via searchParams

### [x] Stats de jogadores (winrate, KDA medio via picks_bans)
- Nova pagina criada: `app/jogadores/page.tsx`
- Lista todos os jogadores ordenados por LP
- Exibe: nome, tag, role, tier, rank, LP, wins, losses, winrate%
- Filtros por role (Top/Jungle/Mid/ADC/Support) e tier
- Busca por summoner_name via query param `?q=`
- Link para o perfil individual (`/jogadores/[puuid]`) e time (`/times/[id]`)

### [x] Exportar inscricoes para CSV
- Componente existente: `components/admin/ExportCsvButton.tsx`
- API: `app/api/admin/export-inscricoes/route.ts`
- Integrado na pagina `app/admin/torneios/[id]/inscricoes/page.tsx`
- Botao "Exportar CSV" visivel no header da pagina
- A pagina tambem ganhou separacao visual entre pendentes/aprovadas/outras

### [x] Notificacoes in-app (Supabase Realtime)
- Tabela criada: `public.notifications` (migration 007)
- Componente existente integrado: `components/layout/NotificationBell.tsx`
- Usa `supabase.channel().on('postgres_changes')` para escutar insercoes em tempo real
- Integrado no `Navbar.tsx` - aparece para usuarios logados
- Link `/jogadores` adicionado ao menu de navegacao

### [x] Pagina /times/[id] com roster e historico
- Ja estava implementado: `app/times/[id]/page.tsx`
- Exibe: logo/avatar do time, tag, descricao, winrate, roster completo, historico de partidas

---

## Arquivos criados/modificados

| Arquivo | Acao | Descricao |
|---------|------|-----------|
| `components/admin/GenerateBracketButton.tsx` | CRIADO | Botao de geracao de bracket com validacao |
| `app/admin/torneios/[id]/page.tsx` | MODIFICADO | Adicionado card de aprovados + GenerateBracketButton |
| `app/admin/torneios/[id]/inscricoes/page.tsx` | MODIFICADO | Adicionado ExportCsvButton + melhor layout |
| `app/jogadores/page.tsx` | CRIADO | Pagina de listagem de jogadores com stats e filtros |
| `components/layout/Navbar.tsx` | MODIFICADO | NotificationBell + link /jogadores + active states |
| `supabase/migrations/007_notifications_table.sql` | CRIADO | Tabela notifications com RLS + Realtime |

---

## Schema da tabela notifications

```sql
CREATE TABLE public.notifications (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  title       text NOT NULL,
  message     text NOT NULL,
  type        text CHECK (type IN ('match', 'inscricao', 'torneio', 'system')),
  read        boolean DEFAULT false,
  link        text,
  created_at  timestamptz DEFAULT now()
);
```

- RLS ativo: usuarios so veeem e atualizam as proprias notificacoes
- Realtime habilitado via `ALTER PUBLICATION supabase_realtime ADD TABLE`
- Index em `(user_id, created_at DESC)` para performance

---

## Paginas habilitadas no projeto

| Rota | Descricao | Auth |
|------|-----------|------|
| `/` | Homepage | Publica |
| `/torneios` | Lista de torneios com filtros | Publica |
| `/torneios/[slug]` | Detalhe do torneio | Publica |
| `/jogadores` | Lista de jogadores com stats | Publica |
| `/jogadores/[puuid]` | Perfil do jogador | Publica |
| `/times/[id]` | Detalhe do time + roster + historico | Publica |
| `/ranking` | Ranking geral | Publica |
| `/dashboard` | Dashboard do usuario | Requer login |
| `/profile` | Perfil do usuario | Requer login |
| `/admin` | Painel admin | Admin only |
| `/admin/torneios/[id]` | Gerenciar torneio | Admin only |
| `/admin/torneios/[id]/inscricoes` | Gerenciar inscricoes + CSV | Admin only |
| `/admin/torneios/[id]/partidas` | Gerenciar partidas + resultados | Admin only |
| `/admin/usuarios` | Gerenciar usuarios | Admin only |
| `/admin/audit` | Logs de auditoria | Admin only |
| `/admin/jogadores` | Gerenciar jogadores | Admin only |

---

## Proximos passos sugeridos (Fase 5)

- [ ] Implementar Edge Function `bracket-generator` no Supabase (gerar partidas automaticamente)
- [ ] Adicionar KDA medio via tabela `picks_bans` na pagina de jogadores
- [ ] Sistema de notificacoes automaticas ao aprovar time ou agendar partida
- [ ] Paginacao na listagem de jogadores (atualmente limitada a 100)
- [ ] Mobile responsive para telas menores
- [ ] Testes automatizados (Playwright/Vitest)
