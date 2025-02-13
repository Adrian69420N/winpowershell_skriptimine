# Kuvame riikide nimekirja
Write-Host "`nVali riik:" -ForegroundColor Cyan
Write-Host "1: Eesti"
Write-Host "2: Soome"
Write-Host "3: Rootsi"
Write-Host "4: Läti"

# Küsime kasutajalt valikut
$valik = Read-Host "Sisesta valiku number"

# Kuvame vastava riigi pealinna
if ($valik -eq "1") {
    Write-Host "Eesti pealinn on Tallinn." -ForegroundColor Green
} elseif ($valik -eq "2") {
    Write-Host "Soome pealinn on Helsingi." -ForegroundColor Green
} elseif ($valik -eq "3") {
    Write-Host "Rootsi pealinn on Stockholm." -ForegroundColor Green
} elseif ($valik -eq "4") {
    Write-Host "Läti pealinn on Riia." -ForegroundColor Green
} else {
    Write-Host "Vigane valik! Palun vali number 1-4." -ForegroundColor Red
}
