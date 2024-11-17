"use client";

import * as React from "react";
import {
  SDK,
  NetworkEnum,
  HashLock,
  QuoteParams,
  OrderInfo,
  PrivateKeyProviderConnector,
} from "@1inch/cross-chain-sdk";
import { Web3 } from "web3";
import { privateKeyToAddress } from "viem/accounts";
import { randomBytes } from "crypto";
import {
  ArrowDown,
  ArrowLeftRight,
  Lock,
  RefreshCcw,
  Settings2,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Alert, AlertDescription } from "@/components/ui/alert";

const USDT_ADDRESSES = {
  [NetworkEnum.OPTIMISM]: "0x94b008aA00579c1307B0EF2c499aD98a8ce58e58",
  [NetworkEnum.POLYGON]: "0xc2132D05D31c914a87C6611C10748AEb04B58e8F",
} as const;

// Network metadata remains the same as your original code
const networks = {
  [NetworkEnum.ETHEREUM]: {
    name: "Ethereum",
    icon: "https://app.1inch.io/assets/images/network-logos/ethereum.svg",
  },
  [NetworkEnum.POLYGON]: {
    name: "Polygon",
    icon: "https://app.1inch.io/assets/images/network-logos/polygon_1.svg",
  },
  [NetworkEnum.BINANCE]: {
    name: "BNB Chain",
    icon: "https://app.1inch.io/assets/images/network-logos/bsc_2.svg",
  },
  [NetworkEnum.ARBITRUM]: {
    name: "Arbitrum",
    icon: "https://app.1inch.io/assets/images/network-logos/arbitrum_2.svg",
  },
  [NetworkEnum.AVALANCHE]: {
    name: "Avalanche",
    icon: "https://app.1inch.io/assets/images/network-logos/avalanche.svg",
  },
  [NetworkEnum.OPTIMISM]: {
    name: "Optimism",
    icon: "https://app.1inch.io/assets/images/network-logos/optimism.svg",
  },
  [NetworkEnum.GNOSIS]: {
    name: "Gnosis",
    icon: "https://app.1inch.io/assets/images/network-logos/gnosis.svg",
  },
  [NetworkEnum.COINBASE]: {
    name: "Base",
    icon: "https://app.1inch.io/assets/images/network-logos/base.svg",
  },
} as const;

const tokens = {
  USDC: {
    name: "USD Coin",
    symbol: "USDC",
    icon: "https://tokens-data.1inch.io/images/0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48.png",
    decimals: 6,
  },
  USDT: {
    name: "Tether USD",
    symbol: "USDT",
    icon: "https://tokens-data.1inch.io/images/0xdac17f958d2ee523a2206206994597c13d831ec7.png",
    decimals: 6,
  },
};

function getRandomBytes32() {
  return "0x" + randomBytes(32).toString("hex");
}

