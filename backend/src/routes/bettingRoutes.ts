// routes/betting.routes.ts

import { Router } from "express";
import { BettingController } from "../controllers/bettingController";

const router = Router();
const bettingController = new BettingController();

// Create a new bet
router.post("/bets", bettingController.createBet);

// Place a bet
router.post("/bets/:betId/positions", bettingController.placeBet);

// Get bets with filters
router.get("/bets", bettingController.getBets);

export default router;
