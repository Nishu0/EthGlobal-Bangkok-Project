import { Router } from "express";
import { PortfolioController } from "../controllers/portfolioController";

const router = Router();
const portfolioController = new PortfolioController();

router.get("/getportfolio", portfolioController.getPortfolio);

export default router;
