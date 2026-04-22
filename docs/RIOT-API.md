# 🎮 Riot Games API — Documentação Técnica

> GerenciadorDeTorneios BRLOL · `lib/riot.ts` · `lib/riot-cache.ts` · `lib/rate-limit.ts`

---

## 📌 Visão Geral

O projeto consome a Riot Games REST API via Next.js Route Handlers (server-side).
Toda chamada passa por uma camada de cache em memória e um rate limiter por IP.

```
Browser → Next.js Route Handler → rate-limit → riot-cache → Riot API
                                                    |
                                            (retorna cache se válido)
```

---

## 🔑 Variáveis de Ambiente

| Variável             | Exemplo                  | Descrição                               |
|----------------------|--------------------------|-----------------------------------------|
| `RIOT_API_KEY`       | `RGAPI-xxxx-xxxx`        | Chave da Riot (Developer ou Production) |
| `RIOT_REGION`        | `br1`                    | Plataforma regional (servidor do jogo)  |
| `RIOT_REGIONAL_HOST` | `americas`               | Host continental (Account/Match API)    |

### Regiões disponíveis

| `RIOT_REGION` | `RIOT_REGIONAL_HOST` | Onde usar          |
|---------------|----------------------|--------------------|
| `br1`         | `americas`           | Brasil             |
| `na1`         | `americas`           | América do Norte   |
| `la1`/`la2`   | `americas`           | América Latina     |
| `euw1`/`eun1` | `europe`             | Europa             |
| `kr`          | `asia`               | Coreia             |
| `jp1`         | `asia`               | Japão              |

> Summoner API e Mastery usam PLATFORM (`br1.api.riotgames.com`).
> Account API e Match API usam REGIONAL (`americas.api.riotgames.com`).

---

## 🏗️ Arquitetura Interna (lib/riot.ts)

### URLs base

```ts
const PLATFORM = 'https://' + REGION + '.api.riotgames.com'
const REGIONAL = 'https://' + REGIONAL_HOST + '.api.riotgames.com'
```

### Função base riotFetch<T>(url)

Toda chamada à Riot passa por esta função. Ela:
1. Injeta o header `X-Riot-Token` automaticamente
2. Configura `next: { revalidate: 300 }` (cache HTTP do Next.js por 5 min)
3. Lança erro com código HTTP e mensagem da Riot em caso de falha

```ts
async function riotFetch<T>(url: string): Promise<T> {
  const res = await fetch(url, {
    headers: { 'X-Riot-Token': API_KEY },
    next: { revalidate: 300 }
  });
  if (!res.ok) {
    const e = await res.json().catch(() => ({}));
    throw new Error('Riot API ' + res.status + ': ' + (e?.status?.message ?? res.statusText));
  }
  return res.json() as Promise<T>;
}
```

---

## 📦 Funções Exportadas

### getAccountByRiotId(gameName, tagLine)

- **Endpoint:** `GET /riot/account/v1/accounts/by-riot-id/{gameName}/{tagLine}`
- **Host:** REGIONAL (americas)
- **Cache TTL:** 600s (10 min)
- **Retorna:** `{ puuid, gameName, tagLine }`

```ts
const account = await getAccountByRiotId('ProPlayer', 'BR1');
// { puuid: 'abc123...', gameName: 'ProPlayer', tagLine: 'BR1' }
```

---

### getSummonerByPuuid(puuid)

- **Endpoint:** `GET /lol/summoner/v4/summoners/by-puuid/{puuid}`
- **Host:** PLATFORM (br1)
- **Cache TTL:** 300s (5 min)
- **Retorna:** `{ id, accountId, puuid, profileIconId, summonerLevel }`

```ts
const summoner = await getSummonerByPuuid(account.puuid);
// { id: 'summ123', summonerLevel: 350, profileIconId: 4321 }
```

---

### getLeagueEntriesByPuuid(puuid)

- **Endpoint:** `GET /lol/league/v4/entries/by-summoner/{summonerId}`
- **Host:** PLATFORM (br1)
- **Cache TTL:** 300s
- **Obs:** Chama `getSummonerByPuuid` internamente para obter o `summonerId`
- **Retorna:** array `LeagueEntry[]` com entradas por tipo de fila

```ts
const entries = await getLeagueEntriesByPuuid(puuid);
// [{ queueType: 'RANKED_SOLO_5x5', tier: 'GOLD', rank: 'II', leaguePoints: 75 }]
```

| Campo          | Tipo    | Descrição                         |
|----------------|---------|-----------------------------------|
| `queueType`    | string  | `RANKED_SOLO_5x5` ou `RANKED_FLEX_SR` |
| `tier`         | string  | `IRON` até `CHALLENGER`           |
| `rank`         | string  | `IV` até `I`                      |
| `leaguePoints` | number  | LP atual                          |
| `wins`         | number  | Vitórias na temporada             |
| `losses`       | number  | Derrotas na temporada             |
| `hotStreak`    | boolean | Sequência de vitórias             |

---

### getTopMasteriesByPuuid(puuid, count?)

