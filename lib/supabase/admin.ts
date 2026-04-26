import { createClient as createSupabaseClient } from '@supabase/supabase-js';

/**
 * Cliente com service_role — bypassa RLS.
 * Usar APENAS em Server Components/Actions do painel admin.
 * NUNCA expor para o client-side.
 */
export function createAdminClient() {
  return createSupabaseClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,
    {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    }
  );
}
