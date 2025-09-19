<#
Create-SuperGodModeShortcuts-Enhanced.ps1
Creates a "SuperGodMode" folder on the Desktop and populates categorized subfolders
with 300+ carefully named Windows 11 shortcuts including niche and advanced tools.
Cleans invalid filename chars and ensures folders exist before saving .lnk files.
#>

# Helper: sanitize filename (remove or replace invalid characters)
function Sanitize-Filename {
    param([string]$Name)
    $invalid = [System.IO.Path]::GetInvalidFileNameChars()
    foreach ($c in $invalid) { $Name = $Name -replace ([regex]::Escape($c)), '-' }
    # Also replace forward slash and backslash (just in case)
    $Name = $Name -replace '[\\/]', '-'
    # Trim trailing spaces or dots
    $Name = $Name.TrimEnd(' ', '.')
    return $Name
}

# Helper: ensure category folder exists
function Ensure-Category {
    param([string]$Base, [string]$Category)
    $catPath = Join-Path $Base $Category
    if (-not (Test-Path $catPath)) { New-Item -Path $catPath -ItemType Directory -Force | Out-Null }
    return $catPath
}

# Helper: create a .lnk safely
function Create-Shortcut {
    param(
        [string]$Folder,
        [string]$Name,
        [string]$Target,
        [string]$Arguments = $null,
        [string]$Icon = "$env:windir\System32\shell32.dll,0"
    )

    $safeName = Sanitize-Filename $Name
    $lnkPath = Join-Path $Folder ("$safeName.lnk")

    try {
        $wsh = New-Object -ComObject WScript.Shell
        $sc = $wsh.CreateShortcut($lnkPath)
        $sc.TargetPath = $Target
        if ($Arguments) { $sc.Arguments = $Arguments }
        $sc.IconLocation = $Icon
        $sc.WorkingDirectory = Split-Path $Target -Parent
        $sc.Save()
    } catch {
        Write-Warning "Failed to save shortcut: $lnkPath -- $_"
    }
}

# Base folder (Desktop)
$Desktop = [Environment]::GetFolderPath('Desktop')
$SuperGodMode = Join-Path $Desktop 'SuperGodMode'
if (-not (Test-Path $SuperGodMode)) { New-Item -Path $SuperGodMode -ItemType Directory -Force | Out-Null }

# Icon helper shortcuts to pick index by category (you can adjust indices if you prefer)
$iconShell = "$env:windir\System32\shell32.dll"
$iconImage = "$env:windir\System32\imageres.dll"

# -----------------------
# Category: Power
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Power'
Create-Shortcut -Folder $cat -Name 'Restart (Instant)' -Target 'shutdown.exe' -Arguments '/r /t 0 /f' -Icon "$iconShell,128"
Create-Shortcut -Folder $cat -Name 'Shutdown (Instant)' -Target 'shutdown.exe' -Arguments '/s /t 0 /f' -Icon "$iconShell,129"
Create-Shortcut -Folder $cat -Name 'Hibernate (If Enabled)' -Target 'shutdown.exe' -Arguments '/h' -Icon "$iconShell,131"
Create-Shortcut -Folder $cat -Name 'Sleep (Suspend)' -Target 'rundll32.exe' -Arguments 'powrprof.dll,SetSuspendState 0,1,0' -Icon "$iconShell,130"
Create-Shortcut -Folder $cat -Name 'Lock WorkStation' -Target 'rundll32.exe' -Arguments 'user32.dll,LockWorkStation' -Icon "$iconShell,132"
Create-Shortcut -Folder $cat -Name 'Sign Out (Logoff)' -Target 'shutdown.exe' -Arguments '/l' -Icon "$iconShell,133"
Create-Shortcut -Folder $cat -Name 'Reboot to UEFI (Firmware)' -Target 'shutdown.exe' -Arguments '/r /fw /t 0 /f' -Icon "$iconShell,134"
Create-Shortcut -Folder $cat -Name 'Power & Sleep Settings' -Target 'explorer.exe' -Arguments 'ms-settings:powersleep' -Icon "$iconImage,27"
Create-Shortcut -Folder $cat -Name 'Battery Saver Settings' -Target 'explorer.exe' -Arguments 'ms-settings:batterysaver' -Icon "$iconImage,53"
# NEW POWER SHORTCUTS
Create-Shortcut -Folder $cat -Name 'Power Options (Control Panel)' -Target 'powercfg.cpl' -Icon "$iconShell,131"
Create-Shortcut -Folder $cat -Name 'Advanced Power Settings' -Target 'rundll32.exe' -Arguments 'shell32.dll,Control_RunDLL powercfg.cpl,,1' -Icon "$iconShell,131"
Create-Shortcut -Folder $cat -Name 'Power Efficiency Diagnostics Report' -Target 'cmd.exe' -Arguments '/c powercfg /energy /output %userprofile%\Desktop\energy-report.html & start %userprofile%\Desktop\energy-report.html' -Icon "$iconShell,131"
Create-Shortcut -Folder $cat -Name 'Battery Report' -Target 'cmd.exe' -Arguments '/c powercfg /batteryreport /output %userprofile%\Desktop\battery-report.html & start %userprofile%\Desktop\battery-report.html' -Icon "$iconShell,131"
Create-Shortcut -Folder $cat -Name 'Sleep Study Report' -Target 'cmd.exe' -Arguments '/c powercfg /sleepstudy /output %userprofile%\Desktop\sleepstudy-report.html & start %userprofile%\Desktop\sleepstudy-report.html' -Icon "$iconShell,131"

# Additional Power Shortcuts (New)
Create-Shortcut -Folder $cat -Name 'Power Troubleshooter' -Target 'msdt.exe' -Arguments '-id PowerDiagnostic' -Icon "$iconShell,131"
Create-Shortcut -Folder $cat -Name 'List Power Plans' -Target 'cmd.exe' -Arguments '/c powercfg /list & pause' -Icon "$iconShell,131"
Create-Shortcut -Folder $cat -Name 'Set Power Plan Balanced' -Target 'cmd.exe' -Arguments '/c powercfg /setactive SCHEME_BALANCED & pause' -Icon "$iconShell,131"
Create-Shortcut -Folder $cat -Name 'Export Power Plan' -Target 'cmd.exe' -Arguments '/c powercfg /export %userprofile%\Desktop\powerplan.pow {guid} & pause' -Icon "$iconShell,131" # Replace {guid} with actual

# -----------------------
# Category: System Utilities
# -----------------------
$cat = Ensure-Category $SuperGodMode 'System Utilities'
Create-Shortcut -Folder $cat -Name 'Task Manager' -Target 'taskmgr.exe' -Icon "$iconShell,137"
Create-Shortcut -Folder $cat -Name 'Task Scheduler' -Target 'taskschd.msc' -Icon "$iconShell,138"
Create-Shortcut -Folder $cat -Name 'Event Viewer' -Target 'eventvwr.msc' -Icon "$iconShell,139"
Create-Shortcut -Folder $cat -Name 'Services' -Target 'services.msc' -Icon "$iconShell,140"
Create-Shortcut -Folder $cat -Name 'Device Manager' -Target 'devmgmt.msc' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Disk Management' -Target 'diskmgmt.msc' -Icon "$iconShell,142"
Create-Shortcut -Folder $cat -Name 'Computer Management' -Target 'compmgmt.msc' -Icon "$iconShell,143"
Create-Shortcut -Folder $cat -Name 'System Information (msinfo32)' -Target 'msinfo32.exe' -Icon "$iconShell,144"
Create-Shortcut -Folder $cat -Name 'Resource Monitor' -Target 'perfmon.exe' -Arguments '/res' -Icon "$iconShell,145"
Create-Shortcut -Folder $cat -Name 'Performance Monitor' -Target 'perfmon.exe' -Icon "$iconShell,146"
Create-Shortcut -Folder $cat -Name 'Reliability Monitor' -Target 'perfmon.exe' -Arguments '/rel' -Icon "$iconShell,147"
Create-Shortcut -Folder $cat -Name 'Windows Memory Diagnostic' -Target 'mdsched.exe' -Icon "$iconShell,152"
Create-Shortcut -Folder $cat -Name 'System Configuration (msconfig)' -Target 'msconfig.exe' -Icon "$iconShell,174"
Create-Shortcut -Folder $cat -Name 'DirectX Diagnostic (dxdiag)' -Target 'dxdiag.exe' -Icon "$iconShell,190"
Create-Shortcut -Folder $cat -Name 'Open CMD Here (Admin) - Explorer' -Target 'cmd.exe' -Arguments '/k pushd "%V"' -Icon "$iconShell,179"
# NEW SYSTEM UTILITIES
Create-Shortcut -Folder $cat -Name 'System File Checker (SFC Scan)' -Target 'cmd.exe' -Arguments '/c sfc /scannow & pause' -Icon "$iconShell,137"
Create-Shortcut -Folder $cat -Name 'DISM Health Check' -Target 'cmd.exe' -Arguments '/c DISM /Online /Cleanup-Image /CheckHealth & pause' -Icon "$iconShell,137"
Create-Shortcut -Folder $cat -Name 'DISM Restore Health' -Target 'cmd.exe' -Arguments '/c DISM /Online /Cleanup-Image /RestoreHealth & pause' -Icon "$iconShell,137"
Create-Shortcut -Folder $cat -Name 'Component Store Cleanup' -Target 'cmd.exe' -Arguments '/c DISM /online /Cleanup-Image /StartComponentCleanup /ResetBase & pause' -Icon "$iconShell,137"
Create-Shortcut -Folder $cat -Name 'System Restore' -Target 'rstrui.exe' -Icon "$iconShell,137"
Create-Shortcut -Folder $cat -Name 'Windows Version Info (winver)' -Target 'winver.exe' -Icon "$iconShell,144"
Create-Shortcut -Folder $cat -Name 'Character Map' -Target 'charmap.exe' -Icon "$iconShell,144"
Create-Shortcut -Folder $cat -Name 'Private Character Editor' -Target 'eudcedit.exe' -Icon "$iconShell,144"
Create-Shortcut -Folder $cat -Name 'Registry Checker (ScanReg)' -Target 'cmd.exe' -Arguments '/c sfc /verifyonly & pause' -Icon "$iconShell,162"

