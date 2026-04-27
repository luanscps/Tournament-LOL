import { createAdminClient } from "@/lib/supabase/admin";
import Link from "next/link";

export const dynamic = "force-dynamic";

const DDRAGON = "14.24.1";

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

const ROLES = ["TOP", "JUNGLE", "MID", "ADC", "SUPPORT"] as const;

export default async function TimesPage() {
  const admin = createAdminClient();

  const { data: teams, error } = await admin
    .from("teams")
    .select(
      `id, name, tag, slug, logo_url, banner_url,
       players:players(id, summoner_name, tag_line, role, tier, rank, lp, profile_icon)`
    )
    .order("name");

  if (error) console.error("[TimesPage] erro:", error.message);

  return (
    <div className="min-h-screen bg-[#050E1A]">
      <div className="max-w-5xl mx-auto p-4 md:p-6 space-y-6">

        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-white">Times</h1>
            <p className="text-gray-500 text-sm mt-0.5">
              {teams?.length ?? 0} time{(teams?.length ?? 0) !== 1 ? "s" : ""} cadastrado{(teams?.length ?? 0) !== 1 ? "s" : ""}
            </p>
          </div>
          <Link
            href="/dashboard/times/criar"
            className="bg-[#C8A84B] hover:bg-[#d4b55a] text-black font-semibold text-sm px-4 py-2 rounded-lg transition-colors"
          >
            + Criar Time
          </Link>
        </div>

        {/* Vazio */}
        {(!teams || teams.length === 0) && (
          <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-xl text-center py-20">
            <p className="text-5xl mb-4">🛡️</p>
            <h2 className="text-white font-bold text-lg mb-2">Nenhum time cadastrado ainda</h2>
            <p className="text-gray-400 text-sm mb-6">Crie o primeiro time da plataforma!</p>
            <Link href="/dashboard/times/criar"
              className="inline-block bg-[#C8A84B] text-black font-semibold px-5 py-2 rounded-lg text-sm">
              Criar Time
            </Link>
          </div>
        )}

        {/* Grid de times */}
        {teams && teams.length > 0 && (
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {teams.map((team) => {
              const players = (team.players ?? []) as any[];
              const byRole = (role: string) => players.find((p: any) => p.role === role) ?? null;

              // Tier médio do time (para barra de força)
              const ranked = players.filter((p: any) => p.tier && p.tier !== "UNRANKED");
              const avgTierIdx =
                ranked.length > 0
                  ? Math.round(
                      ranked.reduce((acc: number, p: any) => acc + (TIER_ORDER[(p.tier ?? "").toUpperCase()] ?? 0), 0) /
                        ranked.length,
                    )
                  : -1;
              const avgTierName =
                Object.entries(TIER_ORDER).find(([, v]) => v === avgTierIdx)?.[0] ?? null;
              const avgColor = avgTierName ? (TIER_HEX[avgTierName] ?? "#4B5563") : "#4B5563";

              return (
                <Link
                  key={team.id}
                  href={`/times/${team.slug ?? team.id}`}
                  className="group block rounded-xl overflow-hidden transition-all hover:-translate-y-0.5"
                  style={{
                    background: "#0D1B2E",
                    border: "1px solid #1E3A5F",
                    boxShadow: "0 2px 8px rgba(0,0,0,0.3)",
                  }}
                >
                  {/* Banner do time */}
                  <div
                    className="relative h-20 overflow-hidden"
                    style={{ background: "#0A1428" }}
                  >
                    {/* Fundo: banner_url ou logo blurred */}
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
                    {/* Gradiente de fade para o card */}
                    <div
                      className="absolute inset-0"
                      style={{
                        background:
                          "linear-gradient(180deg, transparent 30%, #0D1B2E 100%)",
                      }}
                    />
                    {/* Linha dourada no topo */}
                    <div
                      className="absolute top-0 left-0 right-0 h-[2px] opacity-0 group-hover:opacity-100 transition-opacity"
                      style={{
                        background:
                          "linear-gradient(90deg, transparent, #C8A84B, transparent)",
                      }}
                    />
                    {/* Logo sobreposto */}
                    <div className="absolute bottom-2 left-3 flex items-end gap-2">
                      {team.logo_url ? (
                        <div className="relative">
                          <div
                            className="absolute -inset-[2px] rounded-lg opacity-50"
                            style={{
                              background:
                                "linear-gradient(135deg,#C8A84B,#8B6914,#C8A84B)",
                            }}
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
                        <div
                          className="w-10 h-10 rounded-lg bg-[#050E1A] border border-[#1E3A5F]
                                     flex items-center justify-center text-xl"
                        >
                          🛡️
                        </div>
                      )}
                    </div>
                  </div>

                  {/* Corpo do card */}
                  <div className="px-3 pt-2 pb-3">
                    {/* Nome e tag */}
                    <div className="mb-2">
                      <p
                        className="text-[10px] font-black uppercase tracking-[0.2em]"
                        style={{ color: "#C8A84B" }}
                      >
                        [{team.tag}]
                      </p>
                      <h2
                        className="text-white font-bold text-sm truncate transition-colors group-hover:text-[#C8A84B]"
                      >
                        {team.name}
                      </h2>
                      <div className="flex items-center gap-1.5 mt-0.5">
                        <span className="text-gray-600 text-xs">
                          {players.length}/5 jogadores
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

                    {/* Divisor */}
                    <div className="border-t mb-2.5" style={{ borderColor: "rgba(30,58,95,0.6)" }} />

                    {/* Roster por role */}
                    <div className="space-y-1">
                      {ROLES.map((role) => {
                        const p = byRole(role);
                        const tierColor = TIER_HEX[(p?.tier ?? "UNRANKED").toUpperCase()] ?? "#4B5563";

                        return (
                          <div key={role} className="flex items-center gap-1.5 text-xs">
                            {/* Ícone CDragon */}
                            {ROLE_ICON_URL[role] ? (
                              <img
                                src={ROLE_ICON_URL[role]}
                                alt={role}
                                width={14}
                                height={14}
                                loading="lazy"
                                className="w-3.5 h-3.5 opacity-50 flex-shrink-0"
                                style={{ filter: "invert(1) sepia(1) saturate(1.5) hue-rotate(5deg)" }}
                              />
                            ) : (
                              <span className="w-3.5 text-center">❓</span>
                            )}
                            <span className="text-gray-600 w-12 shrink-0">
                              {ROLE_LABELS[role]}
                            </span>
                            {p ? (
                              <div className="flex items-center gap-1 min-w-0 flex-1">
                                {/* Avatar minúsculo */}
                                {p.profile_icon ? (
                                  <img
                                    src={`https://ddragon.leagueoflegends.com/cdn/${DDRAGON}/img/profileicon/${p.profile_icon}.png`}
                                    alt={p.summoner_name}
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
                                  {p.summoner_name}
                                  <span className="text-gray-600">#{p.tag_line}</span>
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
