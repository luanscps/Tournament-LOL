"use server";
import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";
import { z } from "zod";

const FaseSchema = z.object({
  nome: z.string().min(1, "Nome é obrigatório").max(80),
  tipo: z.enum(["grupos", "playoffs", "pontos_corridos", "suíço"], {
    errorMap: () => ({ message: "Tipo inválido" }),
  }),
  ordem: z.coerce.number().min(1).max(20),
  num_grupos: z.coerce.number().min(1).max(16).optional(),
  times_por_grupo: z.coerce.number().min(2).max(16).optional(),
  classificados_por_grupo: z.coerce.number().min(1).max(8).optional(),
  melhor_de: z.coerce.number().min(1).max(7).optional(),
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

export async function createFase(
  tournamentId: string,
  formData: FormData
) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: "Não autenticado" };
    await requireOrgOrAdmin(supabase, tournamentId, user.id);

    const parsed = FaseSchema.safeParse(Object.fromEntries(formData));
    if (!parsed.success) return { error: parsed.error.errors[0].message };

    const { data, error } = await supabase
      .from("fases")
      .insert({
        tournament_id: tournamentId,
        name: parsed.data.nome,
        type: parsed.data.tipo,
        order: parsed.data.ordem,
        num_groups: parsed.data.num_grupos ?? 1,
        teams_per_group: parsed.data.times_por_grupo ?? 4,
        qualifiers_per_group: parsed.data.classificados_por_grupo ?? 2,
        best_of: parsed.data.melhor_de ?? 1,
        status: "pending",
      })
      .select()
      .single();

    if (error) return { error: error.message };
    revalidatePath(`/organizador/torneios/${tournamentId}/fases`);
    return { success: true, data };
  } catch (e: any) {
    return { error: e.message };
  }
}

export async function updateFase(
  faseId: string,
  tournamentId: string,
  formData: FormData
) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: "Não autenticado" };
    await requireOrgOrAdmin(supabase, tournamentId, user.id);

    const parsed = FaseSchema.safeParse(Object.fromEntries(formData));
    if (!parsed.success) return { error: parsed.error.errors[0].message };

    const { error } = await supabase
      .from("fases")
      .update({
        name: parsed.data.nome,
        type: parsed.data.tipo,
        order: parsed.data.ordem,
        num_groups: parsed.data.num_grupos ?? 1,
        teams_per_group: parsed.data.times_por_grupo ?? 4,
        qualifiers_per_group: parsed.data.classificados_por_grupo ?? 2,
        best_of: parsed.data.melhor_de ?? 1,
      })
      .eq("id", faseId);

    if (error) return { error: error.message };
    revalidatePath(`/organizador/torneios/${tournamentId}/fases`);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

export async function deleteFase(
  faseId: string,
  tournamentId: string
) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: "Não autenticado" };
    await requireOrgOrAdmin(supabase, tournamentId, user.id);

    // Bloqueia exclusão se a fase já iniciou
    const { data: fase } = await supabase
      .from("fases")
      .select("status")
      .eq("id", faseId)
      .single();
    if (fase?.status === "active" || fase?.status === "finished") {
      return { error: "Não é possível excluir uma fase que já está em andamento ou finalizada" };
    }

    const { error } = await supabase.from("fases").delete().eq("id", faseId);
    if (error) return { error: error.message };
    revalidatePath(`/organizador/torneios/${tournamentId}/fases`);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

export async function getFasesByTorneio(tournamentId: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("fases")
    .select("*")
    .eq("tournament_id", tournamentId)
    .order("order", { ascending: true });
  if (error) return { error: error.message, data: null };
  return { data, error: null };
}

export async function ativarFase(faseId: string, tournamentId: string) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: "Não autenticado" };
    await requireOrgOrAdmin(supabase, tournamentId, user.id);

    // Finaliza fase anterior se existir
    await supabase
      .from("fases")
      .update({ status: "finished" })
      .eq("tournament_id", tournamentId)
      .eq("status", "active");

    const { error } = await supabase
      .from("fases")
      .update({ status: "active", started_at: new Date().toISOString() })
      .eq("id", faseId);

    if (error) return { error: error.message };
    revalidatePath(`/organizador/torneios/${tournamentId}/fases`);
    revalidatePath(`/torneios`);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}
