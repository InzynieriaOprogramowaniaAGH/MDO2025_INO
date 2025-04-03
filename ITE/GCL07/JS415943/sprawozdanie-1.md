# Sprawozdanie 1
## Zajęcia 01
### 1. Instalacja git i konfiguracja kluczy ssh
Zainstalowano git za pomocą polecenia:
```bash
sudo dnf install git
```

Następnie wygenerowano parę kluczy ssh za pomocą polecenia:
```bash
ssh-keygen -t ed25519 -C "kuba.swierczynski4@gmail.com"
```
Oraz dodano klucz publiczny do githuba:

![ssh-key](/ITE/GCL07/JS415943/lab1/ssh-key1.png)

Skonfigurowano 2FA

![github-2fa](/ITE/GCL07/JS415943/lab1/github-f2a.png)


### 2. Przy użyciu klucza ssh sklonowano repozytorium przedmiotu
```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

Po sklonowaniu przełączono się na gałąź grupy 7 a z niej stworzono nową 
```bash
git checkout  GCL07
git checkout -b JS415943
```

Następnie utworzono podfolder z inicjałami, numerem indeksu oraz sprawozdaniem:
```bash
mkdir JS415943
cd JS415943
mkdir Sprawozdanie1
cd Sprawozdanie1
touch README.md
touch commit-msg
chmod +x commit-msg
```

### 3. Napisano git hooka o treści
```bash
#!/bin/bash

EXPECTED_PREFIX="JS415943"

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! $COMMIT_MSG =~ ^$EXPECTED_PREFIX ]]; then
    echo "ERROR: Commit message must start with '$EXPECTED_PREFIX'"
    exit 1
fi
```
Skopiowano git hooka do folderu .git/hooks
```bash
cp commit-msg ../../../../.git/hooks/
```

![git-hook1](/ITE/GCL07/JS415943/lab1/git-hook1.png)

Oraz przetestowano działanie

![git-hook2](/ITE/GCL07/JS415943/lab1/git-hook2.png)

### 4. Dodano sprawozdanie oraz wypchnięto zmiany

![git-push](/ITE/GCL07/JS415943/lab1/git-push.png)

## Zajęcia 02
### 1. Instalacje docker i rejestracja w dockerhub

Zainstalowałem dockera poprzez polecenie 
```bash
sudo dnf -y install docker
```

### 2. Pobranie obrazów `hello-world`, `busybox`, `ubuntu`, `fedora` oraz `mysql` 

![docker-images](/ITE/GCL07/JS415943/lab2/images.png)

### 3. Uruchomienie obrazu busybox

Uruchomiłem obraz z poleceniem echo i następnie interaktywnie sprawdzając numer wersji

![busybox](/ITE/GCL07/JS415943/lab2/busybox.png)

### 4. Uruchomienie obrazu ubuntu

Uruchomiłem obraz interaktywnie, sprawdziłem `PID1`, procesy następnie zaaktualizowałem pakiety i wyszedłem

![ubuntu-pid](/ITE/GCL07/JS415943/lab2/docker-ubuntu-pid.png)
![ubuntu-update](/ITE/GCL07/JS415943/lab2/docker-ubuntu-update.png)
![ubuntu-exit](/ITE/GCL07/JS415943/lab2/docker-ubuntu-exit.png)

### 5. Stworzenie pliku `dockerfile`, zainstalowanie na nim gita i sklonowanie repozytorium projektu

Treść pliku dockerfile:
```bash
FROM ubuntu:latest

LABEL maintainer="JS415943"

RUN apt-get update && \
    apt-get install -y git curl && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /app

WORKDIR /app

CMD ["/bin/bash"]
```

Zbudowałem obraz
![docker-build](/ITE/GCL07/JS415943/lab2/docker-my-image-build.png)

A następnie uruchomiłem i sprawdziłem sklonowane rezpozytorium oraz gita
![my-image](/ITE/GCL07/JS415943/lab2/docker-my-image.png)

### 6. Sprawdzenie nie uruchomionych obrazów i wyczyszczenie ich
![docker-clean](/ITE/GCL07/JS415943/lab2/docker-clean.png)

## Zajęcia 03

### 1. Wybór repozytorium

Wybrałem i sklonowałem repozytorium zlib.

![](/ITE/GCL07/JS415943/lab3/zlib-clone.png)

Zainstalowałem wymagane pakiety, zbudowałem oraz uruchomiłem testy

![](/ITE/GCL07/JS415943/lab3/install.png)
![](/ITE/GCL07/JS415943/lab3/configure-build.png)
![](/ITE/GCL07/JS415943/lab3/make-test.png)

### 2. Przeprowadzenie buildu w kontenerze

Uruchomiłem interaktywnie kontener ubuntu 

![](/ITE/GCL07/JS415943/lab3/ubuntu-latest.png)

Sklonowałem repozytorium

![](/ITE/GCL07/JS415943/lab3/ubuntu-clone.png)

Ponownie skonfigurowałem, zbudowałem i uruchomiłem testy
```bash
git clone https://github.com/madler/zlib.git
cd zlib
./configure
make
make test
```
![](/ITE/GCL07/JS415943/lab3/ubuntu-build.png)

### 3. Stworzenie plików Dockerfile dla zautomatyzowania wcześniejszych kroków

Plik `Dockerfile.build`
```Dockerfile
FROM ubuntu:latest

