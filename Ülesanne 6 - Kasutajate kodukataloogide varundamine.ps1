<#
.SYNOPSIS
    Varundab kõikide kasutajate kodukataloogid C:\Users alt
.DESCRIPTION
    Loob igale kasutajale tema kodukataloogi varukoopia kujul kasutajanimi-PP.KK.YYYY.zip
    ja paigutab need C:\Backup kausta.
.NOTES
    Vajab administraatoriõigusi
#>

# Loome backup-kausta kui see puudub
$backupPath = "C:\Backup"
if (-not (Test-Path $backupPath)) {
    New-Item -Path $backupPath -ItemType Directory | Out-Null
    Write-Host "Loodi varunduse kaust: $backupPath" -ForegroundColor Green
}

# Saame tänase kuupäeva vormingus PP.KK.AAAA
$dateStamp = Get-Date -Format "dd.MM.yyyy"

# Võtame kõik lokaalsed kasutajad
$users = Get-LocalUser | Where-Object { $_.Enabled -eq $true -and $_.Name -notin @('Administrator', 'DefaultAccount', 'Guest') }

foreach ($user in $users) {
    $userName = $user.Name
    $userProfile = "C:\Users\$userName"

    # Kontrolli, kas kasutaja kodukataloog eksisteerib
    if (Test-Path $userProfile) {
        $zipName = "$userName-$dateStamp.zip"
        $zipPath = Join-Path -Path $backupPath -ChildPath $zipName

        try {
            # Kui fail juba olemas, kustuta vana
            if (Test-Path $zipPath) {
                Remove-Item -Path $zipPath -Force
            }

            Compress-Archive -Path $userProfile -DestinationPath $zipPath -Force
            Write-Host "Varundatud: $userName -> $zipPath" -ForegroundColor Cyan
        }
        catch {
            Write-Host "Viga varundamisel: $userName ($userProfile)" -ForegroundColor Red
            Write-Host "Veateade: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Kodukataloogi ei leitud: $userProfile" -ForegroundColor DarkYellow
    }
}

Write-Host "`nKÕIKIDE kasutajate varundus lõpetatud." -ForegroundColor Green
