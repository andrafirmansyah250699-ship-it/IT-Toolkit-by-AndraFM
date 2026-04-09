param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = "delete-prefetch-file"
    Label         = "Delete Prefetch File"
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

$prefetchPath = Join-Path $env:SystemRoot "Prefetch"
$deleted = 0

if (-not (Test-Path -Path $prefetchPath)) {
    Write-Output "Prefetch folder not found: $prefetchPath"
    return
}

Get-ChildItem -Path $prefetchPath -Force -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction Stop
        $deleted++
    }
    catch {
        # Skip locked files.
    }
}

Write-Output "Prefetch cleanup finished in: $prefetchPath"
Write-Output "Entries removed: $deleted"
