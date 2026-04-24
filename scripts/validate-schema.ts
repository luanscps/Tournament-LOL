// scripts/validate-schema.ts
// Uso: npx ts-node scripts/validate-schema.ts
// Requer: NEXT_PUBLIC_SUPABASE_URL e SUPABASE_SERVICE_ROLE_KEY no .env.local

import { createClient } from '@supabase/supabase-js'
import * as dotenv from 'dotenv'
import * as path from 'path'

dotenv.config({ path: path.resolve(process.cwd(), '.env.local') })

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
)

// ─── Definição esperada do schema ─────────────────────────────────────────────

const EXPECTED_TABLES: Record<string, string[]> = {
  profiles: ['id', 'email', 'full_name', 'avatar_url', 'is_admin', 'created_at'],
  tournaments: ['id', 'name', 'description', 'status', 'bracket_type', 'max_teams',
                'prize_pool', 'start_date', 'end_date', 'min_tier', 'created_at'],
  teams: ['id', 'tournament_id', 'name', 'tag', 'created_at'],
  players: ['id', 'team_id', 'summoner_name', 'tagline', 'role',
            'tier', 'rank', 'lp', 'wins', 'losses',
            'profile_icon', 'summoner_level', 'created_at'],
  inscricoes: ['id', 'tournament_id', 'team_id', 'status', 'requested_by', 'created_at'],
  seedings: ['id', 'tournament_id', 'team_id', 'seed'],
  tournament_stages: ['id', 'tournament_id', 'name', 'stage_order', 'bracket_type', 'best_of'],
  matches: ['id', 'tournament_id', 'stage_id', 'round', 'match_order',
            'team_a_id', 'team_b_id', 'status', 'format'],
  match_games: ['id', 'match_id', 'game_number', 'winner_team_id'],
  player_stats: ['id', 'match_game_id', 'player_id'],
  notifications: ['id', 'user_id', 'type', 'title', 'body', 'message', 'link', 'read', 'created_at'],
  audit_log: ['id', 'action', 'table_name', 'record_id', 'created_at'],
  // Riot — criadas em 009
  riot_accounts: ['id', 'profile_id', 'puuid', 'gamename', 'tagline',
                  'summoner_id', 'summoner_level', 'profile_icon_id', 'is_primary', 'created_at'],
  rank_snapshots: ['id', 'riot_account_id', 'queue_type', 'tier', 'rank',
                   'lp', 'wins', 'losses', 'hot_streak', 'snapshotted_at'],
  champion_masteries: ['id', 'riot_account_id', 'champion_id', 'champion_name',
                       'mastery_level', 'mastery_points', 'last_play_time'],
}

const MUST_NOT_EXIST: Record<string, string[]> = {
  players: ['tag_line', 'profile_id'],   // removidos em 008
  inscricoes: ['profile_id', 'user_id'], // nunca existiram — campo correto é requested_by
}

const RLS_TABLES = [
  'profiles', 'tournaments', 'teams', 'players', 'inscricoes',
  'notifications', 'riot_accounts', 'rank_snapshots', 'champion_masteries',
]

// ─── Helpers ──────────────────────────────────────────────────────────────────

type CheckResult = { ok: boolean; message: string }

async function getColumns(table: string): Promise<string[]> {
  const { data, error } = await supabase.rpc('exec_sql', {
    sql: `
      SELECT column_name
      FROM information_schema.columns
      WHERE table_schema = 'public'
        AND table_name   = '${table}'
      ORDER BY ordinal_position
    `,
  })
  if (error) {
    // fallback via select vazio
    const { data: fallback } = await supabase.from(table).select('*').limit(0)
    return fallback ? Object.keys(fallback[0] ?? {}) : []
  }
  return (data as { column_name: string }[]).map((r) => r.column_name)
}

async function tableExists(table: string): Promise<boolean> {
  const { error } = await supabase.from(table).select('id').limit(1)
  // 42P01 = table does not exist
  return !error || error.code !== '42P01'
}

