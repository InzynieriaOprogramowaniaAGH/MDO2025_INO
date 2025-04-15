# LAB1

## Połączono z serwerem poprzez SSH

![alt text](lab1/2.png)

## Sklonowano repozytorium za pomocą HTTPS
![alt text](lab1/1.png)
## Wygenerowano klucze SSH
![alt text](lab1/3.png)
![alt text](lab1/4.png)
## Dodano klucz SSH na GitHubie
![alt text](lab1/5.png)
## Sklonowano repozytorium poprzez SSH
![alt text](lab1/6.png)
## Przełączono na gałąź grupy i utworzono własną gałąź
![alt text](lab1/7.png)
## Stworzono Git Hooka
```bash
#!/bin/sh

COMMIT_MESSAGE=$(cat "$1")

if [[  ! $COMMIT_MESSAGE =~ ^KP414342 ]]; then
    echo "ERROR: Commit message does not start with KP414342"
    exit 1
fi

exit 0
```
## Przetestowano działanie Git Hooka

![alt text](lab1/8.png)
![alt text](lab1/9.png)

## Wysłano zmiany
![alt text](lab1/10.png)

# LAB2

## Zainstalowano dockera

![alt text](lab2/1.png)

## Utworzono konto na dockerhubie

![alt text](lab2/7.png)

## Pobrano obrazy

![alt text](lab2/2.png)

## Uruchomiono busyboxa

![alt text](lab2/3.png)

## Uruchomiono fedorę

![alt text](lab2/4.png)

## Zaprezentowano PID1 w kontenerze oraz zaktualizowano pakiety
![alt text](lab2/5.png)
![alt text](lab2/6.png)

## Utworzono Dockerfile
```Dockerfile
FROM fedora:latest

RUN dnf install -y git && dnf clean all

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["/bin/bash"]
```
## Zbudowano obraz z Dockerfila i uruchomiono w trybie interaktywnym
![alt text](lab2/9.png)

## Wyświetlono listę kontenerów
![alt text](lab2/10.png)
## Zatrzymano i usunięto wszystkie kontenery
![alt text](lab2/11.png)
## Usunięto wszystkie obrazy kontenerów
![alt text](lab2/12.png)

# LAB3

## Sklonowano repozytorium irssi
![alt text](lab3/image.png)

## Doinstalowano potrzebne paczki
![alt text](lab3/image-1.png)

## Stworzono builda aplikacji
![alt text](lab3/image-2.png)

## Uruchomiono testy
![alt text](lab3/image-4.png)

# Powtórzenie tych działań w kontenerze
## Zainstalowano paczki
![alt text](lab3/image-5.png)

## Sklonowano repozytorium
![alt text](lab3/image-6.png)

## Stworzono builda
![alt text](lab3/image-7.png)

##
![alt text](lab3/image-8.png)

## Uruchomiono testy
![alt text](lab3/image-9.png)

## Stworzenie Dockerfile do automatyzacji poprzednich kroków
### Kod Dockerfile do budowania aplikacji
```Dockerfile
FROM fedora:latest

RUN dnf -y update && \
    dnf -y install git ninja-build meson gcc glib2-devel openssl-devel ncurses-devel utf8proc-devel perl-ExtUtils-Embed

RUN git clone https://github.com/irssi/irssi.git

WORKDIR /irssi

RUN meson setup Build

RUN ninja -C Build
```
## Zbudowano obraz
![alt text](lab3/image-12.png)
### Dockerfile do uruchomienia testów
```Dockerfile
FROM bld001

RUN ninja -C Build test

CMD ["/bin/bash"]
```
## Zbudowano obraz
![alt text](lab3/image-13.png)

## Uruchomiono kontener
![alt text](lab3/image-14.png)

### Dockerfile dla builda aplikacji node
```Dockerfile
FROM node:22.14.0

RUN git clone https://github.com/devenes/node-js-dummy-test

WORKDIR /node-js-dummy-test

RUN npm install
```
## Zbudowano obraz
![alt text](lab3/image-15.png)
### Dockerfile dla uruchomienia testów
```Dockerfile
FROM node_build_v1
RUN npm test
```
## Zbudowano obraz
![alt text](lab3/image-16.png)

# LAB4
## Utworzono dwa woluminy
![alt text](lab4/image.png)

## Utworzono kontener którym sklonowono repozytorium do woluminu
![alt text](lab4/image-1.png)

```Dockerfile
FROM fedora
RUN dnf update -y && dnf -y install git 
WORKDIR /root/Volumes
CMD git clone https://github.com/devenes/node-js-dummy-test /root/Volumes
```

## Utworzono kontener bazowy w którym przekopiowano zawartość woluminu wejściowego do woluminu wyjściowego
![alt text](lab4/image-2.png)

```Dockerfile
FROM fedora:39
VOLUME /root/TDWA
VOLUME /root/OUT

RUN dnf update -y && dnf install -y nodejs

WORKDIR /root/TDWA/node-js-dummy-test

CMD npm install && cp -r /root/TDWA /root/OUT
```

## Uruchomienie kontenera serwera
![alt text](lab4/image-7.png)
![alt text](lab4/image-3.png)

```Dockerfile
FROM ubuntu:latest

RUN apt-get update && apt-get install -y iperf3

EXPOSE 5201

CMD ["iperf3", "-s"]
```
## Zainstalowanie iperf3 na kontenerze z lab2
![alt text](lab4/image-4.png)

## Przetestowanie działania iperf3
![alt text](lab4/image-8.png)

## Utworzenie sieci mostkowej
![alt text](lab4/image-9.png)

## Uruchomienie kontenera serwera podłączonego do nowej sieci
```Dockerfile
FROM ubuntu:latest

RUN apt-get update && apt-get install -y iperf3

CMD ["/bin/bash"]
```
## Próba połączenia przez sieć wewnętrzną
![alt text](lab4/image-5.png)
## Próba połączenia z poziomu hosta
![alt text](lab4/image-6.png)

# Instalacja Jenkins

## Utworzono sieć i uruchomiono dockera na obrazie docker:dind

![alt text](lab4/image-10.png)

![alt text](lab4/image-12.png)

## Przygotowanie Dockerfile na bazie Jenkins Docker image

```Dockerfile
FROM jenkins/jenkins:2.492.3-jdk17
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

## Zbudowanie obrazu

![alt text](lab4/image-15.png)

## Uruchomienie kontenera

![alt text](lab4/image-16.png)

## Finalny efekt po konfiguracji
### Zapomniałem o dokumentacji screenami kolejnych kroków konfiguracji
![alt text](lab4/image-18.png)