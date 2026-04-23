import { createClient } from '@/lib/supabase/server';
import Link from 'next/link';

const TIER_ORDER = [
  'CHALLENGER', 'GRANDMASTER', 'MASTER', 'DIAMOND', 'EMERALD',
  'PLATINUM', 'GOLD', 'SILVER', 'BRONZE', 'IRON', 'UNRANKED',
];

const TIER_COLORS: Record<string, string> = {
  CHALLENGER: 'text-yellow-300',
  GRANDMASTER: 'text-red-400',
  MASTER: 'text-purple-400',
  DIAMOND: 'text-blue-400',
  EMERALD: 'text-emerald-400',
  PLATINUM: 'text-teal-400',
  GOLD: 'text-yellow-500',
  SILVER: 'text-gray-400',
  BRONZE: 'text-orange-700',
  IRON: 'text-gray-500',
  UNRANKED: 'text-gray-600',
};

export default async function RankingPage({
  searchParams,
}: {
  searchParams: Promise<{ tier?: string }>;
}) {
  const { tier } = await searchParams;
  const supabase = await createClient();

  let query = supabase
    .from('players')
    .select('id, summoner_name, tagline, tier, rank, lp, wins, losses, team_id, teams(name, tag)')
    .order('lp', { ascending: false })
    .order('tier')
    .limit(100);
  if (tier) query = query.eq('tier', tier);
  const { data: players } = await query;

  const playerIds = (players ?? []).map((p) => p.id);
  const { data: statsRaw } = playerIds.length
    ? await supabase
        .from('player_stats')
        .select('player_id, kills, deaths, assists, is_mvp')
        .in('player_id', playerIds)
    : { data: [] };

  const statsMap: Record<string, { kills: number; deaths: number; assists: number; mvps: number; games: number }> = {};
  for (const s of statsRaw ?? []) {
    if (!statsMap[s.player_id]) statsMap[s.player_id] = { kills: 0, deaths: 0, assists: 0, mvps: 0, games: 0 };
    statsMap[s.player_id].kills += s.kills ?? 0;
    statsMap[s.player_id].deaths += s.deaths ?? 0;
    statsMap[s.player_id].assists += s.assists ?? 0;
    statsMap[s.player_id].mvps += s.is_mvp ? 1 : 0;
    statsMap[s.player_id].games += 1;
  }

  const playersWithKDA = (players ?? []).map((p) => {
    const stats = statsMap[p.id];
    const kda = stats && stats.deaths > 0 ? (stats.kills + stats.assists) / stats.deaths : stats ? stats.kills + stats.assists : 0;
    const winrate = (p.wins ?? 0) + (p.losses ?? 0) > 0 ? Math.round(((p.wins ?? 0) / ((p.wins ?? 0) + (p.losses ?? 0))) * 100) : null;
    return { ...p, kda, stats, winrate };
  }).sort((a, b) => b.kda - a.kda);

  const btnBase = 'px-3 py-1 rounded text-xs border transition-colors';
  const btnActive = 'border-[#C8A84B] text-[#C8A84B] bg-[#C8A84B]/10';
  const btnInactive = 'border-[#1E3A5F] text-gray-400 hover:border-[#C8A84B]/50';

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between flex-wrap gap-4">
        <div>
          <h1 className="text-3xl font-bold text-white">🏆 Leaderboard Global</h1>
          <p className="text-gray-400 text-sm mt-1">Top {playersWithKDA.length} invocadores{tier ? ` — Tier: ${tier}` : ''}</p>
        </div>
      </div>

      {/* Filtro de Tier */}
      <div className="flex flex-wrap gap-2 items-center">
        <span className="text-xs text-gray-500">Tier:</span>
        <a href="/ranking" className={`${btnBase} ${!tier ? btnActive : btnInactive}`}>Todos</a>
        {TIER_ORDER.map((t) => (
          <a key={t} href={`/ranking?tier=${t}`}
            className={`${btnBase} ${tier === t ? btnActive : btnInactive} ${TIER_COLORS[t]}`}>
            {t}
          </a>
        ))}
      </div>

      {/* Podium top 3 */}
      {!tier && playersWithKDA.length >= 3 && (
        <div className="flex justify-center items-end gap-4">
          {[1, 0, 2].map((pos) => {
            const p = playersWithKDA[pos];
            if (!p) return null;
            return (
              <div key={pos} className={`text-center p-4 rounded-lg border ${
                pos === 0 ? 'border-yellow-400 bg-yellow-400/10 scale-110' :
                pos === 1 ? 'border-gray-400 bg-gray-400/10' : 'border-orange-700 bg-orange-700/10'
              }`}>
                <div className="text-2xl">{pos === 0 ? '🥇' : pos === 1 ? '🥈' : '🥉'}</div>
                <div className="font-bold text-white text-sm mt-1">{p.summoner_name}</div>
                <div className="text-xs text-gray-400">#{p.tagline}</div>
                <div className={`text-xs mt-1 font-semibold ${TIER_COLORS[p.tier ?? 'UNRANKED']}`}>
                  {p.tier} {p.rank} {p.lp}LP
                </div>
                <div className="text-xs text-green-400">{p.kda.toFixed(2)} KDA</div>
              </div>
            );
          })}
        </div>
      )}

      {/* Tabela */}
      <div className="overflow-x-auto rounded-lg border border-[#1E3A5F]">
        <table className="w-full text-sm">
          <thead>
            <tr className="bg-[#0D1B2E] text-gray-400 text-left">
              <th className="px-4 py-3">#</th>
              <th className="px-4 py-3">Invocador</th>
              <th className="px-4 py-3">Time</th>
              <th className="px-4 py-3">Tier/Rank</th>
              <th className="px-4 py-3">KDA</th>
              <th className="px-4 py-3">Winrate</th>
              <th className="px-4 py-3">MVPs</th>
              <th className="px-4 py-3">Partidas</th>
            </tr>
          </thead>
          <tbody>
            {playersWithKDA.map((player, i) => (
              <tr key={player.id} className={`border-t border-[#1E3A5F] hover:bg-[#0D1B2E]/50 transition-colors ${
                i === 0 ? 'bg-yellow-400/5' : i === 1 ? 'bg-gray-400/5' : i === 2 ? 'bg-orange-700/5' : ''
              }`}>
                <td className="px-4 py-3 text-gray-400 font-mono">{i + 1}</td>
                <td className="px-4 py-3">
                  <div className="font-semibold text-white">{player.summoner_name}</div>
                  <div className="text-xs text-gray-500">#{player.tagline}</div>
                </td>
                <td className="px-4 py-3">
                  {player.teams ? (
                    <span className="text-xs text-[#C8A84B]">[{(player.teams as any).tag}] {(player.teams as any).name}</span>
                  ) : <span className="text-gray-600">-</span>}
                </td>
                <td className="px-4 py-3">
                  <span className={`font-semibold ${TIER_COLORS[player.tier ?? 'UNRANKED']}`}>
                    {player.tier ?? 'UNRANKED'}
                  </span>
                  {player.rank && <span className="text-gray-400 text-xs ml-1">{player.rank}</span>}
                  {player.lp != null && <span className="text-gray-500 text-xs ml-1">{player.lp}LP</span>}
                </td>
                <td className="px-4 py-3">
                  <span className={`font-mono ${
                    player.kda >= 4 ? 'text-yellow-400' : player.kda >= 3 ? 'text-green-400' :
                    player.kda >= 2 ? 'text-blue-400' : 'text-gray-400'
                  }`}>{player.kda.toFixed(2)}</span>
                </td>
                <td className="px-4 py-3 text-gray-300">{player.winrate != null ? `${player.winrate}%` : '-'}</td>
                <td className="px-4 py-3 text-gray-300">{player.stats?.mvps ?? 0}</td>
                <td className="px-4 py-3 text-gray-300">{player.stats?.games ?? 0}</td>
              </tr>
            ))}
          </tbody>
        </table>
        {playersWithKDA.length === 0 && (
          <div className="text-center py-16 text-gray-500">
            Nenhum jogador encontrado{tier ? ` no tier ${tier}` : ''}.
            {tier && <a href="/ranking" className="block text-[#C8A84B] text-sm mt-2 hover:underline">Ver todos</a>}
          </div>
        )}
      </div>
    </div>
  );
}
