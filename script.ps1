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

# ===== Tweaks =====

Write-Host "Applying Lanman Server Tweaks..." -ForegroundColor Yellow

# ===== REAL SYSTEM VALUE =====
$val = @("AES_256_GCM","AES_256_GCM","AES_256_GCM","AES_256_GCM")

New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Force | Out-Null

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
-Name "Smb2CipherSuiteOrder" `
-Value $val

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
-Name "Smb2HonorCipherSuiteOrder" `
-Type DWord `
-Value 1


# ===== POLICY VALUE (FOR GPEDIT) =====
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanServer" -Force | Out-Null

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanServer" `
-Name "HashPublicationForBranchCache" `
-Type DWord `
-Value 1

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanServer" `
-Name "HashVersionSupportForBranchCache" `
-Type DWord `
-Value 1


# ===== CIPHER POLICY =====
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -Force | Out-Null

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" `
-Name "Functions" `
-Value "AES_256_GCM,AES_256_GCM,AES_256_GCM,AES_256_GCM"


Write-Host "Lanman Server Tweaks Applied!" -ForegroundColor Green

gpupdate /force
# ==================

Write-Host "Ok." -ForegroundColor Green

gpupdate /force