- **Endpoint:** `GET /lol/champion-mastery/v4/champion-masteries/by-puuid/{puuid}/top?count={n}`
- **Host:** PLATFORM (br1)
- **Cache TTL:** 600s
- **Default:** `count = 5`

```ts
const masteries = await getTopMasteriesByPuuid(puuid, 5);
// [{ championId: 157, championLevel: 7, championPoints: 450000 }]
```

---

### getMatchIdsByPuuid(puuid, count?, queue?)

- **Endpoint:** `GET /lol/match/v5/matches/by-puuid/{puuid}/ids?count={n}&queue={id}`
- **Host:** REGIONAL (americas)
- **Cache TTL:** 120s (dado mais volátil)
- **Default:** `count = 20`

```ts
const ids = await getMatchIdsByPuuid(puuid, 10, 420);
// ['BR1_123456789', 'BR1_987654321']
```

| Nome no código     | Queue ID | Descrição          |
|--------------------|----------|--------------------|
| `RANKED_SOLO_5x5`  | `420`    | Ranqueado Solo/Duo |
| `RANKED_FLEX_SR`   | `440`    | Ranqueado Flex     |
| `NORMAL_5x5_DRAFT` | `400`    | Normal Escolha     |
| `ARAM`             | `450`    | ARAM               |

---

### getMatchById(matchId)

- **Endpoint:** `GET /lol/match/v5/matches/{matchId}`
- **Host:** REGIONAL (americas)
- **Cache TTL:** 3600s (1h — partidas não mudam)
- **Retorna:** `MatchDto` com dados completos dos 10 participantes

```ts
const match = await getMatchById('BR1_123456789');
// { metadata: { matchId: '...', participants: [...] }, info: { ... } }
```

| Campo                         | Tipo    | Descrição                      |
|-------------------------------|---------|--------------------------------|
| `championName`                | string  | Nome do campeão jogado         |
| `kills / deaths / assists`    | number  | KDA                            |
| `win`                         | boolean | Ganhou ou perdeu               |
| `totalDamageDealtToChampions` | number  | Dano total causado             |
| `goldEarned`                  | number  | Ouro ganho                     |
| `totalMinionsKilled`          | number  | CS (creep score)               |
| `visionScore`                 | number  | Pontuação de visão             |
| `teamPosition`                | string  | TOP/JUNGLE/MIDDLE/BOTTOM/UTILITY |
| `pentaKills`                  | number  | Penta kills                    |

---

## 🗄️ Cache em Memória (lib/riot-cache.ts)

Cache in-process com Map + TTL. Não persiste entre deploys ou reinicializações.

```ts
getCached<T>(key: string): T | null          // retorna null se expirado
setCached<T>(key, data, ttlSeconds): void    // grava com TTL
invalidateCache(prefix: string): void        // invalida por prefixo
```

| Função                    | Chave                           | TTL   |
|---------------------------|---------------------------------|-------|
| `getAccountByRiotId`      | `account:nome#tag` (lowercase)  | 600s  |
| `getSummonerByPuuid`      | `summoner:{puuid}`              | 300s  |
| `getLeagueEntriesByPuuid` | `league:{puuid}`                | 300s  |
| `getTopMasteriesByPuuid`  | `mastery:{puuid}:{count}`       | 600s  |
| `getMatchIdsByPuuid`      | `matchids:{puuid}:{count}:{q}`  | 120s  |
| `getMatchById`            | `match:{matchId}`               | 3600s |

> Para produção com alto volume, considere migrar para Redis (Upstash) ou Supabase Edge Cache.

---

## 🚦 Rate Limiter (lib/rate-limit.ts)

Rate limiter por IP com janela fixa, implementado em memória.

```ts
rateLimit(ip, limit, windowMs): boolean
// true = requisição permitida | false = bloqueada (429)
```

| Rota                     | Limite | Janela | Resposta ao bloquear      |
|--------------------------|--------|--------|---------------------------|
| `GET /api/riot/summoner` | 30 req | 60s    | `429 Rate limit atingido` |
| `GET /api/riot/matches`  | 20 req | 60s    | `429 Rate limit`          |

---

## 🌐 Rotas de API Expostas

### GET /api/riot/summoner?riotId=Nome%23TAG

Retorna perfil completo do jogador em uma única chamada.

| Parâmetro | Obrigatório | Formato  | Exemplo         |
|-----------|-------------|----------|-----------------|
| `riotId`  | Sim         | Nome#TAG | `ProPlayer#BR1` |

Resposta de sucesso (200):

```json
{
  "account":   { "puuid": "...", "gameName": "ProPlayer", "tagLine": "BR1" },
  "summoner":  { "summonerLevel": 350, "profileIconId": 4321 },
  "entries":   [{ "queueType": "RANKED_SOLO_5x5", "tier": "DIAMOND", "rank": "II", "leaguePoints": 45 }],
  "masteries": [{ "championId": 157, "championLevel": 7, "championPoints": 500000 }]
}
```