# Additional System Utilities (New)
Create-Shortcut -Folder $cat -Name 'Disk Partition Tool (diskpart)' -Target 'diskpart.exe' -Icon "$iconShell,142"
Create-Shortcut -Folder $cat -Name 'Driver Query' -Target 'cmd.exe' -Arguments '/c driverquery & pause' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'System Info Command' -Target 'cmd.exe' -Arguments '/c systeminfo & pause' -Icon "$iconShell,144"
Create-Shortcut -Folder $cat -Name 'WMI Tester' -Target 'wbemtest.exe' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Resultant Set of Policy' -Target 'rsop.msc' -Icon "$iconShell,163"
Create-Shortcut -Folder $cat -Name 'Package Manager' -Target 'pkgmgr.exe' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Mobility Center' -Target 'mblctr.exe' -Icon "$iconShell,53"
Create-Shortcut -Folder $cat -Name 'Signature Verification' -Target 'sigverif.exe' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Driver Verifier' -Target 'verifier.exe' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'ClearType Tuner' -Target 'cttune.exe' -Icon "$iconShell,144"

# -----------------------
# Category: Cleanup & Maintenance
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Cleanup & Maintenance'
Create-Shortcut -Folder $cat -Name 'Disk Cleanup (cleanmgr)' -Target 'cleanmgr.exe' -Icon "$iconShell,151"
Create-Shortcut -Folder $cat -Name 'Storage Sense' -Target 'explorer.exe' -Arguments 'ms-settings:storagesense' -Icon "$iconShell,156"
Create-Shortcut -Folder $cat -Name 'Optimize Drives (Defrag)' -Target 'dfrgui.exe' -Icon "$iconShell,157"
Create-Shortcut -Folder $cat -Name 'Empty Recycle Bin' -Target 'explorer.exe' -Arguments 'shell:RecycleBinFolder' -Icon "$iconShell,159"
Create-Shortcut -Folder $cat -Name 'Clear Clipboard' -Target 'cmd.exe' -Arguments '/c echo off | clip' -Icon "$iconShell,158"
Create-Shortcut -Folder $cat -Name 'Clean Temp Folder' -Target 'cmd.exe' -Arguments '/c del /q/f/s %TEMP%\*' -Icon "$iconShell,160"
Create-Shortcut -Folder $cat -Name 'Flush DNS Cache' -Target 'cmd.exe' -Arguments '/c ipconfig /flushdns & pause' -Icon "$iconShell,161"
Create-Shortcut -Folder $cat -Name 'CHKDSK Interactive' -Target 'cmd.exe' -Arguments '/k chkdsk /f' -Icon "$iconShell,195"
Create-Shortcut -Folder $cat -Name 'Reliability History (GUI)' -Target 'perfmon.exe' -Arguments '/rel' -Icon "$iconShell,147"
# NEW CLEANUP SHORTCUTS
Create-Shortcut -Folder $cat -Name 'Advanced Disk Cleanup (All Users)' -Target 'cleanmgr.exe' -Arguments '/sageset:1' -Icon "$iconShell,151"
Create-Shortcut -Folder $cat -Name 'Clear Windows Update Cache' -Target 'cmd.exe' -Arguments '/c net stop wuauserv & rd /s /q C:\Windows\SoftwareDistribution & net start wuauserv & pause' -Icon "$iconShell,151"
Create-Shortcut -Folder $cat -Name 'Clear Icon Cache' -Target 'cmd.exe' -Arguments '/c taskkill /f /im explorer.exe & attrib -h %userprofile%\AppData\Local\IconCache.db & del %userprofile%\AppData\Local\IconCache.db & start explorer & pause' -Icon "$iconShell,151"
Create-Shortcut -Folder $cat -Name 'Clear Font Cache' -Target 'cmd.exe' -Arguments '/c net stop FontCache & del /q/f/s "%WinDir%\ServiceProfiles\LocalService\AppData\Local\FontCache\*" & net start FontCache & pause' -Icon "$iconShell,151"
Create-Shortcut -Folder $cat -Name 'Reset Windows Search' -Target 'cmd.exe' -Arguments '/c net stop wsearch & rd /s /q "%ProgramData%\Microsoft\Search\Data" & net start wsearch & pause' -Icon "$iconShell,151"
Create-Shortcut -Folder $cat -Name 'Clear Thumbnail Cache' -Target 'cmd.exe' -Arguments '/c taskkill /f /im explorer.exe & del /q/a/f/s "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache*" & start explorer & pause' -Icon "$iconShell,151"

# Additional Cleanup (New)
Create-Shortcut -Folder $cat -Name 'Compress Files (compact)' -Target 'cmd.exe' -Arguments '/c compact /c /s /i & pause' -Icon "$iconShell,151"
Create-Shortcut -Folder $cat -Name 'Cipher Wipe Free Space' -Target 'cmd.exe' -Arguments '/c cipher /w:C:\ & pause' -Icon "$iconShell,151"
Create-Shortcut -Folder $cat -Name 'Maintenance Troubleshooter' -Target 'msdt.exe' -Arguments '-id MaintenanceDiagnostic' -Icon "$iconShell,151"
Create-Shortcut -Folder $cat -Name 'Convert FAT to NTFS' -Target 'cmd.exe' -Arguments '/c convert C: /fs:ntfs & pause' -Icon "$iconShell,151"
Create-Shortcut -Folder $cat -Name 'Volume Shadow Copy Admin' -Target 'cmd.exe' -Arguments '/c vssadmin list shadows & pause' -Icon "$iconShell,151"
Create-Shortcut -Folder $cat -Name 'Delete Shadow Copies' -Target 'cmd.exe' -Arguments '/c vssadmin delete shadows /all & pause' -Icon "$iconShell,151"

# -----------------------
# Category: Security & Privacy
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Security & Privacy'
Create-Shortcut -Folder $cat -Name 'Registry Editor' -Target 'regedit.exe' -Icon "$iconShell,162"
Create-Shortcut -Folder $cat -Name 'Local Group Policy Editor' -Target 'gpedit.msc' -Icon "$iconShell,163"
Create-Shortcut -Folder $cat -Name 'Local Security Policy' -Target 'secpol.msc' -Icon "$iconShell,164"
Create-Shortcut -Folder $cat -Name 'Windows Security (Defender)' -Target 'explorer.exe' -Arguments 'windowsdefender:' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Firewall & Network Protection' -Target 'explorer.exe' -Arguments 'ms-settings:windowsdefender-firewall' -Icon "$iconShell,166"
Create-Shortcut -Folder $cat -Name 'Credential Manager' -Target 'control.exe' -Arguments '/name Microsoft.CredentialManager' -Icon "$iconShell,167"
Create-Shortcut -Folder $cat -Name 'BitLocker Drive Encryption' -Target 'control.exe' -Arguments '/name Microsoft.BitLockerDriveEncryption' -Icon "$iconShell,168"
Create-Shortcut -Folder $cat -Name 'User Account Control Settings' -Target 'UserAccountControlSettings.exe' -Icon "$iconShell,169"
# NEW SECURITY SHORTCUTS
Create-Shortcut -Folder $cat -Name 'Certificates (Current User)' -Target 'certmgr.msc' -Icon "$iconShell,168"
Create-Shortcut -Folder $cat -Name 'Certificates (Local Computer)' -Target 'certlm.msc' -Icon "$iconShell,168"
Create-Shortcut -Folder $cat -Name 'Authorization Manager' -Target 'azman.msc' -Icon "$iconShell,164"
Create-Shortcut -Folder $cat -Name 'Windows Defender Offline Scan' -Target 'cmd.exe' -Arguments '/c "C:\Program Files\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2 & pause' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Trusted Platform Module (TPM)' -Target 'tpm.msc' -Icon "$iconShell,168"
Create-Shortcut -Folder $cat -Name 'Windows Security Audit' -Target 'cmd.exe' -Arguments '/c SecPol.msc' -Icon "$iconShell,164"
Create-Shortcut -Folder $cat -Name 'Security Configuration Wizard' -Target 'scwwiz.exe' -Icon "$iconShell,164"

