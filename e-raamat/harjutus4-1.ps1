# Küsime kasutajalt kaks arvu
[int]$arv1 = Read-Host "Sisesta esimene arv"
[int]$arv2 = Read-Host "Sisesta teine arv"

# Kontrollime, kumb arv on suurem
if ($arv1 -gt $arv2) {
    Write-Host "Suurem arv on: $arv1" -ForegroundColor Green
} elseif ($arv2 -gt $arv1) {
    Write-Host "Suurem arv on: $arv2" -ForegroundColor Green
} else {
    Write-Host "Mõlemad arvud on võrdsed: $arv1" -ForegroundColor Yellow
}
