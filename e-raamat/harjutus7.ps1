# Määrame õpilaste arvu ja võimalikud grupid
$opilasteArv = 20
$grupid = @("Punane", "Roheline", "Kollane", "Sinine")

# Loome massiivi, kuhu salvestame tulemused
$tulemused = @()

# Genereerime iga õpilasele juhusliku grupi
for ($i = 1; $i -le $opilasteArv; $i++) {
    $valitudGrupp = Get-Random -InputObject $grupid

    # Loome objekti ja lisame massiivi
    $temp = [PSCustomObject]@{
        "Õpilase number" = $i
        "Grupp" = $valitudGrupp
    }
    $tulemused += $temp
}

# Kuvame tulemused tabelina
Write-Host "`nÕpilaste grupid:" -ForegroundColor Cyan
$tulemused | Format-Table -AutoSize

# Salvestame tulemused CSV-faili
$tulemused | Export-Csv -Path C:\Temp\students_groups.csv -NoTypeInformation -Encoding UTF8
Write-Host "`nTulemused on salvestatud faili: C:\Temp\students_groups.csv" -ForegroundColor Green
