import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
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

const TIER_ICONS: Record<string, string> = {
  CHALLENGER: "🏅", GRANDMASTER: "💠", MASTER: "💜",
  DIAMOND: "💎", EMERALD: "💚", PLATINUM: "🩵",
  GOLD: "🥇", SILVER: "🥈", BRONZE: "🥉", IRON: "⚫", UNRANKED: "❓",
};

export default async function TimeDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const admin = createAdminClient();

  // Busca por id ou por slug
  const isUUID = /^[0-9a-f-]{36}$/.test(slug);
  const { data: team } = isUUID
    ? await admin.from("teams").select("*").eq("id", slug).single()
    : await admin.from("teams").select("*").eq("slug", slug).single();

  if (!team) notFound();

  // Jogadores com conta Riot
  const { data: players } = await admin
    .from("players")
    .select("id, summoner_name, tagline, tier, rank, lp, wins, losses, role")
    .eq("team_id", team.id)
    .order("lp", { ascending: false });

  // Partidas onde o time participou
  const [{ data: matchesA }, { data: matchesB }] = await Promise.all([
    admin
      .from("matches")
      .select("id, round, status, score_a, score_b, format, scheduled_at, winner_team_id, team_a_id, team_b_id, team_b:teams!matches_team_b_id_fkey(name, tag), tournament:tournaments(name, id, slug)")
      .eq("team_a_id", team.id)
      .in("status", ["FINISHED", "IN_PROGRESS", "SCHEDULED"])
      .order("scheduled_at", { ascending: false })
      .limit(30),
    admin
      .from("matches")
      .select("id, round, status, score_a, score_b, format, scheduled_at, winner_team_id, team_a_id, team_b_id, team_a:teams!matches_team_a_id_fkey(name, tag), tournament:tournaments(name, id, slug)")
      .eq("team_b_id", team.id)
      .in("status", ["FINISHED", "IN_PROGRESS", "SCHEDULED"])
      .order("scheduled_at", { ascending: false })
      .limit(30),
  ]);

  const allMatches = [
    ...(matchesA ?? []).map(m => ({ ...m, side: "A" as const })),
    ...(matchesB ?? []).map(m => ({ ...m, side: "B" as const })),
  ].sort((a, b) =>
    new Date(b.scheduled_at ?? 0).getTime() - new Date(a.scheduled_at ?? 0).getTime()
  );

  const wins   = allMatches.filter(m => m.status === "FINISHED" && m.winner_team_id === team.id).length;
  const losses = allMatches.filter(m => m.status === "FINISHED" && m.winner_team_id && m.winner_team_id !== team.id).length;
  const total  = wins + losses;
  const wr     = total > 0 ? Math.round((wins / total) * 100) : 0;

  // Torneios participados (únicos)
  const tournamentMap: Record<string, any> = {};
  for (const m of allMatches) {
    const t = (m as any).tournament;
    if (t?.id) tournamentMap[t.id] = t;
  }
  const tournamentsParticipated = Object.values(tournamentMap);

  // Inscrições ativas
  const { data: activeRegs } = await admin
    .from("tournament_registrations")
    .select("tournament_id, tournaments(id, name, slug, status)")
    .eq("team_id", team.id);

  const activeTournaments = (activeRegs ?? [])
    .map((r: any) => r.tournaments)
    .filter(Boolean)
    .filter((t: any) => ["OPEN", "IN_PROGRESS", "CHECKIN"].includes(t.status));

  return (
    <div className="max-w-3xl mx-auto space-y-6 p-4 md:p-6">

      {/* Header */}
      <div className="card-lol">
        <div className="flex items-start justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold text-white">
              <span className="text-[#C8A84B]">[{team.tag}]</span> {team.name}
            </h1>
            {team.description && (
              <p className="text-gray-400 text-sm mt-1">{team.description}</p>
            )}
          </div>
          {team.logo_url && (
            <img src={team.logo_url} alt={team.name} width={64} height={64}
              className="rounded-lg object-cover flex-shrink-0" />
          )}
        </div>

        {/* Stats */}
        <div className="grid grid-cols-3 gap-4 mt-5 pt-4 border-t border-[#1E3A5F]">
          <div className="text-center">
            <p className="text-[#C8A84B] font-bold text-xl">{wins}</p>
            <p className="text-gray-500 text-xs mt-0.5">Vitórias</p>
          </div>
          <div className="text-center">
            <p className="text-red-400 font-bold text-xl">{losses}</p>
            <p className="text-gray-500 text-xs mt-0.5">Derrotas</p>
          </div>
          <div className="text-center">
            <p className={`font-bold text-xl ${wr >= 50 ? "text-green-400" : "text-red-400"}`}>{wr}%</p>
            <p className="text-gray-500 text-xs mt-0.5">Winrate</p>
          </div>
        </div>
      </div>

      {/* Torneios ativos */}
      {activeTournaments.length > 0 && (
        <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-xl p-4">
          <h2 className="text-[#C8A84B] font-bold text-sm mb-3">🏆 Torneios Ativos</h2>
          <div className="flex flex-wrap gap-2">
            {activeTournaments.map((t: any) => (
              <Link
                key={t.id}
                href={`/torneios/${t.slug}`}
                className="bg-[#0A1428] border border-[#C8A84B]/20 hover:border-[#C8A84B]/50 text-[#C8A84B] text-xs rounded-lg px-3 py-1.5 transition-colors"
              >
                {t.name}
              </Link>
            ))}
          </div>
        </div>
      )}

      {/* Jogadores */}
      <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-xl p-4">
        <h2 className="text-[#C8A84B] font-bold text-sm mb-3">👥 Jogadores ({(players ?? []).length}/5)</h2>
        {(players ?? []).length === 0 ? (
          <p className="text-gray-500 text-sm py-4 text-center">Sem jogadores vinculados.</p>
        ) : (
          <div className="space-y-2">
            {players?.map(p => {
              const gamesPlayed = (p.wins ?? 0) + (p.losses ?? 0);
              const playerWr = gamesPlayed > 0 ? Math.round(((p.wins ?? 0) / gamesPlayed) * 100) : 0;
              return (
                <div key={p.id} className="flex items-center justify-between bg-[#0A1428] rounded-lg p-3">
                  <div className="flex items-center gap-3">
                    <span className="text-lg">{TIER_ICONS[p.tier ?? "UNRANKED"] ?? "❓"}</span>
                    <div>
                      <p className="text-white text-sm font-medium">
                        {p.summoner_name}
                        <span className="text-gray-500 text-xs ml-1">#{p.tagline}</span>
                      </p>
                      {p.role && <p className="text-gray-500 text-xs capitalize">{p.role}</p>}
                    </div>
                  </div>
                  <div className="text-right">
                    <p className={`text-xs font-bold ${TIER_COLORS[p.tier ?? "UNRANKED"] ?? "text-gray-400"}`}>
                      {p.tier ?? "UNRANKED"} {p.rank ?? ""}
                    </p>
                    <p className="text-gray-500 text-xs">
                      {p.lp ?? 0} LP · {playerWr}% WR
                    </p>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Partidas recentes */}
      <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-xl p-4">
        <h2 className="text-[#C8A84B] font-bold text-sm mb-3">⚔️ Partidas Recentes</h2>
        {allMatches.length === 0 ? (
          <p className="text-gray-500 text-sm py-4 text-center">Nenhuma partida registrada.</p>
        ) : (
          <div className="space-y-2">
            {allMatches.slice(0, 10).map(m => {
              const isFinished = m.status === "FINISHED";
              const won = isFinished && m.winner_team_id === team.id;
              const lost = isFinished && m.winner_team_id && m.winner_team_id !== team.id;
              const opp = m.side === "A" ? (m as any).team_b : (m as any).team_a;
              const tourn = (m as any).tournament;
              const scoreA = m.side === "A" ? m.score_a : m.score_b;
              const scoreB = m.side === "A" ? m.score_b : m.score_a;
              return (
                <div key={m.id}
                  className={`flex items-center justify-between rounded-lg p-3 text-sm border-l-2 ${
                    won  ? "bg-green-500/5 border-green-500" :
                    lost ? "bg-red-500/5 border-red-500" :
                           "bg-[#0A1428] border-gray-700"
                  }`}
                >
                  <div>
                    <span className={`font-bold mr-2 ${
                      won ? "text-green-400" : lost ? "text-red-400" : "text-gray-400"
                    }`}>
                      {won ? "V" : lost ? "D" : "—"}
                    </span>
                    <span className="text-gray-300">
                      vs{" "}
                      {opp ? (
                        <span className="text-white font-medium">[{opp.tag}] {opp.name}</span>
                      ) : (
                        <span className="text-gray-500">Adversário?</span>
                      )}
                    </span>
                    {m.scheduled_at && (
                      <p className="text-gray-600 text-xs mt-0.5">
                        {new Date(m.scheduled_at).toLocaleDateString("pt-BR")}
                      </p>
                    )}
                  </div>
                  <div className="text-right">
                    {isFinished && (
                      <p className="text-white font-bold text-sm">{scoreA} × {scoreB}</p>
                    )}
                    {tourn?.slug ? (
                      <Link href={`/torneios/${tourn.slug}`} className="text-xs text-blue-400 hover:underline">
                        {tourn.name}
                      </Link>
                    ) : (
                      <span className="text-xs text-gray-600">{m.round ?? ""}</span>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Torneios histórico */}
      {tournamentsParticipated.length > 0 && (
        <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-xl p-4">
          <h2 className="text-[#C8A84B] font-bold text-sm mb-3">📋 Histórico de Torneios</h2>
          <div className="space-y-1">
            {tournamentsParticipated.map((t: any) => (
              <Link
                key={t.id}
                href={`/torneios/${t.slug}`}
                className="flex items-center justify-between bg-[#0A1428] rounded p-2 text-sm hover:bg-[#0D1B2E] transition-colors"
              >
                <span className="text-gray-300">{t.name}</span>
                <span className="text-gray-500 text-xs">Ver torneio →</span>
              </Link>
            ))}
          </div>
        </div>
      )}

      <Link href="/torneios" className="text-gray-400 hover:text-white text-sm inline-block">
        ← Ver Torneios
      </Link>
    </div>
  );
}