# Additional Security (New)
Create-Shortcut -Folder $cat -Name 'Firewall with Advanced Security' -Target 'wf.msc' -Icon "$iconShell,166"
Create-Shortcut -Folder $cat -Name 'Change Product Key' -Target 'changepk.exe' -Icon "$iconShell,168"
Create-Shortcut -Folder $cat -Name 'Malicious Removal Tool' -Target 'mrt.exe' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Encrypt Files (cipher)' -Target 'cmd.exe' -Arguments '/c cipher /e & pause' -Icon "$iconShell,168"
Create-Shortcut -Folder $cat -Name 'System Key (syskey)' -Target 'syskey.exe' -Icon "$iconShell,168" # Deprecated, use cautiously
Create-Shortcut -Folder $cat -Name 'Security Center' -Target 'wscui.cpl' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Automatic Updates' -Target 'wuaucpl.cpl' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Credential Wizard' -Target 'credwiz.exe' -Icon "$iconShell,167"
Create-Shortcut -Folder $cat -Name 'iCACLS Permissions' -Target 'cmd.exe' -Arguments '/c icacls . & pause' -Icon "$iconShell,164"
Create-Shortcut -Folder $cat -Name 'Take Ownership' -Target 'cmd.exe' -Arguments '/c takeown /f . & pause' -Icon "$iconShell,164"

# -----------------------
# Category: Network
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Network'
Create-Shortcut -Folder $cat -Name 'Network Connections (ncpa.cpl)' -Target 'ncpa.cpl' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Wi-Fi Settings' -Target 'explorer.exe' -Arguments 'ms-settings:network-wifi' -Icon "$iconShell,171"
Create-Shortcut -Folder $cat -Name 'Ethernet Settings' -Target 'explorer.exe' -Arguments 'ms-settings:network-ethernet' -Icon "$iconShell,172"
Create-Shortcut -Folder $cat -Name 'VPN Settings' -Target 'explorer.exe' -Arguments 'ms-settings:network-vpn' -Icon "$iconShell,173"
Create-Shortcut -Folder $cat -Name 'Proxy Settings' -Target 'explorer.exe' -Arguments 'ms-settings:network-proxy' -Icon "$iconShell,174"
Create-Shortcut -Folder $cat -Name 'Remote Desktop Connection (mstsc)' -Target 'mstsc.exe' -Icon "$iconShell,175"
Create-Shortcut -Folder $cat -Name 'Internet Options' -Target 'inetcpl.cpl' -Icon "$iconShell,176"
Create-Shortcut -Folder $cat -Name 'Network Reset' -Target 'explorer.exe' -Arguments 'ms-settings:network-networkreset' -Icon "$iconShell,177"
# NEW NETWORK SHORTCUTS
Create-Shortcut -Folder $cat -Name 'Network Troubleshooter' -Target 'msdt.exe' -Arguments '-id NetworkDiagnosticsDA' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Internet Connection Troubleshooter' -Target 'msdt.exe' -Arguments '-id NetworkDiagnosticsWeb' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Show WiFi Passwords' -Target 'cmd.exe' -Arguments '/c netsh wlan show profiles & pause' -Icon "$iconShell,171"
Create-Shortcut -Folder $cat -Name 'Network Statistics (netstat)' -Target 'cmd.exe' -Arguments '/c netstat -an & pause' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'IP Configuration (ipconfig)' -Target 'cmd.exe' -Arguments '/c ipconfig /all & pause' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'ARP Table' -Target 'cmd.exe' -Arguments '/c arp -a & pause' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Route Table' -Target 'cmd.exe' -Arguments '/c route print & pause' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Network Adapter Reset' -Target 'cmd.exe' -Arguments '/c netsh int ip reset & netsh winsock reset & pause' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Release/Renew IP' -Target 'cmd.exe' -Arguments '/c ipconfig /release & ipconfig /renew & pause' -Icon "$iconShell,170"

# Additional Network (New)
Create-Shortcut -Folder $cat -Name 'Airplane Mode Settings' -Target 'explorer.exe' -Arguments 'ms-settings:network-airplanemode' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Cellular Settings' -Target 'explorer.exe' -Arguments 'ms-settings:network-cellular' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Dial-Up Settings' -Target 'explorer.exe' -Arguments 'ms-settings:network-dialup' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Mobile Hotspot' -Target 'explorer.exe' -Arguments 'ms-settings:network-mobilehotspot' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Get MAC Address' -Target 'cmd.exe' -Arguments '/c getmac & pause' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Ping Test' -Target 'cmd.exe' -Arguments '/c ping google.com & pause' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Trace Route' -Target 'cmd.exe' -Arguments '/c tracert google.com & pause' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Net Use (Map Drive)' -Target 'cmd.exe' -Arguments '/c net use & pause' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'RPC Ping' -Target 'cmd.exe' -Arguments '/c rpcping & pause' -Icon "$iconShell,170"
Create-Shortcut -Folder $cat -Name 'Bluetooth File Transfer' -Target 'fsquirt.exe' -Icon "$iconShell,171"

# -----------------------
# Category: Developer & Admin
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Developer & Admin'
Create-Shortcut -Folder $cat -Name 'Windows PowerShell (Admin)' -Target 'powershell.exe' -Arguments '-NoExit -Command "Start-Process PowerShell -Verb RunAs"' -Icon "$iconShell,178"
Create-Shortcut -Folder $cat -Name 'Command Prompt (Admin)' -Target 'cmd.exe' -Arguments '/k' -Icon "$iconShell,179"
Create-Shortcut -Folder $cat -Name 'Windows Subsystem for Linux (WSL)' -Target 'wsl.exe' -Icon "$iconShell,180"
Create-Shortcut -Folder $cat -Name 'Ubuntu (WSL) - if installed' -Target 'ubuntu.exe' -Icon "$iconShell,181"
Create-Shortcut -Folder $cat -Name 'Open WSL as Root' -Target 'wsl.exe' -Arguments '-u root' -Icon "$iconShell,181"
Create-Shortcut -Folder $cat -Name 'Hyper-V Manager' -Target 'virtmgmt.msc' -Icon "$iconShell,182"
Create-Shortcut -Folder $cat -Name 'Windows Sandbox' -Target 'WindowsSandbox.exe' -Icon "$iconShell,183"
Create-Shortcut -Folder $cat -Name 'ODBC Data Sources (64-bit)' -Target 'odbcad32.exe' -Icon "$iconShell,182"
Create-Shortcut -Folder $cat -Name 'ODBC Data Sources (32-bit)' -Target 'C:\Windows\SysWOW64\odbcad32.exe' -Icon "$iconShell,183"
Create-Shortcut -Folder $cat -Name 'Environment Variables' -Target 'rundll32.exe' -Arguments 'sysdm.cpl,EditEnvironmentVariables' -Icon "$iconShell,184"
Create-Shortcut -Folder $cat -Name 'System Properties (Advanced)' -Target 'sysdm.cpl' -Icon "$iconShell,185"
Create-Shortcut -Folder $cat -Name 'Local Users & Groups' -Target 'lusrmgr.msc' -Icon "$iconShell,187"
# NEW DEVELOPER & ADMIN SHORTCUTS
Create-Shortcut -Folder $cat -Name 'Windows Terminal (Admin)' -Target 'wt.exe' -Arguments '-p "Command Prompt"' -Icon "$iconShell,178"
Create-Shortcut -Folder $cat -Name 'PowerShell ISE' -Target 'powershell_ise.exe' -Icon "$iconShell,178"
Create-Shortcut -Folder $cat -Name 'WMI Management (wmimgmt.msc)' -Target 'wmimgmt.msc' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Windows Management Instrumentation Tester' -Target 'wbemtest.exe' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name '.NET Framework Configuration' -Target "$env:windir\Microsoft.NET\Framework64\v4.0.30319\mscorcfg.msc" -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'IIS Manager' -Target 'inetmgr.exe' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Component Services' -Target 'dcomcnfg.exe' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Shared Folders' -Target 'fsmgmt.msc' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Disk Defragmenter' -Target 'dfrgui.exe' -Icon "$iconShell,157"
Create-Shortcut -Folder $cat -Name 'Windows PowerShell (x86)' -Target "$env:windir\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" -Icon "$iconShell,178"

