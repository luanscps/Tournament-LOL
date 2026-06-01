# Server Actions — ArenaGG (GerenciadorDeTorneios-BRLOL)

> **Fonte de verdade:** `lib/actions/*.ts`
> Última revisão: 2026-06-01

Todos os arquivos em `lib/actions/` são declarados com `'use server'` no topo e exportam funções assíncronas invocáveis diretamente de Client Components via `useTransition` ou de Server Components.

---

## Tipo de retorno padrão

```ts
// Padrão uniforme em todas as Server Actions do projeto
type ActionResult<T = void> =
  | { success: true; data: T }
  | { success: false; error: string };
```

**Padrões transversais obrigatórios:**
1. Validação Zod antes de qualquer operação no banco
2. `revalidatePath()` após mutations que afetam a UI
3. Guard de autenticação via `supabase.auth.getUser()` no início de toda action
4. `useTransition` no cliente para desabilitar UI durante execução
5. Nunca lançar exceções — sempre retornar `ActionResult`

---

## `lib/actions/profile.ts`

### `updateProfile(data)`
```ts
await updateProfile({ display_name: string; avatar_url?: string })
// → UPDATE profiles SET display_name, avatar_url WHERE id = user.id
// → revalidatePath('/perfil')
```

### `linkRiotAccount(gameName, tagLine)`
```ts
await linkRiotAccount(gameName: string, tagLine: string)
// → GET account-v1 /riot/account/v1/accounts/by-riot-id/{gameName}/{tagLine}
// → UPSERT riot_accounts { profile_id, puuid, game_name, tag_line }
// → UPDATE players { riot_account_id }
// → revalidatePath('/perfil')
```

### `unlinkRiotAccount(riotAccountId)`
```ts
await unlinkRiotAccount(riotAccountId: string)
// → Guard: riot_accounts.profile_id === user.id
// → UPDATE players SET riot_account_id = null
// → DELETE riot_accounts WHERE id = riotAccountId
// → revalidatePath('/perfil')
```

---

## `lib/actions/teams.ts`

### `createTeam(data)`
```ts
await createTeam({ name: string; tag: string; logo_url?: string })
// → Valida: usuário não tem time ativo
// → INSERT teams { name, tag, logo_url, owner_id = user.id }
// → INSERT team_members { team_id, profile_id, role='captain', status='accepted' }
// → revalidatePath('/times')
```

### `updateTeam(teamId, data)`
```ts
await updateTeam(teamId: string, { name?, tag?, logo_url? })
// → Guard: team_members.role = 'captain' AND status = 'accepted'
// → UPDATE teams SET ...
// → revalidatePath('/times/[teamId]')
```

### `convidarMembro(teamId, profileId)`
```ts
await convidarMembro(teamId: string, profileId: string)
// → Guard: captain do time
// → Valida: count(team_members WHERE status='accepted') < 8
// → Valida: profileId não é membro ativo
// → INSERT team_invites {
//     team_id, invited_profile_id, invited_by,
//     status='PENDING', expires_at=now()+7d
//   }
// → INSERT notifications (para o convidado)
```

### `responderConvite(inviteId, resposta)`
```ts
await responderConvite(inviteId: string, resposta: 'ACCEPTED' | 'DECLINED')
// ACCEPTED:
//   → Valida: invite.status='PENDING' e not expired
//   → RPC accept_team_invite(inviteId)
//       ├─ UPDATE team_invites.status = 'ACCEPTED'
//       └─ INSERT team_members { role='member', status='accepted' }
//   → INSERT notifications (para o capitão)
// DECLINED:
//   → UPDATE team_invites.status = 'DECLINED'
//   → INSERT notifications (para o capitão)
// → revalidatePath('/convites')
```

### `removerMembro(teamId, memberId)`
```ts
await removerMembro(teamId: string, memberId: string)
// → Guard: captain OU próprio usuário
// → UPDATE team_members SET status='left' WHERE id = memberId
// → INSERT notifications
// → revalidatePath('/times/[teamId]')
```

