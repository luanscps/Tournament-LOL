import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { TournamentCard } from "@/components/tournament/TournamentCard";
import { StatsSection } from "@/components/home/StatsSection";
import { HowItWorks } from "@/components/home/HowItWorks";
import { HeroSection } from "@/components/home/HeroSection";

export default async function HomePage() {
  const supabase = await createClient();

  const { data: tournaments } = await supabase
    .from("tournaments")
    .select("*")
    .in("status", ["OPEN", "IN_PROGRESS", "CHECKIN"])
    .order("starts_at", { ascending: true })
    .limit(6);

  const { count: totalPlayers } = await supabase
    .from("riot_accounts")
    .select("*", { count: "exact", head: true });

  const { count: totalTeams } = await supabase
    .from("teams")
    .select("*", { count: "exact", head: true });

  const { count: totalT } = await supabase
    .from("tournaments")
    .select("*", { count: "exact", head: true });

  return (
    <div className="space-y-16">
      {/* Hero — Client Component com Framer Motion */}
      <HeroSection />

      {/* Stats — Client Component com stagger animation */}
      <StatsSection
        totalPlayers={totalPlayers ?? 0}
        totalTeams={totalTeams ?? 0}
        totalTournaments={totalT ?? 0}
      />

      {/* Como funciona — Client Component com stagger animation */}
      <HowItWorks />

      {/* Torneios Ativos */}
      <section>
        <div className="flex items-center justify-between mb-6">
          <h2
            style={{
              fontFamily: "var(--font-display)",
              fontSize: "var(--text-xl)",
              color: "var(--text)",
            }}
          >
            Torneios Ativos
          </h2>
          <Link
            href="/torneios"
            style={{ color: "var(--gold)", fontSize: "var(--text-sm)" }}
            className="hover:underline transition-opacity"
          >
            Ver todos →
          </Link>
        </div>

        {tournaments && tournaments.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {tournaments.map((t) => (
              <TournamentCard key={t.id} tournament={t} />
            ))}
          </div>
        ) : (
          <div className="card text-center py-16">
            <div
              className="mx-auto mb-4 flex items-center justify-center animate-float"
              style={{
                width: 56,
                height: 56,
                borderRadius: "var(--radius-xl)",
                background: "var(--gold-dim)",
                border: "1px solid var(--border-gold)",
                color: "var(--gold)",
                fontSize: 28,
              }}
            >
              🏆
            </div>
            <p
              style={{
                fontFamily: "var(--font-display)",
                fontSize: "var(--text-lg)",
                color: "var(--text)",
                fontWeight: 700,
                marginBottom: "var(--sp-2)",
              }}
            >
              Nenhum torneio ativo no momento
            </p>
            <p
              style={{
                fontSize: "var(--text-sm)",
                color: "var(--text-muted)",
                marginBottom: "var(--sp-6)",
              }}
            >
              Em breve novos torneios serão abertos para inscrição.
            </p>
            <Link href="/torneios" className="btn-outline-gold">
              Ver todos os torneios
            </Link>
          </div>
        )}
      </section>
    </div>
  );
}
