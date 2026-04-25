# 🧪 Plano de Testes — GerenciadorDeTorneios-BRLOL

> Gerado em: 2026-04-25  
> Cobre: Partes 1, 2 e 3 (dashboard, admin, migrations, actions)

---

## 📋 Legenda de Status

| Símbolo | Significado |
|---------|-------------|
| ✅ | Implementado e correto |
| 🔧 | Corrigido nesta sprint |
| ⚠️ | Requer teste manual |
| ❌ | Risco identificado |

---

## 1. Migrations SQL

### 1.1 `008_fix_core_schema.sql` 🔧

| # | Teste | Como testar | Esperado |
|---|-------|-------------|----------|
| 1 | `tag_line` tem DEFAULT 'BR1' | `\d players` no psql | Coluna `tag_line DEFAULT 'BR1' NOT NULL` |
| 2 | Índice trigram em `summoner_name` | `\di players*` | `idx_players_summoner_name_trgm` presente |
| 3 | Índices em `inscricoes` | `\di inscricoes*` | 5 índices criados sem erro |
| 4 | Migração idempotente | Rodar 2x | `CREATE INDEX IF NOT EXISTS` — sem erro na segunda vez |

**Comando de validação:**
```sql
SELECT indexname FROM pg_indexes
WHERE tablename IN ('players','inscricoes')
ORDER BY indexname;
```

---

## 2. Server Actions — `lib/actions/inscricao.ts` 🔧

### 2.1 `criarInscricao(teamId, tournamentId)`

| # | Cenário | Esperado |
|---|---------|----------|
| 1 | Usuário autenticado inscreve time válido | `{ success: true }` + registro em `inscricoes` com `status=PENDING` |
| 2 | Usuário não autenticado | `{ error: 'Nao autenticado' }` |
| 3 | Inscrição duplicada (team+torneio já existe) | Erro de constraint único do Postgres |
| 4 | `revalidatePath` dispara | Cache de `/dashboard/times` e `/torneios/:id` limpo |

### 2.2 `aprovarInscricao(teamId, tournamentId)`

| # | Cenário | Esperado |
|---|---------|----------|
| 5 | Admin aprova inscrição PENDING | `status=APPROVED`, `checked_in_at` preenchido, `reviewed_by=adminId` |
| 6 | Não-admin tenta aprovar | `{ error: 'Sem permissao' }` |
| 7 | Inscrição inexistente | `0 rows affected`, sem erro fatal |

### 2.3 `rejeitarInscricao(teamId, tournamentId)`

| # | Cenário | Esperado |
|---|---------|----------|
| 8 | Admin rejeita inscrição | `status=REJECTED`, `reviewed_by=adminId` |
| 9 | Não-admin tenta rejeitar | `{ error: 'Sem permissao' }` |

### 2.4 `listarInscricoesPorTorneio(tournamentId)`

| # | Cenário | Esperado |
|---|---------|----------|
| 10 | Torneio com inscrições | Array com join de `teams` contendo `id, name, tag` |
| 11 | Torneio sem inscrições | Array vazio `[]` |
| 12 | Ordenação | `created_at ASC` |

---

## 3. Dashboard — `app/dashboard/page.tsx` ✅

| # | Cenário | Esperado |
|---|---------|----------|
| 13 | Usuário sem conta Riot vinculada | Exibe link "Vincule sua conta Riot" |
| 14 | Usuário com conta Riot + player cadastrado | Exibe `summoner_name #tag_line` |
| 15 | Usuário com time inscrito | Lista inscrições com nome do time e torneio |
| 16 | Usuário sem time | Mensagem "Você ainda não está em nenhum time" |
| 17 | Torneios abertos disponíveis | Seção "Inscrições Abertas" com até 3 torneios |
| 18 | Usuário não autenticado | Redirect para `/login` |

**Query crítica a validar:**
```ts
// Deve usar summoner_name e tag_line (snake_case)
.eq('summoner_name', profile.riot_game_name)
.eq('tag_line', profile.riot_tag_line ?? 'BR1')
```

