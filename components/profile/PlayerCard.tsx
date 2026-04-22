import React from 'react';
import Link from 'next/link';

const TIER_COLORS: Record<string, string> = {
  IRON: 'text-gray-400',
  BRONZE: 'text-amber-700',
  SILVER: 'text-gray-300',
  GOLD: 'text-yellow-400',
  PLATINUM: 'text-teal-400',
  EMERALD: 'text-emerald-400',
  DIAMOND: 'text-blue-400',
  MASTER: 'text-purple-400',
  GRANDMASTER: 'text-red-400',
  CHALLENGER: 'text-yellow-300',
};

const ROLE_LABELS: Record<string, string> = {
  TOP: 'Top',
  JUNGLE: 'Jungle',
  MID: 'Mid',
  ADC: 'ADC',
  SUPPORT: 'Suporte',
};

interface PlayerCardProps {
  summonerName: string;
  tagLine: string;
  role: string;
  tier: string;
  rank: string;
  lp: number;
  wins: number;
  losses: number;
  wr: number;
  puuid?: string | null;
  team?: { id: string; name: string; tag: string; logoUrl: string | null } | null;
  DD_VERSION: string;
  linkToProfile?: boolean;
}

export default function PlayerCard({
  summonerName,
  tagLine,
  role,
  tier,
  rank,
  lp,
  wins,
  losses,
  wr,
  puuid,
  team,
  DD_VERSION,
  linkToProfile = true,
}: PlayerCardProps) {
  const tierColor = TIER_COLORS[tier?.toUpperCase()] ?? 'text-white';
  const roleLabel = ROLE_LABELS[role?.toUpperCase()] ?? role;

  const nameEl = (
    <span className="text-white font-semibold text-base">
      {summonerName}
      <span className="text-gray-400 font-normal text-sm"> #{tagLine}</span>
    </span>
  );

  return (
    <div className="bg-[#0A1628] border border-[#1E3A5F] rounded-xl p-4 flex items-start gap-4">
      <div className="flex-shrink-0">
        <div className="w-12 h-12 rounded-full bg-[#1E2A3A] border border-[#1E3A5F] flex items-center justify-center">
          <span className="text-gray-400 text-xs font-bold">{role?.slice(0, 1) || '?'}</span>
        </div>
      </div>

      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-2 mb-1">
          {linkToProfile && puuid ? (
            <Link href={`/jogadores/${puuid}`} className="hover:underline">
              {nameEl}
            </Link>
          ) : (
            nameEl
          )}
          <span className="text-gray-500 text-xs bg-[#1E2A3A] px-2 py-0.5 rounded">
            {roleLabel}
          </span>
        </div>

        <div className="flex items-center gap-3 text-xs">
          <span className={`font-bold ${tierColor}`}>
            {tier} {rank}
          </span>
          <span className="text-gray-500">{lp} LP</span>
          <span className="text-gray-400">
            {wins}W/{losses}L
          </span>
          <span className={wr >= 50 ? 'text-blue-400' : 'text-red-400'}>
            {wr}% WR
          </span>
        </div>

        {team && (
          <div className="mt-2">
            <Link
              href={`/times/${team.tag}`}
              className="text-xs text-gray-400 hover:text-blue-400"
            >
              {team.name} [{team.tag}]
            </Link>
          </div>
        )}
      </div>
    </div>
  );
}
