import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { getLeagueEntriesByPuuid } from "@/lib/riot";
export async function POST(req: NextRequest) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Nao autenticado" }, { status: 401 });
  const { puuid } = await req.json();
  if (!puuid) return NextResponse.json({ error: "puuid obrigatorio" }, { status: 400 });
  const { data: account } = await supabase.from("riot_accounts").select("id").eq("puuid", puuid).eq("profile_id", user.id).single();
  if (!account) return NextResponse.json({ error: "Conta nao encontrada" }, { status: 404 });
  try {
    const entries = await getLeagueEntriesByPuuid(puuid);
    for (const e of entries) {
      await supabase.from("rank_snapshots").insert({ riot_account_id: account.id, queue_type: e.queueType, tier: e.tier, rank: e.rank, lp: e.leaguePoints, wins: e.wins, losses: e.losses, hot_streak: e.hotStreak });
    }
    return NextResponse.json({ success: true, updated: entries.length });
  } catch (err: unknown) {
    return NextResponse.json({ error: err instanceof Error ? err.message : "Erro" }, { status: 500 });
  }
}
