export interface TokenData {
  chain_id: number;
  contract_address: string;
  amount: number;
  price_to_usd: number;
  value_usd: number;
  abs_profit_usd: number;
  roi: number;
  status: number;
  // Add these new fields for token info
  symbol?: string;
  name?: string;
}

export interface PortfolioResponse {
  result: TokenData[];
  meta?: any;
}

export interface TokenInfo {
  symbol: string;
  name: string;
  address: string;
  decimals: number;
  tags: string[];
  eip2612: boolean;
  isFoT: boolean;
}
