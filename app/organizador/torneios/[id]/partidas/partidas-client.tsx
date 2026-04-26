'use client'
import { useState, useTransition } from 'react'
import { updateResultadoPartida, createPartida, deletePartida, gerarChaveamento } from '@/lib/actions/partida'
import Link from 'next/link'
import { useRouter } from 'next/navigation'

const STATUS_LABEL: Record<string, string> = {
  pending: 'Agendada', ongoing: 'Ao vivo', finished: 'Finalizada', cancelled: 'Cancelada'
}
const STATUS_COLOR: Record<string, string> = {
  pending:   'text-gray-400 bg-gray-800/40 border-gray-700/40',
  ongoing:   'text-yellow-400 bg-yellow-900/20 border-yellow-700/40',
  finished:  'text-green-400 bg-green-900/20 border-green-700/40',
  cancelled: 'text-red-400 bg-red-900/20 border-red-700/40',
}

export default function PartidasClient({
  torneio, partidas: initialPartidas, fases, timesAprovados
}: { torneio: any; partidas: any[]; fases: any[]; timesAprovados: any[] }) {
  const router = useRouter()
  const [partidas, setPartidas] = useState(initialPartidas)
  const [isPending, startTransition] = useTransition()
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  const [editingId, setEditingId] = useState<string | null>(null)
  const [showCreateForm, setShowCreateForm] = useState(false)

  // Form resultado
  const [winnerId, setWinnerId] = useState('')
  const [scoreA, setScoreA] = useState(1)
  const [scoreB, setScoreB] = useState(0)
  const [matchRiot, setMatchRiot] = useState('')

  // Form nova partida
  const [newTeamA, setNewTeamA] = useState('')
  const [newTeamB, setNewTeamB] = useState('')
  const [newRound, setNewRound] = useState(1)
  const [newMatchNum, setNewMatchNum] = useState(partidas.length + 1)
  const [newFaseId, setNewFaseId] = useState('')
  const [newBestOf, setNewBestOf] = useState(1)
  const [newScheduled, setNewScheduled] = useState('')

  function openEdit(partida: any) {
    setEditingId(partida.id)
    setWinnerId(partida.winner?.id ?? '')
    setScoreA(partida.score_a ?? 1)
    setScoreB(partida.score_b ?? 0)
    setMatchRiot(partida.match_id_riot ?? '')
  }

  async function handleResultado(e: React.FormEvent, matchId: string) {
    e.preventDefault()
    setError(''); setSuccess('')
    const fd = new FormData()
    fd.append('winner_team_id', winnerId)
    fd.append('score_a', String(scoreA))
    fd.append('score_b', String(scoreB))
    if (matchRiot) fd.append('match_id_riot', matchRiot)
    startTransition(async () => {
      const res = await updateResultadoPartida(matchId, torneio.id, fd)
      if (res.error) { setError(res.error); return }
      setSuccess('Resultado salvo!')
      setEditingId(null)
      router.refresh()
    })
  }

  async function handleCreatePartida(e: React.FormEvent) {
    e.preventDefault()
    setError(''); setSuccess('')
    const fd = new FormData()
    fd.append('team_a_id', newTeamA)
    fd.append('team_b_id', newTeamB)
    fd.append('round', String(newRound))
    fd.append('match_number', String(newMatchNum))
    fd.append('best_of', String(newBestOf))
    if (newFaseId) fd.append('fase_id', newFaseId)
    if (newScheduled) fd.append('scheduled_at', new Date(newScheduled).toISOString())
    startTransition(async () => {
      const res = await createPartida(torneio.id, fd)
      if (res.error) { setError(res.error); return }
      setSuccess('Partida criada!')
      setShowCreateForm(false)
      router.refresh()
    })
  }

  async function handleDelete(matchId: string) {
    if (!confirm('Deletar esta partida?')) return
    setError('')
    startTransition(async () => {
      const res = await deletePartida(matchId, torneio.id)
      if (res.error) { setError(res.error); return }
      setSuccess('Partida removida.')
      router.refresh()
    })
  }

  async function handleGerarChaveamento() {
    const faseAtiva = fases.find(f => f.status === 'active')
    if (!faseAtiva) { setError('Ative uma fase antes de gerar o chaveamento.'); return }
    if (!confirm(`Gerar chaveamento para a fase "${faseAtiva.name}"?`)) return
    setError('')
    startTransition(async () => {
      const res = await gerarChaveamento(torneio.id, faseAtiva.id)
      if (res.error) { setError(res.error); return }
      setSuccess(`Chaveamento gerado! ${(res.data as any[])?.length ?? 0} partidas criadas.`)
      router.refresh()
    })
  }

  // Agrupa partidas por round
  const porRound: Record<number, any[]> = {}
  partidas.forEach(p => {
    if (!porRound[p.round]) porRound[p.round] = []
    porRound[p.round].push(p)
  })

  const times = timesAprovados.map((i: any) => i.teams).filter(Boolean)

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h1 className="text-xl font-bold text-white">⚔️ Partidas — {torneio.name}</h1>
          <p className="text-gray-400 text-sm mt-0.5">{partidas.length} partida{partidas.length !== 1 ? 's' : ''} · {partidas.filter(p => p.status === 'finished').length} finalizada{partidas.filter(p => p.status === 'finished').length !== 1 ? 's' : ''}</p>
        </div>
        <div className="flex gap-3">
          <Link href={`/organizador/torneios/${torneio.id}/fases`} className="btn-outline-gold text-sm px-4 py-2">🏗️ Fases</Link>
          <Link href={`/organizador/torneios/${torneio.id}`} className="text-gray-400 hover:text-white text-sm py-2">← Torneio</Link>
        </div>
      </div>

      {/* Alertas */}
      {error   && <div className="bg-red-900/30 border border-red-500/40 rounded-xl px-5 py-3"><p className="text-red-400 text-sm">❌ {error}</p></div>}
      {success && <div className="bg-green-900/30 border border-green-600/40 rounded-xl px-5 py-3"><p className="text-green-400 text-sm">✅ {success}</p></div>}

      {/* Ações rápidas */}
      <div className="flex gap-3 flex-wrap">
        <button onClick={handleGerarChaveamento} disabled={isPending || fases.filter(f => f.status === 'active').length === 0}
          className="btn-gold py-2 px-5 text-sm disabled:opacity-50">🎲 Gerar Chaveamento Automático</button>
        <button onClick={() => setShowCreateForm(v => !v)} disabled={isPending}
          className="btn-outline-gold py-2 px-5 text-sm">+ Criar Partida Manual</button>
      </div>

      {fases.filter(f => f.status === 'active').length === 0 && fases.length > 0 && (
        <div className="bg-yellow-900/20 border border-yellow-700/40 rounded-xl px-5 py-3">
          <p className="text-yellow-400 text-sm">⚠️ Nenhuma fase está ativa. <Link href={`/organizador/torneios/${torneio.id}/fases`} className="underline">Ative uma fase</Link> para habilitar o chaveamento automático.</p>
        </div>
      )}

      {/* Form criar partida manual */}
      {showCreateForm && (
        <form onSubmit={handleCreatePartida} className="card-lol space-y-4">
          <h2 className="text-white font-bold">➕ Nova Partida Manual</h2>
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-gray-400 text-sm mb-1">Time A</label>
              <select value={newTeamA} onChange={e => setNewTeamA(e.target.value)} className="input-lol w-full" required>
                <option value="">Selecionar...</option>
                {times.map((t: any) => <option key={t.id} value={t.id}>[{t.tag}] {t.name}</option>)}
              </select>
            </div>
            <div>
              <label className="block text-gray-400 text-sm mb-1">Time B</label>
              <select value={newTeamB} onChange={e => setNewTeamB(e.target.value)} className="input-lol w-full" required>
                <option value="">Selecionar...</option>
                {times.map((t: any) => <option key={t.id} value={t.id}>[{t.tag}] {t.name}</option>)}
              </select>
            </div>
            <div>
              <label className="block text-gray-400 text-sm mb-1">Round</label>
              <input type="number" min={1} value={newRound} onChange={e => setNewRound(+e.target.value)} className="input-lol w-full" required />
            </div>
            <div>
              <label className="block text-gray-400 text-sm mb-1">Nº da Partida</label>
              <input type="number" min={1} value={newMatchNum} onChange={e => setNewMatchNum(+e.target.value)} className="input-lol w-full" required />
            </div>
            <div>
              <label className="block text-gray-400 text-sm mb-1">Fase (opcional)</label>
              <select value={newFaseId} onChange={e => setNewFaseId(e.target.value)} className="input-lol w-full">
                <option value="">Sem fase</option>
                {fases.map(f => <option key={f.id} value={f.id}>{f.name}</option>)}
              </select>
            </div>
            <div>
              <label className="block text-gray-400 text-sm mb-1">Melhor de</label>
              <select value={newBestOf} onChange={e => setNewBestOf(+e.target.value)} className="input-lol w-full">
                <option value={1}>MD1</option><option value={3}>MD3</option><option value={5}>MD5</option>
              </select>
            </div>
            <div className="col-span-2">
              <label className="block text-gray-400 text-sm mb-1">Data/hora agendada (opcional)</label>
              <input type="datetime-local" value={newScheduled} onChange={e => setNewScheduled(e.target.value)} className="input-lol w-full" />
            </div>
          </div>
          <div className="flex gap-3">
            <button type="button" onClick={() => setShowCreateForm(false)} className="btn-outline-gold flex-1 py-2.5">Cancelar</button>
            <button type="submit" disabled={isPending} className="btn-gold flex-1 py-2.5">{isPending ? 'Criando...' : '➕ Criar Partida'}</button>
          </div>
        </form>
      )}

      {/* Partidas vazias */}
      {partidas.length === 0 && (
        <div className="card-lol text-center py-16">
          <p className="text-4xl mb-3">⚔️</p>
          <p className="text-white font-bold">Nenhuma partida ainda</p>
          <p className="text-gray-400 text-sm mt-1">Use o botão acima para gerar o chaveamento ou criar partidas manualmente.</p>
        </div>
      )}

      {/* Lista agrupada por round */}
      {Object.entries(porRound).map(([round, matches]) => (
        <section key={round}>
          <h2 className="text-gray-400 font-semibold text-sm uppercase tracking-wider mb-3">Round {round}</h2>
          <div className="space-y-3">
            {matches.map((p) => {
              const fase = fases.find(f => f.id === p.fase_id)
              return (
                <div key={p.id} className="card-lol">
                  <div className="flex items-center justify-between gap-4 flex-wrap">
                    {/* Times */}
                    <div className="flex items-center gap-3 flex-1 min-w-0">
                      <div className="text-right flex-1">
                        <p className={`font-bold ${ p.winner?.id === p.team_a?.id ? 'text-[#C8A84B]' : 'text-white' }`}>
                          [{p.team_a?.tag}] {p.team_a?.name}
                        </p>
                      </div>
                      <div className="text-center">
                        {p.status === 'finished'
                          ? <span className="text-white font-bold text-lg">{p.score_a} × {p.score_b}</span>
                          : <span className="text-gray-500 text-sm">VS</span>}
                      </div>
                      <div className="flex-1">
                        <p className={`font-bold ${ p.winner?.id === p.team_b?.id ? 'text-[#C8A84B]' : 'text-white' }`}>
                          [{p.team_b?.tag}] {p.team_b?.name}
                        </p>
                      </div>
                    </div>

                    {/* Meta */}
                    <div className="flex items-center gap-3 flex-shrink-0">
                      <div className="text-right">
                        <span className={`text-xs font-semibold px-2 py-0.5 rounded border ${STATUS_COLOR[p.status] ?? STATUS_COLOR.pending}`}>
                          {STATUS_LABEL[p.status] ?? p.status}
                        </span>
                        {fase && <p className="text-gray-500 text-xs mt-0.5">{fase.name}</p>}
                        {p.scheduled_at && p.status !== 'finished' && (
                          <p className="text-gray-500 text-xs">{new Date(p.scheduled_at).toLocaleString('pt-BR', { dateStyle: 'short', timeStyle: 'short' })}</p>
                        )}
                      </div>
                      {p.status !== 'finished' && (
                        <button onClick={() => openEdit(p)}
                          className="btn-gold text-xs px-3 py-1.5">📝 Resultado</button>
                      )}
                      {p.status !== 'finished' && (
                        <button onClick={() => handleDelete(p.id)} disabled={isPending}
                          className="bg-red-900/30 hover:bg-red-800/40 text-red-400 border border-red-700/40 rounded-lg text-xs px-2.5 py-1.5 transition-colors">🗑</button>
                      )}
                    </div>
                  </div>

                  {/* Form resultado inline */}
                  {editingId === p.id && (
                    <form onSubmit={(e) => handleResultado(e, p.id)} className="mt-4 pt-4 border-t border-[#1E3A5F] space-y-4">
                      <h3 className="text-white text-sm font-bold">📝 Lançar Resultado</h3>
                      <div className="grid grid-cols-3 gap-3">
                        <div>
                          <label className="block text-gray-400 text-xs mb-1">Placar [{p.team_a?.tag}]</label>
                          <input type="number" min={0} value={scoreA} onChange={e => setScoreA(+e.target.value)} className="input-lol w-full" required />
                        </div>
                        <div>
                          <label className="block text-gray-400 text-xs mb-1">Placar [{p.team_b?.tag}]</label>
                          <input type="number" min={0} value={scoreB} onChange={e => setScoreB(+e.target.value)} className="input-lol w-full" required />
                        </div>
                        <div>
                          <label className="block text-gray-400 text-xs mb-1">Vencedor</label>
                          <select value={winnerId} onChange={e => setWinnerId(e.target.value)} className="input-lol w-full" required>
                            <option value="">Selecionar...</option>
                            <option value={p.team_a?.id}>[{p.team_a?.tag}] {p.team_a?.name}</option>
                            <option value={p.team_b?.id}>[{p.team_b?.tag}] {p.team_b?.name}</option>
                          </select>
                        </div>
                      </div>
                      <div>
                        <label className="block text-gray-400 text-xs mb-1">Match ID Riot (opcional)</label>
                        <input value={matchRiot} onChange={e => setMatchRiot(e.target.value)} placeholder="BR1_XXXXXXXXXX" className="input-lol w-full text-sm" />
                      </div>
                      <div className="flex gap-3">
                        <button type="button" onClick={() => setEditingId(null)} className="btn-outline-gold flex-1 py-2">Cancelar</button>
                        <button type="submit" disabled={isPending} className="btn-gold flex-1 py-2">{isPending ? 'Salvando...' : '✔ Confirmar Resultado'}</button>
                      </div>
                    </form>
                  )}
                </div>
              )
            })}
          </div>
        </section>
      ))}
    </div>
  )
}
