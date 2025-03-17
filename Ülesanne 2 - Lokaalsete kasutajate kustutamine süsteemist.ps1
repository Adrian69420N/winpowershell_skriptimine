# Seadista PowerShelli konsooli kodeering UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Küsi kasutajalt ees- ja perenimi
$firstName = Read-Host "Sisesta kustutatava kasutaja eesnimi"
$lastName = Read-Host "Sisesta kustutatava kasutaja perenimi"

# Kontrolli, et sisestatud väärtused sisaldavad ainult ladina tähti
if ($firstName -match "[^a-zA-Z]" -or $lastName -match "[^a-zA-Z]") {
    Write-Host "Viga: Nimi tohib sisaldada ainult ladina tähti!" -ForegroundColor Red
    exit 1
}

# Muuda väikesteks tähtedeks ja loo kasutajanimi
$firstName = $firstName.ToLower()
$lastName = $lastName.ToLower()
$username = "$firstName.$lastName"

# Kontrolli, kas kasutaja eksisteerib
if (!(Get-LocalUser -Name $username -ErrorAction SilentlyContinue)) {
    Write-Host "Viga: Kasutajat '$username' ei leitud süsteemist!" -ForegroundColor Red
    exit 1
}

# Proovi kasutajat kustutada ja püüa võimalikke vigu
try {
    Remove-LocalUser -Name $username -ErrorAction Stop
    Write-Host "Kasutaja '$username' kustutatud edukalt!" -ForegroundColor Green
} catch {
    Write-Host "Viga kasutaja kustutamisel: $_" -ForegroundColor Red
    exit 1
}

# Kontrolli käsu edukust
if ($?) {
    Write-Host "Käsk täideti edukalt." -ForegroundColor Green
} else {
    Write-Host "Käsk ebaõnnestus." -ForegroundColor Red
}

exit 0
