export type TournamentStatus = 'DRAFT' | 'OPEN' | 'IN_PROGRESS' | 'FINISHED' | 'CANCELLED';
export type MatchStatus = 'SCHEDULED' | 'IN_PROGRESS' | 'FINISHED';
export type BracketType = 'SINGLE_ELIMINATION' | 'DOUBLE_ELIMINATION' | 'ROUND_ROBIN' | 'SWISS';

export interface Tournament {
  id: string;
  name: string;
  description: string | null;
  status: TournamentStatus;
  bracketType: BracketType;
  maxTeams: number;
  prizePool: string | null;
  startDate: string | null;
  endDate: string | null;
  createdAt: string;
  updatedAt: string;
  _count?: {
    teams: number;
    matches: number;
  };
}

export interface Team {
  id: string;
  name: string;
  tag: string;
  logoUrl: string | null;
  tournamentId: string;
  createdAt: string;
  players?: Player[];
  _count?: {
    players: number;
  };
}

export interface Player {
  id: string;
  summonerName: string;
  tagLine: string;
  puuid: string | null;
  teamId: string | null;
  role: string;
  tier: string;
  rank: string;
  lp: number;
  wins: number;
  losses: number;
  createdAt: string;
}

export interface Match {
  id: string;
  tournamentId: string;
  round: number;
  status: MatchStatus;
  teamAId: string | null;
  teamBId: string | null;
  winnerId: string | null;
  scoreA: number | null;
  scoreB: number | null;
  scheduledAt: string | null;
  playedAt: string | null;
  teamA?: Team;
  teamB?: Team;
  winner?: Team;
}

export interface AdminStats {
  totalTournaments: number;
  activeTournaments: number;
  totalTeams: number;
  totalPlayers: number;
  totalMatches: number;
  pendingRegistrations: number;
}
