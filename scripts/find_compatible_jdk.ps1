# scripts/find_compatible_jdk.ps1
# Discovers the best compatible JDK (Java 17..23) for Gradle 8.13 and Flutter.
# Rejects incompatible versions (such as Java 25 / 25.0.2) that crash Gradle plugin resolution.

$candidates = [System.Collections.Generic.List[string]]::new()

function Add-Candidate([string]$p) {
    if ($p -and (Test-Path "$p\bin\java.exe") -and (-not $candidates.Contains($p))) {
        $candidates.Add($p)
    }
}

# 1. Standard Java installations (prioritize LTS 21, then LTS 17, then 22, 23)
if (Test-Path "C:\Program Files\Java") {
    Get-ChildItem -Directory "C:\Program Files\Java" -Filter "jdk-21*" -ErrorAction SilentlyContinue | ForEach-Object { Add-Candidate $_.FullName }
    Get-ChildItem -Directory "C:\Program Files\Java" -Filter "jdk-17*" -ErrorAction SilentlyContinue | ForEach-Object { Add-Candidate $_.FullName }
    Get-ChildItem -Directory "C:\Program Files\Java" -Filter "jdk-22*" -ErrorAction SilentlyContinue | ForEach-Object { Add-Candidate $_.FullName }
    Get-ChildItem -Directory "C:\Program Files\Java" -Filter "jdk-23*" -ErrorAction SilentlyContinue | ForEach-Object { Add-Candidate $_.FullName }
    Get-ChildItem -Directory "C:\Program Files\Java" -ErrorAction SilentlyContinue | ForEach-Object { Add-Candidate $_.FullName }
}

# 2. Eclipse Adoptium / Temurin
if (Test-Path "C:\Program Files\Eclipse Adoptium") {
    Get-ChildItem -Directory "C:\Program Files\Eclipse Adoptium" -Filter "jdk-21*" -ErrorAction SilentlyContinue | ForEach-Object { Add-Candidate $_.FullName }
    Get-ChildItem -Directory "C:\Program Files\Eclipse Adoptium" -Filter "jdk-17*" -ErrorAction SilentlyContinue | ForEach-Object { Add-Candidate $_.FullName }
    Get-ChildItem -Directory "C:\Program Files\Eclipse Adoptium" -ErrorAction SilentlyContinue | ForEach-Object { Add-Candidate $_.FullName }
}

# 3. Microsoft OpenJDK
if (Test-Path "C:\Program Files\Microsoft") {
    Get-ChildItem -Directory "C:\Program Files\Microsoft" -Filter "jdk-21*" -ErrorAction SilentlyContinue | ForEach-Object { Add-Candidate $_.FullName }
    Get-ChildItem -Directory "C:\Program Files\Microsoft" -Filter "jdk-17*" -ErrorAction SilentlyContinue | ForEach-Object { Add-Candidate $_.FullName }
    Get-ChildItem -Directory "C:\Program Files\Microsoft" -Filter "jdk-*" -ErrorAction SilentlyContinue | ForEach-Object { Add-Candidate $_.FullName }
}

# 4. Amazon Corretto
if (Test-Path "C:\Program Files\Amazon Corretto") {
    Get-ChildItem -Directory "C:\Program Files\Amazon Corretto" -ErrorAction SilentlyContinue | ForEach-Object { Add-Candidate $_.FullName }
}

# 5. Zulu
if (Test-Path "C:\Program Files\Zulu") {
    Get-ChildItem -Directory "C:\Program Files\Zulu" -ErrorAction SilentlyContinue | ForEach-Object { Add-Candidate $_.FullName }
}

# 6. Current JAVA_HOME
if ($env:JAVA_HOME) {
    Add-Candidate $env:JAVA_HOME
}

# 7. Android Studio JBR (tested for version compatibility)
Add-Candidate "C:\Program Files\Android\Android Studio\jbr"
if ($env:LOCALAPPDATA) {
    Add-Candidate "$env:LOCALAPPDATA\Programs\Android Studio\jbr"
}

# 8. Check where.exe java
try {
    $whereJava = (where.exe java 2>$null) | Select-Object -First 1
    if ($whereJava) {
        $parent = Split-Path (Split-Path $whereJava)
        Add-Candidate $parent
    }
} catch {}

$found = $null

foreach ($jdkPath in $candidates) {
    $javaBin = Join-Path $jdkPath "bin\java.exe"
    if (Test-Path $javaBin) {
        try {
            $output = & "$javaBin" -version 2>&1 | Out-String
            if ($output -match '(?:version|openjdk)\s+"?(\d+)') {
                $major = [int]$matches[1]
                # Accept Java 17 through 23
                # Explicitly reject Java 24+ and Java 25 (e.g. 25.0.2)
                if ($major -ge 17 -and $major -le 23) {
                    $found = $jdkPath
                    break
                }
            }
        } catch {}
    }
}

if ($found) {
    Write-Output $found
    exit 0
} else {
    exit 1
}
