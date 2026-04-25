"use server";
import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";

async function requireAdmin() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("Nao autenticado");
  const { data: profile } = await supabase
    .from("profiles")
    .select("is_admin")
    .eq("id", user.id)
    .single();
  if (!profile?.is_admin) throw new Error("Sem permissao");
  return { supabase, adminId: user.id };
}

export async function aprovarInscricao(teamId: string, tournamentId: string) {
  try {
    const { supabase, adminId } = await requireAdmin();

    const { error } = await supabase
      .from("inscricoes")
      .update({
        status: "APPROVED",
        checked_in_at: new Date().toISOString(),
        reviewed_by: adminId,
      })
      .eq("team_id", teamId)
      .eq("tournament_id", tournamentId);

    if (error) return { error: error.message };

    revalidatePath("/admin/torneios/" + tournamentId + "/inscricoes");
    revalidatePath("/admin/torneios/" + tournamentId);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

export async function rejeitarInscricao(teamId: string, tournamentId: string) {
  try {
    const { supabase, adminId } = await requireAdmin();

    const { error } = await supabase
      .from("inscricoes")
      .update({
        status: "REJECTED",
        reviewed_by: adminId,
      })
      .eq("team_id", teamId)
      .eq("tournament_id", tournamentId);

    if (error) return { error: error.message };

    revalidatePath("/admin/torneios/" + tournamentId + "/inscricoes");
    revalidatePath("/admin/torneios/" + tournamentId);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

export async function criarInscricao(teamId: string, tournamentId: string) {
  try {
    const supabase = await createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) return { error: "Nao autenticado" };

    const { error } = await supabase.from("inscricoes").insert({
      team_id: teamId,
      tournament_id: tournamentId,
      status: "PENDING",
      requested_by: user.id,
    });

    if (error) return { error: error.message };

    revalidatePath("/dashboard/times");
    revalidatePath("/torneios/" + tournamentId);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

export async function listarInscricoesPorTorneio(tournamentId: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("inscricoes")
    .select(
      `
      id,
      status,
      checked_in_at,
      created_at,
      team:teams (
        id,
        name,
        tag,
        tournament_id,
        owner_id
      )
    `
    )
    .eq("tournament_id", tournamentId)
    .order("created_at", { ascending: true });

  if (error) return { error: error.message, data: null };
  return { data, error: null };
}
