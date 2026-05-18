/**
 * lib/bracket-utils.ts
 *
 * Utilitários de bracket compartilhados entre:
 *  - lib/actions/partida.ts  (resultado manual pelo organizador)
 *  - lib/actions/ingest-match.ts (resultado automático via Riot callback)
 *
 * Exportado como módulo puro (sem "use server") para ser importável
 * tanto em Server Actions quanto em funções de ingestão.
 */

// ── Tipos mínimos necessários ─────────────────────────────────────────────────

export interface MatchForBracket {
  id: string;
  round: number;
  match_number: number;
  tournament_id: string;
  best_of: number | null;
}

// ── avancarVencedor ───────────────────────────────────────────────────────────
/**
 * Avança o vencedor de uma partida para o slot correto na próxima rodada
 * do bracket eliminatório simples.
 *
 * Lógica:
 *  - próximo round  = match.round + 1
 *  - próximo slot   = Math.ceil(match.match_number / 2)
 *  - se slot A já preenchido → preenche slot B
 *  - se a próxima partida ainda não existe → cria com best_of herdado
 *
 * @param supabase  cliente Supabase com permissão de escrita (service role ou RLS ok)
 * @param match     dados da partida que acabou de ser finalizada
 * @param winnerId  UUID do time vencedor
 */
export async function avancarVencedor(
  supabase: any,
  match: MatchForBracket,
  winnerId: string
): Promise<void> {
  const proximoRound      = match.round + 1;
  const proximaPartidaNum = Math.ceil(match.match_number / 2);

  const { data: proximaPartida } = await supabase
    .from("matches")
    .select("id, team_a_id, team_b_id")
    .eq("tournament_id", match.tournament_id)
    .eq("round", proximoRound)
    .eq("match_number", proximaPartidaNum)
    .maybeSingle();

  if (proximaPartida) {
    // Partida já existe: preenche o slot vazio
    const update =
      proximaPartida.team_a_id == null
        ? { team_a_id: winnerId }
        : { team_b_id: winnerId };
    await supabase
      .from("matches")
      .update(update)
      .eq("id", proximaPartida.id);
  } else {
    // Partida ainda não existe: cria com best_of herdado
    const isSlotA = match.match_number % 2 !== 0;
    await supabase.from("matches").insert({
      tournament_id: match.tournament_id,
      team_a_id:     isSlotA ? winnerId : null,
      team_b_id:     isSlotA ? null : winnerId,
      round:         proximoRound,
      match_number:  proximaPartidaNum,
      best_of:       match.best_of ?? 1,
      status:        "SCHEDULED",
    });
  }
}

// ── calcularPlacar ────────────────────────────────────────────────────────────
/**
 * Conta as vitórias de cada time a partir dos match_games já persistidos.
 *
 * @param supabase   cliente Supabase
 * @param matchId    UUID do match interno
 * @param teamAId    UUID do time A
 * @param teamBId    UUID do time B
 * @returns { scoreA, scoreB }
 */
export async function calcularPlacar(
  supabase: any,
  matchId: string,
  teamAId: string,
  teamBId: string
): Promise<{ scoreA: number; scoreB: number }> {
  const { data: games } = await supabase
    .from("match_games")
    .select("winner_id")
    .eq("match_id", matchId);

  const gamesArray = games ?? [];
  const scoreA = gamesArray.filter((g: any) => g.winner_id === teamAId).length;
  const scoreB = gamesArray.filter((g: any) => g.winner_id === teamBId).length;

  return { scoreA, scoreB };
}
