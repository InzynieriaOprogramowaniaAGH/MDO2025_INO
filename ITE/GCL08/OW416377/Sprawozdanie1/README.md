# Sprawozdanie 1

Oliwia Wiatrowska


---


## **Laboratorium 01**

### **Wprowadzenie, Git, Gałęzie, SSH**


---

## **1. Instalacja klienta Git i konfiguracja SSH**
Podczas konfiguracji środowiska na maszynie wirtualnej zainstalowałam system kontroli wersji Git oraz skonfigurowałam dostęp do GitHuba za pomocą klucza SSH. Aby potwierdzić, że Git i obsługa SSH zostały poprawnie skonfigurowane, przedstawiam wyniki kilku komend diagnostycznych:

### Wersja Gita

```bash
git --version
```
![Wersja Gita](zrzuty_ekranu1/zrzut1.png)

### Lokalizacja pliku wykonywalnego Gita

```bash
which git
```
![Lokalizacja pliku wykonywalnego Gita](zrzuty_ekranu1/zrzut2.png)

### Sprawdzenie klucza SSH

```bash
ls -la ~/.ssh/
```
![Sprawdzenie klucza SSH](zrzuty_ekranu1/zrzut3.png)

### Test połączenia SSH z GitHubem

```bash
ssh -T git@github.com
```
![Test połączenia SSH z GitHubem](zrzuty_ekranu1/zrzut4.png)

### Konfiguracja użytkownika Git

```bash
git config --list
```

![Konfiguracja użytkownika Git](zrzuty_ekranu1/zrzut5.png)


## **2. Klonowanie repozytorium**

### Klonowanie repozytorium przez SSH

Po skonfigurowaniu klucza SSH, sklonowałam repozytorium przy użyciu SSH:

```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

Zrzut ekranu przedstawiający poprawnie sklonowane repozytorium:
![Klonowanie repozytorium](zrzuty_ekranu1/zrzut6.png)


## **3. Gałęzie**

### Przełączanie się między gałęziami
Na początku przełączyłam się na gałęź main, następnie na gałęź mojej grupy, tj. GCL08

![Przełączenie na gałęź main i gałęź grupy](zrzuty_ekranu1/zrzut7.png)

### Utworzenie nowej gałęzi
Następnie uwtorzyłam swoją gałąź o nazwie składającej się z moich inicjałów i numeru indeksu

![Tworzenie mojej gałęzi](zrzuty_ekranu1/zrzut8.png)

## **4. Praca na nowej gałęzi**

### Utworzenie nowego katalogu
Utworzyłam katalog, także o nazwie składającej się z moich inicjałów i numeru indeksu:

![Tworzenie mojego katalogu](zrzuty_ekranu1/zrzut9.png)

### Napisanie Git hooka
Napisałam hooka `commit-msg`, weryfikującego to, aby każdy mój "commit message" zaczynał się od moich inicjałów i numeru indeksu.

Plik `commit-msg`:

```bash
#!/bin/bash

EXPECTED_PREFIX="OW416377"
COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! "$COMMIT_MSG" =~ ^$EXPECTED_PREFIX ]]; then
  echo "❌ Błąd: Każdy commit message musi zaczynać się od \"$EXPECTED_PREFIX\""
  exit 1
fi

