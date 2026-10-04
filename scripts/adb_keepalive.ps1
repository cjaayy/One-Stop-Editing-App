param(
    [string]$DeviceId,
    [string]$SavedIp,
    [string]$AdbPath = "adb"
)

if (-not $DeviceId) { exit 0 }

while ($true) {
    Start-Sleep -Seconds 15
    try {
        & $AdbPath -s $DeviceId shell echo keepalive > $null 2>&1
    } catch {
        # ignore transient errors
    }
}
