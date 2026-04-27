# Riot Games API — Detalhes técnicos de integração

> Para a **visão funcional completa** (como os dados entram no banco Supabase, mapeamento de tabelas, Edge Functions de sync e fluxos de negócio), consulte primeiro:
> - [`../BRLOL-DOCS-UNIFICADO.md`](../BRLOL-DOCS-UNIFICADO.md) → seção "Riot Games API — Visão unificada"
>
> Este arquivo aprofunda **configuração de roteamento, rate limits, códigos HTTP, assets estáticos e exemplos de uso de funções helper** — é a referência de implementação.

---

## Roteamento: Platform vs. Regional

| Tipo | URL base | Endpoints |
|---|---|---|
| **Platform** (por servidor) | `https://br1.api.riotgames.com` | summoner-v4, league-v4, champion-mastery-v4, spectator-v5, tournament-stub-v5, lol-status-v4 |
| **Regional** (continental) | `https://americas.api.riotgames.com` | account-v1, match-v5 |

Brasil (`br1`) pertence à região `americas`. O projeto resolve isso automaticamente via `getPlatformUrl()` e `getRegionalUrl()` em `lib/riot.ts`, lendo a variável `RIOT_REGION`.

---

## Tipos de API Key

| Tipo | req/s | req/2min | Validade |
|---|---|---|---|
| Development | 20 | 100 | 24 h (renova manualmente) |
| Personal | 20 | 100 | Permanente |
| Production | 500 | 30.000/10min | Permanente |

