<#
.SYNOPSIS
    Loob uue Active Directory kasutaja koos juhuslikult genereeritud parooliga.
.DESCRIPTION
    Küsib ees- ja perenime, genereerib kasutajanime ja parooli, loob AD kasutaja,
    salvestab andmed CSV faili ning eemaldab parooli vahetamise nõude.
.NOTES
    Vajab AD moodulit ja administraatoriõigusi.
#>

# UTF-8 toetus täpitähtede jaoks
chcp 65001 > $null
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "=== Active Directory kasutaja loomine ===" -ForegroundColor Cyan

# Impordi AD moodul
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
if (-not (Get-Module -Name ActiveDirectory)) {
    Write-Host "[X] Viga: Active Directory moodulit ei õnnestunud laadida!" -ForegroundColor Red
    exit 1
}

# Kontrolli domeeniühendust
try {
    $domain = Get-ADDomain
    Write-Host "[OK] Ühendus domeeniga: $($domain.DNSRoot)" -ForegroundColor Green
} catch {
    Write-Host "[X] Viga: Ei saanud domeeniga ühendust." -ForegroundColor Red
    exit 1
}

# Parooli genereerimise funktsioon
function New-RandomPassword {
    $length = 12
    $upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    $lower = 'abcdefghijklmnopqrstuvwxyz'
    $digits = '0123456789'
    $special = '!@#$%&*()-_=+?'

    $allChars = ($upper + $lower + $digits + $special).ToCharArray()
    $password = @(
        ($upper.ToCharArray() | Get-Random)
        ($lower.ToCharArray() | Get-Random)
        ($digits.ToCharArray() | Get-Random)
        ($special.ToCharArray() | Get-Random)
    )

    for ($i = $password.Count; $i -lt $length; $i++) {
        $password += $allChars | Get-Random
    }

    return ($password | Sort-Object { Get-Random }) -join ''
}

# CSV faili loomine kui puudub
function Initialize-CsvFile {
    param ([string]$filePath)
    if (-not (Test-Path $filePath)) {
        "Username,Password" | Out-File -FilePath $filePath -Encoding utf8
        Write-Host "[OK] CSV fail loodud: $filePath" -ForegroundColor Green
    }
}

# Andmete küsimine
$firstName = Read-Host "Sisesta eesnimi"
$lastName = Read-Host "Sisesta perenimi"

if ([string]::IsNullOrWhiteSpace($firstName) -or [string]::IsNullOrWhiteSpace($lastName)) {
    Write-Host "[X] Viga: Nimed ei tohi olla tühjad!" -ForegroundColor Red
    exit 1
}

# Kasutajanime genereerimine
$username = ($firstName.Substring(0, 1) + $lastName).ToLower()
$username = $username -replace '[^a-z0-9]', ''
Write-Host "[Info] Genereeritud kasutajanimi: $username" -ForegroundColor Cyan

# Kontrolli, kas kasutaja on juba olemas
try {
    if (Get-ADUser -Filter { SamAccountName -eq $username }) {
        Write-Host "[!] Kasutaja '$username' on juba olemas." -ForegroundColor Yellow
        exit 0
    }
} catch {
    Write-Host "[OK] Kasutajanimi on saadaval." -ForegroundColor Green
}

# Parool ja UPN
$password = New-RandomPassword
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$email = "$username@$($domain.DNSRoot)"
$upn = $email
$ouPath = "CN=Users,$($domain.DistinguishedName)"

# Kasutaja loomine
try {
    New-ADUser -Name "$firstName $lastName" `
               -GivenName $firstName `
               -Surname $lastName `
               -SamAccountName $username `
               -UserPrincipalName $upn `
               -EmailAddress $email `
               -AccountPassword $securePassword `
               -Enabled $true `
               -Path $ouPath `
               -PassThru | Out-Null

    Set-ADUser -Identity $username -ChangePasswordAtLogon $false

    Write-Host "[✔] Kasutaja '$username' lisati edukalt AD-sse." -ForegroundColor Green
} catch {
    Write-Host "[X] Viga kasutaja loomisel: $_" -ForegroundColor Red
    exit 1
}

# CSV logimine
$csvPath = Join-Path -Path $PSScriptRoot -ChildPath "kasutanimi.csv"
Initialize-CsvFile -filePath $csvPath

try {
    "$username,$password" | Out-File -FilePath $csvPath -Encoding utf8 -Append
    Write-Host "[OK] Kasutaja andmed salvestatud CSV faili: $csvPath" -ForegroundColor Green
} catch {
    Write-Host "[!] Viga CSV faili salvestamisel." -ForegroundColor Yellow
}

# Kokkuvõte
Write-Host ""
Write-Host "--- Kokkuvõte ---" -ForegroundColor Cyan
Write-Host "Nimi       : $firstName $lastName"
Write-Host "Kasutajanimi : $username"
Write-Host "Parool     : $password"
Write-Host "Email      : $email"
Write-Host "UPN        : $upn"
Write-Host ""
Write-Host "[Valmis] Kasutaja saab kohe sisse logida, parooli vahetus pole nõutud." -ForegroundColor Yellow
