"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import Image from "next/image";
interface SummonerResult {
  account: { puuid: string; gameName: string; tagLine: string };
  summoner: { profileIconId: number; summonerLevel: number; id: string };
  entries: Array<{ queueType: string; tier: string; rank: string; leaguePoints: number; wins: number; losses: number }>;
  masteries: Array<{ championId: number; championName: string; championLevel: number; championPoints: number }>;
}
export default function RegistrarRiotPage() {
  const [riotId, setRiotId]   = useState("");
  const [result, setResult]   = useState<SummonerResult | null>(null);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving]   = useState(false);
  const [error, setError]     = useState("");
  const [saved, setSaved]     = useState(false);
  const router   = useRouter();
  const supabase = createClient();
  const DD = "https://ddragon.leagueoflegends.com/cdn/14.10.1";
  const TIER_COLORS: Record<string,string> = {
    IRON:"#8B7A6B",BRONZE:"#CD7F32",SILVER:"#A8A9AD",GOLD:"#FFD700",
    PLATINUM:"#00E5CC",EMERALD:"#50C878",DIAMOND:"#99CCFF",
    MASTER:"#9B59B6",GRANDMASTER:"#E74C3C",CHALLENGER:"#00D4FF",
  };
  async function handleSearch(e: React.FormEvent) {
    e.preventDefault();
    if (!riotId.includes("#")) { setError("Use o formato Nome#TAG"); return; }
    setLoading(true); setError(""); setResult(null);
    try {
      const res  = await fetch("/api/riot/summoner?riotId=" + encodeURIComponent(riotId));
      const data = await res.json();
      if (!res.ok) throw new Error(data.error);
      setResult(data);
    } catch (err: unknown) { setError(err instanceof Error ? err.message : "Nao encontrado"); }
    finally { setLoading(false); }
  }
  async function handleSave() {
    if (!result) return;
    setSaving(true); setError("");
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }
      const { data: acct, error: e1 } = await supabase.from("riot_accounts").upsert({
        profile_id: user.id, puuid: result.account.puuid,
        game_name: result.account.gameName, tag_line: result.account.tagLine,
        summoner_id: result.summoner.id, summoner_level: result.summoner.summonerLevel,
        profile_icon_id: result.summoner.profileIconId, is_primary: true,
      }, { onConflict: "puuid" }).select().single();
      if (e1) throw e1;
      for (const entry of result.entries) {
        await supabase.from("rank_snapshots").insert({
          riot_account_id: acct.id, queue_type: entry.queueType,
          tier: entry.tier, rank: entry.rank, lp: entry.leaguePoints,
          wins: entry.wins, losses: entry.losses,
        });
      }
      for (const m of result.masteries) {
        await supabase.from("champion_masteries").upsert({
          riot_account_id: acct.id, champion_id: m.championId,
          champion_name: m.championName, mastery_level: m.championLevel, mastery_points: m.championPoints,
        }, { onConflict: "riot_account_id,champion_id" });
      }
      setSaved(true);
      setTimeout(() => router.push("/dashboard"), 1500);
    } catch (err: unknown) { setError(err instanceof Error ? err.message : "Erro ao salvar"); }
    finally { setSaving(false); }
  }
  return (
    <div className="max-w-lg mx-auto space-y-6">
      <h1 className="text-2xl font-bold text-white">🔗 Vincular Conta Riot</h1>
      <div className="card-lol">
        <p className="text-gray-400 text-sm mb-4">
          Busque pelo seu <strong className="text-white">Riot ID</strong> no formato <code className="text-[#C8A84B] bg-[#0A1428] px-1 rounded">Nome#TAG</code>
        </p>
        <form onSubmit={handleSearch} className="flex gap-2">
          <input value={riotId} onChange={e => setRiotId(e.target.value)}
            placeholder="SeuNome#BR1" className="input-lol flex-1" required />
          <button type="submit" disabled={loading} className="btn-gold px-6 shrink-0">
            {loading ? "..." : "Buscar"}
          </button>
        </form>
        {error && <p className="text-red-400 text-sm mt-3">{error}</p>}
      </div>
      {result && (
        <div className="card-lol space-y-4">
          <div className="flex items-center gap-4">
            <Image src={DD + "/img/profileicon/" + result.summoner.profileIconId + ".png"}
              width={64} height={64} alt="icon" className="rounded-full border-2 border-[#C8A84B]" />
            <div>
              <p className="text-xl font-bold text-white">
                {result.account.gameName}<span className="text-gray-500">#{result.account.tagLine}</span>
              </p>
              <p className="text-gray-400 text-sm">Nivel {result.summoner.summonerLevel}</p>
            </div>
          </div>
          {result.entries.length > 0 && (
            <div className="space-y-2">
              <p className="text-gray-400 text-xs font-bold uppercase tracking-wider">Rank Oficial</p>
              {result.entries.map(e => (
                <div key={e.queueType} className="flex items-center justify-between bg-[#0A1428] rounded p-3">
                  <div>
                    <p className="text-white text-sm font-medium">{e.queueType === "RANKED_SOLO_5x5" ? "Solo/Duo" : "Flex"}</p>
                    <p className="text-gray-400 text-xs">{e.wins}V · {e.losses}D · {e.wins+e.losses > 0 ? Math.round(e.wins/(e.wins+e.losses)*100) : 0}%WR</p>
                  </div>
                  <p className="font-bold" style={{ color: TIER_COLORS[e.tier] ?? "#666" }}>
                    {e.tier === "UNRANKED" ? "Sem Rank" : e.tier + " " + e.rank + " — " + e.leaguePoints + " LP"}
                  </p>
                </div>
              ))}
            </div>
          )}
          {result.masteries.length > 0 && (
            <div>
              <p className="text-gray-400 text-xs font-bold uppercase tracking-wider mb-2">Top Campeoes</p>
              <div className="flex gap-2">
                {result.masteries.slice(0,5).map(m => (
                  <div key={m.championId} className="text-center" title={m.championName}>
                    <Image src={DD + "/img/champion/" + m.championName + ".png"}
                      width={44} height={44} alt={m.championName}
                      className="rounded border border-[#1E3A5F]" />
                    <p className="text-[10px] text-gray-500 mt-0.5">M{m.championLevel}</p>
                  </div>
                ))}
              </div>
            </div>
          )}
          {saved ? (
            <p className="text-green-400 font-bold text-center">✅ Conta vinculada! Redirecionando...</p>
          ) : (
            <button onClick={handleSave} disabled={saving} className="btn-gold w-full py-3">
              {saving ? "Salvando..." : "✅ Vincular esta Conta"}
            </button>
          )}
        </div>
      )}
    </div>
  );
}
