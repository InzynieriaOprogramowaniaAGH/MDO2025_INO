**Sprawozdanie 1**

Bartosz Skubel 416365
ITE Gr. 7

**Zajęcia 01 - Wprowadzenie, Git, Gałęzie, SSH**

1. Instalacja klienta Git
Instalacja została przeprowadzona z pomocą menadżera pakietów dnf:

```sudo dnf install git```

Instalacja OpenSSH nie była konieczna.

2. Sklonowanie repozytorium przedmiotowego za pomocą HTTP

Repozytorium sklonowano za pomocą:

```git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO```

![HTTPS clone](<Lab 1/1.png>)

3. Konfiguracja klucza SSH, klonowanie repozytorium przez SSH

Wygenerowane zostały 2 klucze SSH za pomocą:

![Generowanie jednego z kluczy](<Lab 1/3.png>)

Klucze prywatne zostały odczytane przy pomocy:

```cat ~/.ssh/id_ed25519.pub```

Następnie zostały dodane do konta na Github:

![Klucze dodane do Githuba](<Lab 1/2.png>)

Do sklonowania repozytorium przy użyciu klucza SSH użyto polecenia:

```git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git```

Do tego punktu trzeba było skonfigurować dwu stopniową weryfikację na Githubie.

4. Przełączenie gałęzi na main i gałąź grupy.
 
![Przełączenie gałęzi](<Lab 1/4.1.png>)

5. Utworzenie gałęzi o nazwie `BS416365`.

![Przełączenie gałęzi](<Lab 1/4.2.png>)

6. Rozpoczęto pracę na nowej gałęzi.

W odpowiednim katalogu utworzono katalog o nazwie `BS416365`.

![Tworzenie katalogu](<Lab 1/5.png>)

Napisano hook `commit-msg`, który dodano do `.git/hooks`:

```#!/bin/bash
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

if [[ ! $COMMIT_MSG =~ ^BS416365 ]]; then
    echo "Błąd: Commit message musi zaczynać się od 'BS416365'"
    exit 1
fi
```
Hookowi nadano wymagane uprawnienia:

```chmod +x .git/hooks/commit-msg```

Testowanie hooka:

![Test hooka](<Lab 1/7.png>)

Hook działa poprawnie i wszystkie commity muszą zaczynać się od `BS416365`.

Dodano zdjęcia i sprawozdanie do katalogu `BS416365`.

Wysłano zmiany do repozytorium zdalnego.

![Push](<Lab 1/8.png>)

**Zajęcia 02 - Git, Docker**

1. Zainstalowano Docker przy pomocy dnf:

```sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin```

![Docker install](<Lab 2/1.png>)

2. Zarejestrowano się w serwisie Docker Hub.
   
![Docker Hub](<Lab 2/1.5.png>)

3. Pobranie obrazów.
   
Pobrano obrazy `hello-world`, `busybox`, `fedora`, `mysql` przy pomocy:

``` 
docker pull hello-world
docker pull busybox
docker pull fedora
docker pull mysql 
```

Pobrane obrazy:

![Obrazy](<Lab 2/2.png>)

4. Uruchamianie kontenera z obrazu `busybox`.

Uruchomiono kontener w wersji interaktywnej i sprawdzono wersję przy pomocy `busybox --help`

![Busybox](<Lab 2/3.png>)

5. Uruchomienie systemu Fedora w kontenerze:

Uruchomiono kontener i zainstalowano `procps-ng`, aby użyć `top`:

![Fedora i procps-ng](<Lab 2/4.png>)

![top](<Lab 2/5.png>)

Pakiety zaktualizowano przy pomocy `dnf update -y` a nastenie użyto `exit` w celu wyjścia z kontenera.

![dnf update](<Lab 2/6.png>)

6. Utworzono `Dockerfile`, który będzie miał git-a oraz sklonowane repo.

```
FROM fedora:latest

RUN dnf install -y git && dnf clean all

WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

WORKDIR /app/MDO2025_INO

CMD ["/bin/bash"]
```

Uruchomienie kontenera:

![Fedora-dockerfile](<Lab 2/8.png>)

Sprawdzenie zawartości kontenera:

![Zawartość kontenera](<Lab 2/9.png>)

7. Pokazanie uruchomionych kontenerów i czyszczenie ich wraz z obrazami.

![Kontenery i czystka](<Lab 2/10.png>)

8. Commit i wypchnięcie zmian.

![Commit i push](<Lab 2/11.png>)

