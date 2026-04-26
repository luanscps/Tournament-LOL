-- ============================================================
-- RESET + SEED DEMO — GerenciadorDeTorneios-BRLOL
-- Gerado em 2026-04-25
-- 6 torneios | 20 times | 200 jogadores | matches + stats
-- Execute no Supabase SQL Editor (query única)
-- ============================================================

-- ---------------------------------------------------------------
-- 1. LIMPEZA (ordem respeita FKs)
-- ---------------------------------------------------------------
TRUNCATE TABLE
  player_stats,
  match_games,
  matches,
  tournament_stages,
  inscricoes,
  players,
  teams,
  tournaments,
  notifications,
  audit_log,
  champion_masteries,
  rank_snapshots,
  riot_accounts
RESTART IDENTITY CASCADE;

-- NOTA: profiles NÃO é truncado para não quebrar auth.users.
-- O admin demo abaixo usa ON CONFLICT para não duplicar.
