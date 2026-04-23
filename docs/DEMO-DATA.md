# Demo Data - GerenciadorDeTorneios-BRLOL

> Documentacao dos dados de demonstracao inseridos no banco de dados para validacao das funcionalidades das Fases 3 e 4.

## Visao Geral

O projeto possui dois scripts de seed para demonstracao:

| Arquivo | Descricao | Status |
|---------|-----------|--------|
| `005_demo_seed.sql` | Base: 40 jogadores, 4 times, 1 torneio | Executado |
| `006_demo_phases3-4.sql` | Fases 3-4: stages, partidas, picks/bans, player_stats, notifications | Executado |

---

## Times Ficticios (4 times)

| Tag | Nome | ID |
|-----|------|----|
| AGD | Aguias Douradas | `23175448-c8ba-41b0-ac9e-9d2df72a0319` |
| DDF | Dragoes de Fogo | `f5b9d5bc-a4ca-44a1-9f16-575e7d6a2a3d` |
| LSL | Leoes Selvagens | `319215ab-0248-4d09-ad17-d12d83397b76` |
| LDN | Lobos da Noite | `697bc87c-460b-43f0-865c-60e7a97f4003` |

**Total: 40 jogadores** (10 por time)

---

## Torneio Demo

- **Nome:** BRLOL Championship 2025 - Season 1
- **Tier:** Challenger
- **Status:** IN_PROGRESS
- **Formato:** 5v5, Swiss + Single Elimination

---

## Fases do Torneio (tournament_stages)

| Fase | Stage Order | Best Of | Bracket Type |
|------|-------------|---------|---------------|
| Fase de Grupos | 1 | BO1 | - |
| Semifinal | 2 | BO3 | - |
| Grande Final | 3 | BO5 | - |

---

## Partidas (matches)

### Fase de Grupos

| Partida | Time A | Time B | Vencedor | Status | Formato |
|---------|--------|--------|----------|--------|--------|
| Match 1 | AGD | DDF | AGD | FINISHED | BO1 |
| Match 2 | LSL | LDN | LSL | FINISHED | BO1 |
| Match 3 | AGD | LSL | LSL | FINISHED | BO1 |

### Semifinal

| Partida | Time A | Time B | Vencedor | Status | Formato | Resultado |
|---------|--------|--------|----------|--------|---------|----------|
| Match 4 | DDF | LDN | DDF | FINISHED | BO3 | 2-1 |

### Grande Final

| Partida | Time A | Time B | Status | Formato |
|---------|--------|--------|--------|--------|
| Match 5 | LSL | DDF | SCHEDULED | BO5 |

---

## Picks & Bans (match_games.picks_bans JSONB)

Estrutura do campo `picks_bans`:

```json
{
  "picks": [
    { "team": "AGD", "champion": "Jinx" },
    { "team": "DDF", "champion": "Caitlyn" }
  ],
  "bans": [
    { "team": "AGD", "champion": "Zed" },
    { "team": "DDF", "champion": "Lee Sin" }
  ]
}
```

### Picks/Bans por Jogo

| Jogo | AGD Picks | DDF Picks | Bans |
|------|-----------|-----------|------|
| Match 1 Game 1 | Jinx | Caitlyn | Zed, Lee Sin |
| Match 2 Game 1 | Ahri (LSL) | Lux (LDN) | Yasuo, Katarina |
| Match 3 Game 1 | Ezreal (AGD) | Zed (LSL) | Ahri, Jinx |
| Match 4 Game 1 | Caitlyn (DDF) | Draven (LDN) | Zed, Ahri |
| Match 4 Game 2 | Jinx (DDF) | Caitlyn (LDN) | Lee Sin, Thresh |
| Match 4 Game 3 | Ezreal (DDF) | Jhin (LDN) | Yasuo, Zed |

---

## Player Stats

