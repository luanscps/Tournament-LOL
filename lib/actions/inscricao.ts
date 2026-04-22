"use server";
import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";

async function requireAdmin() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error("Nao autenticado");
  const { data: profile } = await supabase.from("profiles").select("is_admin").eq("id", user.id).single();
  if (!profile?.is_admin) throw new Error("Sem permissao");
  return supabase;
}

export async function aprovarInscricao(teamId: string, tournamentId: string) {
  try {
    const supabase = await requireAdmin();
    const { error } = await supabase
      .from("tournament_teams")
      .update({ status: "approved" })
      .eq("team_id", teamId)
      .eq("tournament_id", tournamentId);
    if (error) return { error: error.message };
    revalidatePath("/admin/torneios/" + tournamentId + "/inscricoes");
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

export async function rejeitarInscricao(teamId: string, tournamentId: string) {
  try {
    const supabase = await requireAdmin();
    const { error } = await supabase
      .from("tournament_teams")
      .update({ status: "rejected" })
      .eq("team_id", teamId)
      .eq("tournament_id", tournamentId);
    if (error) return { error: error.message };
    revalidatePath("/admin/torneios/" + tournamentId + "/inscricoes");
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}
