param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = 'restart-sql-server'
    Label         = 'Restart SQL Server'
    Group         = 'Fixes'
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

$services = Get-Service | Where-Object { $_.Name -match '^MSSQL(\$.+)?$' }
if (-not $services) {
    throw 'SQL Server service tidak ditemukan.'
}

$timeout = New-TimeSpan -Seconds 20

Write-Output '========================='
Write-Output 'RESTART SQL SERVER'
Write-Output '========================='

foreach ($service in $services) {
    Write-Output "[STOP] $($service.DisplayName) ($($service.Name))"
    Stop-Service -Name $service.Name -Force -ErrorAction Stop
    $service.WaitForStatus('Stopped', $timeout)

    Write-Output "[START] $($service.DisplayName) ($($service.Name))"
    Start-Service -Name $service.Name -ErrorAction Stop
    $service.WaitForStatus('Running', $timeout)

    $refreshed = Get-Service -Name $service.Name
    Write-Output "[OK] $($refreshed.DisplayName) status: $($refreshed.Status)"
}

Write-Output 'Restart SQL Server selesai.'
