param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = "open-windows-update"
    Label         = "Open Windows Update Settings"
    RequiresAdmin = $false
}

if (-not $Execute) {
    return $config
}

Start-Process "ms-settings:windowsupdate"
Write-Output "Windows Update settings opened."
