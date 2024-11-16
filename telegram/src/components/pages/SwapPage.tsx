"use client";

import * as React from "react";
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

// Network enum from the provided code
const NetworkEnum = {
  ETHEREUM: 1,
  POLYGON: 137,
  ZKSYNC: 324,
  BINANCE: 56,
  ARBITRUM: 42161,
  AVALANCHE: 43114,
  OPTIMISM: 10,
  FANTOM: 250,
  GNOSIS: 100,
  COINBASE: 8453,
} as const;

// Network metadata
const networks = {
  [NetworkEnum.ETHEREUM]: { name: "Ethereum", icon: "🔷" },
  [NetworkEnum.POLYGON]: { name: "Polygon", icon: "💜" },
  [NetworkEnum.ZKSYNC]: { name: "zkSync", icon: "⚡" },
  [NetworkEnum.BINANCE]: { name: "Binance", icon: "🟡" },
  [NetworkEnum.ARBITRUM]: { name: "Arbitrum", icon: "🔵" },
  [NetworkEnum.AVALANCHE]: { name: "Avalanche", icon: "❄️" },
  [NetworkEnum.OPTIMISM]: { name: "Optimism", icon: "🔴" },
  [NetworkEnum.FANTOM]: { name: "Fantom", icon: "👻" },
  [NetworkEnum.GNOSIS]: { name: "Gnosis", icon: "🦊" },
  [NetworkEnum.COINBASE]: { name: "Coinbase", icon: "🔵" },
};

const tokens = {
  USDC: {
    name: "USD Coin",
    symbol: "USDC",
    icon: "💵",
    decimals: 6,
  },
  USDT: {
    name: "Tether USD",
    symbol: "USDT",
    icon: "💵",
    decimals: 6,
  },
};

export default function SwapPage() {
  const [fromNetwork, setFromNetwork] = React.useState<number>(
    NetworkEnum.OPTIMISM
  );
  const [toNetwork, setToNetwork] = React.useState<number>(NetworkEnum.POLYGON);
  const [fromToken, setFromToken] = React.useState("USDC");
  const [toToken, setToToken] = React.useState("USDT");
  const [amount, setAmount] = React.useState("");

  const handleSwapNetworks = () => {
    setFromNetwork(toNetwork);
    setToNetwork(fromNetwork);
    setFromToken(toToken);
    setToToken(fromToken);
  };

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
              <Button variant="ghost" size="icon" className="text-neutral-400">
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
              <div className="rounded-lg border text-white border-neutral-800 bg-neutral-950 p-4">
                <div className="flex items-center gap-4">
                  <div className="flex-1">
                    <Input
                      type="number"
                      placeholder="0"
                      value={amount}
                      onChange={(e) => setAmount(e.target.value)}
                      className="border-0 bg-transparent text-2xl placeholder:text-neutral-600"
                    />
                  </div>
                  <div className="flex items-center gap-2">
                    <Select value={fromToken} onValueChange={setFromToken}>
                      <SelectTrigger className="w-[120px] border-0 bg-neutral-800">
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectGroup>
                          <SelectLabel>Tokens</SelectLabel>
                          {Object.entries(tokens).map(([symbol, token]) => (
                            <SelectItem key={symbol} value={symbol}>
                              {token.icon} {token.symbol}
                            </SelectItem>
                          ))}
                        </SelectGroup>
                      </SelectContent>
                    </Select>
                    <Lock className="h-4 w-4 text-neutral-400" />
                  </div>
                </div>
                <div className="mt-2 flex items-center justify-between text-sm">
                  <Select
                    value={fromNetwork.toString()}
                    onValueChange={(v) => setFromNetwork(Number(v))}
                  >
                    <SelectTrigger className="w-[140px] border-0 bg-transparent text-neutral-400">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectGroup>
                        <SelectLabel>Networks</SelectLabel>
                        {Object.entries(networks).map(([id, network]) => (
                          <SelectItem key={id} value={id}>
                            {network.icon} {network.name}
                          </SelectItem>
                        ))}
                      </SelectGroup>
                    </SelectContent>
                  </Select>
                  <span className="text-neutral-400">Balance: 0.00</span>
                </div>
              </div>
            </div>

            <div className="flex justify-center">
              <Button
                variant="ghost"
                size="icon"
                className="rounded-full bg-neutral-800 text-neutral-400"
                onClick={handleSwapNetworks}
              >
                <ArrowDown className="h-4 w-4" />
              </Button>
            </div>

            <div className="space-y-2">
              <Label className="text-sm text-neutral-400">You receive</Label>
              <div className="rounded-lg border border-neutral-800 bg-neutral-950 p-4">
                <div className="flex items-center gap-4">
                  <div className="flex-1">
                    <Input
                      type="number"
                      placeholder="0"
                      disabled
                      className="border-0 bg-transparent text-2xl placeholder:text-neutral-600"
                    />
                  </div>
                  <div className="flex items-center gap-2">
                    <Select value={toToken} onValueChange={setToToken}>
                      <SelectTrigger className="w-[120px] border-0 bg-neutral-800">
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectGroup>
                          <SelectLabel>Tokens</SelectLabel>
                          {Object.entries(tokens).map(([symbol, token]) => (
                            <SelectItem key={symbol} value={symbol}>
                              {token.icon} {token.symbol}
                            </SelectItem>
                          ))}
                        </SelectGroup>
                      </SelectContent>
                    </Select>
                    <Lock className="h-4 w-4 text-neutral-400" />
                  </div>
                </div>
                <div className="mt-2 flex items-center justify-between text-sm">
                  <Select
                    value={toNetwork.toString()}
                    onValueChange={(v) => setToNetwork(Number(v))}
                  >
                    <SelectTrigger className="w-[140px] border-0 bg-transparent text-neutral-400">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectGroup>
                        <SelectLabel>Networks</SelectLabel>
                        {Object.entries(networks).map(([id, network]) => (
                          <SelectItem key={id} value={id}>
                            {network.icon} {network.name}
                          </SelectItem>
                        ))}
                      </SelectGroup>
                    </SelectContent>
                  </Select>
                  <span className="text-neutral-400">Balance: 0.00</span>
                </div>
              </div>
            </div>

            <Button
              className="w-full bg-blue-600 hover:bg-blue-700"
              size="lg"
              disabled={!amount}
            >
              {amount ? "Review Swap" : "Enter an amount"}
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
