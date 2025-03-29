
# LEKCJA 1: Wstęp, Git, Gałęzie, SSH
### 1) Instalacja Git i kluczy SSH Aby rozpocząć pracę z systemem Git oraz zapewnić bezpieczne połączenie przez SSH, zainstalowano odpowiednie narzędzia.

Aby rozpocząć pracę z systemem Git oraz zapewnić bezpieczne połączenie przez SSH, zainstalowano odpowiednie narzędzia.

    sudo apt-get install git
    apt-get install openssh-server
    
![0](https://github.com/user-attachments/assets/07765b4f-d32a-4f9c-affa-23de9d4eb0fd)
![image](https://github.com/user-attachments/assets/895ee287-57fe-4112-a4e4-d5e09884cb07)


### 2) Repozytorium przedmiotowe zostało sklonowane za pomocą polecenia git clone, początkowo używając protokołu HTTPS.
Sklonowanie repozytorium Repozytorium przedmiotowe zostało sklonowane za pomocą polecenia git clone, początkowo używając protokołu HTTPS.

        git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO
![image](https://github.com/user-attachments/assets/e72599c4-0e33-4b7f-b6c6-5c1d67b7c557)


### 3)Generowanie kluczy SSH i zmiana połączenia na SSH Aby zapewnić bezpieczne połączenie z GitHubem bez konieczności każdorazowego podawania loginu i hasła, wygenerowano dwa klucze SSH: jeden dla algorytmu ed25519, drugi dla ecdsa.

        ssh-keygen -t ed25519 -C "kristfolach@gmail.com"
        ssh-keygen -t ecdsa -b 521 -C "kristoflach@gmail.com"
        
![1](https://github.com/user-attachments/assets/46db9f25-13cd-405f-99ed-528a8f4ec90a)
![image](https://github.com/user-attachments/assets/45f65d8c-ff0d-4f9a-a03f-f293719692a7)

Następnie klucze zostały dodane do agenta SSH:

![2](https://github.com/user-attachments/assets/4df17867-5a64-406b-b748-b7c8c7f1f3c5)

Zmieniono połączenie z repozytorium na SSH:

![3](https://github.com/user-attachments/assets/ee421b52-e96b-4656-9902-88015be3ec8a)

### 4) Zmiana gałęzi Po skonfigurowaniu połączenia SSH przełączono się na gałąź główną i gałąź dedykowaną dla grupy.
        git checkout main
        git checkout GCL02
![4 1](https://github.com/user-attachments/assets/f9619c28-f188-4d66-86e0-fff7b3ee38c2)
![4 2](https://github.com/user-attachments/assets/2686ca3a-171f-4db6-be8d-b18f3bace47d)

### 5) Stworzenie nowej gałęzi Utworzono nową gałąź o nazwie KP415903, odgałęziając ją od gałęzi grupowej.

        git checkout -b KL414598
![4 3](https://github.com/user-attachments/assets/6d213f69-3617-445c-8e30-a83fc474f3e1)


### 6)Praca na nowej gałęzi W odpowiednim katalogu stworzono folder o nazwie KL414598. Utworzono również Git hooka, który sprawdza, czy wiadomość commit zaczyna się od "KL414598".
        mkdir -p .git/hooks
        cd .git/hooks
        touch pre-commit
        nano pre-commit
        chmod +x pre-commit

        #!/bin/bash
        EXPECTED_PREFIX="KL414598"
        COMMIT_MSG=$(cat "$1")
        if [[ "$COMMIT_MSG" != $EXPECTED_PREFIX* ]]; then
        echo "Error: Początek wiadomości musi zaczynać się od '$EXPECTED_PREFIX'."
        exit 1
        fi
![6](https://github.com/user-attachments/assets/8fd9e204-ba37-4244-9049-c1a8c3f76b64)
![5](https://github.com/user-attachments/assets/bdb9f5e7-a6ab-464e-9a94-ea9c6d74eef3)




# LEKCJA 2: Instalacja i podstawowa konfiguracja Dockera na Linuxie

## Instalacja Dockera

### 1) Instalacja Dockera z repozytorium dystrybucji
Jeżeli to możliwe, korzystam z repozytorium mojej dystrybucji zamiast Docker Community Edition (CE).

```sh
sudo apt update
sudo apt install docker.io
git -v
sudo docker run hello-world
```
![image](https://github.com/user-attachments/assets/e003c990-7ee2-4543-9369-e550e47d8ee9)
![image](https://github.com/user-attachments/assets/a4917653-5cdc-40a8-b3c1-3f885927fef2)


Uruchomienie i automatyczne startowanie Dockera
```sh
sudo systemctl enable --now docker
```
![9](https://github.com/user-attachments/assets/bbefe96c-1a17-4cd7-9759-26b39a5f1e3c)

---

### 2) Rejestracja w Docker Hub

Rejestruję się na stronie: [https://hub.docker.com/](https://hub.docker.com/) i zapoznaję się z sugerowanymi obrazami.

![10](https://github.com/user-attachments/assets/bf497b8a-dfdd-46b7-a1ba-4e17e97ed46a)


### 3) Pobranie podstawowych obrazów
```sh
docker pull hello-world
docker pull busybox
docker pull ubuntu
docker pull fedora
docker pull mysql
```

![11](https://github.com/user-attachments/assets/f5ac210d-1c8b-457d-bf59-854d50034999)

---

### 4) Uruchomienie kontenera z obrazu busybox
```sh
docker run busybox echo "Hello from BusyBox"
```
![12](https://github.com/user-attachments/assets/65370449-a06a-42a3-9e7c-aca2ac62589e)

Efekt uruchomienia powinien wyświetlić komunikat "Hello from BusyBox".

```sh
docker run -it busybox sh
```
W środku kontenera sprawdzam wersję systemu:
```sh
uname -a
exit
```
![13](https://github.com/user-attachments/assets/2615618d-f056-4ea0-bd1e-1eea2c8f449b)

### 5) Uruchomienie pełnego systemu w kontenerze
```sh
docker run -it ubuntu bash
```
![14](https://github.com/user-attachments/assets/0d1ceec7-7beb-4ba2-a0e8-136fe6d67a53)

W środku sprawdzam PID1 i procesy Dockera na hoście:
```sh
ps aux
exit
```
![15](https://github.com/user-attachments/assets/0b5da344-fc58-4aaf-b358-e66f14ea62ef)


### 6) Aktualizacja pakietów w kontenerze
```sh
docker run -it ubuntu bash 
apt update && apt upgrade -y
```
![16](https://github.com/user-attachments/assets/4abd3c5c-1fcb-484f-b1e4-aac85a91ac79)

---


### 7) Tworzenie pliku `Dockerfile`
W folderze `Sprawozdanie1` tworzę plik `Dockerfile`:
```Dockerfile
FROM ubuntu:latest
RUN apt update && apt install -y git
WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
CMD ["/bin/bash"]
```
![17](https://github.com/user-attachments/assets/39287d0a-0cd2-48c6-860f-ced6457b4ef3)

uruchamianie obrazu
```sh
docker build -t obraz .
docker run -it obraz
```
![18](https://github.com/user-attachments/assets/c3e9de51-f06e-4b51-8168-bf146b0d01bf)

Sprawdzam, czy repozytorium zostało pobrane:
```sh
ls /app
```
![19](https://github.com/user-attachments/assets/2288243b-3207-41cd-a509-97f3cca8a097)

---

### 7) Zarządzanie kontenerami i obrazami

Lista uruchomionych i wszystkich kontenerów
```sh
docker ps -a
```
![20](https://github.com/user-attachments/assets/c307540b-e82a-4857-bf59-1cb97ebe329b)

Usuwanie kontenerów
```sh
docker rm $(docker ps -aq)
```
![21](https://github.com/user-attachments/assets/15444acb-0ac6-4536-a052-fa4a3e6a9f95)

Czyszczenie obrazów
```sh
docker rmi moj_obraz busybox ubuntu fedora mysql hello-world
```
![image](https://github.com/user-attachments/assets/cf8a41c8-4b71-4c5c-a98c-4e3b4b4dace1)


# LEKCJA 3: Dockerfiles, kontener jako definicja etapu

### 1) Wybór oprogramowania

Do przeprowadzenia ćwiczenia wybrano repozytorium cJSON,
![23](https://github.com/user-attachments/assets/de7d178d-68bb-44f7-9e28-fe484ed96a8f)

które skonowałem poleceniem: 

    git clone https://github.com/DaveGamble/cJSON
![24](https://github.com/user-attachments/assets/6ec3b844-2e15-4a12-abfd-24b8b82051c3)


zawierające oprogramowanie na otwartej licencji, spełniające następujące wymagania:

-Jest dostępne publicznie i posiada otwartą licencję.

-Zawiera skrypt Makefile umożliwiający kompilację (make build) oraz uruchomienie testów (make test).

-Posiada testy jednostkowe z jednoznacznym raportem wyników.

Repozytorium zostało sklonowane, a następnie przeprowadzono kompilację 
    
    make

![25](https://github.com/user-attachments/assets/37077354-3abd-4b7e-9286-9bf21abb6b8c)
oraz uruchomienie testów zgodnie z instrukcjami w dokumentacji poleceniem

    make test
    
![26](https://github.com/user-attachments/assets/776b7512-b500-4fe7-9e7a-1933c8bbb74c)

### 2)Przeprowadzenie buildu w kontenerze
Ponieważ cJSON jest biblioteką napisaną w języku C, odpowiednim wyborem będzie użycie obrazu bazowego Ubuntu, który zapewnia niezbędne narzędzia do kompilacji.
![27](https://github.com/user-attachments/assets/1c0c6d0e-9ab2-4b93-bff8-73a41b72630d)
Pierwszy plik Dockerfile (Dockerfile.build) będzie odpowiedzialny za zbudowanie aplikacji.​
![28](https://github.com/user-attachments/assets/0784426b-0141-4fd2-b77b-32dcb4cee9c7)

Drugi plik Dockerfile (Dockerfile.test) będzie bazować na obrazie zbudowanym w poprzednim etapie i będzie odpowiedzialny za uruchomienie testów.​
![29](https://github.com/user-attachments/assets/8adb260e-3ec7-43fd-a2d9-92d297c3fd75)

Budowanie i uruchamianie kontenerów:
![30](https://github.com/user-attachments/assets/8dfbd9e7-0d6b-458e-9d73-7f6fd75eb121)
![31](https://github.com/user-attachments/assets/eb8e86b8-0053-44ff-a8cd-dd79afda83e4)
![32](https://github.com/user-attachments/assets/9aa4deb3-96fb-409e-a36f-ef7852b8cc83)


# LEKCJA 4: Sprawozdanie z zadania: Wykorzystanie woluminów Docker

Zadanie polegało na wykorzystaniu woluminów Docker do zarządzania kodem źródłowym i wynikami kompilacji. Zgodnie z instrukcją, zapoznałem się z dokumentacją Docker dotyczącą woluminów i bind mount, a następnie wykonałem szereg operacji wykorzystujących te mechanizmy.


Utworzyłem dwa woluminy: wejściowy (dla kodu źródłowego) i wyjściowy (dla skompilowanych plików):

    docker volume create input-vol
    docker volume create output-vol
    
![33](https://github.com/user-attachments/assets/ede8aec1-fb8f-4184-afbe-4c4b1cf6f043)

Sprawdziłem, czy woluminy zostały utworzone:

## Wariant 1: Klonowanie repozytorium na wolumin wejściowy z zewnątrz kontenera

Aby sklonować repozytorium na wolumin wejściowy, użyłem kontenera pomocniczego z zainstalowanym git:

![34](https://github.com/user-attachments/assets/1b2ae6b1-362b-47cc-9433-e00d94fbf646)

![35](https://github.com/user-attachments/assets/40a268b8-660a-4d11-816a-0e3fe99ec764)

sprawdziłem zawartość woluminu na hoście: 

![36](https://github.com/user-attachments/assets/ffb9e133-247f-476e-87a4-2d44717dcdf6)


Użyłem dedykowanego kontenera pomocniczego alpine/git, który:

-Jest lekkim kontenerem bazującym na Alpine Linux

-Ma preinstalowany git, więc nie musiałem instalować go w kontenerze bazowym

-Działa tylko przez czas potrzebny do sklonowania repozytorium (flaga --rm automatycznie usuwa kontener po zakończeniu działania)

Montowanie woluminu
Wolumin input-vol został zamontowany w kontenerze pomocniczym w ścieżce /repo:
-v input-vol:/repo - łączy wolumin Docker z katalogiem w kontenerze

Wszystkie pliki zapisane w katalogu /repo w kontenerze zostają zapisane trwale na woluminie

Dane na woluminie pozostają po zakończeniu działania kontenera

## Wariant 2: Klonowanie repozytorium wewnątrz kontenera

Ponownie utworzyłem nowy kontener z obrazu program:

![37](https://github.com/user-attachments/assets/b207b5cc-afa5-4962-bdae-9ed937bdc17a)
![38](https://github.com/user-attachments/assets/434e9189-39d2-4479-bdbd-55c223013da9)

### Eksponowanie portów i testowanie przepustowości sieci w Docker
    
Uruchomienie serwera iperf3 w kontenerze

    docker run -d --name iperf-test ubuntu sh -c "apt update && apt install -y iperf3 && iperf3 -s"
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' iperf-test
    iperf3 -c 172.17.0.2

![39](https://github.com/user-attachments/assets/60d8297e-882a-42bf-900b-f52c5ceaed68)


Stworzyłem dedykowaną sieć mostkową:
![40](https://github.com/user-attachments/assets/99a0ff36-f85c-434a-a07a-10046cbd0e36)




Po raz kolejny utworzyłem kontenery serwera i klienta, tym razem wewnątrz zdefiniowanej sieci. Umieszczenie obu kontenerów w tej samej sieci umożliwiło ich komunikację przy użyciu nazw zamiast konieczności wyszukiwania adresów IP.

    docker network create iperf-network
    docker stop iperf-server
    docker rm iperf-server
    docker run -d --name iperf-server --network iperf-network -p 5201:5201 ubuntu sh -c "apt update && apt install -y iperf3 && iperf3 -s"
    docker run --rm --network iperf-network ubuntu sh -c "apt update && apt install -y iperf3 && iperf3 -c iperf-server"

![41](https://github.com/user-attachments/assets/595ffc2f-9ff6-4239-add6-a1bf95b5b4a1)
![42](https://github.com/user-attachments/assets/5931143e-a8ac-4dae-8c5f-6fc786aa034e)

### Instalacja skonteneryzowanej instancji Jenkins z Docker-in-Docker (DIND)

Najpierw utworzyłem dedykowaną sieć Docker, aby umożliwić komunikację między kontenerem Jenkins a kontenerem Docker (DIND):

    docker network create jenkins

![43](https://github.com/user-attachments/assets/c0a31479-bb91-4cb0-ae3b-8137653bb61b)

Następnie uruchomiłem kontener Docker-in-Docker, który będzie służył jako agent budowania oraz stworzyłem kontener Jenkins skonfigurowany do współpracy z Docker-in-Docker:

![44](https://github.com/user-attachments/assets/478942f3-56c1-42fb-9692-6cee8995a714)

![45](https://github.com/user-attachments/assets/1b41a357-5224-4fbc-86d9-30a8167b1832)

ekran logowania:
![46](https://github.com/user-attachments/assets/f2224f5a-5f25-4491-904f-4535fc4159eb)
ekran po wpisaniu hasła z terminala: 
![47](https://github.com/user-attachments/assets/ca639f12-70e3-4871-8744-f20a5c773f96)



