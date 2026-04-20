Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoOwner = "andrafm"
$repoName = "IT-Toolkit-by-AndraFM"
$cacheBust = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
$bootstrapUrl = "https://raw.githubusercontent.com/$repoOwner/$repoName/master/bootstrap.ps1?bust=$cacheBust"

try {
    $branchInfoUrl = "https://api.github.com/repos/$repoOwner/$repoName/branches/master"
    $branchInfo = Invoke-RestMethod -Uri $branchInfoUrl -UseBasicParsing -Headers @{ "User-Agent" = "ITToolkit-Launcher" }
    $headSha = [string]$branchInfo.commit.sha
    if (-not [string]::IsNullOrWhiteSpace($headSha)) {
        $bootstrapUrl = "https://raw.githubusercontent.com/$repoOwner/$repoName/$headSha/bootstrap.ps1"
    }
}
catch {
    # Fallback to cache-busted master bootstrap URL.
}

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}
catch {
    # Ignore if already on modern TLS.
}

Clear-Host

function Type-Text {
    param (
        [string]$text,
        [int]$delay = 40,
        [string]$color = "White"
    )
    foreach ($char in $text.ToCharArray()) {
        Write-Host $char -NoNewline -ForegroundColor $color
        Start-Sleep -Milliseconds $delay
    }
    Write-Host ""
}

# Top line
Write-Host ("=" * 32) -ForegroundColor DarkGray
Write-Host ""

# Typing Title
Type-Text "        TOOLKIT" 35 "Cyan"
Write-Host ""

Type-Text "           by" 25 "DarkGray"
Type-Text "        Andra FM" 35 "Yellow"

Write-Host ""
Write-Host ("=" * 32) -ForegroundColor DarkGray
Write-Host ""

# Progress Bar Simulation
$steps = @(
    "Initializing...",
    "Loading modules...",
    "Preparing environment...",
    "Starting toolkit..."
)

foreach ($step in $steps) {
    Write-Host ""
    Write-Host $step -ForegroundColor Green

    for ($i = 0; $i -le 100; $i += 10) {
        $bar = ("█" * ($i / 10)).PadRight(10, "-")
        Write-Host ("[{0}] {1}%" -f $bar, $i) -NoNewline -ForegroundColor Cyan
        Start-Sleep -Milliseconds 120
        Write-Host "`r" -NoNewline
    }

    Write-Host "[██████████] 100%" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "✔ Toolkit Ready!" -ForegroundColor Yellow
Start-Sleep -Milliseconds 500

if ($content.Length -gt 0 -and $content[0] -eq [char]0xFEFF) {
    $content = $content.Substring(1)
}

Invoke-Expression $content