exit 0
```
Utworzony skrypt znajduje się w utworzonym wcześniej katalogu.

![Lokalizacja skryptu](zrzuty_ekranu1/zrzut10.png)

Następnie skopiowałam go do katalogu `.git/hooks/`:

```bash
cp commit-msg ../../../.git/hooks/
```

Oraz dodałam uprawnienia do uruchamiania:

```bash
chmod +x ../../../.git/hooks/commit-msg
```

![Komenda kopiowania skryptu i nadawania uprawnień](zrzuty_ekranu1/zrzut11.png)

### Sprawdzenie działania hooka

![Komunikat o błędzie](zrzuty_ekranu1/zrzut12.png)

![Poprawne dodanie commita](zrzuty_ekranu1/zrzut13.png)

### Wysłanie zmian do zdalnego źródła

![Wysłanie zmian do zdalnego źródła](zrzuty_ekranu1/zrzut14.png)

### Próba wyciągnięcia swojej gałęzi do gałęzi grupowej

```bash
git checkout GCL08
git merge OW416377
git push origin OW416377
```
![Próba wyciągnięcia swojej gałęzi](zrzuty_ekranu1/zrzut15.png)

---


## **Laboratorium 02**

### **Git, Docker**


---

## **1. Instalacja dockera**

```bash
sudo dnf install -y docker
```

![Instalacja dockera](zrzuty_ekranu1/instalacja_dockera.png)
![Ukończenie instalacji](zrzuty_ekranu1/docker_ukonczenie_instalacji.png)

### Uruchomienie Dockera oraz sprawdzenie, czy działa

![Uruchomienie dockera](zrzuty_ekranu1/docker_uruchomienie.png)

## **2. Rejestracja w Docker Hub**
Zarejestrowałam się w Docker Hub poprzez konto na Githubie, a następnie zalogowałam się w terminalu.
![Konto w DockerHub](zrzuty_ekranu1/konto_w_dockerhub.png)

![Logowanie przez terminal](zrzuty_ekranu1/logowanie_docker.png)


## **3. Pobranie odpowiednich obrazów**

```bash
sudo docker pull hello-world
sudo docker pull busybox
sudo docker pull ubuntu
sudo docker pull fedora
sudo docker pull mysql
```
Sprawdzenie czy obrazy zostały pobrane:

```bash
sudo docker images
```

![Sprawdzenie pobrania obrazów](zrzuty_ekranu1/lista_pobranych_obrazow.png)

## **4. Uruchomienie kontenera z obrazu busybox**

### Uruchomienie kontenera i sprawdzenie czy działa

![Uruchomienie kontenera](zrzuty_ekranu1/uruchomienie_kontenera_busybox.png)

### Interaktywne podłączenie się do kontenera

```bash
sudo docker exec -it busybox sh
```
![Podłączenie się do kontenera](zrzuty_ekranu1/wejscie_do_kontenera.png)

### Wywołanie numeru wersji

![Wywołanie numeru wersji](zrzuty_ekranu1/numer_wersji_busybox.png)

## **5. Uruchomienie "systemu w kontenerze" (ubuntu)**

### Uruchomienie kontenera Ubuntu i sprawdzenie, czy działa

![Uruchomienie kontenera Ubuntu](zrzuty_ekranu1/uruchomienie_kontenera_ubuntu.png)

### Sprawdzenie PID1 w kontenerze

![PID1  w kontenerze ubuntu](zrzuty_ekranu1/pid1_ubuntu.png)

### Sprawdzenie procesów dockera na hoście

![Procesy dockera na hoście](zrzuty_ekranu1/procesy_dockera_na_hoscie.png)

### Aktualizacja pakietów

```bash
apt update && apt upgrade -y
```

![Aktualizacja pakietów](zrzuty_ekranu1/koncowy_fragment_outtputu_aktualizacji_pakietow.png)

## **6. Stworzenie własnego Dockerfile**

### Tworzenie pliku Dockerfile

![Tworzenie Dockerfile](zrzuty_ekranu1/tworzenie_pliku_dockerfile.png)

plik `Dockerfile`:

```bash
FROM ubuntu:latest

LABEL maintainer="Oliwia Wiatrowska"

RUN apt update && apt install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

