import { createClient } from 'jsr:@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { tournament_id } = await req.json()
    if (!tournament_id) {
      return new Response(JSON.stringify({ error: 'tournament_id is required' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseKey)

    // 1. Buscar dados do torneio e stages
    const { data: tournament, error: tErr } = await supabase
      .from('tournaments')
      .select('id, name, bracket_type')
      .eq('id', tournament_id)
      .single()
    if (tErr || !tournament) throw new Error('Tournament not found')

    const { data: stage } = await supabase
      .from('tournament_stages')
      .select('id, bracket_type, stage_order')
      .eq('tournament_id', tournament_id)
      .order('stage_order', { ascending: true })
      .limit(1)
      .single()

    const bracketType = stage?.bracket_type ?? tournament.bracket_type ?? 'SINGLE_ELIMINATION'
    const stageId = stage?.id ?? null

    // 2. Buscar times aprovados com seedagem
    const { data: inscricoes, error: iErr } = await supabase
      .from('inscricoes')
      .select('team_id, teams(id, name, tag)')
      .eq('tournament_id', tournament_id)
      .eq('status', 'APPROVED')
    if (iErr) throw iErr

    const { data: seedingsData } = await supabase
      .from('seedings')
      .select('team_id, seed')
      .eq('tournament_id', tournament_id)
      .order('seed', { ascending: true })

    // Ordenar times por seed se existir
    const teamIds: string[] = []
    if (seedingsData && seedingsData.length > 0) {
      const seedMap = new Map(seedingsData.map((s: any) => [s.team_id, s.seed]))
      const sorted = (inscricoes ?? []).sort((a: any, b: any) => {
        const sa = seedMap.get(a.team_id) ?? 999
        const sb = seedMap.get(b.team_id) ?? 999
        return sa - sb
      })
      sorted.forEach((i: any) => teamIds.push(i.team_id))
    } else {
      // Aleatorizar se sem seeds
      const shuffled = [...(inscricoes ?? [])].sort(() => Math.random() - 0.5)
      shuffled.forEach((i: any) => teamIds.push(i.team_id))
    }

    const n = teamIds.length
    if (n < 2) throw new Error('Need at least 2 approved teams')

    // 3. Deletar matches existentes deste torneio (regenerar)
    await supabase.from('matches').delete().eq('tournament_id', tournament_id)

    const matchesToInsert: any[] = []

    if (bracketType === 'ROUND_ROBIN') {
      // Algoritmo round-robin circular
      let round = 1
      const teams = [...teamIds]
      if (teams.length % 2 !== 0) teams.push('BYE')
      const numRounds = teams.length - 1
      const half = teams.length / 2
      for (let r = 0; r < numRounds; r++) {
        for (let i = 0; i < half; i++) {
          const home = teams[i]
          const away = teams[teams.length - 1 - i]
          if (home !== 'BYE' && away !== 'BYE') {
            matchesToInsert.push({
              tournament_id,
              stage_id: stageId,
              team_a_id: home,
              team_b_id: away,
              round,
              match_order: i + 1,
              status: 'SCHEDULED',
              format: 'BO1',
            })
          }
        }
        // Rotacionar (mantendo teams[0] fixo)
        const last = teams.pop()
        teams.splice(1, 0, last!)
        round++
      }
    } else if (bracketType === 'SWISS') {
      // Swiss: apenas rodada 1
      const shuffled = [...teamIds].sort(() => Math.random() - 0.5)
      for (let i = 0; i < shuffled.length - 1; i += 2) {
        matchesToInsert.push({
          tournament_id,
          stage_id: stageId,
          team_a_id: shuffled[i],
          team_b_id: shuffled[i + 1],
          round: 1,
          match_order: Math.floor(i / 2) + 1,
          status: 'SCHEDULED',
          format: 'BO1',
        })
      }
    } else {
      // SINGLE_ELIMINATION (default) com byes
      const nextPow2 = Math.pow(2, Math.ceil(Math.log2(n)))
      const byes = nextPow2 - n
      const teams: (string | null)[] = [...teamIds]
      for (let i = 0; i < byes; i++) teams.push(null)

      let round = 1
      let matchOrder = 1
      let currentRoundTeams = teams

      while (currentRoundTeams.length > 1) {
        const nextRoundTeams: (string | null)[] = []
        matchOrder = 1
        for (let i = 0; i < currentRoundTeams.length; i += 2) {
          const teamA = currentRoundTeams[i]
          const teamB = currentRoundTeams[i + 1] ?? null
          if (teamA && !teamB) {
            // Bye - avanca automaticamente
            nextRoundTeams.push(teamA)
          } else {
            matchesToInsert.push({
              tournament_id,
              stage_id: stageId,
              team_a_id: teamA,
              team_b_id: teamB,
              round,
              match_order: matchOrder++,
              status: 'SCHEDULED',
              format: 'BO1',
            })
            nextRoundTeams.push(null) // placeholder para proximo round
          }
        }
        currentRoundTeams = nextRoundTeams
        round++
      }
    }

    // 4. Inserir matches
    const { error: mErr } = await supabase.from('matches').insert(matchesToInsert)
    if (mErr) throw mErr

    // 5. Registrar no audit_log
    const authHeader = req.headers.get('Authorization') ?? ''
    const token = authHeader.replace('Bearer ', '')
    let adminId: string | null = null
    if (token) {
      const { data: { user } } = await supabase.auth.getUser(token)
      adminId = user?.id ?? null
    }
    await supabase.from('audit_log').insert({
      action: 'GENERATE_BRACKET',
      target_table: 'matches',
      target_id: tournament_id,
      performed_by: adminId,
      new_data: { bracket_type: bracketType, matches_created: matchesToInsert.length },
    })

    return new Response(
      JSON.stringify({
        success: true,
        bracket_type: bracketType,
        matches_created: matchesToInsert.length,
        teams_count: n,
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
