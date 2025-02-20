# Funktsioon menüü kuvamiseks
function showMenu {
    Write-Host "Vali kujundi pindala arvutamiseks:"
    Write-Host "1: Ruudu pindala"
    Write-Host "2: Ristküliku pindala"
    Write-Host "3: Ringi pindala"
    Write-Host "4: Kolmnurga pindala"
    Write-Host "5: Välju"
    return (Read-Host "Sisesta valik")
}

do {
    $choice = showMenu

    switch ($choice) {
        1 {
            [int]$side = Read-Host "Sisesta ruudu külg"
            Write-Host "Ruudu pindala: $($side * $side)"
        }
        2 {
            [int]$length = Read-Host "Sisesta ristküliku pikkus"
            [int]$width = Read-Host "Sisesta ristküliku laius"
            Write-Host "Ristküliku pindala: $($length * $width)"
        }
        3 {
            [int]$radius = Read-Host "Sisesta ringi raadius"
            Write-Host "Ringi pindala: $([math]::PI * $radius * $radius)"
        }
        4 {
            [int]$base = Read-Host "Sisesta kolmnurga alus"
            [int]$height = Read-Host "Sisesta kolmnurga kõrgus"
            Write-Host "Kolmnurga pindala: $(0.5 * $base * $height)"
        }
    }
} while ($choice -ne "5")  # Tsükkel töötab, kuni kasutaja valib väljumise

Write-Host "Skript lõpetatud."
