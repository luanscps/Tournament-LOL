import { createClient } from '@/lib/supabase/server';
import { redirect } from 'next/navigation';
import Link from 'next/link';

const TIER_COLORS: Record<string, string> = {
  IRON: '#8B7A6B', BRONZE: '#CD7F32', SILVER: '#A8A9AD', GOLD: '#FFD700',
  PLATINUM: '#00E5CC', EMERALD: '#50C878', DIAMOND: '#99CCFF',
  MASTER: '#9B59B6', GRANDMASTER: '#E74C3C', CHALLENGER: '#00D4FF',
};

interface TournamentKda {
  tournament_id: string;
  tournament_name: string;
  tournament_slug: string | null;
  games: number;
  kills: number;
  deaths: number;
  assists: number;
  wins: number;
  losses: number;
  avg_damage: number;
  avg_vision: number;
  champions: string[];
}

interface PlayerStatRow {
  kills: number;
  deaths: number;
  assists: number;
  damage_dealt: number | null;
  vision_score: number | null;
  win: boolean;
  champion_name: string | null;
  match_games: {
    matches: {
      tournament_id: string | null;
      tournaments: { id: string; name: string; slug: string | null } | null;
    } | null;
  } | null;
}

export default async function CarreiraPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect('/login');

  // Busca conta riot primária para ter o riot_account_id
  const { data: riotAccount } = await supabase
    .from('riot_accounts')
    .select('id, game_name, tag_line, rank_snapshots(queue_type, tier, rank, lp, wins, losses)')
    .eq('profile_id', user.id)
    .eq('is_primary', true)
    .maybeSingle();

  let torneioPorId: Record<string, TournamentKda> = {};

  // Tenta usar a view v_player_tournament_kda
  if (riotAccount?.id) {
    const { data: kdaView } = await supabase
      .from('v_player_tournament_kda')
      .select('*')
      .eq('riot_account_id', riotAccount.id);

    if (kdaView && kdaView.length > 0) {
      for (const row of kdaView) {
        torneioPorId[row.tournament_id] = {
          tournament_id:   row.tournament_id,
          tournament_name: row.tournament_name ?? 'Torneio',
          tournament_slug: row.tournament_slug ?? null,
          games:           row.games ?? 0,
          kills:           row.total_kills ?? row.kills ?? 0,
          deaths:          row.total_deaths ?? row.deaths ?? 0,
          assists:         row.total_assists ?? row.assists ?? 0,
          wins:            row.wins ?? 0,
          losses:          row.losses ?? 0,
          avg_damage:      row.avg_damage ?? 0,
          avg_vision:      row.avg_vision ?? 0,
          champions:       row.champions ?? [],
        };
      }
    }
  }

  // Fallback: agrega player_stats manualmente se a view não retornou
  if (Object.keys(torneioPorId).length === 0 && riotAccount?.id) {
    const { data: stats } = await supabase
      .from('player_stats')
      .select(`
        kills, deaths, assists, damage_dealt, vision_score, win, champion_name,
        match_games (
          matches (
            tournament_id,
            tournaments ( id, name, slug )
          )
        )
      `)
      .eq('riot_account_id', riotAccount.id)
      .order('created_at', { ascending: false })
      .limit(200);

    for (const row of (stats ?? []) as unknown as PlayerStatRow[]) {
      const tourn = row.match_games?.matches?.tournaments;
      const tid   = row.match_games?.matches?.tournament_id;
      if (!tid || !tourn) continue;

      if (!torneioPorId[tid]) {
        torneioPorId[tid] = {
          tournament_id:   tid,
          tournament_name: tourn.name,
          tournament_slug: tourn.slug,
          games: 0, kills: 0, deaths: 0, assists: 0,
          wins: 0, losses: 0, avg_damage: 0, avg_vision: 0,
          champions: [],
        };
      }
      const t = torneioPorId[tid];
      t.games++;
      t.kills   += row.kills ?? 0;
      t.deaths  += row.deaths ?? 0;
      t.assists += row.assists ?? 0;
      t.avg_damage += row.damage_dealt ?? 0;
      t.avg_vision += row.vision_score ?? 0;
      if (row.win) t.wins++; else t.losses++;
      if (row.champion_name && !t.champions.includes(row.champion_name)) {
        t.champions.push(row.champion_name);
      }
    }
    // Calcula médias
    for (const t of Object.values(torneioPorId)) {
      if (t.games > 0) {
        t.avg_damage = Math.round(t.avg_damage / t.games);
        t.avg_vision = Math.round(t.avg_vision / t.games);
      }
    }
  }

  const torneios = Object.values(torneioPorId).sort((a, b) => b.games - a.games);

  const rankSolo = (riotAccount?.rank_snapshots as any[])?.find(
    (r: any) => r.queue_type === 'RANKED_SOLO_5x5'
  );

  // Stats globais
  const totalGames   = torneios.reduce((s, t) => s + t.games, 0);
  const totalKills   = torneios.reduce((s, t) => s + t.kills, 0);
  const totalDeaths  = torneios.reduce((s, t) => s + t.deaths, 0);
  const totalAssists = torneios.reduce((s, t) => s + t.assists, 0);
  const totalWins    = torneios.reduce((s, t) => s + t.wins, 0);
  const kdaGlobal    = totalDeaths > 0
    ? ((totalKills + totalAssists) / totalDeaths).toFixed(2)
    : totalKills + totalAssists > 0 ? 'Perfect' : '—';
  const wrGlobal     = totalGames > 0 ? Math.round((totalWins / totalGames) * 100) : 0;

  return (
    <main className="min-h-screen bg-[#050E1A] py-10 px-4">
      <div className="max-w-3xl mx-auto space-y-6">

        {/* Header */}
        <div className="flex items-center justify-between flex-wrap gap-3">
          <div>
            <h1 className="text-white font-bold text-2xl">📊 Carreira em Torneios</h1>
            {riotAccount && (
              <p className="text-[#C8A84B] text-sm mt-0.5">
                {riotAccount.game_name}
                <span className="text-gray-500">#{riotAccount.tag_line}</span>
              </p>
            )}
          </div>
          <Link href="/dashboard" className="btn-outline-gold text-sm px-4 py-2">
            ← Dashboard
          </Link>
        </div>

        {/* Sem conta Riot */}
        {!riotAccount && (
          <div className="card-lol text-center space-y-3 py-10">
            <p className="text-4xl">🔗</p>
            <p className="text-gray-400">Vincule sua conta Riot para ver sua carreira em torneios.</p>
            <Link href="/dashboard/jogador/registrar" className="btn-gold px-6 py-2 inline-block">
              Vincular conta Riot
            </Link>
          </div>
        )}

        {/* Sem partidas */}
        {riotAccount && torneios.length === 0 && (
          <div className="card-lol text-center space-y-3 py-10">
            <p className="text-4xl">🎮</p>
            <p className="text-gray-400">Você ainda não jogou nenhuma partida em torneios oficiais.</p>
            <Link href="/torneios" className="btn-gold px-6 py-2 inline-block">
              Explorar Torneios
            </Link>
          </div>
        )}

        {/* Stats globais */}
        {torneios.length > 0 && (
          <div className="card-lol">
            <h2 className="text-white font-bold mb-4">🌐 Totais de Carreira</h2>
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
              {[
                { label: 'Partidas',  value: totalGames },
                { label: 'KDA',       value: kdaGlobal },
                { label: 'WR%',       value: `${wrGlobal}%` },
                { label: 'Torneios',  value: torneios.length },
              ].map(s => (
                <div key={s.label} className="bg-[#0D1E35] border border-[#1E3A5F] rounded-xl p-4 text-center">
                  <p className="text-2xl font-bold text-white">{s.value}</p>
                  <p className="text-gray-500 text-xs mt-1 uppercase tracking-wider">{s.label}</p>
                </div>
              ))}
            </div>

            {rankSolo && (
              <div className="mt-4 bg-[#0D1E35] border border-[#1E3A5F] rounded-xl px-4 py-3 flex items-center justify-between">
                <span className="text-gray-400 text-sm">Rank Atual (Solo/Duo)</span>
                <span
                  className="font-bold text-sm"
                  style={{ color: TIER_COLORS[rankSolo.tier] ?? '#fff' }}
                >
                  {rankSolo.tier} {rankSolo.rank} · {rankSolo.lp} LP
                </span>
              </div>
            )}
          </div>
        )}

        {/* Por torneio */}
        {torneios.map(t => {
          const kda = t.deaths > 0
            ? ((t.kills + t.assists) / t.deaths).toFixed(2)
            : t.kills + t.assists > 0 ? 'Perfect' : '—';
          const wr  = t.games > 0 ? Math.round((t.wins / t.games) * 100) : 0;
          const wrColor = wr >= 60 ? 'text-green-400' : wr >= 50 ? 'text-yellow-400' : 'text-red-400';

          return (
            <div key={t.tournament_id} className="card-lol space-y-4">
              <div className="flex items-center justify-between flex-wrap gap-2">
                <div>
                  <h3 className="text-white font-bold">{t.tournament_name}</h3>
                  <p className="text-gray-500 text-xs mt-0.5">{t.games} partidas · {t.wins}V {t.losses}D</p>
                </div>
                {t.tournament_slug && (
                  <Link
                    href={`/torneios/${t.tournament_slug}`}
                    className="text-[#C8A84B] text-xs hover:underline"
                  >
                    Ver torneio →
                  </Link>
                )}
              </div>

              <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                {[
                  { label: 'KDA',         value: kda,                   sub: `${t.kills}/${t.deaths}/${t.assists}` },
                  { label: 'Win Rate',    value: `${wr}%`,              sub: `${t.wins}V ${t.losses}D`, color: wrColor },
                  { label: 'Avg Dano',    value: t.avg_damage > 0 ? (t.avg_damage / 1000).toFixed(1) + 'k' : '—', sub: 'por partida' },
                  { label: 'Avg Vision',  value: t.avg_vision > 0 ? t.avg_vision : '—', sub: 'pts visão' },
                ].map(s => (
                  <div key={s.label} className="bg-[#0D1E35] border border-[#1E3A5F] rounded-xl p-3 text-center">
                    <p className={`text-xl font-bold ${(s as any).color ?? 'text-white'}`}>{s.value}</p>
                    <p className="text-gray-500 text-xs mt-0.5">{s.label}</p>
                    {s.sub && <p className="text-gray-600 text-xs mt-0.5">{s.sub}</p>}
                  </div>
                ))}
              </div>

              {t.champions.length > 0 && (
                <div>
                  <p className="text-gray-500 text-xs uppercase tracking-wider mb-2">Campeões jogados</p>
                  <div className="flex flex-wrap gap-2">
                    {t.champions.slice(0, 8).map(c => (
                      <span
                        key={c}
                        className="text-xs bg-[#0D1E35] border border-[#1E3A5F] text-gray-300 px-2 py-1 rounded-lg"
                      >
                        {c}
                      </span>
                    ))}
                    {t.champions.length > 8 && (
                      <span className="text-xs text-gray-500">+{t.champions.length - 8} mais</span>
                    )}
                  </div>
                </div>
              )}
            </div>
          );
        })}

      </div>
    </main>
  );
}
