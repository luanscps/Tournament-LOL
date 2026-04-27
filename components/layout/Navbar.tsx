"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useState, useEffect } from "react";
import { NotificationBell } from "@/components/layout/NotificationBell";

type Me = { id: string; email: string } | null;

export function Navbar() {
  const [user, setUser]       = useState<Me>(null);
  const [isAdmin, setIsAdmin] = useState(false);
  const [loading, setLoading] = useState(true);
  const [loggingOut, setLoggingOut] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const pathname = usePathname();

  // Fecha menu mobile ao trocar de rota
  useEffect(() => { setMenuOpen(false); }, [pathname]);

  // Busca estado de autenticacao via server-side (bypassa RLS para is_admin)
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

  useEffect(() => {
    fetchMe();
  }, [pathname]); // Re-verifica ao mudar de pagina

  async function handleLogout() {
    if (loggingOut) return;
    setLoggingOut(true);
    try {
      await fetch('/api/auth/signout', { method: 'POST' });
    } catch {
      // ignora erro de rede, continua o redirect
    }
    // Recarga completa — cookies ja foram limpos server-side
    window.location.href = '/';
  }

  const NAV_LINKS = [
    { href: '/torneios',  label: 'Torneios' },
    { href: '/times',     label: 'Times'    },
    { href: '/jogadores', label: 'Jogadores'},
    { href: '/ranking',   label: 'Ranking'  },
  ];

  const isActive = (href: string) =>
    pathname === href || pathname.startsWith(href + '/');

  return (
    <nav className="bg-[#050E1A] border-b border-[#1E3A5F] px-4 py-3">
      <div className="max-w-7xl mx-auto flex items-center justify-between">
        {/* Logo */}
        <Link href="/" className="flex items-center gap-2 font-bold text-white shrink-0">
          <span>⚔️</span>
          <span className="hidden sm:inline">LoL Tournament</span>
        </Link>

        {/* Links desktop */}
        <div className="hidden md:flex items-center gap-1">
          {NAV_LINKS.map(({ href, label }) => (
            <Link
              key={href}
              href={href}
              className={`px-3 py-1.5 rounded text-sm transition-colors ${
                isActive(href)
                  ? 'text-[#C8A84B] bg-[#C8A84B]/10 font-medium'
                  : 'text-gray-400 hover:text-white hover:bg-white/5'
              }`}
            >
              {label}
            </Link>
          ))}

          {/* Link Admin — so aparece se isAdmin=true */}
          {!loading && isAdmin && (
            <Link
              href="/admin"
              className={`px-3 py-1.5 rounded text-sm font-semibold transition-colors ${
                pathname.startsWith('/admin')
                  ? 'text-[#C8A84B] bg-[#C8A84B]/10'
                  : 'text-red-400 hover:text-red-300 hover:bg-red-400/5'
              }`}
            >
              ⚙️ Admin
            </Link>
          )}
        </div>

        {/* Auth (desktop) */}
        <div className="hidden md:flex items-center gap-2">
          {loading ? (
            <span className="text-gray-500 text-sm animate-pulse">•••</span>
          ) : user ? (
            <>
              <NotificationBell userId={user.id} />
              <Link
                href="/dashboard"
                className={`text-sm px-3 py-1.5 rounded transition-colors ${
                  pathname === '/dashboard'
                    ? 'text-[#C8A84B]'
                    : 'text-gray-400 hover:text-white'
                }`}
              >
                Dashboard
              </Link>
              <button
                onClick={handleLogout}
                disabled={loggingOut}
                className="text-sm text-gray-400 hover:text-red-400 disabled:opacity-50 disabled:cursor-not-allowed px-3 py-1.5 rounded transition-colors"
              >
                {loggingOut ? 'Saindo...' : 'Sair'}
              </button>
            </>
          ) : (
            <>
              <Link
                href="/login"
                className="text-sm text-gray-400 hover:text-white px-3 py-1.5 rounded transition-colors"
              >
                Entrar
              </Link>
              <Link
                href="/register"
                className="text-sm bg-[#C8A84B] hover:bg-[#d4b55a] text-black font-semibold px-3 py-1.5 rounded transition-colors"
              >
                Cadastrar
              </Link>
            </>
          )}
        </div>

        {/* Botão hambúrguer (mobile) */}
        <button
          className="md:hidden text-gray-400 hover:text-white p-1.5 rounded transition-colors"
          onClick={() => setMenuOpen(v => !v)}
          aria-label={menuOpen ? 'Fechar menu' : 'Abrir menu'}
        >
          {menuOpen ? (
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M18 6L6 18M6 6l12 12"/>
            </svg>
          ) : (
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M3 12h18M3 6h18M3 18h18"/>
            </svg>
          )}
        </button>
      </div>

      {/* Menu mobile */}
      {menuOpen && (
        <div className="md:hidden mt-3 border-t border-[#1E3A5F] pt-3 flex flex-col gap-1">
          {NAV_LINKS.map(({ href, label }) => (
            <Link
              key={href}
              href={href}
              className={`px-3 py-2 rounded text-sm transition-colors ${
                isActive(href)
                  ? 'text-[#C8A84B] bg-[#C8A84B]/10 font-medium'
                  : 'text-gray-400 hover:text-white hover:bg-white/5'
              }`}
            >
              {label}
            </Link>
          ))}
          {!loading && isAdmin && (
            <Link href="/admin" className="px-3 py-2 rounded text-sm font-semibold text-red-400 hover:text-red-300">
              ⚙️ Admin
            </Link>
          )}
          <div className="border-t border-[#1E3A5F] mt-2 pt-2 flex flex-col gap-1">
            {loading ? null : user ? (
              <>
                <Link href="/dashboard" className="px-3 py-2 rounded text-sm text-gray-400 hover:text-white">
                  Dashboard
                </Link>
                <button
                  onClick={handleLogout}
                  disabled={loggingOut}
                  className="text-left px-3 py-2 rounded text-sm text-gray-400 hover:text-red-400 disabled:opacity-50"
                >
                  {loggingOut ? 'Saindo...' : 'Sair'}
                </button>
              </>
            ) : (
              <>
                <Link href="/login" className="px-3 py-2 rounded text-sm text-gray-400 hover:text-white">
                  Entrar
                </Link>
                <Link href="/register" className="px-3 py-2 rounded text-sm bg-[#C8A84B] text-black font-semibold text-center">
                  Cadastrar
                </Link>
              </>
            )}
          </div>
        </div>
      )}
    </nav>
  );
}
