<#
.SYNOPSIS
    Loob uue lokaalse kasutaja ees- ja perenime alusel.
.DESCRIPTION
    Skript küsib kasutaja ees- ja perekonnanime, genereerib kasutajanime ning
    lisab lokaalse kasutaja, kui seda veel pole. Väljastab kasutajasõbraliku info.
.NOTES
    Vajab administraatoriõigusi ja töötab UTF-8 konsoolis.
#>

# ➤ UTF-8 tugi täpitähtede jaoks
chcp 65001 > $null
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "`n=== Lokaalse kasutaja loomine ===`n" -ForegroundColor Cyan

# ➤ Küsime kasutaja ees- ja perenime
$firstName = Read-Host "Sisesta eesnimi"
$lastName  = Read-Host "Sisesta perenimi"

# ➤ Kontrollime, et mõlemad väljad on täidetud ja sisaldavad ainult ladina tähti
if ([string]::IsNullOrWhiteSpace($firstName) -or [string]::IsNullOrWhiteSpace($lastName)) {
    Write-Host "Viga: Eesnimi ja perenimi ei tohi olla tühjad!" -ForegroundColor Red
    exit 1
}

if ($firstName -match "[^a-zA-Z]" -or $lastName -match "[^a-zA-Z]") {
    Write-Host "Viga: Nimi tohib sisaldada ainult ladina tähti!" -ForegroundColor Red
    exit 1
}

# ➤ Genereerime kasutajanime: esimene täht + perenimi (väiketähtedega)
$username = ($firstName.Substring(0,1) + $lastName).ToLower()
$fullName = "$firstName $lastName"

# ➤ Kontrollime, kas kasutaja on juba olemas
if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
    Write-Host "Kasutaja '$username' on juba olemas süsteemis." -ForegroundColor Yellow
    exit 1
}

# ➤ Proovime kasutaja lisada
try {
    $password = ConvertTo-SecureString "Parool1!" -AsPlainText -Force

    New-LocalUser -Name $username `
                  -FullName $fullName `
                  -Password $password `
                  -Description "Automaatne lisamine skriptiga" `
                  -ErrorAction Stop

    Write-Host "Kasutaja '$username' loodud edukalt!" -ForegroundColor Green
}
catch {
    Write-Host "Viga kasutaja loomisel: $_" -ForegroundColor Red
    exit 1
}

# ➤ Kontrollime käsu tulemust
if ($?) {
    Write-Host "`nKäsk täideti edukalt." -ForegroundColor Green
} else {
    Write-Host "`nKäsk ebaõnnestus." -ForegroundColor Red
}

exit 0
