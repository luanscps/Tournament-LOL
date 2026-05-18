import { createAdminClient } from "../supabase/admin";
import { getMatchById, MatchDto } from "../riot";
import { avancarVencedor, calcularPlacar } from "../bracket-utils";

// ─── Interfaces ───────────────────────────────────────────────────────────────

interface RawRiotGameData {
  gameId: number;
  platformId: string;
}

interface NormalizedMatchData {
  tournamentCode: string;
  gameId: number;
  platformId: string;
  rawPayload: RawRiotGameData;
}

interface TournamentCodeEntry {
  game_number: number;
  code: string;
  used: boolean;
  used_at: string | null;
}

interface ResolvedMatchData extends NormalizedMatchData {
  matchId: string;
  matchDetails: MatchDto;
  localMatchId: string;
  /** Número do game dentro da match (1 para Bo1, 1-3 para Bo3, 1-5 para Bo5) */
  gameNumber: number;
  /** Formato máximo da match */
  bestOf: number;
  /** UUID do time A */
  teamAId: string | null;
  /** UUID do time B */
  teamBId: string | null;
}

// ─── Subtarefa 1: Normaliza dados brutos do banco ─────────────────────────────

async function processMatchResult(
  tournamentCode: string,
  gameId: number
): Promise<{ success: true; data: NormalizedMatchData } | { success: false; error: string }> {
  const supabase = createAdminClient();

  const { data, error } = await supabase
    .from("tournament_match_results")
    .select("*")
    .eq("tournament_code", tournamentCode)
    .eq("game_id", gameId)
    .single();

  if (error || !data) {
    console.error(`[IngestMatch] Registro não encontrado: ${tournamentCode} / ${gameId}`);
    return { success: false, error: "Registro não encontrado" };
  }

  if (data.processed) {
    console.warn(`[IngestMatch] Já processado: ${tournamentCode} / ${gameId}`);
    return { success: false, error: "Já processado" };
  }

  const gameData = data.game_data as unknown as RawRiotGameData;
  if (!gameData?.gameId || !gameData?.platformId) {
    return { success: false, error: "Dados brutos inválidos" };
  }

  return {
    success: true,
    data: {
      tournamentCode: data.tournament_code,
      gameId: gameData.gameId,
      platformId: gameData.platformId,
      rawPayload: gameData,
    },
  };
}

// ─── Subtarefa 2: Busca Riot API + resolve match interno ──────────────────────
// Chamada apenas UMA vez por ingestão. Retorna ResolvedMatchData completo.

async function fetchAndResolveMatch(
  tournamentCode: string,
  gameId: number
): Promise<{ success: true; data: ResolvedMatchData } | { success: false; error: string }> {
  const normResult = await processMatchResult(tournamentCode, gameId);
  if (!normResult.success) return { success: false, error: normResult.error };

  const normalized = normResult.data;
  const matchId = `${normalized.platformId}_${normalized.gameId}`.toUpperCase();
  console.log(`[IngestMatch] Buscando Riot API para: ${matchId}`);

  let matchDetails: MatchDto;
  try {
    matchDetails = await getMatchById(matchId);
  } catch (err) {
    console.error(`[IngestMatch] Erro Riot API ${matchId}:`, err);
    return { success: false, error: "Erro ao buscar detalhes do match" };
  }

  const supabase = createAdminClient();

  // Busca match interno incluindo tournament_codes para resolver game_number
  const { data: matchInternal, error: matchError } = await supabase
    .from("matches")
    .select("id, best_of, team_a_id, team_b_id, tournament_codes")
    .eq("tournament_code", tournamentCode)
    .single();

  if (matchError || !matchInternal) {
    console.error(`[IngestMatch] Match interno não encontrado: ${tournamentCode}`);
    return { success: false, error: "Match interno não encontrado" };
  }

  // Resolve game_number via lookup no JSONB de tournament_codes
  const codesArray = (matchInternal.tournament_codes as TournamentCodeEntry[] | null) ?? [];
  const codeEntry  = codesArray.find((e) => e.code === tournamentCode);
  const gameNumber = codeEntry?.game_number ?? 1;

  console.log(
    `[IngestMatch] Match ${matchInternal.id} — game_number: ${gameNumber} / best_of: ${matchInternal.best_of ?? 1}`
  );

  return {
    success: true,
    data: {
      ...normalized,
      matchId,
      matchDetails,
      localMatchId: matchInternal.id,
      gameNumber,
      bestOf:  matchInternal.best_of  ?? 1,
      teamAId: matchInternal.team_a_id ?? null,
      teamBId: matchInternal.team_b_id ?? null,
    },
  };
}

