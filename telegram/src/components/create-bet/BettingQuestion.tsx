"use client";

import { motion } from "framer-motion";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

interface BettingQuestionProps {
  onNext: () => void;
  updateFormData: (field: "description", value: string) => void;
  description: string;
}

const BettingQuestion: React.FC<BettingQuestionProps> = ({
  onNext,
  updateFormData,
  description,
}) => {
  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -10 }}
      className="space-y-4"
    >
      <h2 className="text-lg font-medium bg-gradient-to-r from-blue-400 via-purple-500 to-blue-400 bg-clip-text text-transparent text-center">
        Write a short betting question...
      </h2>
      <Input
        placeholder="Enter your question"
        className="bg-gray-800 border-gray-700 text-white placeholder:text-gray-400"
        value={description}
        onChange={(e) => updateFormData("description", e.target.value)}
      />
      <Button
        className="w-full bg-blue-600 hover:bg-blue-700 text-white"
        onClick={() => description && onNext()}
      >
        Continue
      </Button>
    </motion.div>
  );
};

export default BettingQuestion;
