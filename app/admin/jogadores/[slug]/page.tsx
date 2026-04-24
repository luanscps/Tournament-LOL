import React from "react";
import { notFound } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";

async function getJogador(id: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("players")
    .select(`
      id, summoner_name, tag_line, role, tier, rank, lp,
      wins, losses, puuid, created_at,
      team_id,
      teams ( id, name, tag )
    `)
    .eq("id", id)
    .single();
  if (error || !data) return null;
  return data;
}

const TIER_COLORS: Record<string, string> = {
  CHALLENGER:  "text-yellow-300",
  GRANDMASTER: "text-red-400",
  MASTER:      "text-purple-400",
  DIAMOND:     "text-blue-400",
  EMERALD:     "text-emerald-400",
  PLATINUM:    "text-teal-400",
  GOLD:        "text-yellow-500",
  SILVER:      "text-gray-400",
  BRONZE:      "text-orange-700",
  IRON:        "text-gray-500",
  UNRANKED:    "text-gray-600",
};

export default async function AdminJogadorDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  // slug aqui ainda é o UUID do player (busca segura por id)
  const { slug } = await params;
  const j = await getJogador(slug);
  if (!j) return notFound();

  const total = (j.wins ?? 0) + (j.losses ?? 0);
  const wr    = total > 0 ? Math.round(((j.wins ?? 0) / total) * 100) : 0;
  const tier  = (j.tier ?? "UNRANKED") as string;

  return (
    <div className="p-6 max-w-2xl">
      <div className="flex items-center gap-2 mb-6">
        <Link href="/admin/jogadores" className="text-gray-400 hover:text-white text-sm">
          ← Jogadores
        </Link>
        <span className="text-gray-600">/</span>
        <span className="text-white text-sm">{j.summoner_name}</span>
      </div>

      <h1 className="text-2xl font-bold text-white mb-1">
        {j.summoner_name}
        <span className="text-gray-400 font-normal text-base ml-1">#{j.tag_line}</span>
      </h1>
      <p className="text-gray-500 text-xs mb-6">ID: {j.id}</p>

      <div className="bg-[#0A1628] border border-[#1E3A5F] rounded-xl p-5 space-y-4">
        <div className="grid grid-cols-2 gap-4">
          <div>
            <p className="text-gray-500 text-xs mb-1">Papel</p>
            <p className="text-white font-medium">{j.role || "—"}</p>
          </div>
          <div>
            <p className="text-gray-500 text-xs mb-1">Time</p>
            {j.teams ? (
              // Link para o time usa o id do time (ainda sem slug real em teams)
              <Link href={`/times/${(j.teams as any).id}`} className="text-blue-400 hover:underline font-medium">
                [{(j.teams as any).tag}] {(j.teams as any).name}
              </Link>
            ) : (
              <span className="text-gray-500">Sem time</span>
            )}
          </div>
          <div>
            <p className="text-gray-500 text-xs mb-1">Elo</p>
            <p className={`font-bold ${TIER_COLORS[tier] ?? "text-gray-400"}`}>
              {tier} {j.rank ?? ""}
            </p>
          </div>
          <div>
            <p className="text-gray-500 text-xs mb-1">LP</p>
            <p className="text-white font-medium">{j.lp ?? 0}</p>
          </div>
          <div>
            <p className="text-gray-500 text-xs mb-1">Vitórias / Derrotas</p>
            <p className="text-white font-medium">
              <span className="text-green-400">{j.wins ?? 0}W</span>
              {" "}
              <span className="text-red-400">{j.losses ?? 0}L</span>
              {" "}
              <span className="text-gray-400 text-xs">({wr}% WR)</span>
            </p>
          </div>
          <div>
            <p className="text-gray-500 text-xs mb-1">PUUID</p>
            <p className="text-gray-400 text-xs font-mono truncate" title={j.puuid ?? ""}>
              {j.puuid ? j.puuid.slice(0, 20) + "…" : "—"}
            </p>
          </div>
        </div>
      </div>

      <div className="mt-4">
        <Link href="/admin/jogadores" className="text-gray-400 hover:text-white text-sm">
          ← Voltar para Jogadores
        </Link>
      </div>
    </div>
  );
}
