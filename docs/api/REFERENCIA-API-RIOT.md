# Referência da API Riot Games — ArenaGG

> **Fonte de verdade:** `lib/riot.ts` e `lib/riot-rate-limiter.ts`.
> Última revisão: 2026-06-01

---

## Base URLs

| Contexto | Base URL | Usado em |
|---|---|---|
| Conta / Match / Tournament (regional) | `https://americas.api.riotgames.com` | account-v1, match-v5, tournament-v5/stub |
| Plataforma BR1 | `https://br1.api.riotgames.com` | summoner-v4, league-v4, champion-mastery-v4, spectator-v5 |

**Autenticação:** Header `X-Riot-Token: {RIOT_API_KEY}` em todas as chamadas.

**Variáveis de ambiente:**
```
RIOT_API_KEY=              # Chave de produção (tournament-v5) ou dev (stub)
RIOT_TOURNAMENT_API_KEY=   # Chave exclusiva da Tournament API (aprovada pela Riot)
RIOT_PROVIDER_ID=          # ID do provider registrado (riot_tournament_registrations.riot_provider_id)
RIOT_TOURNAMENT_ID=        # ID do torneio ativo na Riot (riot_tournament_registrations.riot_tournament_id)
RIOT_CALLBACK_URL=         # URL pública do /api/tournament/callback
RIOT_HMAC_SECRET=          # Secret para validação HMAC do callback
```

---

## account-v1

Base: `https://americas.api.riotgames.com`

| Método | Endpoint | Assinatura em `lib/riot.ts` |
|---|---|---|
| GET | `/riot/account/v1/accounts/by-riot-id/{gameName}/{tagLine}` | `getAccountByRiotId(gameName, tagLine)` |
| GET | `/riot/account/v1/accounts/by-puuid/{puuid}` | `getAccountByPuuid(puuid)` |

**Resposta:**
```ts
{
  puuid: string;
  gameName: string;
  tagLine: string;
}
```

**Armazenado em:** `riot_accounts` — `puuid`, `game_name`, `tag_line`

---

## summoner-v4

Base: `https://br1.api.riotgames.com`

| Método | Endpoint | Assinatura em `lib/riot.ts` |
|---|---|---|
| GET | `/lol/summoner/v4/summoners/by-puuid/{encryptedPUUID}` | `getSummonerByPuuid(puuid)` |

> O parâmetro `{encryptedPUUID}` neste endpoint refere-se ao `puuid` do jogador. O termo "encrypted" é da nomenclatura interna Riot — o valor passado é o `puuid` obtido via account-v1.

**Resposta:**
```ts
{
  id: string;           // summonerId (encrypted) — usado em league-v4
  accountId: string;
  puuid: string;
  name: string;         // deprecated → usar gameName+tagLine de account-v1
  profileIconId: number;
  revisionDate: number;
  summonerLevel: number;
}
```

**Armazenado em:** `riot_accounts.summoner_id` (campo `id` da resposta)

---

## league-v4

Base: `https://br1.api.riotgames.com`

| Método | Endpoint | Assinatura em `lib/riot.ts` |
|---|---|---|
| GET | `/lol/league/v4/entries/by-summoner/{encryptedSummonerId}` | `getLeagueEntriesBySummoner(summonerId)` |

> `{encryptedSummonerId}` é o campo `id` retornado por summoner-v4 (diferente do puuid).

**Resposta (array — pode conter múltiplas filas):**
```ts
[{
  leagueId: string;
  summonerId: string;
  queueType: string;    // "RANKED_SOLO_5x5" | "RANKED_FLEX_SR"
  tier: string;         // IRON | BRONZE | SILVER | GOLD | PLATINUM | EMERALD | DIAMOND | MASTER | GRANDMASTER | CHALLENGER
  rank: string;         // I | II | III | IV
  leaguePoints: number;
  wins: number;
  losses: number;
  hotStreak: boolean;
  veteran: boolean;
  freshBlood: boolean;
  inactive: boolean;
}]
```

**Armazenado em:** `players.current_rank`, `players.current_tier`, `players.current_lp`, `rank_snapshots`

> O sync itera por todas as entradas do array. Tanto `RANKED_SOLO_5x5` quanto `RANKED_FLEX_SR` são salvos em `rank_snapshots` (um registro por fila por sync).

