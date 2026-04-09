param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = "enable-windows-firewall"
    Label         = "Enable Windows Firewall (All Profiles)"
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True
Write-Output "Windows Firewall enabled for Domain, Private, and Public profiles."
