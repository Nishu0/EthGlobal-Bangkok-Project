import { useState, useEffect } from "react";
import { DynamicWidget, useDynamicContext } from "@dynamic-labs/sdk-react-core";
import { Avatar, AvatarImage } from "@/components/ui/avatar";
import { Check, ChevronDownIcon, Copy, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { toast } from "@/hooks/use-toast";
import { useAccount, useEnsAddress, useEnsAvatar, useEnsName } from "wagmi";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Card, CardContent } from "@/components/ui/card";
import { useQuery } from "@tanstack/react-query";
import { z } from "zod";

// Type definitions
interface TokenInfo {
  symbol: string;
  name: string;
}

interface Chain {
  id: number;
  name: string;
  icon: string;
}

interface TokenMapping {
  [key: string]: TokenInfo;
}

// Zod schemas
const TokenResponseSchema = z.object({
  chain_id: z.number(),
  contract_address: z.string(),
  amount: z.number(), // Changed from string to number
  price_to_usd: z.number(), // Changed from string to number
  value_usd: z.number(), // Changed from string to number
  abs_profit_usd: z.number(), // Changed from string to number
  roi: z.number(), // Changed from string to number
  status: z.number(),
  symbol: z.string(),
  name: z.string(),
});

const APIResponseSchema = z.object({
  result: z.array(TokenResponseSchema),
});

// Types inferred from Zod schemas
type TokenResponse = z.infer<typeof TokenResponseSchema>;
type APIResponse = z.infer<typeof APIResponseSchema>;

const TOKEN_MAPPING: TokenMapping = {
  "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee": {
    symbol: "ETH",
    name: "Ethereum",
  },
  "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599": {
    symbol: "WBTC",
    name: "Wrapped Bitcoin",
  },
  "0xdac17f958d2ee523a2206206994597c13d831ec7": {
    symbol: "USDT",
    name: "Tether USD",
  },
  "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48": {
    symbol: "USDC",
    name: "USD Coin",
  },
} as const;

const SUPPORTED_CHAINS: readonly Chain[] = [
  {
    id: 1,
    name: "Ethereum",
    icon: "https://app.1inch.io/assets/images/network-logos/ethereum.svg",
  },
  {
    id: 56,
    name: "BNB Chain",
    icon: "https://app.1inch.io/assets/images/network-logos/bsc_2.svg",
  },
  {
    id: 137,
    name: "Polygon",
    icon: "https://app.1inch.io/assets/images/network-logos/polygon_1.svg",
  },
  {
    id: 42161,
    name: "Arbitrum",
    icon: "https://app.1inch.io/assets/images/network-logos/arbitrum_2.svg",
  },
  {
    id: 100,
    name: "Gnosis",
    icon: "https://app.1inch.io/assets/images/network-logos/gnosis.svg",
  },
  {
    id: 10,
    name: "Optimism",
    icon: "https://app.1inch.io/assets/images/network-logos/optimism.svg",
  },
  {
    id: 8453,
    name: "Base",
    icon: "https://app.1inch.io/assets/images/network-logos/base.svg",
  },
  {
    id: 43114,
    name: "Avalanche",
    icon: "https://app.1inch.io/assets/images/network-logos/avalanche.svg",
  },
] as const;

// API function with explicit parameter types
const fetchPortfolio = async (
  address: string,
  chainId: string
): Promise<APIResponse> => {
  const response: Response = await fetch(
    `http://localhost:8000/api/getportfolio?address=${address}&chainId=${chainId}`
  );

  if (!response.ok) {
    throw new Error("Failed to fetch portfolio data");
  }

  const data: unknown = await response.json();
  return APIResponseSchema.parse(data);
};