export default function SwapPage() {
  const [fromNetwork, setFromNetwork] = React.useState<number>(
    NetworkEnum.POLYGON
  );
  const [toNetwork, setToNetwork] = React.useState<number>(
    NetworkEnum.OPTIMISM
  );
  const [amount, setAmount] = React.useState("");
  const [loading, setLoading] = React.useState(false);
  const [error, setError] = React.useState<string | null>(null);
  const [orderStatus, setOrderStatus] = React.useState<string | null>(null);

  const handleSwapNetworks = () => {
    setFromNetwork(toNetwork);
    setToNetwork(fromNetwork);
  };

  const initializeSDK = React.useCallback(async () => {
    if (
      !process.env.NEXT_PUBLIC_RPC_URL ||
      !process.env.NEXT_PUBLIC_PRIVATE_KEY ||
      !process.env.NEXT_PUBLIC_AUTH_KEY
    ) {
      throw new Error("Environment variables not configured");
    }

    const web3Instance = new Web3(process.env.NEXT_PUBLIC_RPC_URL);
    const blockchainProvider = new PrivateKeyProviderConnector(
      process.env.NEXT_PUBLIC_PRIVATE_KEY,
      web3Instance
    );

    return new SDK({
      url: "https://api.1inch.dev/fusion-plus",
      authKey: process.env.NEXT_PUBLIC_AUTH_KEY,
      blockchainProvider,
    });
  }, []);

  const handleSwap = React.useCallback(async () => {
    setLoading(true);
    setError(null);
    setOrderStatus(null);

    try {
      const sdk = await initializeSDK();
      const makerAddress = privateKeyToAddress(
        `0x${process.env.NEXT_PUBLIC_PRIVATE_KEY}`
      );

      // Convert amount to proper decimals (USDT has 6 decimals)
      const amountInDecimals = (
        parseFloat(amount) * Math.pow(10, 6)
      ).toString();

      const params: QuoteParams = {
        srcChainId: fromNetwork,
        dstChainId: toNetwork,
        srcTokenAddress:
          USDT_ADDRESSES[fromNetwork as keyof typeof USDT_ADDRESSES],
        dstTokenAddress:
          USDT_ADDRESSES[toNetwork as keyof typeof USDT_ADDRESSES],
        amount: amountInDecimals,
        enableEstimate: true,
        walletAddress: makerAddress,
      };

      // Get quote
      const quote = await sdk.getQuote(params);
      const secretsCount = quote.getPreset().secretsCount;

      // Generate secrets and create hash lock
      const secrets = Array.from({ length: secretsCount }).map(() =>
        getRandomBytes32()
      );
      const secretHashes = secrets.map((x) => HashLock.hashSecret(x));
      const hashLock = HashLock.forSingleFill(secrets[0]);

      // Place order
      const orderResponse = await sdk.placeOrder(quote, {
        walletAddress: makerAddress,
        hashLock,
        secretHashes,
      });

      setOrderStatus("Order placed, monitoring status...");

      // Monitor order status
      const intervalId = setInterval(async () => {
        try {
          const order = await sdk.getOrderStatus(orderResponse.orderHash);
          setOrderStatus(`Current status: ${order.status}`);

          if (order.status === "executed") {
            clearInterval(intervalId);
            setOrderStatus("Order completed successfully!");
            setLoading(false);
          }

          if (
            ["expired", "cancelled", "refunded", "refunding"].includes(
              order.status
            )
          ) {
            clearInterval(intervalId);
            setOrderStatus("Order unsuccessful");
            setLoading(false);
          }

          // Check for fills and submit secrets
          const fillsObject = await sdk.getReadyToAcceptSecretFills(
            orderResponse.orderHash
          );
          if (fillsObject.fills.length > 0) {
            for (const fill of fillsObject.fills) {
              await sdk.submitSecret(
                orderResponse.orderHash,
                secrets[fill.idx]
              );
              setOrderStatus(`Fill found and secret submitted`);
            }
          }
        } catch (error) {
          console.error("Error monitoring order:", error);
        }
      }, 5000);
    } catch (error) {
      console.error("Swap error:", error);
      setError(
        error instanceof Error
          ? error.message
          : "An error occurred during the swap"
      );
      setLoading(false);
    }
  }, [fromNetwork, toNetwork, amount, initializeSDK]);

  return (
    <div className="min-h-screen p-4 flex items-center justify-center">
      <Card className="w-full max-w-md border-neutral-800 bg-neutral-900">
        <CardContent className="p-6">
          <div className="flex items-center justify-between mb-6">
            <Tabs defaultValue="swap" className="w-[200px]">
              <TabsList className="grid w-full grid-cols-2 bg-neutral-800">
                <TabsTrigger value="swap">Swap</TabsTrigger>
                <TabsTrigger value="limit">Limit</TabsTrigger>
              </TabsList>
            </Tabs>
            <div className="flex gap-2">
              <Button
                variant="ghost"
                size="icon"
                className="text-neutral-400"
                disabled={loading}
              >
                <RefreshCcw className="h-4 w-4" />
              </Button>
              <Button variant="ghost" size="icon" className="text-neutral-400">
                <Settings2 className="h-4 w-4" />
              </Button>
            </div>
          </div>

          <div className="space-y-4">
            <div className="space-y-2">
              <Label className="text-sm text-neutral-400">You pay</Label>
              <div className="rounded-lg border border-neutral-800 bg-neutral-950 p-4 text-white">
                <div className="flex items-center gap-4">
                  <div className="flex-1">
                    <Input
                      type="number"
                      placeholder="0"
                      value={amount}
                      onChange={(e) => setAmount(e.target.value)}
                      disabled={loading}
                      className="border-0 bg-transparent text-2xl placeholder:text-neutral-600"
                    />
                  </div>
                  <div className="flex items-center gap-2">
                    <Select disabled value="USDC">
                      <SelectTrigger className="w-[120px] border-0 bg-neutral-800 text-w">
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectGroup>
                          <SelectLabel>Tokens</SelectLabel>
                          <SelectItem value="USDC">
                            <img
                              src={tokens.USDC.icon}
                              alt={tokens.USDC.name}
                              className="w-4 h-4 inline mr-2"
                            />
                            USDT
                          </SelectItem>
                        </SelectGroup>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
                <div className="mt-2 flex items-center justify-between text-sm">
                  <Select
                    value={fromNetwork.toString()}
                    onValueChange={(v) => setFromNetwork(Number(v))}
                    disabled={loading}
                  >
                    <SelectTrigger className="w-[140px] border-0 bg-transparent text-neutral-400">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectGroup>
                        <SelectLabel>Networks</SelectLabel>
                        <SelectItem value={NetworkEnum.POLYGON.toString()}>
                          <img
                            src={networks[NetworkEnum.POLYGON].icon}
                            alt={networks[NetworkEnum.POLYGON].name}
                            className="w-4 h-4 inline mr-2"
                          />
                          {networks[NetworkEnum.POLYGON].name}
                        </SelectItem>
                        <SelectItem value={NetworkEnum.OPTIMISM.toString()}>
                          <img
                            src={networks[NetworkEnum.OPTIMISM].icon}
                            alt={networks[NetworkEnum.OPTIMISM].name}
                            className="w-4 h-4 inline mr-2"
                          />
                          {networks[NetworkEnum.OPTIMISM].name}
                        </SelectItem>
                      </SelectGroup>
                    </SelectContent>
                  </Select>
                </div>
              </div>
            </div>

            <div className="flex justify-center">
              <Button
                variant="ghost"
                size="icon"
                className="rounded-full bg-neutral-800 text-neutral-400"
                onClick={handleSwapNetworks}
                disabled={loading}
              >
                <ArrowDown className="h-4 w-4" />
              </Button>
            </div>

            <div className="space-y-2">
              <Label className="text-sm text-neutral-400">You receive</Label>
              <div className="rounded-lg border border-neutral-800 bg-neutral-950 p-4 text-white">
                <div className="flex items-center gap-4">
                  <div className="flex-1">
                    <Input
                      type="number"
                      placeholder="0"
                      value={amount}
                      disabled
                      className="border-0 bg-transparent text-2xl placeholder:text-neutral-600"
                    />
                  </div>
                  <div className="flex items-center gap-2">
                    <Select disabled value="USDT">
                      <SelectTrigger className="w-[120px] border-0 bg-neutral-800">
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectGroup>
                          <SelectLabel>Tokens</SelectLabel>
                          <SelectItem value="USDT">
                            <img
                              src={tokens.USDT.icon}
                              alt={tokens.USDT.name}
                              className="w-4 h-4 inline mr-2"
                            />
                            USDT
                          </SelectItem>
                        </SelectGroup>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
                <div className="mt-2 flex items-center justify-between text-sm">
                  <Select
                    value={toNetwork.toString()}
                    onValueChange={(v) => setToNetwork(Number(v))}
                    disabled={loading}
                  >
                    <SelectTrigger className="w-[140px] border-0 bg-transparent text-neutral-400">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectGroup>
                        <SelectLabel>Networks</SelectLabel>
                        <SelectItem value={NetworkEnum.OPTIMISM.toString()}>
                          <img
                            src={networks[NetworkEnum.OPTIMISM].icon}
                            alt={networks[NetworkEnum.OPTIMISM].name}
                            className="w-4 h-4 inline mr-2"
                          />
                          {networks[NetworkEnum.OPTIMISM].name}
                        </SelectItem>
                        <SelectItem value={NetworkEnum.POLYGON.toString()}>
                          <img
                            src={networks[NetworkEnum.POLYGON].icon}
                            alt={networks[NetworkEnum.POLYGON].name}
                            className="w-4 h-4 inline mr-2"
                          />
                          {networks[NetworkEnum.POLYGON].name}
                        </SelectItem>
                      </SelectGroup>
                    </SelectContent>
                  </Select>
                </div>
              </div>
            </div>

            {error && (
              <Alert variant="destructive">
                <AlertDescription>{error}</AlertDescription>
              </Alert>
            )}

            {orderStatus && (
              <Alert>
                <AlertDescription>{orderStatus}</AlertDescription>
              </Alert>
            )}

            <Button
              className="w-full bg-blue-600 hover:bg-blue-700"
              size="lg"
              disabled={!amount || loading}
              onClick={handleSwap}
            >
              {loading
                ? "Processing..."
                : amount
                ? "Swap USDT"
                : "Enter an amount"}
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
