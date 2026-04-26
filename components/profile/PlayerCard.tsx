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

// Mapeia tier para o nome do emblema no Community Dragon
const TIER_EMBLEM: Record<string, string> = {
  IRON: 'iron',
  BRONZE: 'bronze',
  SILVER: 'silver',
  GOLD: 'gold',
  PLATINUM: 'platinum',
  EMERALD: 'emerald',
  DIAMOND: 'diamond',
  MASTER: 'master',
  GRANDMASTER: 'grandmaster',
  CHALLENGER: 'challenger',
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
  profileIconId?: number | null;
  topChampionId?: string | null;
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
  profileIconId,
  topChampionId,
  team,
  DD_VERSION,
  linkToProfile = true,
}: PlayerCardProps) {
  const tierColor = TIER_COLORS[tier?.toUpperCase()] ?? 'text-white';
  const roleLabel = ROLE_LABELS[role?.toUpperCase()] ?? role;
  const tierKey = TIER_EMBLEM[tier?.toUpperCase()] ?? null;

  const profileIconUrl = profileIconId
    ? `https://ddragon.leagueoflegends.com/cdn/${DD_VERSION}/img/profileicon/${profileIconId}.png`
    : null;

  const rankEmblemUrl = tierKey
    ? `https://raw.communitydragon.org/latest/plugins/rcp-fe-lol-shared-components/global/default/images/ranked-emblem/emblem-${tierKey}.png`
    : null;

  const championIconUrl = topChampionId
    ? `https://ddragon.leagueoflegends.com/cdn/${DD_VERSION}/img/champion/${topChampionId}.png`
    : null;

  const nameEl = (
    <span className="text-white font-semibold text-base">
      {summonerName}
      <span className="text-gray-400 font-normal text-sm"> #{tagLine}</span>
    </span>
  );

  return (
    <div className="bg-[#0A1628] border border-[#1E3A5F] rounded-xl p-4 flex items-start gap-4">

      {/* Ícone de perfil com moldura */}
      <div className="flex-shrink-0 relative w-14 h-14">
        {profileIconUrl ? (
          <>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={profileIconUrl}
              alt={`Ícone de ${summonerName}`}
              width={56}
              height={56}
              className="rounded-full w-14 h-14 object-cover"
              onError={(e) => {
                (e.currentTarget as HTMLImageElement).style.display = 'none';
              }}
            />
            {/* Moldura sobreposta via Community Dragon */}
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src="https://raw.communitydragon.org/latest/plugins/rcp-fe-lol-static-assets/global/default/images/regalia/regalia-profile-frame-gold.png"
              alt=""
              aria-hidden="true"
              className="absolute inset-0 w-full h-full pointer-events-none select-none"
              onError={(e) => {
                (e.currentTarget as HTMLImageElement).style.display = 'none';
              }}
            />
          </>
        ) : (
          <div className="w-14 h-14 rounded-full bg-[#1E2A3A] border border-[#1E3A5F] flex items-center justify-center">
            <span className="text-gray-400 text-sm font-bold">{role?.slice(0, 1) || '?'}</span>
          </div>
        )}
      </div>

      <div className="flex-1 min-w-0">
        {/* Nome + role */}
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

        {/* Emblema de rank + stats */}
        <div className="flex items-center gap-3 mb-2">
          {rankEmblemUrl && (
            // eslint-disable-next-line @next/next/no-img-element
            <img
              src={rankEmblemUrl}
              alt={`Emblema ${tier}`}
              width={40}
              height={40}
              className="w-10 h-10 object-contain flex-shrink-0"
              onError={(e) => {
                (e.currentTarget as HTMLImageElement).style.display = 'none';
              }}
            />
          )}
          <div className="flex flex-col">
            <span className={`font-bold text-sm ${tierColor}`}>
              {tier} {rank}
            </span>
            <span className="text-gray-500 text-xs">{lp} LP</span>
          </div>
          <span className="text-gray-400 text-xs">{wins}W/{losses}L</span>
          <span className={`text-xs font-semibold ${wr >= 50 ? 'text-blue-400' : 'text-red-400'}`}>
            {wr}% WR
          </span>
        </div>

        {/* Campeão mais jogado */}
        {championIconUrl && (
          <div className="flex items-center gap-2 mb-1">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={championIconUrl}
              alt={topChampionId ?? 'campeão'}
              width={24}
              height={24}
              className="w-6 h-6 rounded object-cover border border-[#1E3A5F]"
              onError={(e) => {
                (e.currentTarget as HTMLImageElement).style.display = 'none';
              }}
            />
            <span className="text-gray-400 text-xs">{topChampionId}</span>
          </div>
        )}

        {/* Time */}
        {team && (
          <div className="mt-1">
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
