// supabase/functions/bracket-generator/index.ts
import { createClient } from 'jsr:@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface MatchInsert {
  tournament_id: string
  stage_id: string
  round: number
  match_order: number
  team_a_id: string
  team_b_id: string
  status: 'SCHEDULED'
  format: 'BO1' | 'BO3' | 'BO5'
}

function formatFromBestOf(bestOf: number | null | undefined): 'BO1' | 'BO3' | 'BO5' {
  if (bestOf === 3) return 'BO3'
  if (bestOf === 5) return 'BO5'
  return 'BO1'
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { tournament_id } = await req.json()
    if (!tournament_id) {
      return new Response(JSON.stringify({ error: 'tournament_id obrigatório' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    const { data: tournament, error: tErr } = await supabase
      .from('tournaments')
      .select('id, name, bracket_type, max_teams')
      .eq('id', tournament_id)
      .single()

    if (tErr || !tournament) {
      return new Response(JSON.stringify({ error: 'Torneio não encontrado' }), {
        status: 404,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // FIX: tabela correta é tournament_stages (migration 002)
    const { data: stages } = await supabase
      .from('tournament_stages')
      .select('id, bracket_type, best_of')
      .eq('tournament_id', tournament_id)
      .order('stage_order', { ascending: true })

    const stage = stages?.[0]
    if (!stage) {
      return new Response(
        JSON.stringify({ error: 'Nenhuma fase encontrada. Crie uma fase primeiro.' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const { data: inscricoes } = await supabase
      .from('inscricoes')
      .select('team_id')
      .eq('tournament_id', tournament_id)
      .eq('status', 'APPROVED')

    if (!inscricoes || inscricoes.length < 2) {
      return new Response(
        JSON.stringify({ error: 'Mínimo 2 times aprovados necessários' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const { data: seedsData } = await supabase
      .from('seedings')
      .select('team_id, seed')
      .eq('tournament_id', tournament_id)
      .order('seed', { ascending: true })

    let orderedTeams: string[]
    if (seedsData && seedsData.length === inscricoes.length) {
      orderedTeams = seedsData.map((s) => s.team_id)
    } else {
      orderedTeams = inscricoes.map((i) => i.team_id).sort(() => Math.random() - 0.5)
    }

    const bracketType: string = stage.bracket_type || tournament.bracket_type
    const fmt = formatFromBestOf(stage.best_of)
    const matches: MatchInsert[] = []

    if (bracketType === 'SINGLE_ELIMINATION') {
      const totalSlots = Math.pow(2, Math.ceil(Math.log2(orderedTeams.length)))
      const padded: (string | null)[] = [...orderedTeams, ...Array(totalSlots - orderedTeams.length).fill(null)]

      let round = 1
      let roundTeams: (string | null)[] = padded

      while (roundTeams.length > 1) {
        const nextRound: (string | null)[] = []
        for (let i = 0; i < roundTeams.length; i += 2) {
          const teamA = roundTeams[i]
          const teamB = roundTeams[i + 1]
          const matchOrder = Math.floor(i / 2) + 1
          if (teamA && teamB) {
            matches.push({ tournament_id, stage_id: stage.id, round, match_order: matchOrder, team_a_id: teamA, team_b_id: teamB, status: 'SCHEDULED', format: fmt })
            nextRound.push(null)
          } else if (teamA && !teamB) {
            nextRound.push(teamA) // BYE
          } else {
            nextRound.push(null)
          }
        }
        round++
        roundTeams = nextRound
      }

    } else if (bracketType === 'ROUND_ROBIN') {
      const teams: (string | null)[] = [...orderedTeams]
      if (teams.length % 2 !== 0) teams.push(null)
      const totalRounds = teams.length - 1
      const half = teams.length / 2

      for (let round = 1; round <= totalRounds; round++) {
        let matchOrder = 1
        for (let i = 0; i < half; i++) {
          const teamA = teams[i]
          const teamB = teams[teams.length - 1 - i]
          if (teamA && teamB) {
            matches.push({ tournament_id, stage_id: stage.id, round, match_order: matchOrder++, team_a_id: teamA, team_b_id: teamB, status: 'SCHEDULED', format: fmt })
          }
        }
        const last = teams.pop()!
        teams.splice(1, 0, last)
      }

    } else if (bracketType === 'SWISS') {
      let matchOrder = 1
      for (let i = 0; i < orderedTeams.length - 1; i += 2) {
        matches.push({ tournament_id, stage_id: stage.id, round: 1, match_order: matchOrder++, team_a_id: orderedTeams[i], team_b_id: orderedTeams[i + 1], status: 'SCHEDULED', format: fmt })
      }
    }

    // Limpar partidas anteriores da fase e reinserir
    await supabase.from('matches').delete().eq('stage_id', stage.id)

    const { error: insertErr } = await supabase.from('matches').insert(matches)
    if (insertErr) {
      return new Response(JSON.stringify({ error: insertErr.message }), {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    await supabase.rpc('log_admin_action', {
      p_action: 'BRACKET_GENERATED',
      p_table_name: 'matches',
      p_record_id: tournament_id,
      p_old_data: null,
      p_new_data: { matches_created: matches.length, bracket_type: bracketType },
    })

    return new Response(
      JSON.stringify({ success: true, matches_created: matches.length, bracket_type: bracketType }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Erro interno'
    return new Response(JSON.stringify({ error: message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})