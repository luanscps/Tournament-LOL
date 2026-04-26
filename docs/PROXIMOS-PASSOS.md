# Próximos Passos — GerenciadorDeTorneios BRLOL

> Atualizado em: **2026-04-26**

Backlog organizado por prioridade. Marque como `[x]` conforme for implementando.

---

## 🔴 Alta Prioridade (bugs / blocking)

- [x] Corrigir link "+ Inscrever meu time" na dashboard (`/dashboard/times/criar` — plural)
- [x] Corrigir UPDATE de torneio para usar `start_date`/`end_date` (não as colunas GENERATED)
- [x] Corrigir redirecionamento pós-criação de torneio para `/torneios/{id}/inscricoes`
- [x] `lib/actions/inscricao.ts` já usa `inscricoes` em 100% dos lugares — sem referência a `tournament_teams`
- [x] Todos os componentes já usam `summoner_name` / `tag_line` (com underscore) — verificado em `TeamCard.tsx`, `jogadores/[puuid]/page.tsx`, `api/admin/jogadores/route.ts`

---

## 🟡 Média Prioridade (melhorias de produto)

- [ ] `013_teams_slug.sql` — adicionar coluna `slug` em `teams` com backfill e unique index
- [ ] Migrar `app/times/[slug]` para usar slug textual real (não UUID)
- [ ] Padronizar `status` de torneios como enum rígido no Postgres
- [ ] Tela de check-in para times inscritos (botão em `/dashboard/times`)
- [ ] Página de perfil público do jogador com histórico de torneios e stats
- [ ] Integração completa do bracket (exibição visual do chaveamento no frontend)
- [ ] Sincronização automática de rank via Edge Function agendada
- [ ] Implementar fluxo de eliminação de times em `inscricoes.status = 'eliminated'`

---

## 🟢 Baixa Prioridade (polish / extras)

- [ ] Dark mode completo na UI
- [ ] Histórico de partidas na página pública do time
- [ ] Exportar bracket como imagem (PNG/PDF)
- [ ] Suporte a múltiplas contas Riot por perfil com troca de conta primária
- [ ] Discord webhook — configuração por torneio (canal customizável)
- [ ] Email transacional via `send-email` Edge Function
- [ ] Relatório de estatísticas do torneio (PDF) para o organizador
- [ ] PWA / mobile-friendly refinements

---

## ✅ Sprint 3 — Em andamento

- [x] `020_team_roster.sql` — `team_invites` + RLS + `accept_team_invite()` RPC + trigger expiração
- [ ] UI roster do capitão — `app/dashboard/times/[id]/roster/page.tsx`
- [ ] Componente `InvitePlayerForm` — `components/times/InvitePlayerForm.tsx`
- [ ] Página de convites recebidos — `app/dashboard/convites/page.tsx`

---

## ✅ Concluídos (histórico)

| Data | Item |
|---|---|
| 2026-04-22 | Schema inicial + migrations 001–005 |
| 2026-04-23 | Migrations 006–012, RLS, triggers, slug |
| 2026-04-24 | Correção `unaccent` → `translate()` no trigger de slug |
| 2026-04-25 | Fix link inscrição (`time` → `times`), fix editar torneio (`starts_at` → `start_date`) |
| 2026-04-25 | Redirect pós-criação de torneio → `/torneios/{id}/inscricoes` |
| 2026-04-26 | Documentação completa criada/atualizada em `/docs` |
| 2026-04-26 | Sprint 3: `020_team_roster.sql` — team_invites, RLS, RPC accept_team_invite |
| 2026-04-26 | Bugs blockers confirmados como já resolvidos no código (inscricao.ts + summonername) |
