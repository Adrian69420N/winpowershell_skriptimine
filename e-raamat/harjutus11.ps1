[int]$n1 = Read-Host "Sisesta esimene arv"
[int]$n2 = Read-Host "Sisesta teine arv"

# Kuvame valikumenüü kasutajale
Write-Host "Vali tehe:"
Write-Host "1: Liitmine (+)"
Write-Host "2: Lahutamine (-)"
Write-Host "3: Korrutamine (*)"
Write-Host "4: Jagamine (/)"

# Kasutaja sisestab oma valiku
$valik = Read-Host "Sisesta oma valik"

# Switch-konstruktsioon, mis kontrollib kasutaja valikut
switch ($valik) {
    1 { Write-Host "Tulemus: $($n1 + $n2)" }  # Liitmine
    2 { Write-Host "Tulemus: $($n1 - $n2)" }  # Lahutamine
    3 { Write-Host "Tulemus: $($n1 * $n2)" }  # Korrutamine
    4 { 
        if ($n2 -ne 0) {
            Write-Host "Tulemus: $($n1 / $n2)"
        } else {
            Write-Host "Jagamine nulliga ei ole lubatud!" -ForegroundColor Red
        }
    }
    default { Write-Host "Vale valik!" -ForegroundColor Red }  # Kui valik on vale
}
