-- ============================================================
-- Migration 019: Correções críticas de schema e RLS
-- ============================================================

-- ─── 1. PICKS_BANS ───────────────────────────────────────────
-- O banco armazena picks/bans como campo JSONB em match_games.
-- Não existe (nem deve existir) tabela separada picks_bans.
-- Esta migration é apenas documentação; nenhuma DDL necessária.
-- O código em partida.ts foi corrigido para usar match_games.picks_bans.


-- ─── 2. RLS DUPLICADA: teams ─────────────────────────────────
-- Políticas teams_select_all e teams_select_public ambas com USING (true)
-- causam overhead desnecessário. Mantemos apenas uma.
DO $$
BEGIN
  -- Remove a política redundante se existir
  IF EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename  = 'teams'
      AND policyname = 'teams_select_all'
  ) THEN
    EXECUTE 'DROP POLICY teams_select_all ON public.teams';
  END IF;
END;
$$;

-- Garante que existe exatamente uma política de leitura pública
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename  = 'teams'
      AND policyname = 'teams_select_public'
  ) THEN
    EXECUTE 'CREATE POLICY teams_select_public ON public.teams FOR SELECT USING (true)';
  END IF;
END;
$$;


-- ─── 3. TOURNAMENTS.STARTS_AT — coluna GENERATED ─────────────
-- starts_at é GENERATED ALWAYS AS (start_date) STORED.
-- Garante que não existe DEFAULT nem valor manual nessa coluna.
-- O código tournament.ts foi corrigido para usar start_date diretamente.
-- Nenhuma DDL de ALTER necessária; a coluna já está correta no banco.


-- ─── 4. TEAM_INVITES → TEAM_MEMBERS ──────────────────────────
-- Função auxiliar chamada quando um convite é aceito via RPC ou trigger.
-- O código team_invite.ts já faz o insert diretamente,
-- mas esta função pode ser chamada por triggers futuros.
CREATE OR REPLACE FUNCTION public.fn_accept_team_invite(p_invite_id uuid, p_profile_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_invite public.teaminvites%ROWTYPE;
BEGIN
  SELECT * INTO v_invite
  FROM public.teaminvites
  WHERE id = p_invite_id AND status = 'PENDING';

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Convite não encontrado ou já respondido';
  END IF;

  IF v_invite.expires_at IS NOT NULL AND v_invite.expires_at < now() THEN
    RAISE EXCEPTION 'Convite expirado';
  END IF;

  -- Marca convite como aceito
  UPDATE public.teaminvites
  SET status = 'ACCEPTED'
  WHERE id = p_invite_id;

  -- Insere em team_members (upsert seguro)
  INSERT INTO public.teammembers (team_id, profile_id, team_role, status, invited_at, responded_at)
  VALUES (v_invite.teamid, p_profile_id, COALESCE(v_invite.role::text, 'member')::public.teammemberrole, 'active', now(), now())
  ON CONFLICT (team_id, profile_id)
  DO UPDATE SET status = 'active', responded_at = now();
END;
$$;


-- ─── 5. TRIGGERS DE NOTIFICAÇÃO — validar user_id ────────────
-- Os triggers trg_inscricao_nova e trg_inscricao_status_change
-- disparam notificações. Recriamos a função garantindo que o
-- user_id alvo é o requested_by da inscrição (quem pediu),
-- não o reviewed_by (admin que avaliou).
CREATE OR REPLACE FUNCTION public.fn_notify_inscricao()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id uuid;
  v_title   text;
  v_body    text;
  v_type    text;
BEGIN
  -- FIX: user_id alvo = quem fez a inscrição (requested_by), não o admin
  v_user_id := COALESCE(NEW.requested_by, OLD.requested_by);

  IF v_user_id IS NULL THEN
    RETURN NEW;
  END IF;

  IF TG_OP = 'INSERT' THEN
    v_type  := 'inscricao_nova';
    v_title := 'Inscrição enviada';
    v_body  := 'Sua inscrição foi recebida e está em análise.';

  ELSIF TG_OP = 'UPDATE' AND OLD.status IS DISTINCT FROM NEW.status THEN
    v_type  := 'inscricao_status';
    CASE NEW.status
      WHEN 'APPROVED' THEN
        v_title := 'Inscrição aprovada! 🎉';
        v_body  := 'Seu time foi aprovado para o torneio.';
      WHEN 'REJECTED' THEN
        v_title := 'Inscrição recusada';
        v_body  := 'Sua inscrição não foi aprovada desta vez.';
      ELSE
        RETURN NEW;
    END CASE;
  ELSE
    RETURN NEW;
  END IF;

  INSERT INTO public.notifications (user_id, type, title, body, metadata)
  VALUES (
    v_user_id,
    v_type,
    v_title,
    v_body,
    jsonb_build_object(
      'tournament_id', NEW.tournament_id,
      'team_id',       NEW.team_id,
      'status',        NEW.status
    )
  );

  RETURN NEW;
END;
$$;

-- Remove triggers antigos e recria com a função corrigida
DROP TRIGGER IF EXISTS trg_inscricao_nova           ON public.inscricoes;
DROP TRIGGER IF EXISTS trg_inscricao_status_change  ON public.inscricoes;

CREATE TRIGGER trg_inscricao_nova
  AFTER INSERT ON public.inscricoes
  FOR EACH ROW EXECUTE FUNCTION public.fn_notify_inscricao();

CREATE TRIGGER trg_inscricao_status_change
  AFTER UPDATE OF status ON public.inscricoes
  FOR EACH ROW EXECUTE FUNCTION public.fn_notify_inscricao();
