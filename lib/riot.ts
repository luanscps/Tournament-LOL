// lib/riot.ts
import { getCached, setCached } from "@/lib/riot-cache";

// ─── CORREÇÃO BUG 1: leitura lazy dentro de função, nunca no module-level ─────
function getApiKey(): string {
  const key = process.env.RIOT_API_KEY;
  if (!key) {
    throw new Error("RIOT_API_KEY não configurada no servidor. Adicione no .env.local");
  }
  return key;
}

// Mapa de region → regional routing value (continental)
const REGION_TO_REGIONAL: Record<string, string> = {
  br1: "americas",
  na1: "americas",
  la1: "americas",
  la2: "americas",
  euw1: "europe",
  eun1: "europe",
  tr1: "europe",
  ru: "europe",
  kr: "asia",
  jp1: "asia",
  oc1: "sea",
  ph2: "sea",
  sg2: "sea",
  th2: "sea",
  tw2: "sea",
  vn2: "sea",
};

function getRegion(): string {
  return (process.env.RIOT_REGION ?? "br1").toLowerCase();
}

function getRegionalHost(): string {
  const region = getRegion();
  // ─── CORREÇÃO BUG 3: regional derivado da region, nunca fixo ──────────────
  return process.env.RIOT_REGIONAL_HOST ?? REGION_TO_REGIONAL[region] ?? "americas";
}

function getPlatformUrl(): string {
  return "https://" + getRegion() + ".api.riotgames.com";
}

function getRegionalUrl(): string {
  return "https://" + getRegionalHost() + ".api.riotgames.com";
}

// ─── Data Dragon: versão dinâmica ─────────────────────────────────────────────
let _ddVersion: string | null = null;

export async function getDDVersion(): Promise<string> {
  if (_ddVersion) return _ddVersion;
  const cached = getCached<string>("dd:version");
  if (cached) { _ddVersion = cached; return cached; }
  try {
    const res = await fetch("https://ddragon.leagueoflegends.com/api/versions.json", {
      next: { revalidate: 3600 },
    });
    const versions: string[] = await res.json();
    _ddVersion = versions[0];
    setCached("dd:version", _ddVersion, 3600);
    return _ddVersion;
  } catch {
    _ddVersion = "16.8.1";
    return _ddVersion;
  }
}

// ─── Helper principal ─────────────────────────────────────────────────────────
async function riotFetch<T>(url: string): Promise<T> {
  const apiKey = getApiKey(); // ← CORREÇÃO BUG 1: lazy, nunca no import

  const res = await fetch(url, {
    headers: { "X-Riot-Token": apiKey },
    next: { revalidate: 300 },
  });

  if (!res.ok) {
    const e = await res.json().catch(() => ({}));
    const msg = e?.status?.message ?? res.statusText;
    throw new Error(`Riot API ${res.status}: ${msg}`);
  }

  return res.json() as Promise<T>;
}

// ─── Endpoints ────────────────────────────────────────────────────────────────

export async function getAccountByRiotId(
  gameName: string,
  tagLine: string
): Promise<RiotAccount> {
  const key = ("account:" + gameName + "#" + tagLine).toLowerCase();
  const cached = getCached<RiotAccount>(key);
  if (cached) return cached;

  const data = await riotFetch<RiotAccount>(
    getRegionalUrl() +
    "/riot/account/v1/accounts/by-riot-id/" +
    encodeURIComponent(gameName) + "/" +
    encodeURIComponent(tagLine)
  );
  setCached(key, data, 600);
  return data;
}

export async function getSummonerByPuuid(puuid: string): Promise<Summoner> {
  const key = "summoner:" + puuid;
  const cached = getCached<Summoner>(key);
  if (cached) return cached;

  const data = await riotFetch<Summoner>(
    getPlatformUrl() + "/lol/summoner/v4/summoners/by-puuid/" + puuid
  );
  setCached(key, data, 300);
  return data;
}

export async function getLeagueEntriesByPuuid(puuid: string): Promise<LeagueEntry[]> {
  const key = "league:" + puuid;
  const cached = getCached<LeagueEntry[]>(key);
  if (cached) return cached;

  // ─── CORREÇÃO BUG 2: usa /by-puuid direto, sem buscar summoner antes ──────
  const data = await riotFetch<LeagueEntry[]>(
    getPlatformUrl() + "/lol/league/v4/entries/by-puuid/" + puuid
  );
  setCached(key, data, 300);
  return data;
}

export async function getTopMasteriesByPuuid(
  puuid: string,
  count = 5
): Promise<ChampionMastery[]> {
  const key = "mastery:" + puuid + ":" + count;
  const cached = getCached<ChampionMastery[]>(key);
  if (cached) return cached;

  const data = await riotFetch<ChampionMastery[]>(
    getPlatformUrl() +
    "/lol/champion-mastery/v4/champion-masteries/by-puuid/" +
    puuid + "/top?count=" + count
  );
  setCached(key, data, 600);
  return data;
}

