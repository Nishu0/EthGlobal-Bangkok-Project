import {
  useContractWrite,
  usePrepareContractWrite,
  useWaitForTransaction,
} from "wagmi";
export function usePlaceBet(
  questionId: number,
  amount: number,
  isYesBet: boolean
) {
  const { config } = usePrepareContractWrite({
    address: process.env.NEXT_PUBLIC_MARKET_CONTRACT_ADDRESS,
    abi: marketAbi,
    functionName: isYesBet ? "addYesBet" : "addNoBet",
    args: [BigInt(questionId), parseEther(amount.toString())],
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
