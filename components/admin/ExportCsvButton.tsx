'use client';

import { useState } from 'react';

interface Props {
  tournamentId?: string;
  label?: string;
}

export function ExportCsvButton({ tournamentId, label = 'Exportar CSV' }: Props) {
  const [loading, setLoading] = useState(false);

  async function handleExport() {
    setLoading(true);
    try {
      const url = tournamentId
        ? `/api/admin/export-inscricoes?tournament_id=${tournamentId}`
        : '/api/admin/export-inscricoes';

      const res = await fetch(url);
      if (!res.ok) {
        const err = await res.json();
        alert(err.error ?? 'Erro ao exportar');
        return;
      }

      const blob = await res.blob();
      const contentDisposition = res.headers.get('Content-Disposition') ?? '';
      const filenameMatch = contentDisposition.match(/filename="([^"]+)"/);
      const filename = filenameMatch?.[1] ?? 'inscricoes.csv';

      const anchor = document.createElement('a');
      anchor.href = URL.createObjectURL(blob);
      anchor.download = filename;
      anchor.click();
      URL.revokeObjectURL(anchor.href);
    } catch (err) {
      alert('Erro ao exportar CSV');
    } finally {
      setLoading(false);
    }
  }

  return (
    <button
      onClick={handleExport}
      disabled={loading}
      className="flex items-center gap-2 px-3 py-2 bg-[#1E3A5F] hover:bg-[#2a4f7a] text-[#C8A84B] text-sm rounded border border-[#C8A84B]/30 transition-colors disabled:opacity-50"
    >
      <svg xmlns="http://www.w3.org/2000/svg" className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
      </svg>
      {loading ? 'Exportando...' : label}
    </button>
  );
}
