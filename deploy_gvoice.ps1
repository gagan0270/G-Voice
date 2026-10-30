# G-Voice Deployment Script
# Author: Gagan V

$TargetDir = "C:\Users\gagan\Desktop\G-Voice"
$SourceExe = "src-tauri\target\release\g-voice.exe"
$SourceIco = "src-tauri\icons\icon.ico"
$SourceLibs = "src-tauri\transcribe-libs"
$SourceResources = "src-tauri\resources"

Write-Host "--- Stopping any running G-Voice instances ---" -ForegroundColor Cyan
Stop-Process -Name "G-Voice" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

Write-Host "--- Ensuring destination directory exists ---" -ForegroundColor Cyan
if (!(Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

Write-Host "--- Copying production executable ---" -ForegroundColor Cyan
if (Test-Path $SourceExe) {
    Copy-Item -Path $SourceExe -Destination "$TargetDir\G-Voice.exe" -Force
    Write-Host "G-Voice.exe updated successfully." -ForegroundColor Green
} else {
    Write-Host "Error: $SourceExe not found!" -ForegroundColor Red
    exit 1
}

Write-Host "--- Updating G-Voice icon ---" -ForegroundColor Cyan
Copy-Item -Path $SourceIco -Destination "$TargetDir\G-Voice.ico" -Force

Write-Host "--- Copying runtime DLLs and resources ---" -ForegroundColor Cyan
if (Test-Path $SourceLibs) {
    Copy-Item -Path "$SourceLibs\*.dll" -Destination $TargetDir -Force
}
if (Test-Path $SourceResources) {
    Copy-Item -Path $SourceResources -Destination $TargetDir -Recurse -Force
}

Write-Host "--- Creating Desktop Shortcut ---" -ForegroundColor Cyan
$WScriptShell = New-Object -ComObject WScript.Shell
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$Shortcut = $WScriptShell.CreateShortcut("$DesktopPath\G-Voice.lnk")
$Shortcut.TargetPath = "$TargetDir\G-Voice.exe"
$Shortcut.WorkingDirectory = $TargetDir
$Shortcut.Description = "G-Voice - Offline AI Voice Typing by Gagan V"
$Shortcut.IconLocation = "$TargetDir\G-Voice.ico"
$Shortcut.Save()
Write-Host "Desktop shortcut created: $DesktopPath\G-Voice.lnk" -ForegroundColor Green

Write-Host "--- Creating Windows Startup Shortcut ---" -ForegroundColor Cyan
$StartupPath = [Environment]::GetFolderPath("Startup")
$StartupShortcut = $WScriptShell.CreateShortcut("$StartupPath\G-Voice.lnk")
$StartupShortcut.TargetPath = "$TargetDir\G-Voice.exe"
$StartupShortcut.WorkingDirectory = $TargetDir
$StartupShortcut.Description = "G-Voice - Offline AI Voice Typing by Gagan V"
$StartupShortcut.IconLocation = "$TargetDir\G-Voice.ico"
$StartupShortcut.Save()
Write-Host "Startup shortcut created: $StartupPath\G-Voice.lnk" -ForegroundColor Green

# Remove legacy Handy shortcut if present
if (Test-Path "$DesktopPath\Handy.lnk") {
    Remove-Item "$DesktopPath\Handy.lnk" -Force
}
if (Test-Path "$StartupPath\Handy.lnk") {
    Remove-Item "$StartupPath\Handy.lnk" -Force
}

Write-Host "=== G-Voice Deployment Complete! ===" -ForegroundColor Green
