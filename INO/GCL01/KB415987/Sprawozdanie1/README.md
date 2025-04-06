# Sprawozdanie

## Zajęcia 1
### Zalogowanie się na serwerze
![Ss 0](resources/lab1/s0.png)

### Sklonowanie repozytorium przedmiotowego za pomocą HTTPS 
![Ss 1](resources/lab1/s1.png)

### Tworzenie dwóch kluczy SSH
![Ss 2](resources/lab1/s2.png)

### Sklonowanie repozytorium za pomocą protokołu SSH
![Ss 3](resources/lab1/s3.png)

### Konfiguracja weryfikacji dwuetapowej (2FA)
![Sg 0](resources/lab1/g0.png)

### Konfiguracja klucza SSH jako metody dostępdu do GitHub
![Sg 1](resources/lab1/g1.png)

### Utworzenie gałęzi 'KB415987' wychodzącej z gałęzi GCL01
![Ss 4](resources/lab1/s4.png)

### Pisanie skryptu, nadanie uprawnień do jego uruchamiania oraz umieszczenie go w katalogu ~/MDO2025_INO/.git/hooks/
![Ss 5](resources/lab1/s5.png)
### Git Hook
```bash
    #!/bin/bash
    COMMIT_MSG=$(cat "$1")
    if [[ ! "$COMMIT_MSG" =~ ^KB415987 ]]; then
        echo "Error: Commit message have to start with 'KB415987'"
        exit 1
    fi
```
### Dodanie pliku ze sprawodzaniem, umieszczenie w nim treści napisanego wcześniej git hooka oraz dodanie zrzutów ekranu wraz z opisem zrealizowanych kroków
![Ss 6](resources/lab1/s6.png)

### Dodanie plików do śledzenia przez Git'a
![Ss 7](resources/lab1/s7.png)

### Wykonanie commita
![Ss 8](resources/lab1/s8.png)

### Wysłanie zmian na GitHub'a
![Ss 10](resources/lab1/s10.png)

### Wciągnięcie gałęzi 'KB415987' do gałęzi grupowej GCL01
![Ss 11](resources/lab1/s11.png)

#
## Zajęcia 2
### Docker zainstalowany `sudo dnf install -y docker`
![Ss 12](resources/lab2/s12.png)
### Rejestracja w Docker Hub
![](resources/lab2/dockerhub.png)
### Pobranie obrazów `hello-world`, `busybox`, `ubuntu` oraz `mysql`
![Ss 13](resources/lab2/s13.png)
### Uruchomienie kontenera z obrazem `busybox`
![Ss 14](resources/lab2/s14.png)
### Interaktywne podłączenie i wyświetlenie numeru wersji obrazu
![Ss 15](resources/lab2/s15.png)

### Uruchomienie systemu `ubuntu`, prezentacja PID 1 i procesów dockera na hoście
![Ss 16](resources/lab2/s16.png)

### Aktualizacja pakietów `ubuntu`:
![Ss 17](resources/lab2/s17.png)

### Tworzenie pliku `Dockerfile`:
```Dockerfile
FROM ubuntu:latest
RUN apt update && apt install -y git
WORKDIR /repo
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /repo
CMD ["bash"]
```
### Budowanie obrazu z pliku `Dockerfile`
```bash
docker build -t my_image .
```
![Ss 18](resources/lab2/s18.png)

### Uruchamianie kontenera z własnym obrazem
```bash
docker run -it my_image
```
![Ss 19](resources/lab2/s19.png)
#### Repozytorium przedmiotowe zostało pomyślnie sklonowane.
#
### Wyświetlenie uruchomionych kontenerów oraz ich usunięcie:
![Ss 20](resources/lab2/s20.png)

### Wyświetlenie obrazów oraz ich usunięcie:
![Ss 21](resources/lab2/s21.png)

### Plik `Dockerfile` w katalogu /Sprawozdanie1
![Ss 22](resources/lab2/s22.png)

##
## Zajęcia 3

