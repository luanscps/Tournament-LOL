// app/torneios/[slug]/times/page.tsx
import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import Link from 'next/link'

export default async function TimesDoTorneioPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params
  const supabase = await createClient()

  const { data: torneio } = await supabase
    .from('tournaments')
    .select('id, name, slug, status, max_teams')
    .eq('slug', slug)
    .single()

  if (!torneio) notFound()

  const { data: inscricoes } = await supabase
    .from('inscricoes')
    .select(`
      id, status, created_at,
      teams:team_id (
        id, name, tag, logo_url,
        team_members(count)
      )
    `)
    .eq('tournament_id', torneio.id)
    .eq('status', 'APPROVED')
    .order('created_at', { ascending: true })

  const times = (inscricoes ?? []).map(i => i.teams).filter(Boolean)

  return (
    <div className="space-y-6">
      <div className="card-lol">
        <div className="flex items-center justify-between flex-wrap gap-3">
          <div>
            <p className="text-gray-400 text-sm mb-1">
              <Link href={`/torneios/${slug}`} className="hover:text-white transition-colors">← {torneio.name}</Link>
            </p>
            <h1 className="text-2xl font-bold text-white">🛡️ Times Inscritos</h1>
          </div>
          <p className="text-gray-400 text-sm">{times.length}/{torneio.max_teams} vagas preenchidas</p>
        </div>
      </div>

      {times.length === 0 ? (
        <div className="card-lol text-center py-16">
          <p className="text-4xl mb-3">🛡️</p>
          <p className="text-white font-bold">Nenhum time inscrito ainda</p>
          <p className="text-gray-400 text-sm mt-1">As inscrições aprovadas aparecerão aqui.</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {times.map((time: any) => (
            <div key={time.id} className="card-lol flex items-center gap-4">
              {time.logo_url ? (
                <img src={time.logo_url} alt={time.name} className="w-12 h-12 rounded-full object-cover bg-[#0A1628]" />
              ) : (
                <div className="w-12 h-12 rounded-full bg-[#1E3A5F] flex items-center justify-center text-[#C8A84B] font-bold text-lg">
                  {time.tag?.slice(0, 2).toUpperCase()}
                </div>
              )}
              <div className="min-w-0">
                <p className="font-bold text-white truncate">{time.name}</p>
                <p className="text-[#C8A84B] text-sm">[{time.tag}]</p>
                <p className="text-gray-500 text-xs">{(time.team_members as any)?.[0]?.count ?? 0} membros</p>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
