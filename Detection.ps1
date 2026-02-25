$ScriptName = "Detect Latest BIOS"
$LogPath    = 'C:\Windows\Logs\Software'

function Invoke-RemediationLog {
<#
.SYNOPSIS
    Unified logger for PS4-PS7, overrides Write-* commands and captures all messages
.DESCRIPTION
    Captures all Write-Host, Write-Output, Write-Warning, Write-Error and Write-Verbose messages in memory.
    On 'Stop' mode, restores original Write-* commands and returns an array of all captured log messages.
.NOTES
    Version: 1.0.0
#>
  param(
    [ValidateSet('Start','Stop')][string]$Mode='Start',
    [string]$Name = $(if($MyInvocation.ScriptName){[System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.ScriptName)}else{'AthLog'}),
    [string]$LogPath = $(if($MyInvocation.PSScriptRoot){$MyInvocation.PSScriptRoot}elseif($PSScriptRoot){$PSScriptRoot}else{$pwd.Path})
  )
  if ($Mode -eq 'Start') {
    if (-not $script:_l) {
        $script:_l = New-Object 'System.Collections.Generic.List[string]'
    # Override write-*** cmdlets to capture log messages and return an array of all messages on 'Stop' mode
        function global:Write-Host {$m = $args -join ' ';if ($m) {$script:_l.Add("[INFO]$m");Microsoft.PowerShell.Utility\Write-Host "[INFO]$m"}}
        function global:Write-Output {$m = $args -join ' ';if ($m) {$script:_l.Add("[INFO]$m");Microsoft.PowerShell.Utility\Write-Host "[INFO]$m"}}
        function global:Write-Warning {$m = $args -join ' ';if ($m) {$script:_l.Add("[WARN]$m");Microsoft.PowerShell.Utility\Write-Host "[WARN]$m" -ForegroundColor Yellow}}
        function global:Write-Error {$m = $args -join ' ';if ($m) {$script:_l.Add("[ERR]$m");Microsoft.PowerShell.Utility\Write-Host "[ERR]$m" -ForegroundColor Red}}
        function global:Write-Verbose {$m = $args -join ' ';if ($m) {$script:_l.Add("[VERBOSE]$m");if ($VerbosePreference -ne 'SilentlyContinue') {Microsoft.PowerShell.Utility\Write-Host "[VERBOSE]$m" -ForegroundColor Cyan}}}    }
  } else {
    'Write-Host','Write-Output','Write-Warning','Write-Error','Write-Verbose'|ForEach-Object{Remove-Item "function:$_" -ea 0}
    if ($script:_l) {try{[System.IO.File]::WriteAllLines("$($LogPath)\$($Name).log",$script:_l)}catch{};,$script:_l.ToArray();$script:_l=$null} else {@()}
  }
}

# Start logging
Invoke-RemediationLog -Mode Start

# BIOS Version Check
Import-Module HPCMSL -ErrorAction Stop

# Get device model using HP CMSL
$DeviceModel = (Get-CimInstance -ClassName Win32_ComputerSystem).Model

[version]$BiosCurrentVer = Get-HPBIOSVersion
[version]$BiosLatest = (Get-HPBIOSUpdates -Latest).Ver
$BiosCheckResult = Get-HPBIOSUpdates -Check

$Diag = [ordered]@{
    'DeviceModel' = $DeviceModel
    'BIOSCurrentVersion' = $BiosCurrentVer.ToString()
    'BIOSLatestVersion' = $BiosLatest.ToString()
    'BIOSIsLatest' = $BiosCheckResult
}

# Output diagnostic info
foreach ($key in $Diag.Keys) {
    Write-Output "$key=$($Diag[$key])"
}

if ($BiosCheckResult) {
    Write-Host "BIOS is up to date. Current: $BiosCurrentVer, Latest: $BiosLatest"
    Write-Host "Result=Compliant"
    $Log = Invoke-RemediationLog -Mode Stop -Name "Detection-$ScriptName" -LogPath $LogPath
    Write-Output "Compliant - $Log"
    Exit 0
} else {
    Write-Warning "BIOS is NOT up to date. Current: $BiosCurrentVer, Latest: $BiosLatest"
    Write-Warning "Result=Non-Compliant"
    $Log = Invoke-RemediationLog -Mode Stop -Name "Detection-$ScriptName" -LogPath $LogPath
    Write-Output "Non-Compliant - $Log"
    Exit 1
}
