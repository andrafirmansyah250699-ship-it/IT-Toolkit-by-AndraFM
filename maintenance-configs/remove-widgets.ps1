param(
    [switch]
    $Execute
)

$config = [pscustomobject]@{
    Id            = 'remove-widgets'
    Label         = 'Remove Widgets'
    Group         = 'Basic'
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

Get-Process -Name '*Widget*' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

$targets = @(
    'Microsoft.WidgetsPlatformRuntime',
    'MicrosoftWindows.Client.WebExperience'
)

foreach ($name in $targets) {
    $packages = Get-AppxPackage -AllUsers -Name $name -ErrorAction SilentlyContinue
    if (-not $packages) {
        Write-Output "Not found: $name"
        continue
    }

    foreach ($pkg in $packages) {
        try {
            Remove-AppxPackage -Package $pkg.PackageFullName -AllUsers -ErrorAction SilentlyContinue
            Write-Output "Removed: $name"
        } catch {
            Write-Output "Skipped: $name"
        }
    }
}

Get-Process -Name explorer -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Process explorer.exe

Write-Output 'Widgets removed (if installed).'
