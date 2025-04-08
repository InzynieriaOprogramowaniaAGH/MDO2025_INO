Sprawozdanie nr 1 z Przedmiotu DevOps

Kierunek: Informatyka Techniczna

Grupa 4

Marcin Król


## Zajecia 1

1.Zainstalowałem klienta Git i obsługę kluczy SSH 

![](Screeny/1.jpg)

2.Utworzono dwa klucze SSH w tym jeden zabezpieczony hasłem hasłem. Skonfigurowano klucz SSH jako metodę dostępu do GitHuba. 

![](Screeny/2.jpg)

3.Sklonowano repozytorium z wykorzystaniem protokołu SSH 

![](Screeny/3.jpg)

4.Przełączono się na gałąź main, a następnie na gałąź grupową GCL04 po czym utworzono nową gałąź

![](Screeny/4.jpg)

5.Przejscie do katalogu z własnymi inicjałami

![](Screeny/5.jpg)

6.Przygotowałem Git hooka sprawdzającego, czy każdy mój komunikat commita zaczyna się od „inicjały & nr indeksu”.

```
#!/bin/sh

EXPECTED_PREFIX="MK416388"

if [ ! -f "$1" ]; then
    echo "Błąd: Plik $1 nie istnieje!"
    exit 1
fi

COMMIT_MSG=$(cat "$1")

if [[ "$COMMIT_MSG" != $EXPECTED_PREFIX* ]]; then
    echo "Błąd: Commit message musi zaczynać się od $EXPECTED_PREFIX!"
    exit 1
fi

exit 0
```

## Zajecia 2

1.Zainstalowanie Dockera 

![](Screeny/6.jpg)


2.Zalogowanie się do Docker Hub

![](Screeny/7.jpg)

3.Pobranie obrazów hello-world, busybox,fedora,ubuntu,mysql z wykorzystaniem docker pull

![](Screeny/8.jpg)

4.Uruchomienie konteneru z obrazu busybox

![](Screeny/9.jpg)

5.Podłączenie się do kontenera interaktywnie i wywołanie numeru wersji

![](Screeny/10.jpg)

6.Uruchomienie konteneru z obrazu ubuntu oraz pokazanie PID1 w kontenerze i procesy

![](Screeny/11.jpg)

7.Aktualizacja pakietów

![](Screeny/12.jpg)

8.Stworzony plik Dockerfile
```
FROM ubuntu:latest

RUN apt update && apt install -y git


WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["/bin/bash"]
```

9.Pokazanie uruchomionych kontenerów

![](Screeny/13.jpg)

10.Wyczyszczenie obrazów

![](Screeny/14.jpg)

## Zajecia 3

1.Sklonowanie repozytorium z aplikacją w Node.js 

![](Screeny/15.jpg)

2.Zainstalowanie zależności

![](Screeny/16.jpg)

3.Wykonanie testów

![](Screeny/17.jpg)

4.Pokazanie gotowego obrazu oraz uruchomienie kontenera

![](Screeny/18.jpg)

5.Sklonowanie repozytorium wewnątrz kontenera

![](Screeny/19.jpg)

6.Wykonanie testów wewnątrz kontenera

![](Screeny/20.jpg)

7.Stworzony Dockerfile.build
```
FROM node:latest

RUN git clone https://github.com/devenes/node-js-dummy-test

WORKDIR /node-js-dummy-test

RUN npm i

CMD ["npm", "run", "start"]
```

8.Stworzony Dockerfile.test
```
FROM my_node_build

CMD ["npm", "run", "test"]
```

9.Pokazanie build oraz test

![](Screeny/21.jpg)

## Zajecia 4

1.Utworzenie woluminów

![](Screeny/22.jpg)

2.Sklonowanie repozytorium

![](Screeny/23.jpg)

3.Uruchomienie kontenera z podpiętymi woluminami i skopiowanie plików do środka

![](Screeny/24.jpg)
![](Screeny/25.jpg)

4.Przejście do katalogu 

![](Screeny/26.jpg)

5.Instalacja zależności

![](Screeny/27.jpg)

6.Kopiowanie zawartości katalogu /mnt/input do /mnt/output

![](Screeny/28.jpg)

7.Uruchomiono kontener z podpiętym woluminem wyjściowym

![](Screeny/29.jpg)

8.Tworzenie nastepnego wolumina

![](Screeny/30.jpg)

9.Startujemy kontener z podłączonym woluminem volume_3 a następnie wchodzimy do katalogu /mnt/app

![](Screeny/31.jpg)

10.Klonowanie repozytorium

![](Screeny/32.jpg)

11.Instalacja zaleznosci

![](Screeny/33.jpg)

12.Żeby uprościć cały proces można użyć Dockerfile do zbudowania obrazu który przy starcie kontenera automatycznie podłączy woluminy

![](Screeny/34.jpg)

13.Dockerfile
```
FROM node:22

RUN apt-get install -y tzdata && dpkg-reconfigure -f noninteractive tzdata
RUN apt-get update && apt-get install -y git

VOLUME /mnt/input
VOLUME /mnt/output

RUN git clone https://github.com/devenes/node-js-dummy-test.git /mnt/input && \
    cd /mnt/input && npm install && \
    cp -r /mnt/input /mnt/output && \
    echo "output: $(ls /mnt/output)"

CMD ["node", "/mnt/input/src/index.js"]
```



14.Podłączamy się do kontenera i instalujemy iperf3

![](Screeny/35.jpg)

15.Uruchamiamy iperf3 

![](Screeny/36.jpg)

16.Powtarzamy proces na drugim

![](Screeny/37.jpg)

17.Sprawdzamy Ip

![](Screeny/38.jpg)

18.Sprawdzamy polaczenie miedzy kontenerami 

![](Screeny/39.jpg)

19.Tworzymy własną sieć  uruchamiamy w niej kontenery i sprawdzamy czy się ze sobą łącza

![](Screeny/40.jpg)

![](Screeny/41.jpg)

20.Pobieramy obraz Jenkinsa

![](Screeny/42.jpg)

21.Wlaczenie kontenera z odpowiednimi flagami 

![](Screeny/43.jpg)

22.Sprawdzenie czy Jenkins działa

![](Screeny/44.jpg)

![](Screeny/45.jpg)



