param(
    [switch]
    $Execute
)

$config = [pscustomobject]@{
    Id            = 'disable-hibernation'
    Label         = 'Disable Hibernation'
    Group         = 'Basic'
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

$regItems = @(
    @{ Path = 'HKLM:\System\CurrentControlSet\Control\Session Manager\Power'; Name = 'HibernateEnabled'; Value = 0 },
    @{ Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings'; Name = 'ShowHibernateOption'; Value = 0 }
)

foreach ($item in $regItems) {
    if (-not (Test-Path -Path $item.Path)) {
        New-Item -Path $item.Path -Force | Out-Null
    }
    Set-ItemProperty -Path $item.Path -Name $item.Name -Value $item.Value -Type DWord -Force
    Write-Output "Set: $($item.Path)\$($item.Name) = $($item.Value)"
}

powercfg.exe /hibernate off | Out-Null
Write-Output 'Hibernation disabled.'
