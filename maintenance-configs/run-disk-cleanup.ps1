param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = "run-disk-cleanup"
    Label         = "Run Disk Cleanup"
    RequiresAdmin = $false
}

if (-not $Execute) {
    return $config
}

Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/VERYLOWDISK" -Wait
Write-Output "Disk Cleanup completed."
