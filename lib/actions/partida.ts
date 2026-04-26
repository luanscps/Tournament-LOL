"use server";
import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";
import { z } from "zod";

const ResultSchema = z.object({
  winner_team_id: z.string().uuid(),
  score_a: z.coerce.number().min(0),
  score_b: z.coerce.number().min(0),
  match_id_riot: z.string().optional(),
});

const CreatePartidaSchema = z.object({
  team_a_id: z.string().uuid(),
  team_b_id: z.string().uuid(),
  round: z.coerce.number().min(1),
  match_number: z.coerce.number().min(1),
  scheduled_at: z.string().optional(),
  fase_id: z.string().uuid().optional(),
  best_of: z.coerce.number().min(1).max(7).default(1),
});

async function requireOrgOrAdmin(supabase: any, tornId: string, userId: string) {
  const { data: profile } = await supabase
    .from("profiles")
    .select("is_admin")
    .eq("id", userId)
    .single();
  if (profile?.is_admin) return true;
  const { data: torneio } = await supabase
    .from("tournaments")
    .select("organizer_id")
    .eq("id", tornId)
    .single();
  if (torneio?.organizer_id !== userId) throw new Error("Sem permissão");
  return true;
}

// Mantém compatibilidade com código admin existente
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
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: "Não autenticado" };
    await requireOrgOrAdmin(supabase, tournamentId, user.id);

    const parsed = ResultSchema.safeParse(Object.fromEntries(formData));
    if (!parsed.success) return { error: parsed.error.errors[0].message };

    const { score_a, score_b, winner_team_id, match_id_riot } = parsed.data;

    const { error } = await supabase
      .from("matches")
      .update({
        winner_id: winner_team_id,
        score_a,
        score_b,
        match_id_riot: match_id_riot ?? null,
        status: "finished",
        finished_at: new Date().toISOString(),
      })
      .eq("id", matchDbId);

    if (error) return { error: error.message };

    revalidatePath(`/organizador/torneios/${tournamentId}/partidas`);
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
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: "Não autenticado" };
    await requireOrgOrAdmin(supabase, tournamentId, user.id);

    const parsed = CreatePartidaSchema.safeParse(Object.fromEntries(formData));
    if (!parsed.success) return { error: parsed.error.errors[0].message };

    if (parsed.data.team_a_id === parsed.data.team_b_id) {
      return { error: "Os dois times precisam ser diferentes" };
    }

    const { data, error } = await supabase
      .from("matches")
      .insert({
        tournament_id: tournamentId,
        team_a_id: parsed.data.team_a_id,
        team_b_id: parsed.data.team_b_id,
        round: parsed.data.round,
        match_number: parsed.data.match_number,
        best_of: parsed.data.best_of,
        fase_id: parsed.data.fase_id ?? null,
        scheduled_at: parsed.data.scheduled_at ?? null,
        status: "pending",
      })
      .select()
      .single();

    if (error) return { error: error.message };
    revalidatePath(`/organizador/torneios/${tournamentId}/partidas`);
    return { success: true, data };
  } catch (e: any) {
    return { error: e.message };
  }
}

export async function deletePartida(matchId: string, tournamentId: string) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: "Não autenticado" };
    await requireOrgOrAdmin(supabase, tournamentId, user.id);

    const { data: match } = await supabase
      .from("matches")
      .select("status")
      .eq("id", matchId)
      .single();
    if (match?.status === "finished") {
      return { error: "Não é possível excluir uma partida já finalizada" };
    }

    const { error } = await supabase.from("matches").delete().eq("id", matchId);
    if (error) return { error: error.message };
    revalidatePath(`/organizador/torneios/${tournamentId}/partidas`);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

export async function getPartidasByTorneio(tournamentId: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("matches")
    .select(
      `id, round, match_number, status, score_a, score_b, scheduled_at, finished_at, best_of, fase_id,
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

export async function getPartidasByFase(faseId: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("matches")
    .select(
      `id, round, match_number, status, score_a, score_b, scheduled_at, finished_at, best_of,
       team_a:teams!team_a_id(id, name, tag, logo_url),
       team_b:teams!team_b_id(id, name, tag, logo_url),
       winner:teams!winner_id(id, name, tag)`
    )
    .eq("fase_id", faseId)
    .order("round")
    .order("match_number");
  if (error) return { error: error.message, data: null };
  return { data, error: null };
}

/**
 * Gera chaveamento eliminatório simples a partir dos times aprovados.
 * Embaralha e cria confrontos round 1. Retorna as partidas inseridas.
 */
export async function gerarChaveamento(tournamentId: string, faseId?: string) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: "Não autenticado" };
    await requireOrgOrAdmin(supabase, tournamentId, user.id);

    // Busca times aprovados
    const { data: inscricoes, error: errInsc } = await supabase
      .from("inscricoes")
      .select("team_id, teams(id, name, tag)")
      .eq("tournament_id", tournamentId)
      .eq("status", "APPROVED");

    if (errInsc) return { error: errInsc.message };
    if (!inscricoes || inscricoes.length < 2) {
      return { error: "É necessário pelo menos 2 times aprovados para gerar o chaveamento" };
    }

    // Embaralha os times
    const times = [...inscricoes].sort(() => Math.random() - 0.5);

    // Garante potência de 2 (preenche com bye se necessário)
    const nextPow2 = Math.pow(2, Math.ceil(Math.log2(times.length)));
    const partidas: any[] = [];

    for (let i = 0; i < nextPow2 / 2; i++) {
      const timeA = times[i * 2];
      const timeB = times[i * 2 + 1];
      if (!timeA) continue;
      if (!timeB) {
        // BYE: avança automaticamente — pula inserção de partida
        continue;
      }
      partidas.push({
        tournament_id: tournamentId,
        team_a_id: timeA.team_id,
        team_b_id: timeB.team_id,
        round: 1,
        match_number: i + 1,
        best_of: 1,
        fase_id: faseId ?? null,
        status: "pending",
      });
    }

    const { data: inserted, error: errIns } = await supabase
      .from("matches")
      .insert(partidas)
      .select();

    if (errIns) return { error: errIns.message };
    revalidatePath(`/organizador/torneios/${tournamentId}/partidas`);
    revalidatePath(`/organizador/torneios/${tournamentId}/fases`);
    revalidatePath(`/torneios`);
    return { success: true, data: inserted };
  } catch (e: any) {
    return { error: e.message };
  }
}
