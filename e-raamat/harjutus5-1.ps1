# Leia kõik töötavad Notepad'i protsessid
$notepadProtsessid = Get-Process | Where-Object { $_.ProcessName -eq "notepad" }

# Kontrolli, kas Notepad töötab
if ($notepadProtsessid) {
    Write-Host "`nTöötavad Notepad'i protsessid:" -ForegroundColor Cyan
    $notepadProtsessid | Select-Object ProcessName, Id | Format-Table -AutoSize
} else {
    Write-Host "Ühtegi Notepad'i protsessi ei leitud." -ForegroundColor Red
}