CMD ["bash"]
```

### Budowanie obrazu Dockera

```bash
sudo docker build -t moj_obraz .
```
![Budowanie obrazu](zrzuty_ekranu1/budowanie_obrazu_mojego_dockerfile.png)

### Sprawdzenie, czy `moj_obraz` został zbudowany

![Sprawdzenie zbudowania obrazu](zrzuty_ekranu1/sprawdzenie_zbudowania_mojego_obrazu.png)

### Uruchomienie kontenera

![Uruchomienie mojego kontenera](zrzuty_ekranu1/uruchomienie_mojego_kontenera.png)

### Sprawdzenie, czy repozytorium zostało sklonowane

![Sprawdzenie repo](zrzuty_ekranu1/sprawdzenie_sklonowania_repo.png)

### Sprawdzenie czy Git działa

![Sprawdzenie Git](zrzuty_ekranu1/sprawdzenie_git_moj_kontener.png)

## **7. Wyświetlenie uruchomionych (!= "działających") kontenerów i usunięcie ich**

### Wyświetlenie kontenerów

![Wyświetlenie kontenerów](zrzuty_ekranu1/wyswietlenie_wszystkich_kontenerow.png)

### Usunięcie kontenerów

![Usunięcie kontenerów](zrzuty_ekranu1/usuniecie_kontenerow.png)

## **8. Wyczyszczenie obrazów**

### Wyświetlenie obrazów

![Wyświetlenie obrazów](zrzuty_ekranu1/wyswietlenie_obrazow.png)

### Usunięcie obrazów

```bash
sudo docker rmi $(sudo docker images -q)
```
![Usunięcie obrazów](zrzuty_ekranu1/usuniecie_obrazow.png)

## **9. Dodanie pliku `Dockerfile` do folderu `sprawozdanie1`**

```bash
cp ~/MDO2025_INO/ITE/GCL08/OW416377/moj_kontener/Dockerfile ~/MDO2025_INO/ITE/GCL08/OW416377/sprawozdanie1/
```
![Skopiowanie pliku do katalogu sprawozdanie1](zrzuty_ekranu1/skopiowanie_mojego_dockerfile_do_sprawozdanie1.png)

---


## **Laboratorium 03**

### **Dockerfiles, kontener jako definicja etapu**


---

## **1. Wybór oprogramowania na zajęcia**

### Wybór repozytorium do sklonowania
Wybrałam: https://github.com/devenes/node-js-dummy-test

### Klonowanie repozytorium i przeprowadzenie buildu programu
Sklonowałam repozytorium i przeszłam do katalogu `node-js-dummy-test`
```bash
git clone https://github.com/devenes/node-js-dummy-test
cd node-js-dummy-test/
```
![Sklonowanie repozytorium](zrzuty_ekranu_lab3/sklonowanie_repo_poza_kontenerem.png)

Nastepnie doinstalowałam wymagane zależności.

```bash
sudo dnf install nodejs
sudo npm install
```
![Instalacja nodejs](zrzuty_ekranu_lab3/instalacja_nodejs_poza_kontenerem.png)

![Instalacja npm](zrzuty_ekranu_lab3/instalacja_npm_poza_kontenerem.png)

![Wersja nodejs i npm](zrzuty_ekranu_lab3/wersje_node_npm_poza_kontenerem.png)

### Uruchomienie testów jednostkowych
Uruchomiłam testy jednostkowe:

```bash
npm test
```
![Wynik testu](zrzuty_ekranu_lab3/uruchomienie_testow_poza_kontenerem.png)


## **2. Przeprowadzenie buildu w kontenerze**

### **2.1. Wykonanie build i test wewnątrz kontenera**

### Uruchomienie kontenera w trybie interaktywnym
Wybrałam obraz `Node.js 22.14.0`, ponieważ aplikacja napisana jest w Node.js i wymaga `npm` do instalacji zależności oraz uruchomienia testów.

```bash
sudo docker run -it --rm node:22.14.0 bash
```
![Uruchomienie kontenera w trybie interaktywnym](zrzuty_ekranu_lab3/uruchomienie_konteneru_interaktywnie.png)

### Sklonowanie repozytorium
Sklonowałam repozytorium w kontenerze i przeszłam do katalogu `node-js-dummy-test`
```bash
git clone https://github.com/devenes/node-js-dummy-test
cd node-js-dummy-test/
```
![Sklonowanie repozytorium w kontenerze](zrzuty_ekranu_lab3/sklonowanie_repo_w_kontenerze.png)

### Skonfigurowanie środowiska oraz uruchomienie build
W projekcie nie ma osobnego kroku "build", ale konieczna jest instalacja zależności.

```bash
npm install
```
Powyższe polecenie pobrało i zainstalowało wszystkie wymagane biblioteki.
![Instalacja npm w kontenerze](zrzuty_ekranu_lab3/zainstalowanie_zaleznosci_w_kontenerze.png) 

### Uruchomienie testów
Testy uruchomiłam za pomocą:
```bash
npm test
```
![Uruchomienie testów w kontenerze](zrzuty_ekranu_lab3/testy_w_kontenerze.png)

Wynik testu potwierdza poprawność działania aplikacji.

### **2.2. Stworzenie dwóch plików Dockerfile**
Utworzone pliki mają za zadanie zautomatyzować wyżej wymienione kroki.

### Utworzenie pliku `Dockerfile.build`
Plik `Dockerfile.build` ma za zadanie przeprowadzać wszystkie kroki aż do builda - przygotować środowisko, 
pobrać kod źródłowy, zainstalować zależności i przeprowadzić build aplikacji.

```bash
FROM node:22.14.0
RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test
RUN npm install
```
### Budowanie kontenera buildowego

```bash
sudo docker build -t bld -f ./Dockerfile.build .
```
![Budowanie kontenera](zrzuty_ekranu_lab3/budowanie_kontenera_buildowego.png)


### Utworzenie pliku `Dockerfile.test`
Plik `Dockerfile.test` bazuje na obrazie `Dockerfile.build` i odpowiada za uruchomienie testów.

```bash
FROM bld
RUN npm test
```

### Budowanie kontenera testowego

```bash
docker build -t test -f ./Dockerfile.test .
```
![Budowanie kontenera](zrzuty_ekranu_lab3/budowanie_kontenera_testowego.png)

### **2.3. Wykazanie poprawnego działania kontenera**

### Pokazanie poprawnego zbudowania obrazów - wyświetlenie listy dostępnych obrazów

```bash
sudo docker images
```
![Zbudowane obrazy](zrzuty_ekranu_lab3/pokazanie_zbudowanych_obrazów.png)

### **Sprawdzenie działania kontenerów:**

### Kontener budujący
Do wykazania poprawnej instalacji zależności w kontenerze uruchomiłam go w trybie interaktywnym oraz sprawdziłam, czy katalog `node_modules` został uwtworzony.

```bash
sudo docker run -it --rm bld bash
ls -l node_modules
```

![Interaktywne uruchomienie kontenera](zrzuty_ekranu_lab3/interaktywne_uruchomienie_builda.png)

### Kontener testowy
Do zweryfikowania poprawności działania testów w kontenerze, uruchomiłam kontener testowy w trybie interaktywnym i ręcznie wykonałam testy.

```bash
sudo docker run -it --rm test bash
npm test
```
![Uruchomienie kontenera testowego interaktywnie](zrzuty_ekranu_lab3/interaktywne_uruchomienie_kontenera_test.png)


### Kontener a obraz
Obraz `app-build` przechowuje kod źródłowy i skompilowaną aplikację, natomiast kontener `app-build` uruchomiony na bazie tego obrazu
wykonuje build.
Obraz `app-test` dziedziczy wszystko od `app-build`, ale dodaje krok uruchomienia testów, natomiast kontener `app-test` wykonuje testy i kończy pracę.


---


## **Laboratorium 04**

### **Dodatkowa terminologia w konteneryzacji, instancja Jenkins**


---

## **1. Zachowywanie stanu**

### 1.1 Utworzenie woluminu wejściowego i wyjściowego kolejno o nazwach `wejsciowy` i `wyjsciowy`

```bash
sudo docker volume create wejsciowy
```
![Utworzenie woluminu wejsciowego](zrzuty_ekranu_lab4/utworzenie_woluminu_wejsciowego.png)

```bash
sudo docker volume create wyjsciowy
```

![Utworzenie woluminu wyjsciowego](zrzuty_ekranu_lab4/utworzenie_woluminu_wyjsciowego.png)

Wyświetlenie utworzonych woluminów.
![Woluminy](zrzuty_ekranu_lab4/pokazanie_utworzonych_woluminow.png)

### 1.2 Utworzenie konteneru bazowego `kontenerlab4` oraz podłączenie do niego woluminów
Wykorzystałam obraz node w wersji slim, ponieważ ma zależności potrzebne do budowy projektu i nie ma zainstalowanego gita.

```bash
sudo docker run -it -v wejsciowy:/input -v wyjsciowy:/output --name kontenerlab4 node:slim /bin/bash
```
![Utworzenie kontenerlab4](zrzuty_ekranu_lab4/utworzenie_kontenerlab4_podpiecie_woluminow.png)

Dodatkowo sprawdziłam wersję `node`, `npm` i `git`, aby upewnić się czy napewno posiada potrzebne zależności i nie ma gita.

```bash
node -v
npm -v
git -v
```
![Sprawdzenie wersji](zrzuty_ekranu_lab4/wersja_node_npm_git.png)

### 1.3 Sklonowanie repozytorium na wolumin wejściowy
Aby sklonować repozytorium na wolumin wejściowy, najpierw sprawdziłam jego lokalizację na hoście za pomocą polecenia:

```bash
sudo docker volume inspect wejsciowy
```
![Ścieżka do woluminu wejściowego](zrzuty_ekranu_lab4/sciezka_do_woluminu_wejsciowego.png)

Następnie aby uzyskać dostęp i przejść do katalogu woluminu, musiałam przełączyć się na użytkownika root przy pomocy
```bash
sudo su
cd /var/lib/docker/volumes/wejsciowy/_data
```
ponieważ `cd` nie działa w połączeniu z `sudo` i polecenie `sudo cd /ścieżka` nie zmieni katalogu w aktualnej sesji. 
![Przejście do katalogu](zrzuty_ekranu_lab4/uprawnienia_admin_przejscie_do_katalogu_woluminu_wejsciowego.png)

Po przejściu do odpowiedniego folderu i użyłam:
```bash
git clone
```
aby sklonować repozytorium bezpośrednio do woluminu.

![Sklonowanie repo](zrzuty_ekranu_lab4/sklonowanie_repo_wolumin_wejsciowy.png)

### 1.4 Uruchomienie buildu w kontenerze
W projekcie nie ma osobnego kroku "build", ale konieczna jest instalacja zależności.
Dlatego po przejściu do katalogu z repozytorium instaluję wymagane biblioteki.

```bash
cd input
cd node-js-dummy-test
npm install
```
![Instalacja zależności](zrzuty_ekranu_lab4/instalacja_zaleznosci_jako_build.png)

### 1.5 Zapisanie plików na woluminie wyjściowym
Dzięki skopiowaniu zawartości woluminu wejściowego na wyjściowy, wynik będzie dostępny poza kontenerem.

```bash
cp -r /input/ /output
```
![Zapisanie na wolumin wyjsciowy](zrzuty_ekranu_lab4/zapisanie_na_wolumin_wyjsciowy.png)

Weryfikacja zawartości woluminów z poziomu hosta.
Dla woluminu wejściowego:
```bash
ls -l /var/lib/docker/volumes/wejsciowy/_data
```
![Zawartość woluminu wejsciowego](zrzuty_ekranu_lab4/wejsciowy_weryfikacja_zawartosci.png)

Dla woluminu wyjściowego:
```bash
ls -l /var/lib/docker/volumes/wyjsciowy/_data
```
![zawartość woluminu wyjściowego](zrzuty_ekranu_lab4/wyjsciowy_weryfikacja_zawartosci.png)

### 1.6 Klonowanie na wolumin wejściowy wewnątrz kontenera
Aby sklonować repozytorium na wolumin wejściowy z poziomu kontenera, potrzebny jest zainstalowany `git` wewnątrz kontenera.
Obraz node:slim nie zaweira domyślnie `git`, dlatego musiałabym go wcześniej zainstalować za pomocą:
```bash
sudo apt update && apt install git
```
Kroki wykonania byłyby niemal identyczne jak wcześniej, z taką różnicą, że zamiast wykonywać polecenie `git clone` z poziomu hosta (w osobnym terminalu, po przejściu do katalogu `/var/lib/docker/volumes/wejsciowy/_data`), wykonywałabym je bezpośrednio wewnątrz kontenera `kontenerlab4`, przechodząc do katalogu `/input`.

### 1.7 Dyskusja dotycząca wykonania ww. kroków za pomocą `docker build` i pliku `Dockerfile`
Klonowanie repozytorium i instalacja zależności mogłyby zostać zautomatyzowane z użyciem pliku `Dockerfile`, polecenia `dockerfile build` oraz funkcji `RUN --mount`, która dostępna jest w Docker BuildKit.
Funkcja `RUN --mount` umożliwia tymczasowe montowanie woluminów w czasie budowania obrazu, co pozwala na klonowanie repozytorium, instalację zależności oraz zapisywanie ich do wskazanego katalogu. Zastosowanie jej jest niezbędne, ponieważ w standardowym procesie budowania obrazu Docker nie zapewnia dostępu do woluminów kontenera. 


## **2. Eksponowanie portu**

### 2.1 Uruchomienie serwera iperf wewnątrz kontenera
Na początku pobrałam obraz iperf (iperf3):

```bash
sudo docker pull networkstatic/iperf3
```
![Obraz iperf](zrzuty_ekranu_lab4/eksponowanie_portow/pobranie_obrazu_iperf.png)

Następnie uruchomiłam serwer iperf wewnątrz kontenera:
```bash
sudo docker run --name iperf-serwer -p 5201:5201 networkstatic/iperf3 -s
```
![Uruchomienie serweru](zrzuty_ekranu_lab4/eksponowanie_portow/uruchomienie_kontenera_serwer.png)

### 2.2 Połącznie się poprzez drugi kontener
Aby połączyć się z serwerem za pomocą drugiego kontenera, najpierw sprawdziłam adres kontenera z serwerem:
```bash
sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' iperf-serwer
```
![Sprawdzenie adresu](zrzuty_ekranu_lab4/eksponowanie_portow/sprawdzenie_adresu_konteneru_serwer.png)

Następnie w osobnym terminalu uruchomiłam drugi kontener iperf i nawiązałam połączenie:
```bash
sudo docker run --name iperf-client networkstatic/iperf3 -c 172.17.0.2
```
![Uruchomienie drugiego kontenera](zrzuty_ekranu_lab4/eksponowanie_portow/uruchomienie_drugiego_kontenera.png)

Wynik połączenie w kontenerze z serwerem:
![Wynik polaczenia](zrzuty_ekranu_lab4/eksponowanie_portow/wynik_polaczenia_w_kontenerze_serwer.png)

Wynik połączenia w drugim kontenerze:
![Wynik polaczenia](zrzuty_ekranu_lab4/eksponowanie_portow/wynik_polaczenia_drugi_kontener_client.png)

### 2.3 Wykorzystanie własnej dedykowanej sieci mostkowej zamiast domyślnej
Na początku zatrzymałam i usunęłam utworzone wcześniej kontenery:
```bash
sudo docker stop iperf-client
sudo docker stop iperf-serwer
```
![Zatrzymanie kontenerów](zrzuty_ekranu_lab4/eksponowanie_portow/zatrzymanie_kontenerow.png)

```bash
sudo docker rm iperf-client
sudo docker rm iperf-serwer
```
![Usuniecie kontenerow](zrzuty_ekranu_lab4/eksponowanie_portow/usuniecie_kontenerow.png)

Następnie utworzyłam własną sieć mostkową:
```bash
sudo docker network create --driver bridge moja_siec_mostkowa
```
![Utworznie sieci mostkowej](zrzuty_ekranu_lab4/eksponowanie_portow/utworzenie_mojej_sieci_mostkowej.png)

Ponownie uruchamiam kontener serwerowy i kliencki tylko w `moja_siec_mostkowa`, to umożliwi wykorzystanie nazw kontenerów zamiast adresów IP.

Uruchomienie kontenera serwerowego:
```bash
sudo docker run --rm -it --name iperf-serwer --network moja_siec_mostkowa networkstatic/iperf3 -s
```
![Uruchomienie serwerowego](zrzuty_ekranu_lab4/eksponowanie_portow/uruchomienie_serwera_w_mojejsiecimostkowej.png)

Uruchomienie kontenera klienta w osobnym terminalu:
```bash
sudo docker run --rm --name iperf-client --network moja_siec_mostkowa networkstatic/iperf3 -c iperf-serwer
```
![Uruchomienie klienta](zrzuty_ekranu_lab4/eksponowanie_portow/uruchomienie_klienta_w_mojejsiecimostkowej.png)

### 2.4 Łącznie się spoza kontenera (z hosta i spoza hosta)
* Połączenie się z hosta:

Najpierw uruchomiłam kontener serwerowy z flagą -p, aby wyeksponować port i możliwe było nawiązanie połączenia.

```bash
sudo docker run --name iperf-serwer -p 5201:5201 networkstatic/iperf3 -s
```
![Uruchomienie serwerowego poza](zrzuty_ekranu_lab4/eksponowanie_portow/utworzenie_serwerowego_poza.png)

Następnie otworzyłam nowy terminal i zainstalowałam iperf3 na hoście:
```bash
sudo dnf install iperf3
```
![Instalacja iperf3](zrzuty_ekranu_lab4/eksponowanie_portow/instalacja_iperf3_fedora.png)

 i nawiązałam połączenie serwera z hostem:

```bash
iperf3 -c localhost -p 5201
```
![Nawiązanie połaczenia](zrzuty_ekranu_lab4/eksponowanie_portow/nawiazanie_polaczenia_z_hostem.png)

* Połączenie się spoza hosta:

Do łączenia spoza hosta wykorzystałam komputer, na którym działa maszyna wirtualna.
Zainstalowałam na komputerze w odpowiednim katalogu serwer iperf3 oraz aby upewnić się, że został zainstalowany sprawdziłam jego wersję.
![Instalacja iperf3](zrzuty_ekranu_lab4/eksponowanie_portow/zainstalowanie_iperf3_na_komputerze.png)
![Sprawdzenie wersji iperf3](zrzuty_ekranu_lab4/eksponowanie_portow/weryfikacja_instalacji_iperf3_na_komputerze.png)

Następnie sprawdziłam adres IP maszyny za pomocą:
```bash
ip a
```
![Sprawdzenie adresu IP maszyny](zrzuty_ekranu_lab4/eksponowanie_portow/sprawdzenie_adresu_ip_maszyny.png)

i nawiązałam połączenie:

```bash
iperf3 -c 192.168.18.97 -p 5201
```
Wynik nawiązania połaczenia spoza hosta - komputer:
![Nawiazanie polaczenia spoza hosta komputer](zrzuty_ekranu_lab4/eksponowanie_portow/nawiazanie_polaczenia_spoza_hosta_komputer.png)

Wynik nazwiązania połączenia spoza hosta - kontener serwerowy:
![Nawizanie polaczenia spoza hosta serwer](zrzuty_ekranu_lab4/eksponowanie_portow/nawiazanie_polaczenia_spoza_hosta_serwer.png)

### 2.5 Przedstawienie przepustowości komunikacji lub problemu z jej zmierzeniem (log z kontenera)
Utworzyłam wolumin `logi`, w którym zapisany zostanie log działania serwera.
```bash
sudo docker volume create logi
```
![Utworzenie woluminu](zrzuty_ekranu_lab4/eksponowanie_portow/utworzenie_woluminu_na_logi.png)

Następnie uruchomiłam kontener serwera i podłączyłam do niego utworzony wolumin `logi`, a także wskazałam miejsce, w którym serwer ma zapisywać logi ze swojego działania.

```bash
sudo docker run --rm -it --name iperf-server -p 5201:5201 -v logi:/logs networkstatic/iperf3 -s --logfile /logs/iperf-serwer.log
```
![Uruchomienie kontenera serwerowego](zrzuty_ekranu_lab4/eksponowanie_portow/uruchomienie_kontenera_serwerowego_z_woluminem_logi.png)

Następnie nawiązałam połączenie z serwerem spoza hosta, aby zaprezentować przepustowość komunikacji:
```bash
iperf3 -c 192.168.18.97 -p 5201
```
Wynik na komputerze:
![Nawiazanie polaczenia spoza hosta komputer](zrzuty_ekranu_lab4/eksponowanie_portow/nawiazanie_polaczenia_spoza_hosta_komputer_v2.png)

Logi zapisane są w pliku, który możemy otworzyć za pomocą:
```bash
sudo nano /var/lib/docker/volumes/logi/_data/iperf-serwer.log
```
![Otworzenie pliku z logami](zrzuty_ekranu_lab4/eksponowanie_portow/otworzenie_pliku_z_logami.png)
![Plik z logami zawartość](zrzuty_ekranu_lab4/eksponowanie_portow/plik_z_logami.png)

## **3. Instancja Jenkins**

### 3.1 Instalacja skonteneryzowanej instancji Jenkinsa z pomocnikiem DIND
Na początku pobrałam obraz dind:
```bash
sudo docker pull docker:dind
```
![Pobranie obrazu dind](zrzuty_ekranu_lab4/jenkins/pobranie_obrazu_dind.png)

Następnie utworzyłam sieć dla Jenkinsa:
```bash
sudo docker network create jenkins
```
![Utworzenie sieci](zrzuty_ekranu_lab4/jenkins/utworzenie_sieci_jenkins.png)

Uruchomiłam instancję Jenkinsa z pomocnikiem DIND:
```bash
sudo docker run \
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
![Uruchomienie instancji Jenkins](zrzuty_ekranu_lab4/jenkins/uruchomienie_jenkins_z_dind.png)

