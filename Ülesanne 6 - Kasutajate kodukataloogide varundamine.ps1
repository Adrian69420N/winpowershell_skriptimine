<#
.SYNOPSIS
    Varundab olemasolevad kasutajate kodukataloogid C:\Users alt
.DESCRIPTION
    Iga kasutaja kataloog salvestatakse C:\Backup kausta nimega kasutaja-PP.KK.AAAA.zip
#>

# Seadista UTF-8 kodeering (täpitähed jms)
chcp 65001 > $null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Backup kataloog
$backupPath = "C:\Backup"
if (-not (Test-Path $backupPath)) {
    New-Item -Path $backupPath -ItemType Directory | Out-Null
    Write-Host "Loodi varunduse kaust: $backupPath" -ForegroundColor Green
}

# Kuupäev failinimes
$dateStamp = Get-Date -Format "dd.MM.yyyy"

# Võta kõik lokaalsed kasutajad (v.a sisseehitatud)
$users = Get-LocalUser | Where-Object {
    $_.Enabled -eq $true -and $_.Name -notin @('Administrator', 'DefaultAccount', 'Guest', 'WDAGUtilityAccount')
}

foreach ($user in $users) {
    $userName = $user.Name
    $userProfile = "C:\Users\$userName"

    if (Test-Path $userProfile) {
        $zipName = "$userName-$dateStamp.zip"
        $zipPath = Join-Path -Path $backupPath -ChildPath $zipName

        try {
            if (Test-Path $zipPath) {
                Remove-Item -Path $zipPath -Force
            }

            Compress-Archive -Path $userProfile -DestinationPath $zipPath -Force
            Write-Host "✅ Varundatud: $userName -> $zipName" -ForegroundColor Cyan
        } catch {
            Write-Host "❌ Viga varundamisel: $userName" -ForegroundColor Red
            Write-Host "Veateade: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "⚠️  Kodukataloogi ei leitud: $userProfile" -ForegroundColor DarkYellow
    }
}

Write-Host "`nKÕIKIDE kasutajate varundus LÕPETATUD." -ForegroundColor Green
