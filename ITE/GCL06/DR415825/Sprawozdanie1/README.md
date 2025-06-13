# Sprawozdanie 1 - Git, Docker - Dawid Reszczyński

## Ćw. 1 - Instalacja Git i obsługa SSH

### Cel laboratorium

Celem zajęć laboratoryjnych było praktyczne zapoznanie z konfiguracją i wykorzystaniem narzędzi Git oraz SSH. Zakres tematyczny obejmował konfigurację kluczy SSH, techniki klonowania repozytoriów, zasady zarządzania gałęziami, a także przykładowe wdrożenie haków (GitHooks) w procesie deweloperskim.

### Instalacja
Instalacja Git z pomocą polecenia: `sudo dnf install -y git`

![alt text](images/image.png)

### Sklonowanie repozytorium projektu

Sklonowanie plików projektowych poleceniem: `git clone https://github.com/InzynieriaOprogramowaniaAgh/MDO2025_INO.git`

![alt text](images/image-1.png)

### Generacja kluczy SSH

Wygenerowanie dwóch par kluczy SSH - jednego bez hasła, drugiego z: `ssh-keygen -t ed25519 -C "reszczak@gmail.com"`

![alt text](images/image-2.png)

![alt text](images/image-3.png)

### Konfiguracja dostępu na GitHubie i clone repo za pomocą ssh

Dodanie ssh-agenta: `eval "$(ssh-agent -s)"`
![alt text](images/image-4.png)

Podpięcie kluczy: `ssh-add ~/.ssh/<key>`
![alt text](images/image-5.png)
![alt text](images/image-6.png)

Dodanie kluczy na GitHub:
![alt text](images/image-7.png)

Sklonowanie repozytorium za pomocą ssh: `git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git`
![alt text](images/image-8.png)

### Praca na branchach

Przełączenie się na własny branch (inicjały_nr_indexu): `git checkout -b DR415825`
![alt text](images/image-10.png)

### Utworzenie Git Hooka

Plik `commit-msg`

```bash 
#!/bin/sh
FILE=$1
MSG=$(cat "$FILE")

if [[ ! $MSG =~ ^DR415825 ]]; then
    echo "ERROR: Invalid commit message. It has to begin with 'DR415825'."
    exit 1
fi
```

### Ustawienie dostępu

```bash 
chmod +x <path>
git config --local core.hooksPath <path>
```
![alt text](images/image-11.png)
![alt text](images/image-12.png)


### Wnioski

Klucze SSH upraszczają bezpieczny dostęp do repozytoriów, eliminując potrzebę ciągłego podawania poświadczeń. Gałęzie (branches) są kluczowe dla izolacji pracy, a GitHooks pozwalają automatyzować walidację, np. komunikatów commitów, w celu utrzymania spójności projektu.

## Ćw. 2 - Docker

### Cel laboratorium
Celem laboratorium było wprowadzenie do technologii konteneryzacji z wykorzystaniem narzędzia Docker. Zakres merytoryczny zajęć obejmował metody tworzenia obrazów, sposoby uruchamiania kontenerów oraz zasady konstruowania plików Dockerfile.

### Aktualizacja systemu

Aktualizacja składników używając: `sudo yum update -y`
![alt text](images/image-14.png)

### Instalacja dockera

Instalacja dockera poleceniem: `sudo yum install docker`
![alt text](images/image-15.png)
![alt text](images/image-16.png)

### Start dockera

Wystartowanie dockera z użyciem: `systemctl start docker` , `systemctl enable docker`
![alt text](images/image-17.png)

### Status dockera

`systemctl status docker`
![alt text](images/image-18.png)

### Logowanie do dockera

`docker login`

![alt text](images/image-19.png)
![alt text](images/image-20.png)

### Pobranie obrazów

Pobranie obrazów hello-world, busybox, fedora, mysql poleceniem : `docker pull`
![alt text](images/image-21.png)

### Uruchomienie kontenera

#### Zwykły 

Stworzenie kontenera i sprawdzenie statusu na liście kontenerów
`docker run -d --name busybox busybox`
![alt text](images/image-23.png)

#### Interaktywny

Uruchomienie kontenera z trybem interaktywnym i ukazanie wersji
`docker run -it --name busybox busybox sh` 
![alt text](images/image-24.png)

#### System w kontenerze

Uruchomienie systemu w kontenerze i ukazanie wersji

![alt text](images/image-25.png)

#### Proces PID

`ps aux`
![alt text](images/image-26.png)

