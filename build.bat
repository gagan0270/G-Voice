@echo off
title G-Voice - Automatic Setup and Builder
setlocal

echo Starting G-Voice Automated Builder...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_and_install.ps1"
if %errorlevel% neq 0 (
    echo.
    echo ========================================================
    echo [ERROR] The build process failed with exit code %errorlevel%.
    echo Please review the messages above for troubleshooting.
    echo ========================================================
    pause
    exit /b %errorlevel%
)

exit /b 0
