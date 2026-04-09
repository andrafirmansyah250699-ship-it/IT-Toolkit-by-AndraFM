param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = "renew-ip-address"
    Label         = "Renew IP Address"
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

ipconfig /release | Out-Null
ipconfig /renew | Out-Null
Write-Output "IP release and renew completed."
