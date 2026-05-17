"use server";
import {
  requireAdmin,
  requireRiotLinked,
  requireTournamentOrganizerOrAdmin,
} from '@/lib/supabase/permissions';
import { revalidatePath } from "next/cache";
import { z } from "zod";

// start_date é a coluna real; starts_at é GENERATED ALWAYS AS (start_date) STORED — nunca enviar manualmente.
const TournamentSchema = z.object({
  name:        z.string().min(3).max(80),
  slug:        z.string().min(3).max(80).regex(/^[a-z0-9-]+$/),
  description: z.string().optional(),
  max_teams:   z.coerce.number().min(2).max(64),
  start_date:  z.string().datetime({ offset: true }).optional().or(z.literal("")),
  status:      z.enum(["DRAFT", "OPEN", "IN_PROGRESS", "FINISHED", "CANCELLED"]),
});

/**
 * Criar torneio:
 *  - Qualquer conta autenticada pode criar, DESDE QUE tenha conta Riot primária vinculada.
 *  - Admins são isentos da trava de Riot.
 *  - O criador se torna organizer_id e created_by automaticamente.
 */
export async function createTournament(formData: FormData) {
  try {
    const { supabase, profile } = await requireRiotLinked();

    const parsed = TournamentSchema.safeParse(Object.fromEntries(formData));
    if (!parsed.success) return { error: parsed.error.errors[0].message };

    const { start_date, ...rest } = parsed.data;
    const payload = {
      ...rest,
      start_date:   start_date || null,
      organizer_id: profile.id,
      created_by:   profile.id,
    };

    const { data, error } = await supabase
      .from("tournaments")
      .insert(payload)
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

/**
 * Atualizar torneio:
 *  - Organizador responsável (organizer_id ou created_by) OU admin.
 */
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
 * Deletar torneio:
 *  - Ação destrutiva: apenas admins.
 */
export async function deleteTournament(id: string) {
  try {
    const { supabase } = await requireAdmin();
    const { error } = await supabase.from("tournaments").delete().eq("id", id);
    if (error) return { error: error.message };
    revalidatePath("/admin/tournaments");
    revalidatePath("/torneios");
    return { success: true };
  } catch (e) {
    return { error: e instanceof Error ? e.message : "Erro ao deletar torneio" };
  }
}
