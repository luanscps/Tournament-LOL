"use server";
import { requireTournamentOrganizerOrAdmin } from '@/lib/supabase/permissions';
import { revalidatePath } from "next/cache";
import { z } from "zod";
import { avancarVencedor } from "@/lib/bracket-utils";

const ResultSchema = z.object({
  winner_team_id: z.string().uuid(),
  score_a:        z.coerce.number().min(0),
  score_b:        z.coerce.number().min(0),
  match_id_riot:  z.string().optional(),
});

const CreatePartidaSchema = z.object({
  team_a_id:    z.string().uuid(),
  team_b_id:    z.string().uuid(),
  round:        z.coerce.number().min(1),
  match_number: z.coerce.number().min(1),
  scheduled_at: z.string().optional(),
  fase_id:      z.string().uuid().optional(),
  best_of:      z.coerce.number().min(1).max(7).default(1),
});

export async function editarResultadoPartida(
  matchDbId: string,
  tournamentId: string,
  formData: FormData
) {
  return updateResultadoPartida(matchDbId, tournamentId, formData);
}

export async function updateResultadoPartida(
  matchDbId: string,
  tournamentId: string,
  formData: FormData
) {
  try {
    const { supabase } = await requireTournamentOrganizerOrAdmin(tournamentId);

    const parsed = ResultSchema.safeParse(Object.fromEntries(formData));
    if (!parsed.success) return { error: parsed.error.errors[0].message };

    const { score_a, score_b, winner_team_id, match_id_riot } = parsed.data;

    const { data: match, error: errMatch } = await supabase
      .from("matches")
      .select("id, round, match_number, tournament_id, best_of, team_a_id, team_b_id")
      .eq("id", matchDbId)
      .single();

    if (errMatch || !match) return { error: "Partida não encontrada" };

    const { error } = await supabase
      .from("matches")
      .update({
        winner_id:     winner_team_id,
        score_a,
        score_b,
        riot_match_id: match_id_riot ?? null,
        status:        "FINISHED",
        finished_at:   new Date().toISOString(),
      })
      .eq("id", matchDbId);

    if (error) return { error: error.message };

    // Avança vencedor para próxima rodada (bracket-utils compartilhado)
    await avancarVencedor(supabase, match, winner_team_id);

    // picks_bans: campo JSONB dentro de match_games
    const picksBansRaw = formData.get("picks_bans");
    if (picksBansRaw) {
      try {
        const picksBans = JSON.parse(picksBansRaw as string);
        if (Array.isArray(picksBans) && picksBans.length > 0) {
          const enriched = picksBans
            .filter((pb: any) => pb.champion)
            .map((pb: any) => ({
              ...pb,
              team_id: pb.team === "A" ? match.team_a_id : match.team_b_id,
            }));

          if (enriched.length > 0) {
            const { data: existingGame } = await supabase
              .from("match_games")
              .select("id")
              .eq("match_id", matchDbId)
              .eq("game_number", 1)
              .maybeSingle();

            if (existingGame) {
              await supabase
                .from("match_games")
                .update({ picks_bans: enriched })
                .eq("id", existingGame.id);
            } else {
              await supabase.from("match_games").insert({
                match_id:    matchDbId,
                game_number: 1,
                picks_bans:  enriched,
              });
            }
          }
        }
      } catch (_) { /* ignora erro de parse de picks_bans */ }
    }

    const { data: torneio } = await supabase
      .from("tournaments")
      .select("slug")
      .eq("id", tournamentId)
      .single();

    const slug = torneio?.slug ?? tournamentId;
    revalidatePath(`/organizador/torneios/${slug}/partidas`);
    revalidatePath(`/admin/torneios/${slug}/partidas`);
    revalidatePath(`/torneios/${slug}/bracket`);
    revalidatePath(`/torneios/${slug}`);
    revalidatePath(`/torneios`);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

export async function createPartida(
  tournamentId: string,
  formData: FormData
) {
  try {
    const { supabase } = await requireTournamentOrganizerOrAdmin(tournamentId);

    const parsed = CreatePartidaSchema.safeParse(Object.fromEntries(formData));
    if (!parsed.success) return { error: parsed.error.errors[0].message };

    if (parsed.data.team_a_id === parsed.data.team_b_id) {
      return { error: "Os dois times precisam ser diferentes" };
    }

    const { data, error } = await supabase
      .from("matches")
      .insert({
        tournament_id: tournamentId,
        team_a_id:     parsed.data.team_a_id,
        team_b_id:     parsed.data.team_b_id,
        round:         parsed.data.round,
        match_number:  parsed.data.match_number,
        best_of:       parsed.data.best_of,
        stage_id:      parsed.data.fase_id ?? null,
        scheduled_at:  parsed.data.scheduled_at ?? null,
        status:        "SCHEDULED",
      })
      .select()
      .single();

    if (error) return { error: error.message };

    const { data: torneio } = await supabase
      .from("tournaments")
      .select("slug")
      .eq("id", tournamentId)
      .single();
    const slug = torneio?.slug ?? tournamentId;
    revalidatePath(`/organizador/torneios/${slug}/partidas`);
    revalidatePath(`/admin/torneios/${slug}/partidas`);
    return { success: true, data };
  } catch (e: any) {
    return { error: e.message };
  }
}

export async function deletePartida(matchId: string, tournamentId: string) {
  try {
    const { supabase } = await requireTournamentOrganizerOrAdmin(tournamentId);

    const { data: match } = await supabase
      .from("matches")
      .select("status")
      .eq("id", matchId)
      .single();

    if (match?.status === "FINISHED") {
      return { error: "Não é possível excluir uma partida já finalizada" };
    }

    const { error } = await supabase.from("matches").delete().eq("id", matchId);
    if (error) return { error: error.message };

    const { data: torneio } = await supabase
      .from("tournaments")
      .select("slug")
      .eq("id", tournamentId)
      .single();
    const slug = torneio?.slug ?? tournamentId;
    revalidatePath(`/organizador/torneios/${slug}/partidas`);
    revalidatePath(`/admin/torneios/${slug}/partidas`);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

export async function getPartidasByTorneio(tournamentId: string) {
  const { supabase } = await requireTournamentOrganizerOrAdmin(tournamentId);
  const { data, error } = await supabase
    .from("matches")
    .select(
      `id, round, match_number, status, score_a, score_b, scheduled_at, finished_at, best_of, stage_id,
       team_a:teams!team_a_id(id, name, tag, logo_url),
       team_b:teams!team_b_id(id, name, tag, logo_url),
       winner:teams!winner_id(id, name, tag)`
    )
    .eq("tournament_id", tournamentId)
    .order("round")
    .order("match_number");
  if (error) return { error: error.message, data: null };
  return { data, error: null };
}

export async function gerarChaveamento(tournamentId: string, faseId?: string) {
  try {
    const { supabase } = await requireTournamentOrganizerOrAdmin(tournamentId);

    // Lê best_of da fase se faseId fornecido — suporta Bo1/Bo3/Bo5 por fase
    let stageBestOf = 1;
    if (faseId) {
      const { data: stage } = await supabase
        .from("tournament_stages")
        .select("best_of")
        .eq("id", faseId)
        .single();
      stageBestOf = stage?.best_of ?? 1;
    }

    const { data: inscricoes, error: errInsc } = await supabase
      .from("inscricoes")
      .select("team_id, teams(id, name, tag)")
      .eq("tournament_id", tournamentId)
      .eq("status", "APPROVED");

    if (errInsc) return { error: errInsc.message };
    if (!inscricoes || inscricoes.length < 2) {
      return { error: "É necessário pelo menos 2 times aprovados para gerar o chaveamento" };
    }

    const times    = [...inscricoes].sort(() => Math.random() - 0.5);
    const nextPow2 = Math.pow(2, Math.ceil(Math.log2(times.length)));
    const partidas: any[] = [];

    for (let i = 0; i < nextPow2 / 2; i++) {
      const timeA = times[i * 2];
      const timeB = times[i * 2 + 1];
      if (!timeA || !timeB) continue;
      partidas.push({
        tournament_id: tournamentId,
        team_a_id:     timeA.team_id,
        team_b_id:     timeB.team_id,
        round:         1,
        match_number:  i + 1,
        best_of:       stageBestOf,   // ← dinâmico: lido da fase
        stage_id:      faseId ?? null,
        status:        "SCHEDULED",
      });
    }

    const { data: inserted, error: errIns } = await supabase
      .from("matches")
      .insert(partidas)
      .select();

    if (errIns) return { error: errIns.message };

    const { data: torneio } = await supabase
      .from("tournaments")
      .select("slug")
      .eq("id", tournamentId)
      .single();
    const slug = torneio?.slug ?? tournamentId;
    revalidatePath(`/organizador/torneios/${slug}/partidas`);
    revalidatePath(`/admin/torneios/${slug}/partidas`);
    revalidatePath(`/torneios/${slug}/bracket`);
    revalidatePath(`/torneios`);
    return { success: true, data: inserted };
  } catch (e: any) {
    return { error: e.message };
  }
}
