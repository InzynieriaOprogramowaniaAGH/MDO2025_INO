# Maszyna wirtualna

![](images/Pasted%20image%2020250312165218.png)

# Wprowadzenie, Git, Gałęzie, SSH

## Instalacja git
![](images/Pasted%20image%2020250312220828.png)

## Konfiguracja użytkownika
- Dodanie nazwy użytkoniwka
`$ git config --global user.name "Your Name"`
- Dodanie adresu email
`$ git config --global user.email "you@example.com"`

![](images/Pasted%20image%2020250313152452.png)
## Pozyskiwanie klucza personalnego i klonowanie repo

### 1. Weryfikacja maila

![](images/Pasted%20image%2020250312170804.png)

### 2. Dodanie klucza w Github
- Wchodzimy w Settings > Developer settings. Potem klikamy na Personal access tokens i wybieramy Tokens (classic)

![](images/Pasted%20image%2020250312171126.png)

- Klikamy Generate new token i wersje classic

![](images/Pasted%20image%2020250312171233.png)

- Zaznaczamy odpowiednie scopy i klikamy Generate token
![](images/Pasted%20image%2020250312171841.png)

![](images/Pasted%20image%2020250312172036.png)

###  3. Sklonowanie repo

`$ git clone https://<PAT>@github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git`

![](images/Pasted%20image%2020250312172919.png)

## Dodanie klucza SSH i klonowanie za pomocą SSH

### Generowanie klucza
Na maszynie, z której chcemy dostęp uruchamiamy polecenie
`$ ssh-keygen -t ed25519 -C "mail@mail.com"

![](images/Pasted%20image%2020250312175252.png)
![](images/Pasted%20image%2020250312175418.png)

### Dodanie klucza do Github
Wchodzimy w Settings > SSH and GPG keys i dodajemy nowy klucz
![](images/Pasted%20image%2020250312175741.png)

![](images/Pasted%20image%2020250312175653.png)

![](images/Pasted%20image%2020250312212034.png)

### Sklonowanie repo

`$ git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git`

![](images/Pasted%20image%2020250312212437.png)

## Konfiguracja 2FA

![](images/Pasted%20image%2020250312212840.png)

## Zmiania gałęzi

Aby zmienić gałąź używamy `$ git switch nazwa_galenzi`

Aby sprawdzić na jakiej aktualnie znajdujemy się gałęzi i które posiadamy na naszej lokalnej maszynie wpisujemy `$ git branch`

![](images/Pasted%20image%2020250312213911.png)

## Stworzenie własnego brancha

`$ git checkout -b nazwa_brancha`

![](images/Pasted%20image%2020250312214238.png)

## Tworzymy nowy katalog w katalogu grupy
![](images/Pasted%20image%2020250312214718.png)

## Naipsanie git hooka

Hook będzie się upewniał, że commit zaczyna się od odpowiednich inicjałów

```sh
#!/bin/sh

COMMIT_MSG_FILE="$1"

REQUIRED_PREFIX="BW414439"

FIRST_LINE=$(head -n 1 "$COMMIT_MSG_FILE")

if ! echo "$FIRST_LINE" | grep -q "^$REQUIRED_PREFIX"; then
    echo "Error: Commit message must start with '$REQUIRED_PREFIX'."
    exit 1
fi

