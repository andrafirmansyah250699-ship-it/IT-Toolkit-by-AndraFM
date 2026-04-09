param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = "delete-temporary-file"
    Label         = "Delete Temporary File"
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

function Clear-TempFolder {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -Path $Path)) {
        New-Item -Path $Path -ItemType Directory -Force | Out-Null
        return [pscustomobject]@{ Path = $Path; Deleted = 0; Skipped = 0 }
    }

    $deleted = 0
    $skipped = 0

    Get-ChildItem -Path $Path -Force -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction Stop
            $deleted++
        }
        catch {
            $skipped++
        }
    }

    if (-not (Test-Path -Path $Path)) {
        New-Item -Path $Path -ItemType Directory -Force | Out-Null
    }

    return [pscustomobject]@{ Path = $Path; Deleted = $deleted; Skipped = $skipped }
}

$userTempPath = [IO.Path]::GetTempPath()
$windowsTempPath = Join-Path $env:WINDIR "Temp"

$results = @(
    (Clear-TempFolder -Path $userTempPath),
    (Clear-TempFolder -Path $windowsTempPath)
)

Write-Output "Temporary cleanup completed."
foreach ($result in $results) {
    Write-Output "Path: $($result.Path) | Removed: $($result.Deleted) | Skipped: $($result.Skipped)"
}
