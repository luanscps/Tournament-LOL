-- Migration: tournament_announcements
-- Tabela de comunicados enviados pelo organizador para os times de um torneio.
-- Canais suportados: email, discord (extensivel via array).
-- Destino (target): all = todos os times | active = times nao eliminados | eliminated = eliminados.

CREATE TABLE IF NOT EXISTS public.tournament_announcements (
  id             uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  tournament_id  uuid        NOT NULL REFERENCES public.tournaments(id) ON DELETE CASCADE,
  sent_by        uuid        REFERENCES public.profiles(id) ON DELETE SET NULL,
  title          text        NOT NULL CHECK (char_length(title) BETWEEN 5 AND 150),
  body           text        NOT NULL CHECK (char_length(body) BETWEEN 10 AND 2000),
  channel        text[]      NOT NULL DEFAULT ARRAY['email']::text[],
  target         text        NOT NULL DEFAULT 'all'
                             CHECK (target IN ('all', 'active', 'eliminated')),
  sent_at        timestamptz NOT NULL DEFAULT now(),
  created_at     timestamptz NOT NULL DEFAULT now()
);

-- Index para queries por torneio (listagem e contagem)
CREATE INDEX IF NOT EXISTS idx_tournament_announcements_tournament_id
  ON public.tournament_announcements (tournament_id);

-- Index para queries por remetente
CREATE INDEX IF NOT EXISTS idx_tournament_announcements_sent_by
  ON public.tournament_announcements (sent_by);

-- RLS
ALTER TABLE public.tournament_announcements ENABLE ROW LEVEL SECURITY;

-- Organizador do torneio ou admin da plataforma pode fazer tudo (SELECT, INSERT, UPDATE, DELETE)
CREATE POLICY "announcements_org_or_admin_all"
  ON public.tournament_announcements
  FOR ALL
  USING (
    EXISTS (
      SELECT 1
      FROM public.tournaments t
      WHERE t.id = tournament_id
        AND (
          t.organizer_id = auth.uid()
          OR t.created_by  = auth.uid()
          OR (SELECT is_admin FROM public.profiles WHERE id = auth.uid())
        )
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.tournaments t
      WHERE t.id = tournament_id
        AND (
          t.organizer_id = auth.uid()
          OR t.created_by  = auth.uid()
          OR (SELECT is_admin FROM public.profiles WHERE id = auth.uid())
        )
    )
  );

-- Times inscritos (aprovados) podem apenas LER os comunicados do torneio
CREATE POLICY "announcements_teams_select"
  ON public.tournament_announcements
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM public.inscricoes i
      JOIN public.team_members tm ON tm.team_id = i.team_id
      WHERE i.tournament_id = tournament_announcements.tournament_id
        AND i.status        = 'APPROVED'
        AND tm.profile_id   = auth.uid()
        AND tm.status       = 'active'
    )
  );