exit 0
```

## Skopiowanie hooka do odpowiedniego miejsca

Kopiujemy plik do folderu `.git/hooks` w repo

`$ cp plik miejsce_docelowe/plik`

![](images/Pasted%20image%2020250312220116.png)

I dodajemy uprawnienia do uruchamiania

`$ chmod +x plik`

![](images/Pasted%20image%2020250312220120.png)

## Commit i push

### Dodanie plików
Sprawdzamy status naszego repo za pomocą
`$ git status`
Dodajemy wszystkie nowe pliki do repo
`$ git add .`

![](images/Pasted%20image%2020250313152358.png)

### Commit
Następnie commitujemy nasze zmiany do lokalnego repo
`$ git commit -am "komentarz"`

Próba commita z błędnym komentarzem
![](images/Pasted%20image%2020250313152634.png)

Commit
![](images/Pasted%20image%2020250313152752.png)

### Push na github

Gdy pushujemy za pierwszym razem branch stworzony lokalnie, musimy podać gitowi do jakiego brancha na serwerze ma go powiązać

`$ git push --set-upstream origin BW414439`

![](images/Pasted%20image%2020250313152914.png)
![](images/Pasted%20image%2020250313153118.png)


---

# Docker

## Instalacja docker

Docker został zainstalowany wraz z systemem
![](images/Pasted%20image%2020250313181936.png)

## Zakładanie konta na Dockerhub

![](images/Pasted%20image%2020250313193636.png)
![](images/Pasted%20image%2020250313193713.png)

## Pobranie kontenerów

Aby pobrać obrazy z dockerhub używamy polecenia
`$ docker pull nazwa_obrazu`

![](images/Pasted%20image%2020250313181530.png)

Teraz aby zobaczyć pobrane obranzy wpisujemy
`$ docker images`

![](images/Pasted%20image%2020250313194638.png)

## Uruchomienie kontenera

Aby uruchomić kontener używamy polecenia
`$ docker run nazwa_obrazu`

![](images/Pasted%20image%2020250313194729.png)

### Uruchomienie kontenera w trybie interaktywnym

Aby uruchomić kontener w trybie interaktywnym używamy polecenia
`$ docker run -it nazwa_obrazu`

> Dodatkono na końcu możemy podac program, który chcemy uruchomić np. bash albo sh

![](images/Pasted%20image%2020250313194854.png)

## Uruchamianie systemu w kontenerze

Uruchamiamy kontener tak jak w poleceniu wyżej (tutaj jest to fedora)

### 1. Zczytanie PID1
Aby posiadać polecenie ps musimy zainstalować odpowienie narzędzia
`$ dnf install -y procps-ng`

![](images/Pasted%20image%2020250313195856.png)

Następie możemy otrzymać informacje o urucjomionych prohramach w kontenerze
`$ ps`

![](images/Pasted%20image%2020250313195908.png)

Pokazanie procesów dockera na hoście
`$ ps auc | grep docker`

![](images/Pasted%20image%2020250313200325.png)

### 2. Zaktualizowanie pakietów

`$ dnf update`

![](images/Pasted%20image%2020250313200432.png)

### 3. Wyjście z kontenera

`$ exit`

![](images/Pasted%20image%2020250313200504.png)

## Dockerfile

Tworzymy plik Dockerfile, który będzie pobierał repo z github

```dockerfile
FROM fedora

RUN dnf install -y git && dnf clean all

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

Przechodzimy do folderu, gdzie znajduje się nasz plik Dockerfile

![](images/Pasted%20image%2020250313201208.png)

A następnie budujemy nasz obraz

`$ docker build -t nazwa_naszego_obrazu .`

![](images/Pasted%20image%2020250313201322.png)

Teraz możemy zobaczyć, że mamy dostępny nasz nowy obraz

`$ docker images`

![](images/Pasted%20image%2020250313211953.png)

Uruchamiamt nasz obraz i sprawdzamy czy repo zostało sklonowane

`$ docker run -it nazwa_naszego_obrazu`

![](images/Pasted%20image%2020250313212027.png)

## Usuwanie kontenerów

Aby usunąć wszystkie kontenery, musimy je najpierw zatrzymać

`$ docker stop $(docker ps -a -q)`

Następnie możemy usunąc  nasze konterery

`$ docker rm $(docker ps -a -q)`

![](images/Pasted%20image%2020250313212533.png)

## Usuwanie obrazów

> Aby usunąć obrazu, wsyzsktie kontenery z nimi powiązane muszą być usunięte

Wszystkie obrazy usuwamy za pomoca polecenia

`$ docker rmi -f $(docker images -aq)`

![](images/Pasted%20image%2020250313213330.png)

![](images/Pasted%20image%2020250313215248.png)

---
# Budowanie aplikacji w kontenerze
## Budowanie poza kontenerem

### 1. Klonowanie repo z programem
`$ git clone https://github.com/irssi/irssi.git`

![](images/Pasted%20image%2020250318201159.png)

### 2. Instalowanie potrzebnych zależnośći

`$ sudo apt install -y meson ninja-build libglib2.0-dev libssl-dev libperl-dev libncurses-dev`

![](images/Pasted%20image%2020250318212114.png)

### 4. Kompilacja
Wchodzimy do folderu z projektem i budujemy

`$ meson Build`

a potem

`$ ninja -C Build`

![](images/Pasted%20image%2020250318201715.png)
![](images/Pasted%20image%2020250318202054.png)

### 5. Testowanie

> Ważne, aby testować aplikacja musi być wcześniej zbudowana

`$ ninja -C Build test`

![](images/Pasted%20image%2020250318202726.png)

## Ręczne budowanie w kontenerze

### Uruchomienie kontenera

`$ docker run -it alpine sh`

![](images/Pasted%20image%2020250326165628.png)
### 1. Instalacja zaleźności

