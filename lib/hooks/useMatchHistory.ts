import { useState, useEffect } from 'react';

export interface MatchEntry {
  matchId: string;
  championName: string;
  teamPosition: string;
  gameMode: string;
  kills: number;
  deaths: number;
  assists: number;
  kda: string;
  win: boolean;
  minutes: number;
}

interface UseMatchHistoryResult {
  matches: MatchEntry[];
  loading: boolean;
  error: string | null;
  refetch: () => void;
}

export function useMatchHistory(puuid: string | null, count = 10): UseMatchHistoryResult {
  const [matches, setMatches] = useState<MatchEntry[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [trigger, setTrigger] = useState(0);

  useEffect(() => {
    if (!puuid) return;
    setLoading(true);
    setError(null);
    fetch(`/api/riot/match-history?puuid=${encodeURIComponent(puuid)}&count=${count}`)
      .then(async (res) => {
        if (!res.ok) throw new Error('Erro ao buscar historico');
        return res.json();
      })
      .then((data: MatchEntry[]) => {
        setMatches(data);
        setLoading(false);
      })
      .catch((err: Error) => {
        setError(err.message);
        setLoading(false);
      });
  }, [puuid, count, trigger]);

  return { matches, loading, error, refetch: () => setTrigger((t) => t + 1) };
}
