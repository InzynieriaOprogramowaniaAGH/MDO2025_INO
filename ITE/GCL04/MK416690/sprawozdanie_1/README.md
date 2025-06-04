# Sprawozdanie 1

## Lab 1

Instalacja Gita

![Instalacja Gita](lab1/1.jpg)

Sklonowanie repozytorium przez HTTPS

![Sklonowanie repozytorium przez HTTPS](lab1/2.jpg)

Wygenerowanie klucza SSH

![Wygenerowanie klucza SSH](lab1/3.jpg)

Sklonowanie repozytorium przez SSH

![Sklonowanie repozytorium przez SSH](lab1/4.jpg)

Utworzenie katalogu w odpowiednim branchu

![Utworzenie katalogu w odpowiednim branchu](lab1/5.jpg)

Dodanie skryptu walidującego poprawność nazw commitów do odpowiedniego katalogu z hookami

![Dodanie skryptu walidującego poprawność nazw commitów do odpowiedniego katalogu z hookami](lab1/6.jpg)

Jak widać, skrypt działa. Niepoprawna nazwa commita nie jest akceptowana

![Jak widać, skrypt działa. Niepoprawna nazwa commita nie jest akceptowana](lab1/7.jpg)

Poprawny commit

![Poprawny commit](lab1/8.jpg)

Treść hooka

```bash
#!/bin/bash

INITIALS="MK"
INDEX="416690"

COMMIT_MSG=$(cat "$1")

if ! echo "$COMMIT_MSG" | grep "^$INITIALS & $INDEX"; then
	echo "Blad: Nazwa commitu musi zaczynac sie od $INITIALS & $INDEX"
	exit 1
fi
```
## Lab 2

Poprawnie zainstalowany Docker

![Poprawnie zainstalowany Docker](lab2/2.jpg)

Pobrane obrazy z Docker Hub

![Pobrane obrazy z Docker Hub](lab2/3.jpg)

Uruchomienie kontenera z obrazu busyboxa

![Uruchomienie kontenera z obrazu busyboxa](lab2/4.jpg)

Podłączenie się do kontenera i wyświetlenie wersji

![Podłączenie się do kontenera i wyświetlenie wersji](lab2/5.jpg)

Uruchomienie Fedory w kontenerze i pokazanie PID1

![Uruchomienie Fedory w kontenerze i pokazanie PID1](lab2/6.jpg)

Aktualizacja pakietów

![Aktualizacja pakietów](lab2/7.jpg)

Procesy Dockera

![Procesy Dockera](lab2/8.jpg)

Przygotowanie Dockerfile, który będzie tworzył nam kontener z Fedorą, instalował Gita i klonował nasze repozytorium

![Przygotowanie Dockerfile, który będzie tworzył nam kontener z Fedorą, instalował Gita i klonował nasze repozytorium](lab2/9.jpg)

Zbudowanie obrazu na podstawie Dockerfile

![Zbudowanie obrazu na podstawie Dockerfile](lab2/10.jpg)

Uruchomienie kontenera z naszego obrazu, jak widać wszystko działa elegancko

![Uruchomienie kontenera z naszego obrazu, jak widać wszystko działa elegancko](lab2/11.jpg)

Wszystkie kontenery, jak widać uruchomiony i działający jest tylko jeden

![Wszystkie kontenery, jak widać uruchomiony i działający jest tylko jeden](lab2/12.jpg)

Usuwanie wszystkich kontenerów oraz obrazów

![Usuwanie wszystkich kontenerów oraz obrazów](lab2/13.jpg)

## Lab 3

Sklonowanie repozytorium z aplikacją w Node.js (lokalnie, nie w kontenerze)

![Sklonowanie repozytorium z aplikacją w Node.js](lab3/1.jpg)

Zainstalowanie wymaganych zależności

![Zainstalowanie wymaganych zależności](lab3/2.jpg)

Wykonanie testów jednostkowych

![Wykonanie testów jednostkowych](lab3/3.jpg)

Gotowy obraz Node.js do użycia

![Gotowy obraz Node.js do użycia](lab3/4.jpg)

Uruchomienie kontenera z obrazu Node i przejście do terminala tegoż kontenera

![Uruchomienie kontenera z obrazu Node i przejście do terminala tegoż kontenera](lab3/5.jpg)

Sklonowanie repozytorium wewnątrz kontenera, zainstalowanie wymaganych zależności

![Sklonowanie repozytorium wewnątrz kontenera, zainstalowanie wymaganych zależności](lab3/6.jpg)

Wykonanie testów jednostkowych w kontenerze

![Wykonanie testów jednostkowych w kontenerze](lab3/7.jpg)

Dockerfile do zbudowania obrazu naszej aplikacji

![Dockerfile do zbudowania obrazu naszej aplikacji](lab3/8.jpg)

```dockerfile
FROM node:latest

RUN git clone https://github.com/devenes/node-js-dummy-test

WORKDIR /node-js-dummy-test

RUN npm i

CMD ["npm", "run", "start"]
```

