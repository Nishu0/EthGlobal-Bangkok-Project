import { useState } from "react";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";

interface AddDescriptionProps {
  onNext: () => void;
  updateFormData: (
    field: "hasDescription" | "descriptionText",
    value: boolean | string
  ) => void;
}

const AddDescription: React.FC<AddDescriptionProps> = ({
  onNext,
  updateFormData,
}) => {
  const [showTextarea, setShowTextarea] = useState(false);
  const [descriptionText, setDescriptionText] = useState("");

  const handleYesClick = () => {
    setShowTextarea(true);
    updateFormData("hasDescription", true);
  };

  const handleNoClick = () => {
    updateFormData("hasDescription", false);
    onNext();
  };

  const handleTextareaSubmit = () => {
    updateFormData("descriptionText", descriptionText);
    onNext();
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -10 }}
      className="space-y-4"
    >
      <h2 className="text-lg font-medium bg-gradient-to-r from-blue-400 via-purple-500 to-blue-400 bg-clip-text text-transparent text-center">
        Do you want to add a description?
      </h2>
      <div className="space-y-2">
        <Button
          className="w-full p-4 text-left rounded-lg bg-gray-800 hover:bg-gray-700 transition-colors"
          onClick={handleYesClick}
        >
          Yes
        </Button>
        <Button
          className="w-full p-4 text-left rounded-lg bg-gray-800 hover:bg-gray-700 transition-colors"
          onClick={handleNoClick}
        >
          No
        </Button>
      </div>

      {showTextarea && (
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -10 }}
          className="space-y-4 mt-4"
        >
          <Textarea
            placeholder="Write your description..."
            className="bg-gray-800 border-gray-700 text-white placeholder:text-gray-400"
            value={descriptionText}
            onChange={(e) => setDescriptionText(e.target.value)}
          />
          <Button
            className="w-full bg-blue-600 hover:bg-blue-700 text-white"
            onClick={handleTextareaSubmit}
          >
            Preview
          </Button>
        </motion.div>
      )}
    </motion.div>
  );
};

export default AddDescription;
