"use server";
import { requireAdmin } from '@/lib/supabase/permissions';
import { createClient } from '@/lib/supabase/server';
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

/**
 * Salva preferências de notificação do próprio usuário.
 * notification_preferences é JSONB em profiles.
 * Qualquer usuário autenticado pode atualizar o próprio registro.
 */
export async function updateNotificationPreferences(
  prefs: {
    email?: boolean;
    discord?: boolean;
    push?: boolean;
    tournament_start?: boolean;
    match_scheduled?: boolean;
    dispute_update?: boolean;
    announcement?: boolean;
  }
) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: 'Não autenticado' };

    // Lê preferências atuais para fazer merge (não sobrescreve campos não enviados)
    const { data: current } = await supabase
      .from('profiles')
      .select('notification_preferences')
      .eq('id', user.id)
      .single();

    const merged = {
      ...((current?.notification_preferences as object) ?? {}),
      ...prefs,
    };

    const { error } = await supabase
      .from('profiles')
      .update({ notification_preferences: merged })
      .eq('id', user.id);

    if (error) return { error: error.message };
    revalidatePath('/dashboard/jogador/notificacoes');
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

/**
 * Marca uma notificação específica como lida.
 * RLS garante que o usuário só pode marcar as próprias.
 */
export async function marcarNotificacaoLida(notificationId: string) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: 'Não autenticado' };

    const { error } = await supabase
      .from('notifications')
      .update({ is_read: true })
      .eq('id', notificationId)
      .eq('user_id', user.id); // garantia extra além do RLS

    if (error) return { error: error.message };
    revalidatePath('/dashboard/jogador/notificacoes');
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

/**
 * Marca todas as notificações do usuário como lidas.
 */
export async function marcarTodasLidas() {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: 'Não autenticado' };

    const { error } = await supabase
      .from('notifications')
      .update({ is_read: true })
      .eq('user_id', user.id)
      .eq('is_read', false);

    if (error) return { error: error.message };
    revalidatePath('/dashboard/jogador/notificacoes');
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}
