# Sprawozdanie 1 
## Miłosz Dębowski [MD415045]

# Zajęcia 1


# Wprowadzenie, Git, Gałęzie, SSH
### 1. Zainstalowanie klienta Git i obsługi kluczy SSH
- Instalacja git na maszynie wirtualnej Fedora Server.
    ```
    dnf update
    dnf install git
    ```
-  Instalacja SSH
    ```
    dnf install openssh-clients
    dnf install openssh-server
    ```
-  Zrzut ekranu przedstawiający zainstalowane wersje

    ![ss1](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20153948.png)
### 2. Sklonowanie [repozytorium przedmiotowego](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO) za pomocą HTTPS i [*personal access token*](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

```
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
![ss2](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20161845.png)


### 3. Upewnienie się w kwestii dostępu do repozytorium jako uczestnik i sklonowanie go za pomocą utworzonego klucza SSH, zapoznanie się z [dokumentacją](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
- Utworzenie dwóch kluczy SSH, innych niż RSA, w tym co najmniej jednego zabezpieczonego hasłem.
   ```
   ssh-keygen -t ed25519 -C "14milosz@gmail.com"
   ssh-keygen -t ecdsa -C "14milosz@gmail.com"
   ```
   ![ss3](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20162206.png)
   - Jeden z kluczy jest zabezpieczony hasłem co powtwierdziłem następującą komedną
        ```
        ssh-add ~/.ssh/id_ecdsa
        ```
        ![ss4](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20162440.png)
- Skonfigurowanie klucza SSH jako metody dostępu do GitHuba
   ![ss5](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20163034.png)
- Potwierdzenie, czy klucz SSH został poprawnie skonfigurowany
   ```
   ssh -T git@github.com
   ```
   ![ss6](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20163334.png)
- Sklonowanie repozytorium z wykorzystaniem protokołu SSH
   ```
   git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
   ```
- Skonfigurowanie 2FA

   ![ss7](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20163853.png)
### 4. Przełączenie się na gałąź ```main```, a potem na gałąź swojej grupy (pilnowanie gałęzi i katalogu!)
- Przełączenie się na gałąź `main`
    ```
    git checkout main
    ```
- Przełączenie się na gałąź grupy nr. 6 `GCL06`
    ```
    git checkout GCL06
    ```
    ![ss8](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20164319.png)
### 5. Utworzenie gałęzi o nazwie "inicjały & nr indeksu" - `MD415045`
```
git checkout -b MD415045
```
![ss9](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20164709.png)
### 6. Rozpoczęcie pracy na nowej gałęzi
   - W katalogu właściwym dla grupy utworzenie nowego katalogu, także o nazwie "inicjały & nr indeksu" - `MD415045`
```
mkdir MD41045
```
![ss10](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20164833.png)
- Przejście do katalogu z hookami Git

    ![ss11](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20165842.png)

    ```
    cd .git/hooks/
    ```
- Stworzenie pliku hooka i napisanie skryptu weryfikującego wiadomości commitów
    ```
    nano commit-msg
    ```
    ```bash
    #!/bin/bash

    PREFIX="MD415045"

    test "$(head -n1 "$1" | grep -E "^$PREFIX")" || {
        echo "ERROR: Wiadomość commita musi zaczynać się od: '$PREFIX'"
        exit 1
    }

    exit 0
    ```
    ![ss12](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20170041.png)
- Upewnienie, że plik hooka jest wykonywalny
    ```
    chmod +x commit-msg
    ```
    ![ss13](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20170204.png)
- Test hook'a
    ![ss14](../Sprawozdanie1/Zrzut%20ekranu%202025-03-11%20174047.png)
---
# Zajęcia 02


# Git, Docker


### Zestawienie środowiska

#### 1. Zainstalowanie Docker w na Fedorze
```
sudo dnf -y install dnf-plugins-core
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
```
![ss15](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20171223.png)
![ss16](../Sprawozdanie1/Zrzut%20ekranu%202025-03-11%20175057.png)
#### 2. Pobranie obrazów `hello-world`, `busybox`, `fedora`, `mysql`
- Pobranie obrazu `fedora`
    ```
    docker pull fedora
    ```
    ![ss17](../Sprawozdanie1/Zrzut%20ekranu%202025-03-11%20175215.png)
- Pobranie obrazu `hello-world`
    ```
    docker run hello-world
    ```
    ![ss18](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20172049.png)
- Pobranie obrazu `busybox`
    ```
    docker run busybox
    ```
    ![ss18](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20172145.png)
- Pobranie obrazu `mysql`
    ```
    docker run mysql
    ```
    ![ss19](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20172347.png)
- Zrzut ekranu przedstawiajaący wszystkie porbane obrazy
    ![ss20](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20172429.png)

#### 3. Uruchomienie kontenera z obrazu `busybox`
```
docker run -tty busybox
```
`-tty` - podpięcie terminala do kontenera

![ss21](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20173724.png)
#### 4. Uruchomienie "systemu w kontenerze" czyli kontenera z obrazu `fedora`
- Uruchomienie kontenera z obrbazu `fedora`
    ```
    docker run -dit --name my_docker fedora
    ```
    ![ss22](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20174219.png) 
- Zaprezentowanie `PID1` w kontenerze i procesów dockera na hoście
    - `PID1` w kontenerze
    ```
    ps -p 1
    ```
    ![ss23](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20174555.png)
    - Procesy dockera na hoście
    ```
    ps aux | grep docker
    ```
    ![ss24](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20174749.png)
- Zaktualizowanie pakietów
    ```
    dnf update && upgrade -y
    ```
    ![ss25](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20174942.png)
- Wyjście z kontenera
    ```
    exit
    ```
#### 5. Stworzenie własnoręcznie, zbudowanie i uruchomienie prostego pliku `Dockerfile` bazującego na wybranym systemie i sklonowanie naszego repo.
- Utworzenie pliku `Dockerfile`
    ```Dockerfile
    FROM fedora:latest

    RUN dnf update -y && dnf install -y git vim curl


    WORKDIR /app


    COPY . /app
    RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
    CMD ["/bin/bash"]
    ```
    ![ss26](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20180746.png)
- Zbudowanie obrazu
    ```
    docker build -t moj_obraz
    ```
    ![ss26](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20180903.png)
- Wyświetlenie dostępnych obrazów
    ```
    docker images
    ```
    ![ss27](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20181118.png)
- Urudchomienie kontenera z stworzonego obrazu `moj_obraz`
    ```
    docker run -it moj_obraz:latest
    ```
    ![ss28](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20181218.png)
#### 7. Pokazanie uruchomionych ( != "działających" ) kontenerów, wyczyszczenie ich.
- Wyświetlenie uruchomionych kontenerów
    ```
    docker ps -a
    ```
    ![ss29](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20181218.png)
- Wyczyszczenie kontenerów
    ```
    docker rm nazwa_kontenera
    ```
    ```
    docker rm id_kontenera
    ```
    ![ss30](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20181602.png)
# Zajęcia 03

## Dockerfiles, kontener jako definicja etapu

### Repozytoria programów
- [Irssi](https://github.com/irssi/irssi)
- [Node-js-dummy-test](https://github.com/devenes/node-js-dummy-test)

#### 1. Przeprowadzenie testów - irssi
- Klonowanie repozytorium:
    ```
    git clone https://github.com/irssi/irssi.git
    ```
    ![ss31](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20183613.png)
- Instalacja `meson`:
    ```
    dnf install meson
    ```
- Sprawdzenie brakujących zależności:
    ```
    meson build
    ```
    ![ss32](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20183650.png)
- Instalacja potrzebnych zależności:
    ```
    dnf -y install meson gcc glib2-devel openssl-devel ncurses-devel utf8proc-devel cmake pkg-config libssl-devel perl-devel perl-ExtUtils*
    ```
    ![ss33](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20183741.png)
    *Brak odpowiednich zrzutów ekranu jest spowodowany zawieszeniem się komputera*
- Zbudowanie aplikacji i uruchomienie testów:
    ```
    meson build
    ```
    ```
    ninja test
    ```
    ![ss34](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20184116.png)

#### 2. Przeprowadzenie buildu irssi interaktywnie w kontenerze
- Uruchomienie kontenera z obrazu Fedory:
    ```
    docker run -it --rm fedora bash
    ```
- Sklonowanie repozytorium:
    ```
    git clone https://github.com/irssi/irssi.git
    ```
- Instalacja zależności i zbudowanie obrazu:
    ```
    dnf -y install meson gcc glib2-devel openssl-devel ncurses-devel utf8proc-devel cmake pkg-config libssl-devel perl-devel perl-ExtUtils*
    ```
    ```
    meson build
    ninja -C /irssi/Build
    ```
    ![ss35](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20185920.png)
    ![ss36](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20185957.png)

---

Utworzenie pliku `irssi-build.Dockerfile` - do budowania aplikacji:

```dockerfile
FROM fedora

