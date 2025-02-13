# Loome hashtable'id töötatud päevade ja päevapalgaga
$daysWorked  = @{ "John" = 12; "Joe" = 20; "Mary" = 18 }
$salaryPerDay = @{ "John" = 100; "Joe" = 120; "Mary" = 150 }
$totalSalary = @{}

# Arvutame iga töötaja palga
foreach ($name in $daysWorked.Keys) {
    $totalSalary[$name] = $daysWorked[$name] * $salaryPerDay[$name]
}

# Kuvame tulemuse ilusasti tabelina
Write-Host "`nTöötajate palgad:" -ForegroundColor Green
$totalSalary.GetEnumerator() | Sort-Object Name | Format-Table -AutoSize
