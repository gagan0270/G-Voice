import React from "react";

const HandyTextLogo: React.FC<{
  width?: number;
  height?: number;
  className?: string;
}> = ({ className }) => {
  return (
    <div className={`inline-flex items-center gap-1 select-none font-bold text-2xl tracking-tight text-ink ${className || ""}`}>
      <span>G-Voice</span>
    </div>
  );
};

export default HandyTextLogo;