RUN apt-get update && apt-get install -y git gcc make

RUN git clone https://github.com/madler/zlib.git /src/zlib

WORKDIR /src/zlib
RUN ./configure && make
```
Plik `Dockerfile.test`
```Dockerfile
FROM zlib-build

WORKDIR /src/zlib

RUN make test
```

Zbudowałem oba obrazy
```bash
sudo docker build -f Dockerfile.build -t zlib-build .
sudo docker build -f Dockerfile.test -t zlib-test .ls
```
Testy przeszły pomyślnie więc utworzył się obraz zlib-test

![](/ITE/GCL07/JS415943/lab3/docker-test.png)

## Zajęcia 04

## 1. Zachowywanie stanu
### 1.1 Przygotowano woluminy wejściowy i wyjściowy

`input_vol` i `output_vol`

![](/ITE/GCL07/JS415943/lab4/input-output.png)
![](/ITE/GCL07/JS415943/lab4/in-out-vol.png)

Następnie utworzyłem i zbudowałem dockerfile `Dockerfile.nogit` zawierający wymagane pakiety ale bez gita
```Dockerfile
FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    gcc \
    make \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /home/build
```

![](/ITE/GCL07/JS415943/lab4/docker-build.png)

### 1.2 Uruchomiono kontener z przyłączeniem przygotowanych woluminów, sprawdzono czy zainstalowane są wszystkie dependencje oraz czy nie ma gita

![](/ITE/GCL07/JS415943/lab4/docker-run2.png)

### 1.3 Sklonowano repozytorium bezpośrednio do woluminu wejściowego
Użyłem polecenia

`sudo git clone https://github.com/madler/zlib.git $(sudo docker volume inspect --format '{{ .Mountpoint }}' input_vol)` 

przez co klonowanie zostało wykonane bezpośrednio do katalogu woluminu, ponieważ

`sudo docker volume inspect --format '{{ .Mountpoint }}' input_vol`

zwraca ścieżkę w `/var/lib/docker/volumes/...`, czyli dokładne miejsce, w którym Docker przechowuje pliki danego woluminu.

![](/ITE/GCL07/JS415943/lab4/docker-clone.png)
![](/ITE/GCL07/JS415943/lab4/docker-zlib-ls.png)

### 1.4 Uruchomiono build w kontenerze+
![](/ITE/GCL07/JS415943/lab4/zlib-configure.png)

### 1.5 Zapisano powstałe pliki na woluminie wyjściowym aby były dostępne po wyjściu z kontenera

![](/ITE/GCL07/JS415943/lab4/docker-output-zlib-a-so-so1.png)

### 1.6 Ponowiono operacje klonowania ale z środka kontenera

![](/ITE/GCL07/JS415943/lab4/install-git.png)

![](/ITE/GCL07/JS415943/lab4/libz-configure-inside.png)


## 2. Eksponowanie portu

### 2.1 Uruchomiłem kontener z iperf3 na domyślnym porcie i sprawdziłem czy jest on aktywny
![](/ITE/GCL07/JS415943/lab4/iperf-download.png)

### 2.2 Połączyłem się z kontenerem z innego kontenera
![](/ITE/GCL07/JS415943/lab4/iperf-client-connect.png)

### 2.3 Połączyłem się do kontenera z dedykowanej sieci mostkowej
Utworzyłem sieć

![](/ITE/GCL07/JS415943/lab4/network-create.png)

Uruchomiłem serwer iperf oraz klienta w utworzonej sieci

![](/ITE/GCL07/JS415943/lab4/iperf-network.png)

![](/ITE/GCL07/JS415943/lab4/iperf-network-client.png)

### 2.4 Połączyłem się do kontenera spoza niego

![](/ITE/GCL07/JS415943/lab4/iperf-spoza.png)


### 2.5 Zebrałem logi z kontenera
![](/ITE/GCL07/JS415943/lab4/iperf-logs1.png)
![](/ITE/GCL07/JS415943/lab4/iperf-logs2.png)


## 3. Instalacja Jenkins

### 3.1 Uruchomiłem oficjalny obraz
![](/ITE/GCL07/JS415943/lab4/jenkins-docker-run.png)
![](/ITE/GCL07/JS415943/lab4/jenkins-docker-ps.png)

Po wejściu w przeglądarce na `http://192.168.100.40:8080` widoczna była strona logowania 

![](/ITE/GCL07/JS415943/lab4/jenkins-login.png)

