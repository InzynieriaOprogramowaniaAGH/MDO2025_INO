# Sprawozdanie 1
#### Tomasz Oszczypko

## Zajęcia 01
Celem laboratorium było skonfigurowanie usługi SSH umożliwiającej połączenie z GitHubem oraz zapoznanie się i przygotowanie własnej gałęzi w repozytorium git.

### DLACZEGO NA ZRZUTACH EKRANU WIDOCZNY JEST LOCALHOST?

Podczas instalacji systemu maszyna domyślnie przyjęła nazwę localhost.localdomain, co widoczne jest na poniższym zrzucie.

![uname -a](001-Class/ss/0.png)

### 1. Instalacja klienta git i obsługi kluczy SSH

Instalacja została przeprowadzona przy użyciu menadżera paczek dnf:
```bash
sudo dnf install git
```

Instalacja klienta oraz serwera SSH nie była konieczna, gdyż Fedora Server domyślnie ma zainstalowany OpenSSH.

W celu weryfikacji poprawnej instalacji gita sprawdzono jego wersję:
```bash
git --version
```

![Sprawdzenie wersji git](001-Class/ss/1.png)

### 2. Sklonowanie repozytorium przedmiotowego za pomocą HTTP

Ponieważ repozytorium jest publiczne, klonowanie mogło się odbyć poprzez HTTP bez konieczności tworzenia <i>personal access token</i>:

![Klonowanie repozytorium przez HTTP](001-Class/ss/2.png)

### 3. Konfiguracja klucza SSH, klonowanie repozytorium przez SSH

Wygenerowane zostały 2 klucze SSH - jeden z hasłem, drugi bez hasła.

- klucz zabezpieczony hasłem:
![Generowanie klucza z hasłem](001-Class/ss/3.png)

- klucz bez hasła:
![Generowanie klucza bez hasła](001-Class/ss/4.png)

Klucz prywatny zabezpieczony hasłem został dodany do agenta SSH:

![Dodanie klucza do agenta ssh](001-Class/ss/5.png)

Zawartość publicznego klucza zabezpieczonego hasłem została odczytana przy użyciu polecenia <i>cat</i>:
```bash
cat ~/.ssh/password.pub
```

Na koncie GitHub został dodany nowy klucz SSH przy użyciu uprzednio odczytanego klucza publicznego:

![Dodanie klucza na GitHubie](001-Class/ss/6.png)

Pobrane repozytorium zostało usunięte, a następnie ponownie sklonowane - tym razem z wykorzystaniem protokołu SSH:

![Klonowanie repozytorium przez SSH](001-Class/ss/8.png)

Na koncie na GitHubie został skonfigurowany Two-Factor Authentication (2FA). Jako metodę autentykacji wybrano aplikację uwierzytelniającą (Authenticator od firmy Microsoft):

![2FA](001-Class/ss/7.png)

### 4. Zmiana gałęzi

Przełączono gałąż na main, a następnie na gałąź grupy - GCL06:

![Zmiana gałęzi](001-Class/ss/9.png)

### 5. Utworzenie własnej gałęzi

Od brancha grupy została utworzona własna gałąź o nazwie "inicjały & nr indeksu":

![Utworzenie własnej gałęzi](001-Class/ss/9-i-pol.png)

### 6. Praca na nowej gałęzi

W katalogu grupy został utworzony własny katalog o nazwie takiej samej, jak nazwa gałęzi:

![Utworzenie katalogu](001-Class/ss/9-i-75.png)

Następnie został napisany git hook weryfikujący, czy każdy commit message zaczyna się od "inicjały & nr indeksu". Plik został zapisany jako commit-msg:

```bash
#!/bin/sh

# This hook checks if commit message starts with proper prefix,
# which is my initials and index number.

COMMIT_MESSAGE_FILE=$1
COMMIT_MESSAGE=$(head -n1 "$COMMIT_MESSAGE_FILE")

PREFIX="TO417248"

if ! echo "$COMMIT_MESSAGE" | grep -q "^$PREFIX"; then
    echo "Error: Commit message must start with '$PREFIX'"
    exit 1
fi

exit 0
```

Plikowi ustawiono możliwość wykonywania:

![Zmiana uprawnień do pliku](001-Class/ss/10-i-pol.png)

Plik następnie został przeniesiony z katalogu GCL06 do własnego katalogu oraz skopiowany do katalogu .git/hooks w celu instalacji:

![Przeniesienie git hooka do własnego katalogu](001-Class/ss/12.png)

Wszelnie wprowadzone zmiany należało wysłać do zdalnego źródła. Przed tym jednak powinien zostać skonfigurowany git tak, aby autor commita na githubie był widoczny jako poprawny użytkownik. W moim przypadku krok ten został niestety wykonany po commicie, przez co w historii commitów jest widoczny inny, niepowiązany ze mną użytkownik: 

![Konfiguracja użytkownika git](001-Class/ss/13.png)

