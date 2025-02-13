# Määrame CSV-faili asukoha
$csvFail = "C:\Temp\students.csv"

# Kontrollime, kas fail eksisteerib
if (-Not (Test-Path $csvFail)) {
    Write-Host "VIGA: CSV-faili ei leitud! Palun loo või paiguta see asukohta: $csvFail" -ForegroundColor Red
    exit
}

# Impordime CSV-faili
$opilased = Import-Csv $csvFail

# Loome tulemuste massiivi
$tulemused = @()

# Töötleme iga õpilase andmeid
foreach ($opilane in $opilased) {
    $kooliaste = if ([int]$opilane.Age -lt 11) { "Noorem aste" } else { "Vanem aste" }

    # Loome objekti tabeli jaoks
    $temp = [PSCustomObject]@{
        Nimi = $opilane.Name
        Vanus = $opilane.Age
        Kooliaste = $kooliaste
    }

    # Lisame tulemuse massiivi
    $tulemused += $temp
}

# Kuvame tulemused tabelina
Write-Host "`nÕpilaste nimekiri ja nende kooliaste:" -ForegroundColor Cyan
$tulemused | Format-Table -AutoSize

# Eksportime tulemused uude CSV-faili
$tulemused | Export-Csv -Path C:\Temp\students_output.csv -NoTypeInformation -Encoding UTF8
Write-Host "`nTulemused on salvestatud faili: C:\Temp\students_output.csv" -ForegroundColor Green
