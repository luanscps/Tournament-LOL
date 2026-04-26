import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { NextResponse } from "next/server";

export async function POST(req: Request) {
  try {
    // Verifica admin via cookie
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Não autenticado" }, { status: 401 });

    const { data: profile } = await supabase
      .from("profiles")
      .select("is_admin")
      .eq("id", user.id)
      .single();
    if (!profile?.is_admin) return NextResponse.json({ error: "Sem permissão" }, { status: 403 });

    const body = await req.json();

    // Usa adminClient para bypassar RLS
    const adminClient = createAdminClient();

    // Monta payload apenas com colunas que existem na tabela
    const payload: Record<string, any> = {
      name:        body.name,
      slug:        body.slug,
      status:      body.status ?? "DRAFT",
      max_teams:   body.max_teams ?? 16,
      created_by:  user.id,
    };
    if (body.description) payload.description = body.description;
    if (body.format)      payload.format      = body.format;
    if (body.game_mode)   payload.game_mode   = body.game_mode;
    if (body.prize_pool)  payload.prize_pool  = body.prize_pool;
    if (body.start_date)  payload.start_date  = body.start_date;

    const { data, error } = await adminClient
      .from("tournaments")
      .insert(payload)
      .select("id, slug")
      .single();

    if (error) return NextResponse.json({ error: error.message }, { status: 400 });

    return NextResponse.json({ id: data.id, slug: data.slug });
  } catch (e) {
    return NextResponse.json({ error: "Erro interno" }, { status: 500 });
  }
}
