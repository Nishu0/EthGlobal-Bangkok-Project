import { useState, useEffect } from "react";
import { DynamicWidget, useDynamicContext } from "@dynamic-labs/sdk-react-core";
import { Avatar, AvatarImage } from "@/components/ui/avatar";
import { Check, Copy, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { toast } from "@/hooks/use-toast";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Card, CardContent } from "@/components/ui/card";

interface TokenInfo {
  symbol: string;
  name: string;
}

interface TokenMapping {
  [key: string]: TokenInfo;
}

interface Chain {
  id: number;
  name: string;
}

interface Token {
  chainId: number;
  address: string;
  symbol: string;
  name: string;
  amount: number;
  priceUSD: number;
  valueUSD: number;
  profitUSD: number;
  roi: number;
}

interface APITokenResponse {
  chain_id: number;
  contract_address: string;
  amount: string;
  price_to_usd: string;
  value_usd: string;
  abs_profit_usd: string;
  roi: string;
}

interface APIResponse {
  result: APITokenResponse[];
}

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
};

const SUPPORTED_CHAINS: Chain[] = [
  { id: 1, name: "Ethereum Mainnet" },
  { id: 42161, name: "Arbitrum" },
  { id: 56, name: "BNB Chain" },
  { id: 100, name: "Gnosis" },
  { id: 10, name: "Optimism" },
  { id: 137, name: "Polygon" },
  { id: 8453, name: "Base" },
];

export default function ProfilePage(): JSX.Element {
  const { primaryWallet } = useDynamicContext();
  const [selectedChain, setSelectedChain] = useState<string>("1");
  const [tokens, setTokens] = useState<Token[]>([]);
  const [loading, setLoading] = useState<boolean>(false);
  const [portfolioValue, setPortfolioValue] = useState<number>(0);

  const fetchTokens = async (): Promise<void> => {
    if (!primaryWallet?.address) return;

    setLoading(true);
    try {
      const apiKey: string | undefined =
        process.env.NEXT_PUBLIC_ONEINCH_API_KEY;
      if (!apiKey) {
        throw new Error("1inch API key is not configured");
      }

      const response: Response = await fetch(
        `https://api.1inch.dev/portfolio/portfolio/v4/overview/erc20/details?addresses=${primaryWallet.address}&chain_id=${selectedChain}`,
        {
          method: "GET",
          headers: {
            Authorization: `Bearer ${apiKey}`,
            Accept: "application/json",
            "Content-Type": "application/json",
          },
        }
      );

      if (!response.ok) {
        switch (response.status) {
          case 401:
            throw new Error(
              "Invalid or missing API key. Please check your API key configuration."
            );
          case 403:
            throw new Error(
              "Access forbidden. Please verify your API permissions."
            );
          case 429:
            throw new Error("Rate limit exceeded. Please try again later.");
          default:
            throw new Error(
              `API request failed with status: ${response.status}`
            );
        }
      }

      const data: APIResponse = await response.json();

      if (data && data.result) {
        const formattedTokens: Token[] = data.result.map(
          (token: APITokenResponse): Token => ({
            chainId: token.chain_id,
            address: token.contract_address,
            symbol: TOKEN_MAPPING[token.contract_address]?.symbol || "Unknown",
            name:
              TOKEN_MAPPING[token.contract_address]?.name || "Unknown Token",
            amount: parseFloat(token.amount),
            priceUSD: parseFloat(token.price_to_usd),
            valueUSD: parseFloat(token.value_usd),
            profitUSD: parseFloat(token.abs_profit_usd),
            roi: parseFloat(token.roi) * 100,
          })
        );

        setTokens(formattedTokens);
        const totalValue: number = formattedTokens.reduce(
          (acc: number, token: Token): number => acc + token.valueUSD,
          0
        );
        setPortfolioValue(totalValue);
      }
    } catch (error) {
      console.error("Error fetching tokens:", error);
      toast({
        title: "Error",
        description:
          error instanceof Error
            ? error.message
            : "Failed to fetch tokens. Please try again.",
        variant: "destructive",
      });
      setTokens([]);
      setPortfolioValue(0);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (primaryWallet?.address && selectedChain) {
      fetchTokens();
    }
  }, [primaryWallet?.address, selectedChain]);

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
    value: number,
    minimumFractionDigits: number = 2,
    maximumFractionDigits: number = 2
  ): string => {
    return value.toLocaleString(undefined, {
      minimumFractionDigits,
      maximumFractionDigits,
    });
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

  return (
    <div className="min-h-screen bg-black text-white p-6 relative">
      <h1 className="text-2xl font-bold text-neutral-400 mb-8">Profile Page</h1>

      <div className="flex justify-center mb-12">
        <Avatar className="w-24 h-24 border-4 border-neutral-800">
          <AvatarImage
            src="https://github.com/shadcn.png"
            alt="Profile picture"
            className="object-cover"
          />
        </Avatar>
      </div>

      <div className="mb-6">
        <Select
          value={selectedChain}
          onValueChange={(value: string) => setSelectedChain(value)}
        >
          <SelectTrigger className="bg-neutral-900 border-neutral-800">
            <SelectValue placeholder="Select Chain" />
          </SelectTrigger>
          <SelectContent className="bg-neutral-900 border-neutral-800">
            {SUPPORTED_CHAINS.map((chain: Chain) => (
              <SelectItem key={chain.id} value={chain.id.toString()}>
                {chain.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
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
        {loading ? (
          <div className="flex justify-center p-8">
            <Loader2 className="h-8 w-8 animate-spin" />
          </div>
        ) : tokens.length > 0 ? (
          <div className="space-y-4">
            {tokens.map((token: Token, index: number) => (
              <div
                key={index}
                className="flex items-center justify-between bg-neutral-900 rounded-2xl p-4"
              >
                <div className="flex flex-col">
                  <div className="flex items-center">
                    <span className="text-lg font-bold">{token.symbol}</span>
                    <span className="text-sm text-neutral-400 ml-2">
                      {token.name}
                    </span>
                  </div>
                  <span className="text-sm text-neutral-400">
                    ROI: {formatNumber(token.roi)}%
                  </span>
                </div>
                <div className="text-right">
                  <p className="text-lg font-bold">
                    {formatNumber(token.amount, 4)}
                  </p>
                  <p className="text-sm text-neutral-400">
                    ${formatNumber(token.valueUSD)}
                  </p>
                  <p className="text-xs text-neutral-400">
                    Price: ${formatNumber(token.priceUSD)}
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
