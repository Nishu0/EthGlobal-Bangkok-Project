import axios from "axios";
import { TokenData, PortfolioResponse } from "../types/portfolio";
import dotenv from "dotenv";
import { TokenListService } from "./tokenListService";
dotenv.config();

export class PortfolioService {
  private readonly apiKey: string;
  private readonly baseUrl: string;
  private readonly tokenListService: TokenListService;

  constructor() {
    this.apiKey = process.env.ONEINCH_API_KEY || "";
    this.baseUrl =
      "https://api.1inch.dev/portfolio/portfolio/v4/overview/erc20/details";
    this.tokenListService = new TokenListService();
  }

  async getPortfolio(address: string, chainId: string): Promise<TokenData[]> {
    try {
      // Get portfolio data
      const response = await axios.get<PortfolioResponse>(this.baseUrl, {
        params: {
          addresses: address,
          chain_id: chainId,
        },
        headers: {
          Authorization: `Bearer ${this.apiKey}`,
          Accept: "application/json",
        },
      });

      // Group tokens by chain_id
      const tokensByChain = response.data.result.reduce((acc, token) => {
        if (!acc[token.chain_id]) {
          acc[token.chain_id] = [];
        }
        acc[token.chain_id].push(token);
        return acc;
      }, {} as { [key: number]: TokenData[] });

      // Enrich tokens with names and symbols
      const enrichedTokens: TokenData[] = [];

      for (const [chainId, tokens] of Object.entries(tokensByChain)) {
        const tokenList = await this.tokenListService.getTokenList(
          Number(chainId)
        );

        for (const token of tokens) {
          const tokenInfo = tokenList.get(token.contract_address.toLowerCase());
          enrichedTokens.push({
            ...token,
            symbol: tokenInfo?.symbol || "Unknown",
            name: tokenInfo?.name || "Unknown Token",
          });
        }
      }

      return enrichedTokens;
    } catch (error) {
      if (axios.isAxiosError(error)) {
        throw new Error(
          `API Error: ${error.response?.data?.message || error.message}`
        );
      }
      throw error;
    }
  }
}