export async function getMatchIdsByPuuid(
  puuid: string,
  count = 20,
  queue?: number
): Promise<string[]> {
  const key = "matchids:" + puuid + ":" + count + ":" + (queue ?? "all");
  const cached = getCached<string[]>(key);
  if (cached) return cached;

  const q = queue ? "&queue=" + queue : "";
  const data = await riotFetch<string[]>(
    getRegionalUrl() +
    "/lol/match/v5/matches/by-puuid/" +
    puuid + "/ids?count=" + count + q
  );
  setCached(key, data, 120);
  return data;
}

export async function getMatchById(matchId: string): Promise<MatchDto> {
  const key = "match:" + matchId;
  const cached = getCached<MatchDto>(key);
  if (cached) return cached;

  const data = await riotFetch<MatchDto>(
    getRegionalUrl() + "/lol/match/v5/matches/" + matchId
  );
  setCached(key, data, 3600);
  return data;
}

// ─── Asset URLs — Data Dragon (sem API Key) ───────────────────────────────────

/** Ícone circular de perfil do invocador */
export async function profileIconUrl(id: number): Promise<string> {
  const v = await getDDVersion();
  return `https://ddragon.leagueoflegends.com/cdn/${v}/img/profileicon/${id}.png`;
}

/** Ícone quadrado do campeão (usado em cartas, listas) */
export async function championIconUrl(name: string): Promise<string> {
  const v = await getDDVersion();
  return `https://ddragon.leagueoflegends.com/cdn/${v}/img/champion/${name}.png`;
}

/**
 * Splash art do campeão.
 * @param name  Nome exato do campeão (ex: "Ahri", "MissFortune")
 * @param skinNum  0 = skin base, 1+ = skins numeradas
 */
export function championSplashUrl(name: string, skinNum = 0): string {
  return `https://ddragon.leagueoflegends.com/cdn/img/champion/splash/${name}_${skinNum}.jpg`;
}

/**
 * Imagem de loading screen do campeão.
 * @param name  Nome exato do campeão
 * @param skinNum  0 = skin base, 1+ = skins numeradas
 */
export function championLoadingUrl(name: string, skinNum = 0): string {
  return `https://ddragon.leagueoflegends.com/cdn/img/champion/loading/${name}_${skinNum}.jpg`;
}

/** Ícone de item (útil para exibir item0–item6 em MatchParticipant) */
export async function itemIconUrl(itemId: number): Promise<string> {
  const v = await getDDVersion();
  return `https://ddragon.leagueoflegends.com/cdn/${v}/img/item/${itemId}.png`;
}

/** Ícone de summoner spell (ex: "SummonerFlash", "SummonerIgnite") */
export async function summonerSpellIconUrl(spellId: string): Promise<string> {
  const v = await getDDVersion();
  return `https://ddragon.leagueoflegends.com/cdn/${v}/img/spell/${spellId}.png`;
}

// ─── Asset URLs — CommunityDragon (sem API Key) ───────────────────────────────

/**
 * Emblema de rank (tier).
 * @param tier  ex: "iron", "bronze", "silver", "gold", "platinum",
 *              "emerald", "diamond", "master", "grandmaster", "challenger"
 */
export function rankEmblemUrl(tier: string): string {
  const t = tier.toLowerCase();
  return `https://raw.communitydragon.org/latest/plugins/rcp-fe-lol-shared-components/global/default/ranked-mini-regalia/${t}.png`;
}

/**
 * Ícone visual do nível de maestria do campeão (1–10).
 * @param level  Nível de maestria (1 a 10)
 */
export function masteryIconUrl(level: number): string {
  const clamped = Math.min(Math.max(level, 1), 10);
  return `https://raw.communitydragon.org/latest/plugins/rcp-fe-lol-champion-mastery/global/default/mastery-${clamped}.png`;
}

// ─── Data Dragon: JSON estático ───────────────────────────────────────────────

/**
 * Retorna todos os campeões do jogo em português (pt_BR).
 * Útil para seletores de campeão, filtros e listagens no painel de torneio.
 * Cache de 1 hora — dados mudam apenas em novos patches.
 */
export async function getAllChampions(): Promise<Record<string, ChampionBasic>> {
  const cacheKey = "dd:champions:pt_BR";
  const cached = getCached<Record<string, ChampionBasic>>(cacheKey);
  if (cached) return cached;

  const v = await getDDVersion();
  const res = await fetch(
    `https://ddragon.leagueoflegends.com/cdn/${v}/data/pt_BR/champion.json`,
    { next: { revalidate: 3600 } }
  );
  const json = await res.json();
  const data: Record<string, ChampionBasic> = json.data;
  setCached(cacheKey, data, 3600);
  return data;
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
  championName: string;
  championLevel: number;
  championPoints: number;
  lastPlayTime: number;
}

export interface ChampionBasic {
  id: string;
  key: string;
  name: string;
  title: string;
  blurb: string;
  tags: string[];
  image: {
    full: string;
    sprite: string;
    group: string;
    x: number;
    y: number;
    w: number;
    h: number;
  };
  stats: Record<string, number>;
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