RUN dnf -y update && dnf -y install git meson ninja* gcc glib2-devel utf8proc* ncurses* perl-Ext*

RUN git clone https://github.com/irssi/irssi.git
WORKDIR /irssi
RUN meson build
RUN ninja -C /irssi/Build
```

Utworzenie pliku `irssi-test.Dockerfile` - do tworzenia obrazu z uruchomionymi testami:

```dockerfile
FROM irssi-builder

WORKDIR /irssi/Build
RUN ninja test
```

Do zbudowania obrazu kontenera używamy polecenia:
```
docker build -t irssi-builder -f ./irssi-build.Dockerfile .
```
Po wykonaniu tego polecenia, Docker tworzy obraz na podstawie pliku `irssi-build.Dockerfile`, który zawiera instrukcje potrzebne do zbudowania naszej aplikacji. Obraz ten oznaczamy tagiem `irssi-builder`.

Sprawdzając dostępne obrazy za pomocą `docker images`, zobaczymy, że zbudowaliśmy obraz kontenera:

![](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20212121.png)

Z zbudowanego obrazu możemy uruchomić kontener poleceniem:
```
docker run irssi-builder
```
Jednak, zgodnie z naszą konfiguracją, kontener ten zakończy działanie od razu po uruchomieniu, ponieważ nie został zaprojektowany do długotrwałego działania czy interaktywnego użytkowania. Obraz ten ma służyć wyłącznie do zbudowania naszej aplikacji, a nie do jej uruchomienia czy użytkowania.

Aby przetestować naszą aplikację, tworzymy inny obraz Docker, tym razem z przeznaczeniem do uruchamiania testów. Do tego celu używamy innego Dockerfile:
```
docker build -t irssi-tester -f ./irssi-test.Dockerfile .
```
Tym sposobem zbudowany obraz `irssi-tester` jest przeznaczony do uruchamiania testów (np. przy użyciu `ninja test`). Podobnie jak w przypadku budowania, obraz ten jest specjalnie zaprojektowany do wykonania testów i nie jest przeznaczony do długotrwałego działania jako kontener.

![](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20212806.png)

Dzięki takiej konfiguracji, mamy oddzielne obrazy dla procesu budowania (`irssi-builder`) i testowania (`irssi-tester`) naszej aplikacji. Obrazy te są używane wyłącznie do swoich dedykowanych zadań. Uruchomienie kontenera z tych obrazów bezpośrednio nie uruchomi aplikacji ani testów automatycznie. Akcje te wykonujemy tylko poprzez proces budowania Dockera z odpowiednim Dockerfile.

---

### Aplikacja w node

Uruchomienie interaktywne kontenera poleceniem:
```
sudo docker run --rm -it node /bin/bash
```
Aktualizacja listy dostępnych pakietów i ich wersji:
```
apt-get update
```
Sklonowanie repozytorium:
```
git clone https://github.com/devenes/node-js-dummy-test
```
W katalogu `node-js-dummy-test` instalujemy potrzebne zależności:
```
npm install
```
Uruchomienie testów:
```
npm run test
```
![](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20212730.png)

---

#### Automatyzacja procesu korzystając z plików Dockerfile

Utworzenie plików `node-build.Dockerfile`, `node-test.Dockerfile` oraz `node-deploy.Dockerfile`

**node-build.Dockerfile**
```dockerfile
FROM node

RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test

RUN npm install
```

**node-test.Dockerfile**
```dockerfile
FROM node-builder

RUN npm test
```

**node-deploy.Dockerfile**
```dockerfile
FROM node-builder

CMD ["npm", "start"]
```

Budowanie obrazów:
```
docker build -t node-builder -f ./node-build.Dockerfile .
docker build -t node-tester -f ./node-test.Dockerfile .
docker build -t node-deploy -f ./node-deploy.Dockerfile .
```
![](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20212633.png)

Uruchomienie aplikacji:
```
docker run --rm node-deploy
```
![](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20212525.png)

---


# Zajęcia 04
#### 1. Zbudowanie obrazu kontenera z poprzednich laboratoriów
```
docker build -t base-node .
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20203352.png)
#### 2. Przygotowanie woluminów wejściowego i wyjściowego, i podłączenie ich do kontenera bazowego.
- Przygotowanie woluminów
    ```
    docker volume create input_volume
    docker volume create output_volume
    ```
    ![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20202224.png)
    
#### 3. Uruchomienie kontenera
```
docker run -it --name base-cont -v input_volume:/input -v output_volume:/output node-base bash
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20202620.png)
#### 4. Sklonowanie repozytorium na wolumin wejściowy (opisanie dokładnie, jak zostało to zrobione)
Sklonowanie repozytorium do wolumina wejściowego za pomocą `docker copy`
```
docker cp ../node-js-dummy-test base-cont:/input
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20203653.png)
#### 6. Instalacja zależności i testowanie
```
npm install
```
```
npm test
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20204250.png)
#### 7. Przeniesienie zbudowanego programu do woluminu wyjściowego
```
cp -r /input/node-js-dummy-test/ /output/
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20204310.png)
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20204401.png)
### Eksponowanie portu

