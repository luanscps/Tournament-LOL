import { createAdminClient } from "@/lib/supabase/admin";
import { notFound } from "next/navigation";
import Link from "next/link";

const DDRAGON = "14.24.1";

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

const ROLE_ORDER: Record<string, number> = {
  TOP: 0, JUNGLE: 1, MID: 2, ADC: 3, SUPPORT: 4,
};

const ROLE_LABELS: Record<string, string> = {
  TOP: "Top", JUNGLE: "Jungle", MID: "Mid", ADC: "ADC", SUPPORT: "Suporte",
};

const ROLE_ICONS: Record<string, string> = {
  TOP: "🛡️", JUNGLE: "🌿", MID: "⚡", ADC: "🏹", SUPPORT: "💊",
};

export default async function TimeDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const admin = createAdminClient();

  // Busca por uuid ou slug
  const isUUID = /^[0-9a-f-]{36}$/.test(slug);
  const { data: team } = isUUID
    ? await admin.from("teams").select("*").eq("id", slug).single()
    : await admin.from("teams").select("*").eq("slug", slug).single();

  if (!team) notFound();

  // ── Jogadores — colunas corretas do schema ──────────────────────────────
  const { data: players } = await admin
    .from("players")
    .select("id, summoner_name, tag_line, tier, rank, lp, wins, losses, role, profile_icon, summoner_level")
    .eq("team_id", team.id)
    .order("lp", { ascending: false });

  const sortedPlayers = (players ?? []).sort(
    (a, b) => (ROLE_ORDER[a.role ?? ""] ?? 99) - (ROLE_ORDER[b.role ?? ""] ?? 99)
  );

  // ── Partidas ────────────────────────────────────────────────────────────
  const [{ data: matchesA }, { data: matchesB }] = await Promise.all([
    admin
      .from("matches")
      .select(`
        id, round, status, score_a, score_b, format, scheduled_at, played_at,
        winner_id, team_a_id, team_b_id,
        team_b:teams!matches_team_b_id_fkey(id, name, tag, logo_url),
        tournament:tournaments!matches_tournament_id_fkey(id, name, slug)
      `)
      .eq("team_a_id", team.id)
      .in("status", ["FINISHED", "IN_PROGRESS", "SCHEDULED"])
      .order("scheduled_at", { ascending: false })
      .limit(30),
    admin
      .from("matches")
      .select(`
        id, round, status, score_a, score_b, format, scheduled_at, played_at,
        winner_id, team_a_id, team_b_id,
        team_a:teams!matches_team_a_id_fkey(id, name, tag, logo_url),
        tournament:tournaments!matches_tournament_id_fkey(id, name, slug)
      `)
      .eq("team_b_id", team.id)
      .in("status", ["FINISHED", "IN_PROGRESS", "SCHEDULED"])
      .order("scheduled_at", { ascending: false })
      .limit(30),
  ]);

  const allMatches = [
    ...(matchesA ?? []).map(m => ({ ...m, side: "A" as const })),
    ...(matchesB ?? []).map(m => ({ ...m, side: "B" as const })),
  ].sort((a, b) =>
    new Date(b.scheduled_at ?? b.played_at ?? 0).getTime() -
    new Date(a.scheduled_at ?? a.played_at ?? 0).getTime()
  );

  const wins   = allMatches.filter(m => m.status === "FINISHED" && m.winner_id === team.id).length;
  const losses = allMatches.filter(m => m.status === "FINISHED" && m.winner_id && m.winner_id !== team.id).length;
  const total  = wins + losses;
  const wr     = total > 0 ? Math.round((wins / total) * 100) : 0;

  // Torneios únicos do histórico
  const tournamentMap: Record<string, any> = {};
  for (const m of allMatches) {
    const t = (m as any).tournament;
    if (t?.id) tournamentMap[t.id] = t;
  }
  const tournamentsParticipated = Object.values(tournamentMap);

  // Torneios ativos (inscrições)
  const { data: activeRegs } = await admin
    .from("inscricoes")
    .select("tournament_id, tournaments!inscricoes_tournament_id_fkey(id, name, slug, status)")
    .eq("team_id", team.id);

  const activeTournaments = (activeRegs ?? [])
    .map((r: any) => r.tournaments)
    .filter(Boolean)
    .filter((t: any) => ["OPEN", "IN_PROGRESS", "CHECKIN"].includes(t.status));

  return (
    <div className="max-w-3xl mx-auto space-y-6 p-4 md:p-6">

      {/* ── Header do Time ─────────────────────────────────────────────── */}
      <div className="card-lol">
        <div className="flex items-start justify-between gap-4">
          <div className="flex-1 min-w-0">
            <p className="text-[#C8A84B] text-xs font-bold uppercase tracking-widest mb-0.5">
              [{team.tag}]
            </p>
            <h1 className="text-2xl font-bold text-white truncate">{team.name}</h1>
            {team.description && (
              <p className="text-gray-400 text-sm mt-1 leading-relaxed">{team.description}</p>
            )}
          </div>
          {team.logo_url ? (
            <img
              src={team.logo_url}
              alt={team.name}
              width={72} height={72}
              className="rounded-xl object-cover flex-shrink-0 border border-[#1E3A5F]"
            />
          ) : (
            <div className="w-16 h-16 bg-[#0A1428] rounded-xl flex items-center justify-center text-3xl border border-[#1E3A5F] flex-shrink-0">
              🛡️
            </div>
          )}
        </div>

        {/* Stats rápidas */}
        <div className="grid grid-cols-4 gap-3 mt-5 pt-4 border-t border-[#1E3A5F]">
          <div className="text-center">
            <p className="text-[#C8A84B] font-bold text-xl">{wins}</p>
            <p className="text-gray-600 text-xs mt-0.5">Vitórias</p>
          </div>
          <div className="text-center">
            <p className="text-red-400 font-bold text-xl">{losses}</p>
            <p className="text-gray-600 text-xs mt-0.5">Derrotas</p>
          </div>
          <div className="text-center">
            <p className={`font-bold text-xl ${wr >= 50 ? "text-green-400" : "text-red-400"}`}>
              {wr}%
            </p>
            <p className="text-gray-600 text-xs mt-0.5">Winrate</p>
          </div>
          <div className="text-center">
            <p className="text-white font-bold text-xl">{(players ?? []).length}/5</p>
            <p className="text-gray-600 text-xs mt-0.5">Jogadores</p>
          </div>
        </div>
      </div>

      {/* ── Torneios Ativos ─────────────────────────────────────────────── */}
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

      {/* ── Roster ──────────────────────────────────────────────────────── */}
      <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-xl p-4">
        <h2 className="text-[#C8A84B] font-bold text-sm mb-3">
          👥 Roster ({sortedPlayers.length}/5)
        </h2>

        {sortedPlayers.length === 0 ? (
          <p className="text-gray-500 text-sm py-6 text-center">Sem jogadores vinculados.</p>
        ) : (
          <div className="space-y-2">
            {sortedPlayers.map(p => {
              const gamesPlayed = (p.wins ?? 0) + (p.losses ?? 0);
              const playerWr = gamesPlayed > 0
                ? Math.round(((p.wins ?? 0) / gamesPlayed) * 100)
                : 0;
              // profile_icon → Data Dragon (coluna real no banco)
              const iconUrl = p.profile_icon
                ? `https://ddragon.leagueoflegends.com/cdn/${DDRAGON}/img/profileicon/${p.profile_icon}.png`
                : null;

              return (
                <div key={p.id} className="flex items-center gap-3 bg-[#0A1428] rounded-xl p-3">
                  {/* Role */}
                  <span className="text-xl w-7 text-center flex-shrink-0" title={ROLE_LABELS[p.role ?? ""] ?? ""}>
                    {ROLE_ICONS[p.role ?? ""] ?? "❓"}
                  </span>

                  {/* Avatar */}
                  {iconUrl ? (
                    <img
                      src={iconUrl}
                      alt="ícone"
                      width={40} height={40}
                      loading="lazy"
                      className="rounded-full border border-[#1E3A5F] w-10 h-10 flex-shrink-0"
                    />
                  ) : (
                    <div className="w-10 h-10 rounded-full bg-[#0D1B2E] border border-[#1E3A5F] flex items-center justify-center flex-shrink-0">
                      {TIER_ICONS[p.tier ?? "UNRANKED"] ?? "❓"}
                    </div>
                  )}

                  {/* Info */}
                  <div className="flex-1 min-w-0">
                    <p className="text-white text-sm font-semibold truncate">
                      {p.summoner_name}
                      {/* tag_line — coluna real correta */}
                      <span className="text-gray-600 font-normal text-xs">#{p.tag_line}</span>
                    </p>
                    <p className="text-gray-500 text-xs">
                      {p.role ? ROLE_LABELS[p.role] : "—"}
                      {p.summoner_level ? ` · Nível ${p.summoner_level}` : ""}
                    </p>
                  </div>

                  {/* Rank */}
                  <div className="text-right flex-shrink-0">
                    <p className={`text-xs font-bold ${TIER_COLORS[p.tier ?? "UNRANKED"] ?? "text-gray-400"}`}>
                      {p.tier === "UNRANKED" || !p.tier
                        ? "Unranked"
                        : `${p.tier} ${p.rank ?? ""}`}
                    </p>
                    <p className="text-gray-600 text-xs">
                      {p.lp ?? 0} LP
                      {gamesPlayed > 0 && ` · ${playerWr}% WR`}
                    </p>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* ── Partidas Recentes ────────────────────────────────────────────── */}
      <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-xl p-4">
        <h2 className="text-[#C8A84B] font-bold text-sm mb-3">⚔️ Partidas Recentes</h2>
        {allMatches.length === 0 ? (
          <p className="text-gray-500 text-sm py-6 text-center">Nenhuma partida registrada.</p>
        ) : (
          <div className="space-y-2">
            {allMatches.slice(0, 10).map(m => {
              const isFinished = m.status === "FINISHED";
              const won  = isFinished && m.winner_id === team.id;
              const lost = isFinished && m.winner_id && m.winner_id !== team.id;
              const opp  = m.side === "A" ? (m as any).team_b : (m as any).team_a;
              const tourn = (m as any).tournament;
              const scoreA = m.side === "A" ? m.score_a : m.score_b;
              const scoreB = m.side === "A" ? m.score_b : m.score_a;
              const dateStr = m.played_at ?? m.scheduled_at;

              return (
                <div
                  key={m.id}
                  className={`flex items-center justify-between rounded-xl p-3 text-sm border-l-2 ${
                    won  ? "bg-green-500/5 border-green-500" :
                    lost ? "bg-red-500/5 border-red-500" :
                           "bg-[#0A1428] border-gray-700"
                  }`}
                >
                  <div className="min-w-0">
                    <div className="flex items-center gap-2">
                      <span className={`font-bold text-xs w-4 ${won ? "text-green-400" : lost ? "text-red-400" : "text-gray-400"}`}>
                        {won ? "V" : lost ? "D" : "—"}
                      </span>
                      <span className="text-gray-300 truncate">
                        vs{" "}
                        {opp ? (
                          <span className="text-white font-medium">[{opp.tag}] {opp.name}</span>
                        ) : (
                          <span className="text-gray-500">Adversário</span>
                        )}
                      </span>
                    </div>
                    {dateStr && (
                      <p className="text-gray-600 text-xs mt-0.5 ml-6">
                        {new Date(dateStr).toLocaleDateString("pt-BR")}
                        {m.round ? ` · ${m.round}` : ""}
                      </p>
                    )}
                  </div>
                  <div className="text-right flex-shrink-0 ml-3">
                    {isFinished && (
                      <p className="text-white font-bold text-sm">
                        {scoreA ?? 0} × {scoreB ?? 0}
                      </p>
                    )}
                    {tourn?.slug ? (
                      <Link href={`/torneios/${tourn.slug}`} className="text-xs text-blue-400 hover:underline">
                        {tourn.name}
                      </Link>
                    ) : (
                      <span className="text-gray-700 text-xs">
                        {m.format ? `Best of ${m.format.replace("BO","")}` : ""}
                      </span>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* ── Histórico de Torneios ───────────────────────────────────────── */}
      {tournamentsParticipated.length > 0 && (
        <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-xl p-4">
          <h2 className="text-[#C8A84B] font-bold text-sm mb-3">📋 Histórico de Torneios</h2>
          <div className="space-y-1">
            {tournamentsParticipated.map((t: any) => (
              <Link
                key={t.id}
                href={`/torneios/${t.slug}`}
                className="flex items-center justify-between bg-[#0A1428] rounded-lg p-2.5 text-sm hover:bg-[#131f30] transition-colors"
              >
                <span className="text-gray-300">{t.name}</span>
                <span className="text-gray-600 text-xs">Ver →</span>
              </Link>
            ))}
          </div>
        </div>
      )}

      {/* ── Navegação ───────────────────────────────────────────────────── */}
      <div className="flex items-center justify-between pt-2">
        <Link href="/times" className="text-gray-500 hover:text-white text-sm transition-colors">
          ← Ver Todos os Times
        </Link>
        <Link
          href="/dashboard/times/criar"
          className="text-[#C8A84B] hover:text-[#d4b55a] text-sm transition-colors"
        >
          + Criar Time
        </Link>
      </div>

    </div>
  );
}
