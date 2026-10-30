import React from "react";

const HandyHand: React.FC<{
  width?: number | string;
  height?: number | string;
  className?: string;
}> = ({ width, height, className = "" }) => (
  <img
    src="/icon.png"
    alt="G-Voice"
    width={width || 64}
    height={height || 64}
    className={`object-contain select-none ${className}`}
  />
);

export default HandyHand;
