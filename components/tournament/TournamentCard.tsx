import Link from "next/link";
import { getQueueLabel } from "@/lib/utils";
interface Tournament {
  id: string; slug: string; name: string; description?: string;
  status: string; max_teams: number; queue_type: string;
  bracket_type: string; prize_pool?: string; starts_at?: string;
}
const STATUS_CONFIG: Record<string,{ label:string; color:string; dot:string }> = {
  open:      { label:"Inscricoes Abertas", color:"text-green-400",  dot:"bg-green-400" },
  checkin:   { label:"Check-in",           color:"text-blue-400",   dot:"bg-blue-400" },
  ongoing:   { label:"Em Andamento",        color:"text-yellow-400", dot:"bg-yellow-400" },
  finished:  { label:"Encerrado",           color:"text-gray-400",   dot:"bg-gray-500" },
  draft:     { label:"Em breve",            color:"text-gray-500",   dot:"bg-gray-600" },
  cancelled: { label:"Cancelado",           color:"text-red-400",    dot:"bg-red-400" },
};
export function TournamentCard({ tournament: t }: { tournament: Tournament }) {
  const s = STATUS_CONFIG[t.status] ?? STATUS_CONFIG.draft;
  return (
    <Link href={"/torneios/" + t.slug}
      className="card-lol block hover:border-[#C8A84B]/50 transition-colors group">
      <div className="flex items-start justify-between mb-3">
        <div className="flex-1 min-w-0 pr-3">
          <p className="text-xs text-gray-500 mb-1">{getQueueLabel(t.queue_type)} · {t.bracket_type?.replace("_"," ")}</p>
          <h3 className="text-white font-bold group-hover:text-[#C8A84B] transition-colors leading-tight truncate">{t.name}</h3>
        </div>
        <div className="flex items-center gap-1.5 shrink-0">
          <span className={"w-1.5 h-1.5 rounded-full " + s.dot} />
          <span className={"text-xs font-medium " + s.color}>{s.label}</span>
        </div>
      </div>
      {t.description && <p className="text-gray-400 text-sm line-clamp-2 mb-3">{t.description}</p>}
      <div className="flex items-center justify-between pt-3 border-t border-[#1E3A5F]">
        <span className="text-gray-500 text-xs">🛡️ Ate {t.max_teams} times</span>
        <div className="flex items-center gap-3">
          {t.prize_pool && <span className="text-[#C8A84B] text-xs font-bold">🏆 {t.prize_pool}</span>}
          {t.starts_at && <span className="text-gray-500 text-xs">{new Date(t.starts_at).toLocaleDateString("pt-BR")}</span>}
        </div>
      </div>
    </Link>
  );
}
