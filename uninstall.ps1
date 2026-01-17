<#
.SYNOPSIS
    ParyEmacs (AutoHotkey) Uninstaller
#>

# ==========================================
# [CONFIGURATION]
# ==========================================
$InstallDir = "$env:LOCALAPPDATA\ParyEmacs"
$StartupDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$ShortcutPath = "$StartupDir\ParyEmacs.lnk"
$ProcessName = "AutoHotkey64"

# ==========================================
# [UNINSTALLATION LOGIC]
# ==========================================
$ErrorActionPreference = "Continue"
Write-Host "Uninstalling ParyEmacs..." -ForegroundColor Yellow

# 1. Stop Process
Write-Host "Terminating AutoHotkey process..."
Stop-Process -Name $ProcessName -ErrorAction SilentlyContinue

# 2. Remove Startup Shortcut
if (Test-Path $ShortcutPath) {
    Write-Host "Removing Startup shortcut..."
    Remove-Item -Path $ShortcutPath -Force
}

# 3. Remove Files
if (Test-Path $InstallDir) {
    Write-Host "Removing installation directory: $InstallDir"
    Remove-Item -Path $InstallDir -Recurse -Force
}

Write-Host "`nUninstallation Complete." -ForegroundColor Green
Read-Host "Press Enter to exit..."