| Código | Condição                          |
|--------|-----------------------------------|
| `400`  | riotId ausente ou sem `#`         |
| `404`  | Jogador não encontrado na Riot    |
| `429`  | Rate limit do app atingido        |
| `500`  | Erro interno ou Riot indisponível |

---

### GET /api/riot/matches?puuid={puuid}&count={n}&queue={tipo}

| Parâmetro | Obrigatório | Default | Máximo | Descrição               |
|-----------|-------------|---------|--------|-------------------------|
| `puuid`   | Sim         | —       | —      | PUUID do jogador        |
| `count`   | Não         | `10`    | `20`   | Quantidade de partidas  |
| `queue`   | Não         | todas   | —      | Tipo de fila            |

> `ids` retorna até `count` IDs, mas `matches` retorna no máximo 5 detalhes completos (`slice(0,5)`).

---

### GET /api/riot/match/[matchId]

| Parâmetro | Exemplo         | Descrição             |
|-----------|-----------------|-----------------------|
| `matchId` | `BR1_123456789` | ID da partida da Riot |

---

## 🏆 Tournament API (Integração Futura)

Requer Production API Key aprovada pela Riot. Para desenvolvimento use `/lol/tournament-stub/v5/`.

### Fluxo completo

```
1. Registrar Provider
   POST /lol/tournament/v5/providers
   Body: { region: 'BRAZIL', url: 'https://seusite.com/callback' }
   Retorna: providerId (number)

2. Criar Torneio
   POST /lol/tournament/v5/tournaments
   Body: { name: 'BRLOL Cup', providerId: 12345 }
   Retorna: tournamentId (number)

3. Gerar Código de Sala
   POST /lol/tournament/v5/codes?tournamentId=12345&count=1
   Body: { teamSize: 5, pickType: 'TOURNAMENT_DRAFT', mapType: 'SUMMONERS_RIFT', spectatorType: 'ALL' }
   Retorna: ['BRLA-XXXX-XXXX-XXXX-XXXX-XXXX']

4. Times entram na lobby com o código gerado

5. Consultar resultado
   GET /lol/tournament/v5/lobby-events/by-code/{code}
   Retorna: eventos de entrada/saída dos jogadores
```

| Endpoint                                          | Método | Descrição                         |
|---------------------------------------------------|--------|-----------------------------------|
| `/lol/tournament/v5/providers`                   | POST   | Registra o provider (URL callback)|
| `/lol/tournament/v5/tournaments`                 | POST   | Cria torneio oficial na Riot      |
| `/lol/tournament/v5/codes`                       | POST   | Gera códigos de sala              |
| `/lol/tournament/v5/codes/{code}`                | GET    | Detalhes de um código             |
| `/lol/tournament/v5/lobby-events/by-code/{code}` | GET    | Eventos da lobby                  |

---

## 🖼️ Data Dragon (Assets Estáticos)

Não requer autenticação. Já configurado no projeto:

```ts
export const DD_VERSION = '14.10.1';
export const DD_BASE    = 'https://ddragon.leagueoflegends.com/cdn/' + DD_VERSION;

championIconUrl('Yasuo')
// https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Yasuo.png

profileIconUrl(4321)
// https://ddragon.leagueoflegends.com/cdn/14.10.1/img/profileicon/4321.png
```

| Asset              | URL                                      |
|--------------------|------------------------------------------|
| Ícone de campeão   | `/img/champion/{Nome}.png`               |
| Splash art         | `/img/champion/splash/{Nome}_0.jpg`      |
| Loading screen     | `/img/champion/loading/{Nome}_0.jpg`     |
| Ícone de item      | `/img/item/{itemId}.png`                 |
| Lista de campeões  | `/data/pt_BR/champion.json`              |
| Lista de itens     | `/data/pt_BR/item.json`                  |

> Versão mais recente: https://ddragon.leagueoflegends.com/api/versions.json

---

## 🐛 Erros Comuns da Riot API

| Código | Significado                  | Solução                                       |
|--------|------------------------------|-----------------------------------------------|
| `400`  | Request inválido             | Verificar parâmetros da URL                   |
| `401`  | API Key ausente              | Verificar header `X-Riot-Token`               |
| `403`  | API Key inválida ou expirada | Renovar em developer.riotgames.com            |
| `404`  | Recurso não encontrado       | Jogador/partida não existe nessa região       |
| `429`  | Rate limit da Riot atingido  | Aguardar `Retry-After`; usar cache adequado   |
| `500`  | Erro interno da Riot         | Tentar novamente após alguns segundos         |
| `503`  | Serviço indisponível         | Verificar https://status.riotgames.com        |

---

## 📚 Referências

- Riot Developer Portal: https://developer.riotgames.com
- Documentação da API (Swagger): https://developer.riotgames.com/apis
- Política de uso: https://developer.riotgames.com/policies/general
- Status dos servidores: https://status.riotgames.com
- Data Dragon CDN: https://ddragon.leagueoflegends.com
- Rate Limits oficiais: https://developer.riotgames.com/docs/portal#web-apis_rate-limiting
- Tournament API: https://developer.riotgames.com/apis#tournament-v5
