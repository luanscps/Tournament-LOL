"use server";
import {
  requireAdmin,
  requireRiotLinked,
  requireTournamentOrganizerOrAdmin,
} from '@/lib/supabase/permissions';
import { createAdminClient } from '@/lib/supabase/admin';
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { z } from "zod";

const TournamentSchema = z.object({
  name:        z.string().min(3).max(80),
  slug:        z.string().min(3).max(80).regex(/^[a-z0-9-]+$/),
  description: z.string().optional(),
  max_teams:   z.coerce.number().min(2).max(64),
  start_date:  z.string().datetime({ offset: true }).optional().or(z.literal("")),
  status:      z.enum(["DRAFT", "OPEN", "IN_PROGRESS", "FINISHED", "CANCELLED"]),
});

export async function createTournament(formData: FormData) {
  try {
    const { supabase, profile } = await requireRiotLinked();
    const parsed = TournamentSchema.safeParse(Object.fromEntries(formData));
    if (!parsed.success) return { error: parsed.error.errors[0].message };
    const { start_date, ...rest } = parsed.data;
    const { data, error } = await supabase
      .from("tournaments")
      .insert({ ...rest, start_date: start_date || null, organizer_id: profile.id, created_by: profile.id })
      .select("id,slug")
      .single();
    if (error) return { error: error.message };
    revalidatePath("/organizador");
    revalidatePath("/admin/tournaments");
    revalidatePath("/torneios");
    return { id: data.id, slug: data.slug };
  } catch (e) {
    return { error: e instanceof Error ? e.message : "Erro ao criar torneio" };
  }
}

export async function updateTournament(id: string, formData: FormData) {
  try {
    const { supabase } = await requireTournamentOrganizerOrAdmin(id);
    const parsed = TournamentSchema.safeParse(Object.fromEntries(formData));
    if (!parsed.success) return { error: parsed.error.errors[0].message };
    const { start_date, ...rest } = parsed.data;
    const { error } = await supabase
      .from("tournaments")
      .update({ ...rest, start_date: start_date || null })
      .eq("id", id);
    if (error) return { error: error.message };
    revalidatePath("/organizador");
    revalidatePath("/admin/tournaments");
    revalidatePath("/admin/tournaments/" + id);
    revalidatePath("/torneios");
    return { success: true };
  } catch (e) {
    return { error: e instanceof Error ? e.message : "Erro ao atualizar torneio" };
  }
}

/**
 * deleteTournament — APENAS ADMIN.
 *
 * Recebe o id diretamente (não via FormData) para evitar problemas
 * de contexto SSR ao passar server action como prop de Client Component.
 *
 * Fluxo:
 *  1. requireAdmin() — valida sessão SSR + is_admin = true
 *  2. createAdminClient() (service_role) — bypassa RLS
 *  3. DELETE em cascade para inscricoes, matches, teams, fases, etc.
 */
export async function deleteTournament(id: string): Promise<{ success: true } | { error: string }> {
  try {
    await requireAdmin();

    const adminClient = createAdminClient();
    const { error } = await adminClient
      .from("tournaments")
      .delete()
      .eq("id", id);

    if (error) return { error: error.message };

    revalidatePath("/admin/tournaments");
    revalidatePath("/torneios");
    return { success: true };
  } catch (e) {
    return { error: e instanceof Error ? e.message : "Erro ao deletar torneio" };
  }
}