// ─── Subtarefa 3: Persiste em match_games ─────────────────────────────────────

async function persistMatchGame(
  resolved: ResolvedMatchData
): Promise<{ success: true; data: { matchGameId: string } } | { success: false; error: string }> {
  const { matchDetails, localMatchId, gameNumber } = resolved;
  const supabase = createAdminClient();

  const riotGameIdStr = matchDetails.info.gameId.toString();

  const { data: existing } = await supabase
    .from("match_games")
    .select("id")
    .eq("match_id", localMatchId)
    .eq("riot_game_id", riotGameIdStr)
    .maybeSingle();

  if (existing) {
    console.log(`[IngestMatch] match_games já existe (id: ${existing.id}). Pulando.`);
    return { success: true, data: { matchGameId: existing.id } };
  }

  // winner_id por game: determinado pelo campo 'win' dos participantes
  // Resolvemos via teamAId/teamBId após persistir — mantemos null aqui
  // e atualizamos em finalizeMatchIngestion após calcularPlacar
  const { data: inserted, error: insertError } = await supabase
    .from("match_games")
    .insert({
      match_id:     localMatchId,
      game_number:  gameNumber,        // ← dinâmico, não mais hardcoded
      riot_game_id: riotGameIdStr,
      duration_sec: Math.floor(matchDetails.info.gameDuration),
      winner_id:    null,              // preenchido abaixo em finalizeMatchIngestion
    })
    .select("id")
    .single();

  if (insertError) {
    console.error(`[IngestMatch] Erro ao persistir match_games:`, insertError);
    return { success: false, error: insertError.message };
  }

  console.log(`[IngestMatch] match_games criado: ${inserted.id} (game ${gameNumber})`);
  return { success: true, data: { matchGameId: inserted.id } };
}

// ─── Subtarefa 4: Persiste player_stats ───────────────────────────────────────

async function persistPlayerStats(
  resolved: ResolvedMatchData,
  matchGameId: string
): Promise<{
  success: true;
  data: { inserted: number; skipped: number; unresolvedPlayers: string[]; winnerTeamId: string | null };
} | { success: false; error: string }> {
  const { matchDetails, teamAId, teamBId } = resolved;
  const supabase = createAdminClient();

  let insertedCount = 0;
  let skippedCount  = 0;
  const unresolvedPlayers: string[] = [];
  let winnerTeamId: string | null = null;

  for (const participant of matchDetails.info.participants) {
    const puuid = participant.puuid;

    const { data: riotAccount, error: raError } = await supabase
      .from("riot_accounts")
      .select("id, profile_id")
      .eq("puuid", puuid)
      .maybeSingle();

    if (raError || !riotAccount) {
      unresolvedPlayers.push(puuid);
      skippedCount++;
      continue;
    }

    const { data: player, error: playerError } = await supabase
      .from("players")
      .select("id")
      .eq("riot_account_id", riotAccount.id)
      .maybeSingle();

    if (playerError || !player) {
      unresolvedPlayers.push(puuid);
      skippedCount++;
      continue;
    }

    const { data: membership } = await supabase
      .from("team_members")
      .select("team_id")
      .eq("riot_account_id", riotAccount.id)
      .eq("status", "ACCEPTED")
      .maybeSingle();

    const teamId = membership?.team_id ?? null;

    // Identifica o time vencedor deste game pelo campo win=true
    if (participant.win && teamId) {
      if (!winnerTeamId) winnerTeamId = teamId;
    }

    const { data: existingStat } = await supabase
      .from("player_stats")
      .select("id")
      .eq("game_id", matchGameId)
      .eq("player_id", player.id)
      .maybeSingle();

    if (existingStat) {
      skippedCount++;
      continue;
    }

    const { error: insertError } = await supabase
      .from("player_stats")
      .insert({
        game_id:       matchGameId,
        player_id:     player.id,
        team_id:       teamId,
        kills:         participant.kills,
        deaths:        participant.deaths,
        assists:       participant.assists,
        gold_earned:   participant.goldEarned,
        cs:            participant.totalMinionsKilled + (participant.neutralMinionsKilled || 0),
        vision_score:  participant.visionScore,
        damage_dealt:  participant.totalDamageDealtToChampions,
        win:           participant.win,
        champion:      participant.championName,
        game_duration: Math.floor(matchDetails.info.gameDuration),
      });

    if (insertError) {
      skippedCount++;
    } else {
      insertedCount++;
    }
  }

  if (unresolvedPlayers.length > 0) {
    console.warn(
      `[IngestMatch] ${unresolvedPlayers.length} participante(s) não resolvido(s):\n` +
      unresolvedPlayers.map((p) => `  - ${p}`).join("\n")
    );
  }

  return {
    success: true,
    data: { inserted: insertedCount, skipped: skippedCount, unresolvedPlayers, winnerTeamId },
  };
}

