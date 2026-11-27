# Read-only ForkFox / Chromium build environment preflight.
# This script only reads system information. It does not install, download,
# modify settings, change PATH, or alter Windows security configuration.

$ErrorActionPreference = 'Continue'
$checks = [System.Collections.Generic.List[object]]::new()

function Add-Check {
    param(
        [string]$Name,
        [ValidateSet('PASS', 'WARN', 'FAIL', 'UNKNOWN')]
        [string]$Status,
        [string]$Details
    )
    $checks.Add([pscustomobject]@{
        Check = $Name
        Status = $Status
        Details = $Details
    })
}

Write-Host '=== ForkFox Chromium build preflight (read-only) ===' -ForegroundColor Cyan
Write-Host ''

try {
    $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
    $computer = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop
    $windowsOK = ($os.Caption -match 'Windows 11') -and ($os.OSArchitecture -match '64')
    Add-Check 'Windows' $(if ($windowsOK) { 'PASS' } else { 'FAIL' }) "$($os.Caption), version $($os.Version), $($os.OSArchitecture)"
    Add-Check 'Installed RAM' $(if ($computer.TotalPhysicalMemory -ge 16GB) { 'PASS' } elseif ($computer.TotalPhysicalMemory -ge 8GB) { 'WARN' } else { 'FAIL' }) "$([math]::Round($computer.TotalPhysicalMemory / 1GB, 1)) GB (8 GB minimum; more than 16 GB recommended)"
} catch {
    Add-Check 'Windows / RAM' 'UNKNOWN' $_.Exception.Message
}

try {
    $fixedDrives = Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' -ErrorAction Stop
    foreach ($drive in $fixedDrives) {
        $media = 'Unknown'
        try {
            $letter = $drive.DeviceID.TrimEnd(':')
            $partition = Get-Partition -DriveLetter $letter -ErrorAction Stop | Select-Object -First 1
            $disk = Get-Disk -Number $partition.DiskNumber -ErrorAction Stop
            $media = "$($disk.MediaType) / $($disk.BusType)"
        } catch {
            $media = 'Could not map volume to physical disk'
        }

        $freeGB = [math]::Round($drive.FreeSpace / 1GB, 1)
        Add-Check "Drive $($drive.DeviceID)" 'WARN' "File system: $($drive.FileSystem); free: $freeGB GB; media: $media"
    }
    $eligible = @($fixedDrives | Where-Object { $_.FileSystem -eq 'NTFS' -and $_.FreeSpace -ge 100GB })
    if ($eligible.Count -gt 0) {
        $eligibleText = ($eligible | ForEach-Object { "$($_.DeviceID) ($([math]::Round($_.FreeSpace / 1GB, 1)) GB free)" }) -join '; '
        Add-Check 'Eligible Chromium build drive' 'PASS' $eligibleText
    } else {
        Add-Check 'Eligible Chromium build drive' 'FAIL' 'No fixed drive has both NTFS and at least 100 GB free.'
    }
} catch {
    Add-Check 'Fixed drives' 'UNKNOWN' $_.Exception.Message
}