### Oprogramowanie : [cJSON](https://github.com/DaveGamble/cJSON)
Wybrałem to oprogramowanie, ponieważ jest na otwartej licencji, proces jego budowania jest prosty, dzięki czemu można łatwo zbudować oraz przetestować w kontenerze.
### Instalacja potrzebnych narzędzi
![](resources/lab3/1.png)
### Klonowanie repozytorium z wybranym oprogramowaniem
![](resources/lab3/2.png)
### Budowanie projektu
Budowa projektu przeprowadzona z wykorzystaniem narzędzi cmake oraz make

![](resources/lab3/3.png)
![](resources/lab3/4.png)
![](resources/lab3/5.png)
![](resources/lab3/6.png)
### Uruchomienie testów jednostkowych
Aby przeprowadzić testy należy użyć komendy:
```bash
make test
```
![](resources/lab3/7.png)

### Dockerfile do budowania
```Dockerfile
FROM ubuntu:latest
RUN apt update && apt install -y build-essential cmake make gcc git
WORKDIR /app
RUN git clone https://github.com/DaveGamble/cJSON.git && cd cJSON && mkdir build && cd build
WORKDIR /app/cJSON/build
RUN cmake .. && make
```

Po wpisaniu w terminal komendy
```bash
docker build -t cjsonbld -f Dockerfile.cjsonbld .
 ```
pomyślnie utworzył się obraz o nazwie ```jsonbld```

![](resources/lab3/8.png)

### Dockerfile do testów
```Dockerfile
FROM cjsonbld

WORKDIR /app/cJSON/build
CMD ["make", "test"]
```

Po wpisaniu komendy 
```bash
docker build -t cjsontest -f Dockerfile.cjsontest .
```
został utworzony obraz
![](resources/lab3/9.png)

## Uruchomienie kontenera testującego
```bash
docker run --rm cjsontest
```
wykorzystałem flagę --rm żeby kontener po wykonaniu zadania został usunięty

![](resources/lab3/10.png)


### Docker compose
#### Doinstalowanie docker-compose
```bash
sudo dnf install -y docker-compose
```

```yaml
version: '3'

services:
  build:
    image: cjsonbld
    build:
      context: .
      dockerfile: Dockerfile

  test:
    image: cjsontest
    build:
      context: .
      dockerfile: Dockerfile.test
    depends_on:
      - build
```
### Aby ująć kontenery w kompozycję należy wpisać
```bash
docker-compose up --build
```

![](resources/lab3/11.png)
![](resources/lab3/12.png)

###
### Czy program nadaje się do wdrażania i publikowania jako kontener, czy taki sposób interakcji nadaje się tylko do builda?

Program nie nadaje sie do wdrożenia i publikowania jako kontener bo to tylko bibloteka języka C, więc powinna byc używana w innych projektach a nie działać jako samodzielna usługa.

### Jeżeli program miałby być publikowany jako kontener - czy trzeba go oczyszczać z pozostałości po buildzie?
Jeśli program miałby być publikowany jako kontener to należy oczyścić go z pozostałości po buildzie.

### A może dedykowany deploy-and-publish byłby oddzielną ścieżką (inne Dockerfiles)?
Można zastosować jeden Dockerfile dla budowania kodu, drugi do testowania i trzeci dla wersji z gotowym artefaktem.

### Czy zbudowany program należałoby dystrybuować jako pakiet, np. JAR, DEB, RPM, EGG?
Można wykorzystać dystrybuować jako pakiet  ```DEB``` lub ```RPM```.

### W jaki sposób zapewnić taki format? Dodatkowy krok (trzeci kontener)? Jakiś przykład?

Można wykorzystać kontener który spakowałby pliki w taki format.

#
## Zajęcia 4
Tworzenie dwóch woluminów:
```docker
docker volume create in_vol
docker volume create out_vol
```
![](resources/lab4/1.png)

Dockerfile którym utworzę obraz bez gita:
```Dockerfile
FROM ubuntu:latest
RUN apt update && apt install -y build-essential cmake make gcc
WORKDIR /app
```

Budowanie obrazu bez zainstalowanego gita:

![](resources/lab4/2.png)

Tworzenie kontenera z podpiętymi dwoma woluminami na podstawie mojego obrazu:
```docker
docker run -it --name cont_lab4 -v in_vol:/app/input -v out_vol:/app/output cjson-gitless
```

