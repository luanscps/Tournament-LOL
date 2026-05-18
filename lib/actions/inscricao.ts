'use server';
import { requireAuth, requireTournamentOrganizerOrAdmin } from '@/lib/supabase/permissions';
import { revalidatePath } from 'next/cache';
import { getPlatformUrl } from '@/lib/riot';

// ─── ORGANIZER/ADMIN: Aprovar inscrição ───────────────────────────────────────
export async function aprovarInscricao(teamId: string, tournamentId: string) {
  try {
    const { supabase, profile } = await requireTournamentOrganizerOrAdmin(tournamentId);
    const { error } = await supabase
      .from('inscricoes')
      .update({
        status:      'APPROVED',
        reviewed_by: profile.id,
        reviewed_at: new Date().toISOString(),
      })
      .eq('team_id', teamId)
      .eq('tournament_id', tournamentId);
    if (error) return { error: error.message };
    revalidatePath(`/organizador/torneios/${tournamentId}/inscricoes`);
    revalidatePath(`/admin/tournaments/${tournamentId}`);
    revalidatePath(`/admin/tournaments/${tournamentId}/inscricoes`);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

// ─── ORGANIZER/ADMIN: Rejeitar inscrição ─────────────────────────────────────
export async function rejeitarInscricao(teamId: string, tournamentId: string, notes: string) {
  try {
    const { supabase, profile } = await requireTournamentOrganizerOrAdmin(tournamentId);
    const { error } = await supabase
      .from('inscricoes')
      .update({
        status:      'REJECTED',
        reviewed_by: profile.id,
        reviewed_at: new Date().toISOString(),
        notes,
      })
      .eq('team_id', teamId)
      .eq('tournament_id', tournamentId);
    if (error) return { error: error.message };
    revalidatePath(`/organizador/torneios/${tournamentId}/inscricoes`);
    revalidatePath(`/admin/tournaments/${tournamentId}`);
    revalidatePath(`/admin/tournaments/${tournamentId}/inscricoes`);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

// ─── ORGANIZER/ADMIN: Desfazer check-in ──────────────────────────────────────
export async function desfazerCheckin(inscricaoId: string) {
  try {
    const { supabase } = await requireAuth();

    const { data: insc, error: fetchErr } = await supabase
      .from('inscricoes')
      .select('tournament_id')
      .eq('id', inscricaoId)
      .single();

    if (fetchErr || !insc) return { error: 'Inscrição não encontrada' };

    await requireTournamentOrganizerOrAdmin(insc.tournament_id);

    const { error } = await supabase
      .from('inscricoes')
      .update({ checked_in: false, checked_in_at: null, checked_in_by: null })
      .eq('id', inscricaoId);

    if (error) return { error: error.message };

    revalidatePath(`/organizador/torneios/${insc.tournament_id}/checkin`);
    revalidatePath(`/admin/tournaments/${insc.tournament_id}/checkin`);
    revalidatePath(`/admin/tournaments/${insc.tournament_id}`);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

// ─── ORGANIZER/ADMIN: Fazer check-in manual ──────────────────────────────────
/**
 * Permite que o organizador ou admin faça check-in de um time manualmente.
 *
 * SEGURANÇA EM DUAS CAMADAS:
 * 1. Client (checkin-client.tsx): verifica spectator-v5 antes de chamar esta action (UX)
 * 2. Server (esta função):        re-verifica spectator-v5 com os PUUIDs do time (fonte de verdade)
 *
 * A verificação server-side é best-effort:
 * - Se a API da Riot estiver fora do ar → libera o check-in (não penaliza)
 * - Se qualquer membro estiver em partida ativa → bloqueia com erro
 *
 * RLS: O UPDATE em inscricoes é permitido pela policy que usa
 * requireTournamentOrganizerOrAdmin, que verifica organizer_id no torneio.
 * Policy de banco: ver supabase/migrations/*_rls_inscricoes.sql
 */
export async function fazerCheckinOrganizador(inscricaoId: string) {
  try {
    const { supabase, profile } = await requireAuth();

    // 1. Busca inscrição + membros + PUUIDs
    const { data: insc, error: fetchErr } = await supabase
      .from('inscricoes')
      .select(`
        id, status, tournament_id,
        teams (
          team_members (
            riot_account:riot_accounts ( puuid )
          )
        )
      `)
      .eq('id', inscricaoId)
      .single();

    if (fetchErr || !insc) return { error: 'Inscrição não encontrada' };

    // 2. Verifica permissão de organizer/admin
    await requireTournamentOrganizerOrAdmin(insc.tournament_id);

    if (insc.status !== 'APPROVED') {
      return { error: 'Inscrição precisa estar APROVADA para check-in' };
    }

    // 3. [ITEM 2] Verificação Spectator-v5 server-side (segunda barreira)
    const team = insc.teams as any;
    if (team?.team_members?.length > 0) {
      const puuids: string[] = team.team_members
        .map((m: any) => m.riot_account?.puuid)
        .filter((p: string | null): p is string => !!p);

      if (puuids.length > 0) {
        const RIOT_KEY = process.env.RIOT_API_KEY;
        if (RIOT_KEY) {
          const spectatorChecks = await Promise.allSettled(
            puuids.map((puuid) =>
              fetch(
                `${getPlatformUrl()}/lol/spectator/v5/active-games/by-summoner/${puuid}`,
                { headers: { 'X-Riot-Token': RIOT_KEY }, cache: 'no-store' }
              ).then((r) => ({ puuid, inGame: r.status === 200 }))
            )
          );

          const anyInGame = spectatorChecks.some(
            (r) => r.status === 'fulfilled' && r.value.inGame
          );

          if (anyInGame) {
            return {
              error: '⚠️ Um ou mais membros do time estão em partida ativa. Aguarde o término.',
            };
          }
        }
      }
    }

    // 4. Aplica check-in
    const { error } = await supabase
      .from('inscricoes')
      .update({
        checked_in:    true,
        checked_in_at: new Date().toISOString(),
        checked_in_by: profile.id,
      })
      .eq('id', inscricaoId);

    if (error) return { error: error.message };

    revalidatePath(`/organizador/torneios/${insc.tournament_id}/checkin`);
    revalidatePath(`/admin/tournaments/${insc.tournament_id}/checkin`);
    revalidatePath(`/admin/tournaments/${insc.tournament_id}`);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

// ─── PLAYER: Criar inscrição (capitão de time) ────────────────────────────────
export async function criarInscricao(teamId: string, tournamentId: string) {
  try {
    const { supabase, profile } = await requireAuth();
    const { error } = await supabase.from('inscricoes').insert({
      team_id:       teamId,
      tournament_id: tournamentId,
      status:        'PENDING',
      requested_by:  profile.id,
    });
    if (error) return { error: error.message };
    revalidatePath('/dashboard');
    revalidatePath(`/torneios/${tournamentId}`);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

// ─── Alias público ────────────────────────────────────────────────────────────
export async function inscreverTime(tournamentId: string, teamId: string) {
  return criarInscricao(teamId, tournamentId);
}

// ─── PLAYER: Fazer check-in (apenas o capitão do time) ───────────────────────
export async function fazerCheckin(inscricaoId: string) {
  try {
    const { supabase, profile } = await requireAuth();

    const { data: insc, error: fetchErr } = await supabase
      .from('inscricoes')
      .select('id, status, team_id, teams!inner(owner_id)')
      .eq('id', inscricaoId)
      .single();

    if (fetchErr || !insc) return { error: 'Inscrição não encontrada' };

    const team = insc.teams as any;
    if (team.owner_id !== profile.id) return { error: 'Apenas o capitão pode fazer check-in' };
    if (insc.status !== 'APPROVED') return { error: 'Inscrição precisa estar APROVADA para check-in' };

    const { error } = await supabase
      .from('inscricoes')
      .update({
        checked_in:    true,
        checked_in_at: new Date().toISOString(),
        checked_in_by: profile.id,
      })
      .eq('id', inscricaoId);

    if (error) return { error: error.message };

    revalidatePath('/dashboard');
    revalidatePath(`/dashboard/times/${insc.team_id}`);
    revalidatePath(`/dashboard/times/${insc.team_id}/checkin`);
    return { success: true };
  } catch (e: any) {
    return { error: e.message };
  }
}

// ─── PUBLIC: Listar inscrições por torneio ────────────────────────────────────
export async function listarInscricoesPorTorneio(tournamentId: string) {
  const { supabase } = await requireAuth();
  const { data, error } = await supabase
    .from('inscricoes')
    .select(`
      id, status, checked_in, checked_in_at, created_at,
      team:teams (
        id, name, tag, logo_url, owner_id,
        team_members (
          id, team_role, lane,
          riot_account:riot_accounts (
            id, game_name, tag_line,
            player:players ( id, tier, lp, wins, losses )
          )
        )
      )
    `)
    .eq('tournament_id', tournamentId)
    .order('created_at', { ascending: true });
  if (error) return { error: error.message, data: null };
  return { data, error: null };
}
