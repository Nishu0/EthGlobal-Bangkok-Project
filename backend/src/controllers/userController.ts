import { Request, Response } from "express";
import { UserService } from "../services/userService";

export class UserController {
  private userService: UserService;

  constructor() {
    this.userService = new UserService();
  }

  public connectWallet = async (req: Request, res: Response) => {
    try {
      const { address } = req.body;

      if (!address) {
        return res.status(400).json({
          success: false,
          message: "Wallet address is required",
        });
      }

      // Validate ethereum address format
      const addressRegex = /^0x[a-fA-F0-9]{40}$/;
      if (!addressRegex.test(address)) {
        return res.status(400).json({
          success: false,
          message: "Invalid wallet address format",
        });
      }

      const user = await this.userService.connectWallet(address);

      return res.json({
        success: true,
        data: user,
        message: "Wallet connected successfully",
      });
    } catch (error) {
      if (error instanceof Error) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }
      return res.status(500).json({
        success: false,
        message: "Internal server error",
      });
    }
  };

  public getUser = async (req: Request, res: Response) => {
    try {
      const { address } = req.body;
      const user = await this.userService.getUser(address);

      return res.json({
        success: true,
        data: user,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Error fetching user",
      });
    }
  };
}