#### 1. Uruchomienie wewnątrz kontenera serwera iperf (iperf3)
- Pobranie obrazu
    ```
    docker pull networkstatic/iperf3
    ```
    ![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20204639.png)
- Uruchomienie obrazu
    ```
    docker run -it --name=perfcont -p 5201:5201 networkstatic/iperf3 -s
    ```
    ![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20204919.png)
#### 3. Połączenie się z nim z drugiego kontenera, zbadanie ruchu
- Zbadanie ruchu
    ```
    docker inspect perfcont
    ```
    ![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20205109.png)
- Podłączenie się z drugiego kontenera
    ```
    docker run -it --name=drugi networkstatic/iperf3 -c 172.21.255.66
    ```
    ![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20205242.png)
#### 4. Pobranie iperf3
```
dnf install iperf3
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20205533.png)
#### 5. Łączenie się z hosta i zbadanie ruchu
```
iperf3 -c localhost -p 5201
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20205626.png)
#### 6. Połączenie się spoza hosta
```Powershell
.\iperf3.exe -c 172.21.255.66 -p 5201
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20205843.png)

#### 7. Przedstawienie przepustowości komunikacji poprzez wyciągnięcie logów
```
docker logs perfcont > logs.txt
```
```
-----------------------------------------------------------
Server listening on 5201 (test #1)
-----------------------------------------------------------
Accepted connection from 172.18.0.1, port 52652
[  5] local 172.18.0.3 port 5201 connected to 172.18.0.1 port 52660
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  6.48 GBytes  55.6 Gbits/sec                  
[  5]   1.00-2.00   sec  6.45 GBytes  55.4 Gbits/sec                  
[  5]   2.00-3.00   sec  6.40 GBytes  55.0 Gbits/sec                  
[  5]   3.00-4.00   sec  6.30 GBytes  54.2 Gbits/sec                  
[  5]   4.00-5.00   sec  6.27 GBytes  53.9 Gbits/sec                  
[  5]   5.00-6.00   sec  6.26 GBytes  53.8 Gbits/sec                  
[  5]   6.00-7.00   sec  6.22 GBytes  53.5 Gbits/sec                  
[  5]   7.00-8.00   sec  6.25 GBytes  53.7 Gbits/sec                  
[  5]   8.00-9.00   sec  6.13 GBytes  52.7 Gbits/sec                  
[  5]   9.00-10.00  sec  6.23 GBytes  53.5 Gbits/sec                  
[  5]  10.00-10.00  sec   384 KBytes  18.4 Gbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.00  sec  63.0 GBytes  54.1 Gbits/sec                  receiver
-----------------------------------------------------------
Server listening on 5201 (test #2)
-----------------------------------------------------------
Accepted connection from 172.18.0.1, port 53392
[  5] local 172.18.0.3 port 5201 connected to 172.18.0.1 port 53400
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  6.90 GBytes  59.2 Gbits/sec                  
[  5]   1.00-2.00   sec  6.80 GBytes  58.4 Gbits/sec                  
[  5]   2.00-3.00   sec  6.80 GBytes  58.4 Gbits/sec                  
[  5]   3.00-4.00   sec  6.80 GBytes  58.4 Gbits/sec                  
[  5]   4.00-5.00   sec  6.80 GBytes  58.4 Gbits/sec                  
[  5]   5.00-6.00   sec  6.76 GBytes  58.1 Gbits/sec                  
[  5]   6.00-7.00   sec  6.81 GBytes  58.5 Gbits/sec                  
[  5]   7.00-8.00   sec  6.82 GBytes  58.6 Gbits/sec                  
[  5]   8.00-9.00   sec  6.82 GBytes  58.6 Gbits/sec                  
[  5]   9.00-10.00  sec  6.57 GBytes  56.4 Gbits/sec                  
[  5]  10.00-10.00  sec  7.06 MBytes  49.9 Gbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.00  sec  67.9 GBytes  58.3 Gbits/sec                  receiver
-----------------------------------------------------------
Server listening on 5201 (test #3)
-----------------------------------------------------------
Accepted connection from 172.21.240.1, port 56249
[  5] local 172.18.0.3 port 5201 connected to 172.21.240.1 port 56250
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  1.16 GBytes  9.94 Gbits/sec                  
[  5]   1.00-2.00   sec  1.16 GBytes  10.0 Gbits/sec                  
[  5]   2.00-3.00   sec  1.19 GBytes  10.2 Gbits/sec                  
[  5]   3.00-4.00   sec  1.19 GBytes  10.2 Gbits/sec                  
[  5]   4.00-5.00   sec  1.19 GBytes  10.2 Gbits/sec                  
[  5]   5.00-6.00   sec  1.18 GBytes  10.2 Gbits/sec                  
[  5]   6.00-7.00   sec  1.20 GBytes  10.3 Gbits/sec                  
[  5]   7.00-8.00   sec  1.19 GBytes  10.2 Gbits/sec                  
[  5]   8.00-9.00   sec  1.14 GBytes  9.79 Gbits/sec                  
[  5]   9.00-10.00  sec  1.17 GBytes  10.1 Gbits/sec                  
[  5]  10.00-10.02  sec  15.5 MBytes  7.62 Gbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.02  sec  11.8 GBytes  10.1 Gbits/sec                  receiver
-----------------------------------------------------------
Server listening on 5201 (test #4)
-----------------------------------------------------------
```
### Instancja Jenkins

#### 1. Utworzenie i uruchomienie kontenera Jenkins

```
docker network create jenkins
```
![](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20210447.png)

```
docker run \
  --name jenkins-docker \
  --rm \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind \
  --storage-driver overlay2
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20210843.png)

#### 2. Utworzenie dockerfile 
```dockerfile
FROM jenkins/jenkins:2.440.2-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20210908.png)
#### 3. Stworzenie kontenera
```
docker build -t myjenkins-blueocean:2.440.2-1 .
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20210942.png)
```
docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.440.2-1
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20211029.png)

#### 4. Wyświeltenie działających kontenerów
```
docker ps
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20211029.png)

#### 5. Po wejściu na localhost:8080 okno jenkinsa wymaga podania hasła

![](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20211220.png)

Pozyskujemy hasło za pomocą komendy
```
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20211350.png)

Po wpisaniu hasła należy zainstalować wtyczki oraz utworzyć konto
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20211502.png)
![ss](../Sprawozdanie1/Zrzut%20ekranu%202025-03-30%20211523.png)

