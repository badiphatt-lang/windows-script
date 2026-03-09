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

# เปิดการแสดงผลกลับ
$InformationPreference = "Continue"

Write-Host "Gpedit X Successfully!" -ForegroundColor Gree
