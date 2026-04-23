import { NextRequest, NextResponse } from "next/server";
import { rateLimit } from "@/lib/rate-limit";
import {
  getAccountByRiotId,
  getSummonerByPuuid,
  getLeagueEntriesByPuuid,
  getTopMasteriesByPuuid,
} from "@/lib/riot";

export async function GET(req: NextRequest) {
  // Verifica chave antes de qualquer coisa
  if (!process.env.RIOT_API_KEY) {
    return NextResponse.json(
      { error: "Servidor não configurado: RIOT_API_KEY ausente no .env.local" },
      { status: 500 }
    );
  }

  const ip = req.headers.get("x-forwarded-for") ?? "unknown";
  if (!rateLimit(ip, 30, 60_000)) {
    return NextResponse.json({ error: "Rate limit atingido. Tente em 1 minuto." }, { status: 429 });
  }

  const { searchParams } = new URL(req.url);
  const riotId = searchParams.get("riotId");

  if (!riotId || !riotId.includes("#")) {
    return NextResponse.json({ error: "Use o formato Nome#TAG" }, { status: 400 });
  }

  const hashIndex = riotId.indexOf("#");
  const gameName  = riotId.slice(0, hashIndex);
  const tagLine   = riotId.slice(hashIndex + 1);

  if (!gameName || !tagLine) {
    return NextResponse.json({ error: "Nome ou TAG inválidos" }, { status: 400 });
  }

  try {
    const account = await getAccountByRiotId(gameName, tagLine);

    const [summoner, entries, masteries] = await Promise.all([
      getSummonerByPuuid(account.puuid),
      getLeagueEntriesByPuuid(account.puuid),
      getTopMasteriesByPuuid(account.puuid, 5),
    ]);

    return NextResponse.json({ account, summoner, entries, masteries });
  } catch (err: unknown) {
    const msg = err instanceof Error ? err.message : "Erro desconhecido";
    console.error("[/api/riot/summoner]", msg);

    // Mapeia status de erro da Riot para respostas claras ao frontend
    if (msg.includes("403")) {
      return NextResponse.json(
        { error: "Chave Riot API inválida ou expirada. Renove em developer.riotgames.com" },
        { status: 403 }
      );
    }
    if (msg.includes("404")) {
      return NextResponse.json(
        { error: "Jogador não encontrado. Verifique o Nome#TAG" },
        { status: 404 }
      );
    }
    if (msg.includes("429")) {
      return NextResponse.json(
        { error: "Limite da Riot API atingido. Aguarde alguns segundos." },
        { status: 429 }
      );
    }
    if (msg.includes("RIOT_API_KEY")) {
      return NextResponse.json({ error: msg }, { status: 500 });
    }

    return NextResponse.json({ error: msg }, { status: 500 });
  }
}