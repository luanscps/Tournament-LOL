"use server";
import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";
import { z } from "zod";

// FIX: starts_at é coluna GENERATED ALWAYS AS (start_date) STORED no banco.
// Nunca deve ser inserida/atualizada manualmente — usamos start_date como campo real.
const TournamentSchema = z.object({
  name: z.string().min(3).max(80),
  slug: z.string().min(3).max(80).regex(/^[a-z0-9-]+$/),
  description: z.string().optional(),
  max_teams: z.coerce.number().min(2).max(64),
  // start_date é a coluna real; starts_at é derivada automaticamente pelo Postgres
  start_date: z.string().datetime({ offset: true }).optional().or(z.literal("")),
  status: z.enum(["draft", "open", "checkin", "ongoing", "finished"]),
});

async function requireAdmin() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error("Não autenticado");
  const { data: profile } = await supabase.from("profiles").select("is_admin").eq("id", user.id).single();
  if (!profile?.is_admin) throw new Error("Sem permissão");
  return supabase;
}

export async function createTournament(formData: FormData) {
  try {
    const supabase = await requireAdmin();
    const parsed = TournamentSchema.safeParse(Object.fromEntries(formData));
    if (!parsed.success) return { error: parsed.error.errors[0].message };

    // FIX: omite starts_at — é GENERATED, só enviamos start_date
    const { start_date, ...rest } = parsed.data;
    const payload = { ...rest, start_date: start_date || null };

    const { data, error } = await supabase.from("tournaments").insert(payload).select("id,slug").single();
    if (error) return { error: error.message };
    revalidatePath("/admin/torneios");
    return { id: data.id, slug: data.slug };
  } catch (e) {
    return { error: e instanceof Error ? e.message : "Erro" };
  }
}

export async function updateTournament(id: string, formData: FormData) {
  try {
    const supabase = await requireAdmin();
    const parsed = TournamentSchema.safeParse(Object.fromEntries(formData));
    if (!parsed.success) return { error: parsed.error.errors[0].message };

    // FIX: omite starts_at — é GENERATED, só enviamos start_date
    const { start_date, ...rest } = parsed.data;
    const payload = { ...rest, start_date: start_date || null };

    const { error } = await supabase.from("tournaments").update(payload).eq("id", id);
    if (error) return { error: error.message };
    revalidatePath("/admin/torneios");
    revalidatePath("/admin/torneios/" + id);
    return { success: true };
  } catch (e) {
    return { error: e instanceof Error ? e.message : "Erro" };
  }
}

export async function deleteTournament(id: string) {
  try {
    const supabase = await requireAdmin();
    const { error } = await supabase.from("tournaments").delete().eq("id", id);
    if (error) return { error: error.message };
    revalidatePath("/admin/torneios");
    return { success: true };
  } catch (e) {
    return { error: e instanceof Error ? e.message : "Erro" };
  }
}
