# Próximos Passos — GerenciadorDeTorneios BRLOL

> Backlog de alto nível.  
> Detalhes de impacto em modelo de dados ou integrações devem ser avaliados sempre em conjunto com `docs/BRLOL-DOCS-UNIFICADO.md`.

---

## 🔴 Alta prioridade (bugs / ajustes críticos)

Itens desta seção devem ser tratados antes de novas features.

- [x] Corrigir link "+ Inscrever meu time" na dashboard (`/dashboard/times/criar` — plural). Já ajustado no código.[cite:32]
- [x] Corrigir UPDATE de torneio para usar `start_date`/`end_date` e não colunas GENERATED. Já implementado (não enviar `starts_at`/`ends_at` no payload).[cite:32]
- [x] Corrigir redirecionamento pós‑criação de torneio para a tela de inscrições. Já em produção.[cite:32]
- [x] Confirmar que `lib/actions/inscricao.ts` usa apenas a tabela de inscrições atual (sem referências legadas).[cite:33]
- [x] Confirmar padronização de `summoner_name` / `tag_line` no frontend e na API. Já verificado conforme anotado neste doc.[cite:33]

---

## 🟡 Média prioridade (melhorias de produto)

Refinamentos que melhoram muito a usabilidade sem mudar o core do domínio.

- [ ] Adicionar coluna `slug` em `teams` com backfill + índice único, e migrar páginas de time para usar o slug textual nas URLs.
- [ ] Padronizar `status` de torneios como enum rígido no Postgres (ajuste em migrations + doc unificada).
- [ ] Criar tela de check‑in para times inscritos (botões na dashboard / página do torneio).
- [ ] Página de perfil público do jogador com histórico de torneios e stats (reaproveitando views já existentes).
- [ ] Integração completa do bracket no frontend (visualização e interação com a chave gerada).
- [ ] Sincronização automática de rank via job agendado (Edge Function ou cron), alinhado às tabelas de snapshot.
- [ ] UX para marcar times eliminados e refletir isso na interface (sem duplicar regra de domínio deste doc).

---

## 🟢 Baixa prioridade (polish / extras)

Melhorias de qualidade que podem ser feitas de forma incremental.

- [ ] Dark mode completo na UI.
- [ ] Histórico de partidas na página pública do time com filtros simples.
- [ ] Exportar bracket como imagem (PNG/PDF) para divulgação.
- [ ] Suporte a múltiplas contas Riot por perfil com troca de conta primária na UI.
- [ ] Configuração de Discord webhook por torneio.
- [ ] Flows de e‑mail transacional via Edge Function `send-email` (convites, avisos, lembretes).
- [ ] Relatório de estatísticas do torneio (PDF) para organizador.
- [ ] Refinos mobile (PWA/responsividade) baseados em métricas de uso.

---

## ✅ Sprint 3 — Roster e convites

Relaciona tarefas da Sprint 3 associadas a gerenciamento de roster/convites.  
O schema completo dessas features está em `BRLOL-DOCS-UNIFICADO.md` (team_invites, RPC, RLS, etc.).

- [x] Criar e aplicar migration `team_roster` (`team_invites` + RLS + RPC `accept_team_invite()` + trigger de expiração).[cite:33]
- [ ] UI de roster do capitão (`app/dashboard/times/[id]/roster/page.tsx`).
- [ ] Componente de convite de jogador (`components/times/InvitePlayerForm.tsx`).
- [ ] Página de convites recebidos (`app/dashboard/convites/page.tsx`).

---

## ✅ Concluídos (histórico)

Mantém um log resumido do progresso, sem repetir detalhes técnicos que já estão nos docs de arquitetura/migrations.

| Data | Item |
|---|---|
| 2026‑04‑22 | Schema inicial + migrations 001–005.[cite:33] |
| 2026‑04‑23 | Migrations 006–012, RLS, triggers, slug.[cite:33] |
| 2026‑04‑24 | Correção `unaccent` → `translate()` em trigger de slug.[cite:33] |
| 2026‑04‑25 | Fix link de inscrição (`time` → `times`) e edição de torneio (`starts_at` → `start_date`).[cite:33] |
| 2026‑04‑26 | Documentação unificada em `/docs` criada/atualizada.[cite:29] |
| 2026‑04‑26 | Sprint 3: migration de roster (`team_invites`, RLS, RPC `accept_team_invite`).[cite:33] |
| 2026‑04‑26 | Bugs bloqueadores confirmados como resolvidos no código (inscricao.ts + campos de summoner).[cite:33] |
