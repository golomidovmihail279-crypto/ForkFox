# Read-only Chromium build environment check
$ErrorActionPreference = 'SilentlyContinue'

Write-Host '=== Windows ==='
Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture

Write-Host '`n=== Physical memory ==='
$os = Get-CimInstance Win32_ComputerSystem
[pscustomobject]@{ InstalledRAM_GB = [math]::Round($os.TotalPhysicalMemory / 1GB, 1) }

Write-Host '`n=== Fixed drives ==='
Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object {
  [pscustomobject]@{
    Drive = $_.DeviceID
    FileSystem = $_.FileSystem
    Size_GB = [math]::Round($_.Size / 1GB, 1)
    Free_GB = [math]::Round($_.FreeSpace / 1GB, 1)
  }
} | Format-Table -AutoSize

Write-Host '`n=== Visual Studio installations ==='
$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
if (Test-Path $vswhere) {
  & $vswhere -all -products * -format table
} else {
  Write-Host 'vswhere.exe not found; Visual Studio Installer may not be installed.'
}

Write-Host '`n=== Git ==='
if (Get-Command git -ErrorAction SilentlyContinue) { git --version } else { Write-Host 'Git not found in PATH.' }

Write-Host '`n=== depot_tools ==='
if (Get-Command gclient -ErrorAction SilentlyContinue) {
  (Get-Command gclient).Source
} else {
  Write-Host 'gclient not found in PATH.'
}

Write-Host '`nThis script only reads system information. It does not install, change, or download anything.'