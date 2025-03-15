# Kacper Mazur, 415588 - Inzynieria Obliczeniowa, GCL02
## Laboratorium 1 - Wprowadzenie, Git, Gałęzie, SSH

### Wprowadzenie:

W ramach tego zadania skonfigurowałem Git i SSH, sklonowałem repozytorium, pracowałem z gałęziami, stworzyłem git hooka oraz przygotowałem sprawozdanie. Używałem wirtualnej maszyny z systemem fedora.
### 1️⃣ Instalacja Git i OpenSSH:
```bash
sudo dnf install -y git openssh
```

![wersje](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/wersje.png)

### 2️⃣ Personal access token:
Utworzyłem personal access token:

![pat](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/token.png)

A następnie sklonowałem repozytorium przy pomocy access token:
```bash
git clone https://<TOKEN>@github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

![httprepo](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/httprepo.png)

### 3️⃣ Klucze SSH:
Wygenerowałem dwa klucze:
-ecdsa:
```bash
ssh-keygen -t ecdsa -b 521 -C "tasnko12@gmail.com"
```
-ed25519:
```bash
ssh-keygen -t ed25519 -C "tasnko12@gmail.com"
```
przy czym w pierwszym przy zapytaniu o hasło kilknąłem ENTER a przy drugim wpisałem hasło dostępu. Wygenerowane klucze zapisałem w katalogu '/home/kmazur/.ssh/', a następnie dodałem do swojego konta na GitHubie: 'Settings' -> 'SSH and GPG keys'.

![SHHKEYS](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/ssh_keys.png)

Następnie skonfigurowałem klucze SSH jako metodę dostępu do GitHuba

- Kopiowanie kluczy SSH:
```bash
clip < ~/.ssh/id_ed25519.pub
```
```bash
clip < ~/.ssh/id_ecdsa.pub
```
- Uruchomienie agenta SSH:
```bash
eval $(ssh-agent -s)
```
- Dodanie klucza typu ed25519 do agenta (musiałem podać hasło przy wykonaniu polcenia):
```bash
ssh-add ~/.ssh/id_ed25519
```
### 4️⃣ Klonowanie repozytorium wykorzytsując protokół SSH:
```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
### 5️⃣ Obsługa gałęzi:
```bash
cd MDO2025_INO
git checkout main
git pull origin main

git checkout GCL02
git pull origin GCL02

git  checkout -b KM415588
```
Zdjęcie przestawiające wszytskie odwiedzone gałęzie:

![Branches](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/Branches.png)

### 6️⃣ Utowrzenie katalogu KM415588 i git hooka:
W kolejnym kroku utworzyłem katalog KM415588 i a w nim plik commit-msg:
```bash
mkdir -p KM415588/Sprawozdanie_1
cd KM415588/Sprawozdanie_1
nano commit-msg
```
Plik commit-msg:
```bash
#!/bin/bash
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! "$COMMIT_MSG" =~ ^KM415588 ]]; then
    echo "❌ Błąd: Commit message musi zaczynać się od 'KM415588'"
    exit 1
fi
```
A następnie skopiowałem go do folderu ./git/hooks i dodałem mu odpowiednie uprawnienia do wykonywania:
```bash
cp ./commit-msg .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg
```

Po przetestowaniu zwraca on następujące wyniki:

![hook](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/test_hook.png)

### 7️⃣ Dodanie sprawozdania w formacie .md i zrzutów ekranu:
Po utworzeniu odpowiedniej struktury plików i napisaniu sprawozdania wypushowałem zmiany do mojej gałęzi po czym zmergeowałem ją z gałęzią grupy:
```
git add .
git commit -m "KM415588: sprawozdanie i zdjęcia"

git push origin KM415588
git checkout GCL02
git pull origin GCL02
git merge KM415588
```
