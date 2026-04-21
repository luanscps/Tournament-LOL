import { NextRequest, NextResponse } from "next/server";
import { getMatchById } from "@/lib/riot";
export async function GET(_req: NextRequest, { params }: { params: { matchId: string } }) {
  try {
    return NextResponse.json(await getMatchById(params.matchId));
  } catch (err: unknown) {
    return NextResponse.json({ error: err instanceof Error ? err.message : "Erro" }, { status: 500 });
  }
}
