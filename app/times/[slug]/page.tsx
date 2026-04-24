import { createClient } from "@/lib/supabase/server";
import { notFound } from "next/navigation";
import Link from "next/link";

const TIER_COLORS: Record<string, string> = {
  CHALLENGER:  "text-yellow-300",
  GRANDMASTER: "text-red-400",
  MASTER:      "text-purple-400",
  DIAMOND:     "text-blue-400",
  EMERALD:     "text-emerald-400",
  PLATINUM:    "text-teal-400",
  GOLD:        "text-yellow-500",
  SILVER:      "text-gray-400",
  BRONZE:      "text-orange-700",
  IRON:        "text-gray-500",
  UNRANKED:    "text-gray-600",
};

export default async function TimeDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  // slug ainda é o UUID do time (busca por id, sem migration teams.slug ainda)
  const { slug } = await params;
  const supabase = await createClient();

  const { data: team } = await supabase
    .from("teams")
    .select("*")
    .eq("id", slug)
    .single();
  if (!team) notFound();

  const { data: players } = await supabase
    .from("players")
    .select("id, summoner_name, tagline, tier, rank, lp, wins, losses")
    .eq("team_id", team.id)
    .order("lp", { ascending: false });

  const { data: matchesA } = await supabase
    .from("matches")
    .select(`
      id, round, status, score_a, score_b, format, scheduled_at, winner_team_id,
      team_a_id, team_b_id,
      team_b:teams!matches_team_b_id_fkey(name, tag),
      tournaments(name, id, slug)
    `)
    .eq("team_a_id", team.id)
    .in("status", ["FINISHED", "IN_PROGRESS", "SCHEDULED"])
    .order("scheduled_at", { ascending: false })
    .limit(20);

  const { data: matchesB } = await supabase
    .from("matches")
    .select(`
      id, round, status, score_a, score_b, format, scheduled_at, winner_team_id,
      team_a_id, team_b_id,
      team_a:teams!matches_team_a_id_fkey(name, tag),
      tournaments(name, id, slug)
    `)
    .eq("team_b_id", team.id)
    .in("status", ["FINISHED", "IN_PROGRESS", "SCHEDULED"])
    .order("scheduled_at", { ascending: false })
    .limit(20);

  const allMatches = [
    ...(matchesA ?? []).map((m) => ({ ...m, side: "A" as const })),
    ...(matchesB ?? []).map((m) => ({ ...m, side: "B" as const })),
  ].sort((a, b) =>
    new Date(b.scheduled_at ?? 0).getTime() - new Date(a.scheduled_at ?? 0).getTime()
  );

  return (
    <div className="max-w-3xl mx-auto space-y-8 p-6">
      <div>
        <h1 className="text-2xl font-bold text-white">
          <span className="text-[#C8A84B]">[{team.tag}]</span> {team.name}
        </h1>
        {team.description && (
          <p className="text-gray-400 text-sm mt-1">{team.description}</p>
        )}
      </div>

      {/* Jogadores */}
      <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-xl p-4">
        <h2 className="text-[#C8A84B] font-bold text-sm mb-3">Jogadores</h2>
        {(players ?? []).length === 0 ? (
          <p className="text-gray-500 text-sm">Sem jogadores vinculados.</p>
        ) : (
          <div className="space-y-2">
            {players?.map((p) => (
              <div key={p.id} className="flex items-center justify-between bg-[#0A1428] rounded p-3">
                <span className="text-white text-sm font-medium">
                  {p.summoner_name}
                  <span className="text-gray-500 text-xs ml-1">#{p.tagline}</span>
                </span>
                <span className={`text-xs font-bold ${TIER_COLORS[p.tier ?? "UNRANKED"] ?? "text-gray-400"}`}>
                  {p.tier ?? "UNRANKED"} {p.rank ?? ""}
                  <span className="text-gray-400 font-normal ml-1">{p.lp ?? 0} LP</span>
                </span>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Partidas recentes */}
      <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-xl p-4">
        <h2 className="text-[#C8A84B] font-bold text-sm mb-3">Partidas Recentes</h2>
        {allMatches.length === 0 ? (
          <p className="text-gray-500 text-sm">Nenhuma partida registrada.</p>
        ) : (
          <div className="space-y-2">
            {allMatches.slice(0, 10).map((m) => {
              const won = m.winner_team_id === team.id;
              const opp = m.side === "A"
                ? (m as any).team_b
                : (m as any).team_a;
              const tourn = (m as any).tournaments;
              return (
                <div key={m.id} className="flex items-center justify-between bg-[#0A1428] rounded p-3 text-sm">
                  <div>
                    <span className={won ? "text-green-400 font-bold" : "text-red-400 font-bold"}>
                      {won ? "Vitória" : "Derrota"}
                    </span>
                    <span className="text-gray-400 ml-2">vs [{opp?.tag}] {opp?.name}</span>
                  </div>
                  <div className="text-right">
                    {/* Link de torneio usa tournaments.slug (disponível na query) */}
                    {tourn?.slug && (
                      <Link href={`/torneios/${tourn.slug}`} className="text-xs text-blue-400 hover:underline">
                        {tourn.name}
                      </Link>
                    )}
                    <p className="text-gray-500 text-xs">
                      {m.score_a} × {m.score_b}
                    </p>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      <Link href="/torneios" className="text-gray-400 hover:text-white text-sm">
        ← Ver Torneios
      </Link>
    </div>
  );
}
