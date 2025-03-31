# winpowershell_skriptimine - Ülesanded 1–6

See repo sisaldab PowerShelli skripte Windowsi keskkonnas erinevate haldustoimingute jaoks. Iga skript lahendab ühe praktilise ülesande ning on varustatud kommentaaride ja UTF-8 toega.

---

## Ülesanne 1 – Lokaalse kasutaja loomine ees- ja perenime alusel
**Fail:** `Ülesanne 1 - lokaalse kasutaja loomine tema ees- ja perenimi järgi.ps1`

- Küsib kasutajalt ees- ja perenime
- Genereerib kasutajanime kujul `eesnime_esimene_täht + perenimi`
- Lisab uue lokaalse kasutaja `New-LocalUser` käsuga
- Kontrollib, kas kasutaja on juba olemas
- Annab kasutajasõbraliku tagasiside

---

## Ülesanne 2 – Lokaalsete kasutajate kustutamine
**Fail:** `Ülesanne 2 - Lokaalsete kasutajate kustutamine süsteemist.ps1`

- Küsib kasutajalt kustutatava kasutajanime
- Kontrollib, kas kasutaja eksisteerib
- Kui jah, kustutab `Remove-LocalUser` käsuga
- Kuvab veateate, kui kasutajat pole olemas

---

## Ülesanne 4 – Kasutajate kustutamine Active Directoryst
**Fail:** `Ülesanne 4 - Kasutajate kustutamine AD-st.ps1`

- Küsib ees- ja perenime
- Genereerib kasutajanime translitereerimisega (nt ä → a)
- Kontrollib, kas kasutaja eksisteerib AD-s
- Kui eksisteerib, kustutab `Remove-ADUser` abil
- Lisatud veakäsitlemine ja viisakad teated

---

## Ülesanne 5 – Kasutajate loomine Active Directorysse koos paroolide genereerimisega
**Fail:** `Ülesanne 5 - Kasutajate loomine täiendamine parooli genereerimisega.ps1`

- Küsib kasutaja ees- ja perenime
- Genereerib unikaalse tugeva parooli (12 tähemärki, sisaldab suuri, väikeseid, numbreid, sümboleid)
- Loob kasutaja AD-s `New-ADUser` abil
- Eemaldab `ChangePasswordAtLogon`, et kasutaja saaks kohe sisse logida
- Salvestab kasutajanime ja parooli CSV-faili `kasutanimi.csv`

---

## Ülesanne 6 – Kasutajate kodukataloogide varundamine
**Fail:** `Ülesanne 6 - Kasutajate kodukataloogide varundamine.ps1`

- Leiab kõik lokaalsed aktiivsed kasutajad
- Kontrollib, kas nende `C:\Users\kasutajanimi` kataloog eksisteerib
- Kui jah, loob ZIP-faili kujul `kasutajanimi-PP.KK.AAAA.zip`
- Salvestab varundused kataloogi `C:\Backup`
- Kuvab täpse tagasiside iga kasutaja kohta

---

**Kõik skriptid on kirjutatud UTF-8 kodeeringus ja testitud PowerShell 5.1 ja PowerShell 7 keskkonnas.**

Soovitused: 
- Käivita skriptid administraatorina
- Kontrolli, et Active Directory moodul on paigaldatud (RSAT)
- Veendu, et sisselogimisõigused oleksid korras (nt "Allow log on locally")
