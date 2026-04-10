param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = 'fix-printer-spooler'
    Label         = 'Fix Printer Spooler'
    Group         = 'Fixes'
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

$spoolPath = Join-Path $env:SystemRoot 'System32\spool\PRINTERS'

Write-Output '==============================='
Write-Output 'FIX PRINTER SPOOLER'
Write-Output '==============================='
Write-Output '[1] Stop Printer Spooler...'
Stop-Service -Name spooler -Force -ErrorAction SilentlyContinue

Write-Output '[2] Hapus file antrian printer...'
if (Test-Path -Path $spoolPath) {
    Get-ChildItem -Path $spoolPath -Force -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item -Path $_.FullName -Force -Recurse -ErrorAction SilentlyContinue
    }
}

Write-Output '[3] Start Printer Spooler...'
Start-Service -Name spooler -ErrorAction Stop

Write-Output 'Selesai! Printer sudah di-refresh.'
