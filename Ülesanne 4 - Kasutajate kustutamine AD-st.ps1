<#
.SYNOPSIS
    Kustutab Active Directory kasutaja ees- ja perenime alusel.
.DESCRIPTION
    Loob kasutajanime (eesnime 1. täht + perenimi), kontrollib selle olemasolu ja kustutab kasutaja AD-st.
.NOTES
    Vajab Active Directory moodulit ja domeeniühendust.
#>

# --> UTF-8 toetus
chcp 65001 > $null
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "=== Active Directory kasutaja kustutamine ===" -ForegroundColor Cyan

# --> Kontrolli, kas AD moodul on olemas
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
if (-not (Get-Module ActiveDirectory)) {
    Write-Host "[X] Viga: Active Directory moodulit ei leitud." -ForegroundColor Red
    exit 1
}

# --> Translit-funktsioon (eemaldab täpitähed)
function Convert-ToAscii {
    param ([string]$text)
    $translit = @{
        'ä' = 'a'; 'ö' = 'o'; 'ü' = 'u'; 'õ' = 'o'
        'Ä' = 'A'; 'Ö' = 'O'; 'Ü' = 'U'; 'Õ' = 'O'
    }
    foreach ($char in $translit.Keys) {
        $text = $text -replace $char, $translit[$char]
    }
    return $text
}

# --> Küsime ees- ja perenime
$firstName = Read-Host "Sisesta kasutaja eesnimi"
$lastName  = Read-Host "Sisesta kasutaja perenimi"

# --> Kontroll tühjade väljade vastu
if ([string]::IsNullOrWhiteSpace($firstName) -or [string]::IsNullOrWhiteSpace($lastName)) {
    Write-Host "[X] Viga: Ees- ja perenimi ei tohi olla tühjad!" -ForegroundColor Red
    exit 1
}

# --> Loo kasutajanimi (translit + lowercase)
$first = Convert-ToAscii $firstName
$last  = Convert-ToAscii $lastName
$username = ($first.Substring(0,1) + $last).ToLower()

Write-Host "[Info] Otsitav kasutajanimi: $username" -ForegroundColor Cyan

# --> Kasutaja otsimine ja kustutamine
try {
    $user = Get-ADUser -Filter { SamAccountName -eq $username } -ErrorAction Stop

    # --> Kui kasutaja leiti, kustutame
    Remove-ADUser -Identity $user -Confirm:$false -ErrorAction Stop
    Write-Host "[✔] Kasutaja '$username' kustutati AD-st edukalt." -ForegroundColor Green
}
catch {
    Write-Host "[!] Viga: Kasutajat '$username' ei leitud või kustutamine ebaõnnestus." -ForegroundColor Yellow
    Write-Host "Detailid: $_" -ForegroundColor DarkGray
    exit 1
}
