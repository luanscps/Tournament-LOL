import React from 'react';
import Link from 'next/link';
import PlayerCard from './PlayerCard';

interface Player {
  id: string;
  summoner_name: string;
  tag_line: string;
  role: string;
  tier: string;
  rank: string;
  lp: number;
  wins: number;
  losses: number;
  puuid?: string | null;
}

interface TeamCardProps {
  team: {
    id: string;
    name: string;
    tag: string;
    logoUrl: string | null;
    players: Player[];
  };
  DD_VERSION: string;
  showHeader?: boolean;
}

const ROLE_ORDER = ['TOP', 'JUNGLE', 'MID', 'ADC', 'SUPPORT'];

export default function TeamCard({ team, DD_VERSION, showHeader = true }: TeamCardProps) {
  const sorted = [...team.players].sort((a, b) => {
    const ai = ROLE_ORDER.indexOf(a.role?.toUpperCase());
    const bi = ROLE_ORDER.indexOf(b.role?.toUpperCase());
    if (ai === -1 && bi === -1) return 0;
    if (ai === -1) return 1;
    if (bi === -1) return -1;
    return ai - bi;
  });

  const totalWins = team.players.reduce((s, p) => s + (p.wins ?? 0), 0);
  const totalLosses = team.players.reduce((s, p) => s + (p.losses ?? 0), 0);
  const totalGames = totalWins + totalLosses;
  const avgWr = totalGames > 0 ? Math.round((totalWins / totalGames) * 100) : 0;

  return (
    <div className="bg-[#0A1628] border border-[#1E3A5F] rounded-xl overflow-hidden">
      {showHeader && (
        <div className="flex items-center gap-3 p-4 border-b border-[#1E3A5F]">
          {team.logoUrl && (
            <img
              src={team.logoUrl}
              alt={team.name}
              width={40}
              height={40}
              className="rounded-lg border border-[#1E3A5F]"
            />
          )}
          <div className="flex-1">
            <h3 className="text-white font-bold">
              {team.name}
              <span className="text-gray-400 font-normal text-sm ml-1">[{team.tag}]</span>
            </h3>
            <p className="text-gray-500 text-xs">
              {team.players.length} jogador{team.players.length !== 1 ? 'es' : ''}
              {totalGames > 0 && (
                <span className={`ml-2 ${avgWr >= 50 ? 'text-blue-400' : 'text-red-400'}`}>
                  {avgWr}% WR medio
                </span>
              )}
            </p>
          </div>
          <Link
            href={`/times/${team.tag}`}
            className="text-xs text-gray-400 hover:text-blue-400 border border-[#1E3A5F] px-2 py-1 rounded"
          >
            Ver time
          </Link>
        </div>
      )}

      <div className="divide-y divide-[#1E3A5F]/40">
        {sorted.length > 0 ? (
          sorted.map((player) => {
            const total = player.wins + player.losses;
            const wr = total > 0 ? Math.round((player.wins / total) * 100) : 0;
            return (
              <div key={player.id} className="px-4 py-2">
                <PlayerCard
                  summonerName={player.summoner_name}
                  tagLine={player.tag_line}
                  role={player.role}
                  tier={player.tier}
                  rank={player.rank}
                  lp={player.lp}
                  wins={player.wins}
                  losses={player.losses}
                  wr={wr}
                  puuid={player.puuid}
                  DD_VERSION={DD_VERSION}
                  linkToProfile
                />
              </div>
            );
          })
        ) : (
          <p className="text-gray-500 text-sm text-center py-6">Nenhum jogador no time.</p>
        )}
      </div>
    </div>
  );
}
