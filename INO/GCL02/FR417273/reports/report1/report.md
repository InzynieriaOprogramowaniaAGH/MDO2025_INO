# Sprawozdanie z laboratoriów: SSH, GIT, Docker, Dockerfiles
Przedmiot: DevOps
Kierunek: Inżynieria Obliczeniowa
Autor: Filip Rak
Data: 10/03/2025

## Przebieg Ćwiczeń
### Pierwsze zajęcia:
- Na wirtualnej maszynie VirtualBox zainstalowana została dystrybucja systemu Linux, Fedora. 
- Na konto użytkonika zalogowano się przez SSH w programie PowerShell systemu Windows. ![Zrzut ekranu logowania](media/m1_login.png)
- Utworzone zostały dwa klucze SSH, nie będace typu RSA, z czego jeden z nich został zabezpieczony hasłem. Użyto polecenia: ```ssh-keygen -t ed25519 -C "ADRES-EMAIL.com"``` ![Zrzut ekrnau tworzenia kluczy](media/m2_keygen.png)
- Do SHH dodano utworzony klucz, poleceniem ```ssh-add ./key_no_password``` ![Zrzut ekranu dodanie klucza](media/m3_add.png")
- Klucz publiczny został skopiowany z pliku o rozszerzeniu `.pub` i przekazany witrynie GitHub. ![Zrzut ekranu klucza na GitHub'ie](media/m4_gh.png")
- Autentyifkacja zostałą potweirdzona poleceniem `ssh -T git@github.com` ![Zrzut ekranu autentyfikacji](media/m5_auth.png)
- Repozytorium zostało sklonowane poleceniem `git clone` ![Zrzut ekranu klonowania](media/m6_clone.png)
- Utworzono nową gałąź kombinacją poleceń `git checkout GCL02` `git checkout -d FR417273`. Wewnątrz tej gałęzi utworozno katalog `mkdir FR417273`.
- Wewnątrz katalogu `.git/hooks` utworzono plik `commit-msg`, którego zadaniem jest weryfikacja i wymuszenie aby każdy przyszły commit zaczynał się inicjałami oraz numerem indeksu. Kopia pliku została przeniesiona do katalogu użytkownika. ![Działanie hooke'a, zablokowany commit i wiadomość](media/m7_commit_msg.png)
```#!/bin/sh
# Verify if commit message starts with the correct initials
string="[FR417273]"
if ! grep -q "^$string" "$1"; then
  echo "FAILED. Start commit message with $string."
  exit 1
fi
```