---

## 4. Dashboard Jogador — `app/dashboard/jogador/registrar/page.tsx` ✅

| # | Cenário | Esperado |
|---|---------|----------|
| 19 | Busca com formato inválido (sem `#`) | Erro "Use o formato Nome#TAG" |
| 20 | Busca com Riot ID válido | Retorna perfil, rank, maestrias |
| 21 | Vincular conta Riot | Upsert em `riot_accounts` + insert em `rank_snapshots` + `champion_masteries` |
| 22 | Conta já vinculada (mesmo puuid) | Upsert atualiza sem duplicar (onConflict: puuid) |
| 23 | API Key expirada | Exibe link para renovar em developer.riotgames.com |

---

## 5. Dashboard Times — `app/dashboard/times/criar/page.tsx` ✅

| # | Cenário | Esperado |
|---|---------|----------|
| 24 | Acesso sem conta Riot vinculada | Tela de bloqueio com link para vincular |
| 25 | Acesso sem `?tournament=` na URL | Erro "Nenhum torneio selecionado" |
| 26 | Usuário já criou time neste torneio | Erro com nome do time existente |
| 27 | Jogador já está em outro time | Erro "Você já está em um time" |
| 28 | Criação bem-sucedida | Time criado → capitão adicionado em `players` → inscrição `PENDING` em `inscricoes` |
| 29 | `tag` menor que 2 chars | Botão submit desabilitado |
| 30 | Redirect após criação | `/torneios/:tournamentId?inscrito=true` |

---

## 6. Admin — Painel de Jogadores (`app/admin/jogadores`) ✅

| # | Cenário | Esperado |
|---|---------|----------|
| 31 | Listar todos os jogadores | GET `/api/admin/jogadores` retorna array com `summoner_name`, `tag_line` |
| 32 | Filtrar por nome | Busca case-insensitive no campo search |
| 33 | Filtrar por time | Dropdown com todos os times únicos |
| 34 | PATCH atualizar role | Status 200 com `{ success: true }` |
| 35 | PATCH atualizar team_id | Player movido para novo time |

---

## 7. Testes de Integração SQL (Supabase)

Executar direto no **SQL Editor** do Supabase:

```sql
-- T1: Verificar colunas da tabela players
SELECT column_name, data_type, column_default, is_nullable
FROM information_schema.columns
WHERE table_name = 'players'
  AND column_name IN ('summoner_name', 'tag_line', 'team_id', 'puuid')
ORDER BY column_name;

-- T2: Verificar colunas da tabela inscricoes
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'inscricoes'
ORDER BY ordinal_position;

-- T3: Simular criarInscricao
INSERT INTO inscricoes (team_id, tournament_id, requested_by, status)
VALUES (
  '<team-uuid>',
  '<tournament-uuid>',
  '<user-uuid>',
  'PENDING'
)
RETURNING *;

-- T4: Simular aprovarInscricao
UPDATE inscricoes
  SET status = 'APPROVED',
      checked_in_at = now(),
      reviewed_by = '<admin-uuid>'
  WHERE team_id = '<team-uuid>'
    AND tournament_id = '<tournament-uuid>'
RETURNING *;

-- T5: Verificar índices criados pela migration 008
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename IN ('players', 'inscricoes')
ORDER BY tablename, indexname;
```

---

## 8. Checklist Final Pré-Deploy

- [ ] Migration `008` aplicada sem erros no Supabase
- [ ] `inscricoes` tem colunas `checked_in_at`, `reviewed_by`, `requested_by`
- [ ] `players` não tem colunas `tagline`, `tagline_`, `summonername`
- [ ] `lib/actions/inscricao.ts` exporta `criarInscricao`, `aprovarInscricao`, `rejeitarInscricao`, `listarInscricoesPorTorneio`
- [ ] Dashboard carrega sem erros de hidratação no console
- [ ] Fluxo criar time → inscrição pendente → aprovação admin funcionando end-to-end
- [ ] Nenhuma referência a `tournament_teams` no codebase (`grep -r tournament_teams .`)
