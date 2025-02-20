function countServices {
    param ([string]$status)  # Kasutaja määrab teenuse oleku ("Running" või "Stopped")
    $services = Get-Service | Where-Object { $_.Status -eq $status }
    Write-Host "Teenuseid olekuga $status: $($services.Count)"
}

# Kutsume funktsiooni välja erinevate parameetritega
countServices -status "Running"
countServices -status "Stopped"
