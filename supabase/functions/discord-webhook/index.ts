import { createClient } from 'jsr:@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

const TIER_COLORS: Record<string, number> = {
  CHALLENGER: 0xffd700,
  GRANDMASTER: 0xff4500,
  MASTER: 0x9b59b6,
  DIAMOND: 0x3498db,
  EMERALD: 0x2ecc71,
  PLATINUM: 0x1abc9c,
  GOLD: 0xf1c40f,
  SILVER: 0x95a5a6,
  BRONZE: 0xcd6133,
  IRON: 0x7f8c8d,
  UNRANKED: 0x99aab5,
}

async function sendDiscordWebhook(webhookUrl: string, payload: object) {
  const res = await fetch(webhookUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  })
  if (!res.ok) {
    const text = await res.text()
    throw new Error(`Discord webhook error ${res.status}: ${text}`)
  }
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const body = await req.json()
    const { event_type, data } = body
    // event_type: 'inscricao_aprovada' | 'inscricao_rejeitada' | 'match_finished' | 'tournament_started' | 'tournament_finished'

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    // Buscar o discord_webhook_url do torneio
    const tournamentId = data.tournament_id
    if (!tournamentId) {
      return new Response(JSON.stringify({ error: 'tournament_id required in data' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const { data: tournament } = await supabase
      .from('tournaments')
      .select('id, name, discord_webhook_url')
      .eq('id', tournamentId)
      .single()

    if (!tournament?.discord_webhook_url) {
      return new Response(
        JSON.stringify({ success: false, message: 'No discord webhook configured for tournament' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    let embed: any = null

    if (event_type === 'inscricao_aprovada') {
      embed = {
        title: '✅ Inscrição Aprovada',
        description: `O time **${data.team_name}** foi aprovado no torneio **${tournament.name}**!`,
        color: 0x2ecc71,
        fields: [
          { name: 'Torneio', value: tournament.name, inline: true },
          { name: 'Time', value: data.team_name, inline: true },
        ],
        timestamp: new Date().toISOString(),
      }
    } else if (event_type === 'inscricao_rejeitada') {
      embed = {
        title: '❌ Inscrição Rejeitada',
        description: `A inscrição do time **${data.team_name}** foi rejeitada.`,
        color: 0xe74c3c,
        fields: [
          { name: 'Torneio', value: tournament.name, inline: true },
          { name: 'Time', value: data.team_name, inline: true },
          { name: 'Motivo', value: data.reason ?? 'Não informado', inline: false },
        ],
        timestamp: new Date().toISOString(),
      }
    } else if (event_type === 'match_finished') {
      const scoreA = data.score_a ?? 0
      const scoreB = data.score_b ?? 0
      const winner = scoreA > scoreB ? data.team_a_name : data.team_b_name
      embed = {
        title: '🏆 Partida Encerrada',
        description: `**${data.team_a_name}** ${scoreA} x ${scoreB} **${data.team_b_name}**`,
        color: 0x3066993,
        fields: [
          { name: 'Torneio', value: tournament.name, inline: true },
          { name: 'Vencedor', value: winner, inline: true },
          { name: 'MVP', value: data.mvp_name ?? 'N/A', inline: true },
          { name: 'Formato', value: data.format ?? 'BO1', inline: true },
        ],
        timestamp: new Date().toISOString(),
      }
    } else if (event_type === 'tournament_started') {
      embed = {
        title: '🎮 Torneio Iniciado!',
        description: `O torneio **${tournament.name}** começou! Boa sorte a todos os participantes.`,
        color: 0x3498db,
        fields: [
          { name: 'Bracket', value: data.bracket_type ?? 'SINGLE_ELIMINATION', inline: true },
          { name: 'Times', value: String(data.teams_count ?? '?'), inline: true },
        ],
        timestamp: new Date().toISOString(),
      }
    } else if (event_type === 'tournament_finished') {
      embed = {
        title: '🥇 Torneio Encerrado!',
        description: `O torneio **${tournament.name}** chegou ao fim!`,
        color: 0xffd700,
        fields: [
          { name: 'Campeão', value: data.winner_name ?? 'N/A', inline: true },
          { name: 'Vice', value: data.runner_up_name ?? 'N/A', inline: true },
        ],
        timestamp: new Date().toISOString(),
      }
    } else {
      return new Response(JSON.stringify({ error: `Unknown event_type: ${event_type}` }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    await sendDiscordWebhook(tournament.discord_webhook_url, {
      username: 'BRLOL Torneios',
      avatar_url: 'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Lux_0.jpg',
      embeds: [embed],
    })

    return new Response(
      JSON.stringify({ success: true, event_type }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
