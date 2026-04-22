import React from 'react';

interface PlayerStatsCardProps {
  summonerName: string;
  tagLine: string;
  profileIconId: number;
  summonerLevel: number;
  rankedSolo?: {
    tier: string;
    rank: string;
    lp: number;
    wins: number;
    losses: number;
  };
  rankedFlex?: {
    tier: string;
    rank: string;
    lp: number;
    wins: number;
    losses: number;
  };
  DD_VERSION: string;
}

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

function RankedBadge({ data, label }: { data: PlayerStatsCardProps['rankedSolo']; label: string }) {
  if (!data) return null;
  const total = data.wins + data.losses;
  const wr = total > 0 ? Math.round((data.wins / total) * 100) : 0;
  const color = TIER_COLORS[data.tier] ?? 'text-white';
  return (
    <div className="bg-[#1E2A3A] rounded-lg p-3 flex-1">
      <p className="text-gray-400 text-xs mb-1">{label}</p>
      <p className={`font-bold text-sm ${color}`}>
        {data.tier} {data.rank} — {data.lp} LP
      </p>
      <p className="text-gray-400 text-xs mt-1">
        {data.wins}W / {data.losses}L —{' '}
        <span className={wr >= 50 ? 'text-blue-400' : 'text-red-400'}>{wr}% WR</span>
      </p>
    </div>
  );
}

export default function PlayerStatsCard({
  summonerName,
  tagLine,
  profileIconId,
  summonerLevel,
  rankedSolo,
  rankedFlex,
  DD_VERSION,
}: PlayerStatsCardProps) {
  return (
    <div className="bg-[#0A1628] border border-[#1E3A5F] rounded-xl p-4">
      <div className="flex items-center gap-4 mb-4">
        <div className="relative">
          <img
            src={`https://ddragon.leagueoflegends.com/cdn/${DD_VERSION}/img/profileicon/${profileIconId}.png`}
            alt={summonerName}
            width={64}
            height={64}
            className="rounded-full border-2 border-[#1E3A5F]"
          />
          <span className="absolute -bottom-1 left-1/2 -translate-x-1/2 bg-[#0A1628] border border-[#1E3A5F] text-xs text-gray-300 px-1 rounded">
            {summonerLevel}
          </span>
        </div>
        <div>
          <h2 className="text-white font-bold text-lg">
            {summonerName}
            <span className="text-gray-400 font-normal text-sm"> #{tagLine}</span>
          </h2>
          <p className="text-gray-500 text-xs">Perfil do Jogador</p>
        </div>
      </div>
      <div className="flex gap-3">
        <RankedBadge data={rankedSolo} label="Solo/Duo" />
        <RankedBadge data={rankedFlex} label="Flex" />
      </div>
    </div>
  );
}
