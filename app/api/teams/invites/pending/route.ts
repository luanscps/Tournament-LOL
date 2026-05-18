import { NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

export async function GET() {
  const supabase = await createClient()

  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    return NextResponse.json({ error: 'Não autorizado' }, { status: 401 })
  }

  const { data, error } = await supabase
    .from('team_invites')
    .select(`
      id,
      status,
      role,
      is_reserve,
      message,
      expires_at,
      created_at,
      team:teams ( id, name, tag, logo_url ),
      inviter:profiles!team_invites_invited_by_fkey ( id, full_name, avatar_url )
    `)
    .eq('invited_profile_id', user.id)
    .eq('status', 'PENDING')
    .gt('expires_at', new Date().toISOString())
    .order('created_at', { ascending: false })

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }

  return NextResponse.json({ invites: data ?? [] })
}