async function rlsEnabled(table: string): Promise<boolean> {
  const { data } = await supabase.rpc('exec_sql', {
    sql: `
      SELECT relrowsecurity
      FROM pg_class
      WHERE relname = '${table}'
        AND relnamespace = 'public'::regnamespace
    `,
  })
  return !!(data as { relrowsecurity: boolean }[])?.[0]?.relrowsecurity
}

// ─── Checks ───────────────────────────────────────────────────────────────────

async function checkTables(): Promise<CheckResult[]> {
  const results: CheckResult[] = []

  for (const [table, cols] of Object.entries(EXPECTED_TABLES)) {
    const exists = await tableExists(table)
    if (!exists) {
      results.push({ ok: false, message: `❌ Tabela ausente: ${table}` })
      continue
    }
    results.push({ ok: true, message: `✅ Tabela existe: ${table}` })

    const actual = await getColumns(table)
    for (const col of cols) {
      if (!actual.includes(col)) {
        results.push({ ok: false, message: `   ❌ Coluna ausente em ${table}: ${col}` })
      }
    }

    // Colunas que NÃO devem existir
    if (MUST_NOT_EXIST[table]) {
      for (const col of MUST_NOT_EXIST[table]) {
        if (actual.includes(col)) {
          results.push({ ok: false, message: `   ⚠️  Coluna obsoleta ainda presente em ${table}: ${col}` })
        }
      }
    }
  }

  return results
}

async function checkRLS(): Promise<CheckResult[]> {
  const results: CheckResult[] = []
  for (const table of RLS_TABLES) {
    const exists = await tableExists(table)
    if (!exists) continue
    const enabled = await rlsEnabled(table)
    results.push({
      ok: enabled,
      message: enabled
        ? `✅ RLS ativo: ${table}`
        : `❌ RLS desativado: ${table}`,
    })
  }
  return results
}

async function checkFunctions(): Promise<CheckResult[]> {
  const EXPECTED_FUNCTIONS = [
    'set_updated_at',
    'log_admin_action',
    'generate_tournament_slug',
    'handle_new_user',
  ]
  const results: CheckResult[] = []

  for (const fn of EXPECTED_FUNCTIONS) {
    const { data } = await supabase.rpc('exec_sql', {
      sql: `
        SELECT proname FROM pg_proc
        WHERE proname = '${fn}'
          AND pronamespace = 'public'::regnamespace
        LIMIT 1
      `,
    })
    const found = !!(data as { proname: string }[])?.[0]
    results.push({
      ok: found,
      message: found
        ? `✅ Função existe: ${fn}()`
        : `❌ Função ausente: ${fn}()`,
    })
  }

  return results
}

// ─── Runner ───────────────────────────────────────────────────────────────────

async function main() {
  console.log('\n════════════════════════════════════════════════')
  console.log(' BRLOL — Validação de Schema Supabase')
  console.log('════════════════════════════════════════════════\n')

  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || !process.env.SUPABASE_SERVICE_ROLE_KEY) {
    console.error('❌ Variáveis de ambiente ausentes: NEXT_PUBLIC_SUPABASE_URL e/ou SUPABASE_SERVICE_ROLE_KEY')
    process.exit(1)
  }

  const allResults: CheckResult[] = []

  console.log('── Tabelas e Colunas ──')
  const tableResults = await checkTables()
  tableResults.forEach((r) => console.log(r.message))
  allResults.push(...tableResults)

  console.log('\n── Row Level Security ──')
  const rlsResults = await checkRLS()
  rlsResults.forEach((r) => console.log(r.message))
  allResults.push(...rlsResults)

  console.log('\n── Funções SQL ──')
  const fnResults = await checkFunctions()
  fnResults.forEach((r) => console.log(r.message))
  allResults.push(...fnResults)

  const failures = allResults.filter((r) => !r.ok)
  console.log('\n════════════════════════════════════════════════')

  if (failures.length === 0) {
    console.log('✅ Schema 100% válido — pronto para deploy!\n')
    process.exit(0)
  } else {
    console.log(`❌ ${failures.length} problema(s) encontrado(s). Corrija antes de fazer deploy.\n`)
    process.exit(1)
  }
}

main().catch((err) => {
  console.error('Erro fatal:', err)
  process.exit(1)
})
