# Sprawozdanie 1 
## Lab 1 - Wprowadzenie, Git, Gałęzie, SSH
### 1. Instalacja klijenta Git i obsługa kluczy SSH
Po intsalacji systemu Fedora i konfiguracji, sprawdziłam adres IP mojego serwera i wykorzystując Visual Studio Code, połączyłam się przez SSH, sklonowałam repozytorium poleceniem:
```bash
sudo dnf install git`
```
Sprawdziłam poprawność instalacji:
```bash
git --version
```
### 2. Utworzenie dwóch kluczy SSH
Pierwszy klucz generuje bez zabezpieczenia:
```bash
ssh-keygen -t ecdsa -b 521 -C "p.szlachta20@gmail.com"
```
W drugim wpisuje hasło:
```bash
ssh-keygen -t ed25519 -C "p.szlachta20@gmail.com"
```
### 3. Konfiguracja kluczy SSH jako metodę dostępu do GitHuba:
Dodałam je do Github (Settings -> SSH and GPG keeys -> new SSH key)
![zdj1](screenshots/1.png)

### 4. Klonowanie repozytorium
Poleceniem:
```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
### 5. Przełącz się na gałąź main, a potem na gałąź swojej grupy (pilnuj gałęzi i katalogu!):
Przełaczam się na gałąź main:
```bash
git checkout mian
```
### 6. Utwórz gałąź o nazwie "inicjały & nr indeksu" 
Poleceniem:
```bash
git checckout -b PS417478
```
### 7. W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu"
W moim przypadku moja ścieżka wygląda następująco: pszlachta@localhost:~/MDO2025_INO/INO/GCL02
W tym folderze tworzę swój katalog poleceniem:
```bash
mkdir PS417478
```
### 8. Napisz Git hooka - skrypt weryfikujący, że każdy Twój "commit message" zaczyna się od "twoje inicjały & nr indexu".
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
```bash
chmod +x .git/hooks/commit-msg
```
### 9. Wysyłanie zmian do repozytorium:
Przełączenie się na moją gałąź:
```bash
git checkout PS417478
```
Dodanie plików do repozytorium:
```bash
git add .
```
Utworzenie commita:
```bash
git commit -m "PS417478: Dodanie zmian"
```
Wypchanie zmian:
```bash
git push origin PS417478
```

(Niestety ćwiczenie 1 nie zawiera screenów z terminala ze względu na to, że zapomniałam je zrobić)
---
## Lab 2 - Git, Docker
1. Instalacja Dockera w systemie linuksowym

użyj repozytorium dystrybucji, jeżeli to możliwe (zamiast Community Edition)
rozważ niestosowanie rozwiązania Snap (w Ubuntu)
Zarejestruj się w Docker Hub i zapoznaj z sugerowanymi obrazami
Pobierz obrazy hello-world, busybox, ubuntu lub fedora, mysql
Uruchom kontener z obrazu busybox
Pokaż efekt uruchomienia kontenera
Podłącz się do kontenera interaktywnie i wywołaj numer wersji
Uruchom "system w kontenerze" (czyli kontener z obrazu fedora lub ubuntu)
Zaprezentuj PID1 w kontenerze i procesy dockera na hoście
Zaktualizuj pakiety
Wyjdź
Stwórz własnoręcznie, zbuduj i uruchom prosty plik Dockerfile bazujący na wybranym systemie i sklonuj nasze repo.
Kieruj się dobrymi praktykami
Upewnij się że obraz będzie miał git-a
Uruchom w trybie interaktywnym i zweryfikuj że jest tam ściągnięte nasze repozytorium
Pokaż uruchomione ( != "działające" ) kontenery, wyczyść je.
Wyczyść obrazy
Dodaj stworzone pliki Dockefile do folderu swojego Sprawozdanie1 w repozytorium.

--- 
## Lab 3


--- 
## Lab 4

