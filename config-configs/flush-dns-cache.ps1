param(
    [switch]$Execute
)

$config = [pscustomobject]@{
    Id            = "flush-dns-cache"
    Label         = "Flush DNS Cache"
    RequiresAdmin = $true
}

if (-not $Execute) {
    return $config
}

ipconfig /flushdns | Out-Null
Write-Output "DNS resolver cache flushed."
