# Sprawozdanie 1

# Pierwsze zajęcia - Wprowadzenie, Git, Gałęzie, SSH

## Logowanie do serwera
![Ss 0](sources/screen1/1-9.png)

## Klonowanie repozytorium za pomocą HTTPS
![Ss 1](sources/screen1/1-12.png)

## Generowanie dwóch kluczy SSH za pomocą komend poniżej
Inne niż RSA i jeden z nich został zabezpieczony hasłem

![Ss 2](sources/screen1/1-0.png)
![Ss 3](sources/screen1/1-1.png)

## Klonowanie repozytorium z wykorzystaniem SSH
Po ustawieniu klucza SSH repozytorium zostało sklonowane za pomocą protokołu SSH.

![Ss 4](sources/screen1/1-13.png)

## Aktywacja weryfikacji dwuetapowej (2FA)
![Ss 5](sources/screen1/1-11.png)

## Ustawienie klucza SSH jako metody autoryzacji w GitHub
![Ss 6](sources/screen1/1-10.png)

## Utworzenie gałęzi „AB414799” na podstawie „GCL01”
![Ss 7](sources/screen1/1-2.png)
![Ss 8](sources/screen1/1-3.png)
![Ss 9](sources/screen1/1-4.png)

## Tworzenie skryptu, nadawanie uprawnień i umieszczanie go w katalogu hooków Git
![Ss 10](sources/screen1/1-5.png)
![Ss 11](sources/screen1/1-6.png)
![Ss 12](sources/screen1/1-7.png)
## Konfiguracja Git Hooka do sprawdzania wiadomości commitów
```bash
    #!/bin/bash
    REQUIRED_PREFIX="AB414799"
    MESSAGE=$(cat "$1")

    if [[ ! "$MESSAGE" =~ ^$REQUIRED_PREFIX ]]; then
        echo "❌ Commit message musi zaczynać się od: $REQUIRED_PREFIX"
        exit 1
    fi
```
## Dodawanie plików do kontroli wersji w Git
![Ss 13](sources/screen1/1-15.png)

## Tworzenie commita w repozytorium
![Ss 14](sources/screen1/1-14.png)

## Wysyłanie zmian do GitHub
![Ss 15](sources/screen1/1-17.png)

## Scalanie gałęzi „AB414799” z „GCL01”
![Ss 16](sources/screen1/1-16.png)


# Drugie zajęcia - Git, Docker
## Instalacja Dockera `sudo dnf install -y docker`
Docker został zainstalowany zgodnie z oficjalnymi instrukcjami, wykorzystując repozytorium dystrybucji.

![Ss 17](sources/screen2/2-0.png)

## Pobieranie obrazów „hello-world”, „busybox”, „ubuntu” i „mysql”
![Ss 18](sources/screen2/2-1.png)
## Uruchamianie kontenera na bazie „busybox”
![Ss 19](sources/screen2/2-2.png)
## Interaktywne podłączenie do kontenera i sprawdzenie wersji
![Ss 20](sources/screen2/2-3.png)

## Start systemu „ubuntu” i analiza procesów Dockera
Weryfikacja procesu PID 1 w kontenerze:

![Ss 21](sources/screen2/2-4.png)

## Aktualizacja pakietów `ubuntu` komendą `apt update && apt upgrade -y`:
![Ss 22](sources/screen2/2-5.png)

### Po tej czynności należało wyjść z kontenera poprzez komendę `exit`


## Tworzenie pliku `Dockerfile`:
```Dockerfile
FROM ubuntu:latest
RUN apt update && apt install -y git
WORKDIR /repo
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /repo
CMD ["bash"]
```
## Budowanie obrazu z pliku `Dockerfile`
```bash
docker build -t new_image .
```
![Ss 23](sources/screen2/2-6.png)

## Uruchamianie kontenera na podstawie nowego obrazu
```bash
docker run -it new_image
```
![Ss 24](sources/screen2/2-7.png)
#### Repozytorium przedmiotowe zostało pomyślnie sklonowane.
#
## Sprawdzenie uruchomionych kontenerów i ich usuwanie
![Ss 25](sources/screen2/2-8.png)
![Ss 26](sources/screen2/2-9.png)
## Wyświetlanie dostępnych obrazów i ich usuwanie
![Ss 27](sources/screen2/2-10.png)

## Umieszczenie pliku „Dockerfile” w katalogu „Sprawozdanie1”
![Ss 28](sources/screen2/2-11.png)

# Trzecie zajęcia - Dockerfiles, kontener jako definicja etapu

### Oprogramowanie: cJSON

## Klonowanie repozytorium
![Ss 29](sources/screen3/3-1.png)

## Instalacja zależności poprzez komendę
### `sudo dnf install gcc cmake make`
   - `sudo` → Uruchamia polecenie z uprawnieniami administratora.  
   - `dnf install` → Używa menedżera pakietów `dnf` do instalacji oprogramowania.  
   - `gcc` → Kompilator języka C/C++.  
   - `cmake` → Narzędzie do zarządzania procesem budowania oprogramowania.  
   - `make` → Narzędzie do kompilacji kodu na podstawie plików makefile.  
