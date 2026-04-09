param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = "set-services-to-manual"
    Label         = "Set Services to Manual"
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

$serviceNames = @(
    "SysMain",
    "DiagTrack",
    "WSearch"
)

foreach ($serviceName in $serviceNames) {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($null -eq $service) {
        Write-Output "Service not found: $serviceName"
        continue
    }

    Set-Service -Name $serviceName -StartupType Manual
    Write-Output "Set to Manual: $serviceName"
}
