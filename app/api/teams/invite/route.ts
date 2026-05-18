import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { z } from 'zod'

const bodySchema = z.object({
  team_id: z.string().uuid(),
  invited_profile_id: z.string().uuid(),
  role: z.enum(['TOP', 'JUNGLE', 'MID', 'ADC', 'SUPPORT']).nullable().optional(),
  is_reserve: z.boolean().optional().default(false),
  message: z.string().max(300).optional(),
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

  const { team_id, invited_profile_id, role, is_reserve, message } = parsed.data

  // 1. Verifica se o caller é owner ou captain do time
  const { data: team } = await supabase
    .from('teams')
    .select('id, name, owner_id')
    .eq('id', team_id)
    .maybeSingle()

  if (!team) {
    return NextResponse.json({ error: 'Time não encontrado' }, { status: 404 })
  }

  const isOwner = team.owner_id === user.id

  let isCaptain = false
  if (!isOwner) {
    const { data: membership } = await supabase
      .from('team_members')
      .select('team_role, status')
      .eq('team_id', team_id)
      .eq('profile_id', user.id)
      .eq('status', 'accepted')
      .maybeSingle()
    isCaptain = membership?.team_role === 'captain'
  }

  if (!isOwner && !isCaptain) {
    return NextResponse.json(
      { error: 'Apenas o dono ou capitão do time pode convidar membros' },
      { status: 403 }
    )
  }

  // 2. Verifica se o jogador já é membro ativo do time
  const { data: existingMember } = await supabase
    .from('team_members')
    .select('id, status')
    .eq('team_id', team_id)
    .eq('profile_id', invited_profile_id)
    .in('status', ['accepted', 'pending'])
    .maybeSingle()

  if (existingMember) {
    const msg = existingMember.status === 'pending'
      ? 'Este jogador já tem um convite pendente para este time'
      : 'Este jogador já é membro deste time'
    return NextResponse.json({ error: msg }, { status: 409 })
  }

  // 3. Verifica se já existe um team_invite pendente para este jogador neste time
  const { data: existingInvite } = await supabase
    .from('team_invites')
    .select('id')
    .eq('team_id', team_id)
    .eq('invited_profile_id', invited_profile_id)
    .eq('status', 'PENDING')
    .maybeSingle()

  if (existingInvite) {
    return NextResponse.json(
      { error: 'Já existe um convite pendente para este jogador neste time' },
      { status: 409 }
    )
  }

  // 4. Busca o riot_account primário do convidado para preencher summoner_name/tag_line
  const { data: riotAccount } = await supabase
    .from('riot_accounts')
    .select('game_name, tag_line')
    .eq('profile_id', invited_profile_id)
    .eq('is_primary', true)
    .maybeSingle()

  // 5. Cria o convite com expiração de 7 dias
  const expiresAt = new Date()
  expiresAt.setDate(expiresAt.getDate() + 7)

  const { data: invite, error: insertError } = await supabase
    .from('team_invites')
    .insert({
      team_id,
      invited_profile_id,
      invited_by: user.id,
      role: role ?? null,
      is_reserve: is_reserve ?? false,
      message: message ?? null,
      status: 'PENDING',
      summoner_name: riotAccount?.game_name ?? null,
      tag_line: riotAccount?.tag_line ?? null,
      expires_at: expiresAt.toISOString(),
    })
    .select('id')
    .single()

  if (insertError) {
    return NextResponse.json({ error: insertError.message }, { status: 500 })
  }

  // 6. Cria notificação para o jogador convidado
  await supabase.from('notifications').insert({
    user_id: invited_profile_id,
    title: `Convite de time: ${team.name}`,
    body: message ?? `Você foi convidado para fazer parte do time ${team.name}.`,
    type: 'team_invite',
    link: `/meu-perfil/convites`,
    metadata: { invite_id: invite.id, team_id, team_name: team.name },
  })

  return NextResponse.json({ invite_id: invite.id, message: 'Convite enviado com sucesso' }, { status: 201 })
}