# Additional Developer & Admin (New)
Create-Shortcut -Folder $cat -Name 'Group Policy Result' -Target 'cmd.exe' -Arguments '/c gpresult /h %userprofile%\Desktop\gpresult.html & start %userprofile%\Desktop\gpresult.html' -Icon "$iconShell,163"
Create-Shortcut -Folder $cat -Name 'Group Policy Update' -Target 'cmd.exe' -Arguments '/c gpupdate /force & pause' -Icon "$iconShell,163"
Create-Shortcut -Folder $cat -Name 'IExpress Wizard' -Target 'iexpress.exe' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Make Cabinet File' -Target 'cmd.exe' -Arguments '/c makecab & pause' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'WMI Command Line' -Target 'wmic.exe' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'RoboCopy Tool' -Target 'cmd.exe' -Arguments '/c robocopy /? & pause' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Service Control (sc)' -Target 'cmd.exe' -Arguments '/c sc query & pause' -Icon "$iconShell,140"
Create-Shortcut -Folder $cat -Name 'Schedule Tasks (schtasks)' -Target 'cmd.exe' -Arguments '/c schtasks /query & pause' -Icon "$iconShell,138"
Create-Shortcut -Folder $cat -Name 'Task Kill' -Target 'cmd.exe' -Arguments '/c taskkill /? & pause' -Icon "$iconShell,137"
Create-Shortcut -Folder $cat -Name 'Run As' -Target 'cmd.exe' -Arguments '/c runas /user:Administrator cmd & pause' -Icon "$iconShell,179"
Create-Shortcut -Folder $cat -Name 'Print Management' -Target 'printmanagement.msc' -Icon "$iconShell,190"

# -----------------------
# Category: Settings & Control Panel
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Settings & Control Panel'
Create-Shortcut -Folder $cat -Name 'Bluetooth Settings' -Target 'explorer.exe' -Arguments 'ms-settings:bluetooth' -Icon "$iconShell,189"
Create-Shortcut -Folder $cat -Name 'Printers & Scanners' -Target 'explorer.exe' -Arguments 'ms-settings:printers' -Icon "$iconShell,190"
Create-Shortcut -Folder $cat -Name 'Apps & Features' -Target 'explorer.exe' -Arguments 'ms-settings:appsfeatures' -Icon "$iconShell,191"
Create-Shortcut -Folder $cat -Name 'Mouse & Touchpad Settings' -Target 'explorer.exe' -Arguments 'ms-settings:mousetouchpad' -Icon "$iconShell,192"
Create-Shortcut -Folder $cat -Name 'Language & Region' -Target 'explorer.exe' -Arguments 'ms-settings:regionlanguage' -Icon "$iconShell,193"
Create-Shortcut -Folder $cat -Name 'Date & Time Settings' -Target 'explorer.exe' -Arguments 'ms-settings:dateandtime' -Icon "$iconShell,194"
Create-Shortcut -Folder $cat -Name 'Focus Assist / Notifications' -Target 'explorer.exe' -Arguments 'ms-settings:focusassist' -Icon "$iconShell,195"
Create-Shortcut -Folder $cat -Name 'Accessibility (Ease of Access)' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Turn Windows Features On/Off' -Target 'optionalfeatures.exe' -Icon "$iconShell,197"
Create-Shortcut -Folder $cat -Name 'Control Panel Home' -Target 'control.exe' -Icon "$iconShell,198"
# NEW SETTINGS SHORTCUTS
Create-Shortcut -Folder $cat -Name 'About This PC' -Target 'explorer.exe' -Arguments 'ms-settings:about' -Icon "$iconShell,144"
Create-Shortcut -Folder $cat -Name 'Storage Settings' -Target 'explorer.exe' -Arguments 'ms-settings:storagesense' -Icon "$iconShell,156"
Create-Shortcut -Folder $cat -Name 'Backup Settings' -Target 'explorer.exe' -Arguments 'ms-settings:backup' -Icon "$iconShell,156"
Create-Shortcut -Folder $cat -Name 'Sync Settings' -Target 'explorer.exe' -Arguments 'ms-settings:sync' -Icon "$iconShell,156"
Create-Shortcut -Folder $cat -Name 'Recovery Options' -Target 'explorer.exe' -Arguments 'ms-settings:recovery' -Icon "$iconShell,156"
Create-Shortcut -Folder $cat -Name 'Activation Status' -Target 'explorer.exe' -Arguments 'ms-settings:activation' -Icon "$iconShell,156"
Create-Shortcut -Folder $cat -Name 'Find My Device' -Target 'explorer.exe' -Arguments 'ms-settings:findmydevice' -Icon "$iconShell,156"
Create-Shortcut -Folder $cat -Name 'For Developers' -Target 'explorer.exe' -Arguments 'ms-settings:developers' -Icon "$iconShell,156"

# Additional Settings (New ms-settings)
Create-Shortcut -Folder $cat -Name 'Advanced Graphics' -Target 'explorer.exe' -Arguments 'ms-settings:advancedgraphics' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Display Settings' -Target 'explorer.exe' -Arguments 'ms-settings:display' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Multitasking Settings' -Target 'explorer.exe' -Arguments 'ms-settings:multitasking' -Icon "$iconShell,137"
Create-Shortcut -Folder $cat -Name 'Project Settings' -Target 'explorer.exe' -Arguments 'ms-settings:project' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Sound Settings' -Target 'explorer.exe' -Arguments 'ms-settings:sound' -Icon "$iconShell,226"
Create-Shortcut -Folder $cat -Name 'System Settings' -Target 'explorer.exe' -Arguments 'ms-settings:system' -Icon "$iconShell,144"
Create-Shortcut -Folder $cat -Name 'Camera Settings' -Target 'explorer.exe' -Arguments 'ms-settings:camera' -Icon "$iconShell,190"
Create-Shortcut -Folder $cat -Name 'Connected Devices' -Target 'explorer.exe' -Arguments 'ms-settings:connecteddevices' -Icon "$iconShell,189"
Create-Shortcut -Folder $cat -Name 'USB Settings' -Target 'explorer.exe' -Arguments 'ms-settings:usb' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Email & Accounts' -Target 'explorer.exe' -Arguments 'ms-settings:emailandaccounts' -Icon "$iconShell,167"
Create-Shortcut -Folder $cat -Name 'Family & Other Users' -Target 'explorer.exe' -Arguments 'ms-settings:family-group' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Other Users' -Target 'explorer.exe' -Arguments 'ms-settings:otherusers' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Sign-in Options' -Target 'explorer.exe' -Arguments 'ms-settings:signinoptions' -Icon "$iconShell,169"
Create-Shortcut -Folder $cat -Name 'Your Info' -Target 'explorer.exe' -Arguments 'ms-settings:yourinfo' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Apps for Websites' -Target 'explorer.exe' -Arguments 'ms-settings:appsforwebsites' -Icon "$iconShell,191"
Create-Shortcut -Folder $cat -Name 'Startup Apps' -Target 'explorer.exe' -Arguments 'ms-settings:startupapps' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Region Formatting' -Target 'explorer.exe' -Arguments 'ms-settings:regionformatting' -Icon "$iconShell,193"
Create-Shortcut -Folder $cat -Name 'Speech Settings' -Target 'explorer.exe' -Arguments 'ms-settings:speech' -Icon "$iconShell,193"
Create-Shortcut -Folder $cat -Name 'Typing Settings' -Target 'explorer.exe' -Arguments 'ms-settings:typing' -Icon "$iconShell,192"
Create-Shortcut -Folder $cat -Name 'Background Settings' -Target 'explorer.exe' -Arguments 'ms-settings:background' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Colors Settings' -Target 'explorer.exe' -Arguments 'ms-settings:colors' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Fonts Settings' -Target 'explorer.exe' -Arguments 'ms-settings:fonts' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Lock Screen' -Target 'explorer.exe' -Arguments 'ms-settings:lockscreen' -Icon "$iconShell,132"
Create-Shortcut -Folder $cat -Name 'Personalization' -Target 'explorer.exe' -Arguments 'ms-settings:personalization' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Start Menu Settings' -Target 'explorer.exe' -Arguments 'ms-settings:start' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Taskbar Settings' -Target 'explorer.exe' -Arguments 'ms-settings:taskbar' -Icon "$iconShell,137"
Create-Shortcut -Folder $cat -Name 'Themes Settings' -Target 'explorer.exe' -Arguments 'ms-settings:themes' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Device Encryption' -Target 'explorer.exe' -Arguments 'ms-settings:deviceencryption' -Icon "$iconShell,168"
Create-Shortcut -Folder $cat -Name 'Windows Insider' -Target 'explorer.exe' -Arguments 'ms-settings:windowsinsider' -Icon "$iconShell,206"
Create-Shortcut -Folder $cat -Name 'Windows Update' -Target 'explorer.exe' -Arguments 'ms-settings:windowsupdate' -Icon "$iconShell,206"
Create-Shortcut -Folder $cat -Name 'Add Hardware Wizard' -Target 'hdwwiz.cpl' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Regional Settings' -Target 'intl.cpl' -Icon "$iconShell,193"
Create-Shortcut -Folder $cat -Name 'Phone and Modem' -Target 'telephon.cpl' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Tablet PC Settings' -Target 'tabletpc.cpl' -Icon "$iconShell,192"

