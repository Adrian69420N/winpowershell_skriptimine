function countRunning {
    $running = Get-Service | Where-Object { $_.Status -eq "Running" }
    Write-Host "Töötavaid teenuseid: $($running.Count)"
}

function countStopped {
    $stopped = Get-Service | Where-Object { $_.Status -eq "Stopped" }
    Write-Host "Peatatud teenuseid: $($stopped.Count)"
}

# Kutsume funktsioonid välja
countRunning
countStopped
