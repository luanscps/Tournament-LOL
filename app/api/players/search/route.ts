import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url)
  const gameName = searchParams.get('gameName')?.trim()
  const tagLine = searchParams.get('tagLine')?.trim()

  if (!gameName || !tagLine) {
    return NextResponse.json(
      { error: 'Parâmetros gameName e tagLine são obrigatórios' },
      { status: 400 }
    )
  }

  const supabase = await createClient()

  // Verifica autenticação
  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    return NextResponse.json({ error: 'Não autorizado' }, { status: 401 })
  }

  // Busca na view profiles_with_riot que já faz o join riot_accounts → profiles
  const { data, error } = await supabase
    .from('profiles_with_riot')
    .select('id, full_name, avatar_url, riot_game_name, riot_tag_line, riot_account_id, summoner_level')
    .ilike('riot_game_name', gameName)
    .ilike('riot_tag_line', tagLine)
    .eq('is_banned', false)
    .limit(1)
    .maybeSingle()

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }

  if (!data) {
    return NextResponse.json(
      { error: 'Jogador não encontrado. O jogador precisa ter uma conta registrada na plataforma.' },
      { status: 404 }
    )
  }

  // Não retorna o próprio usuário
  if (data.id === user.id) {
    return NextResponse.json(
      { error: 'Você não pode convidar a si mesmo.' },
      { status: 400 }
    )
  }

  return NextResponse.json({
    profile_id: data.id,
    full_name: data.full_name,
    avatar_url: data.avatar_url,
    riot_game_name: data.riot_game_name,
    riot_tag_line: data.riot_tag_line,
    summoner_level: data.summoner_level,
  })
}
