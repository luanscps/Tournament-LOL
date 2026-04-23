// app/admin/layout.tsx
import { redirect } from 'next/navigation'
import { cookies } from 'next/headers'
import { createServerClient } from '@supabase/ssr'
import Link from 'next/link'

export const metadata = {
  title: 'Admin — BRLOL',
}

export default async function AdminLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const cookieStore = await cookies()

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll()
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            )
          } catch {
            // Ignorado em Server Components (read-only cookie store)
          }
        },
      },
    }
  )

  // 1. Validar sessão de forma segura (nunca getSession() em server)
  const {
    data: { user },
    error: authError,
  } = await supabase.auth.getUser()

  if (authError || !user) {
    redirect('/login?redirectTo=/admin')
  }

  // 2. Verificar is_admin na tabela profiles
  // Usa service_role key para evitar interferência de RLS em casos edge
  const supabaseAdmin = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!, // server-only, nunca exposta ao client
    {
      cookies: {
        getAll() {
          return cookieStore.getAll()
        },
        setAll() {},
      },
    }
  )

  const { data: profile, error: profileError } = await supabaseAdmin
    .from('profiles')
    .select('is_admin')
    .eq('id', user.id)
    .single()

  if (profileError || !profile?.is_admin) {
    // Usuário autenticado mas não é admin — redireciona para home
    redirect('/?error=acesso_negado')
  }

  // 3. Renderiza o layout admin apenas para admins confirmados
  return (
    <div className="min-h-screen bg-[#060E1A]">
      {/* Sidebar / Topbar Admin */}
      <nav className="bg-[#0D1B2E] border-b border-[#1E3A5F] px-6 py-3 flex items-center justify-between">
        <div className="flex items-center gap-6">
          <span className="text-[#C8A84B] font-bold text-sm tracking-wider uppercase">
            Admin Panel
          </span>
          <div className="flex items-center gap-4 text-sm">
            <Link
              href="/admin"
              className="text-gray-400 hover:text-white transition-colors"
            >
              Dashboard
            </Link>
            <Link
              href="/admin/torneios"
              className="text-gray-400 hover:text-white transition-colors"
            >
              Torneios
            </Link>
            <Link
              href="/admin/usuarios"
              className="text-gray-400 hover:text-white transition-colors"
            >
              Usuários
            </Link>
            <Link
              href="/admin/jogadores"
              className="text-gray-400 hover:text-white transition-colors"
            >
              Jogadores
            </Link>
          </div>
        </div>
        <div className="flex items-center gap-3">
          <span className="text-xs text-gray-500">
            {user.email}
          </span>
          <span className="text-xs bg-purple-900/40 text-purple-300 px-2 py-0.5 rounded font-medium">
            Admin
          </span>
          <Link
            href="/dashboard"
            className="text-xs text-gray-400 hover:text-white transition-colors"
          >
            ← Sair do Admin
          </Link>
        </div>
      </nav>

      {/* Conteúdo */}
      <main className="p-6">{children}</main>
    </div>
  )
}