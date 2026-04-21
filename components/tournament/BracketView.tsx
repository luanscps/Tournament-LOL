interface MatchTeam { name: string; tag: string; }
interface Match {
  id: string; round: number; match_number: number; status: string;
  score_a: number; score_b: number;
  team_a?: MatchTeam; team_b?: MatchTeam; winner?: MatchTeam;
}
function MatchCard({ match: m }: { match: Match }) {
  const fin = m.status === "finished";
  return (
    <div className="bg-[#0A1428] border border-[#1E3A5F] rounded min-w-[180px] overflow-hidden">
      {[
        { team:m.team_a, score:m.score_a, isWin: fin && m.winner?.name === m.team_a?.name },
        { team:m.team_b, score:m.score_b, isWin: fin && m.winner?.name === m.team_b?.name },
      ].map(({ team, score, isWin }, i) => (
        <div key={i} className={"flex items-center justify-between px-3 py-1.5 text-sm " + (i===0 ? "border-b border-[#1E3A5F] " : "") + (isWin ? "bg-[#C8A84B]/10" : "")}>
          <span className={"truncate max-w-[120px] " + (team ? (isWin ? "text-[#C8A84B] font-bold" : "text-white") : "text-gray-600")}>
            {team ? <><span className="text-gray-500 text-xs mr-1">[{team.tag}]</span>{team.name}</> : <span className="italic">A definir</span>}
          </span>
          {fin && <span className={"font-bold ml-2 shrink-0 " + (isWin ? "text-[#C8A84B]" : "text-gray-500")}>{score}</span>}
        </div>
      ))}
    </div>
  );
}
export function BracketView({ matches }: { matches: Match[] }) {
  const maxRound = Math.max(...matches.map(m => m.round), 1);
  const rounds   = Array.from({ length: maxRound }, (_, i) =>
    matches.filter(m => m.round === i+1).sort((a,b) => a.match_number - b.match_number));
  function roundName(r: number, total: number) {
    if (r === total)   return "Final";
    if (r === total-1) return "Semifinal";
    if (r === total-2) return "Quartas de Final";
    return "Rodada " + r;
  }
  return (
    <div className="overflow-x-auto pb-2">
      <div className="flex gap-6 min-w-max">
        {rounds.map((roundMatches, i) => (
          <div key={i} className="space-y-2">
            <p className="text-[#C8A84B] text-xs font-bold tracking-wider text-center mb-3">
              {roundName(i+1, maxRound)}
            </p>
            <div className="flex flex-col justify-around" style={{ gap: Math.pow(2,i)*12 + "px", paddingTop: Math.pow(2,i)*6 + "px" }}>
              {roundMatches.map(match => <MatchCard key={match.id} match={match} />)}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
