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

# ===== SYSTEM VALUES =====

$path1 = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"

New-Item -Path $path1 -Force | Out-Null

New-ItemProperty -Path $path1 `
-Name "Smb2CipherSuiteOrder" `
-PropertyType String `
-Value "AES_256_GCM,AES_256_GCM,AES_256_GCM,AES_256_GCM" `
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
-PropertyType String `
-Value "AES_256_GCM,AES_256_GCM,AES_256_GCM,AES_256_GCM" `
-Force | Out-Null


Write-Host "Lanman Server Tweaks Applied!" -ForegroundColor Green

gpupdate /force
