$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
if (-not (Test-Path $adb)) {
    $cmd = Get-Command adb -ErrorAction SilentlyContinue
    if ($cmd) { $adb = $cmd.Source }
}

if (-not $adb -or -not (Test-Path $adb)) {
    exit 1
}

$output = & $adb shell ip -f inet addr show wlan0 2>$null
$ip = $null
if ($output) {
    foreach ($line in $output) {
        if ($line -match 'inet\s+([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)') {
            $ip = $matches[1]
            break
        }
    }
}

if (-not $ip) {
    $routes = & $adb shell ip route 2>$null
    if ($routes) {
        foreach ($line in $routes) {
            if ($line -match 'src\s+([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)') {
                $ip = $matches[1]
                break
            }
        }
    }
}

if ($ip) {
    Write-Output $ip
}
