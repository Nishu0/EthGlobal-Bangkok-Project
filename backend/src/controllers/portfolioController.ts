import { Request, Response } from "express";
import { PortfolioService } from "../services/portfolioService";

export class PortfolioController {
  private portfolioService: PortfolioService;

  constructor() {
    this.portfolioService = new PortfolioService();
  }

  getPortfolio = async (req: Request, res: Response): Promise<void> => {
    try {
      const { address, chainId } = req.query;

      if (!address || !chainId) {
        res.status(400).json({ error: "Address and chainId are required" });
        return;
      }

      const portfolio = await this.portfolioService.getPortfolio(
        address as string,
        chainId as string
      );

      res.json({ result: portfolio });
    } catch (error) {
      res.status(500).json({
        error: error instanceof Error ? error.message : "Internal server error",
      });
    }
  };
}
