$counter = 0  # Loendur, mis loeb tsükli kordusi

do {
    Write-Host "Notepad on avatud."
    Start-Sleep -Seconds 1  # Lisa 1-sekundiline paus
    $counter++  # Suurendame loendurit ühe võrra
} while (Get-Process -Name notepad -ErrorAction SilentlyContinue)

# Kui Notepadi aknad on suletud, kuvame lõppsõnumi ja tsükli korduste arvu
Write-Host "Kõik Notepadi aknad on suletud."
Write-Host "Skript jooksis $counter korda."
