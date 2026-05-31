'use client';
import Image from 'next/image';

// URL base CommunityDragon — padrão do projeto (não usar DDragon)
const CDN_CHAMPION = (championName: string) =>
  `https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/champion-icons-by-name/${championName.toLowerCase()}.png`;

// Itens: DDragon não tem CORS issue para itens e CDragon não expõe por ID direto — manter CDragon via sprite
// CommunityDragon expõe itens em: /latest/plugins/rcp-be-lol-game-data/global/default/assets/items/icons2d/{itemId}.png
// Mas o nome do arquivo é o displayName, não o ID numérico. A alternativa estável é o endpoint de items JSON.
// Por isso usamos a URL pública: https://raw.communitydragon.org/latest/game/assets/items/icons2d/{hex}.png
// A forma mais simples e sem DD_VERSION: API de itens do CDragon via ID
const CDN_ITEM = (id: number) =>
  `https://ddragon.leagueoflegends.com/cdn/15.10.1/img/item/${id}.png`;
// NOTA: item CDN via DDragon usa versão pinada (15.10.1) até que tenhamos endpoint CDragon estável por ID.
// Isso elimina a necessidade de getDDVersion() em runtime — versão pinada só muda a cada patch maior.

const POSITION_LABEL: Record<string, string> = {
  TOP: 'Top',
  JUNGLE: 'Jungle',
  MIDDLE: 'Mid',
  BOTTOM: 'ADC',
  UTILITY: 'Suporte',
  '': 'ARAM',
};

interface Props {
  championName: string;
  kills: number;
  deaths: number;
  assists: number;
  win: boolean;
  gameDuration: number;
  gameMode: string;
  teamPosition: string;
  cs?: number;
  vision?: number;
  items?: number[];
}

export default function MatchHistoryRow({
  championName,
  kills,
  deaths,
  assists,
  win,
  gameDuration,
  gameMode,
  teamPosition,
  cs = 0,
  vision = 0,
  items = [],
}: Props) {
  const minutes = Math.floor(gameDuration / 60);
  const seconds = gameDuration % 60;
  const kda = deaths === 0 ? 'Perfect' : ((kills + assists) / deaths).toFixed(2);
  const kdaNum = deaths === 0 ? 99 : (kills + assists) / deaths;
  const kdaColor =
    kdaNum >= 5 ? 'text-[#F0C040]' :
    kdaNum >= 3 ? 'text-[#68D391]' :
    kdaNum >= 2 ? 'text-[#A0AEC0]' : 'text-[#FC8181]';
  const posLabel = POSITION_LABEL[teamPosition] ?? (gameMode === 'ARAM' ? 'ARAM' : gameMode);

  // Gradiente sutil por resultado — sem border-left colorido
  const containerStyle: React.CSSProperties = win
    ? {
        background: 'linear-gradient(135deg, rgba(59,130,246,0.08) 0%, var(--surface) 40%)',
        border: '1px solid rgba(59,130,246,0.25)',
        borderRadius: 'var(--radius-lg)',
      }
    : {
        background: 'linear-gradient(135deg, rgba(239,68,68,0.08) 0%, var(--surface) 40%)',
        border: '1px solid rgba(239,68,68,0.20)',
        borderRadius: 'var(--radius-lg)',
      };

  return (
    <div
      className="group flex items-center gap-4 px-4 py-3 transition-all duration-200 hover:brightness-110"
      style={containerStyle}
    >
      {/* Campeão + resultado */}
      <div className="flex items-center gap-3 min-w-[140px]">
        <div className="relative flex-shrink-0">
          <Image
            src={CDN_CHAMPION(championName)}
            width={48}
            height={48}
            alt={championName}
            className="rounded-xl object-cover"
            style={{ border: '2px solid var(--border)' }}
            onError={(e) => {
              // fallback: CDragon icon genérico se nome não bater
              (e.currentTarget as HTMLImageElement).src =
                'https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/champion-icons/-1.png';
            }}
          />
          <span
            className="absolute -bottom-1 -right-1 font-black px-1.5 py-0.5 rounded shadow-lg"
            style={{
              fontSize: 'var(--text-xs)',
              background: win ? 'var(--blue)' : 'var(--loss)',
              color: '#fff',
            }}
          >
            {win ? 'V' : 'D'}
          </span>
        </div>
        <div className="overflow-hidden">
          <p style={{ color: 'var(--text)', fontSize: 'var(--text-sm)', fontWeight: 700 }} className="truncate leading-none">
            {championName}
          </p>
          <p style={{ color: 'var(--text-muted)', fontSize: 'var(--text-xs)' }} className="mt-1 font-medium">
            {posLabel}
          </p>
        </div>
      </div>

      {/* KDA */}
      <div className="w-24 text-center">
        <p style={{ color: 'var(--text)', fontSize: 'var(--text-base)', fontWeight: 900 }} className="tracking-tighter">
          <span>{kills}</span>
          <span style={{ color: 'var(--text-faint)' }} className="mx-1">/</span>
          <span style={{ color: 'var(--loss)' }}>{deaths}</span>
          <span style={{ color: 'var(--text-faint)' }} className="mx-1">/</span>
          <span style={{ color: 'var(--text-muted)' }}>{assists}</span>
        </p>
        <p className={`font-bold mt-0.5 ${kdaColor}`} style={{ fontSize: 'var(--text-xs)' }}>
          {kda === 'Perfect' ? '⭐ PERFECT' : `${kda} KDA`}
        </p>
      </div>

      {/* Items */}
      <div className="flex-1 flex gap-1 justify-center">
        {items.map((id, idx) => (
          <div
            key={idx}
            className="w-8 h-8 rounded-md overflow-hidden"
            style={{ background: 'rgba(0,0,0,0.4)', border: '1px solid var(--border)' }}
          >
            {id > 0 && (
              <img
                src={CDN_ITEM(id)}
                alt={`Item ${id}`}
                width={32}
                height={32}
                loading="lazy"
                className="w-full h-full object-cover"
              />
            )}
          </div>
        ))}
      </div>

      {/* CS + Visão */}
      <div className="text-center hidden md:block w-20 flex-shrink-0">
        <p style={{ color: 'var(--text-muted)', fontSize: 'var(--text-sm)', fontWeight: 700 }}>{cs} CS</p>
        <p style={{ color: 'var(--text-faint)', fontSize: 'var(--text-xs)', fontWeight: 500 }}>
          ({(cs / (gameDuration / 60)).toFixed(1)}/m)
        </p>
      </div>

      {/* Duração */}
      <div className="text-right flex-shrink-0 w-16">
        <p style={{ color: 'var(--text)', fontSize: 'var(--text-sm)', fontWeight: 700 }}>
          {minutes}:{seconds.toString().padStart(2, '0')}
        </p>
        <p style={{ color: 'var(--text-faint)', fontSize: 'var(--text-xs)', fontWeight: 900 }} className="mt-0.5 truncate uppercase tracking-tighter">
          {gameMode}
        </p>
      </div>
    </div>
  );
}