$programFilesX86 = [Environment]::GetFolderPath([Environment+SpecialFolder]::ProgramFilesX86)
$vswhere = Join-Path $programFilesX86 'Microsoft Visual Studio\Installer\vswhere.exe'
if (Test-Path $vswhere) {
    try {
        $vsJson = & $vswhere -all -products '*' -format json -utf8 2>$null
        $vsInstallations = @($vsJson | ConvertFrom-Json)
        if ($vsInstallations.Count -eq 0) {
            Add-Check 'Visual Studio' 'FAIL' 'vswhere found no Visual Studio installations.'
        } else {
            $vs2026 = @($vsInstallations | Where-Object { [version]$_.installationVersion -ge [version]'18.0.0' })
            if ($vs2026.Count -gt 0) {
                Add-Check 'Visual Studio 2026+' 'PASS' (($vs2026 | ForEach-Object { "$($_.displayName) $($_.installationVersion) at $($_.installationPath)" }) -join '; ')
            } else {
                Add-Check 'Visual Studio 2026+' 'FAIL' 'Chromium currently requires Visual Studio 2026 (18.0.0) or newer.'
            }

            $requiredVs = & $vswhere -all -products '*' -requires Microsoft.VisualStudio.Workload.NativeDesktop Microsoft.VisualStudio.Component.VC.ATLMFC -property installationPath 2>$null
            $requiredVs2026 = @($requiredVs | Where-Object { $path = $_; $vs2026 | Where-Object { $_.installationPath -eq $path } })
            if ($requiredVs2026.Count -gt 0) {
                Add-Check 'Visual Studio C++ workload + MFC/ATL' 'PASS' ($requiredVs2026 -join '; ')
            } else {
                Add-Check 'Visual Studio C++ workload + MFC/ATL' 'FAIL' 'No Visual Studio 2026+ installation found with both Desktop development with C++ and MFC/ATL components.'
            }
        }
    } catch {
        Add-Check 'Visual Studio detection' 'UNKNOWN' $_.Exception.Message
    }
} else {
    Add-Check 'Visual Studio Installer' 'FAIL' 'vswhere.exe not found.'
}

$kitsRoot = Join-Path $programFilesX86 'Windows Kits\10'
$requiredSdk = '10.0.28000.2270'
$sdkInclude = Join-Path $kitsRoot "Include\$requiredSdk"
if (Test-Path $sdkInclude) {
    Add-Check 'Windows 11 SDK headers' 'PASS' $requiredSdk
} else {
    $availableSdks = @()
    $includeRoot = Join-Path $kitsRoot 'Include'
    if (Test-Path $includeRoot) {
        $availableSdks = @(Get-ChildItem $includeRoot -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name)
    }
    Add-Check 'Windows 11 SDK headers' 'FAIL' "Required $requiredSdk not found. Installed versions: $($availableSdks -join ', ')"
}

$cdb = Join-Path $kitsRoot 'Debuggers\x64\cdb.exe'
if (Test-Path $cdb) {
    $cdbVersion = (Get-Item $cdb).VersionInfo.FileVersion
    Add-Check 'Windows SDK Debugging Tools' 'WARN' "cdb.exe found; file version $cdbVersion. Confirm the installed package version is 10.0.26100.3323 or newer in Windows Installer."
} else {
    Add-Check 'Windows SDK Debugging Tools' 'FAIL' 'Debuggers\x64\cdb.exe not found. Chromium requires Windows SDK Debugging Tools 10.0.26100.3323 or newer.'
}

foreach ($commandName in @('git', 'gclient', 'fetch', 'gn', 'autoninja')) {
    $command = Get-Command $commandName -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($command) {
        $details = $command.Source
        if ($commandName -eq 'git') {
            $details = (& git --version 2>&1 | Select-Object -First 1)
        }
        Add-Check $commandName 'PASS' "$details"
    } else {
        Add-Check $commandName 'FAIL' 'Not found in PATH.'
    }
}

try {
    $pythonPaths = @(& where.exe python3 2>$null)
    if ($pythonPaths.Count -gt 0) {
        Add-Check 'python3 resolution' 'WARN' ($pythonPaths -join '; ')
    } else {
        Add-Check 'python3 resolution' 'WARN' 'python3 not found. Run gclient from cmd.exe after depot_tools is installed.'
    }
} catch {
    Add-Check 'python3 resolution' 'UNKNOWN' $_.Exception.Message
}

Write-Host ''
Write-Host '=== Results ===' -ForegroundColor Cyan
$checks | Format-Table -Wrap -AutoSize

$failCount = @($checks | Where-Object Status -eq 'FAIL').Count
$warnCount = @($checks | Where-Object Status -eq 'WARN').Count
Write-Host ''
Write-Host "FAIL: $failCount | WARN: $warnCount | Total checks: $($checks.Count)"
Write-Host 'This report is a preflight only. It does not prove that Chromium will build successfully.'
Write-Host 'No settings were changed and no software was installed or downloaded.'
