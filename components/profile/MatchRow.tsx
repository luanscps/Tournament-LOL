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

// Itens: DDragon com versão pinada (15.10.1) — elimina getDDVersion() em runtime.
// Atualizar pin a cada patch maior.
const ITEM_CDN_VERSION = "15.10.1";
function itemIconUrl(itemId: number): string {
  if (!itemId || itemId === 0) return "";
  return `https://ddragon.leagueoflegends.com/cdn/${ITEM_CDN_VERSION}/img/item/${itemId}.png`;
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
  champById: Record<number, string>;
}

export function MatchRow({
  matchId, win, championId, championName, kills, deaths, assists,
  teamPosition, individualPosition, items, queueId, gameDuration,
  gameStartTimestamp, pentaKills, champById,
}: MatchRowProps) {
  const kda       = ((kills + assists) / Math.max(1, deaths)).toFixed(2);
  const champName = champById[championId] ?? championName;
  const queueName = QUEUE_NAMES[queueId] ?? `Fila ${queueId}`;
  const pos       = POSITION_PT[teamPosition] ?? POSITION_PT[individualPosition] ?? "—";

  // Classe CSS gerenciada via globals.css (.match-row + .win/.loss)
  // Sem inline style de border — resolve conflito border vs borderBottom do PR16
  const resultClass = win ? "win" : "loss";
  const champBorder = win ? "rgba(34,197,94,0.3)" : "rgba(239,68,68,0.3)";

  return (
    <div
      key={matchId}
      className={`match-row ${resultClass}`}
    >
      {/* V/D */}
      <div
        style={{
          width: 32,
          flexShrink: 0,
          textAlign: "center",
          fontSize: "var(--text-xs)",
          fontWeight: 800,
          color: win ? "var(--win)" : "var(--loss)",
        }}
      >
        {win ? "V" : "D"}
      </div>

      {/* Ícone campeão — CommunityDragon por championId */}
      <div style={{ position: "relative", flexShrink: 0 }}>
        <img
          src={championIconByCDragon(championId)}
          width={44}
          height={44}
          alt={champName}
          loading="lazy"
          style={{
            width: 44,
            height: 44,
            borderRadius: 8,
            objectFit: "cover",
            display: "block",
            border: `2px solid ${champBorder}`,
          }}
        />
        {pos !== "—" && (
          <span
            style={{
              position: "absolute",
              bottom: -4,
              right: -4,
              background: "var(--bg)",
              fontSize: "var(--text-xs)",
              fontWeight: 700,
              color: "var(--gold)",
              border: "1px solid var(--border)",
              borderRadius: 4,
              padding: "1px 3px",
              lineHeight: 1.2,
            }}
          >
            {pos}
          </span>
        )}
      </div>

      {/* KDA */}
      <div style={{ minWidth: 90, flexShrink: 0 }}>
        <p style={{ fontSize: "var(--text-sm)", fontWeight: 700, color: "var(--text)", lineHeight: 1 }}>
          {kills} / <span style={{ color: "var(--loss)" }}>{deaths}</span> / {assists}
        </p>
        <p style={{ fontSize: "var(--text-xs)", color: "var(--text-muted)", marginTop: 2 }}>
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

      {/* Itens — DDragon versão pinada */}
      <div style={{ display: "flex", gap: 3, flexShrink: 0, flexWrap: "wrap", maxWidth: 180 }}>
        {items.map((itemId, idx) => (
          <div
            key={idx}
            style={{
              width: 24,
              height: 24,
              background: itemId ? "var(--surface-2)" : "var(--border-soft)",
              borderRadius: 4,
              overflow: "hidden",
              border: "1px solid var(--border)",
              flexShrink: 0,
            }}
          >
            {itemId > 0 && (
              <img
                src={itemIconUrl(itemId)}
                width={24}
                height={24}
                alt=""
                loading="lazy"
                style={{ width: 24, height: 24, display: "block" }}
              />
            )}
          </div>
        ))}
      </div>

      {/* Metadados */}
      <div style={{ marginLeft: "auto", textAlign: "right", flexShrink: 0 }}>
        <p style={{ fontSize: "var(--text-xs)", color: "var(--text-muted)", lineHeight: 1 }}>
          {queueName}
        </p>
        <p style={{ fontSize: "var(--text-xs)", color: "var(--text-faint)", marginTop: 2 }}>
          {fmtDuration(gameDuration)} · {timeAgo(gameStartTimestamp)}
        </p>
        {pentaKills > 0 && (
          <p
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "flex-end",
              gap: 3,
              fontSize: "var(--text-xs)",
              color: "var(--gold)",
              fontWeight: 700,
              marginTop: 2,
            }}
          >
            <Zap size={11} aria-hidden="true" />
            PENTA KILL
          </p>
        )}
      </div>
    </div>
  );
}
