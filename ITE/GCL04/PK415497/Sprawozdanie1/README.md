## Laboratorium 1

Wygenerowanie kluczy SSH, skonfigurowanie kluczy jako metodę dostępu do GitHuba

Pokazanie kluczy publicznych

![](screenshoty/1.jpg)
![](screenshoty/2.jpg)

Sklonowanie repozytorium za pomocą SSH

![](screenshoty/3.jpg)

Utworzenie i przełączenie się na odpowiedniego brancha

![](screenshoty/4.jpg)


Napisanie GitHooka i umieszczenie go w odpowiednim miejscu

![](screenshoty/5.jpg)



## Laboratorium 2

Zainstalowanie Dockera

![](screenshoty/6.jpg)


"Zaciągnięcie" odpowiednich obrazów

![](screenshoty/7.jpg)

Przykładowy efekt uruchomienia kontenera busybox z poleceniem echo

![](screenshoty/8.jpg)

Interaktywne podłączenie się do kontenera i sprawdzenie wersji busyboxa

![](screenshoty/9.jpg)


Uruchomienia kontenera z poleceniem tail, aby sobie cały czas działał, wyświetlenie procesów Dockera,
podłączenie się do kontenera w sposób interaktywny za pomocą basha, zaprezentowanie pid1 w kontenerze czym będzie
program inicjujący kontener z systemem czyli tail, aktualizaja pakietów systemu w kontenerze

![](screenshoty/10.jpg)

Stworzenie Dockerfile.repo zbudowanie i uruchomienie, weryfikacja klonowania
```
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
WORKDIR /MDO2025_INO
CMD ["bash"]
```

![](screenshoty/11.jpg)


Wyświetlono obrazy, uruchomione są te, które mają status UP

![](screenshoty/12.jpg)


Wyczyszczenie obrazów

![](screenshoty/13.jpg)

## Laboratorium 3

Sklonowanie wybranego repozytorium, wykonanie buildu i testów

![](screenshoty/14.jpg)

Stworzenie Dockerfile.nodebld służacego do klonowania aplikacji i instalowania pakietów potrzebnych do działania

```
FROM node

RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test
RUN npm i
```

Zbudowanie obrazu za pomocą stworzonego Dockefile'a

![](screenshoty/15.jpg)


Uruchomienie kontenera i sprawdzenie czy repozytorium sie sklonowało i czy zawiera folder node_modules

![](screenshoty/16.jpg)

Stworzono Dockerfile.nodetest, który bazuje na kontenerze budującym i wykonuje testy

```
FROM nodebld
CMD ["npm", "test"]
```

Zbudowanie obrazu z testami

![](screenshoty/17.jpg)


Drugi przykład dla aplikacji Irssi

Zrobienie builda i uruchomienie testów


![](screenshoty/18.jpg)

![](screenshoty/19.jpg)

![](screenshoty/23.jpg)

Stworzenie Dockerfile'ów i zbudowanie obrazów do budowania i testowania aplikacji


![](screenshoty/20.jpg)

![](screenshoty/21.jpg)

![](screenshoty/22.jpg)


## Laboratorium 4

Stowrzenie woluminów wejściowego i wyjściowego, uruchomienie z podpiętymi woluminami kontenera bez git'a

![](screenshoty/24.jpg)


Uruchomienie kontenera pomocniczego z git'em i podpiętym woluminem wejściowym, sklonowanie repozytorium, użycie komendy docker cp
do bezpiecznego przeniesienia plików do folderu, do którego jest powiązany wolumin wejściowy

![](screenshoty/25.jpg)


Ponowne uruchomienie kontenera bez git'a z woluminami (na woluminie wejściowym jest sklonowane repozytorium),
zbudowanie aplikacji

![](screenshoty/26.jpg)


Skopiowanie node_modules do wolumina wyjsciowego

![](screenshoty/27.jpg)


Uruchomienie innego kontenera z podpietym woluminem wyjściowym i weryfikacja zawartości

![](screenshoty/28.jpg)

Uruchomienie kontenera serwera iperf3, połączenie się z serwerem iperf3 z drugiego kontenera, zbadanie ruchu

![](screenshoty/29.jpg)

Powienie kroku z własną dedykowaną siecią mostkową "moja_siec"

![](screenshoty/30.jpg)


Połaczenie się z hosta i zbadanie ruchu

![](screenshoty/31.jpg)

Instalacja Jenkinsa - stworzenie sieci i uruchomienie konteneru Docker in Docker

![](screenshoty/33.jpg)

Uruchomienie obrazu Jenkinsa

![](screenshoty/34.jpg)

Odnalezienie hasła potrzebnego do zrobienia konta, hasło znajduje się w logach kontenera

![](screenshoty/35.jpg)

![](screenshoty/32.jpg)