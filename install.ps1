<#
.SYNOPSIS
    ParyEmacs (AutoHotkey) User-Level Installer
    
.DESCRIPTION
    Downloads AutoHotkey exe/script to LocalAppData and sets up Startup shortcut.
    No Administrator privileges required.
#>

# ==========================================
# [CONFIGURATION]
# ==========================================
# 請修改這裡：指向您 GitHub 放 exe 和 ahk 的 "Raw" 連結路徑
# 建議使用 raw.githubusercontent.com 格式，比 github.io 穩定 (無快取延遲)
$BaseUrl = "https://github.com/perrier8wu/paryemacs/raw/main"

# 檔案名稱
$ExeName = "AutoHotkey64.exe"
$ScriptName = "AutoHotkey64.ahk"

# 安裝目標 (使用者個人資料夾，無需 Admin)
$InstallDir = "$env:LOCALAPPDATA\ParyEmacs"

# Windows 啟動資料夾路徑
$StartupDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$ShortcutPath = "$StartupDir\ParyEmacs.lnk"

# ==========================================
# [INSTALLATION LOGIC]
# ==========================================
$ErrorActionPreference = "Stop"
Write-Host "Starting ParyEmacs Installation..." -ForegroundColor Cyan

# 1. Stop existing process if running
Write-Host "Checking for running instances..."
$ProcessName = [io.path]::GetFileNameWithoutExtension($ExeName)
Stop-Process -Name $ProcessName -ErrorAction SilentlyContinue
Stop-Process -Name "AutoHotkey64" -ErrorAction SilentlyContinue

# 2. Create Installation Directory
if (-not (Test-Path $InstallDir)) {
    Write-Host "Creating directory: $InstallDir"
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# 3. Download Files
Write-Host "Downloading files..."

try {
    # Download EXE
    Write-Host " - Fetching $ExeName..."
    Invoke-RestMethod -Uri "$BaseUrl/$ExeName" -OutFile "$InstallDir\$ExeName"

    # Download AHK Script
    Write-Host " - Fetching $ScriptName..."
    Invoke-RestMethod -Uri "$BaseUrl/$ScriptName" -OutFile "$InstallDir\$ScriptName"
}
catch {
    Write-Error "Download failed. Please check the URL or network connection."
    Write-Error "Error Details: $_"
    Read-Host "Press Enter to exit..."; Exit
}

# 4. Create Startup Shortcut
Write-Host "Creating Startup Shortcut..."
try {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    
    # Target: The EXE
    $Shortcut.TargetPath = "$InstallDir\$ExeName"
    
    # Arguments: Pass the script path explicitly
    $Shortcut.Arguments = "`"$InstallDir\$ScriptName`""
    
    # Working Directory: Important for AHK to find relative files
    $Shortcut.WorkingDirectory = $InstallDir
    
    $Shortcut.Description = "ParyEmacs AutoHotkey Script"
    $Shortcut.Save()
    
    Write-Host "Shortcut created at: $ShortcutPath" -ForegroundColor Green
}
catch {
    Write-Error "Failed to create shortcut: $_"
    Read-Host "Press Enter to exit..."; Exit
}

# 5. Launch Immediately
Write-Host "Launching ParyEmacs..."
Start-Process -FilePath "$InstallDir\$ExeName" -ArgumentList "`"$InstallDir\$ScriptName`""

Write-Host "`nInstallation Complete! ParyEmacs is running and will start on boot." -ForegroundColor Green
Read-Host "Press Enter to exit..."
