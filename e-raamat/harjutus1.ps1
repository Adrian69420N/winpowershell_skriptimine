# Loome esimese massiivi, mis sisaldab arve 1, 2 ja 3
$array1 = @(1,2,3)

# Loome teise massiivi, mis sisaldab arve 4, 5 ja 6
$array2 = @(4,5,6)

# Loome tühja massiivi, kuhu salvestame summad
$array3 = @()

# Käime for-tsükliga läbi kõik esimese massiivi elemendid
for ($i = 0; $i -lt $array1.Length; $i++) {
    # Liidame kokku vastavad elemendid mõlemast massiivist
    $array3 += $array1[$i] + $array2[$i]
}

# Kuvame tulemuse ehk kolmanda massiivi sisu
$array3
