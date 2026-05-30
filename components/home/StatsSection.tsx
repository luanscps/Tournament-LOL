"use client";
import { motion } from "framer-motion";
import { Users, Shield, Trophy, Map } from "lucide-react";

interface Stat {
  label: string;
  value: number | string;
  icon: React.ReactNode;
}

interface StatsSectionProps {
  totalPlayers: number;
  totalTeams: number;
  totalTournaments: number;
}

const container = {
  hidden: {},
  show: { transition: { staggerChildren: 0.08 } },
};

const item = {
  hidden: { opacity: 0, y: 24 },
  show: {
    opacity: 1,
    y: 0,
    transition: { duration: 0.45, ease: [0.16, 1, 0.3, 1] },
  },
};

export function StatsSection({
  totalPlayers,
  totalTeams,
  totalTournaments,
}: StatsSectionProps) {
  const stats: Stat[] = [
    { label: "Invocadores", value: totalPlayers,    icon: <Users   size={22} /> },
    { label: "Times",       value: totalTeams,      icon: <Shield  size={22} /> },
    { label: "Torneios",    value: totalTournaments, icon: <Trophy  size={22} /> },
    { label: "Mapa",        value: "SR 5v5",        icon: <Map     size={22} /> },
  ];

  return (
    <motion.section
      variants={container}
      initial="hidden"
      whileInView="show"
      viewport={{ once: true, margin: "-60px" }}
      className="grid grid-cols-2 md:grid-cols-4 gap-4"
    >
      {stats.map((s) => (
        <motion.div
          key={s.label}
          variants={item}
          className="card text-center py-6 cursor-default"
          whileHover={{ y: -4, transition: { duration: 0.2 } }}
        >
          <div
            className="mx-auto mb-3 flex items-center justify-center"
            style={{
              width: 44,
              height: 44,
              borderRadius: "var(--radius-md)",
              background: "var(--gold-dim)",
              border: "1px solid var(--border-gold)",
              color: "var(--gold)",
            }}
          >
            {s.icon}
          </div>
          <p
            className="font-bold tabular-nums"
            style={{
              fontFamily: "var(--font-display)",
              fontSize: "var(--text-xl)",
              color: "var(--gold)",
              lineHeight: 1.1,
            }}
          >
            {s.value}
          </p>
          <p
            style={{
              fontSize: "var(--text-sm)",
              color: "var(--text-muted)",
              marginTop: "var(--sp-1)",
            }}
          >
            {s.label}
          </p>
        </motion.div>
      ))}
    </motion.section>
  );
}
