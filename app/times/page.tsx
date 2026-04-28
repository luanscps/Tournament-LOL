import { createAdminClient } from "@/lib/supabase/admin";
import Link from "next/link";

export const dynamic = "force-dynamic";

const ROLE_ORDER: Record<string, number> = {
  TOP: 0, JUNGLE: 1, MID: 2, ADC: 3, SUPPORT: 4,
};
const ROLE_LABELS: Record<string, string> = {
  TOP: "Top", JUNGLE: "Jungle", MID: "Mid", ADC: "ADC", SUPPORT: "Suporte",
};
const ROLE_ICON_URL: Record<string, string> = {
  TOP:     "https://raw.communitydragon.org/latest/plugins/rcp-fe-lol-champ-select/global/default/svg/position-top.svg",
  JUNGLE:  "https://raw.communitydragon.org/latest/plugins/rcp-fe-lol-champ-select/global/default/svg/position-jungle.svg",
  MID:     "https://raw.communitydragon.org/latest/plugins/rcp-fe-lol-champ-select/global/default/svg/position-middle.svg",
  ADC:     "https://raw.communitydragon.org/latest/plugins/rcp-fe-lol-champ-select/global/default/svg/position-bottom.svg",
  SUPPORT: "https://raw.communitydragon.org/latest/plugins/rcp-fe-lol-champ-select/global/default/svg/position-utility.svg",
};
const TIER_HEX: Record<string, string> = {
  CHALLENGER: "#F4C874", GRANDMASTER: "#CD4545", MASTER: "#9D48E0",
  DIAMOND: "#576BCE", EMERALD: "#2AC56F", PLATINUM: "#00B2A9",
  GOLD: "#C8A84B", SILVER: "#A8A9AD", BRONZE: "#CD7F32",
  IRON: "#8B8B8B", UNRANKED: "#4B5563",
};
const TIER_ORDER: Record<string, number> = {
  CHALLENGER: 10, GRANDMASTER: 9, MASTER: 8, DIAMOND: 7,
  EMERALD: 6, PLATINUM: 5, GOLD: 4, SILVER: 3, BRONZE: 2,
  IRON: 1, UNRANKED: 0,
};
const DDRAGON = "14.24.1";
const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const ROLES = ["TOP", "JUNGLE", "MID", "ADC", "SUPPORT"] as const;

type RiotAccount = {
  id: string;
  game_name: string;
  tag_line: string;
  profile_icon_id: number | null;
  summoner_level: number | null;
};

type RankSnapshot = {
  tier: string;
  rank: string;
  lp: number;
};

type TeamMember = {
  id: string;
  team_role: string;
  status: string;
  lane: string | null;
  riot_account: RiotAccount | null;
  rank_snapshot: RankSnapshot | null;
};

type Team = {
  id: string;
  name: string;
  tag: string;
  slug: string | null;
  logo_url: string | null;
  banner_url: string | null;
  members: TeamMember[];
};

