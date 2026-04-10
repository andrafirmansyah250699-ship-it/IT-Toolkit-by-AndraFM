param(
    [switch]
    $Execute
)

$config = [pscustomobject]@{
    Id            = 'enable-end-task-right-click'
    Label         = 'Enable End Task With Right Click'
    Group         = 'Basic'
    RequiresAdmin = $false
}

if (-not $Execute) {
    return $config
}

$path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings'
if (-not (Test-Path -Path $path)) {
    New-Item -Path $path -Force | Out-Null
}

Set-ItemProperty -Path $path -Name 'TaskbarEndTask' -Value 1 -Type DWord -Force
Write-Output 'Enabled: End Task on taskbar right-click menu.'
Write-Output 'Note: Restart Explorer or sign out/in if option is not visible yet.'
