# Seadista PowerShelli konsooli kodeering UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Küsi kasutajalt ees- ja perenimi
$firstName = Read-Host "Sisesta eesnimi"
$lastName = Read-Host "Sisesta perenimi"

# Kontrolli, et sisestatud väärtused sisaldavad ainult ladina tähti
if ($firstName -match "[^a-zA-Z]" -or $lastName -match "[^a-zA-Z]") {
    Write-Host "Viga: Nimi tohib sisaldada ainult ladina tähti!" -ForegroundColor Red
    exit 1
}

# Muuda väikesteks tähtedeks ja loo kasutajanimi
$firstName = $firstName.ToLower()
$lastName = $lastName.ToLower()
$username = "$firstName.$lastName"
$fullName = "$firstName $lastName"

# Kontrolli, kas kasutaja juba eksisteerib
if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
    Write-Host "Viga: Kasutaja '$username' on juba olemas!" -ForegroundColor Red
    exit 1
}

# Proovi kasutajat lisada ja püüa võimalikke vigu
try {
    New-LocalUser -Name $username -FullName $fullName -Password (ConvertTo-SecureString "Parool1!" -AsPlainText -Force) -Description "Automaatne kasutaja lisamine" -ErrorAction Stop
    Write-Host "Kasutaja '$username' loodud edukalt!" -ForegroundColor Green
} catch {
    Write-Host "Viga kasutaja loomisel: $_" -ForegroundColor Red
    exit 1
}

# Kontrolli käsu edukust
if ($?) {
    Write-Host "Käsk täideti edukalt." -ForegroundColor Green
} else {
    Write-Host "Käsk ebaõnnestus." -ForegroundColor Red
}

exit 0
