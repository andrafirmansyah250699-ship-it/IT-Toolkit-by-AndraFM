param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = "create-restore-point"
    Label         = "Create Restore Point"
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

$description = "ITToolkit Auto Maintenance - $(Get-Date -Format 'yyyyMMdd-HHmmss')"
Checkpoint-Computer -Description $description -RestorePointType "MODIFY_SETTINGS"
Write-Output "Restore point created: $description"
