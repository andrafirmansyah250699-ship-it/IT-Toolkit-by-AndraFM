param(
    [switch]
    $Execute
)

$config = [pscustomobject]@{
    Id            = 'disable-telemetry'
    Label         = 'Disable Telemetry'
    Group         = 'Basic'
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

$regItems = @(
    @{ Path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo'; Name = 'Enabled'; Value = 0 },
    @{ Path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy'; Name = 'TailoredExperiencesWithDiagnosticDataEnabled'; Value = 0 },
    @{ Path = 'HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy'; Name = 'HasAccepted'; Value = 0 },
    @{ Path = 'HKCU:\Software\Microsoft\Input\TIPC'; Name = 'Enabled'; Value = 0 },
    @{ Path = 'HKCU:\Software\Microsoft\InputPersonalization'; Name = 'RestrictImplicitInkCollection'; Value = 1 },
    @{ Path = 'HKCU:\Software\Microsoft\InputPersonalization'; Name = 'RestrictImplicitTextCollection'; Value = 1 },
    @{ Path = 'HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore'; Name = 'HarvestContacts'; Value = 0 },
    @{ Path = 'HKCU:\Software\Microsoft\Personalization\Settings'; Name = 'AcceptedPrivacyPolicy'; Value = 0 },
    @{ Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection'; Name = 'AllowTelemetry'; Value = 0 },
    @{ Path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; Name = 'Start_TrackProgs'; Value = 0 },
    @{ Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'; Name = 'PublishUserActivities'; Value = 0 },
    @{ Path = 'HKCU:\Software\Microsoft\Siuf\Rules'; Name = 'NumberOfSIUFInPeriod'; Value = 0 }
)

foreach ($item in $regItems) {
    if (-not (Test-Path -Path $item.Path)) {
        New-Item -Path $item.Path -Force | Out-Null
    }
    Set-ItemProperty -Path $item.Path -Name $item.Name -Value $item.Value -Type DWord -Force
    Write-Output "Set: $($item.Path)\$($item.Name) = $($item.Value)"
}

try {
    Set-MpPreference -SubmitSamplesConsent 2 -ErrorAction SilentlyContinue
    Write-Output 'Set Defender sample submission: 2'
} catch {
    Write-Output 'Skipped Defender sample submission setting.'
}

foreach ($svc in @('diagtrack', 'wermgr')) {
    try {
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Write-Output "Disabled service: $svc"
    } catch {
        Write-Output "Skipped service: $svc"
    }
}

$memoryKB = (Get-CimInstance Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1KB
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'SvcHostSplitThresholdInKB' -Value $memoryKB -Type QWord -Force
Write-Output "Set: HKLM:\SYSTEM\CurrentControlSet\Control\SvcHostSplitThresholdInKB = $memoryKB"

try {
    Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Siuf\Rules' -Name 'PeriodInNanoSeconds' -ErrorAction SilentlyContinue
    Write-Output 'Removed: HKCU:\Software\Microsoft\Siuf\Rules\PeriodInNanoSeconds'
} catch {
    Write-Output 'Skipped: PeriodInNanoSeconds removal.'
}

Write-Output 'Telemetry disabled configuration applied.'
