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
  const pathname = usePathname();

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
    { href: '/torneios', label: 'Torneios' },
    { href: '/jogadores', label: 'Jogadores' },
    { href: '/ranking', label: 'Ranking' },
  ];

  return (
    <nav className="bg-[#050E1A] border-b border-[#1E3A5F] px-4 py-3">
      <div className="max-w-7xl mx-auto flex items-center justify-between">
        {/* Logo */}
        <Link href="/" className="flex items-center gap-2 font-bold text-white">
          <span>⚔️</span>
          <span className="hidden sm:inline">LoL Tournament</span>
        </Link>

        {/* Links de navegacao */}
        <div className="flex items-center gap-1">
          {NAV_LINKS.map(({ href, label }) => (
            <Link
              key={href}
              href={href}
              className={`px-3 py-1.5 rounded text-sm transition-colors ${
                pathname === href || pathname.startsWith(href + '/')
                  ? 'text-[#C8A84B] bg-[#C8A84B]/10'
                  : 'text-gray-400 hover:text-white'
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
                  : 'text-red-400 hover:text-red-300'
              }`}
            >
              ⚙️ Admin
            </Link>
          )}
        </div>

        {/* Auth */}
        <div className="flex items-center gap-2">
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
      </div>
    </nav>
  );
}
