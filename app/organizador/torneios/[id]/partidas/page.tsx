// app/organizador/torneios/[id]/partidas/page.tsx
import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import PartidasClient from './partidas-client'

export default async function PartidasPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const { data: torneio } = await supabase
    .from('tournaments')
    .select('id, name, slug, status, organizer_id, created_by')
    .eq('id', id)
    .single()

  if (!torneio) redirect('/organizador')

  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single()

  const isOwner = torneio.organizer_id === user.id || torneio.created_by === user.id
  const isAdmin = profile?.role === 'admin'
  if (!isOwner && !isAdmin) redirect('/dashboard?error=acesso_negado')

  const { data: partidas } = await supabase
    .from('matches')
    .select(`
      id, round, match_number, status, score_a, score_b,
      scheduled_at, finished_at, best_of, fase_id,
      team_a:teams!team_a_id(id, name, tag, logo_url),
      team_b:teams!team_b_id(id, name, tag, logo_url),
      winner:teams!winner_id(id, name, tag)
    `)
    .eq('tournament_id', id)
    .order('round')
    .order('match_number')

  const { data: fases } = await supabase
    .from('fases')
    .select('id, name, type, order, status, best_of')
    .eq('tournament_id', id)
    .order('order')

  // Times aprovados para criar partida manual
  const { data: timesAprovados } = await supabase
    .from('inscricoes')
    .select('team_id, teams:team_id(id, name, tag)')
    .eq('tournament_id', id)
    .eq('status', 'APPROVED')

  return (
    <PartidasClient
      torneio={torneio as any}
      partidas={(partidas ?? []) as any}
      fases={(fases ?? []) as any}
      timesAprovados={(timesAprovados ?? []) as any}
    />
  )
}
