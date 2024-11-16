// controllers/betting.controller.ts

import { Request, Response } from "express";
import { BettingService } from "../services/bettingService";

const bettingService = new BettingService();

export class BettingController {
  async createBet(req: Request, res: Response) {
    try {
      const {
        questionId,
        question,
        description,
        minStake,
        endTimestamp,
        creatorAddress,
        txHash,
      } = req.body;

      const bet = await bettingService.createBet({
        questionId,
        question,
        description,
        minStake,
        endTimestamp: new Date(endTimestamp),
        creatorAddress,
        txHash,
      });

      res.status(201).json(bet);
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  }

  async placeBet(req: Request, res: Response) {
    try {
      const { betId, userAddress, amount, position, txHash } = req.body;

      const betPosition = await bettingService.placeBet({
        betId,
        userAddress,
        amount,
        position,
        txHash,
      });

      res.status(201).json(betPosition);
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  }

  async getBets(req: Request, res: Response) {
    try {
      const { status, userAddress, timeFilter } = req.query;

      const bets = await bettingService.getBets({
        status: status as any,
        userAddress: userAddress as string,
        timeFilter: timeFilter as any,
      });

      res.status(200).json(bets);
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  }
}
