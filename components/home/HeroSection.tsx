"use client";
import Link from "next/link";
import { motion } from "framer-motion";
import { BackgroundBeams } from "@/components/ui/background-beams";
import { MagneticButton } from "@/components/ui/magnetic-button";

/* ─────────────────────────────────────────────────────────────────────────
   HeroSection — PR6
   Mudanças em relação à versão anterior:
   • Meteors substituídos por BackgroundBeams (dourado, já customizado)
   • CTAs envolvidos por MagneticButton
   • Beams ficam z-0, abaixo de todos os outros layers
───────────────────────────────────────────────────────────────────────── */

export function HeroSection() {
  return (
    <section className="relative rounded-2xl overflow-hidden min-h-[420px] flex items-center">
      {/* Fundo: imagem do Rift */}
      <div
        className="absolute inset-0 bg-cover bg-center"
        style={{
          backgroundImage:
            "url('https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/assets/loadingscreen/summoners-rift.jpg')",
          opacity: 0.28,
        }}
      />

      {/* Background Beams — z-0, atrás de tudo */}
      <BackgroundBeams className="z-0" />

      {/* Gradientes — z-10 */}
      <div className="absolute inset-0 bg-gradient-to-r from-[#050D1A] via-[#050D1A]/90 to-transparent z-10" />
      <div className="absolute inset-0 bg-gradient-to-t from-[#050D1A]/60 to-transparent z-10" />

      {/* Conteúdo — z-20 */}
      <div className="relative z-20 p-8 md:p-16 max-w-2xl">
        <motion.span
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4, ease: [0.16, 1, 0.3, 1] }}
          className="block mb-3 text-xs font-bold tracking-[0.15em] uppercase"
          style={{ color: "var(--gold)" }}
        >
          Summoner&apos;s Rift · 5v5 Casual
        </motion.span>

        <motion.h1
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.55, delay: 0.08, ease: [0.16, 1, 0.3, 1] }}
          className="font-extrabold leading-[1.1] mb-4"
          style={{
            fontFamily: "var(--font-display)",
            fontSize: "clamp(2rem, 1.2rem + 2.5vw, 3.5rem)",
            color: "var(--text)",
          }}
        >
          Torneios de<br />
          <span style={{ color: "var(--gold)" }}>League of Legends</span>
        </motion.h1>

        <motion.p
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.16, ease: [0.16, 1, 0.3, 1] }}
          className="mb-8"
          style={{
            fontSize: "var(--text-base)",
            color: "var(--text-muted)",
            maxWidth: "48ch",
          }}
        >
          Cadastre seu invocador, monte seu time e dispute torneios com
          bracket, stats reais e ranking oficial Riot.
        </motion.p>

        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4, delay: 0.24, ease: [0.16, 1, 0.3, 1] }}
          className="flex gap-4 flex-wrap"
        >
          {/* CTA primário — Magnetic com strength padrão */}
          <MagneticButton strength={0.35}>
            <Link href="/torneios" className="btn-gold text-base px-8 py-3">
              Ver Torneios
            </Link>
          </MagneticButton>

          {/* CTA secundário — Magnetic mais suave */}
          <MagneticButton strength={0.22}>
            <Link
              href="/dashboard/jogador/registrar"
              className="btn-outline-gold text-base px-8 py-3"
            >
              Cadastrar Invocador
            </Link>
          </MagneticButton>
        </motion.div>
      </div>
    </section>
  );
}
