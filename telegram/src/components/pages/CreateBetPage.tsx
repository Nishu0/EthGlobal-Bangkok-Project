"use client";

import { useState } from "react";
import { AnimatePresence } from "framer-motion";

import AudienceSelection from "../create-bet/AudienceSelection";
import BettingQuestion from "../create-bet/BettingQuestion";
import AddDescription from "../create-bet/AddDescription";
import { Icons } from "@/components/icons";
import { useWriteContract } from "wagmi";
import { useDynamicContext } from "@dynamic-labs/sdk-react-core";
import ReviewPage from "../create-bet/ReviewSection";

interface FormData {
  audience: string;
  description: string;
  minStake: number;
  duration: number;
  hasDescription: boolean;
  descriptionText?: string;
}

const CreateBetPage: React.FC = () => {
  const { primaryWallet } = useDynamicContext();
  const [step, setStep] = useState<number>(1);
  const [formData, setFormData] = useState<FormData>({
    audience: "",
    description: "",
    minStake: 80000,
    duration: 1735689600 - Date.now() / 1000,
    hasDescription: false,
  });

  const updateFormData = (field: keyof FormData, value: string | boolean) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
  };

  const goBack = () => {
    if (step > 1) setStep(step - 1);
  };

  const renderStep = () => {
    switch (step) {
      case 1:
        return (
          <AudienceSelection
            onNext={() => setStep(2)}
            updateFormData={updateFormData}
          />
        );
      case 2:
        return (
          <BettingQuestion
            onNext={() => setStep(3)}
            updateFormData={updateFormData}
            description={formData.description}
          />
        );
      case 3:
        return (
          <AddDescription
            onNext={() => setStep(4)}
            updateFormData={updateFormData}
          />
        );
      case 4:
        return <ReviewPage formData={formData} />;
      default:
        return null;
    }
  };

  return (
    <div className="min-h-screen bg-zinc-900/90 text-white">
      {/* Header with back button and progress bar */}
      <div className="fixed top-0 left-0 right-0 bg-zinc-900/90 backdrop-blur-lg z-10">
        <div className="flex items-center p-4">
          {step > 1 && (
            <button
              onClick={goBack}
              className="p-2 -ml-2 text-gray-400 hover:text-white"
            >
              <Icons.ChevronLeft className="w-6 h-6" />
            </button>
          )}
          <div className="flex-1 text-center font-medium">Create Bet</div>
          <div className="w-10" /> {/* Spacer for alignment */}
        </div>
        <div className="h-1 bg-gray-800">
          <div
            className="h-full bg-blue-600 transition-all duration-300"
            style={{ width: `${(step / 4) * 100}%` }}
          />
        </div>
      </div>

      {/* Form content */}
      <div className="pt-20 p-4">
        <AnimatePresence mode="wait">{renderStep()}</AnimatePresence>
      </div>
    </div>
  );
};

export default CreateBetPage;
