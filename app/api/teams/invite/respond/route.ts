import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { z } from 'zod'

const bodySchema = z.object({
  invite_id: z.string().uuid(),
  action: z.enum(['accept', 'decline']),
  // riot_account_id opcional: se informado, vincula a conta ao time_member
  riot_account_id: z.string().uuid().optional(),
})

export async function POST(req: NextRequest) {
  const supabase = await createClient()

  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    return NextResponse.json({ error: 'Não autorizado' }, { status: 401 })
  }

  const body = await req.json().catch(() => null)
  const parsed = bodySchema.safeParse(body)
  if (!parsed.success) {
    return NextResponse.json({ error: parsed.error.flatten() }, { status: 400 })
  }

  const { invite_id, action, riot_account_id } = parsed.data

  // Busca o convite e garante que pertence ao usuário logado
  const { data: invite } = await supabase
    .from('team_invites')
    .select('id, team_id, invited_profile_id, status, expires_at')
    .eq('id', invite_id)
    .eq('invited_profile_id', user.id)
    .maybeSingle()

  if (!invite) {
    return NextResponse.json({ error: 'Convite não encontrado' }, { status: 404 })
  }

  if (invite.status !== 'PENDING') {
    return NextResponse.json(
      { error: `Este convite já foi ${invite.status === 'ACCEPTED' ? 'aceito' : 'recusado/expirado'}` },
      { status: 409 }
    )
  }

  if (invite.expires_at && new Date(invite.expires_at) < new Date()) {
    await supabase
      .from('team_invites')
      .update({ status: 'EXPIRED' })
      .eq('id', invite_id)
    return NextResponse.json({ error: 'Este convite expirou' }, { status: 410 })
  }

  if (action === 'decline') {
    await supabase
      .from('team_invites')
      .update({ status: 'DECLINED' })
      .eq('id', invite_id)
    return NextResponse.json({ message: 'Convite recusado' })
  }

  // action === 'accept': usa a RPC accept_team_invite que já existe no banco
  const { data: result, error: rpcError } = await supabase.rpc('accept_team_invite', {
    p_invite_id: invite_id,
    p_profile_id: user.id,
    ...(riot_account_id ? { p_riot_acc_id: riot_account_id } : {}),
  })

  if (rpcError) {
    return NextResponse.json({ error: rpcError.message }, { status: 500 })
  }

  // A RPC já atualiza team_invites.status = ACCEPTED e insere em team_members
  return NextResponse.json({ message: 'Convite aceito com sucesso', result })
}
