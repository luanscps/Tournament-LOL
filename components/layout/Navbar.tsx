"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { useState, useEffect, useRef } from "react";
import type { User } from "@supabase/supabase-js";
import { NotificationBell } from "@/components/layout/NotificationBell";

const LINKS = [
  { href: "/torneios", label: "Torneios" },
  { href: "/jogadores", label: "Jogadores" },
  { href: "/ranking", label: "Ranking" },
];

export function Navbar() {
  const [user, setUser]       = useState<User | null>(null);
  const [isAdmin, setIsAdmin] = useState(false);
  const [loading, setLoading] = useState(true);
  const [loggingOut, setLoggingOut] = useState(false);
  const pathname = usePathname();
  // Singleton estável — nunca recria entre renders
  const supabase = useRef(createClient()).current;

  async function fetchAdminStatus(userId: string) {
    try {
      // Tenta via RPC SECURITY DEFINER (ignora RLS)
      const { data: rpcData, error: rpcError } = await supabase
        .rpc("is_current_user_admin");
      if (!rpcError) {
        setIsAdmin(!!rpcData);
        return;
      }
    } catch (_) {
      // RPC não existe ainda — usa fallback
    }
    // Fallback: query direta na tabela profiles
    const { data } = await supabase
      .from("profiles")
      .select("is_admin")
      .eq("id", userId)
      .single();
    setIsAdmin(!!data?.is_admin);
  }

  useEffect(() => {
    // Leitura inicial segura
    supabase.auth.getUser().then(({ data: { user } }) => {
      setUser(user ?? null);
      setLoading(false);
      if (user) fetchAdminStatus(user.id);
    });

    // Listener de mudanças de sessão
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        const currentUser = session?.user ?? null;
        setUser(currentUser);
        setLoading(false);
        if (currentUser) {
          await fetchAdminStatus(currentUser.id);
        } else {
          setIsAdmin(false);
        }
      }
    );

    return () => subscription.unsubscribe();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function handleLogout() {
    if (loggingOut) return;
    setLoggingOut(true);
    try {
      await supabase.auth.signOut();
    } catch (_) {
      // Ignora erro — continua o logout de qualquer forma
    }
    // Recarga completa: garante que cookies do servidor sejam limpos
    // antes de qualquer Server Component re-renderizar
    window.location.href = "/";
  }

  return (
    <nav className="bg-[#050E1A] border-b border-[#1E3A5F] px-4 py-3">
      <div className="max-w-7xl mx-auto flex items-center justify-between">
        {/* Logo */}
        <Link href="/" className="flex items-center gap-2 font-bold text-white">
          <span>⚔️</span>
          <span className="hidden sm:inline">LoL Tournament</span>
        </Link>

        {/* Nav Links */}
        <div className="flex items-center gap-1">
          {LINKS.map(({ href, label }) => (
            <Link
              key={href}
              href={href}
              className={`px-3 py-1.5 rounded text-sm transition-colors ${
                pathname === href || pathname.startsWith(href + "/")
                  ? "text-[#C8A84B] bg-[#C8A84B]/10"
                  : "text-gray-400 hover:text-white"
              }`}
            >
              {label}
            </Link>
          ))}
          {isAdmin && (
            <Link
              href="/admin"
              className={`px-3 py-1.5 rounded text-sm font-semibold transition-colors ${
                pathname.startsWith("/admin")
                  ? "text-[#C8A84B] bg-[#C8A84B]/10"
                  : "text-red-400 hover:text-red-300"
              }`}
            >
              ⚙️ Admin
            </Link>
          )}
        </div>

        {/* Auth + Notifications */}
        <div className="flex items-center gap-2">
          {loading ? (
            <span className="text-gray-500 text-sm animate-pulse">•••</span>
          ) : user ? (
            <>
              <NotificationBell userId={user.id} />
              <Link
                href="/dashboard"
                className={`text-sm px-3 py-1.5 rounded transition-colors ${
                  pathname === "/dashboard"
                    ? "text-[#C8A84B]"
                    : "text-gray-400 hover:text-white"
                }`}
              >
                Dashboard
              </Link>
              <button
                onClick={handleLogout}
                disabled={loggingOut}
                className="text-sm text-gray-400 hover:text-red-400 disabled:opacity-50 disabled:cursor-not-allowed px-3 py-1.5 rounded transition-colors"
              >
                {loggingOut ? "Saindo..." : "Sair"}
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