#### Aktualizacja pakietów i wyjście

Zaktualizowanie pakietów z użyciem polecenia: 
`dnf update`
![alt text](images/image-27.png)

### Dockerfile

#### Stworzenie pliku Dockerfile

![alt text](images/image-28.png)

Jak widać, dockerfile automatycznie klonuje nam repozytorium

#### Zbudowanie obrazu na podstawie Dockerfile

`docker build . -t test`
![alt text](images/image-29.png)

#### Uruchomienie kontenera na bazie obrazu

`docker run -it ubuntu`
![alt text](images/image-30.png)

I tak dla każdego przypadku 

#### Wypisanie uruchomionych kontenerów

`docker ps -a`
![alt text](images/image-31.png)

#### Zatrzymanie i usunięcie wszystkich kontenerów 

`docker stop` - zatrzymanie
`docker rm` - usunięcie 
![alt text](images/image-32.png)

### Wnioski

Ćwiczenie pozwoliło zrozumieć podstawowy cykl pracy z Dockerem: definicja środowiska w Dockerfile, wykorzystanie obrazów z Docker Hub i uruchamianie izolowanych kontenerów. Kluczowym wnioskiem jest zdolność do tworzenia powtarzalnych i przenośnych środowisk aplikacyjnych.

## Ćw. 3 Dockerfiles, Kontenery

### Cel laboratorium
Celem zajęć było praktyczne zastosowanie Dockera do konteneryzacji aplikacji. Proces ten obejmował stworzenie plików Dockerfile do budowy i uruchamiania aplikacji w izolowanym środowisku, a także przeprowadzenie analizy porównawczej jej działania w kontenerze i poza nim.

### Host 

#### Sklonowanie repozytorium i instalacja bibliotek

![alt text](images/image-33.png)
![alt text](images/image-34.png)
![alt text](images/image-35.png)

#### Przygotowanie build dla Meson, zbudowanie aplikacji i wykonanie testów

``` bash
meson Build
ninja -C Build
ninja -C Build test
```
![alt text](images/image-36.png)
![alt text](images/image-37.png)
![alt text](images/image-38.png)

#### Historia poleceń

![alt text](images/image-39.png)

### Kontener 

#### Uruchomienie kontenera na bazie obrazu fedory

`docker run -it --name fedora fedore:latest /bin/bash`

![alt text](images/image-40.png)
![alt text](images/image-41.png)

#### Instalacja bibliotek 

![alt text](images/image-42.png)

#### Sklonowanie repozytorium 

![alt text](images/image-43.png)

#### Przygotowanie builda, build i testy

``` bash
meson Build
ninja -C Build
ninja -C Build test
```

![alt text](images/image-44.png)
![alt text](images/image-45.png)

#### Historia - system

![alt text](images/image-46.png)

#### Historia - poza systemem 

![alt text](images/image-47.png)

### Automatzacja procesu - kontener instaluje wszystko do builda a drugi bazuje na pierwszym i uruchamia testy

#### Dockerfile do buildowania aplikacji

![alt text](images/image-48.png)

#### Budowanie obrazu

![alt text](images/image-49.png)

#### Dockerfile do testów

![alt text](images/image-50.png)

#### Kolejny build obrazu 

![alt text](images/image-51.png)

#### Stworzenie kontenera na bazie obrazu 

![alt text](images/image-52.png)

### Dockerfile dla node-js-dummy-test

#### Dockerfile2.build i Dockerfile2.test

![alt text](images/image-54.png)
![alt text](images/image-55.png)

#### Buildy
![alt text](images/image-56.png)
![alt text](images/image-57.png)

Obraz się stworzył, więc testy zaliczone.

### Wnioski

Konteneryzacja eliminuje problemy z różnicami między środowiskami, gwarantując powtarzalny proces budowy aplikacji. Zastosowanie wieloetapowego budowania (multi-stage builds) okazało się skuteczną metodą optymalizacji, która znacząco zmniejsza rozmiar finalnego obrazu.

## Ćw. 4 Konteneryzacja i instalacja Jenkins

### Cel laboratorium
Celem laboratorium było pogłębienie wiedzy z zakresu zarządzania woluminami i sieciami w środowiskach skonteneryzowanych. Program zajęć obejmował również praktyczne przeprowadzenie testów wydajnościowych za pomocą narzędzia iperf3 oraz konfigurację środowiska Jenkins w celu automatyzacji procesów CI/CD. 

