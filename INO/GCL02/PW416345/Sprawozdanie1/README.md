# Sprawozdanie 

**Patrycja Wojdyło**

# LAB1 
## Przygotowanie maszyny wirtualnej

#### 1. Rozpoczęłam pracę od instalacji systemu Fedora Server na maszynie wirtualnej. Po instalacji, zalogowałam się na serwerze, aby sprawdzić działanie SSH.


`ssh pwojdylo@172.20.10.14`

![Zrzut ekranu](<ss/Zrzut ekranu 2025-03-03 192629.png>)

Skonfigurowałam klucz SSH jako metodę dostępu do GitHuba.

![alt text](<Zrzut ekranu 2025-04-08 222630.png>)

Następnie utworzyłam dwa klucze SSH, różne od RSA.

![alt text](<ss/Zrzut ekranu 2025-03-08 232031.png>)


Zainstalowałam github na maszynie i poleceniem  `git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git` sklonowałam repozytorium. 

Po sklonowaniu repozytorium, przełączyłam się najpierw na gałąź `main`, a następnie na gałąź grupową, używając poleceń:
`git checkout main`
`git checkout GCL02`

![alt text](<ss/Zrzut ekranu 2025-03-10 192614.png>)

Utworzyłam nową gałąź o nazwie zawierającej moje inicjały i numer indeksu oraz przełączyłam się na nią: `git checkout -b PW -416345`.
![alt text](<Zrzut ekranu 2025-04-08 222316.png>)

# LAB2

Na początku przeprowadziłam instalację Dockera na systemie Fedora poleceniem `sudo dnf install -y docker`.

Następnie, aby pobrać potrzebne obrazy, wykorzystałam polecenie `docker pull [nazwa obrazu]`, a po pobraniu obrazów uruchomiłam kontener Fedora przy pomocy polecenia:

![alt text](<ss/Zrzut ekranu 2025-03-10 194345.png>)

Uruchomiłam kontener z obrazu busybox komendą `docker run busybox echo "Działa"`, aby wypisać napis wewnątrz kontenera.

![alt text](<ss/Zrzut ekranu 2025-03-15 205636.png>)

Zaktualizowałam pakiety poprzez polecenie `dnf update -y`.

Stworzyłam plik Dockerfile, a następnie zbudowałam na jego podstawie własny obraz za pomocą polecenia `docker build -t my-fedora-image .`. Po zakończeniu procesu budowania uruchomiłam komendą `docker run -it my-fedora-image bash`.

```
FROM ubuntu:latest
RUN apt-get update && apt-get install -y git
WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
CMD ["bash"]
```
Wykonałam polecenie `ps aux`, które wyświetliło listę wszystkich procesów uruchomionych w systemie. I wyczyściłam je używając komend `docker stop $(docker ps -aq)` `docker rm $(docker ps -aq)`.

![alt text](<ss/Zrzut ekranu 2025-03-15 210013.png>).

# LAB3

Do zadania wybrałam program https://github.com/devenes/node-js-dummy-test.  

Repozytorium sklonowałam za pomocą polecenia:

`git clone https://github.com/devenes/node-js-dummy-test.git`

![alt text](<ss/Zrzut ekranu 2025-03-22 202912.png>)

Zainstalowałam potrzebne zależnośći `npm install`, zbudowałam projekt `npm run build`.
Uruchomiłam testy jednostkowe
![alt text](<ss/Zrzut ekranu 2025-03-22 204917.png>)

Kolejną częścią zadania było uruchomienie kontenera Node.js w trybie interaktywnym:
![alt text](<ss/Zrzut ekranu 2025-03-22 205307.png>)

Wewnątrz kontenera powtórzyłam wszystkie powyższe kroki: sklonowanie repozytorium, instalację zależności i uruchomienie testów.

Następnie stworzyłam dwa pliki:

Dockerfile.build - odpowiada za zbudowanie aplikacji i instalację zależności.
```
FROM node:latest

WORKDIR /app

COPY . .

RUN npm install
```
Dockerfile.test - bazuje na obrazie utworzonym w Dockerfile.build i uruchamia testy
```
FROM build-image

WORKDIR /app

CMD ["npm", "test"]
```

Uruchomiłam kontener na podstawie obrazu `test-image` przy użyciu komendy `docker run --rm test-image`, co pozwoliło mi uruchomić testy i usunąć kontener po ich zakończeniu.

![alt text](<ss/Zrzut ekranu 2025-03-22 211051.png>)


# LAB4

Na początku stworzyłam dwa woluminy

![alt text](<ss/Zrzut ekranu 2025-04-06 202132.png>)

Następnie stworzyłam dwa obrazy Docker i uruchomiłam kontenery z odpowiednimi woluminami, aby przechowywać dane między nimi.

Zbudowałam plik Dockerfile.vol
![alt text](<ss/Zrzut ekranu 2025-04-06 202429.png>)

Zbudowałam pierwszy obraz cloner:
![alt text](<ss/Zrzut ekranu 2025-04-06 202506.png>)

Uruchomiłam kontener z obrazu cloner, montując wcześniej stworzony wolumin:![alt text](<ss/Zrzut ekranu 2025-04-06 202915.png>)

Dockerfile.install
![alt text](<ss/Zrzut ekranu 2025-04-06 203332.png>)

Zbudowałam drugi obraz install:
![alt text](<ss/Zrzut ekranu 2025-04-06 203320.png>)

Uruchomiłam kontener install, montując dwa woluminy:
![alt text](<ss/Zrzut ekranu 2025-04-06 203610.png>)

## Eksponowanie portu — testy iperf3

Uruchomiłam kontener z serwerem `iperf3`.
Sprawdziłam adres IP kontenera i uruchomiłam kolejny raz - podając ten adres. 

![alt text](<ss/Zrzut ekranu 2025-04-06 204633.png>)

Aby uniknąć konieczności korzystania z adresów IP, stworzyłam własną sieć mostkową poleceniem `sudo docker network create iperf-net-test`

W nowo utworzonej sieci uruchomiłam kontener z serwerem `iperf3`, przypisując mu nazwę. Następnie uruchomiłam klienta, który połączył się z serwerem przy użyciu nazwy kontenera, nie adresu IP.
![alt text](<ss/Zrzut ekranu 2025-04-06 204824.png>)

Fragment pliku iperf3_logs.log (wyniki testów):
![alt text](<ss/Zrzut ekranu 2025-04-06 204906.png>)

Na koniec połączyłąm się do serwera spoza hosta:
![alt text](<ss/Zrzut ekranu 2025-04-06 205254.png>)

## Instalacja Jenkins
Utworzyłam sieć Docker:

![alt text](<ss/Zrzut ekranu 2025-04-06 205616.png>)

Na koniec zalogowałam się do storny i zainstalowałam potrzebne wtyczki:

![alt text](<Zrzut ekranu 2025-04-06 210455.png>)

