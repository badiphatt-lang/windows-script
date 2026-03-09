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

# ปิดการแสดงผลทั้งหมด
$InformationPreference = "SilentlyContinue"

Write-Host "Successfully." -ForegroundColor Yellow

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

Write-Host "Successfully." -ForegroundColor Yellow

$path4 = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"

New-Item -Path $path4 -Force | Out-Null

New-ItemProperty -Path $path4 `
-Name "Smb2HonorCipherSuiteOrder" `
-PropertyType DWord `
-Value 1 `
-Force | Out-Null

Write-Host "Successfully." -ForegroundColor Green


Write-Host "Successfully." -ForegroundColor Yellow

$privacy = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"

New-Item -Path $privacy -Force | Out-Null

New-ItemProperty -Path $privacy `
-Name "LetAppsRunInBackground" `
-PropertyType DWord `
-Value 2 `
-Force | Out-Null

Write-Host "Successfully." -ForegroundColor Green


# เปิดการแสดงผลกลับ
$InformationPreference = "Continue"

Write-Host "All Tweaks Gpedit X Successfully!" -ForegroundColor Green