export default function ProfilePage(): JSX.Element {
  const { primaryWallet } = useDynamicContext();
  const [selectedChain, setSelectedChain] = useState<string>("1");
  const [portfolioValue, setPortfolioValue] = useState<number>(0);

  const {
    data: portfolioData,
    isLoading,
    error,
  } = useQuery<APIResponse, Error>({
    queryKey: ["portfolio", primaryWallet?.address, selectedChain],
    queryFn: () =>
      primaryWallet?.address
        ? fetchPortfolio(primaryWallet.address, selectedChain)
        : Promise.reject(new Error("No wallet address")),
    enabled: !!primaryWallet?.address,
    staleTime: 30000,
    refetchInterval: 60000,
  });

  useEffect((): void => {
    if (portfolioData?.result) {
      const totalValue: number = portfolioData.result.reduce(
        (acc: number, token: TokenResponse): number => acc + token.value_usd,
        0
      );
      setPortfolioValue(totalValue);
    }
  }, [portfolioData]);

  const copyWalletAddress = (): void => {
    if (primaryWallet?.address) {
      navigator.clipboard.writeText(primaryWallet.address);
      toast({
        title: "Copied!",
        description: "Wallet address copied to clipboard.",
      });
    }
  };

  const formatNumber = (
    value: number | string,
    minimumFractionDigits: number = 10,
    maximumFractionDigits: number = 10
  ): string => {
    const numValue: number =
      typeof value === "string" ? parseFloat(value) : value;
    return numValue.toLocaleString(undefined, {
      minimumFractionDigits,
      maximumFractionDigits,
    });
  };

  const handleChainSelect = (value: string): void => {
    setSelectedChain(value);
  };

  if (!primaryWallet) {
    return (
      <div className="min-h-screen bg-black text-white p-6 flex flex-col items-center justify-center">
        <h1 className="text-2xl font-bold text-neutral-400 mb-8">
          Profile Page
        </h1>
        <Card className="bg-neutral-900 w-full max-w-md">
          <CardContent className="p-6">
            <p className="text-center mb-4">
              Connect your wallet to view your portfolio
            </p>
            <DynamicWidget />
          </CardContent>
        </Card>
      </div>
    );
  }

  if (error instanceof Error) {
    return (
      <div className="min-h-screen bg-black text-white p-6 flex flex-col items-center justify-center">
        <Card className="bg-neutral-900 w-full max-w-md">
          <CardContent className="p-6">
            <p className="text-center text-red-500">
              {error.message ||
                "Error loading portfolio data. Please try again later."}
            </p>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-black text-white p-6 relative">
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-3xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-purple-600">
          Profile Page
        </h1>
        <div className="w-48">
          <Select value={selectedChain} onValueChange={handleChainSelect}>
            <SelectTrigger className="bg-gray-800 border-gray-700 text-white">
              <div className="flex items-center">
                <SelectValue />
              </div>
            </SelectTrigger>
            <SelectContent className="bg-gray-800 border-gray-700">
              {SUPPORTED_CHAINS.map((chain: Chain) => (
                <SelectItem
                  key={chain.id}
                  value={chain.id.toString()}
                  className="text-white hover:bg-gray-700"
                >
                  <div className="flex items-center">
                    <img
                      src={chain.icon}
                      alt={chain.name}
                      className="w-5 h-5 mr-2"
                    />
                    <span>{chain.name}</span>
                  </div>
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </div>

      <div className="flex justify-center mb-12">
        <Avatar className="w-24 h-24 border-4 border-neutral-800">
          <AvatarImage
            src="https://github.com/shadcn.png"
            alt="Profile picture"
            className="object-cover"
          />
        </Avatar>
      </div>

      <div className="flex justify-between mb-12">
        <div>
          <p className="text-neutral-400 text-sm mb-2">
            Portfolio Value (USDC)
          </p>
          <p className="text-4xl font-bold">${formatNumber(portfolioValue)}</p>
        </div>
      </div>

      <div className="bg-neutral-900 rounded-3xl p-6 mb-6">
        <div className="flex items-center justify-between">
          <p className="text-lg font-bold truncate flex-1 mr-2">
            {primaryWallet?.address}
          </p>
          <Button
            variant="ghost"
            size="icon"
            onClick={copyWalletAddress}
            className="text-neutral-400 shrink-0"
          >
            <Copy className="h-5 w-5" />
          </Button>
        </div>
      </div>

      <div className="mb-12">
        <h2 className="text-xl font-bold mb-4">Tokens</h2>
        {isLoading ? (
          <div className="flex justify-center p-8">
            <Loader2 className="h-8 w-8 animate-spin" />
          </div>
        ) : portfolioData?.result && portfolioData.result.length > 0 ? (
          <div className="space-y-4">
            {portfolioData.result.map((token: TokenResponse, index: number) => (
              <div
                key={`${token.contract_address}-${index}`}
                className="flex items-center justify-between bg-neutral-900 rounded-2xl p-4"
              >
                <div className="flex flex-col">
                  <div className="flex items-center">
                    <span className="text-lg font-bold">
                      <span>{token.symbol}</span>
                    </span>
                    <span className="text-sm text-neutral-400 ml-2">
                      <span>{token.name}</span>
                    </span>
                  </div>
                  <span className="text-sm text-neutral-400">
                    ROI: {formatNumber(token.roi * 100)}%{" "}
                    {/* Removed parseFloat */}
                  </span>
                </div>
                <div className="text-right">
                  <p className="text-lg font-bold">
                    {formatNumber(token.amount, 4)} {/* Removed parseFloat */}
                  </p>
                  <p className="text-sm text-neutral-400">
                    ${formatNumber(token.value_usd)} {/* Removed parseFloat */}
                  </p>
                  <p className="text-xs text-neutral-400">
                    Price: ${formatNumber(token.price_to_usd)}{" "}
                    {/* Removed parseFloat */}
                  </p>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="text-center p-8 bg-neutral-900 rounded-2xl">
            <p className="text-neutral-400">No tokens found for this chain</p>
          </div>
        )}
      </div>
    </div>
  );
}
