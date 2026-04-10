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

$serviceNames = @('MSSQLSERVER', 'SQLBrowser')

$timeout = New-TimeSpan -Seconds 20

Write-Output '========================='
Write-Output 'RESTART SQL SERVER'
Write-Output '========================='
Write-Output 'Target services:'
Write-Output '- MSSQLSERVER'
Write-Output '- SQLBrowser'

$foundAny = $false

foreach ($serviceName in $serviceNames) {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($null -eq $service) {
        Write-Output "[SKIP] Service not found: $serviceName"
        continue
    }

    $foundAny = $true

    try {
        Write-Output "[STOP] $($service.DisplayName) ($($service.Name))"
        if ($service.Status -ne 'Stopped') {
            Stop-Service -Name $service.Name -Force -ErrorAction Stop
            $service.WaitForStatus('Stopped', $timeout)
        }
        else {
            Write-Output "[INFO] $($service.Name) already stopped"
        }

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

if (-not $foundAny) {
    Write-Output 'SQL Server service tidak ditemukan di device ini. Skip.'
    return
}

Write-Output 'Restart SQL Server selesai.'
