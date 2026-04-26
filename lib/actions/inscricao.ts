'use server';

import { createClient } from '@/lib/supabase/server';
import { revalidatePath } from 'next/cache';

// ─── Inscrever time num torneio ───────────────────────────────────────────────
export async function inscreverTime(tournamentId: string, teamId: string) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { error: 'Não autenticado' };

  const { error } = await supabase.from('inscricoes').insert({
    tournament_id: tournamentId,
    team_id:       teamId,
    requested_by:  user.id,
    status:        'PENDING',
  });

  if (error) return { error: error.message };
  revalidatePath(`/torneios/${tournamentId}`);
  return { success: true };
}

// ─── Check-in ────────────────────────────────────────────────────────────────
export async function fazerCheckin(inscricaoId: string) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { error: 'Não autenticado' };

  // Garante que o usuário é dono do time inscrito
  const { data: insc, error: fetchErr } = await supabase
    .from('inscricoes')
    .select('id, status, teams!inner(owner_id)')
    .eq('id', inscricaoId)
    .single();

  if (fetchErr || !insc) return { error: 'Inscrição não encontrada' };

  const team = insc.teams as any;
  if (team.owner_id !== user.id) return { error: 'Apenas o capitão pode fazer check-in' };
  if (insc.status !== 'APPROVED') return { error: 'Inscrição precisa estar APROVADA para check-in' };

  const { error } = await supabase
    .from('inscricoes')
    .update({
      checked_in:    true,
      checked_in_at: new Date().toISOString(),
      checked_in_by: user.id,
    })
    .eq('id', inscricaoId);

  if (error) return { error: error.message };

  revalidatePath('/dashboard/times');
  return { success: true };
}

// ─── Desfazer check-in (somente admin) ───────────────────────────────────────
export async function desfazerCheckin(inscricaoId: string) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { error: 'Não autenticado' };

  // Verifica se é admin
  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single();

  if (profile?.role !== 'admin') return { error: 'Acesso negado' };

  const { error } = await supabase
    .from('inscricoes')
    .update({
      checked_in:    false,
      checked_in_at: null,
      checked_in_by: null,
    })
    .eq('id', inscricaoId);

  if (error) return { error: error.message };

  revalidatePath('/admin/torneios');
  return { success: true };
}
