export type IconProps = {
  size?: number;
  className?: string;
};

export type TabType =
  | "home"
  | "bet"
  | "friends"
  | "tasks"
  | "create-bet"
  | "profile"
  | "swap"
  | "ens";

export type TimeFilterKey = "All" | "1D" | "1W" | "1M" | "1Y";

export enum BetStatus {
  ONGOING = "ONGOING",
  COMPLETED = "COMPLETED",
  CANCELLED = "CANCELLED",
}

export enum Position {
  YES = "YES",
  NO = "NO",
}

export type Bet = {
  id: string;
  questionId: number;
  question: string;
  description?: string;
  minStake: number;
  endTimestamp: string;
  creatorId: string;
  creator: {
    address: string;
  };
  txHash: string;
  status: BetStatus;
  totalAmount: number;
  totalYesAmount: number;
  totalNoAmount: number;
  eventCompleted: boolean;
  positions: Array<{
    amount: number;
    position: Position;
  }>;
  timeLeft?: {
    days: number;
    hours: number;
    minutes: number;
  };
};

export type PlaceBetParams = {
  betId: string;
  position: Position;
  amount: number;
  userAddress: string;
  txHash: string;
};
