'use client';
import { useState, useEffect, useMemo, useTransition } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { createClient } from '@/lib/supabase/client';
import {
  updateNotificationPreferences,
  marcarNotificacaoLida,
  marcarTodasLidas,
} from '@/lib/actions/usuario';

interface Notification {
  id: string;
  title: string;
  body: string | null;
  type: string | null;
  is_read: boolean;
  link: string | null;
  created_at: string;
}

interface NotifPrefs {
  email?: boolean;
  discord?: boolean;
  push?: boolean;
  tournament_start?: boolean;
  match_scheduled?: boolean;
  dispute_update?: boolean;
  announcement?: boolean;
}

const TYPE_ICONS: Record<string, string> = {
  match:        '⚔️',
  tournament:   '🏆',
  dispute:      '⚠️',
  announcement: '📢',
  checkin:      '📋',
  invite:       '👥',
  general:      '🔔',
};

export default function NotificacoesPage() {
  const router   = useRouter();
  const supabase = useMemo(() => createClient(), []);
  const [isPending, startTransition] = useTransition();

  const [notifs, setNotifs]   = useState<Notification[]>([]);
  const [prefs, setPrefs]     = useState<NotifPrefs>({});
  const [loading, setLoading] = useState(true);
  const [savingPrefs, setSavingPrefs] = useState(false);
  const [savedMsg, setSavedMsg]       = useState('');
  const [tab, setTab] = useState<'notifs' | 'prefs'>('notifs');

  useEffect(() => {
    async function load() {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push('/login'); return; }

      const [{ data: notifData }, { data: profile }] = await Promise.all([
        supabase
          .from('notifications')
          .select('id, title, body, type, is_read, link, created_at')
          .order('created_at', { ascending: false })
          .limit(50),
        supabase
          .from('profiles')
          .select('notification_preferences')
          .eq('id', user.id)
          .single(),
      ]);

      setNotifs((notifData ?? []) as Notification[]);
      setPrefs((profile?.notification_preferences as NotifPrefs) ?? {});
      setLoading(false);
    }
    load();
  }, [supabase, router]);

  async function handleMarcarLida(id: string) {
    startTransition(async () => {
      await marcarNotificacaoLida(id);
      setNotifs(prev => prev.map(n => n.id === id ? { ...n, is_read: true } : n));
    });
  }

  async function handleMarcarTodas() {
    startTransition(async () => {
      await marcarTodasLidas();
      setNotifs(prev => prev.map(n => ({ ...n, is_read: true })));
    });
  }

  async function handleSavePrefs() {
    setSavingPrefs(true);
    setSavedMsg('');
    const result = await updateNotificationPreferences(prefs);
    setSavingPrefs(false);
    setSavedMsg(result.error ? `Erro: ${result.error}` : '✅ Preferências salvas!');
    setTimeout(() => setSavedMsg(''), 3000);
  }

  const naoLidas = notifs.filter(n => !n.is_read).length;

  if (loading) return (
    <main className="min-h-screen bg-[#050E1A] flex items-center justify-center">
      <p className="text-gray-400">Carregando notificações...</p>
    </main>
  );

  return (
    <main className="min-h-screen bg-[#050E1A] py-10 px-4">
      <div className="max-w-2xl mx-auto space-y-5">

        {/* Header */}
        <div className="flex items-center justify-between flex-wrap gap-3">
          <div>
            <h1 className="text-white font-bold text-2xl">
              🔔 Notificações
              {naoLidas > 0 && (
                <span className="ml-2 text-sm bg-[#C8A84B] text-black font-bold px-2 py-0.5 rounded-full">
                  {naoLidas}
                </span>
              )}
            </h1>
            <p className="text-gray-500 text-sm mt-0.5">
              {notifs.length} notificação{notifs.length !== 1 ? 'ões' : ''} · {naoLidas} não lida{naoLidas !== 1 ? 's' : ''}
            </p>
          </div>
          <Link href="/dashboard" className="btn-outline-gold text-sm px-4 py-2">← Dashboard</Link>
        </div>

        {/* Tabs */}
        <div className="flex border-b border-[#1E3A5F]">
          {(['notifs', 'prefs'] as const).map(t => (
            <button
              key={t}
              onClick={() => setTab(t)}
              className={`px-5 py-2.5 text-sm font-semibold transition-colors ${
                tab === t
                  ? 'text-[#C8A84B] border-b-2 border-[#C8A84B] -mb-px'
                  : 'text-gray-500 hover:text-gray-300'
              }`}
            >
              {t === 'notifs' ? `📬 Caixa de Entrada` : '⚙️ Preferências'}
            </button>
          ))}
        </div>

        {/* Tab: Notificações */}
        {tab === 'notifs' && (
          <div className="space-y-3">
            {naoLidas > 0 && (
              <div className="flex justify-end">
                <button
                  onClick={handleMarcarTodas}
                  disabled={isPending}
                  className="text-xs text-[#C8A84B] hover:underline disabled:opacity-50"
                >
                  ✓ Marcar todas como lidas
                </button>
              </div>
            )}

            {notifs.length === 0 && (
              <div className="card-lol text-center py-12 space-y-2">
                <p className="text-4xl">📭</p>
                <p className="text-gray-400">Nenhuma notificação ainda.</p>
              </div>
            )}

            {notifs.map(n => {
              const icon = TYPE_ICONS[n.type ?? 'general'] ?? '🔔';
              return (
                <div
                  key={n.id}
                  className={`border rounded-xl p-4 transition-colors ${
                    n.is_read
                      ? 'bg-[#0A1428] border-[#1E3A5F] opacity-60'
                      : 'bg-[#0D1E35] border-[#C8A84B]/30'
                  }`}
                >
                  <div className="flex items-start gap-3">
                    <span className="text-xl shrink-0 mt-0.5">{icon}</span>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center justify-between gap-2 flex-wrap">
                        <p className={`font-semibold text-sm ${
                          n.is_read ? 'text-gray-400' : 'text-white'
                        }`}>
                          {n.title}
                        </p>
                        <span className="text-gray-600 text-xs shrink-0">
                          {new Date(n.created_at).toLocaleDateString('pt-BR', {
                            day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit',
                          })}
                        </span>
                      </div>
                      {n.body && (
                        <p className="text-gray-400 text-xs mt-1">{n.body}</p>
                      )}
                      <div className="flex items-center gap-3 mt-2">
                        {n.link && (
                          <Link
                            href={n.link}
                            className="text-[#C8A84B] text-xs hover:underline"
                          >
                            Ver detalhes →
                          </Link>
                        )}
                        {!n.is_read && (
                          <button
                            onClick={() => handleMarcarLida(n.id)}
                            disabled={isPending}
                            className="text-xs text-gray-500 hover:text-gray-300 disabled:opacity-50"
                          >
                            Marcar como lida
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}

        {/* Tab: Preferências */}
        {tab === 'prefs' && (
          <div className="card-lol space-y-5">
            <h2 className="text-white font-bold">⚙️ Canais de notificação</h2>

            <div className="space-y-3">
              {([
                { key: 'email',    label: 'E-mail',   desc: 'Receber notificações por e-mail' },
                { key: 'discord',  label: 'Discord',  desc: 'Receber via webhook do Discord do time' },
                { key: 'push',     label: 'Push',     desc: 'Notificações push no navegador (em breve)' },
              ] as const).map(({ key, label, desc }) => (
                <label key={key} className="flex items-center justify-between gap-3 cursor-pointer">
                  <div>
                    <p className="text-white text-sm font-medium">{label}</p>
                    <p className="text-gray-500 text-xs">{desc}</p>
                  </div>
                  <button
                    role="switch"
                    aria-checked={!!prefs[key]}
                    onClick={() => setPrefs(p => ({ ...p, [key]: !p[key] }))}
                    className={`w-11 h-6 rounded-full transition-colors flex items-center px-0.5 ${
                      prefs[key] ? 'bg-[#C8A84B]' : 'bg-[#1E3A5F]'
                    }`}
                  >
                    <span className={`w-5 h-5 bg-white rounded-full shadow transition-transform ${
                      prefs[key] ? 'translate-x-5' : 'translate-x-0'
                    }`} />
                  </button>
                </label>
              ))}
            </div>

            <div className="border-t border-[#1E3A5F] pt-4">
              <h3 className="text-gray-400 text-xs uppercase tracking-wider mb-3">Tipos de aviso</h3>
              <div className="space-y-3">
                {([
                  { key: 'tournament_start', label: 'Início de torneio',    desc: 'Quando um torneio inscrito começar' },
                  { key: 'match_scheduled',  label: 'Partida agendada',     desc: 'Quando uma partida do time for marcada' },
                  { key: 'dispute_update',   label: 'Atualização de disputa', desc: 'Quando uma disputa for resolvida ou atualizada' },
                  { key: 'announcement',     label: 'Comunicados',          desc: 'Comunicados do organizador do torneio' },
                ] as const).map(({ key, label, desc }) => (
                  <label key={key} className="flex items-center justify-between gap-3 cursor-pointer">
                    <div>
                      <p className="text-white text-sm font-medium">{label}</p>
                      <p className="text-gray-500 text-xs">{desc}</p>
                    </div>
                    <button
                      role="switch"
                      aria-checked={!!prefs[key]}
                      onClick={() => setPrefs(p => ({ ...p, [key]: !p[key] }))}
                      className={`w-11 h-6 rounded-full transition-colors flex items-center px-0.5 ${
                        prefs[key] ? 'bg-[#C8A84B]' : 'bg-[#1E3A5F]'
                      }`}
                    >
                      <span className={`w-5 h-5 bg-white rounded-full shadow transition-transform ${
                        prefs[key] ? 'translate-x-5' : 'translate-x-0'
                      }`} />
                    </button>
                  </label>
                ))}
              </div>
            </div>

            <div className="flex items-center gap-4">
              <button
                onClick={handleSavePrefs}
                disabled={savingPrefs}
                className="btn-gold px-6 py-2 text-sm font-bold disabled:opacity-50"
              >
                {savingPrefs ? 'Salvando...' : 'Salvar preferências'}
              </button>
              {savedMsg && (
                <span className={`text-sm ${
                  savedMsg.startsWith('Erro') ? 'text-red-400' : 'text-green-400'
                }`}>
                  {savedMsg}
                </span>
              )}
            </div>
          </div>
        )}

      </div>
    </main>
  );
}
