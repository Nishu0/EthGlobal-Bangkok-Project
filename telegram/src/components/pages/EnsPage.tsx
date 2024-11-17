"use client";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { useState, useEffect } from "react";
import Image from "next/image";

interface Domain {
  id: string;
  name: string;
  truncatedName: string;
  expiryDate: {
    date: string;
  };
}

interface ChainOption {
  id: string;
  name: string;
  icon: string;
}

export default function ENSPage() {
  const [network, setNetwork] = useState("sepolia");
  const [domains, setDomains] = useState<Domain[]>([]);
  const [selectedChain, setSelectedChain] = useState<string | null>(null);

  const chains: ChainOption[] = [
    { id: "base", name: "Base", icon: "https://durin.dev/base.svg" },
    { id: "scroll", name: "Scroll", icon: "https://durin.dev/scroll.svg" },
    {
      id: "optimism",
      name: "Optimism",
      icon: "https://durin.dev/optimism.svg",
    },
    {
      id: "arbitrum",
      name: "Arbitrum",
      icon: "https://durin.dev/arbitrum.svg",
    },
    { id: "linea", name: "Linea", icon: "https://durin.dev/linea.svg" },
  ];

  useEffect(() => {
    const fetchDomains = async () => {
      try {
        const response = await fetch(
          `https://durin.dev/api/get-domains?address=0x8cB4C5336db41B4701A001574749A043Fa2fCB7A&network=${network}`
        );
        const data = await response.json();
        setDomains(data);
      } catch (error) {
        console.error("Error fetching domains:", error);
      }
    };

    fetchDomains();
  }, [network]);

  return (
    <Card className="w-full max-w-2xl mx-auto">
      <CardHeader>
        <CardTitle>Choose Name & Chain</CardTitle>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="space-y-4">
          <div className="flex justify-between items-center">
            <h3 className="text-lg font-medium">ENS Name</h3>
            <Tabs defaultValue="sepolia" onValueChange={setNetwork}>
              <TabsList>
                <TabsTrigger value="sepolia">Sepolia</TabsTrigger>
                <TabsTrigger value="mainnet">Mainnet</TabsTrigger>
              </TabsList>
            </Tabs>
          </div>
          <Select>
            <SelectTrigger>
              <SelectValue placeholder="Connect wallet to see your ENS names" />
            </SelectTrigger>
            <SelectContent>
              {domains.map((domain) => (
                <SelectItem key={domain.id} value={domain.name}>
                  {domain.truncatedName}
                  <span className="text-muted-foreground ml-2">
                    (Expires:{" "}
                    {new Date(domain.expiryDate.date).toLocaleDateString()})
                  </span>
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          <p className="text-sm text-muted-foreground">
            Choose between Sepolia & Mainnet ENS name resolution.
          </p>
        </div>

        <div className="space-y-4">
          <div className="flex justify-between items-center">
            <h3 className="text-lg font-medium">Chain</h3>
            <Tabs defaultValue="sepolia">
              <TabsList>
                <TabsTrigger value="sepolia">Sepolia</TabsTrigger>
                <TabsTrigger value="mainnet">Mainnet</TabsTrigger>
              </TabsList>
            </Tabs>
          </div>
          <div className="grid grid-cols-5 gap-4">
            {chains.map((chain) => (
              <Button
                key={chain.id}
                variant={selectedChain === chain.id ? "default" : "outline"}
                className="flex flex-col items-center p-4 h-auto"
                onClick={() => setSelectedChain(chain.id)}
              >
                <Image
                  src={chain.icon}
                  alt={`${chain.name} icon`}
                  width={32}
                  height={32}
                  className="mb-2"
                />
                <span className="text-xs">{chain.name}</span>
              </Button>
            ))}
          </div>
          <p className="text-sm text-muted-foreground">
            Pick a chain where the registry contract will live. The registry
            contract tracks ownership and stores text records.
          </p>
        </div>

        <Button className="w-full" size="lg" disabled={!selectedChain}>
          Register for your L2
        </Button>
      </CardContent>
    </Card>
  );
}