export default async function TimesPage() {
  const admin = createAdminClient();

  const { data: rawTeams, error } = await admin
    .from("teams")
    .select(`
      id, name, tag, slug, logo_url, banner_url,
      members:team_members!team_members_team_id_fkey(
        id,
        team_role,
        status,
        lane,
        riot_account:riot_accounts!team_members_riot_account_id_fkey(
          id, game_name, tag_line, profile_icon_id, summoner_level
        )
      )
    `)
    .order("name");

  if (error) console.error("[TimesPage] erro teams:", error.message);

  // Coleta todos os riot_account_ids para buscar rank_snapshots em lote
  const allRiotIds: string[] = [];
  for (const team of rawTeams ?? []) {
    for (const m of (team.members ?? []) as any[]) {
      const raId = m.riot_account?.id;
      if (raId && !allRiotIds.includes(raId)) allRiotIds.push(raId);
    }
  }

  const rankMap: Record<string, RankSnapshot> = {};
  if (allRiotIds.length > 0) {
    const { data: snapshots } = await admin
      .from("rank_snapshots")
      .select("riot_account_id, tier, rank, lp, recorded_at")
      .in("riot_account_id", allRiotIds)
      .order("recorded_at", { ascending: false });

    for (const snap of snapshots ?? []) {
      if (!rankMap[snap.riot_account_id]) {
        rankMap[snap.riot_account_id] = {
          tier: snap.tier ?? "UNRANKED",
          rank: snap.rank ?? "",
          lp: snap.lp ?? 0,
        };
      }
    }
  }

  const teams: Team[] = (rawTeams ?? []).map((t: any) => ({
    id: t.id,
    name: t.name,
    tag: t.tag,
    slug: t.slug ?? null,
    logo_url: t.logo_url ?? null,
    banner_url: t.banner_url ?? null,
    members: ((t.members ?? []) as any[])
      .filter((m: any) => m.status === "accepted" && m.riot_account)
      .map((m: any) => ({
        id: m.id,
        team_role: m.team_role ?? "member",
        status: m.status,
        lane: m.lane ?? null,
        riot_account: m.riot_account
          ? {
              id: m.riot_account.id,
              game_name: m.riot_account.game_name ?? "—",
              tag_line:
                m.riot_account.tag_line && m.riot_account.tag_line !== "undefined"
                  ? m.riot_account.tag_line
                  : "BR1",
              profile_icon_id: m.riot_account.profile_icon_id ?? null,
              summoner_level: m.riot_account.summoner_level ?? null,
            }
          : null,
        rank_snapshot: m.riot_account?.id ? (rankMap[m.riot_account.id] ?? null) : null,
      })),
  }));

  return (
    <div className="min-h-screen bg-[#050E1A]">
      <div className="max-w-5xl mx-auto p-4 md:p-6 space-y-6">

        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-white">Times</h1>
            <p className="text-gray-500 text-sm mt-0.5">
              {teams.length} time{teams.length !== 1 ? "s" : ""} cadastrado{teams.length !== 1 ? "s" : ""}
            </p>
          </div>
          <Link
            href="/dashboard/times/criar"
            className="bg-[#C8A84B] hover:bg-[#d4b55a] text-black font-semibold text-sm px-4 py-2 rounded-lg transition-colors"
          >
            + Criar Time
          </Link>
        </div>

        {/* Estado vazio */}
        {teams.length === 0 && (
          <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-xl text-center py-20">
            <p className="text-5xl mb-4">🛡️</p>
            <h2 className="text-white font-bold text-lg mb-2">Nenhum time cadastrado ainda</h2>
            <p className="text-gray-400 text-sm mb-6">Crie o primeiro time da plataforma!</p>
            <Link
              href="/dashboard/times/criar"
              className="inline-block bg-[#C8A84B] text-black font-semibold px-5 py-2 rounded-lg text-sm"
            >
              Criar Time
            </Link>
          </div>
        )}

        {/* Grid de cards */}
        {teams.length > 0 && (
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {teams.map((team) => {
              // Agrupa membros por lane
              const byLane = (lane: string) =>
                team.members
                  .filter((m) => (m.lane ?? "").toUpperCase() === lane)
                  .sort((a, b) => (ROLE_ORDER[a.lane ?? ""] ?? 99) - (ROLE_ORDER[b.lane ?? ""] ?? 99))[0] ?? null;

              // Tier médio do time
              const ranked = team.members.filter(
                (m) => m.rank_snapshot && m.rank_snapshot.tier !== "UNRANKED"
              );
              const avgTierIdx =
                ranked.length > 0
                  ? Math.round(
                      ranked.reduce(
                        (acc, m) =>
                          acc + (TIER_ORDER[(m.rank_snapshot?.tier ?? "").toUpperCase()] ?? 0),
                        0
                      ) / ranked.length
                    )
                  : -1;
              const avgTierName =
                Object.entries(TIER_ORDER).find(([, v]) => v === avgTierIdx)?.[0] ?? null;
              const avgColor = avgTierName ? (TIER_HEX[avgTierName] ?? "#4B5563") : "#4B5563";

              const teamHref = `/times/${
                team.slug && !UUID_RE.test(team.slug) ? team.slug : team.id
              }`;

              return (
                <Link
                  key={team.id}
                  href={teamHref}
                  className="group block rounded-xl overflow-hidden transition-all hover:-translate-y-0.5"
                  style={{
                    background: "#0D1B2E",
                    border: "1px solid #1E3A5F",
                    boxShadow: "0 2px 8px rgba(0,0,0,0.3)",
                  }}
                >
                  {/* Banner */}
                  <div className="relative h-20 overflow-hidden bg-[#0A1428]">
                    {(team.banner_url || team.logo_url) && (
                      <div
                        className="absolute inset-0"
                        style={{
                          backgroundImage: `url(${team.banner_url ?? team.logo_url})`,
                          backgroundSize: team.banner_url ? "cover" : "120px",
                          backgroundPosition: "center",
                          backgroundRepeat: "no-repeat",
                          filter: team.banner_url
                            ? "brightness(0.4) saturate(1.2)"
                            : "blur(20px) brightness(0.25) saturate(1.4)",
                          transform: "scale(1.1)",
                        }}
                      />
                    )}
                    <div
                      className="absolute inset-0"
                      style={{ background: "linear-gradient(180deg, transparent 30%, #0D1B2E 100%)" }}
                    />
                    <div
                      className="absolute top-0 left-0 right-0 h-[2px] opacity-0 group-hover:opacity-100 transition-opacity"
                      style={{ background: "linear-gradient(90deg, transparent, #C8A84B, transparent)" }}
                    />
                    <div className="absolute bottom-2 left-3">
                      {team.logo_url ? (
                        <div className="relative">
                          <div
                            className="absolute -inset-[2px] rounded-lg opacity-50"
                            style={{ background: "linear-gradient(135deg,#C8A84B,#8B6914,#C8A84B)" }}
                          />
                          <img
                            src={team.logo_url}
                            alt={team.name}
                            width={40}
                            height={40}
                            loading="lazy"
                            className="relative rounded-lg object-cover w-10 h-10"
                          />
                        </div>
                      ) : (
                        <div className="w-10 h-10 rounded-lg bg-[#050E1A] border border-[#1E3A5F] flex items-center justify-center text-xl">
                          🛡️
                        </div>
                      )}
                    </div>
                  </div>

                  {/* Corpo */}
                  <div className="px-3 pt-2 pb-3">
                    <div className="mb-2">
                      <p className="text-[10px] font-black uppercase tracking-[0.2em] text-[#C8A84B]">
                        [{team.tag}]
                      </p>
                      <h2 className="text-white font-bold text-sm truncate group-hover:text-[#C8A84B] transition-colors">
                        {team.name}
                      </h2>
                      <div className="flex items-center gap-1.5 mt-0.5">
                        <span className="text-gray-600 text-xs">
                          {team.members.length}/5 jogadores
                        </span>
                        {avgTierName && (
                          <>
                            <span className="text-gray-700 text-xs">·</span>
                            <span className="text-xs font-semibold" style={{ color: avgColor }}>
                              ~{avgTierName}
                            </span>
                          </>
                        )}
                      </div>
                    </div>

                    <div className="border-t mb-2.5" style={{ borderColor: "rgba(30,58,95,0.6)" }} />

                    {/* Roster por lane */}
                    <div className="space-y-1">
                      {ROLES.map((role) => {
                        const member = byLane(role);
                        const ra = member?.riot_account ?? null;
                        const snap = member?.rank_snapshot ?? null;
                        const tierColor =
                          TIER_HEX[(snap?.tier ?? "UNRANKED").toUpperCase()] ?? "#4B5563";

                        return (
                          <div key={role} className="flex items-center gap-1.5 text-xs">
                            <img
                              src={ROLE_ICON_URL[role]}
                              alt={role}
                              width={14}
                              height={14}
                              loading="lazy"
                              className="w-3.5 h-3.5 opacity-50 flex-shrink-0"
                              style={{
                                filter:
                                  "invert(1) sepia(1) saturate(1.5) hue-rotate(5deg)",
                              }}
                            />
                            <span className="text-gray-600 w-12 shrink-0">
                              {ROLE_LABELS[role]}
                            </span>
                            {ra ? (
                              <div className="flex items-center gap-1 min-w-0 flex-1">
                                {ra.profile_icon_id ? (
                                  <img
                                    src={`https://ddragon.leagueoflegends.com/cdn/${DDRAGON}/img/profileicon/${ra.profile_icon_id}.png`}
                                    alt={ra.game_name}
                                    width={16}
                                    height={16}
                                    loading="lazy"
                                    className="w-4 h-4 rounded-full flex-shrink-0"
                                    style={{ border: `1px solid ${tierColor}50` }}
                                  />
                                ) : (
                                  <span
                                    className="w-1.5 h-1.5 rounded-full flex-shrink-0"
                                    style={{ background: tierColor }}
                                  />
                                )}
                                <span className="text-gray-300 truncate">
                                  {ra.game_name}
                                  <span className="text-gray-600">#{ra.tag_line}</span>
                                </span>
                              </div>
                            ) : (
                              <span className="text-gray-700 italic">Vaga em aberto</span>
                            )}
                          </div>
                        );
                      })}
                    </div>
                  </div>
                </Link>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
