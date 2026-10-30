import React from "react";
import logoImg from "../../assets/logo.png";

export const GVoiceLogo: React.FC<{
  className?: string;
  width?: number;
  height?: number;
}> = ({ className, width = 120 }) => {
  return (
    <div className={`flex flex-col items-center gap-1.5 ${className || ""}`}>
      <img
        src={logoImg}
        alt="G-Voice Logo"
        className="w-10 h-10 object-contain drop-shadow"
      />
      <span className="text-sm font-black tracking-widest bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500 bg-clip-text text-transparent uppercase select-none">
        G-VOICE
      </span>
    </div>
  );
};

export const GVoiceIcon: React.FC<{
  width?: number | string;
  height?: number | string;
  className?: string;
}> = ({ width = 20, height = 20, className }) => {
  return (
    <img
      src={logoImg}
      alt="G-Voice"
      width={width}
      height={height}
      className={`object-contain ${className || ""}`}
    />
  );
};

export default GVoiceLogo;
