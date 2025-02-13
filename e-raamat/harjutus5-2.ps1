# Määra kaust, kust otsida faile
$kaust = "C:\Temp\Test"

# Leia kõik failid selles kaustas
$koikFailid = Get-ChildItem -Path $kaust

# Kuvame kokku failide arvu
Write-Host "`nKaustas on kokku $($koikFailid.Count) faili." -ForegroundColor Yellow

# Filtreerime välja ainult CSV-failid
$csvFailid = $koikFailid | Where-Object { $_.Extension -eq ".csv" }

# Kontrollime, kas kaustas on CSV-faile
if ($csvFailid) {
    Write-Host "`nLeitud CSV-failid ja nende suurus:" -ForegroundColor Cyan
    $csvFailid | Select-Object Name, @{Name="Suurus KB"; Expression={"{0:N2}" -f ($_.Length/1KB)}}, @{Name="Suurus MB"; Expression={"{0:N2}" -f ($_.Length/1MB)}} | Format-Table -AutoSize
} else {
    Write-Host "Ühtegi CSV-faili ei leitud kaustas $kaust." -ForegroundColor Red
}
