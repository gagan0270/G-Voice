# G-Voice - Automatic Dependency Checker, Installer and Production Builder
# Author: Gagan V
# License: MIT

$ErrorActionPreference = "Stop"

function Print-Header {
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "                    G-Voice Setup and Builder                         " -ForegroundColor Cyan
    Write-Host "                Created and Developed by Gagan V                      " -ForegroundColor White
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Refresh-Path {
    $machinePath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    $env:PATH = "$userPath;$machinePath;$env:PATH"
    
    $cargoBin = Join-Path $env:USERPROFILE ".cargo\bin"
    if ((Test-Path $cargoBin) -and ($env:PATH -notlike "*$cargoBin*")) {
        $env:PATH = "$cargoBin;$env:PATH"
    }
}

Print-Header

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptDir

Write-Host "[1/6] Checking CMake..." -ForegroundColor Yellow

$cmakeFound = $false
try {
    $cmakeVer = (cmake --version 2>$null | Select-Object -First 1)
    if ($cmakeVer) {
        Write-Host "  [OK] CMake detected: $cmakeVer" -ForegroundColor Green
        $cmakeFound = $true
    }
} catch {
    $cmakeFound = $false
}

if (-not $cmakeFound) {
    $knownCMakePaths = @(
        "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin",
        "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin",
        "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin",
        "C:\Program Files\CMake\bin"
    )

    foreach ($p in $knownCMakePaths) {
        if (Test-Path "$p\cmake.exe") {
            $env:PATH = "$p;$env:PATH"
            Write-Host "  [OK] Found CMake in: $p" -ForegroundColor Green
            $cmakeFound = $true
            break
        }
    }
}

if (-not $cmakeFound) {
    Write-Host "  [!] CMake not found. Attempting automatic installation via winget..." -ForegroundColor Yellow
    try {
        winget install --id Kitware.CMake -e --silent --accept-source-agreements --accept-package-agreements
        Refresh-Path
        $cmakeFound = $true
        Write-Host "  [OK] CMake installed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "  [WARN] Automatic CMake installation failed." -ForegroundColor Red
        Write-Host "  Please install CMake from: https://cmake.org/download/" -ForegroundColor Yellow
    }
}

Write-Host "`n[2/6] Checking Node.js and npm..." -ForegroundColor Yellow
$nodeFound = $false
try {
    $nodeVer = (node -v 2>$null)
    if ($nodeVer) {
        Write-Host "  [OK] Node.js detected: $nodeVer" -ForegroundColor Green
        $nodeFound = $true
    }
} catch {
    $nodeFound = $false
}

if (-not $nodeFound) {
    Write-Host "  [!] Node.js not found. Attempting automatic installation via winget..." -ForegroundColor Yellow
    try {
        winget install --id OpenJS.NodeJS.LTS -e --silent --accept-source-agreements --accept-package-agreements
        Refresh-Path
        $nodeFound = $true
        Write-Host "  [OK] Node.js installed!" -ForegroundColor Green
    } catch {
        Write-Host "  [ERROR] Node.js is required to build G-Voice." -ForegroundColor Red
        Write-Host "  Please download and install Node.js (LTS) from: https://nodejs.org/" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "`n[3/6] Checking Rust and Cargo..." -ForegroundColor Yellow
Refresh-Path
$cargoFound = $false
try {
    $cargoVer = (cargo --version 2>$null)
    if ($cargoVer) {
        Write-Host "  [OK] Cargo detected: $cargoVer" -ForegroundColor Green
        $cargoFound = $true
    }
} catch {
    $cargoFound = $false
}

if (-not $cargoFound) {
    Write-Host "  [!] Rust/Cargo not found. Attempting automatic installation via winget..." -ForegroundColor Yellow
    try {
        winget install --id Rustlang.Rustup -e --silent --accept-source-agreements --accept-package-agreements
        Refresh-Path
        $cargoFound = $true
        Write-Host "  [OK] Rust installed!" -ForegroundColor Green
    } catch {
        Write-Host "  [ERROR] Rust toolchain is required." -ForegroundColor Red
        Write-Host "  Please install Rust from: https://rustup.rs/" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "`n[4/6] Installing npm dependencies..." -ForegroundColor Yellow
try {
    cmd.exe /c "npm install"
    if ($LASTEXITCODE -ne 0) { throw "npm install returned error code $LASTEXITCODE" }
    Write-Host "  [OK] Dependencies ready." -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] Failed to install npm packages: $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n[5/6] Building G-Voice Production Executable..." -ForegroundColor Yellow
try {
    cmd.exe /c "npm run build"
    if ($LASTEXITCODE -ne 0) { throw "Frontend build failed" }
    Write-Host "  [OK] Frontend bundled." -ForegroundColor Green

    Write-Host "  [*] Compiling standalone release binary..." -ForegroundColor Cyan
    cmd.exe /c "npx tauri build --no-bundle --ignore-version-mismatches"
    if ($LASTEXITCODE -ne 0) { throw "Tauri compilation failed" }
    Write-Host "  [OK] Standalone binary compiled successfully!" -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] Compilation failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n[6/6] Deploying G-Voice to Desktop..." -ForegroundColor Yellow
try {
    $DesktopFolder = [Environment]::GetFolderPath("Desktop")
    $TargetAppDir = Join-Path $DesktopFolder "G-Voice"
    $BuiltExe = Join-Path $ScriptDir "src-tauri\target\release\g-voice.exe"
    $SourceIco = Join-Path $ScriptDir "src-tauri\icons\icon.ico"
    $SourceLibs = Join-Path $ScriptDir "src-tauri\transcribe-libs"
    $SourceResources = Join-Path $ScriptDir "src-tauri\resources"

    Stop-Process -Name "G-Voice" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1

    if (-not (Test-Path $TargetAppDir)) {
        New-Item -ItemType Directory -Path $TargetAppDir -Force | Out-Null
    }

    Copy-Item -Path $BuiltExe -Destination "$TargetAppDir\G-Voice.exe" -Force
    Copy-Item -Path $SourceIco -Destination "$TargetAppDir\G-Voice.ico" -Force
    if (Test-Path $SourceLibs) {
        Copy-Item -Path "$SourceLibs\*.dll" -Destination $TargetAppDir -Force
    }
    if (Test-Path $SourceResources) {
        Copy-Item -Path $SourceResources -Destination $TargetAppDir -Recurse -Force
    }

    $WScriptShell = New-Object -ComObject WScript.Shell
    $DesktopShortcut = $WScriptShell.CreateShortcut("$DesktopFolder\G-Voice.lnk")
    $DesktopShortcut.TargetPath = "$TargetAppDir\G-Voice.exe"
    $DesktopShortcut.WorkingDirectory = $TargetAppDir
    $DesktopShortcut.Description = "G-Voice - Offline AI Voice Typing by Gagan V"
    $DesktopShortcut.IconLocation = "$TargetAppDir\G-Voice.ico"
    $DesktopShortcut.Save()

    $StartupFolder = [Environment]::GetFolderPath("Startup")
    $StartupShortcut = $WScriptShell.CreateShortcut("$StartupFolder\G-Voice.lnk")
    $StartupShortcut.TargetPath = "$TargetAppDir\G-Voice.exe"
    $StartupShortcut.WorkingDirectory = $TargetAppDir
    $StartupShortcut.Description = "G-Voice - Offline AI Voice Typing by Gagan V"
    $StartupShortcut.IconLocation = "$TargetAppDir\G-Voice.ico"
    $StartupShortcut.Save()

    Write-Host "  [OK] Application deployed to: $TargetAppDir" -ForegroundColor Green
    Write-Host "  [OK] Desktop shortcut created: $DesktopFolder\G-Voice.lnk" -ForegroundColor Green
    Write-Host "  [OK] Startup shortcut created in: $StartupFolder\G-Voice.lnk" -ForegroundColor Green
} catch {
    Write-Host "  [WARN] Deployment encountered an issue: $_" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Green
Write-Host "              SUCCESS! G-VOICE IS READY ON YOUR DESKTOP!              " -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Green
Write-Host "  Executable : $DesktopFolder\G-Voice\G-Voice.exe" -ForegroundColor White
Write-Host "  Shortcut   : Double-click 'G-Voice' on your Desktop" -ForegroundColor White
Write-Host "  Hotkeys    : Alt + C or Ctrl + Space" -ForegroundColor White
Write-Host "======================================================================" -ForegroundColor Green
Write-Host ""
