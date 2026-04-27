# Fluxos Principais — GerenciadorDeTorneios BRLOL

> Este documento descreve os fluxos **funcionais** principais (do ponto de vista do usuário/organizador).  
> Detalhes de tabelas, colunas, RLS ou integrações com a Riot API estão documentados em `docs/BRLOL-DOCS-UNIFICADO.md`.

---

## 1. Criar torneio (organizador/admin)

```text
Usuário (organizador/admin)
  └─ acessa página de criação de torneio
      └─ preenche formulário (nome, descrição, máximo de times, tipo de chave, datas, etc.)
          └─ envia formulário
              ├─ valida campos obrigatórios e permissões (admin/organizador)
              ├─ cria o registro de torneio no banco
              └─ redireciona para a tela de inscrições daquele torneio
```

Ponto importante de domínio (datas, status, etc.) → ver seção "tournaments" e fluxos de ciclo de vida em `BRLOL-DOCS-UNIFICADO.md`.

---

## 2. Inscrever time em torneio (usuário)

```text
Usuário logado
  └─ acessa página pública do torneio (/torneios/[slug])
      └─ clica em "+ Inscrever meu time"
          └─ é levado para tela de criação/seleção de time na dashboard
              └─ escolhe um time existente ou cadastra um novo
                  └─ confirma inscrição
                      └─ volta para página do torneio com estado "inscrição enviada"
```

O relacionamento entre times, inscrições e torneios (tabelas e colunas) está descrito em "Modelo de dados — teams/inscricoes" no documento unificado.

---

## 3. Aprovar/rejeitar inscrição (organizador/admin)

```text
Organizador
  └─ acessa tela de inscrições do torneio
      └─ visualiza lista de inscrições pendentes/aprovadas/rejeitadas
          └─ clica em "Aprovar" ou "Rejeitar" para cada time
              └─ o status da inscrição é atualizado
                  └─ o capitão recebe notificação in-app e/ou externa (e-mail/Discord)
```

Regras de quem pode aprovar ou rejeitar e como isso reflete em notificações estão detalhadas nas seções de RLS e notificações do documento de arquitetura.

---

## 4. Registrar conta Riot (jogador)

```text
Jogador
  └─ acessa tela de registro de conta Riot na dashboard
      └─ informa Riot ID (Nome#TAG)
          └─ sistema valida a conta via Riot API
              └─ jogador confirma vinculação
                  └─ perfil passa a exibir dados de elo, maestria e histórico
```

Os detalhes de validação, endpoints da Riot API e tabelas persistidas (`riot_accounts`, `rank_snapshots`, `champion_masteries`) estão em "Riot Games API — Visão unificada" e "Modelo de dados" no documento unificado.

---

## 5. Gerar chaveamento (admin)

```text
Admin
  └─ acessa tela administrativa do torneio
      └─ verifica times com inscrição aprovada
          └─ clica em "Gerar chaveamento"
              └─ sistema monta a chave conforme o tipo (single, double, round robin, swiss)
                  └─ partidas são criadas automaticamente
                      └─ tela do torneio passa a exibir o bracket
```

Lógica de seedings, distribuição de partidas por fase e estrutura de tabelas de partidas está descrita nas seções de torneios/partidas em `BRLOL-DOCS-UNIFICADO.md`.

---

## 6. Registrar resultado de partida (admin)

```text
Admin
  └─ acessa seção de partidas do torneio
      └─ escolhe uma partida pendente
          └─ preenche placar (score_a, score_b) e vencedor
              └─ opcionalmente registra picks/bans e detalhes de jogos (BO1/BO3/BO5)
                  └─ confirma salvamento
                      └─ standings, estatísticas de jogadores e bracket são atualizados
```

A forma exata como resultados alimentam standings, views de leaderboard e estatísticas em `player_stats` está documentada no arquivo de arquitetura unificado.

---

## 7. Notificações em tempo real

```text
Sistema
  └─ gera notificações quando eventos importantes acontecem
      ├─ inscrição aprovada/rejeitada
      ├─ partida agendada ou atualizada
      ├─ mudança de status de torneio
      └─ outros eventos de sistema

Usuário logado
  └─ vê badge de notificações na Navbar
      └─ abre dropdown para visualizar últimas notificações
          └─ ao interagir, marca como lidas e navega para a tela relacionada
```

O schema de notificações, política de RLS e configuração de Realtime estão descritos no documento unificado e nas migrations.

---

## 8. Monitoramento da Riot API (cron)

```text
Cron job (Vercel)
  └─ chama rota de monitoramento periodicamente
      └─ consulta status da Riot API (manutenções/incidentes)
          └─ se houver problemas, envia alerta para canal Discord configurado
```

Configuração detalhada do cron, rota `/api/cron/check-riot-status` e variáveis de ambiente estão em `docs/api/cron-monitoramento.md` e na seção de Edge Functions do documento unificado.
