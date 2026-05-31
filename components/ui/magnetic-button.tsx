"use client";
import { useRef } from "react";
import { motion, useMotionValue, useSpring } from "framer-motion";

/* ─────────────────────────────────────────────────────────────────────────
   MagneticButton — PR6
   Wrapper que faz qualquer filho "atrair" o cursor.

   Props:
     strength  — intensidade do efeito (0 = sem movimento, 1 = move 50% do tamanho)
     children  — qualquer elemento React

   Uso:
     <MagneticButton strength={0.35}>
       <Link href="/torneios" className="btn-gold">Ver Torneios</Link>
     </MagneticButton>
───────────────────────────────────────────────────────────────────────── */

interface MagneticButtonProps {
  children: React.ReactNode;
  strength?: number;
  className?: string;
}

const springConfig = { stiffness: 180, damping: 18, mass: 0.5 };

export function MagneticButton({
  children,
  strength = 0.35,
  className,
}: MagneticButtonProps) {
  const ref = useRef<HTMLDivElement>(null);

  const rawX = useMotionValue(0);
  const rawY = useMotionValue(0);
  const x = useSpring(rawX, springConfig);
  const y = useSpring(rawY, springConfig);

  function handleMouseMove(e: React.MouseEvent<HTMLDivElement>) {
    if (!ref.current) return;
    const rect = ref.current.getBoundingClientRect();
    const centerX = rect.left + rect.width / 2;
    const centerY = rect.top  + rect.height / 2;
    rawX.set((e.clientX - centerX) * strength);
    rawY.set((e.clientY - centerY) * strength);
  }

  function handleMouseLeave() {
    rawX.set(0);
    rawY.set(0);
  }

  return (
    <motion.div
      ref={ref}
      style={{ x, y, display: "inline-flex" }}
      onMouseMove={handleMouseMove}
      onMouseLeave={handleMouseLeave}
      className={className}
    >
      {children}
    </motion.div>
  );
}