> ⚠️ Para produção, registre o produto em [developer.riotgames.com](https://developer.riotgames.com).

---

## Endpoints integrados

### account-v1 (regional: americas)
| Endpoint | Cache TTL |
|---|---|
| `/riot/account/v1/accounts/by-riot-id/{gameName}/{tagLine}` — PUUID via Riot ID | 600 s |
| `/riot/account/v1/accounts/by-puuid/{puuid}` — conta via PUUID | — |

### summoner-v4 (platform: br1)
| Endpoint | Cache TTL |
|---|---|
| `/lol/summoner/v4/summoners/by-puuid/{puuid}` | 300 s |

### league-v4 (platform: br1)
| Endpoint | Cache TTL |
|---|---|
| `/lol/league/v4/entries/by-puuid/{puuid}` — tier, LP, winrate | 300 s |

### match-v5 (regional: americas)
| Endpoint | Cache TTL |
|---|---|
| `/lol/match/v5/matches/by-puuid/{puuid}/ids` — IDs das últimas N partidas | 120 s |
| `/lol/match/v5/matches/{matchId}` — detalhes completos | 3600 s |

### champion-mastery-v4 (platform: br1)
| Endpoint | Cache TTL |
|---|---|
| `/lol/champion-mastery/v4/champion-masteries/by-puuid/{puuid}/top` | 600 s |

### tournament-stub-v5 (platform: br1) — apenas ambiente de dev
| Endpoint | Método | Uso |
|---|---|---|
| `/lol/tournament-stub/v5/providers` | POST | Registrar provider (URL callback) |
| `/lol/tournament-stub/v5/tournaments` | POST | Criar torneio |
| `/lol/tournament-stub/v5/codes` | POST | Gerar tournament codes |
| `/lol/tournament-stub/v5/codes/{code}` | GET/PUT | Consultar/atualizar code |
| `/lol/tournament-stub/v5/lobby/events/by-code/{code}` | GET | Eventos de lobby |

### lol-status-v4 (platform: br1)
| Endpoint | Frequência |
|---|---|
| `/lol/status/v4/platform-data` — manutenções e incidentes | Cron semanal |

---

## Códigos HTTP e tratamento de erros

| Código | Ação no projeto |
|---|---|
| 200 | Processar normalmente |
| 400 | Verificar campos enviados |
| 401 | Configurar `RIOT_API_KEY` no servidor |
| 403 | Renovar chave em developer.riotgames.com |
| 404 | Verificar Nome#TAG ou ID |
| 415 | Enviar `Content-Type: application/json` |
| 429 | Ler header `Retry-After` e `X-Rate-Limit-Type` (tratado em `lib/riot-rate-limiter.ts`) |
| 500/503 | Retry após delay — consultar lol-status-v4 |

---

## Fluxo de identificação de jogador (`lib/riot.ts` → route `app/api/riot/summoner`)

```
Nome#TAG
  └─▶ account-v1 (americas) ──▶ puuid
         └─▶ [paralelo via Promise.all()]
               ├─▶ summoner-v4 (br1)  →  { id, level, profileIconId }
               ├─▶ league-v4   (br1)  →  { tier, rank, LP, wins }
               └─▶ match-v5    (americas) → matchIds → detalhes
```

---

## Assets estáticos — sem API Key

### Data Dragon (`ddragon.leagueoflegends.com`)

| Função helper | Async | Descrição |
|---|---|---|
| `getDDVersion()` | sim | Versão atual do patch (cache 1 h) |
| `profileIconUrl(id)` | sim | Ícone de perfil do invocador |
| `championIconUrl(name)` | sim | Ícone quadrado do campeão |
| `championSplashUrl(name, skinNum?)` | **não** | Splash art (skin 0 = base) |
| `championLoadingUrl(name, skinNum?)` | **não** | Loading screen |
| `itemIconUrl(itemId)` | sim | Ícone de item |
| `summonerSpellIconUrl(spellId)` | sim | Ícone de summoner spell |
| `getAllChampions()` | sim | Todos os campeões em `pt_BR` |

**URLs diretas úteis:**

```
# Ícone de perfil
https://ddragon.leagueoflegends.com/cdn/{v}/img/profileicon/{id}.png

# Ícone quadrado de campeão
https://ddragon.leagueoflegends.com/cdn/{v}/img/champion/{Name}.png

# Splash art (skin base)
https://ddragon.leagueoflegends.com/cdn/img/champion/splash/{Name}_0.jpg

# Ícone de item
https://ddragon.leagueoflegends.com/cdn/{v}/img/item/{itemId}.png

# Versão do patch
https://ddragon.leagueoflegends.com/api/versions.json

# JSON de campeões em pt_BR
https://ddragon.leagueoflegends.com/cdn/{v}/data/pt_BR/champion.json
```

> **{Name}** usa o nome interno sem espaços: `MissFortune`, `AurelionSol`. Use `getAllChampions()` para obter o nome correto.

**Exemplo de uso em componente:**

```tsx
import { championSplashUrl, itemIconUrl, rankEmblemUrl } from "@/lib/riot";

// Banner de perfil
<img src={championSplashUrl("Jinx", 0)} alt="Jinx splash art" width={1215} height={717} />

// Ícone de item no histórico
{participant.item0 > 0 && (
  <img src={await itemIconUrl(participant.item0)} alt={`Item ${participant.item0}`} width={32} height={32} />
)}

// Emblema de rank
<img src={rankEmblemUrl(entry.tier)} alt={entry.tier} width={48} height={48} />
```

---

### CommunityDragon (`raw.communitydragon.org`)

Usado apenas para assets **não disponíveis** no Data Dragon oficial.

| Função helper | Descrição |
|---|---|
| `rankEmblemUrl(tier)` | Emblema visual do rank (iron → challenger) |
| `masteryIconUrl(level)` | Ícone de nível de maestria (1–10) |

**URLs diretas:**

```
# Emblema de rank
https://raw.communitydragon.org/latest/plugins/rcp-fe-lol-shared-components/global/default/ranked-mini-regalia/{tier}.png

# Ícone de maestria
https://raw.communitydragon.org/latest/plugins/rcp-fe-lol-champion-mastery/global/default/mastery-{level}.png
```

`rankEmblemUrl()` já aplica `.toLowerCase()` automaticamente — pode passar `entry.tier` diretamente.

---

### `getAllChampions()` — mapeamento de ID numérico → nome

```typescript
// A API retorna championId: 103 (numérico)
// O JSON do Data Dragon tem { key: "103", id: "Ahri" }
export async function getChampionNameById(championId: number): Promise<string | null> {
  const all = await getAllChampions();
  const found = Object.values(all).find(c => c.key === String(championId));
  return found?.id ?? null; // retorna o nome interno, ex: "MissFortune"
}
```

**Casos de uso:** seletor de campeão (ban/pick), filtro no histórico, nome em pt_BR no perfil.