| Jogador | Time | Campeao | K/D/A | CS | MVP | Partida |
|---------|------|---------|-------|----|-----|--------|
| GoldenWings | AGD | Jinx | 8/2/5 | 210 | Sim | Match 1 G1 |
| (jogador DDF) | DDF | Caitlyn | 3/6/1 | 185 | Nao | Match 1 G1 |
| (jogador LSL) | LSL | Ahri | 10/1/8 | 240 | Sim | Match 2 G1 |
| (jogador LDN) | LDN | Lux | 4/7/3 | 195 | Nao | Match 2 G1 |

---

## Notificacoes Demo

| Tipo | Titulo | Destinatarios |
|------|--------|---------------|
| `match_result` | Resultado: AGD 1x0 DDF | 5 perfis |
| `tournament_update` | Grande Final Agendada! | 5 perfis |
| `checkin_open` | Check-in Aberto! | 5 perfis |

---

## Como Reexecutar

> **ATENCAO:** O script 006 nao tem `ON CONFLICT DO NOTHING` nas stages e matches.
> Para reexecutar, limpe os dados primeiro:

```sql
-- Limpar dados de demo (ordem de dependencia)
DELETE FROM public.player_stats WHERE team_id IN (
  '23175448-c8ba-41b0-ac9e-9d2df72a0319',
  'f5b9d5bc-a4ca-44a1-9f16-575e7d6a2a3d',
  '319215ab-0248-4d09-ad17-d12d83397b76',
  '697bc87c-460b-43f0-865c-60e7a97f4003'
);
DELETE FROM public.match_games
WHERE match_id IN (SELECT id FROM public.matches WHERE tournament_id = (
  SELECT id FROM public.tournaments LIMIT 1
));
DELETE FROM public.matches WHERE tournament_id = (
  SELECT id FROM public.tournaments LIMIT 1
);
DELETE FROM public.tournament_stages WHERE tournament_id = (
  SELECT id FROM public.tournaments LIMIT 1
);
-- Entao reexecute 006_demo_phases3-4.sql
```

---

## Enum match_status

Valores validos para o campo `status` em `matches`:
- `SCHEDULED` - Partida agendada (nao iniciada)
- `IN_PROGRESS` - Partida em andamento
- `FINISHED` - Partida finalizada

---

## Paginas Disponiveis no Projeto

| Rota | Descricao |
|------|-----------|
| `/` | Home / Dashboard principal |
| `/torneios` | Lista de torneios com filtros por tier/status |
| `/torneios/[id]` | Detalhe do torneio (partidas, bracket, inscricoes) |
| `/ranking` | Ranking de times com filtro por tier |
| `/times` | Lista de todos os times |
| `/times/[id]` | Perfil do time: roster e historico de partidas |
| `/admin` | Painel administrativo (requer role admin) |
| `/admin/torneios/novo` | Criar novo torneio |
| `/admin/torneios/[id]/editar` | Editar torneio |
| `/api/admin/export-inscricoes?tournamentId=...` | Exportar inscricoes CSV |

---

## Resumo de Dados no Banco

```sql
-- Verificar contagens
SELECT
  (SELECT count(*) FROM public.tournaments) as torneios,
  (SELECT count(*) FROM public.teams) as times,
  (SELECT count(*) FROM public.players) as jogadores,
  (SELECT count(*) FROM public.tournament_stages) as fases,
  (SELECT count(*) FROM public.matches) as partidas,
  (SELECT count(*) FROM public.match_games) as jogos_individuais,
  (SELECT count(*) FROM public.player_stats) as player_stats,
  (SELECT count(*) FROM public.notifications) as notificacoes;
```

**Resultado esperado:** 1 torneio | 4 times | 40 jogadores | 3 fases | 5 partidas | 6 jogos | 4+ stats | 10+ notificacoes

---

*Documentacao gerada em: 2025*  
*Script: `supabase/migrations/006_demo_phases3-4.sql`*
