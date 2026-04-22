"use server";
import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";

async function requireAdmin() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error("Nao autenticado");
  const { data: profile } = await supabase
    .from("profiles").select("is_admin").eq("id", user.id).single();
  if (!profile?.is_admin) throw new Error("Sem permissao");
  return { supabase, userId: user.id };
}

export async function toggleAdmin(targetUserId: string, value: boolean) {
  try {
    const { supabase, userId } = await requireAdmin();
    if (targetUserId === userId) return { error: "Nao pode alterar o proprio admin" };
    const { error } = await supabase
      .from("profiles").update({ is_admin: value }).eq("id", targetUserId);
    if (error) return { error: error.message };
    revalidatePath("/admin/usuarios");
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

export async function toggleBan(targetUserId: string, value: boolean) {
  try {
    const { supabase, userId } = await requireAdmin();
    if (targetUserId === userId) return { error: "Nao pode banir a si mesmo" };
    const { error } = await supabase
      .from("profiles").update({ is_banned: value }).eq("id", targetUserId);
    if (error) return { error: error.message };
    revalidatePath("/admin/usuarios");
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}
