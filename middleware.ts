/**
 * middleware.ts — Proteção de rota no Edge
 *
 * Responsabilidade: apenas garantir que rotas protegidas
 * não sejam acessadas sem sessão ativa.
 *
 * A verificação de role (admin/organizer) permanece nos
 * layouts (Server Components) e nas Server Actions,
 * pois requerem acesso ao banco via service role.
 */
import { createServerClient } from '@supabase/ssr'
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

// Prefixos que exigem autenticação
const AUTH_REQUIRED = ['/dashboard', '/organizador', '/admin', '/profile']

export async function middleware(request: NextRequest) {
  const response = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll: () => request.cookies.getAll(),
        setAll: (cookiesToSet) => {
          cookiesToSet.forEach(({ name, value, options }) =>
            response.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  const { data: { user } } = await supabase.auth.getUser()

  const { pathname } = request.nextUrl
  const needsAuth = AUTH_REQUIRED.some(prefix => pathname.startsWith(prefix))

  if (needsAuth && !user) {
    const loginUrl = new URL('/login', request.url)
    loginUrl.searchParams.set('redirectTo', pathname)
    return NextResponse.redirect(loginUrl)
  }

  return response
}

export const config = {
  matcher: [
    /*
     * Executa em todas as rotas exceto:
     * - _next/static  (assets estáticos)
     * - _next/image   (otimização de imagem)
     * - favicon.ico
     * - api/riot-callback (webhook público da Riot)
     */
    '/((?!_next/static|_next/image|favicon\.ico|api/riot-callback).*)',
  ],
}
