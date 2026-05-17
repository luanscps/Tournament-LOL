"use server";
import { requireAdmin } from '@/lib/supabase/permissions';
import { revalidatePath } from "next/cache";

/**
 * Promover/revogar admin.
 * Apenas admins podem alterar outros admins.
 * Auto-modificação bloqueada.
 */
export async function toggleAdmin(targetUserId: string, value: boolean) {
  try {
    const { supabase, profile } = await requireAdmin();
    if (targetUserId === profile.id) return { error: "Não pode alterar o próprio status de admin" };
    const { error } = await supabase
      .from('profiles')
      .update({ is_admin: value, role: value ? 'admin' : 'player' })
      .eq('id', targetUserId);
    if (error) return { error: error.message };
    revalidatePath('/admin/usuarios');
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

/**
 * Banir/desbanir usuário.
 * Apenas admins podem banir.
 * Auto-ban bloqueado.
 */
export async function toggleBan(targetUserId: string, value: boolean) {
  try {
    const { supabase, profile } = await requireAdmin();
    if (targetUserId === profile.id) return { error: "Não pode banir a si mesmo" };
    const { error } = await supabase
      .from('profiles')
      .update({ is_banned: value })
      .eq('id', targetUserId);
    if (error) return { error: error.message };
    revalidatePath('/admin/usuarios');
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}
