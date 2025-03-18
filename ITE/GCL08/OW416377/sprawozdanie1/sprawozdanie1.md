# Sprawozdanie 1


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
![Lokalizacja pliku wykonywalnego Gita](zrzut2.png)

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

(te screeny tez mam ale pod inna nazwa i do przyciecia)
![Przełączenie na gałęź main i gałęź grupy](zrzuty_ekranu1/zrzut7.png)

### Utworzenie nowej gałęzi
Następnie uwtorzyłam swoją gałąź o nazwie składającej się z moich inicjałów i numeru indeksu

![Tworzenie mojej gałęzi](zrzuty_ekranu1/zrzut8.png)

## **4. Praca na nowej gałęzi**

### Utworzenie nowego katalogu
Utworzyłam katalog, także o nazwie składającej się z moich inicjałów i numeru indeksu:

![Tworzenie mojego katalogu](zrzuty_ekranu/zrzut9.png)

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


## **2. Rejestracja w Docker Hub **
Zarejestrowałam się w Docker Hub poprzez konto na Githubie, a następnie zalogowałam się w terminalu.

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
![Instalacja nodejs](zrzuty_ekarny_lab3/instalacja_nodejs_poza_kontenerem.png)

![Instalacja npm](zrzuty_ekranu_lab3/instalacja_npm_poza_kontenerem.png)

![Wersja nodejs i npm](zrzuty_ekranu_lab3/wersje_node_npm_poza_kontenerem.png)

### Uruchomienie testów jednostkowych
Uruchomiłam testy jednostkowe:

```bash
npm test
```
![Wynik testu](zrzuty_ekranu_lab3/uruchomienie_testow_poza_kontenerem.png)


## **2. Przeprowadzenie buildu w kontenerze **

### **2.1. Wykonanie build i test wewnątrz kontenera **

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

### **2.2. Stworzenie dwóch plików Dockerfile - **
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

### **2.3. Wykazanie poprawnego działania kontenera **

### Pokazanie poprawnego zbudowania obrazów - wyświetlenie listy dostępnych obrazów

```bash
sudo docker images
```
![Zbudowane obrazy](zrzuty_ekranu_lab3/pokazanie_zbudowanych_obrazów.png)

### **Sprawdzenie działania kontenerów**

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
![Uruchomienie kontenera testowego interaktywnie](zrzuty_ekranu_lab3/interaktywne_uruchomienie_kontenera_testowego.png)


### Kontener a obraz
Obraz `app-build` przechowuje kod źródłowy i skompilowaną aplikację, natomiast kontener `app-build` uruchomiony na bazie tego obrazu
wykonuje build.
Obraz `app-test` dziedziczy wszystko od `app-build`, ale dodaje krok uruchomienia testów, natomiast kontener `app-test` wykonuje testy i kończy pracę.