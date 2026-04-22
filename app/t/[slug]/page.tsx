import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import Link from 'next/link'
import { BracketView } from '@/components/tournament/BracketView'

export const revalidate = 60

export default async function TournamentPublicPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params
  const supabase = await createClient()

  // Buscar torneio pelo slug
  const { data: tournament } = await supabase
    .from('tournaments')
    .select(`
      id, name, description, status, bracket_type,
      start_date, end_date, max_teams, prize_pool,
      slug, banner_url, discord_webhook_url
    `)
    .eq('slug', slug)
    .single()

  if (!tournament) notFound()

  // Buscar times aprovados
  const { data: inscricoes } = await supabase
    .from('inscricoes')
    .select('team_id, checked_in_at, teams(id, name, tag, logo_url)')
    .eq('tournament_id', tournament.id)
    .eq('status', 'APPROVED')
    .order('created_at')

  // Buscar partidas com times
  const { data: matches } = await supabase
    .from('matches')
    .select(`
      id, round, match_order, status, score_a, score_b, format, scheduled_at,
      team_a_id, team_b_id, winner_team_id,
      team_a:teams!matches_team_a_id_fkey(name, tag),
      team_b:teams!matches_team_b_id_fkey(name, tag)
    `)
    .eq('tournament_id', tournament.id)
    .order('round')
    .order('match_order')

  // Buscar ultimas partidas finalizadas
  const recentMatches = (matches ?? []).filter((m) => m.status === 'FINISHED').slice(-5)

  const statusLabel: Record<string, string> = {
    DRAFT: 'Rascunho',
    OPEN: 'Inscrições Abertas',
    IN_PROGRESS: 'Em Andamento',
    FINISHED: 'Encerrado',
    CANCELLED: 'Cancelado',
  }

  const statusColor: Record<string, string> = {
    DRAFT: 'bg-gray-700 text-gray-300',
    OPEN: 'bg-green-900 text-green-300',
    IN_PROGRESS: 'bg-yellow-900 text-yellow-300',
    FINISHED: 'bg-blue-900 text-blue-300',
    CANCELLED: 'bg-red-900 text-red-300',
  }

  return (
    <main className="min-h-screen bg-[#030D1A] text-white">
      {/* Banner / Header */}
      <div
        className="relative h-56 bg-gradient-to-b from-[#0A1428] to-[#030D1A] flex items-end"
        style={tournament.banner_url ? { backgroundImage: `url(${tournament.banner_url})`, backgroundSize: 'cover', backgroundPosition: 'center' } : {}}
      >
        <div className="absolute inset-0 bg-gradient-to-t from-[#030D1A] via-[#030D1A]/60 to-transparent" />
        <div className="relative z-10 px-6 pb-6 max-w-6xl mx-auto w-full">
          <span className={`inline-block px-2 py-0.5 rounded text-xs font-bold mb-2 ${statusColor[tournament.status] ?? 'bg-gray-700 text-gray-300'}`}>
            {statusLabel[tournament.status] ?? tournament.status}
          </span>
          <h1 className="text-3xl font-bold text-white">{tournament.name}</h1>
          <div className="flex gap-4 mt-2 text-sm text-gray-400">
            {tournament.start_date && (
              <span>Inicio: {new Date(tournament.start_date).toLocaleDateString('pt-BR')}</span>
            )}
            {tournament.end_date && (
              <span>Fim: {new Date(tournament.end_date).toLocaleDateString('pt-BR')}</span>
            )}
            {tournament.prize_pool && (
              <span className="text-[#C89B3C] font-semibold">🏆 {tournament.prize_pool}</span>
            )}
          </div>
        </div>
      </div>

      <div className="max-w-6xl mx-auto px-4 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Coluna principal */}
          <div className="lg:col-span-2 space-y-8">

            {/* Bracket */}
            <section>
              <h2 className="text-xl font-bold text-[#C89B3C] mb-4">🏆 Bracket</h2>
              <div className="bg-[#0A1428] rounded-xl p-4 border border-[#1E3A5F]">
                <BracketView
                  initialMatches={(matches ?? []) as any}
                  tournamentId={tournament.id}
                  readonly={false}
                />
              </div>
            </section>

            {/* Resultados Recentes */}
            {recentMatches.length > 0 && (
              <section>
                <h2 className="text-xl font-bold text-[#C89B3C] mb-4">📊 Últimos Resultados</h2>
                <div className="space-y-2">
                  {recentMatches.map((m: any) => (
                    <div key={m.id} className="bg-[#0A1428] border border-[#1E3A5F] rounded-lg px-4 py-3 flex items-center justify-between">
                      <span className="text-white font-medium">{m.team_a?.name ?? 'TBD'}</span>
                      <span className="text-[#C89B3C] font-bold text-lg mx-4">{m.score_a} x {m.score_b}</span>
                      <span className="text-white font-medium">{m.team_b?.name ?? 'TBD'}</span>
                    </div>
                  ))}
                </div>
              </section>
            )}
          </div>

          {/* Sidebar */}
          <div className="space-y-6">

            {/* Sobre */}
            {tournament.description && (
              <div className="bg-[#0A1428] border border-[#1E3A5F] rounded-xl p-4">
                <h3 className="text-[#C89B3C] font-bold mb-2">Sobre o Torneio</h3>
                <p className="text-gray-300 text-sm leading-relaxed">{tournament.description}</p>
              </div>
            )}

            {/* Info */}
            <div className="bg-[#0A1428] border border-[#1E3A5F] rounded-xl p-4">
              <h3 className="text-[#C89B3C] font-bold mb-3">Informações</h3>
              <dl className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <dt className="text-gray-400">Formato</dt>
                  <dd className="text-white">{tournament.bracket_type?.replace('_', ' ')}</dd>
                </div>
                <div className="flex justify-between">
                  <dt className="text-gray-400">Times</dt>
                  <dd className="text-white">{inscricoes?.length ?? 0} / {tournament.max_teams ?? '?'}</dd>
                </div>
              </dl>
            </div>

            {/* Times */}
            <div className="bg-[#0A1428] border border-[#1E3A5F] rounded-xl p-4">
              <h3 className="text-[#C89B3C] font-bold mb-3">Times Participantes</h3>
              <ul className="space-y-2">
                {(inscricoes ?? []).map((i: any) => (
                  <li key={i.team_id} className="flex items-center gap-3">
                    {i.teams?.logo_url ? (
                      <img src={i.teams.logo_url} alt={i.teams.name} className="w-8 h-8 rounded-full object-cover" />
                    ) : (
                      <div className="w-8 h-8 rounded-full bg-[#1E3A5F] flex items-center justify-center text-xs font-bold text-[#C89B3C]">
                        {i.teams?.tag?.[0] ?? '?'}
                      </div>
                    )}
                    <div>
                      <p className="text-white text-sm font-medium">{i.teams?.name}</p>
                      <p className="text-gray-500 text-xs">[{i.teams?.tag}]</p>
                    </div>
                    {i.checked_in_at && (
                      <span className="ml-auto text-green-400 text-xs">✓ Check-in</span>
                    )}
                  </li>
                ))}
              </ul>
            </div>

            {/* Login CTA */}
            <div className="text-center">
              <Link
                href="/(auth)/login"
                className="inline-block bg-[#C89B3C] text-black font-bold px-6 py-2 rounded-lg hover:bg-[#E5B44C] transition-colors"
              >
                Entrar / Inscrever Time
              </Link>
            </div>
          </div>
        </div>
      </div>
    </main>
  )
}
