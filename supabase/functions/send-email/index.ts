// supabase/functions/send-email/index.ts
const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY')!
const FROM_EMAIL = 'BRLOL <TeamTorneioLOL@infrabr.site>'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

function baseTemplate(content: string): string {
  return `<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      body { font-family: Arial, sans-serif; background: #0a0a0a; color: #ffffff; margin: 0; padding: 0; }
      .container { max-width: 600px; margin: 0 auto; padding: 24px; }
      .header { background: linear-gradient(135deg, #C89B3C, #785A28); padding: 20px; border-radius: 8px 8px 0 0; text-align: center; }
      .header h1 { margin: 0; font-size: 22px; color: #fff; letter-spacing: 1px; }
      .body { background: #1a1a2e; padding: 24px; border-radius: 0 0 8px 8px; }
      .badge { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: bold; margin-bottom: 16px; }
      .badge-green  { background: #2ecc71; color: #000; }
      .badge-red    { background: #e74c3c; color: #fff; }
      .badge-blue   { background: #3498db; color: #fff; }
      .badge-gold   { background: #C89B3C; color: #000; }
      .btn { display: inline-block; padding: 12px 24px; background: #C89B3C; color: #000; text-decoration: none; border-radius: 6px; font-weight: bold; margin-top: 16px; }
      .footer { text-align: center; margin-top: 24px; font-size: 12px; color: #666; }
      h2 { color: #C89B3C; }
      p { line-height: 1.6; color: #ccc; }
      .info-box { background: #16213e; border-left: 4px solid #C89B3C; padding: 12px 16px; border-radius: 0 6px 6px 0; margin: 16px 0; }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="header"><h1>⚔️ BRLOL Torneios</h1></div>
      <div class="body">${content}</div>
      <div class="footer">
        <p>BRLOL - Plataforma de Torneios de League of Legends<br>
        Este e-mail foi enviado automaticamente, por favor não responda.</p>
      </div>
    </div>
  </body>
</html>`
}

async function sendEmail(to: string, subject: string, html: string) {
  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${RESEND_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ from: FROM_EMAIL, to, subject, html }),
  })
  if (!res.ok) {
    const text = await res.text()
    throw new Error(`Resend error ${res.status}: ${text}`)
  }
  return res.json()
}

