import React from "react";

interface MascotProps {
  /** Height in px. */
  size: number;
  /** Wave once on arrival, or high-five (re-key it to play again). */
  animation?: "wave" | "slap" | null;
}

/** G-Voice mascot/icon, optionally animated. */
export const Mascot: React.FC<MascotProps> = ({ size, animation = null }) => (
  <span
    style={{ width: size, height: size }}
    className={`relative inline-block select-none ${animation === "wave" ? "animate-bounce" : ""}`}
  >
    <img src="/icon.png" alt="G-Voice" className="w-full h-full object-contain" />
  </span>
);