**Zajęcia 03 - Dockerfiles, kontener jako definicja etapu**

1. Wybór oprogramowania.

Do wykonania programu zajęć użyto `irssi` oraz `node-js-dummy-test`.

2. Zadania na `irssi`.

- Build programu w fedorze:

Klonowanie Irssi:
![Irssi clone](<Lab 3/1.png>)

Historia poleceń, w tym instalacja wymagań:

![Historia](<Lab 3/3.png>)


Budowanie przy pomocy `meson Build`:

![meson Build](<Lab 3/2.png>)

- Budowanie w kontenerze podstawowym

Uruchomiono interaktywnie kontener, w którym przy pomocy poniższych komend zainstalowano i zbudowano Irssi jak powyżej:

![Irssi kontener](<Lab 3/4.png>)

- Budowanie przy pomocy Dockerfile:

Stworzono `Dockerfile.irssibld`, który tworzy build, ale nie testuje

```
FROM fedora:41

RUN dnf -y update && \
    dnf -y install meson gcc glib2-devel openssl-devel ncurses-devel utf8proc-devel perl-ExtUtil* cmake libgcrypt-config libgcrypt
RUN dnf -y install git
RUN git clone https://github.com/irssi/irssi
WORKDIR /irssi
RUN meson Build
RUN ninja -C Build
```

Następnie stworzono `Dockerfile.test`, który na potrzeby przechowywania 2 plików o tej samej nazwie w folderze `Lab 2` został zmieniony na `Dockerfile.irssitest`.

```
FROM bld001

WORKDIR /irssi
RUN ninja -C Build test
```

3. Zadania na `node-js-dummy-test`.

- Build i test programu w fedorze:

Sklonowano repozytorium a następnie zrobiono build i test zgodnie z komendami:

![Node history](<Lab 3/6.png>)

Przeprowadzono test:

![Node test](<Lab 3/7.1.png>)

- Budowa w kontenerze:

Uruchomiono kontener:

![Kontener node](<Lab 3/10.png>)

Przeprowadzono odpowiednie instalacje, klonowanie i testy zgodnie z komendami:

![Node kontener historia](<Lab 3/12.png>)

Przeprowadzono test w kontenerze:

![Node kontener test](<Lab 3/11.png>)

- Budowanie przy pomocy Dockerfile:

Stworzono `Dockerfile.nodebld`, który buduje kontener, ale nie robi testów:

```
FROM node:22

RUN apt update && apt install -y curl git
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \apt install -y nodejs

WORKDIR /app

RUN git clone https://github.com/devenes/node-js-dummy-test.git .

RUN npm install
```

Następnie stworzono `Dockerfile.test`, który opiera się na poprzednim Dockerfile, ale przeprowadza testy:

```
FROM bld003

WORKDIR /app

CMD npm test
```

Budowanie obrazów node i włączenie kontenera:

![Node Docker build](<Lab 3/15.png>)

4. Sprawdzenie wszystkich obrazów irssi (bld001, bld002) oraz node-js-dummy-test (bld003, bld004):

![Obrazy](<Lab 3/16.png>)

Sprawdzenie poprawności kontenera z irssi:
![Komendy do testu kontenera irssi](<Lab 3/18.png>)

![Kontener irssi](<Lab 3/17.png>)

Kontener z `node-js-dummy-test` w identyczny sposób poprawnie przechodzi test.

**4. Zajęcia 04 - Dodatkowa terminologia w konteneryzacji, instancja Jenkins**

1. Tworzenie woluminów bez git

![Woluminy](<Lab 4/1.png>)

Po stworzeniu woluminów uruchomiono kontener bazowy `fedora`:

![Kontener z woluminami](<Lab 4/2.png>)
![Woluminy w kontenerze](<Lab 4/3.png>)

Repozytorium sklonowano przy pomocy woluminu `vin`, co pozwala uniknąć instalowania `git`. 
![Klonowanie na vin](<Lab 4/4.png>)
![Potwierdzenie klonowania](<Lab 4/5.png>)

Instalowanie niezbędnych wymagań:

![Instowanie](<Lab 4/6.png>)

Uruchomionu build w kontenerze jak było to robione poprzednio:

```
meson Build
ninja -C Build
```

Po zbudowaniu przeniesiono `Build` na wolumin vout.

![Kopiowanie](<Lab 4/7.png>)

Potwierdzenie obecności zbudowanych plików na woluminie wyjściowym:

![Wolumin vout](<Lab 4/8.png>)

2. Tworzenie woluminów z git

