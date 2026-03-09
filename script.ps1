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

$val = @("AES_256_GCM","AES_256_GCM","AES_256_GCM","AES_256_GCM")

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
-Name "Smb2CipherSuiteOrder" `
-Value $val

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
-Name "Smb2HonorCipherSuiteOrder" `
-Type DWord `
-Value 1

New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanServer" -Force | Out-Null

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanServer" `
-Name "HashPublicationForBranchCache" `
-Type DWord `
-Value 1

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanServer" `
-Name "HashVersionSupportForBranchCache" `
-Type DWord `
-Value 1

Write-Host "Lanman Server Tweaks Applied" -ForegroundColor Green
# ==================

Write-Host "Ok." -ForegroundColor Green

gpupdate /force