**Mapeamentos de tier:**
```
IRON < BRONZE < SILVER < GOLD < PLATINUM < EMERALD < DIAMOND < MASTER < GRANDMASTER < CHALLENGER
```

**Mapeamentos de fila (queueType):**
| queueType | Significado |
|---|---|
| `RANKED_SOLO_5x5` | Solo/Duo — usado para `players.current_rank` |
| `RANKED_FLEX_SR` | Flex 5v5 — salvo em `rank_snapshots`, não em `players` |

---

## match-v5

Base: `https://americas.api.riotgames.com`

| Método | Endpoint | Assinatura em `lib/riot.ts` |
|---|---|---|
| GET | `/lol/match/v5/matches/{matchId}` | `getMatchById(matchId)` |
| GET | `/lol/match/v5/matches/by-puuid/{puuid}/ids` | `getMatchIdsByPuuid(puuid, params?)` |

**matchId format:** `{PLATFORM}_{gameId}` — ex: `BR1_1234567890`

**Campos usados de `MatchDto.info`:**
```ts
{
  gameId: number;
  gameDuration: number;        // segundos
  participants: [{
    puuid: string;
    championName: string;
    kills: number;
    deaths: number;
    assists: number;
    goldEarned: number;
    totalMinionsKilled: number;
    neutralMinionsKilled: number;
    visionScore: number;
    totalDamageDealtToChampions: number;
    win: boolean;
    teamId: number;            // 100 = blue, 200 = red
  }]
}
```

**Armazenado em:** `match_games`, `player_stats`

---

## spectator-v5

Base: `https://br1.api.riotgames.com`

| Método | Endpoint | Assinatura em `lib/riot.ts` |
|---|---|---|
| GET | `/lol/spectator/v5/active-games/by-summoner/{puuid}` | `getActiveGame(puuid)` |

> O parâmetro de path é o `puuid` do jogador (obtido de `riot_accounts.puuid`). Apesar do nome `by-summoner` na URL, a Riot aceita o puuid diretamente neste endpoint na v5.

**Resposta (jogo ativo):**
```ts
{
  gameId: number;
  gameType: string;
  gameStartTime: number;
  mapId: number;
  gameLength: number;
  platformId: string;
  gameMode: string;
  gameQueueConfigId: number;
  participants: [{
    summonerId: string;
    puuid: string;
    championId: number;
    teamId: number;  // 100 | 200
  }]
}
```

**Usado em:** `lib/actions/inscricao.ts → fazerCheckinOrganizador()` para confirmar que o time está em jogo na plataforma antes de registrar o check-in.

**Tratamento de erro 404:** Se o jogador não está em partida, a Riot retorna `404`. O código trata como `{ success: false, error: 'Partida ainda não iniciada' }` sem lançar exceção.

**Tratamento de Riot API offline:** `fazerCheckinOrganizador` usa `Promise.allSettled` — se a API estiver indisponível, o check-in é permitido (não penaliza por falha da Riot).

---

## champion-mastery-v4

Base: `https://br1.api.riotgames.com`

| Método | Endpoint | Assinatura em `lib/riot.ts` |
|---|---|---|
| GET | `/lol/champion-mastery/v4/champion-masteries/by-puuid/{encryptedPUUID}` | `getChampionMasteries(puuid)` |
| GET | `/lol/champion-mastery/v4/champion-masteries/by-puuid/{encryptedPUUID}/top` | `getTopChampionMasteries(puuid, count?)` |

**Armazenado em:** `champion_masteries` — `champion_id`, `champion_level`, `champion_points`

---

## tournament-v5 vs tournament-stub-v5

| Aspecto | tournament-v5 (produção) | tournament-stub-v5 (dev/teste) |
|---|---|---|
| Base URL | `https://americas.api.riotgames.com` | `https://americas.api.riotgames.com` |
| Path | `/lol/tournament/v5/...` | `/lol/tournament-stub/v5/...` |
| Chave necessária | Chave de torneio aprovada (`RIOT_TOURNAMENT_API_KEY`) | Chave de desenvolvimento padrão (`RIOT_API_KEY`) |
| Gera códigos reais | ✅ Sim | ❌ Não (retorna códigos fictícios) |
| Callback real da Riot | ✅ Sim | ❌ Não disparado automaticamente |
| Env var | `RIOT_TOURNAMENT_API_KEY` | `RIOT_API_KEY` |

