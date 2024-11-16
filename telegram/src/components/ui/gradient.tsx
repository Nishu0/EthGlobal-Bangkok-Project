import React from "react";

export const Gradient = ({ className, ...props }: { className?: string }) => {
  return (
    <div
      className={`absolute inset-0 -z-10 bg-gradient-to-br from-sky-200 via-blue-200 to-transparent blur-2xl ${className}`}
      {...props}
    />
  );
};
