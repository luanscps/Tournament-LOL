// app/api/player/refresh-rank/route.ts
import { NextRequest, NextResponse } from 'next/server'
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'
import {
  getSummonerByPuuid,
  getLeagueEntriesByPuuid,
  getTopMasteriesByPuuid,
} from '@/lib/riot'

export async function POST(req: NextRequest) {
  // 1. Validação da chave Riot antes de qualquer operação
  if (!process.env.RIOT_API_KEY) {
    return NextResponse.json(
      { error: 'Servidor não configurado: RIOT_API_KEY ausente.' },
      { status: 500 }
    )
  }

  // 2. Criar cliente Supabase server-side com cookies (padrão SSR)
  const cookieStore = await cookies()
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll()
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            )
          } catch {}
        },
      },
    }
  )

  // 3. Verificar sessão autenticada
  const {
    data: { user },
    error: authError,
  } = await supabase.auth.getUser()

  if (authError || !user) {
    return NextResponse.json(
      { error: 'Não autenticado.' },
      { status: 401 }
    )
  }

  // 4. Buscar a conta Riot primária do usuário
  const { data: riotAccount, error: riotErr } = await supabase
    .from('riotaccounts')
    .select('id, puuid, gamename, tagline')
    .eq('profileid', user.id)
    .eq('isprimary', true)
    .single()

  if (riotErr || !riotAccount) {
    return NextResponse.json(
      { error: 'Conta Riot não vinculada. Acesse /dashboard/jogador/registrar.' },
      { status: 404 }
    )
  }

  // 5. Buscar dados atualizados na Riot API
  try {
    const [summoner, entries, masteries] = await Promise.all([
      getSummonerByPuuid(riotAccount.puuid),
      getLeagueEntriesByPuuid(riotAccount.puuid),
      getTopMasteriesByPuuid(riotAccount.puuid, 5),
    ])

    // 6. Atualizar dados da conta Riot (summonerlevel, profileiconid)
    const { error: updateErr } = await supabase
      .from('riotaccounts')
      .update({
        summonerlevel: summoner.summonerLevel,
        profileiconid: summoner.profileIconId,
        updatedat: new Date().toISOString(),
      })
      .eq('id', riotAccount.id)

    if (updateErr) {
      console.error('refresh-rank: erro ao atualizar riotaccounts', updateErr.message)
    }

    // 7. Inserir novo snapshot de rank (histórico acumulado)
    if (entries.length > 0) {
      const snapshots = entries.map((entry) => ({
        riotaccountid: riotAccount.id,
        queuetype: entry.queueType,
        tier: entry.tier,
        rank: entry.rank,
        lp: entry.leaguePoints,
        wins: entry.wins,
        losses: entry.losses,
        hotstreak: entry.hotStreak,
        // snapshottedat usa DEFAULT now() do banco
      }))

      const { error: snapErr } = await supabase
        .from('ranksnapshots')
        .insert(snapshots)

      if (snapErr) {
        console.error('refresh-rank: erro ao inserir ranksnapshots', snapErr.message)
      }
    }

    // 8. Atualizar masteries (upsert pelo par riotaccountid + championid)
    if (masteries.length > 0) {
      const masteriesPayload = masteries.map((m) => ({
        riotaccountid: riotAccount.id,
        championid: m.championId,
        championname: m.championName,
        masterylevel: m.championLevel,
        masterypoints: m.championPoints,
        lastplaytime: m.lastPlayTime
          ? new Date(m.lastPlayTime).toISOString()
          : null,
        updatedat: new Date().toISOString(),
      }))

      const { error: mastErr } = await supabase
        .from('championmasteries')
        .upsert(masteriesPayload, { onConflict: 'riotaccountid,championid' })

      if (mastErr) {
        console.error('refresh-rank: erro ao upsert championmasteries', mastErr.message)
      }
    }

    return NextResponse.json({
      ok: true,
      summoner: {
        summonerLevel: summoner.summonerLevel,
        profileIconId: summoner.profileIconId,
      },
      entries,
      masteriesCount: masteries.length,
    })
  } catch (err: unknown) {
    const msg = err instanceof Error ? err.message : 'Erro desconhecido'
    console.error('refresh-rank:', msg)

    if (msg.includes('403'))
      return NextResponse.json(
        { error: 'Chave Riot API inválida ou expirada. Renove em developer.riotgames.com' },
        { status: 403 }
      )
    if (msg.includes('404'))
      return NextResponse.json(
        { error: 'Jogador não encontrado na Riot API.' },
        { status: 404 }
      )
    if (msg.includes('429'))
      return NextResponse.json(
        { error: 'Rate limit da Riot API atingido. Aguarde alguns segundos.' },
        { status: 429 }
      )

    return NextResponse.json({ error: msg }, { status: 500 })
  }
}