### `inscreverTime(teamId, tournamentId)`
```ts
await inscreverTime(teamId: string, tournamentId: string)
// → Guard: captain do time
// → Valida: tournament.status = 'OPEN'
// → Valida: 5 <= count(membros accepted) <= 8
// → Valida: sem inscrição duplicada
// → INSERT inscricoes { team_id, tournament_id, status='PENDING' }
// → INSERT notifications (organizador)
// → revalidatePath('/torneios/[slug]')
```

### `deixarTime(teamId)`
```ts
await deixarTime(teamId: string)
// → Guard: não é captain (captain deve transferir antes)
// → UPDATE team_members SET status='left'
// → revalidatePath('/times')
```

---

## `lib/actions/tournaments.ts`

### `createTournament(data)`
```ts
await createTournament(data: TournamentFormData)
// → Guard: is_admin OU profile.user_role = 'organizer'
// → INSERT tournaments { ...data, status='DRAFT', organizer_id=user.id }
// → INSERT riot_tournament_registrations (se Riot API configurada)
// → revalidatePath('/organizer/torneios')
```

### `updateTournament(id, data)`
```ts
await updateTournament(id: string, data: Partial<TournamentFormData>)
// → Guard: is_organizer_or_admin(id)
// → Valida: status = 'DRAFT' (não pode editar torneio em andamento)
// → UPDATE tournaments SET ...
// → revalidatePath('/organizer/torneios/[id]')
```

### `publicarTorneio(id)`
```ts
await publicarTorneio(id: string)
// → Guard: is_organizer_or_admin(id)
// → Valida: status = 'DRAFT'
// → Valida: tournament_rules existe
// → UPDATE tournaments.status = 'OPEN'
// → revalidatePath('/torneios')
// Transição: DRAFT → OPEN
```

### `gerarChaveamento(tournamentId)`
```ts
await gerarChaveamento(tournamentId: string)
// → Guard: is_organizer_or_admin(tournamentId)
// → Valida: status = 'OPEN'
// → Conta inscricoes APPROVED (mínimo 2)
// → supabase.functions.invoke('bracket-generator', { body: { tournamentId } })
//     └─ Gera tournament_stages + matches + tournament_codes (Riot API)
// → UPDATE tournaments.status = 'IN_PROGRESS'
// → revalidatePath('/organizer/torneios/[id]/bracket')
// Transição: OPEN → IN_PROGRESS
```

### `aprovarInscricao(inscricaoId)`
```ts
await aprovarInscricao(inscricaoId: string)
// → Guard: is_organizer_or_admin(tournamentId via inscricao)
// → UPDATE inscricoes.status = 'APPROVED'
// → INSERT notifications (capitão)
// → revalidatePath('/organizer/torneios/[id]/inscricoes')
```

### `rejeitarInscricao(inscricaoId, motivo?)`
```ts
await rejeitarInscricao(inscricaoId: string, motivo?: string)
// → Guard: is_organizer_or_admin
// → UPDATE inscricoes.status = 'REJECTED'
// → INSERT notifications (capitão, com motivo)
```

### `encerrarTorneio(id)`
```ts
await encerrarTorneio(id: string)
// → Guard: is_organizer_or_admin(id)
// → Valida: status = 'IN_PROGRESS'
// → UPDATE tournaments.status = 'FINISHED'
// → INSERT prize_distribution (se configurado)
// Transição: IN_PROGRESS → FINISHED
```

### `cancelarTorneio(id)`
```ts
await cancelarTorneio(id: string)
// → Guard: is_organizer_or_admin(id)
// → Valida: status IN ('DRAFT', 'OPEN')
// → UPDATE tournaments.status = 'CANCELLED'
// → INSERT notifications (todos os inscritos)
// Transição: DRAFT | OPEN → CANCELLED
```