![](resources/lab4/3.png)
Klonowanie projektu na hosta
![](resources/lab4/4.png)
Kopiowanie projektu na wolumin wejściowy z wykorzystnaniem ```docker cp```: 
```docker
docker cp cjson_repo/ cont_lab4:/app/input
```

Pomocna komenda pozwalająca podłączyć się do działającego kontenera jeśli jest on uruchomiony interaktywnie z podłączonym TTY
```docker
docker attach cont_lab4
```
![](resources/lab4/6.png)
###

Budowanie projektu w kontenerze:
![](resources/lab4/7.png)
![](resources/lab4/8.png)
![](resources/lab4/9.png)
Projekt został zbudowany, teraz kopiuję plik cJSON_test do woluminu wyjściowego komendą:
```bash
cp -r build/ /app/output
```


![](resources/lab4/10.png)

Uruchamiam testowy kontener z podłączonym woluminem wyjściowym na którym powinien znajdywać się plik do testowania
```docker
docker run -it --name testowy_kontener -v out_vol:/app alpine sh
```
![](resources/lab4/11.png)

Sukces, po wyłączeniu kontenera do budowania pliki są dostępne na woluminie wyjściowym.

### Powtórzenie operacji z gitem w konetenrze
Po doinstalowaniu gita zabrałem się za klonowanie repo

![](resources/lab4/12.png)

![](resources/lab4/13.png)

Kopiuje rekursywnie wszystko co tam jest w tym katalogu do woluminu wyjściowego
![](resources/lab4/14.png)

Sprawdzenie na hoście czy w woluminie wyjściowym zapisało się repozytorium.

![](resources/lab4/15.png)


#### Możliwość wykonania ww. kroków za pomocą docker build i pliku Dockerfile. (RUN --mount)

Można te kroki zautomatyzować korzystająć z Docker BuildKit, tworzymy Dockerfile w którym sklonujemy dane repozytorium na wolumin wejściowy a następnie zbudujemy program i zapiszemy na woluminie wyjściowym. `RUN --mount` __tymczasowo__ zamontuje woluminy, dzięki czemu rozmiar obrazu się nie zwiększy.

### Iperf
Stworzenie sieci:
![](resources/lab4/16.png)

```bash
docker network create --driver bridge siec_iperf
```

Uruchomienie kontenera z serwerem
![](resources/lab4/17.png)

Utworzenie kontenera z klientem do testowania połączenia:
![](resources/lab4/18.png)

Połączenie się z hosta:
![](resources/lab4/19.png)
Aby przeprowadzić operację połączenia się z Windowsa do serwera musiałem najpierw doinstalować iperf3 na Windowsie
![](resources/lab4/20.png)
Oraz przekierować port 5201
![](resources/lab4/29.png)
Po wpisaniu komendy
```PS
iperf3 -c 192.168.1.105
```
Można zobaczyć prędkość połączenia między moim laptopem z Windowsem, a serwerem w kontenerze na maszynie wirtualnej.
![](resources/lab4/28.png)
Połączenie VM-ki z serwerem jest dużo szybsze niż mojego laptopa z tym serwerem.

Sprawdzenie logów serwera:

![](resources/lab4/30.png)




### Jenkins
Instalację Jenkins przeprowadziłem wg instrukcji w dokumentacji: https://www.jenkins.io/doc/book/installing/docker/

Utworzenie sieci:
![](resources/lab4/21.png)

Utworzenie kontenera z obrazem docker:dind

![](resources/lab4/23.png)

Skopiowanie Dockerfile i zbudowanie obrazu `myjenkins-blueocean`

```Dockerfile
FROM jenkins/jenkins:2.492.3-jdk17
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

Zbudowanie obrazu komendą:

```bash
docker build -t myjenkins-blueocean:2.492.3-1 .
```


![](resources/lab4/24.png)

Uruchomienie kontenera z tym obrazem
![](resources/lab4/25.png)
![](resources/lab4/26.png)
 

Jenkins działa i jest dostępny pod `localhost:8081`, (bo przekierowałem port):
![](resources/lab4/27.png)
