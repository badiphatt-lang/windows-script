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

Write-Host "Running Script..." -ForegroundColor Cyan

$choice = Read-Host "Create Restore Point before tweak? (Y/N)"

if ($choice -eq "Y" -or $choice -eq "y") {

    Write-Host "Preparing System Restore..." -ForegroundColor Yellow

    # เปิด System Protection
    Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue

    # ปรับพื้นที่ restore เป็น 5%
    vssadmin resize shadowstorage /for=C: /on=C: /maxsize=5% | Out-Null

    # ลบ restore point เก่า
    vssadmin delete shadows /for=C: /all /quiet

    Start-Sleep 2

    Write-Host "Creating Restore Point..." -ForegroundColor Yellow

    Checkpoint-Computer -Description "Gpedit X" -RestorePointType MODIFY_SETTINGS

    Write-Host "[✓] Restore Point Created : Gpedit X" -ForegroundColor Green

}
else {

    Write-Host "[✓] Skipped Restore Point" -ForegroundColor DarkGray

}

Write-Host "Creating Restore Point..." -ForegroundColor Yellow

Checkpoint-Computer -Description "Gpedit X" -RestorePointType MODIFY_SETTINGS

Write-Host "[✓] Restore Point Created : Gpedit X" -ForegroundColor Green

}
else {

Write-Host "[✓] Skipped Restore Point" -ForegroundColor DarkGray

}
Write-Host "Applying Lanman Server Tweaks..." -ForegroundColor Yellow

$path1 = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$path2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanServer"

New-Item -Path $path1 -Force | Out-Null
New-Item -Path $path2 -Force | Out-Null

New-ItemProperty -Path $path1 `
-Name "Smb2CipherSuiteOrder" `
-PropertyType MultiString `
-Value "AES_256_GCM","AES_256_GCM","AES_256_GCM","AES_256_GCM" `
-Force | Out-Null

New-ItemProperty -Path $path1 `
-Name "Smb2HonorCipherSuiteOrder" `
-PropertyType DWord `
-Value 1 `
-Force | Out-Null

Set-ItemProperty -Path $path2 `
-Name "HashPublicationForBranchCache" `
-Value 1

Set-ItemProperty -Path $path2 `
-Name "HashVersionSupportForBranchCache" `
-Value 3

New-ItemProperty -Path $path2 `
-Name "Smb2HonorCipherSuiteOrder" `
-PropertyType DWord `
-Value 1 `
-Force | Out-Null


New-ItemProperty -Path $path2 `
-Name "HashPublicationForBranchCache" `
-PropertyType DWord `
-Value 1 `
-Force | Out-Null

New-ItemProperty -Path $path2 `
-Name "HashVersionSupportForBranchCache" `
-PropertyType DWord `
-Value 1 `
-Force | Out-Null


# ===== CIPHER POLICY =====

$path3 = "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"

New-Item -Path $path3 -Force | Out-Null

New-ItemProperty -Path $path3 `
-Name "Functions" `
-PropertyType MultiString `
-Value "AES_256_GCM","AES_256_GCM","AES_256_GCM","AES_256_GCM" `
-Force | Out-Null

Write-Host "Lanman Server Tweaks Applied!" -ForegroundColor Green


Write-Host "Applying Lanman Workstation Tweaks..." -ForegroundColor Yellow

$path4 = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"

New-Item -Path $path4 -Force | Out-Null

New-ItemProperty -Path $path4 `
-Name "Smb2CipherSuiteOrder" `
-PropertyType MultiString `
-Value "AES_256_GCM","AES_256_GCM","AES_256_GCM","AES_256_GCM" `
-Force | Out-Null

New-ItemProperty -Path $path4 `
-Name "Smb2HonorCipherSuiteOrder" `
-PropertyType DWord `
-Value 1 `
-Force | Out-Null

Write-Host "Lanman Workstation Tweaks Applied!" -ForegroundColor Green


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
-Value 65536 `
-Force | Out-Null

New-ItemProperty -Path $qos `
-Name "NonBestEffortLimit" `
-PropertyType DWord `
-Value 0 `
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

Write-Host "All Tweaks Gpedit X Successfully!" -ForegroundColor Green
