$pass = Read-Host "Enter Password"

if ($pass -ne "dotexe") {
Write-Host "Wrong Password"
exit
}

Write-Host "Running Script..."

powercfg -setactive SCHEME_MIN
netsh int tcp set global autotuninglevel=disabled
