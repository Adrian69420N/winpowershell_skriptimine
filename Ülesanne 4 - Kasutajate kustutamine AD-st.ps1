<#
.SYNOPSIS
    Deletes an Active Directory user based on first and last name.
.DESCRIPTION
    This script asks for a user's first and last name, constructs the username,
    and attempts to delete the user from Active Directory.
.NOTES
    Requires ActiveDirectory module and sufficient permissions.
#>

# Impordi AD moodul
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
if (-not (Get-Module ActiveDirectory)) {
    Write-Host "Viga: Active Directory moodulit ei õnnestunud laadida!" -ForegroundColor Red
    exit 1
}

# Funktsioon täpitähtede translitereerimiseks
function Convert-ToAscii {
    param ([string]$text)
    $translit = @{
        'ä' = 'a'; 'ö' = 'o'; 'ü' = 'u'; 'õ' = 'o'
        'Ä' = 'A'; 'Ö' = 'O'; 'Ü' = 'U'; 'Õ' = 'O'
    }
    foreach ($key in $translit.Keys) {
        $text = $text -replace $key, $translit[$key]
    }
    return $text
}

# Küsi kasutajalt ees- ja perekonnanimi
$firstName = Read-Host "Sisesta eesnimi"
$lastName = Read-Host "Sisesta perenimi"

# Kontrolli sisendi tühjust
if ([string]::IsNullOrWhiteSpace($firstName) -or [string]::IsNullOrWhiteSpace($lastName)) {
    Write-Host "Viga: Ees- ja perenimi ei tohi olla tühjad!" -ForegroundColor Red
    exit 1
}

# Translit + username loomine
$firstNameClean = Convert-ToAscii $firstName
$lastNameClean = Convert-ToAscii $lastName
$username = ($firstNameClean.Substring(0,1) + $lastNameClean).ToLower()
$username = $username -replace '[^a-z0-9]', ''  # Eemalda muud märgid

Write-Host "Kustutatava kasutaja kasutajanimi: $username" -ForegroundColor Cyan

# Proovi kasutajat leida ja kustutada
try {
    $user = Get-ADUser -Filter { SamAccountName -eq $username } -ErrorAction Stop
    Remove-ADUser -Identity $user -Confirm:$false -ErrorAction Stop
    Write-Host "Kasutaja '$username' kustutati edukalt Active Directoryst." -ForegroundColor Green
}
catch {
    if ($_ -like "*cannot find an object with identity*") {
        Write-Host "Kasutajat '$username' ei leitud Active Directoryst." -ForegroundColor Yellow
    }
    else {
        Write-Host "Kustutamine ebaõnnestus. Veateade: $_" -ForegroundColor Red
    }
    exit 1
}

exit 0


