# 1. Loo kaust, kui see puudub
$kaust = "C:\Temp\Test"
if (-Not (Test-Path $kaust)) {
    New-Item -ItemType Directory -Path $kaust -Force
    Write-Host "Kaust '$kaust' on loodud!" -ForegroundColor Green
}

# 2. Loo test-CSV-failid
@"
Name,Value
Test1,100
Test2,200
"@ | Set-Content -Path "$kaust\test1.csv" -Encoding UTF8

@"
Name,Amount
Data1,50
Data2,150
"@ | Set-Content -Path "$kaust\test2.csv" -Encoding UTF8

@"
Name,Age
John,8
Joe,12
Mary,7
Tom,15
Lily,16
Emily,9
"@ | Set-Content -Path "$kaust\students.csv" -Encoding UTF8

Write-Host "Kõik test-CSV-failid on loodud!" -ForegroundColor Cyan
