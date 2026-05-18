'use client'

import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { X, Search, UserPlus, Loader2, CheckCircle2, AlertCircle } from 'lucide-react'

const searchSchema = z.object({
  gameName: z.string().min(1, 'Informe o nome do invocador'),
  tagLine: z.string().min(1, 'Informe a tag').max(5),
})

const inviteSchema = z.object({
  role: z.enum(['TOP', 'JUNGLE', 'MID', 'ADC', 'SUPPORT', '']).optional(),
  is_reserve: z.boolean().optional(),
  message: z.string().max(300).optional(),
})

type SearchForm = z.infer<typeof searchSchema>
type InviteForm = z.infer<typeof inviteSchema>

type PlayerResult = {
  profile_id: string
  full_name: string | null
  avatar_url: string | null
  riot_game_name: string
  riot_tag_line: string
  summoner_level: number | null
}

interface Props {
  teamId: string
  teamName: string
  onClose: () => void
  onSuccess?: () => void
}

export function InviteMemberModal({ teamId, teamName, onClose, onSuccess }: Props) {
  const [playerResult, setPlayerResult] = useState<PlayerResult | null>(null)
  const [searchError, setSearchError] = useState<string | null>(null)
  const [isSearching, setIsSearching] = useState(false)
  const [isInviting, setIsInviting] = useState(false)
  const [inviteSent, setInviteSent] = useState(false)
  const [inviteError, setInviteError] = useState<string | null>(null)

  const searchForm = useForm<SearchForm>({
    resolver: zodResolver(searchSchema),
    defaultValues: { gameName: '', tagLine: 'BR1' },
  })

  const inviteForm = useForm<InviteForm>({
    resolver: zodResolver(inviteSchema),
    defaultValues: { role: '', is_reserve: false, message: '' },
  })

  async function handleSearch(values: SearchForm) {
    setIsSearching(true)
    setSearchError(null)
    setPlayerResult(null)
    setInviteSent(false)
    setInviteError(null)

    try {
      const res = await fetch(
        `/api/players/search?gameName=${encodeURIComponent(values.gameName)}&tagLine=${encodeURIComponent(values.tagLine)}`
      )
      const json = await res.json()
      if (!res.ok) {
        setSearchError(json.error ?? 'Erro ao buscar jogador')
        return
      }
      setPlayerResult(json)
    } catch {
      setSearchError('Erro de conexão. Tente novamente.')
    } finally {
      setIsSearching(false)
    }
  }

  async function handleInvite(values: InviteForm) {
    if (!playerResult) return
    setIsInviting(true)
    setInviteError(null)

    try {
      const res = await fetch('/api/teams/invite', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          team_id: teamId,
          invited_profile_id: playerResult.profile_id,
          role: values.role || null,
          is_reserve: values.is_reserve ?? false,
          message: values.message || null,
        }),
      })
      const json = await res.json()
      if (!res.ok) {
        setInviteError(json.error ?? 'Erro ao enviar convite')
        return
      }
      setInviteSent(true)
      onSuccess?.()
    } catch {
      setInviteError('Erro de conexão. Tente novamente.')
    } finally {
      setIsInviting(false)
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4">
      <div className="relative w-full max-w-md rounded-2xl bg-zinc-900 border border-zinc-700 p-6 shadow-2xl">
        <button
          onClick={onClose}
          className="absolute right-4 top-4 text-zinc-400 hover:text-white transition-colors"
        >
          <X className="h-5 w-5" />
        </button>

        <h2 className="mb-1 text-lg font-bold text-white">Convidar Jogador</h2>
        <p className="mb-5 text-sm text-zinc-400">Time: <span className="text-blue-400 font-medium">{teamName}</span></p>

        {/* Etapa 1: Busca por Riot ID */}
        {!inviteSent && (
          <form onSubmit={searchForm.handleSubmit(handleSearch)} className="mb-4">
            <label className="mb-1.5 block text-xs font-medium text-zinc-300">Riot ID do jogador</label>
            <div className="flex gap-2">
              <input
                {...searchForm.register('gameName')}
                placeholder="NomeInvocador"
                className="flex-1 rounded-lg bg-zinc-800 border border-zinc-600 px-3 py-2 text-sm text-white placeholder-zinc-500 focus:outline-none focus:border-blue-500"
              />
              <span className="flex items-center text-zinc-400 text-sm">#</span>
              <input
                {...searchForm.register('tagLine')}
                placeholder="BR1"
                className="w-20 rounded-lg bg-zinc-800 border border-zinc-600 px-3 py-2 text-sm text-white placeholder-zinc-500 focus:outline-none focus:border-blue-500"
              />
              <button
                type="submit"
                disabled={isSearching}
                className="flex items-center gap-1.5 rounded-lg bg-blue-600 hover:bg-blue-500 disabled:opacity-50 px-3 py-2 text-sm font-medium text-white transition-colors"
              >
                {isSearching ? <Loader2 className="h-4 w-4 animate-spin" /> : <Search className="h-4 w-4" />}
                Buscar
              </button>
            </div>
            {searchForm.formState.errors.gameName && (
              <p className="mt-1 text-xs text-red-400">{searchForm.formState.errors.gameName.message}</p>
            )}
            {searchError && (
              <div className="mt-2 flex items-center gap-2 rounded-lg bg-red-900/30 border border-red-700/50 px-3 py-2">
                <AlertCircle className="h-4 w-4 shrink-0 text-red-400" />
                <p className="text-xs text-red-300">{searchError}</p>
              </div>
            )}
          </form>
        )}

        {/* Resultado da busca */}
        {playerResult && !inviteSent && (
          <>
            <div className="mb-4 flex items-center gap-3 rounded-xl bg-zinc-800 border border-zinc-600 p-3">
              {playerResult.avatar_url ? (
                <img src={playerResult.avatar_url} alt="" className="h-10 w-10 rounded-full object-cover" />
              ) : (
                <div className="h-10 w-10 rounded-full bg-zinc-700 flex items-center justify-center text-zinc-400 text-sm font-bold">
                  {(playerResult.riot_game_name?.[0] ?? '?').toUpperCase()}
                </div>
              )}
              <div>
                <p className="text-sm font-semibold text-white">
                  {playerResult.riot_game_name}
                  <span className="text-zinc-400 font-normal">#{playerResult.riot_tag_line}</span>
                </p>
                {playerResult.full_name && (
                  <p className="text-xs text-zinc-400">{playerResult.full_name}</p>
                )}
                {playerResult.summoner_level && (
                  <p className="text-xs text-zinc-500">Nível {playerResult.summoner_level}</p>
                )}
              </div>
            </div>

            <form onSubmit={inviteForm.handleSubmit(handleInvite)} className="space-y-3">
              <div>
                <label className="mb-1 block text-xs font-medium text-zinc-300">Rota (opcional)</label>
                <select
                  {...inviteForm.register('role')}
                  className="w-full rounded-lg bg-zinc-800 border border-zinc-600 px-3 py-2 text-sm text-white focus:outline-none focus:border-blue-500"
                >
                  <option value="">Sem rota definida</option>
                  <option value="TOP">Top</option>
                  <option value="JUNGLE">Jungle</option>
                  <option value="MID">Mid</option>
                  <option value="ADC">ADC</option>
                  <option value="SUPPORT">Support</option>
                </select>
              </div>

              <div className="flex items-center gap-2">
                <input
                  type="checkbox"
                  id="is_reserve"
                  {...inviteForm.register('is_reserve')}
                  className="h-4 w-4 rounded accent-blue-500"
                />
                <label htmlFor="is_reserve" className="text-xs text-zinc-300">Convidar como reserva</label>
              </div>

              <div>
                <label className="mb-1 block text-xs font-medium text-zinc-300">Mensagem (opcional)</label>
                <textarea
                  {...inviteForm.register('message')}
                  rows={2}
                  maxLength={300}
                  placeholder="Ex: Precisamos de um top laner para o próximo torneio!"
                  className="w-full rounded-lg bg-zinc-800 border border-zinc-600 px-3 py-2 text-sm text-white placeholder-zinc-500 focus:outline-none focus:border-blue-500 resize-none"
                />
              </div>

              {inviteError && (
                <div className="flex items-center gap-2 rounded-lg bg-red-900/30 border border-red-700/50 px-3 py-2">
                  <AlertCircle className="h-4 w-4 shrink-0 text-red-400" />
                  <p className="text-xs text-red-300">{inviteError}</p>
                </div>
              )}

              <button
                type="submit"
                disabled={isInviting}
                className="flex w-full items-center justify-center gap-2 rounded-lg bg-blue-600 hover:bg-blue-500 disabled:opacity-50 py-2.5 text-sm font-semibold text-white transition-colors"
              >
                {isInviting ? <Loader2 className="h-4 w-4 animate-spin" /> : <UserPlus className="h-4 w-4" />}
                Enviar Convite
              </button>
            </form>
          </>
        )}

        {/* Sucesso */}
        {inviteSent && (
          <div className="flex flex-col items-center gap-3 py-4 text-center">
            <CheckCircle2 className="h-12 w-12 text-green-400" />
            <p className="text-base font-semibold text-white">Convite enviado!</p>
            <p className="text-sm text-zinc-400">
              <span className="text-blue-400 font-medium">
                {playerResult?.riot_game_name}#{playerResult?.riot_tag_line}
              </span>{' '}
              receberá uma notificação e tem 7 dias para responder.
            </p>
            <button
              onClick={onClose}
              className="mt-2 rounded-lg bg-zinc-700 hover:bg-zinc-600 px-5 py-2 text-sm font-medium text-white transition-colors"
            >
              Fechar
            </button>
          </div>
        )}
      </div>
    </div>
  )
}
