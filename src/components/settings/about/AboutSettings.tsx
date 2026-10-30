import React, { useState, useEffect } from "react";
import { useTranslation } from "react-i18next";
import { getVersion } from "@tauri-apps/api/app";
import { SettingsGroup } from "../../ui/SettingsGroup";
import { SettingContainer } from "../../ui/SettingContainer";
import { AppDataDirectory } from "../AppDataDirectory";
import { AppLanguageSelector } from "../AppLanguageSelector";
import { ShowWhatsNewOnUpdate } from "../ShowWhatsNewOnUpdate";
import { ThemeSelector } from "../ThemeSelector";
import { LogDirectory } from "../debug";

export const AboutSettings: React.FC = () => {
  const { t } = useTranslation();
  const [version, setVersion] = useState("");

  useEffect(() => {
    const fetchVersion = async () => {
      try {
        const appVersion = await getVersion();
        setVersion(appVersion);
      } catch (error) {
        console.error("Failed to get app version:", error);
        setVersion("0.9.8");
      }
    };

    fetchVersion();
  }, []);

  return (
    <div className="max-w-3xl w-full mx-auto space-y-6">
      <SettingsGroup title={t("settings.about.title")}>
        <div className="flex items-center gap-4 p-4 rounded-xl bg-bg-surface-secondary/40 border border-border-subtle mb-4">
          <img src="/icon.png" alt="G-Voice" className="w-14 h-14 object-contain rounded-lg" />
          <div className="flex flex-col">
            <h2 className="text-xl font-bold tracking-tight text-ink">G-Voice</h2>
            <p className="text-xs text-ink-3">Private, 100% Offline AI Voice Typing</p>
            <p className="text-xs font-medium text-primary mt-1">Created & Maintained by Gagan V</p>
          </div>
        </div>

        <AppLanguageSelector descriptionMode="tooltip" grouped={true} />
        <ThemeSelector descriptionMode="tooltip" grouped={true} />
        <SettingContainer
          title={t("settings.about.version.title")}
          description={t("settings.about.version.description")}
          grouped={true}
        >
          {/* eslint-disable-next-line i18next/no-literal-string */}
          <span className="text-sm font-mono font-semibold">v{version || "0.9.8"}</span>
        </SettingContainer>

        <SettingContainer
          title="Developer"
          description="Creator and maintainer of G-Voice"
          grouped={true}
        >
          <span className="text-sm font-semibold text-primary">Gagan V</span>
        </SettingContainer>

        <ShowWhatsNewOnUpdate descriptionMode="tooltip" grouped={true} />
        <AppDataDirectory descriptionMode="tooltip" grouped={true} />
        <LogDirectory grouped={true} />
      </SettingsGroup>

      <SettingsGroup title={t("settings.about.acknowledgments.title")}>
        <SettingContainer
          title="Engine & Architecture"
          description="Local offline neural inference powered by whisper.cpp and ggml."
          grouped={true}
          layout="stacked"
        >
          <div className="text-sm text-ink-3">
            G-Voice utilizes high-performance local inference via ggml and whisper.cpp with native AVX2 and Alder Lake CPU acceleration.
          </div>
        </SettingContainer>
      </SettingsGroup>
    </div>
  );
};
