# While-tsükkel, mis jookseb seni, kuni vähemalt üks Notepad töötab
while (Get-Process -Name notepad -ErrorAction SilentlyContinue) {
    Write-Host "Notepad on endiselt avatud."
    Start-Sleep -Seconds 1  # Lisa 1-sekundiline paus, et mitte koormata protsessorit
}

# Kui Notepadi protsessi enam pole, kuvatakse lõppsõnum
Write-Host "Kõik Notepadi aknad on suletud."