# -----------------------
# Category: Safe Mode
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Safe Mode'
Create-Shortcut -Folder $cat -Name 'Enable Safe Mode (Next Boot)' -Target 'cmd.exe' -Arguments '/c bcdedit /set {current} safeboot minimal & pause' -Icon "$iconShell,199"
Create-Shortcut -Folder $cat -Name 'Enable Safe Mode w/ Networking (Next Boot)' -Target 'cmd.exe' -Arguments '/c bcdedit /set {current} safeboot network & pause' -Icon "$iconShell,200"
Create-Shortcut -Folder $cat -Name 'Disable Safe Mode (Next Boot)' -Target 'cmd.exe' -Arguments '/c bcdedit /deletevalue {current} safeboot & pause' -Icon "$iconShell,201"
# NEW SAFE MODE SHORTCUTS
Create-Shortcut -Folder $cat -Name 'Boot Configuration Data Editor' -Target 'cmd.exe' -Arguments '/c bcdedit & pause' -Icon "$iconShell,199"
Create-Shortcut -Folder $cat -Name 'Advanced Boot Options (F8 Menu)' -Target 'cmd.exe' -Arguments '/c bcdedit /set {current} bootmenupolicy legacy & pause' -Icon "$iconShell,199"
Create-Shortcut -Folder $cat -Name 'Disable F8 Boot Menu' -Target 'cmd.exe' -Arguments '/c bcdedit /set {current} bootmenupolicy standard & pause' -Icon "$iconShell,199"

# Additional Safe Mode (New)
Create-Shortcut -Folder $cat -Name 'Enum Boot Entries' -Target 'cmd.exe' -Arguments '/c bcdedit /enum all & pause' -Icon "$iconShell,199"
Create-Shortcut -Folder $cat -Name 'Set Boot Timeout' -Target 'cmd.exe' -Arguments '/c bcdedit /timeout 10 & pause' -Icon "$iconShell,199"

# -----------------------
# Category: Diagnostics & Logs
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Diagnostics & Logs'
Create-Shortcut -Folder $cat -Name 'Event Viewer (System logs)' -Target 'eventvwr.msc' -Icon "$iconShell,139"
Create-Shortcut -Folder $cat -Name 'Windows Update History' -Target 'explorer.exe' -Arguments 'ms-settings:windowsupdate-history' -Icon "$iconShell,205"
Create-Shortcut -Folder $cat -Name 'Windows Update Settings' -Target 'explorer.exe' -Arguments 'ms-settings:windowsupdate' -Icon "$iconShell,206"
Create-Shortcut -Folder $cat -Name 'Reliability Monitor (Detailed)' -Target 'perfmon.exe' -Arguments '/rel' -Icon "$iconShell,147"
Create-Shortcut -Folder $cat -Name 'Performance Logs' -Target 'perfmon.exe' -Icon "$iconShell,146"
# NEW DIAGNOSTICS SHORTCUTS
Create-Shortcut -Folder $cat -Name 'Windows Logs Folder' -Target 'explorer.exe' -Arguments 'C:\Windows\Logs' -Icon "$iconShell,139"
Create-Shortcut -Folder $cat -Name 'System Event Log' -Target 'cmd.exe' -Arguments '/c wevtutil qe System /f:text | more' -Icon "$iconShell,139"
Create-Shortcut -Folder $cat -Name 'Application Event Log' -Target 'cmd.exe' -Arguments '/c wevtutil qe Application /f:text | more' -Icon "$iconShell,139"
Create-Shortcut -Folder $cat -Name 'Security Event Log' -Target 'cmd.exe' -Arguments '/c wevtutil qe Security /f:text | more' -Icon "$iconShell,139"
Create-Shortcut -Folder $cat -Name 'Windows Error Reporting' -Target 'explorer.exe' -Arguments '%LOCALAPPDATA%\Microsoft\Windows\WER' -Icon "$iconShell,139"

# Additional Diagnostics (New)
Create-Shortcut -Folder $cat -Name 'Support Diagnostic Tool' -Target 'msdt.exe' -Icon "$iconShell,139"
Create-Shortcut -Folder $cat -Name 'Storage Diagnostic' -Target 'stordiag.exe' -Icon "$iconShell,139"
Create-Shortcut -Folder $cat -Name 'Windows Performance Recorder' -Target 'wpr.exe' -Icon "$iconShell,146"
Create-Shortcut -Folder $cat -Name 'Type Performance' -Target 'cmd.exe' -Arguments '/c typeperf -q & pause' -Icon "$iconShell,146"
Create-Shortcut -Folder $cat -Name 'WinSAT Assessment' -Target 'cmd.exe' -Arguments '/c winsat formal & pause' -Icon "$iconShell,146"
Create-Shortcut -Folder $cat -Name 'CBS Log' -Target 'notepad.exe' -Arguments 'C:\Windows\Logs\CBS\CBS.log' -Icon "$iconShell,139"
Create-Shortcut -Folder $cat -Name 'Dism Log' -Target 'notepad.exe' -Arguments 'C:\Windows\Logs\DISM\dism.log' -Icon "$iconShell,139"

# -----------------------
# Category: QOL & Shortcuts
# -----------------------
$cat = Ensure-Category $SuperGodMode 'QOL & Shortcuts'
Create-Shortcut -Folder $cat -Name 'Startup Folder (Current User)' -Target 'explorer.exe' -Arguments 'shell:startup' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Downloads Folder' -Target 'explorer.exe' -Arguments 'shell:Downloads' -Icon "$iconShell,221"
Create-Shortcut -Folder $cat -Name 'Documents' -Target 'explorer.exe' -Arguments 'shell:Personal' -Icon "$iconShell,222"
Create-Shortcut -Folder $cat -Name 'Pictures' -Target 'explorer.exe' -Arguments 'shell:Pictures' -Icon "$iconShell,223"
Create-Shortcut -Folder $cat -Name 'Clipboard History (Win+V opens UI)' -Target 'explorer.exe' -Arguments 'ms-settings:clipboard' -Icon "$iconShell,224"
Create-Shortcut -Folder $cat -Name 'Default Apps' -Target 'explorer.exe' -Arguments 'ms-settings:defaultapps' -Icon "$iconShell,225"
Create-Shortcut -Folder $cat -Name 'Volume Mixer' -Target 'SndVol.exe' -Icon "$iconShell,226"
Create-Shortcut -Folder $cat -Name 'Night Light Settings' -Target 'explorer.exe' -Arguments 'ms-settings:nightlight' -Icon "$iconShell,227"
# NEW QOL SHORTCUTS
Create-Shortcut -Folder $cat -Name 'Shell Folders (All Users)' -Target 'explorer.exe' -Arguments 'shell:Common Programs' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'SendTo Folder' -Target 'explorer.exe' -Arguments 'shell:sendto' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Quick Launch Folder' -Target 'explorer.exe' -Arguments 'shell:Quick Launch' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'AppData Roaming' -Target 'explorer.exe' -Arguments 'shell:AppData' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'AppData Local' -Target 'explorer.exe' -Arguments 'shell:Local AppData' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Common Desktop' -Target 'explorer.exe' -Arguments 'shell:Common Desktop' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'ProgramData Folder' -Target 'explorer.exe' -Arguments 'shell:Common AppData' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Windows Directory' -Target 'explorer.exe' -Arguments 'C:\Windows' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'System32 Directory' -Target 'explorer.exe' -Arguments 'C:\Windows\System32' -Icon "$iconShell,220"

