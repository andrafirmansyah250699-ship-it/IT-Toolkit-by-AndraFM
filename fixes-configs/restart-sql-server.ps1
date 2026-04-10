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
    Write-Output 'SQL Server service tidak ditemukan di device ini. Skip.'
    return
}

$timeout = New-TimeSpan -Seconds 20

Write-Output '========================='
Write-Output 'RESTART SQL SERVER'
Write-Output '========================='

foreach ($service in $services) {
    try {
        Write-Output "[STOP] $($service.DisplayName) ($($service.Name))"
        Stop-Service -Name $service.Name -Force -ErrorAction Stop
        $service.WaitForStatus('Stopped', $timeout)

        Write-Output "[START] $($service.DisplayName) ($($service.Name))"
        Start-Service -Name $service.Name -ErrorAction Stop
        $service.WaitForStatus('Running', $timeout)

        $refreshed = Get-Service -Name $service.Name
        Write-Output "[OK] $($refreshed.DisplayName) status: $($refreshed.Status)"
    }
    catch {
        Write-Output "[FAILED] $($service.Name): $($_.Exception.Message)"
    }
}

Write-Output 'Restart SQL Server selesai.'
