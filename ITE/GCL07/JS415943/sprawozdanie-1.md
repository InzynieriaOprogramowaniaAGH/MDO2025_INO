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

Następnie utworzono podfolder z inicjałami, numerem indeksu oraz sprawozdniem:
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
sudo dnt -y install docker
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
```bash
FROM ubuntu:latest

RUN apt-get update && apt-get install -y git gcc make

RUN git clone https://github.com/madler/zlib.git /src/zlib

WORKDIR /src/zlib
RUN ./configure && make
```
Plik `Dockerfile.test`
```bash
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