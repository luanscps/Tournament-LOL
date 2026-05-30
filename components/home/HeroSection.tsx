"use client";
import Link from "next/link";
import { motion } from "framer-motion";

export function HeroSection() {
  return (
    <section className="relative rounded-2xl overflow-hidden min-h-[400px] flex items-center">
      {/* Fundo: imagem do Rift */}
      <div
        className="absolute inset-0 bg-cover bg-center"
        style={{
          backgroundImage:
            "url('https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/assets/loadingscreen/summoners-rift.jpg')",
          opacity: 0.28,
        }}
      />
      {/* Gradiente overlay */}
      <div className="absolute inset-0 bg-gradient-to-r from-[#050D1A] via-[#050D1A]/90 to-transparent z-10" />
      {/* Vinheta lateral */}
      <div className="absolute inset-0 bg-gradient-to-t from-[#050D1A]/60 to-transparent z-10" />

      {/* Conteúdo */}
      <div className="relative z-20 p-8 md:p-16 max-w-2xl">
        <motion.span
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4, ease: [0.16, 1, 0.3, 1] }}
          style={{
            fontFamily: "var(--font-display)",
            fontSize: "var(--text-xs)",
            color: "var(--gold)",
            fontWeight: 700,
            letterSpacing: "0.15em",
            textTransform: "uppercase",
            display: "block",
            marginBottom: "var(--sp-3)",
          }}
        >
          Summoner's Rift · 5v5 Casual
        </motion.span>

        <motion.h1
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.55, delay: 0.08, ease: [0.16, 1, 0.3, 1] }}
          style={{
            fontFamily: "var(--font-display)",
            fontSize: "clamp(2rem, 1.2rem + 2.5vw, 3.5rem)",
            color: "var(--text)",
            fontWeight: 800,
            lineHeight: 1.1,
            marginBottom: "var(--sp-4)",
          }}
        >
          Torneios de<br />
          <span style={{ color: "var(--gold)" }}>League of Legends</span>
        </motion.h1>

        <motion.p
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.16, ease: [0.16, 1, 0.3, 1] }}
          style={{
            fontSize: "var(--text-base)",
            color: "var(--text-muted)",
            marginBottom: "var(--sp-8)",
            maxWidth: "48ch",
          }}
        >
          Cadastre seu invocador, monte seu time e dispute torneios com bracket, stats reais e ranking oficial Riot.
        </motion.p>

        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4, delay: 0.24, ease: [0.16, 1, 0.3, 1] }}
          className="flex gap-4 flex-wrap"
        >
          <Link href="/torneios" className="btn-gold text-base px-8 py-3">
            Ver Torneios
          </Link>
          <Link href="/dashboard/jogador/registrar" className="btn-outline-gold text-base px-8 py-3">
            Cadastrar Invocador
          </Link>
        </motion.div>
      </div>
    </section>
  );
}
