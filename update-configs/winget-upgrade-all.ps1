param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = "winget-upgrade-all"
    Label         = "Winget Upgrade All"
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget not found. Install App Installer from Microsoft Store first."
}

winget upgrade --all --silent --accept-package-agreements --accept-source-agreements
Write-Output "Winget upgrade all completed."
