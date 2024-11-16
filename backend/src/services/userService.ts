import { PrismaClient, User } from "@prisma/client";

export class UserService {
  private prisma: PrismaClient;

  constructor() {
    this.prisma = new PrismaClient();
  }

  async connectWallet(address: string): Promise<User> {
    try {
      // Check if user already exists
      const existingUser = await this.prisma.user.findUnique({
        where: { address },
      });

      if (existingUser) {
        return existingUser;
      }

      // Create new user if doesn't exist
      const newUser = await this.prisma.user.create({
        data: { address },
      });

      return newUser;
    } catch (error) {
      if (error instanceof Error) {
        throw new Error(`Failed to connect wallet: ${error.message}`);
      }
      throw new Error("Failed to connect wallet");
    }
  }

  async getUser(address: string): Promise<User | null> {
    return this.prisma.user.findUnique({ where: { address } });
  }
}
