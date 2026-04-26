import { NextRequest, NextResponse } from "next/server";

export async function GET(req: NextRequest) {
  const gameName = req.nextUrl.searchParams.get("gameName");
  const tagLine  = req.nextUrl.searchParams.get("tagLine");
  const RIOT_KEY = process.env.RIOT_API_KEY;

  if (!gameName || !tagLine) {
    return NextResponse.json(
      { error: "Parâmetros inválidos. Informe gameName e tagLine." },
      { status: 400 }
    );
  }

  if (!RIOT_KEY) {
    return NextResponse.json(
      { error: "Riot API Key não configurada no servidor." },
      { status: 500 }
    );
  }

  try {
    // 1. Busca PUUID via Account API (regional: americas)
    const accountRes = await fetch(
      `https://americas.api.riotgames.com/riot/account/v1/accounts/by-riot-id/${encodeURIComponent(gameName)}/${encodeURIComponent(tagLine)}`,
      {
        headers: { "X-Riot-Token": RIOT_KEY },
        next: { revalidate: 300 },
      }
    );

    if (!accountRes.ok) {
      const body = await accountRes.json().catch(() => ({}));
      return NextResponse.json(
        { error: body?.status?.message ?? "Conta Riot não encontrada" },
        { status: 404 }
      );
    }

    const account = await accountRes.json();

    // 2. Busca dados do summoner via PUUID (servidor: br1)
    const summonerRes = await fetch(
      `https://br1.api.riotgames.com/lol/summoner/v4/summoners/by-puuid/${account.puuid}`,
      {
        headers: { "X-Riot-Token": RIOT_KEY },
        next: { revalidate: 300 },
      }
    );
    const summoner = summonerRes.ok ? await summonerRes.json() : null;

    // 3. Busca rank soloqueue
    let rankData: any = null;
    if (summoner?.id) {
      const rankRes = await fetch(
        `https://br1.api.riotgames.com/lol/league/v4/entries/by-summoner/${summoner.id}`,
        {
          headers: { "X-Riot-Token": RIOT_KEY },
          next: { revalidate: 300 },
        }
      );
      if (rankRes.ok) {
        const ranks: any[] = await rankRes.json();
        rankData = ranks.find((r) => r.queueType === "RANKED_SOLO_5x5") ?? null;
      }
    }

    return NextResponse.json({
      puuid:         account.puuid,
      gameName:      account.gameName,
      tagLine:       account.tagLine,
      profileIconId: summoner?.profileIconId ?? null,
      summonerLevel: summoner?.summonerLevel ?? null,
      tier:          rankData?.tier ?? "UNRANKED",
      rank:          rankData?.rank ?? "",
      lp:            rankData?.leaguePoints ?? 0,
      wins:          rankData?.wins ?? 0,
      losses:        rankData?.losses ?? 0,
    });
  } catch (err: any) {
    return NextResponse.json(
      { error: err.message ?? "Erro interno" },
      { status: 500 }
    );
  }
}
