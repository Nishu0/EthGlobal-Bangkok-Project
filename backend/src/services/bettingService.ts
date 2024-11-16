import { PrismaClient, Position, BetStatus } from "@prisma/client";

const prisma = new PrismaClient();

export class BettingService {
  async createBet(data: {
    question: string;
    description?: string;
    minStake: number;
    endTimestamp: Date;
    creatorAddress: string;
    txHash: string;
  }) {
    const user = await prisma.user.findUnique({
      where: { address: data.creatorAddress },
    });

    if (!user) {
      throw new Error("User not found");
    }

    return prisma.bet.create({
      data: {
        question: data.question,
        description: data.description,
        minStake: data.minStake,
        endTimestamp: data.endTimestamp,
        creator: { connect: { id: user.id } },
        txHash: data.txHash,
      },
    });
  }

  async placeBet(data: {
    betId: string;
    userAddress: string;
    amount: number;
    position: Position;
    txHash: string;
  }) {
    const user = await prisma.user.findUnique({
      where: { address: data.userAddress },
    });

    if (!user) {
      throw new Error("User not found");
    }

    const bet = await prisma.bet.findUnique({
      where: { id: data.betId },
    });

    if (!bet) {
      throw new Error("Bet not found");
    }

    // Create bet position
    const position = await prisma.betPosition.create({
      data: {
        bet: { connect: { id: data.betId } },
        user: { connect: { id: user.id } },
        amount: data.amount,
        position: data.position,
        txHash: data.txHash,
      },
    });

    // Update bet totals
    await prisma.bet.update({
      where: { id: data.betId },
      data: {
        totalAmount: { increment: data.amount },
        ...(data.position === Position.YES
          ? { totalYesAmount: { increment: data.amount } }
          : { totalNoAmount: { increment: data.amount } }),
      },
    });

    return position;
  }

  async getBets(filter: {
    status?: BetStatus;
    userAddress?: string;
    timeFilter?: "all" | "1d" | "1w" | "1m" | "1y";
  }) {
    const timeFilters = {
      "1d": { gte: new Date(Date.now() - 24 * 60 * 60 * 1000) },
      "1w": { gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000) },
      "1m": { gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000) },
      "1y": { gte: new Date(Date.now() - 365 * 24 * 60 * 60 * 1000) },
    };

    return prisma.bet.findMany({
      where: {
        ...(filter.status && { status: filter.status }),
        ...(filter.userAddress && {
          OR: [
            { creator: { address: filter.userAddress } },
            { positions: { some: { user: { address: filter.userAddress } } } },
          ],
        }),
        ...(filter.timeFilter &&
          filter.timeFilter !== "all" && {
            createdAt:
              timeFilters[filter.timeFilter as keyof typeof timeFilters],
          }),
      },
      include: {
        creator: true,
        positions: {
          include: {
            user: true,
          },
        },
      },
      orderBy: {
        createdAt: "desc",
      },
    });
  }
}
