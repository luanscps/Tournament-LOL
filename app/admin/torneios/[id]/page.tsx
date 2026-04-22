import { createClient } from "@/lib/supabase/server";
import { notFound } from "next/navigation";
import Link from "next/link";
import { TournamentForm } from "@/components/admin/TournamentForm";

export default async function AdminTorneioPorId({
  params,
}: {
  params: { id: string };
}) {
  const supabase = await createClient();
  const { data: t } = await supabase
    .from("tournaments")
    .select("*")
    .eq("id", params.id)
    .single();
  if (!t) notFound();

  const { count: totalTeams } = await supabase
    .from("tournament_teams")
    .select("*", { count: "exact", head: true })
    .eq("tournament_id", params.id);

  const { count: pendingTeams } = await supabase
    .from("tournament_teams")
    .select("*", { count: "exact", head: true })
    .eq("tournament_id", params.id)
    .eq("status", "pending");

  const STATUS_LABEL: Record<string, string> = {
    draft: "Rascunho",
    open: "Aberto",
    checkin: "Check-in",
    ongoing: "Em andamento",
    finished: "Finalizado",
  };

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-white">{t.name}</h1>
          <span className="text-xs text-gray-400">
            Status: {STATUS_LABEL[t.status] ?? t.status}
          </span>
        </div>
        <div className="flex gap-3">
          <Link
            href={"/admin/torneios/" + params.id + "/inscricoes"}
            className="bg-[#1E3A5F] hover:bg-[#C8A84B]/20 text-white hover:text-[#C8A84B] text-sm px-3 py-1.5 rounded border border-[#1E3A5F] hover:border-[#C8A84B]/30 transition-colors"
          >
            Inscricoes {pendingTeams ? "(" + pendingTeams + " pendentes)" : ""}
          </Link>
          <Link
            href={"/admin/torneios/" + params.id + "/partidas"}
            className="bg-[#1E3A5F] hover:bg-[#C8A84B]/20 text-white hover:text-[#C8A84B] text-sm px-3 py-1.5 rounded border border-[#1E3A5F] hover:border-[#C8A84B]/30 transition-colors"
          >
            Partidas
          </Link>
        </div>
      </div>

      <div className="grid grid-cols-3 gap-4">
        <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-lg p-4 text-center">
          <p className="text-3xl font-bold text-[#C8A84B]">{totalTeams ?? 0}</p>
          <p className="text-gray-400 text-xs mt-1">Times inscritos</p>
        </div>
        <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-lg p-4 text-center">
          <p className="text-3xl font-bold text-yellow-400">{pendingTeams ?? 0}</p>
          <p className="text-gray-400 text-xs mt-1">Aguardando aprovacao</p>
        </div>
        <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-lg p-4 text-center">
          <p className="text-3xl font-bold text-green-400">{t.max_teams}</p>
          <p className="text-gray-400 text-xs mt-1">Vagas totais</p>
        </div>
      </div>

      <div>
        <h2 className="text-lg font-bold text-white mb-4">Editar Torneio</h2>
        <TournamentForm
          mode="edit"
          tournamentId={params.id}
          defaultValues={{
            name: t.name,
            slug: t.slug,
            description: t.description ?? "",
            max_teams: t.max_teams,
            starts_at: t.starts_at ? t.starts_at.slice(0, 16) : "",
            status: t.status,
          }}
        />
      </div>
    </div>
  );
}
