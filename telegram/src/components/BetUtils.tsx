import React from "react";
import { Button } from "@/components/ui/button";
import { MoveUpRight } from "lucide-react";
import { cn, truncate } from "@/lib/utils";

interface Bet {
  id: number;
  date: string;
  question: string;
  betAmount: number;
  maxPayout: number;
  answerChoice: string;
  txHash: string;
  time: string;
  timeLeft: { days: number; hours: number; minutes: number };
  status: string;
  paymentMethod: string;
}

export const renderTimeLeft = (timeLeft: {
  days: number;
  hours: number;
  minutes: number;
}) => {
  return (
    <div className="flex gap-2 text-gray-400">
      <span>{timeLeft.days}d</span>
      <span>{timeLeft.hours}h</span>
      <span>{timeLeft.minutes}m</span>
    </div>
  );
};

export const renderBetCard = (bet: Bet) => (
  <div key={bet.id} className="bg-gray-900 rounded-lg p-4 mb-4">
    <div className="flex justify-between items-start mb-4">
      {renderTimeLeft(bet.timeLeft)}
      <div className="text-right">
        <div className="text-sm text-gray-400">Bet Amount</div>
        <div className="text-xl font-bold">${bet.betAmount.toFixed(2)}</div>
      </div>
    </div>

    <div className="mb-4">
      <h3 className="text-lg font-medium mb-2">{bet.question}</h3>
    </div>

    <div className="grid grid-cols-2 gap-4 mb-4">
      <div>
        <div className="text-sm text-gray-400">Max. Payout</div>
        <div className="font-medium">${bet.maxPayout.toFixed(2)}</div>
      </div>
      <div>
        <div className="text-sm text-gray-400">Answer Choice</div>
        <div className="font-medium">{bet.answerChoice}</div>
      </div>
      <div>
        <div className="text-sm text-gray-400">Transaction Hash</div>
        <div className="font-medium">
          <a
            target="_blank"
            href={bet.txHash}
            className="flex flex-row items-center gap-2"
          >
            {truncate(bet.txHash, 4)}
            <MoveUpRight className="h-3 w-3" />
          </a>
        </div>
      </div>
      <div>
        <div className="text-sm text-gray-400">Time (GMT8+)</div>
        <div className="font-medium">{bet.time}</div>
      </div>
    </div>

    <div className="flex items-center justify-between">
      <Button
        variant="outline"
        className="w-full bg-gray-800 hover:bg-gray-700 border-gray-700"
      >
        Close Bet
      </Button>
    </div>

    <div className="mt-4 text-center text-green-500 text-sm">
      |||||| {bet.status} ||||||
    </div>
  </div>
);
