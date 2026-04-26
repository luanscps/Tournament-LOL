import { createAdminClient } from "@/lib/supabase/admin";
import Link from "next/link";

export const dynamic = "force-dynamic";

const ROLE_LABELS: Record<string, string> = {
  TOP: "Top",
  JUNGLE: "Jungle",
  MID: "Mid",
  ADC: "ADC",
  SUPPORT: "Suporte",
};

const ROLE_ICONS: Record<string, string> = {
  TOP: "🛡️",
  JUNGLE: "🌿",
  MID: "⚡",
  ADC: "🏹",
  SUPPORT: "💊",
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

export default async function TimesPage() {
  const admin = createAdminClient();

  const { data: teams, error } = await admin
    .from("teams")
    .select(
      `id, name, tag, slug, logo_url,
       players:players(id, summoner_name, tag_line, role, tier, rank, lp)`
    )
    .order("name");

  if (error) {
    console.error("[TimesPage] erro ao buscar times:", error.message);
  }

  const ROLES = ["TOP", "JUNGLE", "MID", "ADC", "SUPPORT"];

  return (
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

      {/* Lista vazia */}
      {(!teams || teams.length === 0) && (
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

      {/* Grid de times */}
      {teams && teams.length > 0 && (
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {teams.map((team) => {
            const players = (team.players ?? []) as any[];
            const byRole = (role: string) =>
              players.find((p: any) => p.role === role) ?? null;

            return (
              <Link
                key={team.id}
                href={`/times/${team.slug ?? team.id}`}
                className="bg-[#0D1B2E] border border-[#1E3A5F] hover:border-[#C8A84B]/50
                           rounded-xl p-4 transition-all hover:shadow-lg hover:-translate-y-0.5 group block"
              >
                {/* Header do time */}
                <div className="flex items-center gap-3 mb-4">
                  {team.logo_url ? (
                    <img
                      src={team.logo_url}
                      alt={team.name}
                      width={48}
                      height={48}
                      loading="lazy"
                      className="rounded-lg object-cover w-12 h-12 flex-shrink-0"
                    />
                  ) : (
                    <div className="w-12 h-12 bg-[#0A1428] rounded-lg flex items-center justify-center text-xl flex-shrink-0 border border-[#1E3A5F]">
                      🛡️
                    </div>
                  )}
                  <div className="min-w-0">
                    <p className="text-[#C8A84B] font-bold text-xs uppercase tracking-widest">
                      [{team.tag}]
                    </p>
                    <h2 className="text-white font-bold text-sm truncate group-hover:text-[#C8A84B] transition-colors">
                      {team.name}
                    </h2>
                    <p className="text-gray-600 text-xs">
                      {players.length}/5 jogadores
                    </p>
                  </div>
                </div>

                {/* Divisor */}
                <div className="border-t border-[#1E3A5F] mb-3" />

                {/* Roster por role */}
                <div className="space-y-1.5">
                  {ROLES.map((role) => {
                    const p = byRole(role);
                    const tierColor =
                      TIER_COLORS[p?.tier ?? "UNRANKED"] ?? TIER_COLORS.UNRANKED;

                    return (
                      <div key={role} className="flex items-center gap-2 text-xs">
                        <span className="w-4 text-center text-base leading-none">
                          {ROLE_ICONS[role]}
                        </span>
                        <span className="text-gray-600 w-14 shrink-0">
                          {ROLE_LABELS[role]}
                        </span>
                        {p ? (
                          <span className="text-gray-300 truncate flex items-center gap-1 min-w-0">
                            <span
                              className="w-1.5 h-1.5 rounded-full flex-shrink-0"
                              style={{ background: tierColor }}
                            />
                            <span className="truncate">
                              {p.summoner_name}
                              <span className="text-gray-600">#{p.tag_line}</span>
                            </span>
                          </span>
                        ) : (
                          <span className="text-gray-700 italic">Vaga em aberto</span>
                        )}
                      </div>
                    );
                  })}
                </div>
              </Link>
            );
          })}
        </div>
      )}
    </div>
  );
}