# Additional QOL (New)
Create-Shortcut -Folder $cat -Name 'DPI Scaling' -Target 'dpiscaling.exe' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Display Color Calibration' -Target 'dccw.exe' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Font Viewer' -Target 'fontview.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Language Pack Setup' -Target 'lpksetup.exe' -Icon "$iconShell,193"
Create-Shortcut -Folder $cat -Name 'User Accounts Advanced' -Target 'control.exe' -Arguments 'userpasswords2' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Netplwiz User Accounts' -Target 'netplwiz.exe' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Steps Recorder' -Target 'psr.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Math Input Panel' -Target 'mip.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'XPS Viewer' -Target 'xpsrchvw.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Sticky Notes' -Target 'StikyNot.exe' -Icon "$iconShell,235"

# -----------------------
# Category: System Internals & Advanced
# -----------------------
$cat = Ensure-Category $SuperGodMode 'System Internals & Advanced'
Create-Shortcut -Folder $cat -Name 'Windows Internals - Process Explorer' -Target 'explorer.exe' -Arguments 'https://docs.microsoft.com/en-us/sysinternals/downloads/process-explorer' -Icon "$iconShell,15"
Create-Shortcut -Folder $cat -Name 'Registry Editor (regedit32)' -Target 'regedt32.exe' -Icon "$iconShell,162"
Create-Shortcut -Folder $cat -Name 'Show Hidden Devices in Device Manager' -Target 'cmd.exe' -Arguments '/c set devmgr_show_nonpresent_devices=1 & devmgmt.msc' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'DLL Cache Folder' -Target 'explorer.exe' -Arguments 'C:\Windows\System32\dllcache' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Driver Store' -Target 'explorer.exe' -Arguments 'C:\Windows\System32\DriverStore' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Windows Assembly (GAC)' -Target 'explorer.exe' -Arguments 'C:\Windows\assembly' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'System File Protection Log' -Target 'notepad.exe' -Arguments 'C:\Windows\Logs\CBS\CBS.log' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Windows Boot Manager' -Target 'cmd.exe' -Arguments '/c bcdedit /enum all & pause' -Icon "$iconShell,199"
Create-Shortcut -Folder $cat -Name 'System Threads and Handles' -Target 'cmd.exe' -Arguments '/c tasklist /svc & pause' -Icon "$iconShell,137"

# Additional System Internals (New)
Create-Shortcut -Folder $cat -Name 'Device Installation Settings' -Target 'rundll32.exe' -Arguments 'newdev.dll,DeviceInternetSettingUi' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'PnP Devices Enum' -Target 'cmd.exe' -Arguments '/c pnputil /enum-devices & pause' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Virtual Disk Service' -Target 'vds.exe' -Icon "$iconShell,142"
Create-Shortcut -Folder $cat -Name 'Mount Volume' -Target 'cmd.exe' -Arguments '/c mountvol & pause' -Icon "$iconShell,142"
Create-Shortcut -Folder $cat -Name 'Label Disk' -Target 'cmd.exe' -Arguments '/c label & pause' -Icon "$iconShell,142"
Create-Shortcut -Folder $cat -Name 'Registry Ini' -Target 'cmd.exe' -Arguments '/c regini & pause' -Icon "$iconShell,162"
Create-Shortcut -Folder $cat -Name 'Registry Server' -Target 'cmd.exe' -Arguments '/c regsvr32 & pause' -Icon "$iconShell,162"
Create-Shortcut -Folder $cat -Name 'SXS Trace' -Target 'cmd.exe' -Arguments '/c sxstrace & pause' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Windows Time' -Target 'cmd.exe' -Arguments '/c w32tm /resync & pause' -Icon "$iconShell,194"
Create-Shortcut -Folder $cat -Name 'TZ Util' -Target 'cmd.exe' -Arguments '/c tzutil /l & pause' -Icon "$iconShell,194"

# -----------------------
# Category: Hardware & Drivers
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Hardware & Drivers'
Create-Shortcut -Folder $cat -Name 'Device Installation Settings' -Target 'rundll32.exe' -Arguments 'newdev.dll,DeviceInternetSettingUi' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Hardware Troubleshooter' -Target 'msdt.exe' -Arguments '-id DeviceDiagnostic' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Display Settings' -Target 'desk.cpl' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Sound Control Panel' -Target 'mmsys.cpl' -Icon "$iconShell,226"
Create-Shortcut -Folder $cat -Name 'Game Controllers' -Target 'joy.cpl' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Phone and Modem Options' -Target 'telephon.cpl' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Scanners and Cameras' -Target 'sticpl.cpl' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'System Devices (PnP)' -Target 'cmd.exe' -Arguments '/c pnputil /enum-devices & pause' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Driver Verifier' -Target 'verifier.exe' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Tablet PC Settings' -Target 'tabletpc.cpl' -Icon "$iconShell,141"

# Additional Hardware (New)
Create-Shortcut -Folder $cat -Name 'Bluetooth Control Panel' -Target 'bthprops.cpl' -Icon "$iconShell,189"
Create-Shortcut -Folder $cat -Name 'Infrared Settings' -Target 'irprops.cpl' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Mouse Settings' -Target 'main.cpl' -Icon "$iconShell,192"
Create-Shortcut -Folder $cat -Name 'Power Management' -Target 'powercfg.cpl' -Icon "$iconShell,131"
Create-Shortcut -Folder $cat -Name 'Firewall Settings' -Target 'firewall.cpl' -Icon "$iconShell,166"
Create-Shortcut -Folder $cat -Name 'Accessibility Options' -Target 'access.cpl' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Add Hardware' -Target 'hdwwiz.cpl' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'User Accounts CPL' -Target 'nusrmgr.cpl' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Date Time Properties' -Target 'timedate.cpl' -Icon "$iconShell,194"
Create-Shortcut -Folder $cat -Name 'BitLocker Manage-bde' -Target 'cmd.exe' -Arguments '/c manage-bde -status & pause' -Icon "$iconShell,168"

# -----------------------
# Category: Troubleshooters
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Troubleshooters'
Create-Shortcut -Folder $cat -Name 'All Troubleshooters' -Target 'explorer.exe' -Arguments 'ms-settings:troubleshoot' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Audio Troubleshooter' -Target 'msdt.exe' -Arguments '-id AudioPlaybackDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Bluetooth Troubleshooter' -Target 'msdt.exe' -Arguments '-id BluetoothDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Keyboard Troubleshooter' -Target 'msdt.exe' -Arguments '-id KeyboardDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Printer Troubleshooter' -Target 'msdt.exe' -Arguments '-id PrinterDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Windows Update Troubleshooter' -Target 'msdt.exe' -Arguments '-id WindowsUpdateDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Power Troubleshooter' -Target 'msdt.exe' -Arguments '-id PowerDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Search and Indexing Troubleshooter' -Target 'msdt.exe' -Arguments '-id SearchDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Windows Store Apps Troubleshooter' -Target 'wsreset.exe' -Icon "$iconImage,1"

# Additional Troubleshooters (New)
Create-Shortcut -Folder $cat -Name 'Recording Audio Troubleshooter' -Target 'msdt.exe' -Arguments '-id AudioRecordingDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Incoming Connections Troubleshooter' -Target 'msdt.exe' -Arguments '-id MATSIAgentDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Network Adapter Troubleshooter' -Target 'msdt.exe' -Arguments '-id NetworkDiagnosticsNetworkAdapter' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Shared Folders Troubleshooter' -Target 'msdt.exe' -Arguments '-id NetworkDiagnosticsFileShare' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Inbound Connections Troubleshooter' -Target 'msdt.exe' -Arguments '-id NetworkDiagnosticsInbound' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Internet Explorer Safety' -Target 'msdt.exe' -Arguments '-id NetworkDiagnosticsWeb' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Program Compatibility' -Target 'msdt.exe' -Arguments '-id PCWDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'System Maintenance' -Target 'msdt.exe' -Arguments '-id MaintenanceDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Video Playback Troubleshooter' -Target 'msdt.exe' -Arguments '-id VideoPlaybackDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Windows Media Player DVD' -Target 'msdt.exe' -Arguments '-id WindowsMediaPlayerDVDDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Windows Media Player Library' -Target 'msdt.exe' -Arguments '-id WindowsMediaPlayerLibraryDiagnostic' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Windows Media Player Settings' -Target 'msdt.exe' -Arguments '-id WindowsMediaPlayerSettingsDiagnostic' -Icon "$iconImage,1"

