import { NextRequest, NextResponse } from "next/server";
import { rateLimit } from "@/lib/rate-limit";
import { getMatchIdsByPuuid, getMatchById } from "@/lib/riot";
const QUEUE_MAP: Record<string,number> = { RANKED_SOLO_5x5:420, RANKED_FLEX_SR:440, NORMAL_5x5_DRAFT:400, ARAM:450 };
export async function GET(req: NextRequest) {
  const ip = req.headers.get("x-forwarded-for") ?? "unknown";
  if (!rateLimit(ip, 20, 60_000)) return NextResponse.json({ error: "Rate limit" }, { status: 429 });
  const { searchParams } = new URL(req.url);
  const puuid = searchParams.get("puuid");
  const count = Math.min(parseInt(searchParams.get("count") ?? "10"), 20);
  const queueId = QUEUE_MAP[searchParams.get("queue") ?? ""];
  if (!puuid) return NextResponse.json({ error: "puuid obrigatorio" }, { status: 400 });
  try {
    const ids = await getMatchIdsByPuuid(puuid, count, queueId);
    const matches = await Promise.all(ids.slice(0, 5).map(getMatchById));
    return NextResponse.json({ ids, matches });
  } catch (err: unknown) {
    return NextResponse.json({ error: err instanceof Error ? err.message : "Erro" }, { status: 500 });
  }
}