// ─── Subtarefa 5: Finalização — ponto de entrada público ──────────────────────

export async function finalizeMatchIngestion(tournamentCode: string, gameId: number) {
  console.log(`[IngestMatch] Iniciando ingestão: ${tournamentCode} / ${gameId}`);

  const resolved = await fetchAndResolveMatch(tournamentCode, gameId);
  if (!resolved.success) return { success: false, error: resolved.error };

  const { localMatchId, bestOf, teamAId, teamBId, gameNumber } = resolved.data;
  const supabase = createAdminClient();

  // ── Subtarefa 3: match_games ──────────────────────────────────────────────
  const gameRes = await persistMatchGame(resolved.data);
  if (!gameRes.success) return { success: false, error: gameRes.error };

  // ── Subtarefa 4: player_stats + detecção de vencedor do game ─────────────
  const statsRes = await persistPlayerStats(resolved.data, gameRes.data.matchGameId);
  if (!statsRes.success) return { success: false, error: statsRes.error };

  // ── Atualiza winner_id no match_game ─────────────────────────────────────
  const gameWinnerId = statsRes.data.winnerTeamId;
  if (gameWinnerId) {
    await supabase
      .from("match_games")
      .update({ winner_id: gameWinnerId })
      .eq("id", gameRes.data.matchGameId);
  }

  // ── Marca tournament_match_result como processado ─────────────────────────
  const { error: procError } = await supabase
    .from("tournament_match_results")
    .update({ processed: true, processing_at: null })
    .eq("tournament_code", tournamentCode)
    .eq("game_id", gameId);

  if (procError) {
    console.error(`[IngestMatch] Erro ao marcar como processado:`, procError);
    return { success: false, error: "Falha ao marcar registro como processado" };
  }

  // ── Lógica de fim de match: wins_needed ───────────────────────────────────
  // Bo1 → 1 vitória encerra | Bo3 → 2 | Bo5 → 3
  const winsNeeded = Math.ceil(bestOf / 2);

  // Conta vitórias acumuladas consultando todos os match_games já persistidos
  const { scoreA, scoreB } = teamAId && teamBId
    ? await calcularPlacar(supabase, localMatchId, teamAId, teamBId)
    : { scoreA: 0, scoreB: 0 };

  console.log(
    `[IngestMatch] Placar após game ${gameNumber}: ${scoreA}-${scoreB} ` +
    `(precisa ${winsNeeded} para vencer, best_of: ${bestOf})`
  );

  const matchWinner =
    scoreA >= winsNeeded ? teamAId
    : scoreB >= winsNeeded ? teamBId
    : null;

  if (matchWinner) {
    // ── Match encerrado: algum time atingiu wins_needed ───────────────────
    const { error: matchError } = await supabase
      .from("matches")
      .update({
        status:      "FINISHED",
        finished_at: new Date().toISOString(),
        winner_id:   matchWinner,
        score_a:     scoreA,
        score_b:     scoreB,
      })
      .eq("id", localMatchId);

    if (matchError) {
      console.error(`[IngestMatch] Erro ao finalizar match:`, matchError);
      return { success: false, error: "Falha ao finalizar status da partida" };
    }

    // Busca match completo para avancarVencedor
    const { data: matchFull } = await supabase
      .from("matches")
      .select("id, round, match_number, tournament_id, best_of")
      .eq("id", localMatchId)
      .single();

    if (matchFull) {
      await avancarVencedor(supabase, matchFull, matchWinner);
      console.log(`[IngestMatch] Vencedor ${matchWinner} avançado para próxima rodada.`);
    }

    console.log(`[IngestMatch] Match FINALIZADO. Placar: ${scoreA}-${scoreB}`);
  } else {
    // ── Match continua: atualiza apenas o placar parcial ─────────────────
    await supabase
      .from("matches")
      .update({
        status:  "IN_PROGRESS",
        score_a: scoreA,
        score_b: scoreB,
      })
      .eq("id", localMatchId);

    console.log(
      `[IngestMatch] Game ${gameNumber} registrado. Match continua: ${scoreA}-${scoreB}. ` +
      `Aguardando game ${gameNumber + 1}.`
    );
  }

  return {
    success: true,
    data: {
      localMatchId,
      matchGameId:       gameRes.data.matchGameId,
      gameNumber,
      bestOf,
      scoreA,
      scoreB,
      matchFinished:     !!matchWinner,
      statsInserted:     statsRes.data.inserted,
      unresolvedPlayers: statsRes.data.unresolvedPlayers,
    },
  };
}
