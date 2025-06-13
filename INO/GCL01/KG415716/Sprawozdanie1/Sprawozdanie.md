# Sprawozdanie 1

## Lab 1 - Wprowadzenie, Git, Gałęzie, SSH


Najpierw na maszynie zainstalowałam Git i sprawdziłam jego wersję.

`sudo dnf install git`

![alt text](./img/image-5.png)

Następnie przeszłam do konfiguracji SSH, wygenerowałam klucz SSH za pomocą komendy, aby połączyć się z GitHub'em.

`ssh-keygen -t ed25519 -C "klaudiagarus9@gmail.com"`

![alt text](./img/image-6.png)

Wyświetliłam zawartość wygenerowanego klucza, skopiowałam ją i dodałam w ustawieniach konta

![alt text](<./img/Zrzut ekranu 2025-03-31 171325.png>)
![alt text](<./img/Zrzut ekranu 2025-03-31 171910.png>)

Sprawdziłam, czy połączenie działa:

`ssh -T git@github.com`

![alt text](<./img/Zrzut ekranu 2025-03-31 171422.png>)



Kiedy już miałam wszystko skonfigurowane, sklonowałam repozytorium za pomocą komendy:

`git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO  `

![alt text](./img/image.png)

Sprawdziłam dostępne gałęzie i przełączyłam się na odpowiednie:
`git branch`
`git checkout main  `
`git branch`
`git fetch `
`git checkout GCL01`

![alt text](./img/image-1.png)

Na koniec utworzyłam swoją własną gałąź:

`git checkout -b KG415716   `

![alt text](./img/image-2.png)

Po wprowadzeniu zmian w lokalnym repozytorium, wysłaliśmy je do zdalnego repozytorium za pomocą polecenia:

## Lab 2 - Git, Docker

Zainstalowałam Dockera

`sudo dnf install -y docker`

![alt text](./img/image-3.png)

Zarejestrowałam i zalogowałam się w Dockerhub:

`docker login -u klaudia573`

![alt text](./img/image-4.png)

Pobrałam obrazy: *mysql, fedora, hello-world, busybox*

`docker pull <nazwa_obrazu>`

![alt text](./img/image-7.png)


Uruchomiłam kontener *busybox* w trybie interaktywnym.

`docker run -it busybox `

![](./img/image-8.png)
Sprawdziłam PID wewnątrz kontenera oraz zaktualizowałam pakiety w kontenerze fedory:

`ps -aux`

![alt text](./img/image-9.png)

`dnf update`

![alt text](./img/image-10.png)
![alt text](./img/image-11.png)


Utworzyłam plik Dockerfile, który budował obraz systemu Fedora z Gitem i konował repozytorium:

![alt text](./img/image-12.png)

Stworzyłam i zbudowałam swój własny obraz.

`docker build -t moj_obraz `

![alt text](./img/image-13.png)

Następnie go uruchomiłam.

`docker run -it moj_obraz`

![alt text](./img/image-14.png)

Sprawdziałam wszystkie działające kontenery

`docker ps -a`

![alt text](./img/image-15.png)

Zatrzymałam i usunęłam kontenery, a następnie ponownie wyświetliłam liste kontenerów

`docker stop %(docker ps -q)`
`docker rm $(docker ps -a -q)`
`docker ps -a`

![alt text](./img/image-16.png)

## Lab 3 - Dockerfiles, kontener jako definicja etapu

Najpierw zainstalowałam wszystkie potrzebne pakiety
`sudo dnf -y cmake gcc gcc-c++ make git`

![alt text](./img/image-17.png)

Do zadania wykorzystałam program node-js-dummy-test: https://github.com/devenes/node-js-dummy-test

Skolonowałam repozytorium:

`git clone https://github.com/devenes/node-js-dummy-test.git`

![alt text](./img/image-18.png)

Utworzyłam i uruchomiłam kontener:
`docker run -it ubuntu:latest /bin/bash`

![alt text](./img/image-19.png)

Przeprowadziłam testy jednostkowe
`npm run test`

![alt text](./img/image-20.png)

Zbudowałam obraz kontenera przy użyciu pliku Dockerfile.build:
`docker build -t build-image -f `Dockerfile.build .

![alt text](./img/image-21.png)

Plik Dockerfile.build:

![alt text](./img/image-22.png)

Tak samo jak poprzednio uruchomiłam testy aplikacji:

`docker build -t build-image -f Dockerfile.test .`
![alt text](./img/image-23.png)


Plik Dockerfile.test:

![alt text](./img/image-24.png)

`docker run --rm test-image `

![alt text](./img/image-25.png)

## Lab 4  - Dodatkowa terminologia w konteneryzacji, instancja Jenkins
Utworzyłam dwa woluminy: wejściowy i wyjściowy. 

`docker volume create Vin`
`docker volume create Vout`

![woluminy](./img/Zrzut%20ekranu%202025-04-06%20202111.png)

Następnie stworzyłam obraz Docker, na bazie pliku Dockerfile.vol:

`sudo docker build -f Dockerfile.vol -t cloner .`

![obraz](./img/Zrzut%20ekranu%202025-04-06%20202510.png)

Plik Dockerfile.vol:

![dockerfile.vol](./img/Zrzut%20ekranu%202025-04-06%20204327.png)

Następnie uruchomiłam kontener i dodałam wcześniej utworzony wolumin

![uruchomienie](./img/Zrzut%20ekranu%202025-04-06%20203131.png)



Zbudowalam obraz o nazwie install:

`sudo docker build -f Dockerfile.install -t install`

![a](./img/Zrzut%20ekranu%202025-04-06%20203823.png)

Plik Dockerfile.install:

![dockerfile.install](./img/Zrzut%20ekranu%202025-04-06%20204537.png)


Uruchomiłam kontener, działający jako serwer iperf3

`sudo docker run -d --rm --name iperf-server networksattic/iperf3 -s`

![uruchomienie iperf3](./img/Zrzut%20ekranu%202025-04-06%20204537.png)

Otrzymałam adres IP kontenera: **172.17.0.2**

![IP](./img/Zrzut%20ekranu%202025-04-06%20204612.png)

Uruchamiłam klienta iperf3 i przeprowadziłam test połączenia:

`docker urn --rm networkstatic/iper3 -c 172.17.0.2`

![wyniki](./img/Zrzut%20ekranu%202025-04-06%20204648.png)


![](./img/Zrzut%20ekranu%202025-04-06%20204810.png)


Zapisałam wyniki testu połączenia do logow:

`sudo docker logs iperf-server-test > iperf3_logs.log`

Plik iperf3_logs.log:

![alt text](img/image-29.png)

Aby połączyć się do serwera iperf3 spoza kontenera, musiałam otworzyć port i go uruchomić na tym otwartym porcie.:

![alt text](./img/image-28.png)

Utworzyłam osobną sieć Docker dla Jenkinsa

`sudo docker network create jenkins`

Uruchomiłam kontener DIND, a potem kontener Jenkinsa:

![alt text](./img/image-26.png)
![alt text](./img/image-27.png)

Pobrałam hasło i zalogowałam się do strony.

![alt text](<./img/Zrzut ekranu 2025-03-31 172658.png>)