/**
 * lib/supabase/permissions.ts
 *
 * Helper centralizado de permissões server-side.
 * Elimina os `requireAdmin()` duplicados espalhados nas actions.
 *
 * Regras de negócio:
 *  - player:    usuário comum autenticado, pode ter Riot vinculado ou não.
 *  - organizer: qualquer conta autenticada COM conta Riot primária vinculada.
 *               (role='organizer' no profile é setado automaticamente — ver nota abaixo)
 *  - admin:     is_admin=true. Pode fazer tudo.
 *
 * NOTA: o campo `role` em `profiles` não é gerenciado manualmente.
 * A promoção de player → organizer acontece no momento em que o usuário
 * cria um torneio (requireRiotLinked garante o pré-requisito).
 */
'use server';
import { createClient } from '@/lib/supabase/server';

export type UserProfile = {
  id: string;
  is_admin: boolean;
  is_banned: boolean;
  role: 'player' | 'organizer' | 'admin';
};

// ─── Primitivos ──────────────────────────────────────────────────────────────

/** Retorna o user autenticado + perfil. Lança se não autenticado ou banido. */
export async function requireAuth() {
  const supabase = await createClient();
  const { data: { user }, error } = await supabase.auth.getUser();
  if (error || !user) throw new Error('Não autenticado');

  const { data: profile, error: profileErr } = await supabase
    .from('profiles')
    .select('id, is_admin, is_banned, role')
    .eq('id', user.id)
    .single();

  if (profileErr || !profile) throw new Error('Perfil não encontrado');
  if (profile.is_banned) throw new Error('Conta suspensa. Entre em contato com o suporte.');

  return { supabase, profile: profile as UserProfile };
}

// ─── Guards de role ───────────────────────────────────────────────────────────

/** Exige admin geral. */
export async function requireAdmin() {
  const { supabase, profile } = await requireAuth();
  if (!profile.is_admin && profile.role !== 'admin') {
    throw new Error('Sem permissão: apenas administradores.');
  }
  return { supabase, profile };
}

/**
 * Exige que o usuário tenha conta Riot primária vinculada.
 * Pré-requisito obrigatório para criar torneios.
 * Admins são isentos desta verificação.
 */
export async function requireRiotLinked() {
  const { supabase, profile } = await requireAuth();

  // Admin não precisa de Riot vinculado para gerenciar torneios
  if (profile.is_admin || profile.role === 'admin') {
    return { supabase, profile };
  }

  const { data: riotAccount } = await supabase
    .from('riot_accounts')
    .select('id')
    .eq('profile_id', profile.id)
    .eq('is_primary', true)
    .maybeSingle();

  if (!riotAccount) {
    throw new Error(
      'RIOT_ACCOUNT_REQUIRED: Você precisa vincular uma conta Riot para criar torneios.'
    );
  }

  return { supabase, profile };
}

/**
 * Exige que o usuário seja o organizador responsável pelo torneio OU admin.
 * Verifica tanto `organizer_id` quanto `created_by` para retrocompatibilidade.
 */
export async function requireTournamentOrganizerOrAdmin(tournamentId: string) {
  const { supabase, profile } = await requireAuth();

  if (profile.is_admin || profile.role === 'admin') {
    return { supabase, profile };
  }

  const { data: torneio, error } = await supabase
    .from('tournaments')
    .select('organizer_id, created_by')
    .eq('id', tournamentId)
    .single();

  if (error || !torneio) throw new Error('Torneio não encontrado');

  const isOrg =
    torneio.organizer_id === profile.id ||
    torneio.created_by === profile.id;

  if (!isOrg) {
    throw new Error('Sem permissão: você não é o organizador deste torneio.');
  }

  return { supabase, profile };
}
