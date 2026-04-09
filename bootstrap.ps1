Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Replace this URL with your public raw GitHub URL.
$toolkitUrl = "https://raw.githubusercontent.com/your-username/it-toolkit/main/ITToolkit.ps1"

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}
catch {
    # Ignore if already on modern TLS.
}

Write-Host "Downloading toolkit from: $toolkitUrl" -ForegroundColor Cyan
$scriptContent = Invoke-RestMethod -Uri $toolkitUrl -UseBasicParsing

if ([string]::IsNullOrWhiteSpace($scriptContent)) {
    throw "Toolkit script is empty or failed to download."
}

Invoke-Expression $scriptContent
