<#
.SYNOPSIS
    Kustutab süsteemist olemasoleva lokaalse kasutaja.
.DESCRIPTION
    Skript küsib kasutajanime, kontrollib selle olemasolu ning kustutab vajadusel kasutaja.
.NOTES
    Vajab administraatoriõigusi.
#>

# --> UTF-8 toetus
chcp 65001 > $null
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "=== Lokaalse kasutaja kustutamine ===" -ForegroundColor Cyan

# --> Sisend
$username = Read-Host "Sisesta kustutatava kasutaja kasutajanimi"

# --> Kontroll: tühi väli
if ([string]::IsNullOrWhiteSpace($username)) {
    Write-Host "[X] Viga: Kasutajanimi ei tohi olla tühi!" -ForegroundColor Red
    exit 1
}

# --> Kasutaja olemasolu kontroll
$user = Get-LocalUser -Name $username -ErrorAction SilentlyContinue
if (-not $user) {
    Write-Host "[!] Kasutajat '$username' ei leitud süsteemist." -ForegroundColor Yellow
    exit 1
}

# --> Kustutamine
try {
    Remove-LocalUser -Name $username -ErrorAction Stop
    Write-Host "[✔] Kasutaja '$username' kustutati edukalt." -ForegroundColor Green
}
catch {
    Write-Host "[X] Viga kustutamisel: $_" -ForegroundColor Red
    exit 1
}
