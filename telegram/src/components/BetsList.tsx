import React from "react";
import { renderTimeLeft, renderBetCard } from "./BetUtils";
import { format } from "date-fns";

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

interface BetsListProps {
  currentTab: string;
  selectedTimeFilter: string;
  bets: Bet[];
}

const BetsList: React.FC<BetsListProps> = ({
  currentTab,
  selectedTimeFilter,
  bets,
}) => {
  const filteredBets = bets.filter((bet) => {
    switch (selectedTimeFilter) {
      case "1D":
        return new Date(bet.date).toDateString() === new Date().toDateString();
      case "1W":
        const oneWeekAgo = new Date();
        oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
        return new Date(bet.date) >= oneWeekAgo;
      case "1M":
        const oneMonthAgo = new Date();
        oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);
        return new Date(bet.date) >= oneMonthAgo;
      case "1Y":
        const oneYearAgo = new Date();
        oneYearAgo.setFullYear(oneYearAgo.getFullYear() - 1);
        return new Date(bet.date) >= oneYearAgo;
      default:
        return true;
    }
  });

  return (
    <div className="space-y-4">
      {currentTab === "ongoing" && (
        <div>
          {filteredBets.map((bet) => (
            <div key={bet.id} className="mb-6">
              <div className="text-gray-400 mb-2">
                {format(new Date(bet.date), "dd MMMM yyyy")}
              </div>
              {renderBetCard(bet)}
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default BetsList;