![Ss 30](sources/screen3/3-2.png)

## Budowa projektu
### Stworzenie specjalnego folderu o nazwie `build` w któym wykonujemy dalsze czynności

### `cmake ..`
   - Konfiguruje projekt CMake, generując pliki makefile w katalogu nadrzędnym (`..`).
   **Używane do przygotowania środowiska kompilacji na podstawie plików CMakeLists.txt.**
     
![Ss 31](sources/screen3/3-3.png)
![Ss 32](sources/screen3/3-4.png)

### `make`
   - Kompiluje kod źródłowy zgodnie z plikami makefile wygenerowanymi przez CMake.
   **Uruchamia proces budowania projektu.**
     
![Ss 33](sources/screen3/3-5.png)

![Ss 34](sources/screen3/3-6.png)

## Testowanie projektu
### `ctest`
   - Uruchamia testy jednostkowe zdefiniowane w konfiguracji CMake.
   **Służy do automatycznego testowania skompilowanego kodu.**
     
![Ss 35](sources/screen3/3-7.png)

## Uruchomienie kontenera Ubuntu w sposób interaktywny dzięki parametrowi -it i instalacja wymaganych zależności
![Ss 36](sources/screen3/3-8.png)

## Powtórzenie całego poprzedniego procesu budowy i testu na tym kontenerze
![Ss 37](sources/screen3/3-9.png)

![Ss 38](sources/screen3/3-10.png)

![Ss 39](sources/screen3/3-11.png)

![Ss 40](sources/screen3/3-12.png)

### Po wyjściu z kontenera ubuntu należało zautomatyzować proces poprzez utworzenie dwóch plików Dockerfile

## Tworzenie Dockerfile.build
```Dockerfile.build
FROM ubuntu:latest
RUN apt update && apt install -y git cmake gcc g++ make
WORKDIR /app
RUN git clone https://github.com/DaveGamble/cJSON.git .
RUN mkdir build && cd build && cmake .. && make
```
## Budowa tego obrazu
### `docker build -t cjson_tester -f Dockerfile.test`
   - `-t cjson_builder` → Nadaje nazwę i tag obrazowi Docker (np. `cjson_builder`).
   - `-f Dockerfile.build` → Określa konkretny plik Dockerfile do użycia zamiast domyślnego (`Dockerfile`).
   **Stosowane, aby zbudować obraz Dockera na podstawie niestandardowego pliku konfiguracji.**
     
![Ss 41](sources/screen3/3-13.png)

## Tworzenie Dockerfile.test
```Dockerfile.test
FROM cjson_builder

WORKDIR /app/build
CMD ["ctest"]
```
## Budowa tego obrazu
### `docker build -t cjson_tester -f Dockerfile.test`
   - `-t cjson_tester` → Nadaje nazwę i tag obrazowi Docker (np. `cjson_tester`).
   - `-f Dockerfile.test` → Określa konkretny plik Dockerfile do użycia zamiast domyślnego (`Dockerfile`).
   **Stosowane, aby zbudować obraz Dockera na podstawie niestandardowego pliku konfiguracji.**
     
![Ss 42](sources/screen3/3-14.png)

## Uruchomienie testów
### `docker run -t cjson_tester`
![Ss 43](sources/screen3/3-15.png)

## Działające obrazy
![Ss 44](sources/screen3/3-16.png)

# Czwarte zajęcia - Dodatkowa terminologia w konteneryzacji, instancja Jenkins

## Zachowywanie stanu

### Tworzenie woluminów zostało zrealizowane za pomocą polecenia `docker volume create`

![Ss 45](sources/screen4/4-0.png)

### Uruchomienie kontenera z zamontowanymi woluminami
Komenda uruchamia kontener z obrazu ubuntu. Wolumin input_vol jest montowany do katalogu /input w kontenerze, a output_vol do katalogu /output, co pozwala na wymianę danych między kontenerem a hostem w tych lokalizacjach.

![Ss 46](sources/screen4/4-1.png)

### Instalacja zależności poprzez `apt update && apt install -y cmake gcc g++ make` a także `apt update && apt install -y meson ninja-build`

![Ss 46](sources/screen4/4-2.png)
![Ss 47](sources/screen4/4-2-1.png)

### Aby sklonować repozytorium na hoście, zastosowałem polecenie docker volume inspect, które dostarcza szczegółowych informacji o woluminie, w tym wskazuje lokalizację jego danych na hoście

![Ss 48](sources/screen4/4-3.png)

### Sklonowanie repozytorium do katalogu, który zawiera dane wejściowego woluminu

![Ss 49](sources/screen4/4-4.png)

