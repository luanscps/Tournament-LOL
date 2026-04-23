import { getCached, setCached } from "@/lib/riot-cache";

const API_KEY       = process.env.RIOT_API_KEY;
const REGION        = process.env.RIOT_REGION        ?? "br1";
const REGIONAL_HOST = process.env.RIOT_REGIONAL_HOST ?? "americas";

const PLATFORM = "https://" + REGION + ".api.riotgames.com";
const REGIONAL = "https://" + REGIONAL_HOST + ".api.riotgames.com";

// ─── Data Dragon: busca versão atual dinamicamente ───────────────────────────
let _ddVersion: string | null = null;

export async function getDDVersion(): Promise<string> {
  if (_ddVersion) return _ddVersion;
  const cached = getCached<string>("dd:version");
  if (cached) { _ddVersion = cached; return cached; }
  try {
    const res = await fetch("https://ddragon.leagueoflegends.com/api/versions.json", {
      next: { revalidate: 3600 }, // revalida a cada 1h
    });
    const versions: string[] = await res.json();
    _ddVersion = versions[0]; // "16.8.1" atualmente
    setCached("dd:version", _ddVersion, 3600);
    return _ddVersion;
  } catch {
    _ddVersion = "16.8.1"; // fallback explícito
    return _ddVersion;
  }
}

// ─── Helper principal ─────────────────────────────────────────────────────────
async function riotFetch<T>(url: string): Promise<T> {
  if (!API_KEY) {
    throw new Error("RIOT_API_KEY não configurada no servidor. Adicione no .env.local");
  }
  const res = await fetch(url, {
    headers: { "X-Riot-Token": API_KEY },
    next: { revalidate: 300 },
  });
  if (!res.ok) {
    const e = await res.json().catch(() => ({}));
    const msg = e?.status?.message ?? res.statusText;
    // 403 = chave inválida/expirada | 404 = jogador não existe | 429 = rate limit
    throw new Error(`Riot API ${res.status}: ${msg}`);
  }
  return res.json() as Promise<T>;
}

// ─── Endpoints ────────────────────────────────────────────────────────────────
export async function getAccountByRiotId(gameName: string, tagLine: string): Promise<RiotAccount> {
  const key = ("account:" + gameName + "#" + tagLine).toLowerCase();
  const cached = getCached<RiotAccount>(key);
  if (cached) return cached;
  const data = await riotFetch<RiotAccount>(
    REGIONAL + "/riot/account/v1/accounts/by-riot-id/" +
    encodeURIComponent(gameName) + "/" + encodeURIComponent(tagLine)
  );
  setCached(key, data, 600);
  return data;
}

export async function getSummonerByPuuid(puuid: string): Promise<Summoner> {
  const key = "summoner:" + puuid;
  const cached = getCached<Summoner>(key);
  if (cached) return cached;
  const data = await riotFetch<Summoner>(
    PLATFORM + "/lol/summoner/v4/summoners/by-puuid/" + puuid
  );
  setCached(key, data, 300);
  return data;
}

export async function getLeagueEntriesByPuuid(puuid: string): Promise<LeagueEntry[]> {
  const key = "league:" + puuid;
  const cached = getCached<LeagueEntry[]>(key);
  if (cached) return cached;
  const summoner = await getSummonerByPuuid(puuid);
  const data = await riotFetch<LeagueEntry[]>(
    PLATFORM + "/lol/league/v4/entries/by-summoner/" + summoner.id
  );
  setCached(key, data, 300);
  return data;
}

export async function getTopMasteriesByPuuid(puuid: string, count = 5): Promise<ChampionMastery[]> {
  const key = "mastery:" + puuid + ":" + count;
  const cached = getCached<ChampionMastery[]>(key);
  if (cached) return cached;
  const data = await riotFetch<ChampionMastery[]>(
    PLATFORM + "/lol/champion-mastery/v4/champion-masteries/by-puuid/" + puuid + "/top?count=" + count
  );
  setCached(key, data, 600);
  return data;
}

export async function getMatchIdsByPuuid(puuid: string, count = 20, queue?: number): Promise<string[]> {
  const key = "matchids:" + puuid + ":" + count + ":" + (queue ?? "all");
  const cached = getCached<string[]>(key);
  if (cached) return cached;
  const q = queue ? "&queue=" + queue : "";
  const data = await riotFetch<string[]>(
    REGIONAL + "/lol/match/v5/matches/by-puuid/" + puuid + "/ids?count=" + count + q
  );
  setCached(key, data, 120);
  return data;
}

export async function getMatchById(matchId: string): Promise<MatchDto> {
  const key = "match:" + matchId;
  const cached = getCached<MatchDto>(key);
  if (cached) return cached;
  const data = await riotFetch<MatchDto>(REGIONAL + "/lol/match/v5/matches/" + matchId);
  setCached(key, data, 3600);
  return data;
}

// URLs de assets (usam versão dinâmica)
export async function profileIconUrl(id: number): Promise<string> {
  const v = await getDDVersion();
  return `https://ddragon.leagueoflegends.com/cdn/${v}/img/profileicon/${id}.png`;
}
export async function championIconUrl(name: string): Promise<string> {
  const v = await getDDVersion();
  return `https://ddragon.leagueoflegends.com/cdn/${v}/img/champion/${name}.png`;
}

// ─── Interfaces ───────────────────────────────────────────────────────────────
export interface RiotAccount {
  puuid: string;
  gameName: string;
  tagLine: string;
}
export interface Summoner {
  id: string;
  accountId: string;
  puuid: string;
  profileIconId: number;
  revisionDate: number;
  summonerLevel: number;
}
export interface LeagueEntry {
  leagueId: string;
  queueType: string;
  tier: string;
  rank: string;
  summonerId: string;
  leaguePoints: number;
  wins: number;
  losses: number;
  hotStreak: boolean;
  veteran: boolean;
  freshBlood: boolean;
  inactive: boolean;
}
export interface ChampionMastery {
  championId: number;
  championName: string; // ← estava faltando na interface original
  championLevel: number;
  championPoints: number;
  lastPlayTime: number;
}
export interface MatchDto {
  metadata: { matchId: string; participants: string[] };
  info: MatchInfo;
}
export interface MatchInfo {
  gameId: number;
  gameDuration: number;
  gameMode: string;
  queueId: number;
  gameStartTimestamp: number;
  participants: MatchParticipant[];
  teams: MatchTeam[];
}
export interface MatchTeam {
  teamId: number;
  win: boolean;
  objectives: {
    baron: { kills: number };
    dragon: { kills: number };
    tower: { kills: number };
  };
}
export interface MatchParticipant {
  puuid: string;
  summonerName: string;
  championName: string;
  championId: number;
  kills: number;
  deaths: number;
  assists: number;
  win: boolean;
  teamId: number;
  totalDamageDealtToChampions: number;
  goldEarned: number;
  totalMinionsKilled: number;
  visionScore: number;
  item0: number; item1: number; item2: number;
  item3: number; item4: number; item5: number; item6: number;
  pentaKills: number;
  individualPosition: string;
  teamPosition: string;
}