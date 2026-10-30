# G-Voice 🕊️

> **The Fastest, 100% Private Offline AI Voice Typing for Windows**  
> *Created & Developed by **Gagan V***

---

## 🌟 What is G-Voice?

**G-Voice** is a modern, lightweight, and ultra-fast desktop voice typing assistant for Windows. It lets you speak directly into **any application**—including VS Code, Google Chrome, Microsoft Word, Discord, Notepad, WhatsApp, and Slack—with real-time transcription that types right at your text cursor.

Unlike other voice typing tools, **G-Voice runs 100% offline on your device**:
- 🔒 **Zero Cloud APIs**: No audio ever leaves your computer.
- ⚡ **Real-Time Streaming**: Words appear on screen in under 150 milliseconds.
- 🌐 **Kannada & Multilingual Support**: High-accuracy dictation for Kannada (ಕನ್ನಡ) and English.
- 🪶 **Ultra Lightweight**: Sits quietly in your system tray using only ~45 MB RAM.
- 💸 **100% Free & Open**: No subscriptions, no telemetry, no tracking.

---

## 🚀 Key Features

| Feature | Description |
| :--- | :--- |
| **Instant Streaming ASR** | Powered by **Parakeet Unified 0.6B**, transcribing words in real time as you speak. |
| **Kannada & 90+ Languages** | Powered by **Whisper Base Q8_0**, enabling fluent dictation for Kannada and English. |
| **Universal Shortcut** | Press **`Alt + C`** (or **`Ctrl + Space`**) anywhere in Windows to start dictating. |
| **Zero Cold-Start Lag** | Models stay resident in memory (`model_unload_timeout: never`) for immediate response. |
| **Native CPU Acceleration** | Optimized with AVX2 and Alder Lake CPU instructions for maximum performance. |
| **System Tray & Autostart** | Sits in your system tray and starts automatically with Windows. |
| **Single Standalone App** | Fully self-contained desktop executable with zero external runtime dependencies. |

---

## 📦 For End Users: How to Run

You don't need to install Python, Rust, or any developer tools!

1. Download **`G-Voice-v0.9.8-Windows-x64.zip`** from [Releases](https://github.com/gagan0270/G-Voice/releases).
2. Extract the folder anywhere on your PC (e.g. `C:\Users\<You>\Desktop\G-Voice`).
3. Double-click **`G-Voice.exe`** to launch!

### 🧙‍♂️ First-Time Setup Wizard (Automatic)
When you launch G-Voice for the first time:
1. **Choose Your Spoken Language**: Select your primary language (e.g., English, Kannada, Hindi, Spanish, etc.).
2. **Automatic Smart Model Recommendation**: G-Voice automatically selects the best model for your language:
   - **English**: Parakeet Unified 0.6B (Extreme streaming speed, <150ms).
   - **Kannada & Multilingual**: Whisper Base Q8_0 (High accuracy multilingual).
3. **1-Click Download**: The model downloads directly inside the app with a live progress bar.
4. **Shortcut Setup**: Confirm your global shortcut (`Alt + C` or `Ctrl + Space`).
5. **Start Dictating**: You're all set! Click anywhere and start talking.

---

## 🎯 How to Use (3 Simple Steps)

### Step 1: Launch G-Voice
Launch **G-Voice**. The colorful bird icon appears in your Windows system tray (bottom-right near the clock).

### Step 2: Place Your Cursor
Click anywhere you want to type—in a browser search bar, code editor, email composer, or document.

### Step 3: Speak!
Press your global shortcut:
- **`Alt + C`** (or **`Ctrl + Space`**)
- Speak naturally into your microphone.
- Your words are automatically transcribed and pasted right where your cursor is!

---

## ⌨️ Shortcut Modes

You can customize how your shortcut works in **Settings → General → Shortcut Behavior**:

- **Auto Mode (Default & Recommended)**:  
  - *Hold & Speak*: Hold down the shortcut, speak, and release to paste.  
  - *Tap & Speak*: Tap once to start dictating, speak, then tap again to paste.
- **Hold Mode (Push-to-Talk)**:  
  - Dictates only while the keys are held down.
- **Toggle Mode**:  
  - Tap once to start recording, tap again to finish.

---

## 🧠 Supported AI Models

G-Voice includes built-in support for high-performance offline models:

| Model | Size | Best For | Speed | Accuracy |
| :--- | :---: | :--- | :---: | :---: |
| **Parakeet Unified 0.6B Q8_0** | 731 MB | English (Real-Time Streaming) | ⚡ Extreme (<150ms) | ⭐⭐⭐⭐⭐ (98.5%) |
| **Whisper Base Q8_0** | 84 MB | Kannada (ಕನ್ನಡ), English & Multilingual | ⚡ Very Fast (<300ms) | ⭐⭐⭐⭐ (94.0%) |

---

## 💻 For Developers: Building from Source

If you want to modify or contribute to G-Voice:

### Prerequisites:
- **Node.js** (v18 or higher)
- **Rust & Cargo** (`https://rustup.rs/`)
- **CMake** (included with Visual Studio C++ Build Tools)

### One-Click Build:
Simply double-click **`build.bat`** in the repository root, or run:

```cmd
git clone https://github.com/gagan0270/G-Voice.git
cd G-Voice
npm install
npm run build
npx tauri build --no-bundle
```

The script will automatically:
1. Install frontend packages (`npm install`)
2. Build the React UI (`npm run build`)
3. Compile the standalone release executable (`npx tauri build --no-bundle`)
4. Output the production binary to `C:\Users\gagan\Desktop\G-Voice\G-Voice.exe`

---

## 📁 Project Structure

```text
VOICE/
├── Handy-main/
│   ├── src/                  # React + TypeScript frontend
│   │   ├── components/       # Settings, Onboarding, Overlays
│   │   ├── i18n/             # 26 localized translations
│   │   └── assets/           # App logos & bird icons
│   ├── src-tauri/            # Rust Tauri v2 core
│   │   ├── src/              # Audio capture, model inference, shortcuts
│   │   ├── icons/            # Multi-resolution bird icons (.ico, .png)
│   │   ├── resources/        # Default settings, sounds, tray icons
│   │   └── transcribe-libs/  # Prebuilt AVX2 / Alder Lake ggml DLLs
│   └── package.json          # Node dependencies and scripts
└── README.md                 # Documentation
```

---

## 👤 Author & Credits

- **Developer & Maintainer**: **Gagan V**
- **Inference Engine**: Local CPU neural inference via [whisper.cpp](https://github.com/ggerganov/whisper.cpp) & [ggml](https://github.com/ggerganov/ggml).
- **License**: MIT License

---

*Enjoy effortless, private voice typing with G-Voice!* 🕊️
