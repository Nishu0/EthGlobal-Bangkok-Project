import React from "react";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
} from "@/components/ui/select";
import { Filter } from "lucide-react";

type TimeFilterKey = "All" | "1D" | "1W" | "1M" | "1Y";

interface BetsFilterProps {
  currentTab: string;
  setCurrentTab: (tab: string) => void;
  selectedTimeFilter: TimeFilterKey; // Update this type
  setSelectedTimeFilter: (filter: TimeFilterKey) => void; // And this type
}

const BetsFilter: React.FC<BetsFilterProps> = ({
  currentTab,
  setCurrentTab,
  selectedTimeFilter,
  setSelectedTimeFilter,
}) => {
  // Mapping values to labels for display
  const timeFilters = {
    All: "All Time",
    "1D": "Today",
    "1W": "This Week",
    "1M": "This Month",
    "1Y": "This Year",
  };

  return (
    <div className="space-y-4 mb-6">
      <Tabs defaultValue="ongoing" className="w-full">
        <TabsList className="grid grid-cols-3 bg-[#101010] rounded-md">
          {["ongoing", "upcoming", "history"].map((tab) => (
            <TabsTrigger
              key={tab}
              value={tab}
              onClick={() => setCurrentTab(tab)}
              className={`${
                currentTab === tab
                  ? "shine-effect data-[state=active]:bg-gray-800 data-[state=active]:text-blue-300 relative"
                  : "text-gray-400"
              } py-2`}
            >
              {tab.charAt(0).toUpperCase() + tab.slice(1)}
            </TabsTrigger>
          ))}
        </TabsList>
      </Tabs>
      <Select value={selectedTimeFilter} onValueChange={setSelectedTimeFilter}>
        <SelectTrigger className="bg-gray-800 rounded-xl px-3 py-2 flex items-center space-x-2 text-white w-fit">
          <Filter />
          {/* Display label for the selected value */}
          <span>{selectedTimeFilter}</span>
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="All">All Time</SelectItem>
          <SelectItem value="1D">Today</SelectItem>
          <SelectItem value="1W">This Week</SelectItem>
          <SelectItem value="1M">This Month</SelectItem>
          <SelectItem value="1Y">This Year</SelectItem>
        </SelectContent>
      </Select>
    </div>
  );
};

export default BetsFilter;
