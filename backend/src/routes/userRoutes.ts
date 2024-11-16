import express from "express";
import { UserController } from "../controllers/userController";

const router = express.Router();
const userController = new UserController();

router.post("/user", userController.connectWallet.bind(userController));
router.get("/user", userController.connectWallet.bind(userController));

export default router;
