$counter = 0  # Loendur, mis loeb tsükli kordusi

do {
    Write-Host "Notepad on avatud."
    Start-Sleep -Seconds 1
    $counter++
} until (-not (Get-Process -Name notepad -ErrorAction SilentlyContinue))

Write-Host "Kõik Notepadi aknad on suletud."
Write-Host "Skript jooksis $counter korda."
