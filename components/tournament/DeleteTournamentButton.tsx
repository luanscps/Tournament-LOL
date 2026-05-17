'use client'

import { useTransition } from 'react'

interface Props {
  tournamentId: string
  action: (id: string) => Promise<{ error: string } | { success: true }>
}

export function DeleteTournamentButton({ tournamentId, action }: Props) {
  const [pending, startTransition] = useTransition()

  function handleClick() {
    if (!confirm('Deletar este torneio permanentemente? Esta ação não pode ser desfeita.')) return
    startTransition(async () => {
      const result = await action(tournamentId)
      if (result && 'error' in result) {
        alert(`Erro ao deletar: ${result.error}`)
      }
    })
  }

  return (
    <button
      type="button"
      onClick={handleClick}
      disabled={pending}
      className="text-xs px-3 py-1.5 rounded-lg border border-red-500/40 text-red-400 hover:border-red-400 hover:bg-red-400/10 transition-colors disabled:opacity-50"
    >
      {pending ? 'Deletando...' : '🗑️ Deletar Torneio'}
    </button>
  )
}