Kontener uruchomił się prawidłowo:
```bash
sudo docker ps
```
![Potwierdzenie uruchomienie kontenera](zrzuty_ekranu_lab4/jenkins/potwierdzenie_uruchomienia_jenkinsa.png)

Następnie przygotowałam Dockerfile [Dockerfile.jenkins](lab4_pliki/Dockerfile.jenkins).
Utworzyłam katalog lab4_pliki, a w nim plik `Dockerfile.jenkins`.

![Terminal utworzenie katalogu i pliku](zrzuty_ekranu_lab4/jenkins/tworzenie_katalogu_i_pliku.png)

```bash
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
Następnie zbudowałam obraz:
```bash
sudo docker build -t myjenkins-blueocean:2.492.2-1 --file Dockerfile.jenkins .
```
![Zbudowanie obrazu Jenkins](zrzuty_ekranu_lab4/jenkins/zbudowanie_obrazu_jenkins.png)

Uruchomiłam kontener na podstawie obrazu:
```bash
sudo docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.492.2-1
```
![Uruchomienie kontenera na podstawie obrazu](zrzuty_ekranu_lab4/jenkins/uruchomienie_kontenera_na_podstawie_obrazu.png)

Sprawdziłam stan kontenerów:
```bash
sudo docker ps -a
```
![Sprawdzenie stanu kontenerów](zrzuty_ekranu_lab4/jenkins/sprawdzenie_stanu_uruchomionych_kontenerow.png)

### 3.2 Uruchomienie Jenkinsa w przeglądarce
Aby uruchomić Jenkinsa w przeglądarce weszłam na adres maszyny:
```bash
http://192.168.18.97:8080
```
![Uruchomienie Jenkinsa w przegladarce](zrzuty_ekranu_lab4/jenkins/uruchomienie_jenkinsa_w_przegladarce.png)

Następnie przeszłam do konsoli jenkins-docker:
```bash
sudo docker exec -it jenkins-docker /bin/sh
```
![Uruchomienie konsoli dind](zrzuty_ekranu_lab4/jenkins/uruchomienie_konsoli_dind.png)

Po uruchomieniu konsoli, za pomocą:
```bash 
cat /var/jenkins_home/secrets/initialAdminPassword
```
wyświetliłam hasło:

![Wyświetlenie hasła](zrzuty_ekranu_lab4/jenkins/wyswietlenie_hasla_jenkins.png)

Po wpisaniu hasła administratora w przeglądarce przeszłam do strony Jenkinsa, pominęłam dostosowywanie Jenkinsa i kontynuowałam jako admin.

Ekran logowania:
![Ekran logowania](zrzuty_ekranu_lab4/jenkins/ekran_logowania.png)

Ekran po zalogowaniu:
![Ekran konta](zrzuty_ekranu_lab4/jenkins/konto_jenkins.png)