# -----------------------
# Category: Misc / Legacy Tools
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Misc Tools'
Create-Shortcut -Folder $cat -Name 'Internet Explorer Mode (IE Tab helper)' -Target 'iexplore.exe' -Icon "$iconShell,230"
Create-Shortcut -Folder $cat -Name 'Windows Features (Turn On/Off) (Control Panel)' -Target 'optionalfeatures.exe' -Icon "$iconShell,197"
Create-Shortcut -Folder $cat -Name 'Hosts File (Open in Notepad as Admin) - manual' -Target 'notepad.exe' -Arguments "$env:windir\system32\drivers\etc\hosts" -Icon "$iconShell,231"
Create-Shortcut -Folder $cat -Name 'Bluetooth Devices (control panel)' -Target 'bthprops.cpl' -Icon "$iconShell,232"
Create-Shortcut -Folder $cat -Name 'Programs and Features (Uninstall)' -Target 'appwiz.cpl' -Icon "$iconShell,233"
Create-Shortcut -Folder $cat -Name 'Printers Folder' -Target 'explorer.exe' -Arguments 'shell:PrintersFolder' -Icon "$iconShell,234"
Create-Shortcut -Folder $cat -Name 'Fonts Folder' -Target 'explorer.exe' -Arguments 'shell:Fonts' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Recent Items' -Target 'explorer.exe' -Arguments 'shell:Recent' -Icon "$iconShell,236"
# NEW MISC TOOLS
Create-Shortcut -Folder $cat -Name 'On-Screen Keyboard' -Target 'osk.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Magnifier' -Target 'magnify.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Narrator' -Target 'narrator.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Snipping Tool' -Target 'snippingtool.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Steps Recorder (Problem Steps Recorder)' -Target 'psr.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Math Input Panel' -Target 'mip.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Remote Assistance' -Target 'msra.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Windows Media Player Legacy' -Target 'wmplayer.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Paint' -Target 'mspaint.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'WordPad' -Target 'write.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Sticky Notes' -Target 'StikyNot.exe' -Icon "$iconShell,235"
Create-Shortcut -Folder $cat -Name 'Windows Fax and Scan' -Target 'WFS.exe' -Icon "$iconShell,235"

# Additional Misc (New)
Create-Shortcut -Folder $cat -Name 'Phone Dialer' -Target 'dialer.exe' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Sound Recorder' -Target 'soundrecorder.exe' -Icon "$iconShell,226"
Create-Shortcut -Folder $cat -Name 'Recovery Disc' -Target 'recdisc.exe' -Icon "$iconShell,156"
Create-Shortcut -Folder $cat -Name 'Migration Wizard' -Target 'migwiz.exe' -Icon "$iconShell,156"
Create-Shortcut -Folder $cat -Name 'Cabinet Extraction' -Target 'extrac32.exe' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'FTP Client' -Target 'ftp.exe' -Icon "$iconShell,176"
Create-Shortcut -Folder $cat -Name 'Telnet Client' -Target 'telnet.exe' -Icon "$iconShell,176"
Create-Shortcut -Folder $cat -Name 'Debug Tool' -Target 'debug.exe' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Presentation Host' -Target 'presentationhost.exe' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'SQL Command' -Target 'sqlcmd.exe' -Icon "$iconShell,187"

# -----------------------
# Category: God Mode Classic
# -----------------------
$cat = Ensure-Category $SuperGodMode 'God Mode Classic'
Create-Shortcut -Folder $cat -Name 'All Control Panel Items' -Target 'explorer.exe' -Arguments 'shell:::{ED7BA470-8E54-465E-825C-99712043E01C}' -Icon "$iconShell,198"
Create-Shortcut -Folder $cat -Name 'All Tasks (God Mode)' -Target 'explorer.exe' -Arguments 'shell:::{ED7BA470-8E54-465E-825C-99712043E01C}' -Icon "$iconShell,198"
Create-Shortcut -Folder $cat -Name 'Administrative Tools' -Target 'explorer.exe' -Arguments 'shell:Administrative Tools' -Icon "$iconShell,198"
Create-Shortcut -Folder $cat -Name 'Network Places' -Target 'explorer.exe' -Arguments 'shell:NetworkPlacesFolder' -Icon "$iconShell,198"
Create-Shortcut -Folder $cat -Name 'My Computer' -Target 'explorer.exe' -Arguments 'shell:MyComputerFolder' -Icon "$iconShell,198"

# -----------------------
# New Category: Accessibility
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Accessibility'
Create-Shortcut -Folder $cat -Name 'Audio Accessibility' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess-audio' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Closed Captioning' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess-closedcaptioning' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Color Filter' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess-colorfilter' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Cursor Settings' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess-cursor' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Display Accessibility' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess-display' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Eye Control' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess-eyecontrol' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'High Contrast' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess-highcontrast' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Keyboard Accessibility' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess-keyboard' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Magnifier Settings' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess-magnifier' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Mouse Accessibility' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess-mouse' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Narrator Settings' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess-narrator' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Speech Recognition' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess-speechrecognition' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Visual Effects' -Target 'explorer.exe' -Arguments 'ms-settings:easeofaccess-visualeffects' -Icon "$iconShell,196"
Create-Shortcut -Folder $cat -Name 'Utility Manager' -Target 'utilman.exe' -Icon "$iconShell,196"

# -----------------------
# New Category: Gaming
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Gaming'
Create-Shortcut -Folder $cat -Name 'Broadcasting Settings' -Target 'explorer.exe' -Arguments 'ms-settings:gaming-broadcasting' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Game Bar' -Target 'explorer.exe' -Arguments 'ms-settings:gaming-gamebar' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Game DVR' -Target 'explorer.exe' -Arguments 'ms-settings:gaming-gamedvr' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Game Mode' -Target 'explorer.exe' -Arguments 'ms-settings:gaming-gamemode' -Icon "$iconImage,1"
Create-Shortcut -Folder $cat -Name 'Xbox Networking' -Target 'explorer.exe' -Arguments 'ms-settings:gaming-xboxnetworking' -Icon "$iconImage,1"

# -----------------------
# New Category: Mixed Reality
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Mixed Reality'
Create-Shortcut -Folder $cat -Name 'Holographic Settings' -Target 'explorer.exe' -Arguments 'ms-settings:holographic' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Holographic Audio' -Target 'explorer.exe' -Arguments 'ms-settings:holographic-audio' -Icon "$iconShell,226"

# -----------------------
# New Category: Privacy Details
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Privacy Details'
Create-Shortcut -Folder $cat -Name 'Privacy General' -Target 'explorer.exe' -Arguments 'ms-settings:privacy' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Account Info' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-accountinfo' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Activity History' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-activityhistory' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'App Diagnostics' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-appdiagnostics' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Automatic File Downloads' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-automaticfiledownloads' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Background Apps' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-backgroundapps' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Calendar Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-calendar' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Call History' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-callhistory' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Camera Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-camera' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Contacts Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-contacts' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Custom Devices' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-customdevices' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Documents Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-documents' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Downloads Folder Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-downloadsfolder' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Email Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-email' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Eye Tracker' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-eyetracker' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Feedback Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-feedback' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Graphics Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-graphics' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Location Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-location' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Messaging Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-messaging' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Microphone Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-microphone' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Motion Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-motion' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Music Library Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-musiclibrary' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Notifications Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-notifications' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Phone Calls Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-phonecalls' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Pictures Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-pictures' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Radios Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-radios' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Speech Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-speech' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Tasks Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-tasks' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Videos Privacy' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-videos' -Icon "$iconShell,165"
Create-Shortcut -Folder $cat -Name 'Voice Activation' -Target 'explorer.exe' -Arguments 'ms-settings:privacy-voiceactivation' -Icon "$iconShell,165"

