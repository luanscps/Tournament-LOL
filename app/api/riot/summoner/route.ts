import { NextRequest, NextResponse } from "next/server";
import { rateLimit } from "@/lib/rate-limit";
import { getAccountByRiotId, getSummonerByPuuid, getLeagueEntriesByPuuid, getTopMasteriesByPuuid } from "@/lib/riot";
export async function GET(req: NextRequest) {
  const ip = req.headers.get("x-forwarded-for") ?? "unknown";
  if (!rateLimit(ip, 30, 60_000)) return NextResponse.json({ error: "Rate limit atingido" }, { status: 429 });
  const { searchParams } = new URL(req.url);
  const riotId = searchParams.get("riotId");
  if (!riotId || !riotId.includes("#")) return NextResponse.json({ error: "Use Nome#TAG" }, { status: 400 });
  const [gameName, tagLine] = riotId.split("#");
  try {
    const account = await getAccountByRiotId(gameName, tagLine);
    const [summoner, entries, masteries] = await Promise.all([
      getSummonerByPuuid(account.puuid),
      getLeagueEntriesByPuuid(account.puuid),
      getTopMasteriesByPuuid(account.puuid, 5),
    ]);
    return NextResponse.json({ account, summoner, entries, masteries });
  } catch (err: unknown) {
    const msg = err instanceof Error ? err.message : "Erro";
    const status = msg.includes("404") ? 404 : msg.includes("429") ? 429 : 500;
    return NextResponse.json({ error: msg }, { status });
  }
}
