$ErrorActionPreference = 'Stop'
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
    $PSNativeCommandUseErrorActionPreference = $false
}

$flutterDevicesText = cmd /c 'flutter devices --machine 2^>nul' | Out-String
try {
    $flutterDevices = $flutterDevicesText | ConvertFrom-Json
} catch {
    Write-Host 'Unable to read Flutter device information.'
    exit 1
}

$supportedDevices = @()
foreach ($device in $flutterDevices) {
    if ($device.isSupported -eq $true) {
        $supportedDevices += $device
    }
}

$adb = 'C:\Users\mjhay\AppData\Local\Android\Sdk\platform-tools\adb.exe'
$wirelessDeviceLines = @()
if (Test-Path $adb) {
    $adbOutput = & $adb devices
    foreach ($line in $adbOutput) {
        if ($line -match '_adb-tls-connect\._tcp') {
            $wirelessDeviceLines += $line
        }
    }
}

if ($wirelessDeviceLines.Count -gt 0) {
    Write-Host ''
    Write-Host 'Wireless ADB device detected, but Flutter reports it as unsupported in this setup.'
    Write-Host 'If you want to run the app on that phone, connect it by USB or use an adb TCP/IP connection that Flutter recognizes.'
    Write-Host 'Detected wireless ADB device(s):'
    foreach ($line in $wirelessDeviceLines) {
        Write-Host $line
    }
    Write-Host ''
}

if ($supportedDevices.Count -gt 0) {
    if ($supportedDevices.Count -eq 1) {
        $device = $supportedDevices | Select-Object -First 1
        Write-Host ''
        Write-Host ('Running on {0} ({1})...' -f $device.name, $device.id)
        & flutter run -d $device.id
        exit $LASTEXITCODE
    }

    Write-Host ''
    Write-Host 'Available supported devices:'
    for ($i = 0; $i -lt $supportedDevices.Count; $i++) {
        $device = $supportedDevices[$i]
        Write-Host ('[{0}] {1} ({2})' -f ($i + 1), $device.name, $device.id)
    }

    Write-Host ''
    $selection = Read-Host 'Select a device number (or q to quit)'
    if ($selection -match '^[Qq]$') {
        exit 0
    }
    if ($selection -notmatch '^\d+$') {
        Write-Host 'Invalid selection.'
        exit 1
    }

    $index = [int]$selection - 1
    if ($index -lt 0 -or $index -ge $supportedDevices.Count) {
        Write-Host 'Invalid selection.'
        exit 1
    }

    $device = $supportedDevices[$index]
    Write-Host ''
    Write-Host ('Running on {0} ({1})...' -f $device.name, $device.id)
    & flutter run -d $device.id
    exit $LASTEXITCODE
}

Write-Host 'No supported Flutter devices were found.'
exit 1
