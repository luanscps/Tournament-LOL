import { createClient } from 'jsr:@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

const RIOT_API_KEY = Deno.env.get('RIOT_API_KEY')!
const RIOT_BASE = 'https://br1.api.riotgames.com'
const RIOT_AMERICAS = 'https://americas.api.riotgames.com'

async function riotFetch(url: string) {
  const res = await fetch(url, { headers: { 'X-Riot-Token': RIOT_API_KEY } })
  if (!res.ok) {
    const text = await res.text()
    throw new Error(`Riot API error ${res.status}: ${text}`)
  }
  return res.json()
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    // Buscar players que precisam de sync (last_synced > 6h ou null)
    const sixHoursAgo = new Date(Date.now() - 6 * 60 * 60 * 1000).toISOString()
    const { data: players, error: pErr } = await supabase
      .from('players')
      .select('id, summoner_name, tagline, puuid')
      .or(`last_synced.is.null,last_synced.lt.${sixHoursAgo}`)
      .limit(20)
    if (pErr) throw pErr

    if (!players || players.length === 0) {
      return new Response(
        JSON.stringify({ success: true, synced: 0, message: 'No players need sync' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const results: any[] = []
    const errors: any[] = []

    for (const player of players) {
      try {
        const name = player.summoner_name
        const tag = player.tagline ?? 'BR1'

        // 1. Buscar account por Riot ID para obter PUUID
        const accountData = await riotFetch(
          `${RIOT_AMERICAS}/riot/account/v1/accounts/by-riot-id/${encodeURIComponent(name)}/${encodeURIComponent(tag)}`
        )
        const puuid = accountData.puuid
        const profileIconId = accountData.profileIconId ?? null

        // 2. Buscar summoner por PUUID
        const summonerData = await riotFetch(
          `${RIOT_BASE}/lol/summoner/v4/summoners/by-puuid/${puuid}`
        )
        const summonerId = summonerData.id

        // 3. Buscar rank por summoner ID
        const leagueEntries: any[] = await riotFetch(
          `${RIOT_BASE}/lol/league/v4/entries/by-summoner/${summonerId}`
        )

        const soloEntry = leagueEntries.find((e: any) => e.queueType === 'RANKED_SOLO_5x5')
        const tier = soloEntry?.tier ?? 'UNRANKED'
        const rank = soloEntry?.rank ?? null
        const lp = soloEntry?.leaguePoints ?? 0
        const wins = soloEntry?.wins ?? 0
        const losses = soloEntry?.losses ?? 0

        // 4. Atualizar player no banco
        const { error: uErr } = await supabase
          .from('players')
          .update({
            puuid,
            tier,
            rank,
            lp,
            wins,
            losses,
            last_synced: new Date().toISOString(),
          })
          .eq('id', player.id)

        if (uErr) throw uErr

        results.push({ id: player.id, summoner_name: name, tier, rank, lp })
      } catch (e: any) {
        errors.push({ id: player.id, summoner_name: player.summoner_name, error: e.message })
      }

      // Rate limit: esperar 100ms entre requests
      await new Promise((r) => setTimeout(r, 100))
    }

    return new Response(
      JSON.stringify({
        success: true,
        synced: results.length,
        failed: errors.length,
        results,
        errors,
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
