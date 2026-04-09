param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = "quick-defender-scan"
    Label         = "Quick Microsoft Defender Scan"
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

if (-not (Get-Command Start-MpScan -ErrorAction SilentlyContinue)) {
    throw "Start-MpScan command not available on this system."
}

Start-MpScan -ScanType QuickScan
Write-Output "Microsoft Defender quick scan triggered."