Dockerfile do zbudowania drugiego obrazu do odpalenia testów jednostkowych aplikacji, który jest budowany na podstawie obrazu stworzonego w poprzednim kroku

![Dockerfile no. 2](lab3/9.jpg)

```dockerfile
FROM my_node_build

CMD ["npm", "run", "test"]
```

Budowanie pierwszego obrazu z pierwszego Dockerfile

![Budowanie pierwszego obrazu z pierwszego Dockerfile](lab3/10.jpg)

Budowanie drugiego obrazu z drugiego Dockerfile

![Budowanie drugiego obrazu z drugiego Dockerfile](lab3/11.jpg)

Uruchomienie kontenerów z obydwu utworzonych przez nas obrazów

![Uruchomienie kontenerów z obydwu utworzonych przez nas obrazów](lab3/12.jpg)

## Lab 4

Utworzenie woluminów

![Utworzenie woluminów](lab4/1.jpg)

Sklonowanie repo

![Sklonowanie repo](lab4/2.jpg)

Uruchomienie kontenera z podpiętymi woluminami, skopiowanie poleceniem `docker cp` plików do odpowiedniego katalogu. 
Jak widać, pliki zostały poprawnie skopiowane

![Kontener i kopiowanie plików](lab4/3.jpg)

Przejście do katalogu, instalacja zależności, skopiowanie do katalogu wyjściowego

![Przejście do katalogu, instalacja zależności, skopiowanie do katalogu wyjściowego](lab4/4.jpg)

Uruchomienie kontenera z podpiętym woluminem wyjściowym, jak widać, znajdują się na nim pliki z poprzedniego kontenera

![Kontener 2 z woluminem wyjsciowym](lab4/5.jpg)

Tworzymy kolejnym wolumin, podpinamy go do kontenera, w kontenerze klonujemy repo, instalujemy zależności

![Kontener 3 z klonowanym repo w kontenerze](lab4/6.jpg)

Podpinamy wolumin 3 do nowego kontenera, jak widać, pliki z poprzedniego kontenera znajdują się na woluminie

![Kontener 4 z plikami z kontenera 3](lab4/7.jpg)

Aby uprościć cały ten proces, możemy użyć Dockerfile bo budowania obrazu, który przy uruchamianiu kontenera, będzie podłączał nam woluminy

![Kontener 4 z plikami z kontenera 3](lab4/7_1.jpg)

```dockerfile
FROM node:22

RUN apt-get update && apt-get install -y git

VOLUME /mnt/input
VOLUME /mnt/output

RUN git clone https://github.com/devenes/node-js-dummy-test.git /mnt/input && \
    cd /mnt/input && npm i && cp -r /mnt/input/. /mnt/output && echo "output: $(ls /mnt/output)"

CMD ["node", "/mnt/input/src/index.js"]
```

Jako że woluminy mają trochę słabe nazwy, możemy sobie łatwo sprawdzić gdzie podłączony jest dany wolumin

![Kontener 4 z plikami z kontenera 3](lab4/7_2.jpg)

Podłączamy się do kontenera, instalujemy iperf3

![Podłączamy się do kontenera, instalujemy iperf3](lab4/8.jpg)

Uruchamiamy serwer iperf3

![Uruchamiamy serwer iperf3](lab4/9.jpg)

Na drugim kontenerze też instalujemy iperf3

![Na drugim kontenerze też instalujemy iperf3](lab4/10.jpg)

Sprawdzamy adres IP kontenera z serwerem iperf3

![Sprawdzamy adres IP kontenera z serwerem iperf3](lab4/11.jpg)

Testujemy połączenie między kontenerami, wszystko fajnie działa

![Testujemy połączenie między kontenerami, wszystko fajnie działa](lab4/12.jpg)

Tworzymy własną sieć, następnie tworzymy kontenery podpięte wyłącznie do tej sieci, testujemy połączenie między nimi, wszystko jest super

![Własna sieć i test między kontenerami w tej sieci](lab4/13.jpg)

Sprawdzamy IP serwera iperf3, łączymy się z nim z hosta, wszystko działa

![Sprawdzamy IP serwera iperf3, łączymy się z nim z hosta, wszystko działa](lab4/14.jpg)

Pobieramy obraz Jenkinsa, odpalamy kontener z tegoż obrazu z odpowiednimi flagami (zmapowane porty, uprawnienia do uruchomienia Dockera w kontenerze, itp.)

![Jenkins, obraz i kontener](lab4/15.jpg)

Sprawdzamy domyślny klucz dostępu do Jenkinsa

![Sprawdzamy domyślny klucz dostępu do Jenkinsa](lab4/16.jpg)

Logujemy się w przeglądarce uzyskanym kluczem

![Logujemy się w przeglądarce uzyskanym kluczem](lab4/17.jpg)

Instalujemy sugerowane wtyczki

![Instalujemy sugerowane wtyczki](lab4/18.jpg)

Zakładamy konto admina

![Zakładamy konto admina](lab4/19.jpg)