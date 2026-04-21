interface Standing {
  position: number; team_name: string; team_tag: string;
  wins: number; losses: number; games_won: number; games_lost: number;
  points: number; eliminated: boolean;
}
export function StandingsTable({ standings }: { standings: Standing[] }) {
  return (
    <div className="overflow-x-auto">
      <table className="w-full text-sm">
        <thead>
          <tr className="text-gray-400 text-xs border-b border-[#1E3A5F]">
            <th className="text-left pb-2 w-8">#</th>
            <th className="text-left pb-2">Time</th>
            <th className="text-center pb-2">V</th>
            <th className="text-center pb-2">D</th>
            <th className="text-center pb-2">GW</th>
            <th className="text-center pb-2">GL</th>
            <th className="text-right pb-2">Pts</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-[#1E3A5F]/50">
          {standings.map(s => (
            <tr key={s.team_name} className={(s.eliminated ? "opacity-40 " : "") + "hover:bg-[#0A1428] transition-colors"}>
              <td className="py-2 text-gray-500">{s.position}</td>
              <td className="py-2 text-white font-medium">
                <span className="text-[#C8A84B] mr-1">[{s.team_tag}]</span>{s.team_name}
                {s.eliminated && <span className="ml-2 text-red-400 text-xs">(Elim.)</span>}
              </td>
              <td className="py-2 text-center text-green-400">{s.wins}</td>
              <td className="py-2 text-center text-red-400">{s.losses}</td>
              <td className="py-2 text-center text-gray-400">{s.games_won}</td>
              <td className="py-2 text-center text-gray-400">{s.games_lost}</td>
              <td className="py-2 text-right text-[#C8A84B] font-bold">{s.points}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
