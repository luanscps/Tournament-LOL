// @ts-nocheck
import { createClient } from 'jsr:@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

const TIER_COLORS: Record<string, number> = {
  CHALLENGER:  0xffd700,
  GRANDMASTER: 0xff4500,
  MASTER:      0x9b59b6,
  DIAMOND:     0x3498db,
  EMERALD:     0x2ecc71,
  PLATINUM:    0x1abc9c,
  GOLD:        0xf1c40f,
  SILVER:      0x95a5a6,
  BRONZE:      0xcd6133,
  IRON:        0x7f8c8d,
  UNRANKED:    0x99aab5,
}

async function sendDiscordWebhook(webhookUrl: string, payload: object) {
  const res = await fetch(webhookUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(`Discord rejeitou o webhook: ${err}`)
  }
}

function buildEmbed(type: string, data: Record<string, any>): object[] {
  const ts = new Date().toISOString()
  const footer = { text: 'BRLOL Torneios' }

  switch (type) {
    case 'inscricao_aprovada':
      return [{
        title: '✅ Time Aprovado!',
        description: `**${data.team_name}** foi aprovado no torneio **${data.tournament_name}**!`,
        color: 0x2ecc71, timestamp: ts, footer,
      }]

    case 'inscricao_rejeitada':
      return [{
        title: '❌ Inscrição Rejeitada',
        description: `**${data.team_name}** não foi aprovado em **${data.tournament_name}**.`,
        color: 0xe74c3c, timestamp: ts, footer,
      }]

    case 'partida_iniciada':
      return [{
        title: '⚔️ Partida em Andamento!',
        description: `**${data.team_a}** vs **${data.team_b}**`,
        color: 0xf1c40f,
        fields: [
          { name: 'Torneio', value: data.tournament_name, inline: true },
          { name: 'Formato', value: data.format ?? 'BO1', inline: true },
          { name: 'Rodada',  value: `Rodada ${data.round}`, inline: true },
        ],
        timestamp: ts, footer,
      }]

    case 'partida_finalizada':
      return [{
        title: '🏆 Partida Encerrada',
        // FIX: usa matchgames (tabela real) — antes estava referenciando 'games'
        description: `**${data.team_a}** ${data.score_a} — ${data.score_b} **${data.team_b}**`,
        color: 0x7289da,
        fields: [
          { name: 'Vencedor',  value: data.winner,          inline: true },
          { name: 'Torneio',   value: data.tournament_name, inline: true },
          { name: 'Formato',   value: data.format ?? 'BO1', inline: true },
          ...(data.mvp ? [{ name: 'MVP', value: data.mvp, inline: true }] : []),
        ],
        timestamp: ts, footer,
      }]

    case 'torneio_iniciado':
      return [{
        title: '🎉 Torneio Iniciado!',
        description: `O torneio **${data.tournament_name}** começou!`,
        color: 0x3498db,
        fields: [
          { name: 'Times',   value: `${data.team_count} times`, inline: true },
          { name: 'Formato', value: data.bracket_type,          inline: true },
        ],
        timestamp: ts, footer,
      }]

    case 'rank_atualizado': {
      const color = TIER_COLORS[data.tier?.toUpperCase()] ?? TIER_COLORS.UNRANKED
      return [{
        title: '📊 Rank Atualizado',
        description: `**${data.summoner_name}** teve seu rank atualizado`,
        color,
        fields: [
          { name: 'Tier',    value: `${data.tier} ${data.rank}`, inline: true },
          { name: 'LP',      value: `${data.lp} LP`,            inline: true },
          { name: 'W/L',     value: `${data.wins}W / ${data.losses}L`, inline: true },
        ],
        timestamp: ts, footer,
      }]
    }

    default:
      return [{
        title: '📢 Notificação BRLOL',
        description: JSON.stringify(data).slice(0, 200),
        color: 0x99aab5, timestamp: ts, footer,
      }]
  }
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { type, tournament_id, data } = await req.json()

    if (!type || !data) {
      return new Response(
        JSON.stringify({ error: 'Campos obrigatórios: type, data' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    // Buscar webhook_url — só obrigatório quando tournament_id fornecido
    let webhookUrl: string | null = null

    if (tournament_id) {
      const { data: tournament } = await supabase
        .from('tournaments')
        .select('discord_webhook_url, name')
        .eq('id', tournament_id)
        .single()

      if (!tournament?.discord_webhook_url) {
        return new Response(
          JSON.stringify({ skipped: true, reason: 'Sem webhook configurado para este torneio' }),
          { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        )
      }

      webhookUrl = tournament.discord_webhook_url
      data.tournament_name ??= tournament.name
    } else if (data.webhook_url) {
      // Permite passar webhook direto para notificações globais
      webhookUrl = data.webhook_url
    }

    if (!webhookUrl) {
      return new Response(
        JSON.stringify({ error: 'Nenhum webhook_url disponível' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const embeds = buildEmbed(type, data)
    await sendDiscordWebhook(webhookUrl, { embeds })

    return new Response(
      JSON.stringify({ success: true, type }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Erro interno'
    return new Response(
      JSON.stringify({ error: message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})