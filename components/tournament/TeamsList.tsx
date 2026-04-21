interface Team {
  id: string; name: string; tag: string;
  checked_in: boolean; eliminated: boolean; wins: number; losses: number;
  captain?: { username: string; display_name?: string };
  team_members?: { count: number }[];
}
export function TeamsList({ teams }: { teams: Team[] }) {
  return (
    <div className="space-y-2">
      {teams.map(t => (
        <div key={t.id} className={"flex items-center justify-between bg-[#0A1428] rounded p-3 text-sm " + (t.eliminated ? "opacity-40" : "")}>
          <div className="min-w-0">
            <p className="text-white font-medium truncate">
              <span className="text-[#C8A84B] mr-1">[{t.tag}]</span>{t.name}
            </p>
            <p className="text-gray-500 text-xs">
              Cap: {t.captain?.display_name ?? t.captain?.username}
              {t.team_members?.[0]?.count ? " · " + t.team_members[0].count + " jogadores" : ""}
            </p>
          </div>
          <div className="text-right shrink-0 ml-3">
            {t.checked_in   && <span className="text-blue-400 text-xs block">✓ Check-in</span>}
            {t.eliminated   && <span className="text-red-400 text-xs block">Eliminado</span>}
            <span className="text-gray-500 text-xs">{t.wins}V {t.losses}D</span>
          </div>
        </div>
      ))}
    </div>
  );
}
