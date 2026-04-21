import { createClient } from "@/lib/supabase/server";
import Image from "next/image";
import { getTierColor, formatRank } from "@/lib/utils";
export default async function RankingPage() {
  const supabase = await createClient();
  const { data: accounts } = await supabase
    .from("riot_accounts")
    .select("*, profiles(username, display_name), rank_snapshots(*)")
    .eq("is_primary", true)
    .order("summoner_level", { ascending: false })
    .limit(50);
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold text-white">🏆 Ranking de Invocadores</h1>
      <div className="card-lol overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="text-gray-400 border-b border-[#1E3A5F]">
              <th className="text-left pb-3 w-12">#</th>
              <th className="text-left pb-3">Invocador</th>
              <th className="text-left pb-3">Solo/Duo</th>
              <th className="text-left pb-3">Flex</th>
              <th className="text-right pb-3">Nivel</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-[#1E3A5F]">
            {accounts?.map((acc, i) => {
              const solo = acc.rank_snapshots?.find((r: {queue_type:string}) => r.queue_type === "RANKED_SOLO_5x5");
              const flex = acc.rank_snapshots?.find((r: {queue_type:string}) => r.queue_type === "RANKED_FLEX_SR");
              return (
                <tr key={acc.id} className="hover:bg-[#0A1428] transition-colors">
                  <td className="py-3 text-gray-500 font-mono">{i + 1}</td>
                  <td className="py-3">
                    <div className="flex items-center gap-3">
                      {acc.profile_icon_id ? (
                        <Image src={"https://ddragon.leagueoflegends.com/cdn/14.10.1/img/profileicon/" + acc.profile_icon_id + ".png"}
                          width={36} height={36} alt="icon" className="rounded-full border border-[#1E3A5F]" />
                      ) : (
                        <div className="w-9 h-9 rounded-full bg-[#1E3A5F] flex items-center justify-center text-gray-500">?</div>
                      )}
                      <div>
                        <p className="text-white font-medium">{acc.game_name}<span className="text-gray-500">#{acc.tag_line}</span></p>
                        <p className="text-gray-500 text-xs">{acc.profiles?.display_name}</p>
                      </div>
                    </div>
                  </td>
                  <td className="py-3">
                    {solo ? (
                      <span className="badge-tier" style={{ color: getTierColor(solo.tier), background: getTierColor(solo.tier) + "20" }}>
                        {formatRank(solo.tier, solo.rank, solo.lp)}
                      </span>
                    ) : <span className="text-gray-600 text-xs">Sem rank</span>}
                  </td>
                  <td className="py-3">
                    {flex ? (
                      <span className="badge-tier" style={{ color: getTierColor(flex.tier), background: getTierColor(flex.tier) + "20" }}>
                        {formatRank(flex.tier, flex.rank, flex.lp)}
                      </span>
                    ) : <span className="text-gray-600 text-xs">Sem rank</span>}
                  </td>
                  <td className="py-3 text-right text-[#C8A84B] font-bold">{acc.summoner_level}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}