`$ apk add git meson ninja g++ make perl ncurses-dev openssl-dev glib-dev`

![](images/Pasted%20image%2020250326170425.png)

### 2. Pobranie repozytorium

`$ git clone https://github.com/irssi/irssi.git`

![](images/Pasted%20image%2020250326170724.png)

### 3. Wejście do folderu z repozytorium

`$ cd irssi`

![](images/Pasted%20image%2020250326170808.png)

### 4. Zbudowanie programu

`$ meson Build`

a następnie

`$ ninja -C Build`

![](images/Pasted%20image%2020250326170901.png)

![](images/Pasted%20image%2020250326170935.png)

### 5. Testowanie

`$ meson test -C Build`

![](images/Pasted%20image%2020250326171329.png)

## Automatyzacja budowania w kontenerze

### Budowanie

1. Tworzymy plik `Dockerfile.build`

```Dockerfile
FROM alpine:latest

RUN apk add git meson ninja g++ make perl ncurses-dev openssl-dev glib-dev

RUN git clone https://github.com/irssi/irssi.git

WORKDIR /irssi

RUN meson Build

RUN ninja -C Build
```

I budujemy za pomocą

`$ docker build -t build -f Dockerfile.build .`

![](images/Pasted%20image%2020250318204550.png)

W ten sposób posiadamy obraz z zbudowanym projektem

### Testowanie

Bazująć na obrazie z budowy tworzymy `Dockerfile.test`, który będzie uruchamiał test

```Dockerfile
FROM build-i

WORKDIR /irssi

RUN meson test -C Build
```

![](images/Pasted%20image%2020250318211549.png)

## Wdrożenie

Na podstawnie obrazu z budowy tworzymy obraz, za pomocą którego, będzie można uruchomić kontener z aplikacją

```Dockerfile
FROM build-i

WORKDIR /irssi

RUN ninja -C Build install

CMD ["irssi"]
```

Budujemy obraz

`$ docker build -t run-i -f Dockerfile.run .`

![](images/Pasted%20image%2020250318213423.png)

I teraz możemy uruchomić aplikacje w kontenerze

`$ docker run -it run-i`

![](images/Pasted%20image%2020250318213521.png)

![](images/Pasted%20image%2020250318213510.png)

# Dodatkowa terminologia w konteneryzacji, instancja Jenkins

## Używanie woluminów

### Stworzenie folderów

Do tych folderów będą podpięte nasze woluminy

`$ mkdir in`
`$ mkdir out`

![](images/Pasted%20image%2020250331200108.png)

### Uruchomienie kontenera z podpiętymi woluminami

`$ docker run --rm -it -v "./in:/build" -v "./out:/done" alpine sh`

Następnie uruchamiając `ls` w kontenerze widzimy podpięte woluminy

![](images/Pasted%20image%2020250331201330.png)

## Budowanie aplikacji

### Instalacja zależności

Postępujemy tak samo jak na poprzednich labolatoriach

![](images/Pasted%20image%2020250331201433.png)

### Sklonowanie repo

Klonujemy repozytorium z pozycji hosta, do wolderu wejściowego

`$ cd in`
`$ git clone https://github.com/irssi/irssi.git`

Teraz jak wejdziemy do podpiętego woluminu w kontenerze, to widzimy pobrane repozytorium.

![](images/Pasted%20image%2020250331202151.png)

### Budujemy

Postępujemy tak jak na poprzenich labach

![](images/Pasted%20image%2020250331202449.png)
![](images/Pasted%20image%2020250331202529.png)

### Wyciąganie plików poza kontener

Kopiujemy pliki z budowy na wolnmin wyjściowy i teraz mamy do nich dostęp poza konteneram, nawet jak zostanie wyłączony

![](images/Pasted%20image%2020250331203009.png)

### To samo tylko w kontenerze

### Dodanie gita w kontenerze

`$ apk add git`

![](images/Pasted%20image%2020250331212519.png)

Teraz postępujemy dokładnie tak samo jak w poprzenim kroku i dostajemy takie same wyniki

*Klonowanie*
![](images/Pasted%20image%2020250331212703.png)

*Budowa*
![](images/Pasted%20image%2020250331212809.png)
![](images/Pasted%20image%2020250331212839.png)

*Kopiowanie i rezultaty*
![](images/Pasted%20image%2020250331213025.png)


## Iperf

### Uruchamiamy kontener z serwerem iperf

`$ docker run --name server -p 5201:5201 networkstatic/iperf3 -s`

![](images/Pasted%20image%2020250331224917.png)

