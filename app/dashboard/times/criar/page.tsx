"use client";
import { useState, useEffect } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function CriarTimePage() {
  const [nome, setNome]       = useState("");
  const [tag, setTag]         = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError]     = useState("");
  const [checking, setChecking] = useState(true);
  const [hasAccount, setHasAccount] = useState(false);

  const router       = useRouter();
  const searchParams = useSearchParams();
  const supabase     = createClient();
  const tournamentId = searchParams.get("tournament");

  useEffect(() => {
    async function checkAccount() {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }

      const { data } = await supabase
        .from("riot_accounts")
        .select("id")
        .eq("profile_id", user.id)
        .eq("is_primary", true)
        .single();

      setHasAccount(!!data);
      setChecking(false);
    }
    checkAccount();
  }, []);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      const { data: { user }, error: authError } = await supabase.auth.getUser();
      if (authError || !user) { router.push("/login"); return; }

      // Verifica se usuário já tem time
      const { data: existing } = await supabase
        .from("team_members")
        .select("team_id")
        .eq("profile_id", user.id)
        .eq("status", "active")
        .single();

      if (existing) {
        setError("Você já faz parte de um time ativo. Saia do time atual antes de criar um novo.");
        setLoading(false);
        return;
      }

      // Cria o time
      const { data: team, error: teamError } = await supabase
        .from("teams")
        .insert({
          name:       nome.trim(),
          tag:        tag.trim().toUpperCase(),
          captain_id: user.id,
        })
        .select()
        .single();

      if (teamError) throw new Error(teamError.message);

      // Adiciona o criador como capitão
      const { error: memberError } = await supabase
        .from("team_members")
        .insert({
          team_id:    team.id,
          profile_id: user.id,
          role:       "captain",
          status:     "active",
        });

      if (memberError) throw new Error(memberError.message);

      // Se veio de um torneio, inscreve o time automaticamente
      if (tournamentId) {
        const { error: regError } = await supabase
          .from("tournament_registrations")
          .insert({
            tournament_id: tournamentId,
            team_id:       team.id,
            status:        "pending",
          });
        if (regError) console.warn("Inscrição automática falhou:", regError.message);
        router.push(`/torneios/${tournamentId}?inscrito=true`);
        return;
      }

      router.push("/dashboard/time/" + team.id);
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Erro ao criar time");
    } finally {
      setLoading(false);
    }
  }

  if (checking) {
    return (
      <div className="max-w-lg mx-auto card-lol py-16 text-center">
        <p className="text-gray-400">Verificando conta...</p>
      </div>
    );
  }

  if (!hasAccount) {
    return (
      <div className="max-w-lg mx-auto card-lol text-center py-12 space-y-4">
        <p className="text-4xl">⚠️</p>
        <h2 className="text-white font-bold text-lg">Conta Riot necessária</h2>
        <p className="text-gray-400 text-sm">
          Para criar um time você precisa primeiro vincular sua conta Riot.
        </p>
        <a
          href="/dashboard/jogador/registrar"
          className="btn-gold inline-block px-6 py-2"
        >
          Vincular Conta Riot
        </a>
      </div>
    );
  }

  return (
    <div className="max-w-lg mx-auto space-y-6">
      <h1 className="text-2xl font-bold text-white">🛡️ Criar Time</h1>

      {tournamentId && (
        <div className="bg-[#C8A84B]/10 border border-[#C8A84B]/30 rounded-lg p-3">
          <p className="text-[#C8A84B] text-sm">
            🏆 Após criar o time, você será inscrito automaticamente no torneio.
          </p>
        </div>
      )}

      <form onSubmit={handleSubmit} className="card-lol space-y-4">
        <div>
          <label className="block text-gray-400 text-sm mb-1">
            Nome do Time <span className="text-red-400">*</span>
          </label>
          <input
            value={nome}
            onChange={e => setNome(e.target.value)}
            placeholder="Ex: Team Fúria BR"
            className="input-lol w-full"
            maxLength={32}
            required
          />
          <p className="text-gray-600 text-xs mt-1">{nome.length}/32 caracteres</p>
        </div>

        <div>
          <label className="block text-gray-400 text-sm mb-1">
            TAG do Time <span className="text-red-400">*</span>
          </label>
          <input
            value={tag}
            onChange={e => setTag(e.target.value.toUpperCase())}
            placeholder="Ex: FURA"
            className="input-lol w-full"
            maxLength={5}
            minLength={2}
            required
          />
          <p className="text-gray-600 text-xs mt-1">2–5 letras, exibida como [TAG]</p>
        </div>

        {error && (
          <div className="bg-red-900/30 border border-red-500/40 rounded p-3">
            <p className="text-red-400 text-sm">{error}</p>
          </div>
        )}

        <div className="flex gap-3 pt-2">
          <button
            type="button"
            onClick={() => router.back()}
            className="btn-outline-gold flex-1 py-3"
          >
            Cancelar
          </button>
          <button
            type="submit"
            disabled={loading || !nome.trim() || !tag.trim()}
            className="btn-gold flex-1 py-3"
          >
            {loading ? "Criando..." : "Criar Time"}
          </button>
        </div>
      </form>
    </div>
  );
}
