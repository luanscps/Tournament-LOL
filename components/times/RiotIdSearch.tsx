"use client";
import { useState } from "react";

export type PlayerResult = {
  puuid: string;
  gameName: string;
  tagLine: string;
  tier: string;
  rank: string;
  lp: number;
  wins: number;
  losses: number;
  profileIconId: number | null;
  summonerLevel: number | null;
};

const TIER_COLORS: Record<string, string> = {
  IRON: "#8B8B8B",
  BRONZE: "#CD7F32",
  SILVER: "#A8A9AD",
  GOLD: "#C8A84B",
  PLATINUM: "#00B2A9",
  EMERALD: "#2AC56F",
  DIAMOND: "#576BCE",
  MASTER: "#9D48E0",
  GRANDMASTER: "#CD4545",
  CHALLENGER: "#F4C874",
  UNRANKED: "#4B5563",
};

const DDRAGON_VERSION = "14.24.1";

interface RiotIdSearchProps {
  onSelect: (player: PlayerResult) => void;
  alreadyAdded?: string[]; // lista de puuids já adicionados
}

export function RiotIdSearch({ onSelect, alreadyAdded = [] }: RiotIdSearchProps) {
  const [query, setQuery]   = useState("");
  const [result, setResult] = useState<PlayerResult | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError]   = useState("");

  async function handleSearch() {
    const trimmed = query.trim();
    const hashIdx = trimmed.lastIndexOf("#");

    if (hashIdx === -1 || hashIdx === trimmed.length - 1) {
      setError("Use o formato: NomeIngame#TAG  (ex: renektonforever#019)");
      return;
    }

    const gameName = trimmed.slice(0, hashIdx);
    const tagLine  = trimmed.slice(hashIdx + 1);

    setLoading(true);
    setError("");
    setResult(null);

    try {
      const res = await fetch(
        `/api/riot/player?gameName=${encodeURIComponent(gameName)}&tagLine=${encodeURIComponent(tagLine)}`
      );
      const data = await res.json();

      if (!res.ok) {
        throw new Error(data?.error ?? "Jogador não encontrado");
      }

      setResult(data as PlayerResult);
    } catch (e: any) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  }

  const isAlreadyAdded = result ? alreadyAdded.includes(result.puuid) : false;
  const tierColor = result ? (TIER_COLORS[result.tier] ?? TIER_COLORS.UNRANKED) : "";
  const winrate   = result && (result.wins + result.losses) > 0
    ? Math.round((result.wins / (result.wins + result.losses)) * 100)
    : null;

  return (
    <div className="space-y-3">
      <label className="block text-gray-400 text-sm font-medium">
        Buscar jogador por Riot ID
      </label>

      {/* Input de busca */}
      <div className="flex gap-2">
        <input
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          onKeyDown={(e) => e.key === "Enter" && handleSearch()}
          placeholder="renektonforever#019"
          className="flex-1 bg-[#0A1428] border border-[#1E3A5F] rounded-lg px-3 py-2
                     text-white text-sm placeholder-gray-700
                     focus:outline-none focus:border-[#C8A84B]/50 transition-colors"
        />
        <button
          type="button"
          onClick={handleSearch}
          disabled={loading || !query.trim()}
          className="bg-[#C8A84B] hover:bg-[#d4b55a] disabled:opacity-40 disabled:cursor-not-allowed
                     text-black font-semibold text-sm px-4 py-2 rounded-lg transition-colors"
        >
          {loading ? (
            <span className="inline-block w-4 h-4 border-2 border-black/30 border-t-black rounded-full animate-spin" />
          ) : (
            "Buscar"
          )}
        </button>
      </div>

      {/* Erro */}
      {error && (
        <p className="text-red-400 text-xs flex items-center gap-1">
          <span>⚠️</span> {error}
        </p>
      )}

      {/* Card do resultado */}
      {result && (
        <div className="bg-[#0A1428] border border-[#1E3A5F] rounded-xl p-3 flex items-center gap-3">
          {/* Ícone de perfil */}
          {result.profileIconId ? (
            <img
              src={`https://ddragon.leagueoflegends.com/cdn/${DDRAGON_VERSION}/img/profileicon/${result.profileIconId}.png`}
              alt="ícone de perfil"
              width={44}
              height={44}
              loading="lazy"
              className="rounded-full border-2 border-[#1E3A5F] flex-shrink-0"
            />
          ) : (
            <div className="w-11 h-11 rounded-full bg-[#0D1B2E] border border-[#1E3A5F] flex items-center justify-center text-lg flex-shrink-0">
              👤
            </div>
          )}

          {/* Dados do jogador */}
          <div className="flex-1 min-w-0">
            <p className="text-white text-sm font-semibold truncate">
              {result.gameName}
              <span className="text-gray-500 font-normal">#{result.tagLine}</span>
            </p>
            <div className="flex items-center gap-2 mt-0.5">
              <span
                className="text-xs font-medium"
                style={{ color: tierColor }}
              >
                {result.tier === "UNRANKED" ? "Sem rank" : `${result.tier} ${result.rank}`}
              </span>
              {result.lp > 0 && (
                <span className="text-gray-600 text-xs">· {result.lp} LP</span>
              )}
              {winrate !== null && (
                <span className="text-gray-600 text-xs">· {winrate}% WR</span>
              )}
            </div>
            {result.summonerLevel && (
              <p className="text-gray-700 text-xs">Nível {result.summonerLevel}</p>
            )}
          </div>

          {/* Botão de adicionar */}
          {isAlreadyAdded ? (
            <span className="text-xs text-gray-600 flex-shrink-0">Adicionado ✓</span>
          ) : (
            <button
              type="button"
              onClick={() => onSelect(result)}
              className="flex-shrink-0 text-xs bg-[#C8A84B] hover:bg-[#d4b55a]
                         text-black font-bold px-3 py-1.5 rounded-lg transition-colors"
            >
              Adicionar
            </button>
          )}
        </div>
      )}
    </div>
  );
}