**Endpoints utilizados:**
```
POST /lol/tournament/v5/providers
  → Registra provider com callbackUrl e region
  → Salva em riot_tournament_registrations:
       riot_provider_id  ← ID retornado pela Riot

POST /lol/tournament/v5/tournaments
  → Cria torneio no sistema Riot (requer riot_provider_id)
  → Salva em riot_tournament_registrations:
       riot_tournament_id  ← ID retornado pela Riot

POST /lol/tournament/v5/codes
  → Gera tournament codes para uma partida
  → Parâmetros query: tournamentId, count (bo1=1, bo3=3, bo5=5)
  → Body: { mapType, pickType, spectatorType, teamSize, allowedSummonerIds }
  → Salva em matches.tournament_codes (JSONB array de strings)

GET /lol/tournament/v5/codes/{tournamentCode}
  → Verifica detalhes de um código (raramente usado)
```

**Tabela `riot_tournament_registrations`:**
| Campo | Origem |
|---|---|
| `riot_provider_id` | Retorno do POST /providers |
| `riot_tournament_id` | Retorno do POST /tournaments |
| `tournament_id` | FK para `tournaments.id` do projeto |

**Payload do callback Riot (POST /api/tournament/callback):**
```json
{
  "startTime": 1704067200000,
  "shortCode": "BR1-XXXX-XXXX-XXXX-XXXX",
  "metaData": "{}",
  "gameId": 1234567890,
  "gameName": "teambuilder-match-1234567890",
  "gameType": "MATCHED",
  "gameMap": 11,
  "gameMode": "CLASSIC",
  "region": "BR1"
}
```

**Validação HMAC:** Header `X-Riot-Token` — SHA256 HMAC do body com `RIOT_HMAC_SECRET`.

---

## lol-status-v4

Base: `https://br1.api.riotgames.com`

| Método | Endpoint | Uso |
|---|---|---|
| GET | `/lol/status/v4/platform-data` | Health check da plataforma BR1 |

Usado para verificar se a plataforma está operacional antes de criar/iniciar partidas.

---

## Assets (CommunityDragon)

Versões disponíveis: `latest` (patch atual) ou versão específica como `16.10`.

| Asset | URL |
|---|---|
| Profile Icon | `https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/profile-icons/{id}.jpg` |
| Champion Square | `https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/champion-icons/{championId}.png` |
| Champion Splash | `https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/champion-splashes/{championId}/{skinId}.jpg` |
| Item Icon | `https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/item-icons/{itemId}.png` |
| Rank Emblem | `https://raw.communitydragon.org/latest/plugins/rcp-fe-lol-static-assets/global/default/images/ranked-mini-crests/{tier}.png` |

**Fallback:** usar `16.10` no lugar de `latest` para build determinístico.

---

## Rate Limiting

**Limites por chave (desenvolvimento):**
| Janela | Limite |
|---|---|
| 1 segundo | 20 requests |
| 2 minutos | 100 requests |

**Limites por chave (produção / tournament):**
| Janela | Limite |
|---|---|
| 1 segundo | 500 requests |
| 10 minutos | 30.000 requests |

**Implementação:** `lib/riot-rate-limiter.ts` — fila com delay adaptativo baseado nos headers `X-Rate-Limit-Count` e `Retry-After` retornados pela Riot.

**Cache TTL por tipo de dado:**
| Dado | TTL recomendado |
|---|---|
| Rank / LP | 10 minutos |
| Summoner info | 1 hora |
| Match details | Permanente (imutável) |
| Active game | Sem cache (tempo real) |
| Champion masteries | 1 hora |

---

## Tratamento de Erros

| HTTP Status | Significado | Ação no código |
|---|---|---|
| `400` | Bad request — parâmetros inválidos | Log + retornar erro ao caller |
| `401` | API key inválida ou expirada | Log crítico + alertar |
| `403` | Acesso negado (endpoint não liberado para a chave) | Log + retornar erro |
| `404` | Recurso não encontrado (jogador offline, partida não existe) | Tratar como `null` / `{ success: false }` |
| `429` | Rate limit atingido | Respeitar `Retry-After`, backoff exponencial |
| `500/503` | Riot API instável | Retry com backoff, max 3 tentativas |
