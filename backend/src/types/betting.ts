// types/betting.ts

export enum BetStatus {
  OPEN = "OPEN",
  CLOSED = "CLOSED",
  RESOLVED = "RESOLVED",
}

export enum Position {
  YES = "YES",
  NO = "NO",
}

export type TimeFilter = "all" | "1d" | "1w" | "1m" | "1y";

export interface Bet {
  id: string;
  question: string;
  description?: string;
  minStake: number;
  endTimestamp: Date;
  creatorAddress: string;
  txHash: string;
  status: BetStatus;
  totalAmount: number;
  totalYesAmount: number;
  totalNoAmount: number;
  createdAt: Date;
  creator: User;
  positions: BetPosition[];
}

export interface User {
  id: string;
  address: string;
}

export interface BetPosition {
  id: string;
  betId: string;
  userId: string;
  amount: number;
  position: Position;
  txHash: string;
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
