export enum BetStatus {
  ONGOING = "ONGOING",
  COMPLETED = "COMPLETED",
  CANCELLED = "CANCELLED",
}

export enum Position {
  YES = "YES",
  NO = "NO",
}

export type TimeFilter = "all" | "1d" | "1w" | "1m" | "1y";

export interface Bet {
  id: string;
  questionId: number;
  question: string;
  description?: string;
  minStake: number;
  endTimestamp: Date;
  creatorId: string;
  txHash: string;
  status: BetStatus;
  totalAmount: number;
  totalYesAmount: number;
  totalNoAmount: number;
  eventCompleted: boolean;
  createdAt: Date;
  updatedAt: Date;
  creator: User;
  positions: BetPosition[];
}

export interface User {
  id: string;
  address: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface BetPosition {
  id: string;
  betId: string;
  userId: string;
  amount: number;
  position: Position;
  txHash: string;
  claimed: boolean;
  createdAt: Date;
  updatedAt: Date;
  user: User;
}

export interface CreateBetDTO {
  question: string;
  description?: string;
  minStake: number;
  endTimestamp: Date;
  creatorAddress: string;
  txHash: string;
}

export interface PlaceBetDTO {
  betId: string;
  userAddress: string;
  amount: number;
  position: Position;
  txHash: string;
}

export interface GetBetsFilter {
  status?: BetStatus;
  userAddress?: string;
  timeFilter?: TimeFilter;
}
