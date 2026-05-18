'use client'

import { useEffect, useState } from 'react'
import { Bell, Check, X, Loader2, ChevronDown, ChevronUp } from 'lucide-react'

type Invite = {
  id: string
  role: string | null
  is_reserve: boolean
  message: string | null
  expires_at: string | null
  created_at: string
  team: { id: string; name: string; tag: string; logo_url: string | null } | null
  inviter: { id: string; full_name: string | null; avatar_url: string | null } | null
}

export function PendingInvitesBanner() {
  const [invites, setInvites] = useState<Invite[]>([])
  const [loading, setLoading] = useState(true)
  const [expanded, setExpanded] = useState(true)
  const [responding, setResponding] = useState<string | null>(null)

  useEffect(() => {
    fetchInvites()
  }, [])

  async function fetchInvites() {
    setLoading(true)
    try {
      const res = await fetch('/api/teams/invites/pending')
      const json = await res.json()
      setInvites(json.invites ?? [])
    } catch {
      // silencia erro de rede
    } finally {
      setLoading(false)
    }
  }

  async function respond(inviteId: string, action: 'accept' | 'decline') {
    setResponding(inviteId)
    try {
      const res = await fetch('/api/teams/invite/respond', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ invite_id: inviteId, action }),
      })
      if (res.ok) {
        setInvites((prev) => prev.filter((i) => i.id !== inviteId))
      }
    } finally {
      setResponding(null)
    }
  }

  if (loading || invites.length === 0) return null

  return (
    <div className="mb-6 rounded-2xl border border-yellow-500/30 bg-yellow-500/5 p-4">
      <button
        onClick={() => setExpanded((e) => !e)}
        className="flex w-full items-center justify-between text-left"
      >
        <div className="flex items-center gap-2">
          <Bell className="h-5 w-5 text-yellow-400" />
          <span className="font-semibold text-yellow-300">
            {invites.length} convite{invites.length > 1 ? 's' : ''} de time pendente{invites.length > 1 ? 's' : ''}
          </span>
        </div>
        {expanded ? (
          <ChevronUp className="h-4 w-4 text-yellow-400" />
        ) : (
          <ChevronDown className="h-4 w-4 text-yellow-400" />
        )}
      </button>

      {expanded && (
        <div className="mt-3 space-y-3">
          {invites.map((invite) => (
            <div
              key={invite.id}
              className="flex items-start justify-between gap-3 rounded-xl bg-zinc-800/60 p-3"
            >
              <div className="flex items-center gap-3">
                {invite.team?.logo_url ? (
                  <img src={invite.team.logo_url} alt="" className="h-10 w-10 rounded-lg object-cover" />
                ) : (
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-zinc-700 text-xs font-bold text-zinc-300">
                    {invite.team?.tag ?? '?'}
                  </div>
                )}
                <div>
                  <p className="text-sm font-semibold text-white">{invite.team?.name ?? 'Time desconhecido'}</p>
                  {invite.inviter?.full_name && (
                    <p className="text-xs text-zinc-400">Convidado por {invite.inviter.full_name}</p>
                  )}
                  {invite.role && (
                    <span className="mt-0.5 inline-block rounded bg-blue-900/50 px-1.5 py-0.5 text-xs text-blue-300">
                      {invite.role}{invite.is_reserve ? ' · Reserva' : ''}
                    </span>
                  )}
                  {invite.message && (
                    <p className="mt-1 text-xs text-zinc-400 italic">&ldquo;{invite.message}&rdquo;</p>
                  )}
                </div>
              </div>

              <div className="flex shrink-0 gap-2">
                <button
                  onClick={() => respond(invite.id, 'accept')}
                  disabled={responding === invite.id}
                  className="flex items-center gap-1 rounded-lg bg-green-600 hover:bg-green-500 disabled:opacity-50 px-3 py-1.5 text-xs font-semibold text-white transition-colors"
                >
                  {responding === invite.id ? (
                    <Loader2 className="h-3.5 w-3.5 animate-spin" />
                  ) : (
                    <Check className="h-3.5 w-3.5" />
                  )}
                  Aceitar
                </button>
                <button
                  onClick={() => respond(invite.id, 'decline')}
                  disabled={responding === invite.id}
                  className="flex items-center gap-1 rounded-lg bg-zinc-700 hover:bg-zinc-600 disabled:opacity-50 px-3 py-1.5 text-xs font-semibold text-white transition-colors"
                >
                  <X className="h-3.5 w-3.5" />
                  Recusar
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