Zmiany zcommitowano w lokalnym repozytorium:

![Git Commit](001-Class/ss/14.png)

Finalnie wprowadzone zmiany zostały wysłane do zdalnego źródła:

![Git Push](001-Class/ss/15.png)



## Zajęcia 02

Celem laboratorium było przygotowanie środowiska umożliwiającego konteneryzację aplikacji przy użyciu Dockera.

### 1. Instalacja Dockera w systemie linuksowym

Instalacja odbyła się przy użyciu menadżera paczek dnf:
```bash
sudo dnf install docker
```

W celu weryfikacji poprawności instalacji sprawdzono wersję Dockera:

![Sprawdzenie wersji Dockera](002-Class/ss/1.png)

Otrzymany komunikat oznacza, że nie jest aktywny demon Dockera, dlatego też został aktywowany oraz uruchomiony:
```bash
sudo systemctl enable docker
sudo systemctl start docker
```

Po aktywacji sprawdzono, czy demon działa:

![Aktywacja demona Dockera](002-Class/ss/2.png)

### 2. Rejestracja w Docker Hub

Utworzone zostało konto na stronie [Docker Hub](https://hub.docker.com):

![](002-Class/ss/docker-profile.png)

### 3. Pobieranie obrazów Dockera

W następnym kroku zostały pobrane obrazy - `hello-world`, `busy-box`, `ubuntu` oraz `mysql`:

![Pobieranie obrazów Dockera](002-Class/ss/3.png)

### 4. Uruchomienie kontenera z obrazu `busybox`

Kontener uruchomiono wraz z automatycznym usuwaniem po zakończeniu działania przy użyciu poniższego polecenia:
```bash
sudo docker run --rm busybox
```

Kontener ten jednak uruchomił się i automatycznie zamknął, gdyż nie miał zadań do wykonania, co przedstawia poniższy zrzut ekranu z listą uruchomionych kontenerów:

![Uruchomienie kontenera obrazu busybox](002-Class/ss/4.png)

Aby kontener nie zakończył działania od razu, należało uruchomić go w trybie interaktywnym. Wersja kontenera obrazu dostępna jest przy wywołaniu `--help` dla dowolnego uniksowego polecenia:

![Uruchomienie kontenera obrazu busybox w trybie interaktywnym](002-Class/ss/5.png)

Ciąg znaków `2>&1` przy sprawdzeniu wersji oznacza przekazanie strumienia `stderr` do `stdout`.

### 5. Uruchomienie "systemu w kontenerze"

Wybranym obrazem systemu był ubuntu, dlatego też kontener z tym systemem został uruchomiony, a wewnątrz niego zostały sprawdzony proces z `PID 1`. Jak widać, jest to bash:

![Proces o PID 1 w kontenerze ubuntu](002-Class/ss/6.png)

Na hoście w kolejnym terminalu sprawdzono również procesy dockera przy użyciu poniższego polecenia:
```bash
ps aux | grep docker
```

![Procesy dockera na hoście](002-Class/ss/7.png)

Ostatnim zadaniem w tym kroku było zaktualizowanie pakietów w kontenerze: 

![Aktualizacja pakietów w kontenerze ubuntu](002-Class/ss/8.png)

Po zaktualizowaniu pakietów opuszczono kontener:

![Wyjście z kontenera](002-Class/ss/exit.png)

### 6. Utworzenie własnego Dockerfile'a

Obraz tworzony przy użyciu Dockerfile'a bazuje na Alpine Linux, dzięki czemu będzie bardzo lekki. Obraz ma posiadać zainstalowanego gita oraz sklonowane repozytorium przedmiotu:
```Dockerfile
FROM alpine:latest

RUN apk add --no-cache git

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["/bin/sh"]
```

Następnie obraz został zbudowany. Jako własną nazwę obrazu ustawiono `apline-image`:

![Budowa obrazu na podstawie Dockerfile](002-Class/ss/9.png)

Po zbudowaniu obrazu został uruchomiony kontener bazujący na nim, a następnie wewnątrz zweryfikowano, czy jest zainstalowany git oraz czy zostało ściągnięte repozytorium:

![Weryfikacja instalacji gita oraz sklonowania repozytorium](002-Class/ss/11.png)

W nowym terminalu na hoście sprawdzono uruchomione kontenery:

![Sprawdzenie uruchomionych kontenerów](002-Class/ss/12.png)

W ostatnim kroku wyczyszczono wszystkie zatrzymane kontenery, a następnie obrazy przy użyciu poleceń:
```bash
sudo docker container prune
sudo docker rmi -f $(sudo docker images -aq)
```

![Czyszczenie kontenerów i obrazów](002-Class/ss/13.png)

Plik Dockerfile umieszczony został w katalogu `002-Class` wewnątrz katalogu `Sprawozdanie1` dla lepszej organizacji plików.



## Zajęcia 03

Celem laboratorium było przygotowanie plików Dockerfile tworzących wersje testową oraz produkcyjną obrazów z dowolnym otwartoźródłowym projektem.

### 1. Wybór oprogramowania

Wybrane przeze mnie oprogramowanie to `toasty` - otwartoźródłowy framework do pisania testów jednostkowych w C mojego autorstwa. Projekt zawiera plik `Makefile` z dwoma targetami - domyślnym do kompilacji jako biblioteki statycznej oraz `test` do kompilacji i uruchomienia wewnętrznych testów jednostkowych.

Repozytorium zostało sklonowane:

![Klonowanie repozytorium](003-Class/ss/1.png)

Maszyna nie ma wymaganych zależności, dlatego też zostały doinstalowane przy użyciu poniższego polecenia:
```bash
sudo dnf install gcc make
```

Następnie został przeprowadzony build oraz uruchomienie testów:

![Build projektu](003-Class/ss/2.png)

![Budowa i uruchomienia testów](003-Class/ss/3.png)

### 2. Przeprowadzenie buildu w kontenerze

W pierwszym kroku został pobrany obraz ubuntu przy użyciu poniższego polecenia:
```bash
docker pull ubuntu
```

Następnie uruchomiono kontener w trybie interaktywnym:

![Uruchomienie kontenera ubuntu](003-Class/ss/4.png)

W kontenerze zostały zainstalowane wymagane zależności:

![Instalacja zależności](003-Class/ss/5.png)

Po krótkiej chwili możliwe było sklonowanie repozytorium projektu:

![Klonowanie repozytorium](003-Class/ss/6.png)

Następnie zmieniono katalog na katalog projektu oraz zbudowano go:

![Budowa projektu](003-Class/ss/7.png)

Po skończonej budowie możliwe było skompilowanie i uruchomienie testów, które zakończyły się powodzeniem:

![Budowa i uruchomienie testów](003-Class/ss/8.png)

W kolejnym kroku zostały przygotowane dwa pliki Dockerfile automatyzujące powyższe kroki:
- `Dockerfile` - build:
```Dockerfile
FROM ubuntu:latest

RUN apt update && apt install -y git gcc make

RUN git clone https://github.com/badzianga/toasty.git

WORKDIR /toasty

RUN make
```

- `Dockerfile.test` - testy:
```Dockerfile
FROM toasty

RUN make test 
```

Pliki te początkowo zostały umieszczone w katalogu domowym. W pierwszej kolejności zbudowano obraz builda:

![Budowanie obrazu builda](003-Class/ss/9.png)

Następnie zbudowano obraz testów:

![Budowanie obrazu testów](003-Class/ss/10.png)

W ostatnim kroku uruchomiono kontener oparty na obrazie testów. Jak widać na poniższym zrzucie, wraz z uruchomieniem kontenera automatycznie uruchamiany jest target testów, który działa poprawnie:

![Uruchomienie kontenera z testami](003-Class/ss/11.png)

### 3. Kompozycja przy użyciu `docker-compose`

W pierwsze kolejności został pobrany `docker-compose`, gdyż nie był dostępny na maszynie:

![Instalacja docker-compose](003-Class/ss/12.png)

Następnie został utworzony plik `docker-compose.yml` w tym samym katalogu, co pliki Dockerfile. Jego treść wygląda następująco:
```yaml
services:
  toasty:
    build:
      context: .
      dockerfile: Dockerfile
    image: toasty
    container_name: toasty

  toasty-test:
    build:
      context: .
      dockerfile: Dockerfile.test
    depends_on:
      - toasty
    image: toasty-test
    container_name: toasty-test
```

Finalnie możliwe jest zbudowanie i uruchomienie kontenera z testami przy użyciu przygotowanego pliku:

![Uruchomienie kontenera z testami](003-Class/ss/13.png)



## Zajęcia 04

### 1. Zachowywanie stanu

W pierwszej kolejności przygotowane zostały dwa woluminy - wejściowy i wyjściowy o nazwach `input-volume` oraz `output-volume`:

![Utworzenie woluminów](004-Class/ss/1.png)

Czyste repozytorium przedmiotu zostało ponownie sklonowane - do folderu `repo`:

![Sklonowanie repozytorium](004-Class/ss/2.png)

W celu skopiowania sklonowanego repozytorium na wolumin wejściowy z hosta przygotowany został kontener oparty o `hello-world` z podpiętym woluminem `input-volume`. Kontener ten nie był i nie musi być nigdy uruchamiany - służy on tylko do interakcji z woluminem wejściowym poprzez `docker cp`, stąd nadana mu nazwa `input-interface`. Takie rozwiązanie pozwala na oszczędzenie zasobów - obraz `hello-world` jest bardzo lekki, waży tylko nieco ponad 10kB. 

![Skopiowanie repozytorium na wolumin wejściowy](004-Class/ss/3.png)
