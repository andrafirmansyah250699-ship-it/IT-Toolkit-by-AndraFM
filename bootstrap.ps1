Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# =========================
# SILENT MODE FLAG
# =========================
$SilentMode = $true

function Log($msg, $color = "Cyan") {
    if (-not $SilentMode) {
        Write-Host $msg -ForegroundColor $color
    }
}

# =========================
# CONFIG
# =========================
$repoOwner = "andrafm"
$repoName  = "IT-Toolkit-by-AndraFM"
$sourceRef = "master"
$cacheBust = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()

$zipUrl = "https://codeload.github.com/$repoOwner/$repoName/zip/refs/heads/${sourceRef}?bust=$cacheBust"

$tempRoot    = Join-Path $env:TEMP "ITToolkit-AndraFM"
$zipPath     = Join-Path $tempRoot "$sourceRef.zip"
$extractRoot = Join-Path $tempRoot $sourceRef

# =========================
# TLS
# =========================
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
} catch {}

# =========================
# PROGRESS FUNCTION (SINGLE LINE)
# =========================
function Show-Status {
    param([string]$text)

    if ($SilentMode) { return }

    Write-Host ("{0}..." -f $text) -ForegroundColor Cyan
}

# =========================
# PREP TEMP
# =========================
if (-not (Test-Path $tempRoot)) {
    New-Item -Path $tempRoot -ItemType Directory -Force | Out-Null
}

# =========================
# CLEAN OLD
# =========================
Show-Status "Cleaning old files"

Get-ChildItem -Path $tempRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -eq "master" -or $_.Name -like "v*"
} | ForEach-Object {
    Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
}

if (Test-Path $extractRoot) {
    Remove-Item $extractRoot -Recurse -Force -ErrorAction SilentlyContinue
}

# =========================
# DOWNLOAD
# =========================
Show-Status "Downloading toolkit"

Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing

# =========================
# EXTRACT
# =========================
Show-Status "Extracting package"

Expand-Archive -Path $zipPath -DestinationPath $extractRoot -Force

# =========================
# CLEAN SCRIPTS
# =========================
Show-Status "Preparing scripts"

$configDirs = @("maintenance-configs", "config-configs", "security-configs", "update-configs")

foreach ($configDir in $configDirs) {
    $srcPath = Get-ChildItem -Path $extractRoot -Recurse -Directory -Filter $configDir -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName

    if ($srcPath) {
        Get-ChildItem -Path $srcPath -Filter "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
            $content = Get-Content $_.FullName -Raw -Encoding UTF8
            Set-Content $_.FullName -Value $content -Encoding UTF8 -Force
            try { Unblock-File $_.FullName -ErrorAction SilentlyContinue } catch {}
        }
    }
}

Get-ChildItem -Path $extractRoot -Recurse -Filter "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
    try { Unblock-File $_.FullName -ErrorAction SilentlyContinue } catch {}
}

# =========================
# FIND MAIN SCRIPT
# =========================
$toolkitPath = Get-ChildItem -Path $extractRoot -Recurse -Filter "ITToolkit.ps1" -File -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName

if (-not $toolkitPath) {
    throw "Cannot locate ITToolkit.ps1 after extracting package."
}

# =========================
# FINAL STATUS
# =========================
if (-not $SilentMode) {
    Write-Host ""
    Write-Host "[████████████████████] 100% Ready!" -ForegroundColor Cyan
    Write-Host ""
}

# =========================
# LAUNCH
# =========================
try {
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue
} catch {}

try {
    & $toolkitPath
}
catch [System.Management.Automation.PSSecurityException] {
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $toolkitPath
    if ($LASTEXITCODE -ne 0) {
        throw "Toolkit failed to launch. ExitCode=$LASTEXITCODE"
    }
}
