import { createClient } from "@/lib/supabase/server";
import { notFound } from "next/navigation";
import Link from "next/link";
import { TournamentForm } from "@/components/admin/TournamentForm";
import { GenerateBracketButton } from "@/components/admin/GenerateBracketButton";
import { DeleteTournamentButton } from "@/components/tournament/DeleteTournamentButton";
import { deleteTournamentAction } from "@/lib/actions/tournament";

export default async function AdminTournamentPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const supabase = await createClient();

  const { data: t } = await supabase
    .from("tournaments")
    .select("*")
    .eq("id", id)
    .single();
  if (!t) notFound();

  const { count: totalTeams } = await supabase
    .from("inscricoes")
    .select("*", { count: "exact", head: true })
    .eq("tournament_id", id);

  const { count: pendingTeams } = await supabase
    .from("inscricoes")
    .select("*", { count: "exact", head: true })
    .eq("tournament_id", id)
    .in("status", ["PENDING", "pending"]);

  const { count: approvedTeams } = await supabase
    .from("inscricoes")
    .select("*", { count: "exact", head: true })
    .eq("tournament_id", id)
    .in("status", ["APPROVED", "approved"]);

  const { count: checkedInTeams } = await supabase
    .from("inscricoes")
    .select("*", { count: "exact", head: true })
    .eq("tournament_id", id)
    .eq("checked_in", true);

  const { count: matchesCount } = await supabase
    .from("matches")
    .select("*", { count: "exact", head: true })
    .eq("tournament_id", id);

  const { count: stagesCount } = await supabase
    .from("tournament_stages")
    .select("*", { count: "exact", head: true })
    .eq("tournament_id", id);

  const STATUS_LABEL: Record<string, string> = {
    draft: "Rascunho", open: "Aberto", registration: "Inscrições abertas",
    checkin: "Check-in", ongoing: "Em andamento", active: "Em andamento",
    finished: "Finalizado", DRAFT: "Rascunho", OPEN: "Aberto",
    CHECKIN: "Check-in", ACTIVE: "Em andamento", IN_PROGRESS: "Em andamento",
    FINISHED: "Finalizado",
  };

  const navLinks = [
    { href: `/admin/tournaments/${id}/fases`,      label: "Fases",       badge: stagesCount  ? `(${stagesCount})`          : null },
    { href: `/admin/tournaments/${id}/inscricoes`, label: "Inscrições", badge: pendingTeams ? `(${pendingTeams} pendentes)` : null },
    { href: `/admin/tournaments/${id}/checkin`,    label: "Check-ins",   badge: checkedInTeams ? `(${checkedInTeams} ✓)`  : null },
    { href: `/admin/tournaments/${id}/partidas`,   label: "Partidas",    badge: matchesCount ? `(${matchesCount})`          : null },
    { href: t.slug ? `/torneios/${t.slug}` : `/t/${id}`, label: "Ver público ↗", badge: null, external: true },
  ];

  async function boundDeleteAction(formData: FormData) {
    "use server";
    formData.set("tournamentId", id);
    return deleteTournamentAction(formData);
  }

  return (
    <div className="space-y-8">

      {/* Header */}
      <div className="flex items-center justify-between flex-wrap gap-4">
        <div>
          <div className="mb-1">
            <Link href="/admin/tournaments" className="text-gray-400 hover:text-white text-sm">
              ← Todos os Torneios
            </Link>
          </div>
          <h1 className="text-2xl font-bold text-white">{t.name}</h1>
          <span className="text-xs text-gray-400">Status: {STATUS_LABEL[t.status] ?? t.status}</span>
        </div>
        <div className="flex gap-2 flex-wrap justify-end items-center">
          {navLinks.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              target={link.external ? "_blank" : undefined}
              rel={link.external ? "noopener noreferrer" : undefined}
              className="bg-[#1E3A5F] hover:bg-[#C8A84B]/20 text-white hover:text-[#C8A84B] text-sm px-3 py-1.5 rounded border border-[#1E3A5F] hover:border-[#C8A84B]/30 transition-colors"
            >
              {link.label}{link.badge ? ` ${link.badge}` : ""}
            </Link>
          ))}
          <DeleteTournamentButton action={boundDeleteAction} />
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
        {[
          { label: "Total inscritos", value: totalTeams   ?? 0, color: "text-white"        },
          { label: "Pendentes",       value: pendingTeams ?? 0, color: "text-yellow-400"   },
          { label: "Aprovados",       value: approvedTeams ?? 0, color: "text-green-400"  },
          { label: "Check-in feito",  value: checkedInTeams ?? 0, color: "text-blue-400" },
          { label: "Vagas totais",    value: t.max_teams,        color: "text-[#C8A84B]"  },
        ].map((s) => (
          <div key={s.label} className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-lg p-4 text-center">
            <p className={`text-2xl font-bold ${s.color}`}>{s.value}</p>
            <p className="text-xs text-gray-400 mt-1">{s.label}</p>
          </div>
        ))}
      </div>

      {/* Bracket */}
      <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-lg p-4">
        <h2 className="text-sm font-bold text-[#C8A84B] mb-1">Gerar Bracket</h2>
        <p className="text-xs text-gray-400 mb-3">
          {matchesCount && matchesCount > 0
            ? `✅ Bracket já gerado — ${matchesCount} partidas criadas`
            : `Usa times com check-in (ou todos aprovados como fallback)`}
        </p>
        <GenerateBracketButton
          tournamentId={id}
          approvedTeams={approvedTeams ?? 0}
          currentStatus={t.status}
        />
      </div>

      {/* Editar */}
      <div className="bg-[#0D1B2E] border border-[#1E3A5F] rounded-lg p-4">
        <h2 className="text-sm font-bold text-gray-400 mb-4">Editar Torneio</h2>
        <TournamentForm
          mode="edit"
          tournamentId={id}
          defaultValues={{
            name:        t.name        ?? "",
            slug:        t.slug        ?? "",
            description: t.description ?? "",
            max_teams:   t.max_teams   ?? 16,
            starts_at:   t.starts_at ? new Date(t.starts_at).toISOString().slice(0, 16) : "",
            status:      t.status     ?? "draft",
          }}
        />
      </div>

      {/* Zona de Perigo */}
      <div className="bg-red-950/20 border border-red-800/30 rounded-lg p-4">
        <h2 className="text-sm font-bold text-red-400 mb-1">⚠️ Zona de Perigo</h2>
        <p className="text-xs text-gray-500 mb-3">
          Deletar o torneio remove permanentemente todas as inscrições, partidas, fases e times vinculados.
          Esta ação não pode ser desfeita.
        </p>
        <DeleteTournamentButton action={boundDeleteAction} />
      </div>

    </div>
  );
}
