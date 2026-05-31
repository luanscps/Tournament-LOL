import Image from 'next/image';

// CommunityDragon por championId numérico — padrão do projeto
// Usado aqui via championName → precisamos do ID. Como ChampionStatsTable recebe apenas `name` (string),
// usamos o endpoint CDragon de ícone por nome (slug lowercase) que é estável:
const CDN_CHAMPION_BY_NAME = (name: string) =>
  `https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/champion-icons-by-name/${name.toLowerCase()}.png`;

interface ChampStat {
  name: string;
  games: number;
  wr: number;
  kda: string;
  kills: number;
  deaths: number;
  assists: number;
  championId?: number; // opcional: se disponível, usa por ID (mais preciso)
}

// DD_VERSION removido — não mais necessário
interface Props {
  champions: ChampStat[];
}

export default function ChampionStatsTable({ champions }: Props) {
  if (!champions.length) {
    return (
      <div
        className="rounded-xl p-4 text-center"
        style={{
          background: 'var(--surface)',
          border: '1px solid var(--border)',
          color: 'var(--text-faint)',
          fontSize: 'var(--text-sm)',
        }}
      >
        Sem dados suficientes.
      </div>
    );
  }

  return (
    <div
      className="rounded-xl overflow-hidden"
      style={{ background: 'var(--surface)', border: '1px solid var(--border)' }}
    >
      <table className="w-full" style={{ fontSize: 'var(--text-xs)' }}>
        <thead>
          <tr style={{ borderBottom: '1px solid var(--border)' }}>
            {['Campeão', 'Jogos', 'WR', 'KDA'].map((h, i) => (
              <th
                key={h}
                className={i === 0 ? 'text-left' : 'text-center'}
                style={{
                  color: 'var(--text-muted)',
                  fontWeight: 700,
                  textTransform: 'uppercase',
                  letterSpacing: '0.08em',
                  padding: '8px 12px',
                }}
              >
                {h}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {champions.map((c, i) => {
            const wrColor =
              c.wr >= 60 ? 'var(--gold)' :
              c.wr >= 50 ? 'var(--win)' : 'var(--loss)';
            const kdaNum = parseFloat(c.kda);
            const kdaColor =
              c.kda === 'Perfect' || kdaNum >= 5 ? 'var(--gold)' :
              kdaNum >= 3 ? 'var(--win)' :
              kdaNum >= 2 ? 'var(--text-muted)' : 'var(--loss)';

            // Usa CDragon por ID se disponível, senão por nome (slug)
            const iconSrc = c.championId
              ? `https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/champion-icons/${c.championId}.png`
              : CDN_CHAMPION_BY_NAME(c.name);

            return (
              <tr
                key={c.name}
                style={{
                  borderBottom: i === champions.length - 1 ? 'none' : '1px solid var(--border-soft)',
                  transition: 'background 150ms ease',
                }}
                className="hover:bg-[var(--surface-2)]"
              >
                <td style={{ padding: '10px 12px' }}>
                  <div className="flex items-center gap-2">
                    <Image
                      src={iconSrc}
                      width={28}
                      height={28}
                      alt={c.name}
                      loading="lazy"
                      className="rounded"
                      style={{ border: '1px solid var(--border)' }}
                      onError={(e) => {
                        // fallback para ícone genérico CDragon se slug não bater
                        (e.currentTarget as HTMLImageElement).src =
                          'https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/champion-icons/-1.png';
                      }}
                    />
                    <span
                      className="truncate max-w-[80px]"
                      style={{ color: 'var(--text)', fontWeight: 500 }}
                    >
                      {c.name}
                    </span>
                  </div>
                </td>
                <td className="text-center" style={{ color: 'var(--text-muted)', padding: '10px 8px' }}>
                  {c.games}
                </td>
                <td className="text-center font-bold" style={{ color: wrColor, padding: '10px 8px' }}>
                  {c.wr}%
                </td>
                <td className="text-center font-semibold" style={{ color: kdaColor, padding: '10px 8px' }}>
                  {c.kda === 'Perfect' ? '∞' : c.kda}
                  <div style={{ color: 'var(--text-faint)', fontWeight: 400, fontSize: 'var(--text-xs)' }}>
                    {c.kills}/{c.deaths}/{c.assists}
                  </div>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
