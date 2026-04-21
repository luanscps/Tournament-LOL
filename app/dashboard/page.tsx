import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import Link from "next/link";
import Image from "next/image";
import { getTierColor, formatRank, getWinRate } from "@/lib/utils";
export default async function DashboardPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");
  const [{ data: profile }, { data: riotAccount }, { data: myTeams }, { data: openTournaments }] = await Promise.all([
    supabase.from("profiles").select("*").eq("id", user.id).single(),
    supabase.from("riot_accounts").select("*, rank_snapshots(*), champion_masteries(*)").eq("profile_id", user.id).eq("is_primary", true).single(),
    supabase.from("team_members").select("*, role, teams(*, tournaments(name, slug, status))").eq("profile_id", user.id),
    supabase.from("tournaments").select("id, name, slug, status, max_teams, starts_at").eq("status", "open").limit(3),
  ]);
  const soloRank = riotAccount?.rank_snapshots?.find((r: {queue_type:string}) => r.queue_type === "RANKED_SOLO_5x5");
  const flexRank = riotAccount?.rank_snapshots?.find((r: {queue_type:string}) => r.queue_type === "RANKED_FLEX_SR");
  return (
    <div className="space-y-8">
      <div className="card-lol flex items-center gap-6 flex-wrap">
        {riotAccount?.profile_icon_id ? (
          <div className="relative shrink-0">
            <Image src={"https://ddragon.leagueoflegends.com/cdn/14.10.1/img/profileicon/" + riotAccount.profile_icon_id + ".png"}
              width={80} height={80} alt="icon" className="rounded-full border-2 border-[#C8A84B]" />
            <span className="absolute -bottom-2 left-1/2 -translate-x-1/2 bg-[#0A1428] text-[#C8A84B] text-[10px] font-bold px-2 py-0.5 rounded border border-[#C8A84B] whitespace-nowrap">
              Nv. {riotAccount.summoner_level}
            </span>
          </div>
        ) : (
          <div className="w-20 h-20 rounded-full bg-[#1E3A5F] flex items-center justify-center text-3xl shrink-0">👤</div>
        )}
        <div className="flex-1 min-w-0">
          <h1 className="text-2xl font-bold text-white truncate">{profile?.display_name ?? profile?.username}</h1>
          {riotAccount ? (
            <p className="text-gray-400">{riotAccount.game_name}<span className="text-gray-600">#{riotAccount.tag_line}</span></p>
          ) : (
            <Link href="/dashboard/jogador/registrar" className="text-yellow-400 hover:underline text-sm">
              Vincule sua conta Riot para participar
            </Link>
          )}
          <div className="flex gap-4 mt-2 flex-wrap">
            {soloRank && (
              <span className="badge-tier text-xs px-2 py-0.5 rounded"
                style={{ color: getTierColor(soloRank.tier), background: getTierColor(soloRank.tier) + "20" }}>
                Solo: {formatRank(soloRank.tier, soloRank.rank, soloRank.lp)} · {getWinRate(soloRank.wins, soloRank.losses)}%WR
              </span>
            )}
            {flexRank && (
              <span className="badge-tier text-xs px-2 py-0.5 rounded"
                style={{ color: getTierColor(flexRank.tier), background: getTierColor(flexRank.tier) + "20" }}>
                Flex: {formatRank(flexRank.tier, flexRank.rank, flexRank.lp)}
              </span>
            )}
          </div>
        </div>
        <Link href="/dashboard/jogador/registrar" className="btn-outline-gold text-sm text-center shrink-0">
          {riotAccount ? "🔄 Atualizar Rank" : "🔗 Vincular Riot"}
        </Link>
      </div>

      <div className="card-lol">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-bold text-white">🛡️ Meus Times</h2>
          <Link href="/dashboard/time/criar" className="btn-gold text-sm px-3 py-1.5">+ Criar Time</Link>
        </div>
        {myTeams && myTeams.length > 0 ? (
          <div className="space-y-3">
            {myTeams.map((tm: any) => (
              <div key={tm.id} className="flex items-center justify-between bg-[#0A1428] rounded p-3">
                <div>
                  <p className="text-white font-medium"><span className="text-[#C8A84B]">[{tm.teams.tag}]</span> {tm.teams.name}</p>
                  <p className="text-gray-400 text-xs mt-0.5">{tm.teams.tournaments?.name} · {tm.role}</p>
                </div>
                <Link href={"/torneios/" + tm.teams.tournaments?.slug} className="text-[#C8A84B] text-xs hover:underline">Ver torneio →</Link>
              </div>
            ))}
          </div>
        ) : (
          <div className="text-center py-8">
            <p className="text-gray-500 text-sm mb-3">Voce ainda nao esta em nenhum time.</p>
            <Link href="/torneios" className="btn-outline-gold text-sm">Explorar Torneios</Link>
          </div>
        )}
      </div>

      {openTournaments && openTournaments.length > 0 && (
        <div className="card-lol">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-bold text-white">🏆 Inscricoes Abertas</h2>
            <Link href="/torneios" className="text-[#C8A84B] text-sm hover:underline">Ver todos →</Link>
          </div>
          <div className="space-y-2">
            {openTournaments.map((t: any) => (
              <Link key={t.id} href={"/torneios/" + t.slug}
                className="flex items-center justify-between bg-[#0A1428] rounded p-3 hover:border-[#C8A84B]/30 border border-transparent transition-colors">
                <div>
                  <p className="text-white">{t.name}</p>
                  {t.starts_at && <p className="text-gray-500 text-xs">{new Date(t.starts_at).toLocaleDateString("pt-BR")}</p>}
                </div>
                <span className="text-green-400 text-xs font-medium">Inscrever →</span>
              </Link>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