### Sprawdzamy adres kontenera z serwerem

`$ docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' iperfserver`

![](images/Pasted%20image%2020250331222643.png)

### Łączymy się z innego kontenera

`$ docker run --rm --name client networkstatic/iperf3 -c 172.17.0.2`

![](images/Pasted%20image%2020250331224852.png)

### Tworzenie własnej sieci

`$ docker network create --driver bridge lab4_net`

![](images/Pasted%20image%2020250331223200.png)

### Uruchamiamy kontenery w sieci

Usunięcie starego kontenera z serwerem

`$ docker rm server`

![](images/Pasted%20image%2020250331223527.png)

Uruchomienie serwera

`$ docker run --rm -it --name server --network lab4_net networkstatic/iperf3 -s`

![](images/Pasted%20image%2020250331223549.png)

Uruchomienie klienta i test

`$ docker run --rm --name client --network lab4_net networkstatic/iperf3 -c server`

![](images/Pasted%20image%2020250331223801.png)

### Testowanie na hoście

Instalacja

`$ apt install iperf3`

![](images/Pasted%20image%2020250331225517.png)

Test

`$ iperf3 -c 127.0.0.1`

![](images/Pasted%20image%2020250331225635.png)

![](images/Pasted%20image%2020250331225626.png)

### Test na własnym urządzeniu

Pobieramy program
https://files.budman.pw/

Uruchomienie na laptopie

`$ iperf3 -c 192.168.0.115`

![](images/Pasted%20image%2020250331230231.png)

### Uruchmienie z woliumem na logi

Tworzymy folder i podpinamy 

`$ docker run --rm -it -p 5201:5201 --name server -v "./logs:/logs" --network lab4_net networkstatic/iperf3 -s --logfile /logs/server-logs.log`

![](images/Pasted%20image%2020250331230820.png)

### Połączenie

Serwer nic nie wypisuje bo jest w logach

`$ iperf3 -c 127.0.0.1``

![](images/Pasted%20image%2020250331230939.png)

### Podejrzenie logów
![](images/Pasted%20image%2020250331231036.png)

## Jenkins

Postępujemy wedłóg dokumentacji na stronie
https://www.jenkins.io/doc/book/installing/docker/

### Stworzenie sieci

`$ docker network create jenkins`

![](images/Pasted%20image%2020250331231802.png)

### Stworzenie folderów

Tworzymy foldery potrzebne do jenkins

`$ mkdir jenkins-certs`
`$ mkdir jenkins-data`

![](images/Pasted%20image%2020250331231937.png)

### Tworzenie i urichomienie kontenera

`$ docker run --name jenkins-docker --rm --detach --privileged --network jenkins --network-alias docker --env DOCKER_TLS_CERTDIR=/certs --volume ./jenkins-docker-certs:/certs/client --volume ./jenkins-data:/var/jenkins_home --publish 2376:2376 docker:dind --storage-driver overlay2`

![](images/Pasted%20image%2020250331232206.png)

### Stworzenie włanego dockerfile

```Dockerfile
FROM jenkins/jenkins:2.492.2-jdk17

USER root

RUN apt-get update && apt-get install -y lsb-release ca-certificates curl && \

    install -m 0755 -d /etc/apt/keyrings && \

    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \

    chmod a+r /etc/apt/keyrings/docker.asc && \

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \

    https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" \

    | tee /etc/apt/sources.list.d/docker.list > /dev/null && \

    apt-get update && apt-get install -y docker-ce-cli && \

    apt-get clean && rm -rf /var/lib/apt/lists/*

USER jenkins

RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```

![](images/Pasted%20image%2020250331232518.png)

### Stworzenie obrazu kontenera

`$ sudo docker build -t jenkins:2.492.2-1 .`

![](images/Pasted%20image%2020250331232623.png)

### Uruchomienie gotowego kontenera

`$ docker run --name jenkins-blueocean --restart=on-failure --detach --network jenkins --env DOCKER_HOST=tcp://docker:2376 --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 --publish 8080:8080 --publish 50000:50000 --volume ./jenkins-data:/var/jenkins_home --volume ./jenkins-docker-certs:/certs/client:ro jenkins:2.492.2-1`

![](images/Pasted%20image%2020250331233012.png)

#### Sprawdzenie czy kontener jest uruchomiony

`$ sudo docker ps -a`

![](images/Pasted%20image%2020250331233031.png)


Sprawdzamy dostęp do interfajsu z naszego urządzenia

http://192.168.0.115:8080

![](images/Pasted%20image%2020250331233824.png)