### Zachowanie stanu

#### Stworzenie woluminów v1 - wejściowy i v2 - wyjściowy

`docker volume create v1`

![alt text](images/image-58.png)

#### Dockerfile bez git'a do uruchomienia projektu

![alt text](images/image-59.png)

#### Zbudowanie obrazu

![alt text](images/image-60.png)

I tutaj pojawił się błąd, na starcie nie wiedziałem co się dzieje więc postanowiłem poczekać do czasu który był napisany w errorze - i zadziałało, może moja maszyna ma źle ustawiony czas, albo błąd losowy.

![alt text](images/image-61.png)

#### Utworzenie kontenera głownego w podpięciem woluminów 

![alt text](images/image-62.png)

#### Pobranie obrazu alpine z gitem

![alt text](images/image-63.png)

#### Stworzenie kontenera i sklonowanie repozytorium 
![alt text](images/image-64.png)
![alt text](images/image-65.png)

#### Wywołanie builda na woluminie wejściowym 

![alt text](images/image-66.png)

#### Skopiowanie powstałych plików na wolumin wyjściowy

![alt text](images/image-67.png)

#### Dockerfile operacji klonowania na wolumin wyjściowy za pomocą głównego kontenera

Tutaj trzeba wstawić po zalogowaniu na maszyne bo nie mam screena 
![alt text](images/image-92.png)

#### Zbudowanie obrazu

![alt text](images/image-68.png)

#### Uruchomienie kontenera i sprawdzenie zawartości

![alt text](images/image-69.png)


### Eksponowanie portu

#### Dockerfile pod iperf3

![alt text](images/image-70.png)

#### Zbudowanie obrazu

![alt text](images/image-71.png)

#### Uruchomienie kontenera
Kontener uruchamiamy w trybie detached przekierowując port iperf3 5201

![alt text](images/image-72.png)

#### Zmiana nazwy kontenera

![alt text](images/image-73.png)


#### Podpięcie się do innego kontenera (fedory z lab2)
![alt text](images/image-74.png)

#### Doinstalowanie iperf3
![alt text](images/image-75.png)

#### Przetestowanie działania

![alt text](images/image-76.png)

#### Dockerfile pod obraz klienta

![alt text](images/image-77.png)

#### Zbudowanie obrazu 

![alt text](images/image-78.png)

#### Stworzenie własnej sieci 
`docker network create`
![alt text](images/image-79.png)

#### Uruchomienie kontenera serwerowego i klienskiego 

Serwerowy - wystawiony port, podłączony do sieci, detached

`docker run -d --net=iperf_net -p 5201:5201 --name iperf_s iperf3_img`

Kliencki - podłączony do sieci

`docker run --rm  -it--net=iperf_net --name iperf_c iperf3_img_client iperf3 -c iperf_s`

![alt text](images/image-80.png)

#### Test ruchu
![alt text](images/image-81.png)

### Instalacja Jenkins

#### Utworzenie sieci i uruchomienie dockera na bazie obrazu docker:dind

```bash 
docker create network

docker run \
  --name jenkins-docker \
  --rm \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind \
  --storage-driver overlay2
```
![alt text](images/image-82.png)

#### Kontenery (docker ps)

![alt text](images/image-83.png)

#### Dockerfile (według dokumentacji)

![alt text](images/image-84.png)

#### Zbudowanie obrazu 

![alt text](images/image-85.png)

#### Uruchomienie kontenera na bazie obrazu

![alt text](images/image-86.png)

#### Kontenery 

![alt text](images/image-87.png)

#### Historia

![alt text](images/image-88.png)

#### Start Jenkinsa

![alt text](images/image-89.png)

#### Konsola Jenkinsa i uzyskanie hasła

![alt text](images/image-90.png)

#### Koniec ćwiczenia

![alt text](images/image-91.png)

### Wnioski 

Woluminy i sieci Docker są niezbędne do budowy złożonych aplikacji, zapewniając trwałość danych i komunikację między kontenerami. Uruchomienie Jenkinsa w architekturze Docker-in-Docker zademonstrowało zaawansowany wzorzec tworzenia w pełni skonteneryzowanego i przenośnego środowiska CI/CD.


***PS: Z tego miejsca bardzo przepraszam za opóźnienie. Zrobiłem to ćwiczenie już dawno (można sprawdzić po commitach - nie w terminie, chyba 11 maja), ale wypadło mi z głowy zrobienie sprawozdania. Pozdrawiam, Dawid R***