---

## `lib/actions/matches.ts`

### `checkInPartida(matchId)`
```ts
await checkInPartida(matchId: string)
// → Guard: is_organizer_or_admin(tournamentId)
// → Valida: match.status = 'SCHEDULED'
// → Busca puuid via team_members → riot_accounts
// → GET spectator-v5: /lol/spectator/v5/active-games/by-summoner/{puuid}
// → Se ativo: UPDATE matches.status = 'IN_PROGRESS'
// → Se não: { success: false, error: 'Partida não iniciada na plataforma' }
```

---

## `lib/actions/ingest-match.ts`

### `finalizeMatchIngestion(tournamentCode, gameId)` ← função pública (não é Server Action direta)
```ts
// Chamada por /api/internal/process-match/route.ts (não por Client Component)
await finalizeMatchIngestion(tournamentCode: string, gameId: number)
// Pipeline completo — ver fluxos.md #2 para diagrama detalhado:
// 1. processMatchResult()    — normaliza dados de tournament_match_results
// 2. fetchAndResolveMatch()  — busca match-v5 + resolve localMatchId + game_number
// 3. persistMatchGame()      — INSERT match_games
// 4. persistPlayerStats()    — INSERT player_stats (10 participantes)
// 5. finalizeMatchIngestion() — atualiza placar, transita status, chama avancarVencedor()
```

---

## `lib/actions/disputes.ts`

### `abrirDisputa(data)`
```ts
await abrirDisputa({
  match_id: string;
  reported_by: string;  // ← campo real na tabela disputes
  description: string;
  evidence_url?: string;
})
// → Valida: usuário é membro de um dos times da partida
//   (via team_members JOIN matches WHERE team_a_id OR team_b_id)
// → Valida: match.status = 'FINISHED' (só disputa resultado finalizado)
// → INSERT disputes { match_id, reported_by, description, evidence_url, status='OPEN' }
// → INSERT notifications (organizador + admin)
// → revalidatePath('/disputas')
```

### `resolverDisputa(disputaId, resolucao, status)`
```ts
await resolverDisputa(
  disputaId: string,
  resolucao: string,
  status: 'RESOLVED' | 'DISMISSED'
)
// → Guard: is_admin
// → UPDATE disputes { status, resolution, resolved_at=now(), resolved_by=user.id }
// → INSERT notifications (partes envolvidas)
// Transição: OPEN | UNDER_REVIEW → RESOLVED | DISMISSED
```

---

## `lib/actions/admin.ts`

### Guards e auditoria
```ts
// Toda action admin começa com:
const isAdmin = await supabase.rpc('is_current_user_admin')
if (!isAdmin) return { success: false, error: 'Acesso negado' }

// E termina com:
await supabase.rpc('log_admin_action', {
  action_type: 'BAN_USER' | 'DELETE_TEAM' | ...,
  target_id: targetId,
  metadata: { ... }
})
// → INSERT audit_log { actor_id, action_type, target_id, metadata, created_at }
```

### Actions disponíveis
```ts
await banirUsuario(profileId: string, motivo: string)
await desbanirUsuario(profileId: string)
await deletarTime(teamId: string, motivo: string)
await promoverAdmin(profileId: string)
await removerAdmin(profileId: string)
await forcarFinalizarTorneio(tournamentId: string)
```

---

## Transições de status (`tournament_status`)

```
DRAFT ──[publicarTorneio]──► OPEN
OPEN  ──[gerarChaveamento]──► IN_PROGRESS
IN_PROGRESS ──[encerrarTorneio]──► FINISHED
DRAFT | OPEN ──[cancelarTorneio]──► CANCELLED
```

## Transições de status (`match_status`)

```
SCHEDULED ──[checkInPartida]──► IN_PROGRESS
IN_PROGRESS ──[finalizeMatchIngestion]──► FINISHED
any ──[admin/walkover]──► WALKOVER | CANCELLED
```
