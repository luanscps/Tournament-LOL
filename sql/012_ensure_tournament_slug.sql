-- =============================================================
-- 012_ensure_tournament_slug.sql
-- Garante que tournaments.slug é coluna real, NOT NULL,
-- única, indexada e sem conflitos. Executar após 011.
-- =============================================================

-- 1. Adiciona a coluna caso não exista (retrocompatível)
ALTER TABLE public.tournaments
  ADD COLUMN IF NOT EXISTS slug text;

-- 2. Preenche slugs faltantes derivando do nome
--    remove acentos básicos, troca espaços/pontuação por hífen
UPDATE public.tournaments
SET slug = lower(
  regexp_replace(
    regexp_replace(
      translate(name,
        'áàãâéêíóôõúüçÁÀÃÂÉÊÍÓÔÕÚÜÇ',
        'aaaaeeiooouucAAAAEEIOOOUUC'
      ),
      '[^a-z0-9]+', '-', 'g'
    ),
    '(^-|-$)', '', 'g'
  )
)
WHERE slug IS NULL OR slug = '';

-- 3. Garante unicidade adicionando sufixo numérico quando necessário
DO $$
DECLARE
  r RECORD;
  base_slug TEXT;
  counter   INT;
BEGIN
  FOR r IN
    SELECT id, slug
    FROM public.tournaments
    WHERE slug IN (
      SELECT slug FROM public.tournaments GROUP BY slug HAVING COUNT(*) > 1
    )
    ORDER BY created_at
  LOOP
    base_slug := r.slug;
    counter   := 1;
    WHILE EXISTS (
      SELECT 1 FROM public.tournaments
      WHERE slug = base_slug || '-' || counter
        AND id <> r.id
    ) LOOP
      counter := counter + 1;
    END LOOP;
    UPDATE public.tournaments
    SET slug = base_slug || '-' || counter
    WHERE id = r.id;
  END LOOP;
END $$;

-- 4. Aplica NOT NULL e constraint única
ALTER TABLE public.tournaments
  ALTER COLUMN slug SET NOT NULL;

ALTER TABLE public.tournaments
  DROP CONSTRAINT IF EXISTS tournaments_slug_key;

ALTER TABLE public.tournaments
  ADD CONSTRAINT tournaments_slug_key UNIQUE (slug);

-- 5. Índice para busca rápida por slug
CREATE INDEX IF NOT EXISTS idx_tournaments_slug
  ON public.tournaments (slug);

-- Verificação
SELECT id, name, slug, status
FROM public.tournaments
ORDER BY created_at DESC
LIMIT 20;
