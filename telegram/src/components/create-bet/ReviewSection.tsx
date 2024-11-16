import React from "react";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Clock, Globe, Loader2, Users } from "lucide-react";
import { Icons } from "@/components/icons";
import { useWriteContract, useWaitForTransactionReceipt } from "wagmi";
import { marketAbi } from "../../../abis/market";
import { toast } from "sonner";
import { useRouter } from "next/navigation";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useTab } from "@/contexts/TabContext";
import { useDynamicContext } from "@dynamic-labs/sdk-react-core";

interface ReviewPageProps {
  formData: {
    audience: string;
    description: string;
    minStake: number;
    duration: number;
    hasDescription: boolean;
    descriptionText?: string;
  };
}

const ReviewPage: React.FC<ReviewPageProps> = ({ formData }) => {
  const router = useRouter();
  const queryClient = useQueryClient();
  const { activeTab, setActiveTab } = useTab();
  const { primaryWallet } = useDynamicContext();

  const { writeContractAsync } = useWriteContract();

  // Create bet mutation
  const createBetMutation = useMutation({
    mutationFn: async ({ txHash }: { txHash: `0x${string}` }) => {
      const response = await fetch("http://localhost:8000/api/bets", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          creatorAddress: primaryWallet?.address,
          question: formData.description,
          description: formData.descriptionText,
          minStake: formData.minStake,
          endTimestamp: new Date(Date.now() + formData.duration * 1000),
          txHash,
        }),
      });
      console.log("response", response);
      if (!response.ok) {
        throw new Error("Failed to create bet");
      }

      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["bets"] });
      toast.success("Bet created successfully!");
      setActiveTab("create-bet");
    },
    onError: (error) => {
      console.error("Error creating bet:", error);
      toast.error("Failed to create bet. Please try again.");
    },
  });

  const handleCreateBet = async () => {
    try {
      // Convert description to bytes32 by hashing it
      const minStake = 100;

      // Calculate end timestamp in seconds
      console.log("Date.now()", Date.now());
      const endTimestamp = Math.floor(1735689600 - Date.now() / 1000);
      console.log("minStake", minStake);
      console.log("endTimestamp", endTimestamp);
      // Write to contract
      const result = await writeContractAsync({
        address: process.env
          .NEXT_PUBLIC_MARKET_CONTRACT_ADDRESS as `0x${string}`,
        abi: marketAbi,
        functionName: "createQuestion",
        args: [BigInt(minStake), BigInt(endTimestamp)],
      });

      // Create bet in database
      if (result) {
        await createBetMutation.mutateAsync({ txHash: result });
      }
    } catch (error) {
      console.error("Error creating bet:", error);
      toast.error("Failed to create bet. Please try again.");
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -10 }}
      className="space-y-6 max-w-2xl mx-auto"
    >
      <h2 className="text-xl font-semibold bg-gradient-to-r from-blue-400 via-purple-500 to-blue-400 bg-clip-text text-transparent text-center mb-6">
        Review Your Bet Details
      </h2>

      <Card className="bg-gray-800/50 border-gray-700">
        <CardContent className="p-6 space-y-4">
          <div className="space-y-4">
            <div className="space-y-2">
              <h3 className="text-sm font-medium text-gray-400">Audience</h3>
              <p className="text-lg text-white flex items-center gap-2">
                {formData.audience === "everyone" ? (
                  <>
                    <Globe className="w-5 h-5 text-blue-400" />
                    Everyone
                  </>
                ) : (
                  <>
                    <Users className="w-5 h-5 text-purple-400" />
                    Friends Only
                  </>
                )}
              </p>
            </div>

            <div className="space-y-2">
              <h3 className="text-sm font-medium text-gray-400">Question</h3>
              <p className="text-lg text-white">{formData.description}</p>
            </div>

            {formData.hasDescription && formData.descriptionText && (
              <div className="space-y-2">
                <h3 className="text-sm font-medium text-gray-400">
                  Description
                </h3>
                <p className="text-base text-gray-200">
                  {formData.descriptionText}
                </p>
              </div>
            )}

            <div className="grid grid-cols-2 gap-4 pt-4">
              <div className="space-y-2">
                <h3 className="text-sm font-medium text-gray-400">
                  Minimum Stake
                </h3>
                <p className="text-lg text-white flex items-center gap-2">
                  <Icons.Wallet className="w-5 h-5 text-green-400" />
                  {formData.minStake.toLocaleString()} USDC
                </p>
              </div>

              <div className="space-y-2">
                <h3 className="text-sm font-medium text-gray-400">Duration</h3>
                <p className="text-lg text-white flex items-center gap-2">
                  <Clock className="w-5 h-5 text-yellow-400" />
                  {Math.ceil(formData.duration / (24 * 60 * 60))} days
                </p>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      <Button
        className="w-full bg-blue-600 hover:bg-blue-700 text-white py-6 text-lg font-medium"
        onClick={handleCreateBet}
        disabled={createBetMutation.isPending}
      >
        {createBetMutation.isPending ? (
          <div className="flex items-center gap-2">
            <Loader2 className="w-4 h-4 animate-spin" />
            Creating Bet...
          </div>
        ) : (
          "Create Bet"
        )}
      </Button>
    </motion.div>
  );
};

export default ReviewPage;
