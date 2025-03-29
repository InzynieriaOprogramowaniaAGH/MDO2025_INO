# Zajęcia 01

## Wprowadzenie, Git, Gałęzie, SSH

1. Zainstaluj klienta Git i obsługę kluczy SSH

```bash
sudo dnf install git
sudo dnf install openssh-clients openssh-server
```

2. Sklonuj [repozytorium przedmiotowe](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO) za pomocą HTTPS i [_personal access token_](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

3. Upewnij się w kwestii dostępu do repozytorium jako uczestnik i sklonuj je za pomocą utworzonego klucza SSH, zapoznaj się [dokumentacją](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
   - Utwórz dwa klucze SSH, inne niż RSA, w tym co najmniej jeden zabezpieczony hasłem
   - Skonfiguruj klucz SSH jako metodę dostępu do GitHuba
   - Sklonuj repozytorium z wykorzystaniem protokołu SSH

Generowanie pary kluczy (prywatnego i publicznego):
![Ssh klucze](..Sprawozdanie1Screenshots/shhkey.png)

Klonowanie repozytorium przez ssh:
![Ssh klonowanie](..Sprawozdanie1Screenshots/sshclone.png)

4. Przełącz się na gałąź `main`, a potem na gałąź swojej grupy (pilnuj gałęzi i katalogu!)

![Main](..Sprawozdanie1Screenshots/mainb.png)

5. Utwórz gałąź o nazwie "inicjały & nr indeksu" np. `KD232144`. Miej na uwadze, że odgałęziasz się od brancha grupy!

![Własny branch](..Sprawozdanie1Screenshots/wlasnyb.png)

6. Rozpocznij pracę na nowej gałęzi
   - W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu" np. `KD232144`
   - Napisz [Git hooka](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) - skrypt weryfikujący, że każdy Twój "commit message" zaczyna się od "twoje inicjały & nr indexu". (Przykładowe githook'i są w `.git/hooks`.)
   - Dodaj ten skrypt do stworzonego wcześniej katalogu.
   - Skopiuj go we właściwe miejsce, tak by uruchamiał się za każdym razem kiedy robisz commita.
   - Umieść treść githooka w sprawozdaniu.
   - W katalogu dodaj plik ze sprawozdaniem
   - Dodaj zrzuty ekranu (jako inline)
   - Wyślij zmiany do zdalnego źródła
   - Spróbuj wciągnąć swoją gałąź do gałęzi grupowej
   - Zaktualizuj sprawozdanie i zrzuty o ten krok i wyślij aktualizację do zdalnego źródła (na swojej gałęzi)

Treść Git hooka:

```bash
#!/bin/bash

# Pobierz treść wiadomości commit
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Sprawdź, czy wiadomość zaczyna się od "ML416047"
if ! echo "$COMMIT_MSG" | grep -qE '^ML416047'; then
  echo "Błąd: Wiadomość commit musi zaczynać się od 'ML416047'."
  exit 1
fi

exit 0
```

Git hook w odpowiednim folderze
![Git hook](..Sprawozdanie1Screenshots/hook.png)

Pokazanie git hooka w folderze ML416047 oraz pokazanie że działa
![Test hooka](..Sprawozdanie1Screenshots/testhooka.png)

Próba wciągnięcia swojej gałęzi do gałęzi grupowej:
![Galaz grupowa](..Sprawozdanie1Screenshots/grupowa.png)

---

# Zajęcia 02

## Git, Docker, Zestawienie środowiska

1. Zainstaluj Docker w systemie linuksowym

Instalacja dockera na maszynie wirtualnej

```bash
sudo dnf install docker
```

2. Zarejestruj się w [Docker Hub](https://hub.docker.com/) i zapoznaj z sugerowanymi obrazami

Screen z zalogowanego konta na stronie hub.docker.com
![Rejestracja](..Sprawozdanie1Screenshots/rejestracja.png)

3. Pobierz obrazy `hello-world`, `busybox`, `ubuntu` lub `fedora`, `mysql`

```bash
sudo docker pull hello-world
sudo docker pull busybox
sudo docker pull ubuntu
sudo docker pull mysql
```

4. Uruchom kontener z obrazu `busybox`
   - Pokaż efekt uruchomienia kontenera
   - Podłącz się do kontenera **interaktywnie** i wywołaj numer wersji

```bash
sudo docker run -it busybox
```

![Busybox](..Sprawozdanie1Screenshots/busybox.png)

5. Uruchom "system w kontenerze" (czyli kontener z obrazu `fedora` lub `ubuntu`)
   - Zaprezentuj `PID1` w kontenerze i procesy dockera na hoście
   - Zaktualizuj pakiety
   - Wyjdź

```bash
sudo docker run -it ubuntu
```

![PID 1 w kontenerze](..Sprawozdanie1Screenshots/pid1.png)

![Update pakietow w kontenerze](..Sprawozdanie1Screenshots/updatepakietow.png)

Wyjście poprzez komendę:

```bash
exit
```

6. Stwórz własnoręcznie, zbuduj i uruchom prosty plik `Dockerfile` bazujący na wybranym systemie i sklonuj nasze repo.
   - Kieruj się [dobrymi praktykami](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
   - Upewnij się że obraz będzie miał `git`-a
   - Uruchom w trybie interaktywnym i zweryfikuj że jest tam ściągnięte nasze repozytorium

Zawartość pliku Dockerfile

```bash
FROM alpine:latest
RUN apk add --no-cache git
WORKDIR /folderpracy
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git .
CMD ["git", "--help"]
```

Zbudowanie i uruchomienie własnego kontenera

```bash
sudo docker build -t mydocker .
sudo docker run -it mydocker sh
```

![Budowanie mydocker](..Sprawozdanie1Screenshots/budowaniemydocker.png)
![Pokazanie repozytorium](..Sprawozdanie1Screenshots/wlasnerepo.png)

7. Pokaż uruchomione ( != "działające" ) kontenery, wyczyść je.

Kontenery przed czyszczeniem:

```bash
sudo docker ps -a
```

![Pokazanie kontenerow](..Sprawozdanie1Screenshots/przedczystka.png)

Usuwanie kontenerów:

```bash
sudo docker container prune
```

![Usuwanie kontenerow](..Sprawozdanie1Screenshots/czystka.png)

Kontenery po czyszczeniu:
![Kontenery po czyszczeniu](..Sprawozdanie1Screenshots/poczystce.png)

8. Wyczyść obrazy

Czyszczenie obrazów za pomocą polecenia:

```bash
sudo docker rmi -f $(sudo docker images -aq)
```

![Czyszczenie obrazów za pomocą polecenia:](..Sprawozdanie1Screenshots/czobr.png)

9. Dodaj stworzone pliki `Dockefile` do folderu swojego `Sprawozdanie1` w repozytorium.

Dockerfile w folderze Sprawozdanie:
![Dockerfile w folderze Sprawozdanie](..Sprawozdanie1Screenshots/dfwspr.png)

---

# Zajęcia 03

## Dockerfiles, kontener jako definicja etapu

### Wybór oprogramowania na zajęcia

- Znajdź repozytorium z kodem dowolnego oprogramowania, które:
  - dysponuje otwartą licencją
  - jest umieszczone wraz ze swoimi narzędziami Makefile tak, aby możliwe był uruchomienie w repozytorium czegoś na kształt `make build` oraz `make test`. Środowisko Makefile jest dowolne. Może to być automake, meson, npm, maven, nuget, dotnet, msbuild...
  - Zawiera zdefiniowane i obecne w repozytorium testy, które można uruchomić np. jako jeden z "targetów" Makefile'a. Testy muszą jednoznacznie formułować swój raport końcowy (gdy są obecne, zazwyczaj taka jest praktyka)
- Sklonuj niniejsze repozytorium, przeprowadź build programu (doinstaluj wymagane zależności)
- Uruchom testy jednostkowe dołączone do repozytorium

Repozytorium, które wybrałem to [Simple Dynamic Strings - sds](https://github.com/antirez/sds.git), zawiera ono własne pliki make, które pozwalają na testowanie oprogramowania we własnym środowisku.
Przeprowadzone testy:
![Testy na kontenerze](..Sprawozdanie1Screenshots/testywkontenerze.png)

### Przeprowadzenie buildu w kontenerze

Ponów ww. proces w kontenerze, interaktywnie.

1. Wykonaj kroki `build` i `test` wewnątrz wybranego kontenera bazowego. Tj. wybierz "wystarczający" kontener, np `ubuntu` dla aplikacji C lub `node` dla Node.js
   - uruchom kontener
   - podłącz do niego TTY celem rozpoczęcia interaktywnej pracy
   - zaopatrz kontener w wymagania wstępne (jeżeli proces budowania nie robi tego sam)
   - sklonuj repozytorium
   - Skonfiguruj środowisko i uruchom _build_
   - uruchom testy

Klonowanie repozytorium i wykreowanie wymaganych plików przy pomocy polecenia `make`:
![Klonowanie wewnatrz kontenera](..Sprawozdanie1Screenshots/klonowaniewewnatrzkontenera.png)

Uruchomienie testów:
![Testy2](..Sprawozdanie1Screenshots/testy2.png)

2. Stwórz dwa pliki `Dockerfile` automatyzujące kroki powyżej, z uwzględnieniem następujących kwestii:
   - Kontener pierwszy ma przeprowadzać wszystkie kroki aż do _builda_
   - Kontener drugi ma bazować na pierwszym i wykonywać testy (lecz nie robić _builda_!)

Zawartość dwóch plików Dockerfile:
![Dockerfile x2](..Sprawozdanie1Screenshots/2dockfile.png)

Drugi plik `Dockerfile.test`, bazuje na obrazie zbudowanym z pierwszego pliku, w tym celu pierwsza linijka tego pliku odnosi się do nazwy obrazu `FROM makapaka-sds`.

3. Wykaż, że kontener wdraża się i pracuje poprawnie. Pamiętaj o różnicy między obrazem a kontenerem. Co pracuje w takim kontenerze?

Działający kontener o nazwie `makapaka-sds` wykonuje testy na nowozbudowanym obrazie `makapaka-sds` powstałym na bazie pliku `Dockerfile.test`
![Budowanie obrazu makapaka-sds](..Sprawozdanie1Screenshots/makapaka-build.png)

![Kontener wykonuje testy](..Sprawozdanie1Screenshots/makapaka-sds-testy.png)

Pozorna kolizja nazw tak naprawdę nie występuje, ponieważ docker "usuwa" starego taga/nazwę i nadaje nowemu obrazowi. Stary obraz nadal istnieje, ale nie posiada własnego taga/nazwy i można go wywołać po unikalnym ID.

### Zakres rozszerzony tematu sprawozdania

#### Docker Compose

- Zamiast ręcznie wdrażać kontenery, ujmij je w kompozycję

#### Przygotowanie do wdrożenia (deploy): dyskusje

Otrzymany kontener ze zbudowanym programem może, ale nie musi, być już końcowym artefaktem procesu przygotowania nowego wydania. Jednakże, istnieje szereg okoliczności, w których nie ma to sensu. Na przykład gdy chodzi o oprogramowanie interaktywne, które kiepsko działa w kontenerze.

Przeprowadź dyskusję i wykaż:

- czy program nadaje się do wdrażania i publikowania jako kontener, czy taki sposób interakcji nadaje się tylko do builda
- opisz w jaki sposób miałoby zachodzić przygotowanie finalnego artefaktu
  - jeżeli program miałby być publikowany jako kontener - czy trzeba go oczyszczać z pozostałości po buildzie?
  - A może dedykowany _deploy-and-publish_ byłby oddzielną ścieżką (inne Dockerfiles)?
  - Czy zbudowany program należałoby dystrybuować jako pakiet, np. JAR, DEB, RPM, EGG?
  - W jaki sposób zapewnić taki format? Dodatkowy krok (trzeci kontener)? Jakiś przykład?

---

# Zajęcia 04

## Dodatkowa terminologia w konteneryzacji, instancja Jenkins

### Zachowywanie stanu

- Zapoznaj się z dokumentacją https://docs.docker.com/storage/volumes/
- Przygotuj woluminy wejściowy i wyjściowy, o dowolnych nazwach, i podłącz je do kontenera bazowego, z którego rozpoczynano poprzednio pracę
- Uruchom kontener, zainstaluj niezbędne wymagania wstępne (jeżeli istnieją), ale _bez gita_
- Sklonuj repozytorium na wolumin wejściowy (opisz dokładnie, jak zostało to zrobione)
- Uruchom build w kontenerze - rozważ skopiowanie repozytorium do wewnątrz kontenera
- Zapisz powstałe/zbudowane pliki na woluminie wyjściowym, tak by były dostępne po wyłączniu kontenera.
- Pamiętaj udokumentować wyniki.
- Ponów operację, ale klonowanie na wolumin wejściowy przeprowadź wewnątrz kontenera (użyj gita w kontenerze)
- Przedyskutuj możliwość wykonania ww. kroków za pomocą `docker build` i pliku `Dockerfile`. (podpowiedź: `RUN --mount`)

Tworzenie woluminów:

```bash
sudo docker volume create Wejsciowy
sudo docker volume create Wyjsciowy
```

![Tworzenie woluminów:](..Sprawozdanie1Screenshots/woluminy.png)

Podłączanie woluminu wejściowego do kontenera zbudowanego na obrazie `Dockerfile.lab4`:
![Laczenie wol:](..Sprawozdanie1Screenshots/wolkont.png)

```bash
sudo docker build -t wolumin -f Dockerfile.lab4 .
sudo docker run -it --rm -v Wejsciowy:/entry --name wolumin wolumin
```

Dockerfile.lab4:

```bash
FROM ubuntu:latest
RUN mkdir -p /entry /output
```

Klonowanie plików na wolumin wejściowy:
![Pliki na wol wej:](..Sprawozdanie1Screenshots/wejscie.png)

```bash
sudo docker build -t nogitches -f Dockerfile.lab4 .
sudo docker run -it --rm -v Wejsciowy:/entry -v Wyjsciowy:/output --name nogitussy nogitches
```

Budowanie plików w kontenerze:
![Budowa:](..Sprawozdanie1Screenshots/makewkont.png)

Zbudowane pliki na woluminie wyjściowym:
![Pliki na wol wyj:](..Sprawozdanie1Screenshots/wyjscie.png)

Klonowanie plików na wolumin wejściowy wewnątrz kontenera:
![Klonowanie wewnatrz kont:](..Sprawozdanie1Screenshots/gitclonekont.png)

### Eksponowanie portu

- Zapoznaj się z dokumentacją https://iperf.fr/
- Uruchom wewnątrz kontenera serwer iperf (iperf3)
- Połącz się z nim z drugiego kontenera, zbadaj ruch
- Zapoznaj się z dokumentacją `network create` : https://docs.docker.com/engine/reference/commandline/network_create/
- Ponów ten krok, ale wykorzystaj własną dedykowaną sieć mostkową. Spróbuj użyć rozwiązywania nazw
- Połącz się spoza kontenera (z hosta i spoza hosta)
- Przedstaw przepustowość komunikacji lub problem z jej zmierzeniem (wyciągnij log z kontenera, woluminy mogą pomóc)
- Opcjonalnie: odwołuj się do kontenera serwerowego za pomocą nazw, a nie adresów IP

Instalowanie iperf3

```bash
sudo docker pull networkstatic/iperf3
```

![instalowanie iperf3](..Sprawozdanie1Screenshots/iperfin.png)

Uruchomienie serwera iperf w kontenerze, zapisanie jego adresu IP do zmiennej `$adresip` a następnie połączenie się z drugiego kontenera przy użyciu tej zmiennej:

```bash
sudo docker run -d --name serwer -p 2137:2137 networkstatic/iperf3 -s
adresip=$(sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' serwer)
sudo docker run -it --rm networkstatic/iperf3 -c $adresip
```

![Stawianie serwera](..Sprawozdanie1Screenshots/stawianieserwer.png)
![Polaczenie klienta](..Sprawozdanie1Screenshots/laczenieklient.png)

Stworzenie własnej sieci mostkowej:

```bash
sudo docker network create --driver bridge iperf-net
```

![Stawianie sieci](..Sprawozdanie1Screenshots/network.png)

Połączenie się klienta z serwerem:

```bash
sudo docker run -it --rm --name serwer --network iperf-net klient iperf3 -s &
sudo docker run -it --rm --name trueklient --network iperf-net klient iperf3 -c serwer

```

![Polaczenie klienta z serwerem](..Sprawozdanie1Screenshots/consiec.png)

Stworzenie woluminów, na których będą przechowywane logi:

```bash
sudo docker volume create serwer-vol
sudo docker volume create klient-vol
```

Lista istniejących woluminów:
![Woluminy](..Sprawozdanie1Screenshots/volser.png)

Połączenie między serwerem a klientem z wykorzystaniem logów:

```bash
sudo docker run -d   --name serwer   --network iperf-net   -v serwer-vol:/logs   klient   sh -c "iperf3 -s > /logs/serwer.log 2>&1"
sudo docker run -it   --name trueklient   --network iperf-net   -v klient-vol:/logs   klient   sh -c "iperf3 -c serwer > /logs/trueklient.log 2>&1"
```

![Klonowanie wewnatrz kont:](..Sprawozdanie1Screenshots/serwerklient.png)

### Instancja Jenkins

- Zapoznaj się z dokumentacją https://www.jenkins.io/doc/book/installing/docker/
- Przeprowadź instalację skonteneryzowanej instancji Jenkinsa z pomocnikiem DIND
- Zainicjalizuj instację, wykaż działające kontenery, pokaż ekran logowania

```bash
sudo docker network create jenkins-net
sudo docker run --name jenkins-docker   --rm --detach   --privileged   --network jenkins-net   --network-alias docker   --env DOCKER_TLS_CERTDIR=""   -p 2376:2376   docker:dind
sudo docker run --name jenkins   --rm --detach   --network jenkins-net   --env DOCKER_HOST=tcp://docker:2376   --env DOCKER_TLS_VERIFY=0   -p 8080:8080 -p 50000:50000   -v jenkins-data:/var/jenkins_home   jenkins/jenkins:lts-jdk11
```

Działające kontenery: serwer, klient oraz jenkins
![Dzialajace kontenery](..Sprawozdanie1Screenshots/status.png)

Ekran logowania:
![Logowanie Jenkins](..Sprawozdanie1Screenshots/logpage.png)

## Zakres rozszerzony

### Komunikacja

- Stwórz kontener czysto do budowania (bez narzędzi do klonowania/kopiowania, bez sklonowanego repozytorium)
- Stwórz na jego bazie kontener przejściowy, który tylko buduje, wyciągnij z niego pliki po skutecznym buildzie

### Usługi w rozumieniu systemu, kontenera i klastra

- Zestaw w kontenerze ubuntu/fedora usługę SSHD, połącz się z nią, opisz zalety i wady (przypadki użycia...?) komunikacji z kontenerem z wykorzystaniem SSH

### Jenkins: zależności

- Co jest potrzebne by w naszym Jenkinsie uruchomić Dockerfile dla buildera?
- Co jest potrzebne w Jenkinsie by uruchomić Docker Compose?
