# Sprawozdanie 1 
## Zajęcia 01: Wprowadzenie, Git, Gałęzie, SSH

1. Zainstalowano klienta Git oraz obsługę kluczy SSH dla systemu Ubuntu Server 
```
sudo apt update
sudo apt install git openssh-client -y
```
![obraz](KM/lab1/zajecia/1.png)

2. Następnie za pomocą HTTPS oraz personal access token zostało sklonowane repozytorium przedmiotowe
```
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
![obraz](KM/lab1/zajecia/klonowanie_https.png)

3. Utworzono dwa klucze SSH, zabezpieczone hasłem
```
ssh-keygen -t ed25519 -C "katarzynamad@student.agh.edu.pl"
ssh-keygen -t ecdsa -b 521 -C "katarzynamad@student.agh.edu.pl"
```
![obraz](KM/lab1/zajecia/klucz_gen1.png)
![obraz](KM/lab1/zajecia/klucz_ecdsa.png)

4. Utworzony klucz SSH konfigurejemy jako metodę dostępu do GitHub
```
cat .ssh/id_ed25519.pub
```
![obraz](KM/lab1/zajecia/konfiguracja.png)
![obraz](KM/lab1/zajecia/konfiguracja1.png)

5. Za pomocą SSH sklonowano repozytorium przedmiotowego
```
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
![obraz](KM/lab1/zajecia/klonowanie_ssh.png)

6. Skonfigurowano również na GitHubie uwierzytelnianie dwuskładnikowe 2FA
![obraz](KM/lab1/zajecia/2fa.png)

7. W sklonowanym repozytorium przełączono się do gałęzi *main*, a potem na gałąź mojej grupy (5) gdzie został utworzony nowy branch - ```KM417392```
```
cd MDO2025_INO
git checout main
git checkout GCL05
git checkout -b KM417392
```
![obraz](KM/lab1/zajecia/galaz-main.png)
![obraz](KM/lab1/zajecia/galaz%20GCL05.png)

8. Utworzono również nowy folder "KM417392"
```
cd ITE/GCL05/
mkdir KM417392
```
![obraz](KM/lab1/zajecia/folder.png)

9. Następnie w folderze: ```.git/hooks``` napisano nowy skrypt weryfikujący  (każdy "commit message" zaczyna się od "KM417392").
W nowo utworzonym pliku "commit-msg" napisano skrypt oraz przyznano uprawnienia do wykonywania.
Plik został również skopiowany do osobistego folderu.
```
cd ~/MDO2025_INO/.git/hooks/
nano commit-msg
chmod +x commit-msg
```
![obraz](KM/lab1/zajecia/uprawnienia-hook.png)
```
#!/bin/sh

pattern="^KM417392"

if ! grep -qE "$pattern" "$1"; then
    echo "Commit message must start with 'KM417392'" >&2
    exit 1
fi
```
![obraz](KM/lab1/zajecia/git_hook.png)

10. W katalogu ```KM417392``` utworzono folder "Sprawozdanie1" oraz w nim umieszczono ważne pliki (Readme.md oraz zrzuty ekranu - folder "KM")
```
mkdir Sprawozdanie1
cd Sprawozdanie1
touch Readme.md
```
11. Gotowe pliki dodajemy najpierw do staging area (obszar przygotowania do commitowania)
```
git add .
git status
```
![obraz](KM/lab1/zajecia/git%20add.png)

12. Zatwierdzenie zmian z staging area do lokalnej historii repozytorium. Pliki są teraz zapisane w lokalnej gałęzi.
```
git commit -m  "KM417392: add ss"
```
![obraz](KM/lab1/zajecia/spraw.png)
- Sprawdzenie czy działa poprawnie Git hook wcześniej zapisany
![obraz](KM/lab1/zajecia/dziala_hook.png)

13. Wypychanie plików do zdalnego repozytorium na Githubie
```
git push origin KM417392
```
![obraz](KM/lab1/zajecia/push.png)

## Zajęcia 02: Git, Docker

1. Zainstalowano Docker w systemie Ubuntu Server
```
sudo apt install docker.io
```
![obraz](KM/lab2/instalacja@20docker.png)

2. Następnie zarejestrowano się w DockerHub i zalogowano przez maszyne
```
docker login
```
![obraz](KM/lab2/logowanie%20docker.png)

3. Pobrano obrazy hello-world, busybox, ubuntu, mysql
```
docker pull ubuntu
```
Aby uniknąć wpisywania za każdym razem "sudo":
```
sudo usermod -aG docker $USER
```
![obraz](KM/lab2/logowanie%20docker.png)
```
docker images
```
![obraz](KM/lab2/pobrane_zdj.png)

4. Uruchomiono kontener z obrazu *busybox*
- Bez podłączenia się do kontenera interaktywnie 
```
docker run busybox echo "Kontener BusyBox uruchomiony"
```
Po wykonaniu komendy *echo*, natychmiast kończy swoje działanie. Kontener się zatrzymuje.
![obraz](KM/lab2/lab2_cz2/busybox-nie-interaktywnie.png)

- Z podłączeniem się do kontenera interaktywnie oraz wyświetleniem PID1 i procesy dockera na hoście
```
docker run -it busybox sh
ps aux
```
![obraz](KM/lab2/lab2_cz2/procesy_dockera.png)

5. Zaktualizowano pakiety oraz wyszło z powłoki shell
```
apt update
apt upgrade
exit
```
![obraz](KM/lab2/lab2_cz2/apt_update.png)
![obraz](KM/lab2/lab2_cz2/apt_upgrade.png)

6. Utworzono i zbudowano nowy plik Dockerfile bazujący na systemie Ubuntu
```
touch Dockerfile
nano Dockerfile
docker build -t nowy_obraz .
```
*Plik Dockerfile*
```
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean


RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

WORKDIR /MDO2025_INO

CMD ["/bin/bash"]
```
![obraz](KM/lab2/lab2_cz2/budowanie_obrazu.png)
- Uruchomiono interaktywnie i sprawdzono czy jest ściągnięte repozytorium
```
docker run -it nowy_obraz
docker ps -a
```
![obraz](KM/lab2/lab2_cz2/uruchomiamy_nowy_obraz.png)

7. Wyświetlenie działających kontenerów oraz ich usunięcie
```
docker ps -a
docker rm $(docker ps -a -q)
```
![obraz](KM/lab2/lab2_cz2/kontenery.png)
![obraz](KM/lab2/lab2_cz2/usuwanie_docker.png)
- usunięcie obrazów
```
docker rmi $(docker images -q)
docker images
``` 
![obraz](KM/lab2/lab2_cz2/czyszczenie_obrazow.png)

