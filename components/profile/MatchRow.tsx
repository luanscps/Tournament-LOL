import { championIconByCDragon } from "@/lib/riot";
import { Zap } from "lucide-react";

const QUEUE_NAMES: Record<number, string> = {
  420: "Solo/Duo", 440: "Flex 5v5", 450: "ARAM",
  400: "Normal Draft", 430: "Normal Cega", 0: "Custom",
};

const POSITION_PT: Record<string, string> = {
  TOP: "Top", JUNGLE: "Jungle", MIDDLE: "Mid",
  BOTTOM: "ADC", UTILITY: "Sup", NONE: "—",
};

function itemIconUrl(ddVersion: string, itemId: number): string {
  if (!itemId || itemId === 0) return "";
  return `https://ddragon.leagueoflegends.com/cdn/${ddVersion}/img/item/${itemId}.png`;
}

function fmtDuration(seconds: number): string {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m}m ${s.toString().padStart(2, "0")}s`;
}

function timeAgo(ts: number): string {
  const diff = Math.floor((Date.now() - ts) / 1000);
  if (diff < 60)    return `${diff}s atrás`;
  if (diff < 3600)  return `${Math.floor(diff / 60)}min atrás`;
  if (diff < 86400) return `${Math.floor(diff / 3600)}h atrás`;
  return `${Math.floor(diff / 86400)}d atrás`;
}

interface MatchRowProps {
  matchId: string;
  win: boolean;
  championId: number;
  championName: string;
  kills: number;
  deaths: number;
  assists: number;
  teamPosition: string;
  individualPosition: string;
  items: number[];
  queueId: number;
  gameDuration: number;
  gameStartTimestamp: number;
  pentaKills: number;
  ddVersion: string;
  champById: Record<number, string>;
}

export function MatchRow({
  matchId, win, championId, championName, kills, deaths, assists,
  teamPosition, individualPosition, items, queueId, gameDuration,
  gameStartTimestamp, pentaKills, ddVersion, champById,
}: MatchRowProps) {
  const kda       = ((kills + assists) / Math.max(1, deaths)).toFixed(2);
  const champName = champById[championId] ?? championName;
  const queueName = QUEUE_NAMES[queueId] ?? `Fila ${queueId}`;
  const pos       = POSITION_PT[teamPosition] ?? POSITION_PT[individualPosition] ?? "—";

  return (
    <div
      key={matchId}
      className="match-row"
      style={{
        display: "flex",
        alignItems: "center",
        gap: 12,
        padding: "12px 16px",
        borderBottom: "1px solid var(--border-soft, rgba(30,58,95,0.4))",
        transition: "background var(--ease-default, 0.15s ease)",
        background: win
          ? "linear-gradient(90deg, rgba(34,197,94,0.06) 0%, transparent 20%)"
          : "linear-gradient(90deg, rgba(239,68,68,0.06) 0%, transparent 20%)",
        borderLeft: `3px solid ${win ? "rgba(34,197,94,0.27)" : "rgba(239,68,68,0.27)"}`,
      }}
      onMouseEnter={(e) => {
        (e.currentTarget as HTMLDivElement).style.background = "rgba(30,58,95,0.35)";
      }}
      onMouseLeave={(e) => {
        (e.currentTarget as HTMLDivElement).style.background = win
          ? "linear-gradient(90deg, rgba(34,197,94,0.06) 0%, transparent 20%)"
          : "linear-gradient(90deg, rgba(239,68,68,0.06) 0%, transparent 20%)";
      }}
    >
      {/* V/D */}
      <div
        style={{
          width: 32, flexShrink: 0, textAlign: "center",
          fontSize: 12, fontWeight: 800,
          color: win ? "var(--win)" : "var(--loss)",
        }}
      >
        {win ? "V" : "D"}
      </div>

      {/* Ícone campeão + posição */}
      <div style={{ position: "relative", flexShrink: 0 }}>
        <img
          src={championIconByCDragon(championId)}
          width={44}
          height={44}
          alt={champName}
          style={{
            width: 44, height: 44, borderRadius: 8,
            objectFit: "cover", display: "block",
            border: `2px solid ${win ? "rgba(34,197,94,0.27)" : "rgba(239,68,68,0.27)"}`,
          }}
        />
        {pos !== "—" && (
          <span
            style={{
              position: "absolute", bottom: -4, right: -4,
              background: "var(--bg)",
              fontSize: 8, fontWeight: 700,
              color: "var(--gold)",
              border: "1px solid var(--border)",
              borderRadius: 4, padding: "1px 3px", lineHeight: 1.2,
            }}
          >
            {pos}
          </span>
        )}
      </div>

      {/* KDA */}
      <div style={{ minWidth: 90, flexShrink: 0 }}>
        <p style={{ fontSize: 14, fontWeight: 700, color: "var(--text)", lineHeight: 1 }}>
          {kills} / <span style={{ color: "var(--loss)" }}>{deaths}</span> / {assists}
        </p>
        <p style={{ fontSize: 11, color: "var(--text-muted)", marginTop: 2 }}>
          KDA{" "}
          <span
            style={{
              color: Number(kda) >= 3 ? "var(--win)" : "var(--text-muted)",
              fontWeight: 700,
            }}
          >
            {kda}
          </span>
        </p>
      </div>

      {/* Itens */}
      <div style={{ display: "flex", gap: 3, flexShrink: 0, flexWrap: "wrap", maxWidth: 180 }}>
        {items.map((itemId, idx) => (
          <div
            key={idx}
            style={{
              width: 24, height: 24,
              background: itemId ? "var(--surface-2)" : "var(--border-soft, rgba(30,58,95,0.3))",
              borderRadius: 4, overflow: "hidden",
              border: "1px solid var(--border)",
              flexShrink: 0,
            }}
          >
            {itemId > 0 && (
              <img
                src={itemIconUrl(ddVersion, itemId)}
                width={24}
                height={24}
                alt=""
                style={{ width: 24, height: 24, display: "block" }}
              />
            )}
          </div>
        ))}
      </div>

      {/* Metadados */}
      <div style={{ marginLeft: "auto", textAlign: "right", flexShrink: 0 }}>
        <p style={{ fontSize: 11, color: "var(--text-muted)", lineHeight: 1 }}>{queueName}</p>
        <p style={{ fontSize: 11, color: "var(--text-faint)", marginTop: 2 }}>
          {fmtDuration(gameDuration)} · {timeAgo(gameStartTimestamp)}
        </p>
        {pentaKills > 0 && (
          <p
            style={{
              display: "flex", alignItems: "center", justifyContent: "flex-end", gap: 3,
              fontSize: 11, color: "var(--gold)", fontWeight: 700, marginTop: 2,
            }}
          >
            <Zap size={11} />
            PENTA KILL
          </p>
        )}
      </div>
    </div>
  );
}
