'use client';
import { useState, useEffect, useMemo } from 'react';
import { useRouter, useParams } from 'next/navigation';
import Link from 'next/link';
import { createClient } from '@/lib/supabase/client';
import { fazerCheckin } from '@/lib/actions/inscricao';

interface InscricaoDetalhe {
  id: string;
  status: string;
  checked_in: boolean;
  checked_in_at: string | null;
  teams: { id: string; name: string; tag: string; owner_id: string };
  tournaments: { id: string; name: string; status: string };
}

export default function CheckinPage() {
  const params   = useParams();
  const teamId   = params.id as string;
  const router   = useRouter();
  const supabase = useMemo(() => createClient(), []);

  const [insc, setInsc]       = useState<InscricaoDetalhe | null>(null);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError]     = useState('');
  const [success, setSuccess] = useState(false);

  useEffect(() => {
    async function load() {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push('/login'); return; }

      const { data, error: err } = await supabase
        .from('inscricoes')
        .select(`
          id, status, checked_in, checked_in_at,
          teams!inner ( id, name, tag, owner_id ),
          tournaments!inner ( id, name, status )
        `)
        .eq('team_id', teamId)
        .single();

      if (err || !data) { setError('Inscrição não encontrada para este time.'); setLoading(false); return; }

      const team = data.teams as any;
      if (team.owner_id !== user.id) { setError('Apenas o capitão pode fazer check-in.'); setLoading(false); return; }

      setInsc(data as any);
      setLoading(false);
    }
    load();
  }, [supabase, router, teamId]);

  async function handleCheckin() {
    if (!insc) return;
    setSubmitting(true);
    setError('');
    const result = await fazerCheckin(insc.id);
    if (result.error) {
      setError(result.error);
    } else {
      setSuccess(true);
      setInsc(prev => prev ? { ...prev, checked_in: true, checked_in_at: new Date().toISOString() } : prev);
    }
    setSubmitting(false);
  }

  if (loading) return (
    <main className="min-h-screen bg-[#050E1A] flex items-center justify-center">
      <p className="text-gray-400">Carregando check-in...</p>
    </main>
  );

  if (error && !insc) return (
    <main className="min-h-screen bg-[#050E1A] flex items-center justify-center">
      <div className="card-lol text-center space-y-3">
        <p className="text-4xl">⚠️</p>
        <p className="text-red-400">{error}</p>
        <Link href="/dashboard" className="text-blue-400 text-sm hover:underline">Voltar ao Dashboard</Link>
      </div>
    </main>
  );

  if (!insc) return null;

  const tourn = insc.tournaments as any;

  return (
    <main className="min-h-screen bg-[#050E1A] py-10 px-4">
      <div className="max-w-lg mx-auto space-y-6">

        <h1 className="text-2xl font-bold text-white">📋 Check-in no Torneio</h1>

        {/* Info do Torneio */}
        <div className="card-lol space-y-2">
          <p className="text-gray-400 text-xs uppercase tracking-wider">Torneio</p>
          <p className="text-white font-bold text-lg">🏆 {tourn.name}</p>
          <p className="text-gray-500 text-sm">
            Time: <span className="text-white font-medium">[{insc.teams.tag}] {insc.teams.name}</span>
          </p>
        </div>

        {/* Status */}
        {insc.status !== 'APPROVED' ? (
          <div className="bg-yellow-900/20 border border-yellow-500/30 rounded-xl p-4">
            <p className="text-yellow-400 font-semibold">⚠️ Inscrição ainda não aprovada</p>
            <p className="text-gray-400 text-sm mt-1">
              Seu time precisa ter a inscrição <strong>APROVADA</strong> pelo administrador antes de fazer check-in.
            </p>
          </div>
        ) : insc.checked_in ? (
          <div className="bg-green-900/20 border border-green-500/30 rounded-xl p-4 text-center space-y-2">
            <p className="text-green-400 text-3xl">✅</p>
            <p className="text-green-400 font-bold text-lg">Check-in Confirmado!</p>
            {insc.checked_in_at && (
              <p className="text-gray-400 text-xs">
                Realizado em {new Date(insc.checked_in_at).toLocaleString('pt-BR')}
              </p>
            )}
          </div>
        ) : (
          <div className="card-lol space-y-4">
            <p className="text-gray-300 text-sm">
              Confirme a presença do seu time no torneio. Após o check-in, sua vaga estará garantida.
            </p>

            {error && (
              <div className="bg-red-900/30 border border-red-500/40 rounded p-3">
                <p className="text-red-400 text-sm">{error}</p>
              </div>
            )}

            {success && (
              <div className="bg-green-900/20 border border-green-500/30 rounded p-3">
                <p className="text-green-400 text-sm">✅ Check-in realizado com sucesso!</p>
              </div>
            )}

            <button
              onClick={handleCheckin}
              disabled={submitting}
              className="btn-gold w-full py-4 text-base font-bold"
            >
              {submitting ? 'Confirmando...' : '✅ Confirmar Check-in'}
            </button>
          </div>
        )}

        <div className="flex gap-3">
          <Link
            href={`/dashboard/times/${teamId}`}
            className="btn-outline-gold flex-1 py-3 text-center text-sm"
          >
            ← Painel do Time
          </Link>
          <Link
            href={`/torneios/${tourn.id}`}
            className="btn-gold flex-1 py-3 text-center text-sm"
          >
            Ver Torneio
          </Link>
        </div>

      </div>
    </main>
  );
}
