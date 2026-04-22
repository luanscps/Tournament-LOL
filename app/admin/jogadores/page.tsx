'use client';
import React, { useEffect, useState } from 'react';

interface Jogador {
  id: string;
  summonerName: string;
  tagLine: string;
  teamId: string | null;
  teamName: string | null;
  role: string;
  tier: string;
  rank: string;
  lp: number;
  wins: number;
  losses: number;
  createdAt: string;
}

export default function AdminJogadoresPage() {
  const [jogadores, setJogadores] = useState<Jogador[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [filterTeam, setFilterTeam] = useState('');

  useEffect(() => {
    fetch('/api/admin/jogadores')
      .then((r) => r.json())
      .then((data) => {
        setJogadores(data);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, []);

  const filtered = jogadores.filter((j) => {
    const matchSearch = j.summonerName.toLowerCase().includes(search.toLowerCase());
    const matchTeam = filterTeam ? j.teamName === filterTeam : true;
    return matchSearch && matchTeam;
  });

  const teams = Array.from(new Set(jogadores.map((j) => j.teamName).filter(Boolean)));

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold text-white mb-6">Gerenciamento de Jogadores</h1>

      <div className="flex gap-3 mb-6">
        <input
          type="text"
          placeholder="Buscar jogador..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="bg-[#1E2A3A] border border-[#1E3A5F] text-white px-4 py-2 rounded-lg flex-1"
        />
        <select
          value={filterTeam}
          onChange={(e) => setFilterTeam(e.target.value)}
          className="bg-[#1E2A3A] border border-[#1E3A5F] text-white px-4 py-2 rounded-lg"
        >
          <option value="">Todos os times</option>
          {teams.map((t) => (
            <option key={t} value={t ?? ''}>{t}</option>
          ))}
        </select>
      </div>

      {loading ? (
        <p className="text-gray-400">Carregando...</p>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left">
            <thead>
              <tr className="text-gray-400 border-b border-[#1E3A5F]">
                <th className="pb-3 pr-4">Jogador</th>
                <th className="pb-3 pr-4">Time</th>
                <th className="pb-3 pr-4">Papel</th>
                <th className="pb-3 pr-4">Rank</th>
                <th className="pb-3 pr-4">W/L</th>
                <th className="pb-3">Cadastro</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((j) => {
                const total = j.wins + j.losses;
                const wr = total > 0 ? Math.round((j.wins / total) * 100) : 0;
                return (
                  <tr key={j.id} className="border-b border-[#1E3A5F]/40 hover:bg-[#1E2A3A]/40">
                    <td className="py-3 pr-4">
                      <p className="text-white font-medium">{j.summonerName}</p>
                      <p className="text-gray-500 text-xs">#{j.tagLine}</p>
                    </td>
                    <td className="py-3 pr-4 text-gray-300">{j.teamName ?? <span className="text-gray-600">Sem time</span>}</td>
                    <td className="py-3 pr-4 text-gray-300">{j.role}</td>
                    <td className="py-3 pr-4">
                      <span className="text-yellow-400 font-medium">{j.tier} {j.rank}</span>
                      <span className="text-gray-500 text-xs ml-1">{j.lp} LP</span>
                    </td>
                    <td className="py-3 pr-4">
                      <span className="text-white">{j.wins}W/{j.losses}L</span>
                      <span className={`ml-1 text-xs ${wr >= 50 ? 'text-blue-400' : 'text-red-400'}`}>{wr}%</span>
                    </td>
                    <td className="py-3 text-gray-500 text-xs">{new Date(j.createdAt).toLocaleDateString('pt-BR')}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
          {filtered.length === 0 && (
            <p className="text-gray-500 text-center py-8">Nenhum jogador encontrado.</p>
          )}
        </div>
      )}
    </div>
  );
}
