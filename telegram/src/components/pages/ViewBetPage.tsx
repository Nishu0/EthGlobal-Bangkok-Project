import React, { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Button } from "../ui/button";
import { Plus } from "lucide-react";
import { useTab } from "@/contexts/TabContext";
import BetsList from "../BetsList";
import BetsFilter from "../BetsFilter";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { toast } from "sonner";
import { Loader2 } from "lucide-react";

type TimeFilterKey = "All" | "1D" | "1W" | "1M" | "1Y";

enum BetStatus {
  OPEN = "OPEN",
  CLOSED = "CLOSED",
  RESOLVED = "RESOLVED",
}

type Bet = {
  id: number;
  question: string;
  description?: string;
  minStake: number;
  endTimestamp: string;
  creatorAddress: string;
  txHash: string;
  status: BetStatus;
  yesAmount?: number;
  noAmount?: number;
  betAmount?: number;
  maxPayout?: number;
  timeLeft?: {
    days: number;
    hours: number;
    minutes: number;
  };
};

type PlaceBetParams = {
  betId: number;
  position: "YES" | "NO"; // Changed to match Prisma enum
  amount: number;
  userAddress: string;
  txHash: string;
};

const BetsPage = () => {
  const queryClient = useQueryClient();
  const [selectedTimeFilter, setSelectedTimeFilter] =
    useState<TimeFilterKey>("All");
  const [currentTab, setCurrentTab] = useState("ongoing");
  const { setActiveTab } = useTab();

  // Convert UI status to API status
  const getApiStatus = (tab: string): BetStatus => {
    return tab === "ongoing" ? BetStatus.OPEN : BetStatus.CLOSED;
  };

  // Format time filter for API
  const formatTimeFilter = (filter: TimeFilterKey): string => {
    return filter.toLowerCase();
  };

  // Fetch bets query
  const {
    data: bets = [],
    isLoading: isFetchingBets,
    error: fetchError,
  } = useQuery({
    queryKey: ["bets", selectedTimeFilter, currentTab],
    queryFn: async () => {
      const params = new URLSearchParams({
        timeFilter: formatTimeFilter(selectedTimeFilter),
        status: getApiStatus(currentTab),
      });

      const response = await fetch(`http://localhost:8000/api/bets?${params}`);

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || "Failed to fetch bets");
      }

      return response.json();
    },
    retry: 1,
    staleTime: 30000, // Consider data fresh for 30 seconds
  });

  // Place bet mutation
  const placeBetMutation = useMutation({
    mutationFn: async ({
      betId,
      position,
      amount,
      userAddress,
      txHash,
    }: PlaceBetParams) => {
      const response = await fetch(
        `http://localhost:8000/api/bets/${betId}/positions`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            position,
            amount,
            userAddress,
            txHash,
          }),
        }
      );

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || "Failed to place bet");
      }

      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["bets"] });
      toast.success("Bet placed successfully!");
    },
    onError: (error: Error) => {
      console.error("Error placing bet:", error);
      toast.error(error.message || "Failed to place bet. Please try again.");
    },
  });

  const handlePlaceBet = (
    betId: number,
    position: "YES" | "NO",
    amount: number
  ) => {
    placeBetMutation.mutate({
      betId,
      position,
      amount,
      userAddress: "user_address", // Get from your auth context
      txHash: "sample_tx_hash", // Get from blockchain transaction
    });
  };

  const renderBetButtons = (bet: Bet) => {
    if (bet.status === BetStatus.CLOSED) {
      return (
        <Button className="bg-gray-600 cursor-not-allowed" disabled>
          Betting Closed
        </Button>
      );
    }

    const isPlacingBet = placeBetMutation.isPending;

    return (
      <div className="flex gap-2">
        <Button
          className="bg-green-600 hover:bg-green-700"
          onClick={() => handlePlaceBet(bet.id, "YES", bet.minStake)}
          disabled={isPlacingBet}
        >
          {isPlacingBet ? (
            <Loader2 className="w-4 h-4 mr-2 animate-spin" />
          ) : null}
          Yes
        </Button>
        <Button
          className="bg-red-600 hover:bg-red-700"
          onClick={() => handlePlaceBet(bet.id, "NO", bet.minStake)}
          disabled={isPlacingBet}
        >
          {isPlacingBet ? (
            <Loader2 className="w-4 h-4 mr-2 animate-spin" />
          ) : null}
          No
        </Button>
      </div>
    );
  };

  return (
    <div className="min-h-screen bg-black text-white p-4">
      <div className="mb-6 flex justify-between items-center">
        <h1 className="text-2xl font-bold">My Bets</h1>
        <Button
          onClick={() => setActiveTab("create-bet")}
          className="bg-blue-600 hover:bg-blue-700"
        >
          <Plus className="w-4 h-4 mr-2" />
          Create Bet
        </Button>
      </div>

      <BetsFilter
        currentTab={currentTab}
        setCurrentTab={setCurrentTab}
        selectedTimeFilter={selectedTimeFilter}
        setSelectedTimeFilter={setSelectedTimeFilter}
      />

      {(fetchError || placeBetMutation.error) && (
        <Alert variant="destructive" className="mb-4">
          <AlertDescription>
            {fetchError?.message ||
              placeBetMutation.error?.message ||
              "An error occurred"}
          </AlertDescription>
        </Alert>
      )}

      {isFetchingBets ? (
        <div className="flex flex-col items-center justify-center h-64 space-y-4">
          <Loader2 className="w-8 h-8 animate-spin text-blue-500" />
          <p className="text-gray-400">Loading bets...</p>
        </div>
      ) : bets.length === 0 ? (
        <div className="text-center py-8 text-gray-400">
          No bets found for the selected filters
        </div>
      ) : (
        <div className="space-y-4">
          {bets.map((bet: Bet) => (
            <div key={bet.id} className="bg-gray-800 p-4 rounded-lg">
              <div className="flex justify-between items-start mb-4">
                <div>
                  <h3 className="text-lg font-semibold">{bet.question}</h3>
                  <p className="text-gray-400">{bet.description}</p>
                  <p className="text-sm text-gray-400">
                    Min Stake: {bet.minStake} FLOW
                  </p>
                </div>
                {renderBetButtons(bet)}
              </div>
              <div className="text-sm text-gray-400">
                Transaction: {bet.txHash.slice(0, 10)}...
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default BetsPage;
