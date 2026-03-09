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

reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v Smb2CipherSuiteOrder /t REG_MULTI_SZ /d "AES_256_GCM\0AES_256_GCM\0AES_256_GCM\0AES_256_GCM\0" /f

reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v Smb2HonorCipherSuiteOrder /t REG_DWORD /d 1 /f

reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LanmanServer" /v HashPublicationForBranchCache /t REG_DWORD /d 1 /f

reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LanmanServer" /v HashVersionSupportForBranchCache /t REG_DWORD /d 1 /fป
# ==================

Write-Host "Ok." -ForegroundColor Green
