import React from "react";

const HandyMascot: React.FC<{ className?: string }> = ({ className = "" }) => {
  return (
    <img
      src="/icon.png"
      alt="G-Voice"
      className={`object-contain select-none ${className}`}
    />
  );
};

export default HandyMascot;
