"use client";

import { motion } from "framer-motion";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

interface MinimumBetStakeProps {
  onNext: () => void;
  updateFormData: (field: "minStake", value: string) => void;
  minStake: string;
}

const MinimumBetStake: React.FC<MinimumBetStakeProps> = ({
  onNext,
  updateFormData,
  minStake,
}) => {
  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -10 }}
      className="space-y-4"
    >
      <h2 className="text-lg font-medium bg-gradient-to-r from-blue-400 via-purple-500 to-blue-400 bg-clip-text text-transparent text-center">
        What will be the bet end time ?
      </h2>
      <div className="relative">
        <Input
          type="number"
          placeholder="5.00"
          className="bg-gray-800 border-gray-700 text-white placeholder:text-gray-400 pl-8"
          value={minStake}
          onChange={(e) => updateFormData("minStake", e.target.value)}
        />
        {/* <span className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">
          $
        </span> */}
      </div>
      <Button
        className="w-full bg-blue-600 hover:bg-blue-700 text-white"
        onClick={() => minStake && onNext()}
      >
        Continue
      </Button>
    </motion.div>
  );
};

export default MinimumBetStake;
