$securePass = Read-Host "Enter Password" -AsSecureString
$pass = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePass)
)

if ($pass -ne "dotexe") {
    Write-Host "Warning Password"
    exit
}

Write-Host "Running Script..."

powercfg -setactive SCHEME_MIN
netsh int tcp set global autotuninglevel=disabled

Write-Host "Ok."
