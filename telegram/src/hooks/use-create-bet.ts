import { useContractWrite } from "wagmi";
import { marketAbi } from "../../abis/market";
import { parseEther } from "viem";

const MARKET_CONTRACT_ADDRESS = "YOUR_CONTRACT_ADDRESS"; // Replace with actual address

export function useCreateBet(question: string, duration: number) {
  const { config } = usePrepareContractWrite({
    address: MARKET_CONTRACT_ADDRESS,
    abi: marketAbi,
    functionName: "createQuestion",
    args: [
      BigInt(question), // Convert question to appropriate format if needed
      BigInt(duration),
    ],
  });

  const {
    data: writeData,
    write,
    isLoading: isWriteLoading,
  } = useContractWrite(config);

  const { isLoading: isConfirming, isSuccess } = useWaitForTransaction({
    hash: writeData?.hash,
  });

  return {
    write,
    isLoading: isWriteLoading || isConfirming,
    isSuccess,
    txHash: writeData?.hash,
  };
}
