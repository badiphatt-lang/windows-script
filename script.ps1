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


Write-Host "Applying Lanman Server Tweaks..." -ForegroundColor Yellow


$path1 = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"

New-Item -Path $path1 -Force | Out-Null

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


# ===== GPEDIT POLICY VALUES =====

$path2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanServer"

New-Item -Path $path2 -Force | Out-Null

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

gpupdate /force
