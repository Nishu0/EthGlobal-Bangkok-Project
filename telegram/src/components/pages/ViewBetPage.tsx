"use client";

import React, { useState } from "react";
import BetsList from "../BetsList";
import BetsFilter from "../BetsFilter";
import { Button } from "../ui/button";
import { Plus } from "lucide-react";
import { useTab } from "@/contexts/TabContext";

const BetsPage = () => {
  type TimeFilterKey = "All" | "1D" | "1W" | "1M" | "1Y";
  const [selectedTimeFilter, setSelectedTimeFilter] =
    useState<TimeFilterKey>("All");
  const { setActiveTab } = useTab();
  const [currentTab, setCurrentTab] = useState("ongoing");
  // Sample data - in production this would come from an API
  const bets = [
    {
      id: 1,
      date: "2024-02-06",
      question: "What percentage of votes gets Nikki Haley in New Jersey?",
      betAmount: 10.0,
      maxPayout: 228.67,
      answerChoice: "YES",
      txHash:
        "0xe157929b2bcccd07aeb2d3f43528f2f8d2705d6c770459fd928a2772843cf33d",
      time: "22:21:66",
      timeLeft: { days: 1, hours: 2, minutes: 26 },
      status: "Successful Placed",
      paymentMethod: "PayPal",
    },
    {
      id: 2,
      date: "2024-04-17",
      question: "What percentage of votes gets Nikki Haley in New Jersey?",
      betAmount: 1180.0,
      maxPayout: 2282.67,
      answerChoice: "YES",
      txHash:
        "0x3415e501986bcaa01a0c7db973b56f1ddbdccc82faff117d56e97a6fa653d73d",
      time: "22:21:66",
      timeLeft: { days: 1, hours: 2, minutes: 26 },
      status: "Successful Placed",
      paymentMethod: "PayPal",
    },
  ];

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

      <BetsList
        currentTab={currentTab}
        selectedTimeFilter={selectedTimeFilter}
        bets={bets}
      />
    </div>
  );
};

export default BetsPage;
