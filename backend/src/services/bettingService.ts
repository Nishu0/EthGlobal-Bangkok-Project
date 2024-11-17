import { PrismaClient } from "@prisma/client";
import {
  CreateBetDTO,
  PlaceBetDTO,
  GetBetsFilter,
  BetStatus,
  Position,
} from "../types/betting";

const prisma = new PrismaClient();

export class BettingService {
  async createBet(data: CreateBetDTO) {
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
        status: BetStatus.ONGOING,
        totalAmount: 0,
        totalYesAmount: 0,
        totalNoAmount: 0,
        eventCompleted: false,
        creator: { connect: { id: user.id } },
        txHash: data.txHash,
      },
    });
  }

  async placeBet(data: PlaceBetDTO) {
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

    if (bet.status !== BetStatus.ONGOING) {
      throw new Error("Bet is not open for positions");
    }

    if (bet.eventCompleted) {
      throw new Error("Event has already completed");
    }

    // Create bet position in a transaction
    return prisma.$transaction(async (tx) => {
      const position = await tx.betPosition.create({
        data: {
          bet: { connect: { id: data.betId } },
          user: { connect: { id: user.id } },
          amount: data.amount,
          position: data.position,
          txHash: data.txHash,
          claimed: false,
        },
      });

      await tx.bet.update({
        where: { id: data.betId },
        data: {
          totalAmount: { increment: data.amount },
          ...(data.position === Position.YES
            ? { totalYesAmount: { increment: data.amount } }
            : { totalNoAmount: { increment: data.amount } }),
        },
      });

      return position;
    });
  }

  async getBets(filter: GetBetsFilter) {
    const timeFilters = {
      "1d": { gte: new Date(Date.now() - 24 * 60 * 60 * 1000) },
      "1w": { gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000) },
      "1m": { gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000) },
      "1y": { gte: new Date(Date.now() - 365 * 24 * 60 * 60 * 1000) },
    };

    const whereClause: any = {
      ...(filter.status && { status: filter.status }),
      ...(filter.userAddress && {
        OR: [
          { creator: { address: filter.userAddress } },
          { positions: { some: { user: { address: filter.userAddress } } } },
        ],
      }),
      ...(filter.timeFilter &&
        filter.timeFilter !== "all" && {
          createdAt: timeFilters[filter.timeFilter],
        }),
    };

    return prisma.bet.findMany({
      where: whereClause,
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

  // Add method to complete event
  async completeBet(betId: string) {
    const bet = await prisma.bet.findUnique({
      where: { id: betId },
    });

    if (!bet) {
      throw new Error("Bet not found");
    }

    if (bet.status !== BetStatus.ONGOING) {
      throw new Error("Bet is not ongoing");
    }

    return prisma.bet.update({
      where: { id: betId },
      data: {
        status: BetStatus.COMPLETED,
        eventCompleted: true,
      },
    });
  }
}
