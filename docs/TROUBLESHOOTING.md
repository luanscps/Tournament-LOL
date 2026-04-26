# 🔧 Troubleshooting — GerenciadorDeTorneios BRLOL

> Atualizado em: **2026-04-26**

Registro de problemas conhecidos e suas soluções definitivas.

---

## ❌ Erro: `column "starts_at" can only be updated to DEFAULT`

### Causa

As colunas `starts_at` e `ends_at` na tabela `tournaments` são **GENERATED** (geradas automaticamente a partir de `start_date` e `end_date`). Qualquer `UPDATE` que inclua essas colunas no payload causa esse erro.

### Solução

**No payload de update, use sempre `start_date`/`end_date`:**

```ts
// ❌ ERRADO — causa erro de GENERATED COLUMN
await supabase.from('tournaments').update({
  starts_at: startsAt,
  ends_at: endsAt,
}).eq('id', id)

// ✅ CORRETO
await supabase.from('tournaments').update({
  start_date: startsAt,
  end_date: endsAt,
}).eq('id', id)
```

**No load (useEffect), leia `start_date`/`end_date` para preencher os campos:**

```ts
setStartsAt(data.start_date ? data.start_date.slice(0, 16) : '')
setEndsAt(data.end_date ? data.end_date.slice(0, 16) : '')
```

---

## ❌ Erro: Link "+ Inscrever meu time" retorna 404

### Causa

O link gerado na página pública do torneio usava o caminho singular `/dashboard/time/criar`, mas a rota real no App Router é `/dashboard/times/criar` (plural).

### Solução

Em `app/torneios/[slug]/page.tsx`, o `href` deve ser:

```tsx
// ❌ ERRADO
href={`/dashboard/time/criar?tournament=${tournament.id}`}

// ✅ CORRETO
href={`/dashboard/times/criar?tournament=${tournament.id}`}
```

---

## ❌ Erro: `function unaccent(text) does not exist`

### Causa

A função trigger `generate_tournament_slug()` usa `unaccent()`, que depende da extensão `unaccent` do PostgreSQL. No Supabase, ela pode não estar habilitada ou acessível no schema correto.

### Solução Definitiva

Recriar a função usando `translate()` nativo do PostgreSQL (sem dependência de extensão):

```sql
CREATE OR REPLACE FUNCTION public.generate_tournament_slug()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  base_slug text;
  final_slug text;
  counter int := 0;
BEGIN
  base_slug := translate(lower(NEW.name),
    'áàâãäéèêëíìîïóòôõöúùûüçñ',
    'aaaaaeeeeiiiiooooouuuucn'
  );
  base_slug := regexp_replace(base_slug, '[^a-z0-9]+', '-', 'g');
  base_slug := trim(both '-' from base_slug);
  final_slug := base_slug;

  WHILE EXISTS (
    SELECT 1 FROM public.tournaments
    WHERE slug = final_slug
    AND id != COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid)
  ) LOOP
    counter := counter + 1;
    final_slug := base_slug || '-' || counter;
  END LOOP;

  NEW.slug := final_slug;
  RETURN NEW;
END;
$$;
```

> `translate()` é nativo do Postgres, não requer extensões e funciona em qualquer ambiente Supabase.

---

## ❌ Erro: Referência a `tournament_teams` retorna relação não encontrada

### Causa

Documentação e código antigo referenciavam uma tabela `tournament_teams`. Ela **não existe** no schema atual. O equivalente correto é a tabela `inscricoes`.

### Solução

Substituir toda referência a `tournament_teams` por `inscricoes`:

| Coluna antiga (`tournament_teams`) | Equivalente em `inscricoes` |
|---|---|
| `tournament_id` | `tournament_id` |
| `team_id` | `team_id` |
| `status` | `status` (`pending`, `approved`, `rejected`, `eliminated`) |
| `seed` | `seed` |
| `checked_in_at` | `checked_in_at` |

---

## ❌ Erro: Coluna `summonername` não existe em `players`

### Causa

Migrations antigas criavam a coluna como `summonername` (sem underscore). O schema atual usa `summoner_name` e `tag_line`.

### Solução

Sempre use os nomes corretos nas queries:

```ts
// ❌ ERRADO
.select('summonername, tagline')

// ✅ CORRETO
.select('summoner_name, tag_line')
```

---

## ⚠️ RLS: Inserção de `inscricoes` bloqueada por policy

### Causa

A tabela `inscricoes` tem RLS habilitado. Se uma policy de `INSERT` não estiver configurada para o usuário autenticado (capitão do time), a inserção é silenciosamente bloqueada ou retorna erro de permissão.

### Solução

Verificar no Supabase Dashboard → Authentication → Policies → tabela `inscricoes`:

```sql
-- Policy para capitão do time inserir inscrição
CREATE POLICY "Capitao pode inserir inscricao"
ON public.inscricoes
FOR INSERT
TO authenticated
WITH CHECK (
  team_id IN (
    SELECT id FROM public.teams WHERE captain_id = auth.uid()
  )
);
```
