<#
.SYNOPSIS
    Loob uue lokaalse kasutaja ees- ja perenime alusel.
.DESCRIPTION
    Skript küsib kasutaja ees- ja perekonnanime, genereerib kasutajanime ning
    lisab lokaalse kasutaja, kui seda veel pole. Väljastab kasutajasõbraliku info.
.NOTES
    Vajab administraatoriõigusi ja UTF-8 tuge.
#>

# --> UTF-8 toetus täpitähtede jaoks
chcp 65001 > $null
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "=== Lokaalse kasutaja loomine ===" -ForegroundColor Cyan

# --> Küsi kasutaja ees- ja perenimi
$firstName = Read-Host "Sisesta eesnimi"
$lastName  = Read-Host "Sisesta perenimi"

# --> Kontroll: tühjus või mitte-ladina tähed
if ([string]::IsNullOrWhiteSpace($firstName) -or [string]::IsNullOrWhiteSpace($lastName)) {
    Write-Host "[X] Viga: Eesnimi ja perenimi ei tohi olla tühjad!" -ForegroundColor Red
    exit 1
}

if ($firstName -match "[^a-zA-Z]" -or $lastName -match "[^a-zA-Z]") {
    Write-Host "[!] Viga: Nimi tohib sisaldada ainult ladina tähti!" -ForegroundColor Red
    exit 1
}

# --> Genereeri kasutajanimi
$username = ($firstName.Substring(0,1) + $lastName).ToLower()
$fullName = "$firstName $lastName"

# --> Kontrolli, kas kasutaja on juba olemas
if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
    Write-Host "[!] Kasutaja '$username' on juba olemas." -ForegroundColor Yellow
    exit 1
}

# --> Proovi kasutajat luua
try {
    $password = ConvertTo-SecureString "Parool1!" -AsPlainText -Force

    New-LocalUser -Name $username `
                  -FullName $fullName `
                  -Password $password `
                  -Description "Automaatne lisamine skriptiga" `
                  -ErrorAction Stop

    Write-Host "[✔] Kasutaja '$username' loodud edukalt." -ForegroundColor Green
}
catch {
    Write-Host "[X] Viga kasutaja loomisel: $_" -ForegroundColor Red
    exit 1
}

# --> Edu või mitte?
if ($?) {
    Write-Host "[OK] Käsk täideti edukalt." -ForegroundColor Green
} else {
    Write-Host "[X] Käsk ebaõnnestus." -ForegroundColor Red
}

exit 0
