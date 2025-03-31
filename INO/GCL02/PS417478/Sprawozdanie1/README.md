# Sprawozdanie 1 
## Lab 1 - Wprowadzenie, Git, Gałęzie, SSH
1. Instalacja klijenta Git i obsługa kluczy SSH
Po intsalacji systemu Fedora i konfiguracji, sprawdziłam adres IP mojego serwera i wykorzystując Visual Studio Code, połączyłam się przez SSH, sklonowałam repozytorium poleceniem:
`sudo dnf install git`
Sprawdziłam poprawność instalacji:
`git --version`
2. Utworzenie dwóch kluczy SSH:
Pierwszy klucz generuje bez zabezpieczenia:
`ssh-keygen -t ecdsa -b 521 -C "p.szlachta20@gmail.com"`
W drugim wpisuje hasło:
`ssh-keygen -t ed25519 -C "p.szlachta20@gmail.com"`
3. Konfiguracja kluczy SSH jako metodę dostępu do GitHuba:
Dodałam je do Github (Settings -> SSH and GPG keeys -> new SSH key)

ZDJĘCIE 1

4. Klonowanie repozytorium z wykorzystaniem protokołu SSH
Poleceniem:
`git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git`
5. Przełącz się na gałąź main, a potem na gałąź swojej grupy (pilnuj gałęzi i katalogu!):
Przełaczam się na gałąź main:
`git checkout mian`
6. Utwórz gałąź o nazwie "inicjały & nr indeksu" 
Poleceniem:
`git checckout -b PS417478`
7. W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu"
W moim przypadku moja ścieżka wygląda następująco: pszlachta@localhost:~/MDO2025_INO/INO/GCL02
W tym folderze tworzę swój katalog poleceniem:
`mkdir PS417478`
8. Napisz Git hooka - skrypt weryfikujący, że każdy Twój "commit message" zaczyna się od "twoje inicjały & nr indexu".
Tworzę folder Sprawozdanie1, a w nim plik `commit-msg` który wygląda następująco:
```bash
#!/bin/bash
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! "$COMMIT_MSG" =~ ^PS417478 ]]; then
    echo "❌ Błąd: Commit message musi zaczynać się od 'PS417478'"
    exit 1
fi
exit 0
```
Dodaje uprawnienia do uruchamiania:
`chmod +x .git/hooks/commit-msg`

9. Wysyłanie zmian do repozytorium:
Przełączenie się na moją gałąź:
`git checkout PS417478`
Dodanie plików do repozytorium:
`git add .`
Utworzenie commita:
`git commit -m "PS417478: Dodanie zmian"`
Wypchanie zmian:
`git push origin PS417478`

---
## Lab 2


--- 
## Lab 3


--- 
## Lab 4

