import axios from "axios";
import { TokenData, PortfolioResponse } from "../types/portfolio";
import dotenv from "dotenv";
dotenv.config();

export class PortfolioService {
  private readonly apiKey: string;
  private readonly baseUrl: string;

  constructor() {
    this.apiKey = process.env.ONEINCH_API_KEY || "";
    this.baseUrl =
      "https://api.1inch.dev/portfolio/portfolio/v4/overview/erc20/details";
  }

  async getPortfolio(address: string, chainId: string): Promise<TokenData[]> {
    try {
      console.log(this.apiKey);
      console.log("Getting portfolio");
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

      return response.data.result;
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
