"use client";
import { useState, useCallback } from "react";
import { motion, AnimatePresence } from "framer-motion";
import Link, { LinkProps } from "next/link";
import { cn } from "@/lib/utils";

/* ─────────────────────────────────────────────────────────────────────────
   StatefulButton — PR5
   Estados: idle | loading | success | error
   Variantes: primary | outline | ghost
   Uso:
     <StatefulButton variant="primary" onClickAsync={handleSubmit}>
       Criar Torneio
     </StatefulButton>
───────────────────────────────────────────────────────────────────────── */

export type ButtonState = "idle" | "loading" | "success" | "error";
export type ButtonVariant = "primary" | "outline" | "ghost";

interface StatefulButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  state?: ButtonState;                // controlado externamente (opcional)
  onClickAsync?: () => Promise<void>; // modo autogerenciado
  resetDelay?: number;                // ms para voltar ao idle após success/error
  successLabel?: string;
  errorLabel?: string;
  loadingLabel?: string;
  size?: "sm" | "md" | "lg";
}

const variantClass: Record<ButtonVariant, string> = {
  primary: "btn-gold",
  outline: "btn-outline-gold",
  ghost:
    "inline-flex items-center justify-center gap-2 px-6 py-2.5 rounded-[var(--radius-md)] text-[var(--text-muted)] font-semibold text-[length:var(--text-sm)] border border-transparent hover:border-[var(--border)] hover:text-[var(--text)] transition-colors",
};

const sizeClass: Record<string, string> = {
  sm: "!px-4 !py-1.5 !text-[length:var(--text-xs)]",
  md: "",
  lg: "!px-8 !py-3 !text-[length:var(--text-base)]",
};

// Spinner SVG animado
function Spinner() {
  return (
    <svg
      className="animate-spin"
      width="16"
      height="16"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2.5"
      aria-hidden="true"
    >
      <circle cx="12" cy="12" r="10" strokeOpacity="0.25" />
      <path d="M12 2a10 10 0 0 1 10 10" strokeLinecap="round" />
    </svg>
  );
}

// Ícone de check
function CheckIcon() {
  return (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <polyline points="20 6 9 17 4 12" />
    </svg>
  );
}

// Ícone de erro
function XIcon() {
  return (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <line x1="18" y1="6" x2="6" y2="18" />
      <line x1="6" y1="6" x2="18" y2="18" />
    </svg>
  );
}

export function StatefulButton({
  variant = "primary",
  state: externalState,
  onClickAsync,
  resetDelay = 2500,
  successLabel = "Feito!",
  errorLabel = "Erro — tente novamente",
  loadingLabel = "Aguarde...",
  size = "md",
  children,
  onClick,
  disabled,
  className,
  ...rest
}: StatefulButtonProps) {
  const [internalState, setInternalState] = useState<ButtonState>("idle");
  const activeState = externalState ?? internalState;

  const handleClick = useCallback(
    async (e: React.MouseEvent<HTMLButtonElement>) => {
      if (activeState !== "idle") return;

      // modo manual: delega para onClick pai
      if (onClick && !onClickAsync) {
        onClick(e);
        return;
      }

      // modo autogerenciado via onClickAsync
      if (onClickAsync) {
        setInternalState("loading");
        try {
          await onClickAsync();
          setInternalState("success");
        } catch {
          setInternalState("error");
        } finally {
          setTimeout(() => setInternalState("idle"), resetDelay);
        }
      }
    },
    [activeState, onClick, onClickAsync, resetDelay]
  );

  const isLoading = activeState === "loading";
  const isSuccess = activeState === "success";
  const isError   = activeState === "error";
  const isDisabled = disabled || isLoading || isSuccess;

  // Label e ícone conforme estado
  const content = (() => {
    if (isLoading) return <><Spinner />{loadingLabel}</>;
    if (isSuccess) return <><CheckIcon />{successLabel}</>;
    if (isError)   return <><XIcon />{errorLabel}</>;
    return children;
  })();

  return (
    <motion.button
      {...(rest as React.ComponentProps<typeof motion.button>)}
      className={cn(
        variantClass[variant],
        sizeClass[size],
        isError && "!bg-[var(--loss)] !border-[var(--loss)] !text-white",
        isSuccess && variant === "primary" && "!bg-[var(--win)] !text-white",
        isDisabled && "opacity-60 cursor-not-allowed pointer-events-none",
        className
      )}
      onClick={handleClick}
      disabled={isDisabled}
      whileTap={!isDisabled ? { scale: 0.97 } : {}}
      animate={{ scale: 1 }}
      aria-busy={isLoading}
      aria-live="polite"
    >
      <AnimatePresence mode="wait" initial={false}>
        <motion.span
          key={activeState}
          className="inline-flex items-center gap-2"
          initial={{ opacity: 0, y: 6 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -6 }}
          transition={{ duration: 0.15, ease: [0.16, 1, 0.3, 1] }}
        >
          {content}
        </motion.span>
      </AnimatePresence>
    </motion.button>
  );
}

/* ─────────────────────────────────────────────────────────────────────────
   ButtonLink — mesmo visual que StatefulButton mas renderiza <Link>
   Uso:
     <ButtonLink href="/torneios" variant="outline">Ver Torneios</ButtonLink>
───────────────────────────────────────────────────────────────────────── */
interface ButtonLinkProps extends LinkProps {
  variant?: ButtonVariant;
  size?: "sm" | "md" | "lg";
  className?: string;
  children: React.ReactNode;
}

export function ButtonLink({
  variant = "primary",
  size = "md",
  className,
  children,
  ...rest
}: ButtonLinkProps) {
  return (
    <Link
      {...rest}
      className={cn(variantClass[variant], sizeClass[size], className)}
    >
      {children}
    </Link>
  );
}
