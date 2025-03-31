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
### 1. Instalacja Dockera 
```bash
sudo dnf install -y dnf-plugins-core
sudo dnf install -y docker
sudo systemctl start docker
sudo systemctl enable docker
```
Sprawdzenie instalacji:
```bash
docker --version
```
### 2. Rejestracja w Docker i logowanie 
Po zarejestrowaniu się na stronie Docker Hub zalogowałam się na fedorze:
```bash
docker login
```
### 3. Pobranie obrazów hello-world, busybox, fedora, mysql
Poleceniami:
```bash
sudo docker pull hello-world
sudo docker pull busybox
sudo docker pull fedora
sudo docker pull mysql
```
Sprawdzenie:
```bash
sudo docker images
```
![zdj2](screenshots/2.png)

### 4. Uruchomienie kontenerów
```bash
sudo docker run -it busybox sh
```
![zdj3](screenshots/3.png)
Wyjście `exit`

Poleceniem sprawdzam że istnieje:
```bash
sudo docker ps -a
```
![zdj4](screenshots/4.png)

### 5. Tworzenie własnego Dockerfile
Poleceniem:
```bash
nano Dockerfile
```
Mój dockerfile wygląda następująco:
```bash
FROM fedora:latest

RUN dnf update -y && dnf install -y git && dnf clean all

WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["/bin/bash"]
```
Buduje obraz:
```bash
sudo docker built -t my-fedora-image .
```
![zdj5](screenshots/5.png)

Nastepnie poleceniami jak wyżej sprawdzam liste kontenerów, zatrzymuje je i usuwam:
```bash
sudo docker ps -a
sudo docker image prune -a -f
```
![zdj6](screenshots/6.png)
![zdj7](screenshots/7.png)

### 6. Dodanie utworzonych plików:
```bash
git add .
git commit -m "PS417478: docker"
git push origin PS417478
```
--- 
## Lab 3


--- 
## Lab 4

