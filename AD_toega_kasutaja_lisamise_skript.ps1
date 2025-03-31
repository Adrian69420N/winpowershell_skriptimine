<#
.SYNOPSIS
    Loob uue Active Directory kasutajakonto.
.DESCRIPTION
    Küsib ees- ja perenime, genereerib kasutajanime ja turvalise parooli, loob kasutaja AD-s,
    salvestab andmed CSV faili. Kasutaja saab kohe sisse logida (parooli muutmise nõuet pole).
.NOTES
    Vajab AD moodulit ja administraatoriõigusi.
#>

# UTF-8 tugi
chcp 65001 > $null
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "=== AD kasutaja loomine ===" -ForegroundColor Cyan

# AD mooduli import
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
if (-not (Get-Module ActiveDirectory)) {
    Write-Host "[X] Viga: AD moodulit ei laetud." -ForegroundColor Red
    exit 1
}

# Proovi ühendada domeeniga
try {
    $domain = Get-ADDomain
    Write-Host "[OK] Ühendus domeeniga: $($domain.DNSRoot)" -ForegroundColor Green
} catch {
    Write-Host "[X] Viga: Ei saanud domeeniga ühendust." -ForegroundColor Red
    Write-Host "Detailid: $_"
    exit 1
}

# Parooli genereerimine
function New-RandomPassword {
    $length = 12
    $chars = "ABCDEFGHKLMNOPRSTUVWXYZabcdefghiklmnoprstuvwxyz0123456789!@#$%^&*()-_=+[]{}"
    return -join ((1..$length) | ForEach-Object { $chars | Get-Random })
}

# CSV loomine (kui ei eksisteeri)
function Initialize-CsvFile {
    param ([string]$filePath)
    if (-not (Test-Path $filePath)) {
        "FirstName,LastName,Username,Password,Email,CreationTime" | Out-File -FilePath $filePath -Encoding utf8
        Write-Host "[OK] CSV fail loodud: $filePath" -ForegroundColor Green
    }
}

# Andmete sisestus
$firstName = Read-Host "Sisesta eesnimi"
$lastName = Read-Host "Sisesta perenimi"

if ([string]::IsNullOrWhiteSpace($firstName) -or [string]::IsNullOrWhiteSpace($lastName)) {
    Write-Host "[X] Viga: Nimede väljad ei tohi olla tühjad." -ForegroundColor Red
    exit 1
}

# Kasutajanimi kujul: eesnime esimene täht + perenimi
$username = ($firstName.Substring(0,1) + $lastName).ToLower() -replace '[^a-z0-9]', ''
$email = "$username@$($domain.DNSRoot)"
$upn = $email
$ouPath = "CN=Users,$($domain.DistinguishedName)"

# Kontrolli, kas kasutaja on juba olemas
try {
    if (Get-ADUser -Filter { SamAccountName -eq $username }) {
        Write-Host "[!] Kasutaja '$username' juba olemas." -ForegroundColor Yellow
        exit 0
    }
} catch {
    Write-Host "[OK] Kasutaja on lisamiseks saadaval." -ForegroundColor Green
}

# Parool
$password = New-RandomPassword
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

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

    Write-Host "[✔] Kasutaja '$username' edukalt loodud." -ForegroundColor Green
}
catch {
    Write-Host "[X] Viga kasutaja loomisel: $_" -ForegroundColor Red
    exit 1
}

# Salvesta CSV
$csvPath = Join-Path $PSScriptRoot "kasutanimi.csv"
Initialize-CsvFile -filePath $csvPath
$creationTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"$firstName,$lastName,$username,$password,$email,$creationTime" | Out-File -FilePath $csvPath -Encoding utf8 -Append
Write-Host "[OK] Andmed salvestatud faili: $csvPath" -ForegroundColor Green

# Kokkuvõte
Write-Host ""
Write-Host "--- Kokkuvõte ---" -ForegroundColor Cyan
Write-Host "Nimi      : $firstName $lastName"
Write-Host "Kasutaja  : $username"
Write-Host "Parool    : $password"
Write-Host "Email     : $email"
Write-Host "Fail      : $csvPath"
Write-Host ""
Write-Host "[Valmis] Kasutaja saab kohe sisse logida." -ForegroundColor Yellow
