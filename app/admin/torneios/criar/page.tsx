"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
export default function CriarTorneioPage() {
  const router   = useRouter();
  const supabase = createClient();
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState({
    name:"", slug:"", description:"",
    queue_type:"NORMAL_5x5_DRAFT", bracket_type:"single_elimination",
    max_teams:"16", prize_pool:"", starts_at:"",
  });
  function handle(e: React.ChangeEvent<HTMLInputElement|HTMLTextAreaElement|HTMLSelectElement>) {
    setForm(p => ({ ...p, [e.target.name]: e.target.value }));
  }
  async function onSubmit(e: React.FormEvent) {
    e.preventDefault(); setLoading(true);
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return;
    const { error } = await supabase.from("tournaments").insert({
      name: form.name, slug: form.slug, description: form.description || null,
      queue_type: form.queue_type, bracket_type: form.bracket_type,
      max_teams: parseInt(form.max_teams), prize_pool: form.prize_pool || null,
      starts_at: form.starts_at || null, created_by: user.id, status: "draft",
    });
    if (error) { alert(error.message); setLoading(false); return; }
    router.push("/admin");
  }
  return (
    <div className="max-w-2xl">
      <h1 className="text-2xl font-bold text-white mb-6">🏆 Criar Torneio</h1>
      <form onSubmit={onSubmit} className="card-lol space-y-4">
        <div>
          <label className="text-gray-400 text-sm">Nome do torneio</label>
          <input name="name" value={form.name} onChange={handle} className="input-lol mt-1" required />
        </div>
        <div>
          <label className="text-gray-400 text-sm">Slug (URL) — apenas letras, numeros e hifen</label>
          <input name="slug" value={form.slug} onChange={handle} placeholder="ex: lol-cup-abril-2026" className="input-lol mt-1" required />
        </div>
        <div>
          <label className="text-gray-400 text-sm">Descricao (opcional)</label>
          <textarea name="description" value={form.description} onChange={handle} rows={3} className="input-lol mt-1 resize-none w-full" />
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="text-gray-400 text-sm">Modo de jogo</label>
            <select name="queue_type" value={form.queue_type} onChange={handle} className="input-lol mt-1 bg-[#0A1428]">
              <option value="NORMAL_5x5_DRAFT">Normal Draft</option>
              <option value="RANKED_SOLO_5x5">Ranqueada Solo</option>
              <option value="RANKED_FLEX_SR">Ranqueada Flex</option>
              <option value="ARAM">ARAM</option>
            </select>
          </div>
          <div>
            <label className="text-gray-400 text-sm">Tipo de bracket</label>
            <select name="bracket_type" value={form.bracket_type} onChange={handle} className="input-lol mt-1 bg-[#0A1428]">
              <option value="single_elimination">Eliminacao Simples</option>
              <option value="double_elimination">Eliminacao Dupla</option>
              <option value="round_robin">Fase de Grupos</option>
              <option value="swiss">Swiss</option>
            </select>
          </div>
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="text-gray-400 text-sm">Max. de times</label>
            <input name="max_teams" type="number" min={4} max={64} value={form.max_teams} onChange={handle} className="input-lol mt-1" />
          </div>
          <div>
            <label className="text-gray-400 text-sm">Premiacao (opcional)</label>
            <input name="prize_pool" value={form.prize_pool} onChange={handle} placeholder="Ex: R$ 100" className="input-lol mt-1" />
          </div>
        </div>
        <div>
          <label className="text-gray-400 text-sm">Data de inicio</label>
          <input name="starts_at" type="datetime-local" value={form.starts_at} onChange={handle} className="input-lol mt-1" />
        </div>
        <button type="submit" disabled={loading} className="btn-gold w-full py-3">
          {loading ? "Criando..." : "Criar Torneio"}
        </button>
      </form>
    </div>
  );
}