### Budowa programu w katalogu woluminu wejściowego
 Meson to system kompilacji o wysokiej wydajności, który używa pliku meson.build do efektywnego kompilowania kodu źródłowego.

![Ss 50](sources/screen4/4-5.png)

### Przeniesienie plików wynikowych do katalogu wyjściowego, a także zobaczenie poprawności z poziomu hosta

![Ss 51](sources/screen4/4-6.png)
![Ss 52](sources/screen4/4-7.png)

### Powtórzenie powyższych kroków ale z użyciem gita

![Ss 53](sources/screen4/4-8.png)

Klonowanie repozytorium

![Ss 54](sources/screen4/4-9.png)

Reszta kroków bez zmian

### Aby zautomatyzować ten proces moglibyśmy tu użyć pliku Dockerfile, które wykorzystał by opcję RUN --mount

## Eksponowanie portu

### W celu uruchomienia serwera iperf wykorzystano publicznie dostępny na DockerHub obraz networkstatic/iperf3. Port na którym został utworzony serwer to 5201, na którym od razu nasłuchuje

![Ss 55](sources/screen4/4-10.png)

### Sprawdzenie IP kontenera komendą `docker inspect iperf_server | grep IP`

![Ss 56](sources/screen4/4-11.png)

### Utworzono nowy kontener i nawiązano połączenie z serwerem, wykorzystując adres IP kontenera, na którym serwer iperf nasłuchuje.

![Ss 57](sources/screen4/4-12.png)

### Kolejnym krokiem było utworzenie sieci Docker za pomocą `docker network create`

![Ss 58](sources/screen4/4-13.png)

### Zrobiłem nowy serwer w tej sieci 

![Ss 59](sources/screen4/4-14.png)

### Nawiązanie połączenia z systemu Fedora

![Ss 60](sources/screen4/4-15.png)

### Zatrzymanie i usunięcie serwera

![Ss 61](sources/screen4/4-16.png)

### Po usunięciu utworzono nowy serwer

![Ss 62](sources/screen4/4-17.png)

### Zainstalowanie narzędzia iperf3

![Ss 63](sources/screen4/4-18.png)

### Połączenie z hosta

![Ss 63](sources/screen4/4-19.png)

### Z systemu Windows nawiązałem połączenie z serwerem iperf, używając komendy `.\iperf3.exe -c 192.168.56.1` na porcie 5201 do tego najpierw musiałem przekierować porty na maszynie wirtualnej

![Ss 64](sources/screen4/4-20_1.png)

Aby to wykonać, należało wcześniej pobrać iperf3. Ja to zrobiłem za pomocą tej instrukcji: https://medium.com/@OkoloPromise/how-to-install-iperf3-on-windows-10-837d2fefcd0e

![Ss 65](sources/screen4/4-20.png)

### Za pomocą komendy `docker logs iperf_server` zostały sprawdzone logi serwera
Nie wystąpiły żadne problemy z połączeniem, jak pokazują logi. Transfer danych pomiędzy hostem a serwerem jest dużo szybszy niż pomiędzy serwerem a systemem Windows, co jest zrozumiałe, ponieważ host i serwer działają na tej samej maszynie wirtualnej.

![Ss 66](sources/screen4/4-21.png)

![Ss 67](sources/screen4/4-22.png)
---
## Instalacja Jenkinsa

### Zważając na to, że kończę to sprawozdanie po labach 5, instaluje jenkinsa tak jak jest w instrukcji do laboratoriów numer 5 korzystając z intrukcji instalacji pod tym linkiem:
### https://www.jenkins.io/doc/book/installing/docker/

### Sieć o nazwie jenkins została utworzona przed rozpoczęciem procesu instalacji.

![Ss 98](sources/screen4/5-0.png)

### Kolejnym krokiem było utworzenie kontenera na podstawie obrazu `docker:dind`, wykorzystując do tego poniższe polecenie.

![Ss 99](sources/screen4/5-1.png)

### W dalszej kolejności przygotowano plik Dockerfile, który generuje spersonalizowany obraz oparty na oficjalnym obrazie Jenkinsa. Jego zawartość została zaczerpnięta z dokumentacji Jenkinsa.

```
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

### W dalszej części procesu przystąpiono do budowy obrazu komendą `docker build -t myjenkins-blueocean:2.492.3-1 .`

![Ss 100](sources/screen4/5-2.png)

### Na bazie przygotowanego obrazu uruchomiono kontener za pomocą poniższego polecenia.

![Ss 101](sources/screen4/5-3.png)

### Po stronie hosta, na zakończenie możliwe było przejście do ekranu logowania dostępnego pod adresem localhost:8081, z wykorzystaniem portu 8081. Zostało skonfigurowane przekierowanie portów z lokalnego komputera na maszynę wirtualną.

![Ss 102](sources/screen4/5-4.png)

### Pierwsze logowanie zostało zrobione ale nie zarejestrowane dlatego jestem już na ekranie logowania
![Ss 103](sources/screen4/5-5.png)

