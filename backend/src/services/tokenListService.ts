import axios from "axios";
import { TokenInfo } from "../types/portfolio";

export class TokenListService {
  private tokenListCache: Map<number, Map<string, TokenInfo>> = new Map();
  private readonly chainIdToUrl: { [key: number]: string } = {
    1: "https://portfolio.1inch.io/assets/tokens-list/ethereum-tokens.json?v=2",
    56: "https://portfolio.1inch.io/assets/tokens-list/bsc-tokens.json?v=2",
    137: "https://portfolio.1inch.io/assets/tokens-list/polygon-tokens.json?v=2",
    42161:
      "https://portfolio.1inch.io/assets/tokens-list/arbitrum-tokens.json?v=2",
    100: "https://portfolio.1inch.io/assets/tokens-list/gnosis-tokens.json?v=2",
    10: "https://portfolio.1inch.io/assets/tokens-list/optimism-tokens.json?v=2",
    8453: "https://portfolio.1inch.io/assets/tokens-list/base-tokens.json?v=2",
    43114:
      "https://portfolio.1inch.io/assets/tokens-list/avalanche-tokens.json?v=2",
  };

  async getTokenList(chainId: number): Promise<Map<string, TokenInfo>> {
    // Check cache first
    if (this.tokenListCache.has(chainId)) {
      return this.tokenListCache.get(chainId)!;
    }

    const url = this.chainIdToUrl[chainId];
    if (!url) {
      throw new Error(`Unsupported chain ID: ${chainId}`);
    }

    try {
      const response = await axios.get<TokenInfo[]>(url);
      const tokenMap = new Map<string, TokenInfo>();

      response.data.forEach((token) => {
        tokenMap.set(token.address.toLowerCase(), token);
      });

      // Add native token if not present
      if (!tokenMap.has("0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee")) {
        const nativeTokens: { [key: number]: TokenInfo } = {
          1: { symbol: "ETH", name: "Ethereum" },
          56: { symbol: "BNB", name: "BNB" },
          137: { symbol: "MATIC", name: "Polygon" },
          42161: { symbol: "ETH", name: "Ethereum" },
          100: { symbol: "xDAI", name: "xDAI" },
          10: { symbol: "ETH", name: "Ethereum" },
          8453: { symbol: "ETH", name: "Ethereum" },
          43114: { symbol: "AVAX", name: "Avalanche" },
        } as any;

        if (nativeTokens[chainId]) {
          tokenMap.set("0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", {
            ...nativeTokens[chainId],
            address: "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
            decimals: 18,
            tags: ["native"],
            eip2612: false,
            isFoT: false,
          });
        }
      }

      // Cache the result
      this.tokenListCache.set(chainId, tokenMap);
      return tokenMap;
    } catch (error) {
      throw new Error(
        `Failed to fetch token list for chain ${chainId}: ${error}`
      );
    }
  }
}