Utworzono nowe woluminy i uruchomiono kontener z `ubuntu`:

![Nowe woluminy i kontener](<Lab 4/9.png>)

Instalowanie wymagań i klonowanie przy użyciu git:

![Instowanie](<Lab 4/11.png>)

Potwierdzenie pobrania:

![Potwierdzenie](<Lab 4/12.png>)

Po buildzie skopiowano gotowe pliki na `vout2`:

![Kopia na vout2](<Lab 4/13.png>)

Potwierdzenie pobrania:

![Potwierdzenie](<Lab 4/14.png>)

3. Wykorzystanie `docker build` i pliku `Dockerfile.mountbuild`:

Stworzono Dockerfile dla `irssi`:

```
FROM fedora:41

RUN dnf -y update && \
    dnf -y install meson ninja-build gcc glib2-devel openssl-devel ncurses-devel utf8proc-devel perl-ExtUtils-* cmake libgcrypt-devel git
WORKDIR /irssi
RUN git clone https://github.com/irssi/irssi.git .
RUN --mount=type=cache,target=/var/cache/dnf \
    meson setup Build && \
    ninja -C Build
RUN --mount=type=bind,target=/mnt/vout,rw \
    cp -r Build /mnt/vout/
```

Dockerfile przy wywołaniu `RUN --mount` tworzy kontener z tymczasowymi woluminami, które są usuwane po jego zakończeniu.

Stworzono kontener przy pomocy `Dockerfile.mountbuild`:

![Kontener mountbuild](<Lab 4/16.png>)

4. Eksponowanie portu - iperf3


- Iperf3 w kontenerze:

Uruchomiono serwer iperf3 wewnątrz kontenera:

![Serwer iperf3](<Lab 4/17.png>)

Serwer nasłuchuje połączenia, a do połączenia się z nim używamy:

![Łączenie z iperf3](<Lab 4/18.png>)


![Potwierdzenie połączenia](<Lab 4/19.png>)

Połączenie nastąpiło poprawnie i zostało odebrane w serwerze.

- Iperf3 przy użyciu `network`:

Utworzono własną sieć mostkową `bridged-network`:

![Sieć](<Lab 4/20.png>)

Następnie utworzono kontenery z serwerem i drugi, interaktywny, który się z nim łączy:

![Sieć - iperf3](<Lab 4/21.png>)

- Iperf3 spoza kontenera:

Najpierw łączymy się z hosta, czyli fedory:

![Iperf3 - host](<Lab 4/22.png>)

Połączenie odebrano poprawnie:

![Iperf3 - host - serwer](<Lab 4/23.png>)

Następnie połączono się spoza hosta, czyli z Windowsa:

![Iperf3 - !host](<Lab 4/24.png>)

Połączenie odebrano poprawnie:

![Iperf3 - !host - serwer](<Lab 4/25.png>)

Przy pomocy `docker logs iperf-server` możemy zobaczyć logi, które nie wykazują problemów.

![Iperf3 - logi](<Lab 4/26.png>)

5. Instalacja Jenkins

Po zapoznaniu się z dokumentacją utworzono sieć `Jenkins`:

![Sieć Jenkins](<Lab 4/27.png>)

Następnie pobrano kontener `jenkins:dind`:

![Kontener Jenkins:dind](<Lab 4/28.png>)

Utworzono kontener `jenkins:lts`:

![Kontener Jenkins:lts](<Lab 4/29.png>)

Po wpisaniu adresu hosta w przeglądarce wyświetla się ekran logowania Jenkinsa:

![Logowanie Jenkins](<Lab 4/30.png>)

**Wykorzystanie AI**

Podczas zajęć wykorzystywano ChatGPT w wersji 4o głównie w celu sprawdzenia poprawnej pisowni komend i streszczania dłuższych wiadomości błędów, kiedy na takie natrafiono. Model językowy ułatwił pracę, ponieważ takie błędy jak "- d" zamiast "-d" umykały moim oczom, co natomiast było szybko wychwytywane przez dzieło OpenAI.

**Problemy z zajęciami**

W trakcie pracy nad zajęciami nr 04 maszyna wirtualna zamiast poprawnie wznowić pracę otrzymała nieodwracalny błąd, który zmusił mnie do odwzorowania poprzedniej zawartości za pomocą wcześniej zrobionych zrzutów ekranu, jednak niemożliwe było odzyskanie całej historii i plik z nią zawiera jedynie informacje potrzebne do odwzorowania obecnego stanu i pełną historię drugiej połowy zajęć 4.