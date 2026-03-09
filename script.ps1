# Check admin
if (-not ([Security.Principal.WindowsPrincipal] 
[Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
[Security.Principal.WindowsBuiltInRole] "Administrator"))
{
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -Command `"irm https://raw.githubusercontent.com/badiphat-lang/windows-script/main/script.ps1 | iex`"" -Verb RunAs
exit
}

$securePass = Read-Host "Enter Password" -AsSecureString
$pass = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
[Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePass)
)

if ($pass -ne "dotexe") {
Write-Host "Wrong Password"
exit
}

Write-Host "Running Script..."

powercfg -setactive SCHEME_MIN
netsh int tcp set global autotuninglevel=disabled

Write-Host "Ok."