function buildEmail(template: string, data: Record<string, any>): { subject: string; html: string } {
  switch (template) {

    case 'inscricao_pendente':
      return {
        subject: `[${data.tournament_name}] Inscrição recebida — ${data.team_name}`,
        html: baseTemplate(`
          <span class="badge badge-blue">PENDENTE</span>
          <h2>Inscrição Recebida!</h2>
          <p>Olá, <strong>${data.captain_name ?? 'Capitão'}</strong>!</p>
          <p>A inscrição do time <strong>${data.team_name}</strong> no torneio
          <strong>${data.tournament_name}</strong> foi recebida e aguarda aprovação.</p>
          <div class="info-box">
            <strong>Time:</strong> ${data.team_name}<br>
            <strong>Torneio:</strong> ${data.tournament_name}<br>
            <strong>Data:</strong> ${new Date().toLocaleDateString('pt-BR')}
          </div>
          <p>Você receberá um e-mail assim que a inscrição for aprovada ou rejeitada.</p>
        `),
      }

    case 'inscricao_aprovada':
      return {
        subject: `✅ [${data.tournament_name}] Time ${data.team_name} aprovado!`,
        html: baseTemplate(`
          <span class="badge badge-green">APROVADO</span>
          <h2>Inscrição Aprovada!</h2>
          <p>Parabéns, <strong>${data.captain_name ?? 'Capitão'}</strong>!</p>
          <p>O time <strong>${data.team_name}</strong> foi oficialmente aprovado no torneio
          <strong>${data.tournament_name}</strong>!</p>
          <div class="info-box">
            <strong>Próximos passos:</strong><br>
            1. Certifique-se que todos os jogadores fizeram check-in<br>
            2. Aguarde o comunicado da primeira partida<br>
            3. Fique de olho no servidor do Discord
          </div>
          ${data.tournament_url ? `<a href="${data.tournament_url}" class="btn">Ver Torneio</a>` : ''}
        `),
      }

    case 'inscricao_rejeitada':
      return {
        subject: `❌ [${data.tournament_name}] Inscrição rejeitada — ${data.team_name}`,
        html: baseTemplate(`
          <span class="badge badge-red">REJEITADO</span>
          <h2>Inscrição Rejeitada</h2>
          <p>Olá, <strong>${data.captain_name ?? 'Capitão'}</strong>.</p>
          <p>A inscrição do time <strong>${data.team_name}</strong> no torneio
          <strong>${data.tournament_name}</strong> foi rejeitada.</p>
          <div class="info-box">
            <strong>Motivo:</strong> ${data.reason ?? 'Não informado'}
          </div>
          <p>Se acredita que houve um erro, entre em contato com os organizadores.</p>
        `),
      }

    case 'partida_agendada':
      return {
        subject: `⏰ [${data.tournament_name}] Sua partida está agendada!`,
        html: baseTemplate(`
          <span class="badge badge-blue">PARTIDA AGENDADA</span>
          <h2>Lembrete de Partida</h2>
          <p>Olá, <strong>${data.captain_name ?? 'Capitão'}</strong>!</p>
          <p>Sua partida no torneio <strong>${data.tournament_name}</strong> está agendada.</p>
          <div class="info-box">
            <strong>Time A:</strong> ${data.team_a_name}<br>
            <strong>Time B:</strong> ${data.team_b_name}<br>
            <strong>Formato:</strong> ${data.format ?? 'BO1'}<br>
            <strong>Data/Hora:</strong> ${data.scheduled_at
              ? new Date(data.scheduled_at).toLocaleString('pt-BR')
              : 'A confirmar'}
          </div>
          <p>Certifique-se que toda a equipe está online antes do horário agendado.</p>
          ${data.match_url ? `<a href="${data.match_url}" class="btn">Ver Partida</a>` : ''}
        `),
      }

    case 'resultado_final': {
      const isWinner = data.winner_team_id === data.recipient_team_id
      return {
        subject: `${isWinner ? '🏆' : '👏'} [${data.tournament_name}] Resultado da sua partida`,
        html: baseTemplate(`
          <span class="badge ${isWinner ? 'badge-green' : 'badge-red'}">${isWinner ? 'VITÓRIA' : 'DERROTA'}</span>
          <h2>Resultado da Partida</h2>
          <p>Olá, <strong>${data.captain_name ?? 'Capitão'}</strong>!</p>
          <div class="info-box">
            <strong>${data.team_a_name}</strong> ${data.score_a} x ${data.score_b}
            <strong>${data.team_b_name}</strong><br>
            <strong>Vencedor:</strong> ${data.winner_name}<br>
            ${data.mvp_name ? `<strong>MVP:</strong> ${data.mvp_name}` : ''}
          </div>
          ${data.match_url ? `<a href="${data.match_url}" class="btn">Ver Stats da Partida</a>` : ''}
        `),
      }
    }

    case 'novo_torneio':
      return {
        subject: `🎉 Novo torneio disponível: ${data.tournament_name}`,
        html: baseTemplate(`
          <span class="badge badge-gold">NOVO TORNEIO</span>
          <h2>${data.tournament_name}</h2>
          <p>Um novo torneio foi aberto para inscrições!</p>
          <div class="info-box">
            <strong>Formato:</strong> ${data.bracket_type ?? 'A definir'}<br>
            <strong>Vagas:</strong> ${data.max_teams ?? '?'} times<br>
            <strong>Início:</strong> ${data.start_date
              ? new Date(data.start_date).toLocaleDateString('pt-BR')
              : 'A definir'}
          </div>
          ${data.tournament_url ? `<a href="${data.tournament_url}" class="btn">Inscrever meu time</a>` : ''}
        `),
      }

    default:
      throw new Error(`Template desconhecido: ${template}`)
  }
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const body = await req.json()
    const { template, data } = body

    if (!template || !data) {
      return new Response(
        JSON.stringify({ error: 'Campos obrigatórios: template, data' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    if (!data.to_email) {
      return new Response(
        JSON.stringify({ error: 'data.to_email é obrigatório' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const { subject, html } = buildEmail(template, data)
    const result = await sendEmail(data.to_email, subject, html)

    return new Response(
      JSON.stringify({ success: true, template, email_id: result.id }),
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