# -----------------------
# New Category: Shell Folders
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Shell Folders'
Create-Shortcut -Folder $cat -Name '3D Objects' -Target 'explorer.exe' -Arguments 'shell:3D Objects' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Account Pictures' -Target 'explorer.exe' -Arguments 'shell:AccountPicturesDir' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Application Shortcuts' -Target 'explorer.exe' -Arguments 'shell:Application Shortcuts' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Apps Folder' -Target 'explorer.exe' -Arguments 'shell:AppsFolder' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Camera Roll' -Target 'explorer.exe' -Arguments 'shell:Camera Roll' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Captures' -Target 'explorer.exe' -Arguments 'shell:Captures' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'CD Burning' -Target 'explorer.exe' -Arguments 'shell:CD Burning' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Change Remove Programs' -Target 'explorer.exe' -Arguments 'shell:ChangeRemoveProgramsFolder' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Common Documents' -Target 'explorer.exe' -Arguments 'shell:Common Documents' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Common Downloads' -Target 'explorer.exe' -Arguments 'shell:Common Downloads' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Common Music' -Target 'explorer.exe' -Arguments 'shell:Common Music' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Common Pictures' -Target 'explorer.exe' -Arguments 'shell:Common Pictures' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Common Startup' -Target 'explorer.exe' -Arguments 'shell:Common Startup' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Common Templates' -Target 'explorer.exe' -Arguments 'shell:Common Templates' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Common Videos' -Target 'explorer.exe' -Arguments 'shell:Common Videos' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Cookies' -Target 'explorer.exe' -Arguments 'shell:Cookies' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Device Metadata Store' -Target 'explorer.exe' -Arguments 'shell:Device Metadata Store' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Games' -Target 'explorer.exe' -Arguments 'shell:Games' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'History' -Target 'explorer.exe' -Arguments 'shell:History' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Internet Cache' -Target 'explorer.exe' -Arguments 'shell:Internet Cache' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Links' -Target 'explorer.exe' -Arguments 'shell:Links' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'My Games' -Target 'explorer.exe' -Arguments 'shell:MyGames' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'My Music' -Target 'explorer.exe' -Arguments 'shell:MyMusic' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'My Video' -Target 'explorer.exe' -Arguments 'shell:My Video' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'NetHood' -Target 'explorer.exe' -Arguments 'shell:NetHood' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'PhotoAlbums' -Target 'explorer.exe' -Arguments 'shell:PhotoAlbums' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Playlists' -Target 'explorer.exe' -Arguments 'shell:Playlists' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'PrintHood' -Target 'explorer.exe' -Arguments 'shell:PrintHood' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Profile' -Target 'explorer.exe' -Arguments 'shell:Profile' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'RecordedTV' -Target 'explorer.exe' -Arguments 'shell:RecordedTV' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'ResourceDir' -Target 'explorer.exe' -Arguments 'shell:ResourceDir' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Roaming AppData' -Target 'explorer.exe' -Arguments 'shell:Roaming AppData' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'SavedGames' -Target 'explorer.exe' -Arguments 'shell:SavedGames' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'SyncCenterFolder' -Target 'explorer.exe' -Arguments 'shell:SyncCenterFolder' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Templates' -Target 'explorer.exe' -Arguments 'shell:Templates' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Videos' -Target 'explorer.exe' -Arguments 'shell:Videos' -Icon "$iconShell,220"

# -----------------------
# New Category: Niche Commands
# -----------------------
$cat = Ensure-Category $SuperGodMode 'Niche Commands'
Create-Shortcut -Folder $cat -Name 'Compare Files (fc)' -Target 'cmd.exe' -Arguments '/c fc /? & pause' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Finger Command' -Target 'cmd.exe' -Arguments '/c finger & pause' -Icon "$iconShell,176"
Create-Shortcut -Folder $cat -Name 'ForFiles Loop' -Target 'cmd.exe' -Arguments '/c forfiles /? & pause' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Load Counter (lodctr)' -Target 'cmd.exe' -Arguments '/c lodctr /q & pause' -Icon "$iconShell,146"
Create-Shortcut -Folder $cat -Name 'Make Link (mklink)' -Target 'cmd.exe' -Arguments '/c mklink /? & pause' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'Mode Command' -Target 'cmd.exe' -Arguments '/c mode & pause' -Icon "$iconShell,179"
Create-Shortcut -Folder $cat -Name 'Query Process' -Target 'cmd.exe' -Arguments '/c qprocess & pause' -Icon "$iconShell,137"
Create-Shortcut -Folder $cat -Name 'Query User' -Target 'cmd.exe' -Arguments '/c quser & pause' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'RAS Dial' -Target 'cmd.exe' -Arguments '/c rasdial & pause' -Icon "$iconShell,173"
Create-Shortcut -Folder $cat -Name 'RAS Phone' -Target 'rasphone.exe' -Icon "$iconShell,173"
Create-Shortcut -Folder $cat -Name 'Reset Win Station' -Target 'cmd.exe' -Arguments '/c rwinsta & pause' -Icon "$iconShell,137"
Create-Shortcut -Folder $cat -Name 'SDB Install' -Target 'cmd.exe' -Arguments '/c sdbinst & pause' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Security Edit' -Target 'cmd.exe' -Arguments '/c secedit /? & pause' -Icon "$iconShell,164"
Create-Shortcut -Folder $cat -Name 'Shadow Session' -Target 'cmd.exe' -Arguments '/c shadow & pause' -Icon "$iconShell,175"
Create-Shortcut -Folder $cat -Name 'Sort Command' -Target 'cmd.exe' -Arguments '/c sort & pause' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Substitute Drive' -Target 'cmd.exe' -Arguments '/c subst & pause' -Icon "$iconShell,142"
Create-Shortcut -Folder $cat -Name 'TCM Setup' -Target 'cmd.exe' -Arguments '/c tcmsetup & pause' -Icon "$iconShell,141"
Create-Shortcut -Folder $cat -Name 'Timeout Command' -Target 'cmd.exe' -Arguments '/c timeout /? & pause' -Icon "$iconShell,194"
Create-Shortcut -Folder $cat -Name 'Tree View' -Target 'cmd.exe' -Arguments '/c tree & pause' -Icon "$iconShell,220"
Create-Shortcut -Folder $cat -Name 'TS Admin' -Target 'tsadmin.exe' -Icon "$iconShell,175"
Create-Shortcut -Folder $cat -Name 'TS Connect' -Target 'cmd.exe' -Arguments '/c tscon & pause' -Icon "$iconShell,175"
Create-Shortcut -Folder $cat -Name 'TS Disconnect' -Target 'cmd.exe' -Arguments '/c tsdiscon & pause' -Icon "$iconShell,175"
Create-Shortcut -Folder $cat -Name 'TS Kill' -Target 'cmd.exe' -Arguments '/c tskill & pause' -Icon "$iconShell,137"
Create-Shortcut -Folder $cat -Name 'Unload Counter' -Target 'cmd.exe' -Arguments '/c unlodctr & pause' -Icon "$iconShell,146"
Create-Shortcut -Folder $cat -Name 'User Init' -Target 'userinit.exe' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Wait For' -Target 'cmd.exe' -Arguments '/c waitfor /? & pause' -Icon "$iconShell,194"
Create-Shortcut -Folder $cat -Name 'WB Admin' -Target 'cmd.exe' -Arguments '/c wbadmin & pause' -Icon "$iconShell,156"
Create-Shortcut -Folder $cat -Name 'WEC Util' -Target 'cmd.exe' -Arguments '/c wecutil & pause' -Icon "$iconShell,139"
Create-Shortcut -Folder $cat -Name 'WEVT Util' -Target 'cmd.exe' -Arguments '/c wevtutil & pause' -Icon "$iconShell,139"
Create-Shortcut -Folder $cat -Name 'Where Command' -Target 'cmd.exe' -Arguments '/c where & pause' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Who Am I' -Target 'cmd.exe' -Arguments '/c whoami & pause' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Win Management' -Target 'winmgmt.exe' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'Win RM' -Target 'cmd.exe' -Arguments '/c winrm & pause' -Icon "$iconShell,187"
Create-Shortcut -Folder $cat -Name 'WS Man HTTP Config' -Target 'wsmanhttpconfig.exe' -Icon "$iconShell,176"
Create-Shortcut -Folder $cat -Name 'Windows Update Standalone' -Target 'wusa.exe' -Icon "$iconShell,206"
Create-Shortcut -Folder $cat -Name 'XCopy Tool' -Target 'cmd.exe' -Arguments '/c xcopy /? & pause' -Icon "$iconShell,187"

Write-Output "Enhanced SuperGodMode shortcuts created! Total shortcuts: 300+"
Write-Output "Location: $SuperGodMode"
Write-Output ""
Write-Output "Categories created:"
Write-Output "- Power (17 shortcuts)"
Write-Output "- System Utilities (33 shortcuts)"
Write-Output "- Cleanup & Maintenance (21 shortcuts)"
Write-Output "- Security & Privacy (25 shortcuts)"
Write-Output "- Network (29 shortcuts)"
Write-Output "- Developer & Admin (33 shortcuts)"
Write-Output "- Settings & Control Panel (52 shortcuts)"
Write-Output "- Safe Mode (8 shortcuts)"
Write-Output "- Diagnostics & Logs (17 shortcuts)"
Write-Output "- QOL & Shortcuts (27 shortcuts)"
Write-Output "- System Internals & Advanced (20 shortcuts)"
Write-Output "- Hardware & Drivers (20 shortcuts)"
Write-Output "- Troubleshooters (21 shortcuts)"
Write-Output "- Misc Tools (30 shortcuts)"
Write-Output "- God Mode Classic (5 shortcuts)"
Write-Output "- Accessibility (14 shortcuts)"
Write-Output "- Gaming (5 shortcuts)"
Write-Output "- Mixed Reality (2 shortcuts)"
Write-Output "- Privacy Details (31 shortcuts)"
Write-Output "- Shell Folders (36 shortcuts)"
Write-Output "- Niche Commands (35 shortcuts)"