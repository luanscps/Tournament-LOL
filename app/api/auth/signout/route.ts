import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'
import { NextResponse } from 'next/server'
import type { ResponseCookie } from 'next/dist/compiled/@edge-runtime/cookies'

export async function POST() {
  const cookieStore = await cookies()

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll: () => cookieStore.getAll(),
        setAll: (cookiesToSet: Pick<ResponseCookie, 'name' | 'value' | 'options'>[]) => {
          cookiesToSet.forEach(({ name, value, options }: Pick<ResponseCookie, 'name' | 'value' | 'options'>) =>
            cookieStore.set(name, value, options as Parameters<typeof cookieStore.set>[2])
          )
        },
      },
    }
  )

  await supabase.auth.signOut()

  const allCookies = cookieStore.getAll()
  const response = NextResponse.json({ success: true })
  allCookies
    .filter((c) => c.name.startsWith('sb-'))
    .forEach((c) => {
      response.cookies.set(c.name, '', {
        maxAge: 0,
        path: '/',
        sameSite: 'lax',
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
      })
    })

  return response
}
