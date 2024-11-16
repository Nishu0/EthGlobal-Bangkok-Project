"use client";

import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";

interface AudienceSelectionProps {
  onNext: () => void;
  updateFormData: (field: "audience", value: string) => void;
}

const AudienceSelection: React.FC<AudienceSelectionProps> = ({
  onNext,
  updateFormData,
}) => {
  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -10 }}
      className="space-y-4"
    >
      <h2 className="text-lg font-medium bg-gradient-to-r from-blue-400 via-purple-500 to-blue-400 bg-clip-text text-transparent text-center">
        For whom do you create a Bet for?
      </h2>
      <div className="space-y-2">
        <Button
          className="w-full p-4 text-left rounded-lg bg-gray-800 hover:bg-gray-700 transition-colors"
          onClick={() => {
            updateFormData("audience", "everyone");
            onNext();
          }}
        >
          Everyone
        </Button>
        <Button
          className="w-full p-4 text-left rounded-lg bg-gray-800 hover:bg-gray-700 transition-colors"
          onClick={() => {
            updateFormData("audience", "friends");
            onNext();
          }}
        >
          Just Friends
        </Button>
      </div>
    </motion.div>
  );
};

export default AudienceSelection;
