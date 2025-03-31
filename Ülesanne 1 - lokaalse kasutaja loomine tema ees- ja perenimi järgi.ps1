# Seadista PowerShelli konsooli kodeering UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Lae AD moodul
Import-Module ActiveDirectory

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

# Kontrolli, kas kasutaja juba eksisteerib AD-s
if (Get-ADUser -Filter { SamAccountName -eq $username } -ErrorAction SilentlyContinue) {
    Write-Host "Teade: Kasutaja '$username' on juba Active Directorys olemas. Lisamine ei ole vajalik." -ForegroundColor Yellow
    exit 0
}

# Proovi kasutajat lisada ja püüa võimalikke vigu
try {
    $password = ConvertTo-SecureString "Parool1!" -AsPlainText -Force
    New-ADUser -Name $fullName `
               -SamAccountName $username `
               -GivenName $firstName `
               -Surname $lastName `
               -UserPrincipalName "$username@yourdomain.local" `
               -AccountPassword $password `
               -Enabled $true `
               -Path "CN=Users,DC=yourdomain,DC=local" `
               -Description "Automaatne kasutaja lisamine"

    if ($?) {
        Write-Host "Kasutaja '$username' lisati edukalt Active Directorysse." -ForegroundColor Green
        exit 0
    } else {
        Write-Host "Käsk ebaõnnestus." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Viga kasutaja loomisel: $_" -ForegroundColor Red
    exit 1
}
