"use server";
import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";

/**
 * Aceita um convite de time.
 *
 * FIX: após aceitar o convite (status → ACCEPTED), insere o jogador na tabela
 * team_members para que o RLS e os flows de roster funcionem corretamente.
 * Antes deste fix o jogador ficava em team_invites sem transição para team_members.
 */
export async function aceitarConvite(inviteId: string) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: "Não autenticado" };

    // Busca o convite pelo id e valida se pertence ao usuário autenticado
    const { data: invite, error: fetchErr } = await supabase
      .from("team_invites")
      .select("id, team_id, role, status, expires_at, summoner_name, tagline")
      .eq("id", inviteId)
      .single();

    if (fetchErr || !invite) return { error: "Convite não encontrado" };
    if (invite.status !== "PENDING") return { error: "Convite já foi respondido" };
    if (invite.expires_at && new Date(invite.expires_at) < new Date()) {
      return { error: "Convite expirado" };
    }

    // 1. Marca o convite como aceito
    const { error: updateErr } = await supabase
      .from("team_invites")
      .update({ status: "ACCEPTED" })
      .eq("id", inviteId);

    if (updateErr) return { error: updateErr.message };

    // 2. FIX: insere na tabela team_members para que o jogador apareça no roster
    //    Usa upsert para evitar duplicata caso o usuário já seja membro
    const { error: memberErr } = await supabase
      .from("team_members")
      .upsert(
        {
          team_id:    invite.team_id,
          profile_id: user.id,
          team_role:  invite.role ?? "member",
          status:     "active",
          invited_by: null, // preenchido pelo trigger se existir
          invited_at: new Date().toISOString(),
          responded_at: new Date().toISOString(),
        },
        { onConflict: "team_id,profile_id", ignoreDuplicates: false }
      );

    if (memberErr) return { error: memberErr.message };

    revalidatePath("/dashboard");
    revalidatePath(`/dashboard/times/${invite.team_id}`);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

/**
 * Recusa um convite de time.
 */
export async function recusarConvite(inviteId: string) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: "Não autenticado" };

    const { error } = await supabase
      .from("team_invites")
      .update({ status: "REJECTED" })
      .eq("id", inviteId);

    if (error) return { error: error.message };
    revalidatePath("/dashboard");
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

/**
 * Lista convites pendentes do usuário autenticado.
 * Cruza team_invites com profiles via summoner_name+tagline.
 */
export async function listarConvitesPendentes() {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return { error: "Não autenticado", data: null };

    // Busca o summoner_name e tagline do perfil para cruzar com convites
    const { data: profile } = await supabase
      .from("profiles")
      .select("riot_game_name, riot_tagline")
      .eq("id", user.id)
      .single();

    if (!profile?.riot_game_name) return { data: [], error: null };

    const { data, error } = await supabase
      .from("team_invites")
      .select(`
        id, role, status, expires_at, created_at,
        team:teams ( id, name, tag, logo_url )
      `)
      .eq("summoner_name", profile.riot_game_name)
      .eq("tagline", profile.riot_tagline ?? "BR1")
      .eq("status", "PENDING")
      .gt("expires_at", new Date().toISOString());

    if (error) return { error: error.message, data: null };
    return { data, error: null };
  } catch (e: any) {
    return { error: e.message, data: null };
  }
}
