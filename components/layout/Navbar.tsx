"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useState, useEffect } from "react";
import { AnimatePresence, motion } from "framer-motion";
import { NotificationBell } from "@/components/layout/NotificationBell";
import { Swords } from "lucide-react";

type Me = { id: string; email: string } | null;

export function Navbar() {
  const [user, setUser]         = useState<Me>(null);
  const [isAdmin, setIsAdmin]   = useState(false);
  const [loading, setLoading]   = useState(true);
  const [loggingOut, setLoggingOut] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const pathname = usePathname();

  useEffect(() => { setMenuOpen(false); }, [pathname]);

  async function fetchMe() {
    try {
      const res = await fetch('/api/auth/me', { cache: 'no-store' });
      if (!res.ok) throw new Error('falhou');
      const data = await res.json();
      setUser(data.user ?? null);
      setIsAdmin(!!data.isAdmin);
    } catch {
      setUser(null);
      setIsAdmin(false);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { fetchMe(); }, [pathname]);

  async function handleLogout() {
    if (loggingOut) return;
    setLoggingOut(true);
    try { await fetch('/api/auth/signout', { method: 'POST' }); } catch {}
    window.location.href = '/';
  }

  const NAV_LINKS = [
    { href: '/torneios',  label: 'Torneios'  },
    { href: '/times',     label: 'Times'     },
    { href: '/jogadores', label: 'Jogadores' },
    { href: '/ranking',   label: 'Ranking'   },
  ];

  const isActive = (href: string) =>
    pathname === href || pathname.startsWith(href + '/');

  return (
    <nav
      style={{
        background: "rgba(5,13,26,0.95)",
        borderBottom: "1px solid var(--border)",
        backdropFilter: "blur(12px)",
        WebkitBackdropFilter: "blur(12px)",
        position: "sticky",
        top: 0,
        zIndex: 50,
      }}
    >
      <div className="max-w-7xl mx-auto px-4 py-3 flex items-center justify-between">
        {/* Logo */}
        <Link
          href="/"
          className="flex items-center gap-2 shrink-0"
          style={{
            fontFamily: "var(--font-display)",
            fontWeight: 800,
            fontSize: "var(--text-base)",
            color: "var(--text)",
            textDecoration: "none",
          }}
        >
          <Swords size={20} style={{ color: "var(--gold)" }} />
          <span className="hidden sm:inline">ArenaGG</span>
        </Link>

        {/* Links desktop */}
        <div className="hidden md:flex items-center gap-1">
          {NAV_LINKS.map(({ href, label }) => (
            <Link
              key={href}
              href={href}
              style={{
                padding: "6px 12px",
                borderRadius: "var(--radius-sm)",
                fontSize: "var(--text-sm)",
                fontWeight: isActive(href) ? 600 : 400,
                color: isActive(href) ? "var(--gold)" : "var(--text-muted)",
                background: isActive(href) ? "var(--gold-dim)" : "transparent",
                transition: "color var(--duration), background var(--duration)",
                textDecoration: "none",
              }}
            >
              {label}
            </Link>
          ))}
          {!loading && isAdmin && (
            <Link
              href="/admin"
              style={{
                padding: "6px 12px",
                borderRadius: "var(--radius-sm)",
                fontSize: "var(--text-sm)",
                fontWeight: 600,
                color: pathname.startsWith('/admin') ? "var(--gold)" : "#f87171",
                background: pathname.startsWith('/admin') ? "var(--gold-dim)" : "transparent",
                transition: "color var(--duration), background var(--duration)",
                textDecoration: "none",
              }}
            >
              ⚙️ Admin
            </Link>
          )}
        </div>

        {/* Auth (desktop) */}
        <div className="hidden md:flex items-center gap-2">
          {loading ? (
            <span style={{ color: "var(--text-faint)", fontSize: "var(--text-sm)" }} className="animate-pulse">•••</span>
          ) : user ? (
            <>
              <NotificationBell userId={user.id} />
              <Link
                href="/dashboard"
                style={{
                  fontSize: "var(--text-sm)",
                  color: pathname === '/dashboard' ? "var(--gold)" : "var(--text-muted)",
                  padding: "6px 12px",
                  borderRadius: "var(--radius-sm)",
                  textDecoration: "none",
                  transition: "color var(--duration)",
                }}
              >
                Dashboard
              </Link>
              <button
                onClick={handleLogout}
                disabled={loggingOut}
                style={{
                  fontSize: "var(--text-sm)",
                  color: "var(--text-muted)",
                  padding: "6px 12px",
                  borderRadius: "var(--radius-sm)",
                  transition: "color var(--duration)",
                }}
                className="hover:text-red-400 disabled:opacity-50"
              >
                {loggingOut ? 'Saindo...' : 'Sair'}
              </button>
            </>
          ) : (
            <>
              <Link
                href="/login"
                style={{
                  fontSize: "var(--text-sm)",
                  color: "var(--text-muted)",
                  padding: "6px 12px",
                  borderRadius: "var(--radius-sm)",
                  textDecoration: "none",
                  transition: "color var(--duration)",
                }}
                className="hover:text-white"
              >
                Entrar
              </Link>
              <Link href="/register" className="btn-gold" style={{ padding: "6px 16px", fontSize: "var(--text-sm)" }}>
                Cadastrar
              </Link>
            </>
          )}
        </div>

        {/* Hambúrguer mobile */}
        <button
          className="md:hidden p-2 rounded"
          style={{ color: "var(--text-muted)", transition: "color var(--duration)" }}
          onClick={() => setMenuOpen((v) => !v)}
          aria-label={menuOpen ? 'Fechar menu' : 'Abrir menu'}
        >
          <motion.svg
            width="22" height="22" viewBox="0 0 24 24"
            fill="none" stroke="currentColor" strokeWidth="2"
            animate={menuOpen ? "open" : "closed"}
          >
            <motion.path
              variants={{
                closed: { d: "M3 6h18" },
                open:   { d: "M6 18L18 6" },
              }}
              transition={{ duration: 0.25 }}
            />
            <motion.path
              variants={{
                closed: { d: "M3 12h18", opacity: 1 },
                open:   { d: "M3 12h18",  opacity: 0 },
              }}
              transition={{ duration: 0.15 }}
            />
            <motion.path
              variants={{
                closed: { d: "M3 18h18" },
                open:   { d: "M6 6l12 12" },
              }}
              transition={{ duration: 0.25 }}
            />
          </motion.svg>
        </button>
      </div>

      {/* Menu mobile — AnimatePresence para slide suave */}
      <AnimatePresence>
        {menuOpen && (
          <motion.div
            key="mobile-menu"
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: "auto" }}
            exit={{ opacity: 0, height: 0 }}
            transition={{ duration: 0.28, ease: [0.16, 1, 0.3, 1] }}
            style={{ overflow: "hidden", borderTop: "1px solid var(--border)" }}
          >
            <div className="px-4 py-3 flex flex-col gap-1">
              {NAV_LINKS.map(({ href, label }) => (
                <Link
                  key={href}
                  href={href}
                  style={{
                    padding: "10px 12px",
                    borderRadius: "var(--radius-sm)",
                    fontSize: "var(--text-sm)",
                    fontWeight: isActive(href) ? 600 : 400,
                    color: isActive(href) ? "var(--gold)" : "var(--text-muted)",
                    background: isActive(href) ? "var(--gold-dim)" : "transparent",
                    textDecoration: "none",
                    display: "block",
                  }}
                >
                  {label}
                </Link>
              ))}
              {!loading && isAdmin && (
                <Link href="/admin"
                  style={{ padding: "10px 12px", borderRadius: "var(--radius-sm)", fontSize: "var(--text-sm)", fontWeight: 600, color: "#f87171", textDecoration: "none", display: "block" }}
                >
                  ⚙️ Admin
                </Link>
              )}
              <div style={{ borderTop: "1px solid var(--border-soft)", marginTop: "var(--sp-2)", paddingTop: "var(--sp-2)", display: "flex", flexDirection: "column", gap: "var(--sp-1)" }}>
                {loading ? null : user ? (
                  <>
                    <Link href="/dashboard"
                      style={{ padding: "10px 12px", borderRadius: "var(--radius-sm)", fontSize: "var(--text-sm)", color: "var(--text-muted)", textDecoration: "none", display: "block" }}
                    >
                      Dashboard
                    </Link>
                    <button
                      onClick={handleLogout}
                      disabled={loggingOut}
                      style={{ textAlign: "left", padding: "10px 12px", borderRadius: "var(--radius-sm)", fontSize: "var(--text-sm)", color: "var(--text-muted)", background: "none", border: "none", cursor: "pointer", opacity: loggingOut ? 0.5 : 1 }}
                    >
                      {loggingOut ? 'Saindo...' : 'Sair'}
                    </button>
                  </>
                ) : (
                  <>
                    <Link href="/login"
                      style={{ padding: "10px 12px", borderRadius: "var(--radius-sm)", fontSize: "var(--text-sm)", color: "var(--text-muted)", textDecoration: "none", display: "block" }}
                    >
                      Entrar
                    </Link>
                    <Link href="/register" className="btn-gold"
                      style={{ textAlign: "center", padding: "10px 12px", fontSize: "var(--text-sm)" }}
                    >
                      Cadastrar
                    </Link>
                  </>
                )}
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </nav>
  );
}
