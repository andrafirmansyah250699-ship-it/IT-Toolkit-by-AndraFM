param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = "set-services-to-manual"
    Label         = "Set Services to Manual"
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

$serviceNames = @(
    "ALG",
    "AppMgmt",
    "AppReadiness",
    "Appinfo",
    "AxInstSV",
    "BDESVC",
    "BTAGService",
    "CDPSvc",
    "COMSysApp",
    "CertPropSvc",
    "CscService",
    "DevQueryBroker",
    "DeviceAssociationService",
    "DeviceInstall",
    "DisplayEnhancementService",
    "EFS",
    "EapHost",
    "FDResPub",
    "FrameServer",
    "FrameServerMonitor",
    "GraphicsPerfSvc",
    "HvHost",
    "IKEEXT",
    "InstallService",
    "IpxlatCfgSvc",
    "KtmRm",
    "LicenseManager",
    "LxpSvc",
    "MSDTC",
    "MSiSCSI",
    "McpManagementService",
    "MicrosoftEdgeElevationService",
    "NaturalAuthentication",
    "NcaSvc",
    "NcbService",
    "NcdAutoSetup",
    "NetSetupSvc",
    "Netman",
    "NlaSvc",
    "PeerDistSvc",
    "PerfHost",
    "PhoneSvc",
    "PlugPlay",
    "PolicyAgent",
    "PrintNotify",
    "PushToInstall",
    "QWAVE",
    "RasAuto",
    "RasMan",
    "RetailDemo",
    "RmSvc",
    "RpcLocator",
    "SCPolicySvc",
    "SCardSvr",
    "SDRSVC",
    "SEMgrSvc",
    "SNMPTRAP",
    "SNMPTrap",
    "SSDPSRV",
    "ScDeviceEnum",
    "SensorDataService",
    "SensorService",
    "SensrSvc",
    "SessionEnv",
    "SharedAccess",
    "SmsRouter",
    "SstpSvc",
    "StiSvc",
    "TapiSrv",
    "TermService",
    "TieringEngineService",
    "TokenBroker",
    "TroubleshootingSvc",
    "TrustedInstaller",
    "UmRdpService",
    "UsoSvc",
    "VSS",
    "VaultSvc",
    "W32Time",
    "WEPHOSTSVC",
    "WFDSConMgrSvc",
    "WMPNetworkSvc",
    "WManSvc",
    "WPDBusEnum",
    "WSAIFabricSvc",
    "WalletService",
    "WarpJITSvc",
    "WbioSrvc",
    "WdiServiceHost",
    "WdiSystemHost",
    "WebClient",
    "Wecsvc",
    "WerSvc",
    "WiaRpc",
    "WinRM",
    "WpcMonSvc",
    "WpnService",
    "XblAuthManager",
    "XblGameSave",
    "XboxGipSvc",
    "XboxNetApiSvc",
    "autotimesvc",
    "bthserv",
    "camsvc",
    "cloudidsvc",
    "dcsvc",
    "defragsvc",
    "diagsvc",
    "dmwappushservice",
    "dot3svc",
    "edgeupdate",
    "edgeupdatem",
    "fdPHost",
    "fhsvc",
    "hidserv",
    "icssvc",
    "lfsvc",
    "lltdsvc",
    "lmhosts",
    "netprofm",
    "perceptionsimulation",
    "pla",
    "seclogon",
    "smphost",
    "svsvc",
    "swprv",
    "upnphost",
    "vds",
    "vmicguestinterface",
    "vmicheartbeat",
    "vmickvpexchange",
    "vmicrdv",
    "vmicshutdown",
    "vmictimesync",
    "vmicvmsession",
    "vmicvss",
    "wbengine",
    "wcncsvc",
    "webthreatdefsvc",
    "wercplsupport",
    "wisvc",
    "wlidsvc",
    "wlpasvc",
    "wmiApSrv",
    "workfolderssvc",
    "wuauserv"
)

$updated = 0
$missing = 0
$failed = 0

foreach ($serviceName in $serviceNames) {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($null -eq $service) {
        Write-Output "Service not found: $serviceName"
        $missing++
        continue
    }

    try {
        Set-Service -Name $serviceName -StartupType Manual -ErrorAction Stop
        Write-Output "Set to Manual: $serviceName"
        $updated++
    }
    catch {
        Write-Output "Failed set Manual: $serviceName -> $($_.Exception.Message)"
        $failed++
    }
}

Write-Output "Done. Updated=$updated Missing=$missing Failed=$failed"
