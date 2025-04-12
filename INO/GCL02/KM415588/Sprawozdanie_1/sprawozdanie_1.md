# Kacper Mazur, 415588 - Inzynieria Obliczeniowa, GCL02
## Laboratorium 1 - Wprowadzenie, Git, Gałęzie, SSH

### Wprowadzenie:

W ramach tego zadania skonfigurowałem Git i SSH, sklonowałem repozytorium, pracowałem z gałęziami, stworzyłem git hooka oraz przygotowałem sprawozdanie. Używałem wirtualnej maszyny z systemem fedora.
### 1️⃣ Instalacja Git i OpenSSH:
```bash
sudo dnf install -y git openssh
```

![wersje](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/wersje.png)

### 2️⃣ Personal access token:
Utworzyłem personal access token:

![pat](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/token.png)

A następnie sklonowałem repozytorium przy pomocy access token:
```bash
git clone https://<TOKEN>@github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

![httprepo](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/httprepo.png)

### 3️⃣ Klucze SSH:
Wygenerowałem dwa klucze:
-ecdsa:
```bash
ssh-keygen -t ecdsa -b 521 -C "tasnko12@gmail.com"
```
-ed25519:
```bash
ssh-keygen -t ed25519 -C "tasnko12@gmail.com"
```
przy czym w pierwszym przy zapytaniu o hasło kilknąłem ENTER a przy drugim wpisałem hasło dostępu. Wygenerowane klucze zapisałem w katalogu '/home/kmazur/.ssh/', a następnie dodałem do swojego konta na GitHubie: 'Settings' -> 'SSH and GPG keys'.

![SHHKEYS](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/ssh_keys.png)

Następnie skonfigurowałem klucze SSH jako metodę dostępu do GitHuba

- Kopiowanie kluczy SSH:
```bash
clip < ~/.ssh/id_ed25519.pub
```
```bash
clip < ~/.ssh/id_ecdsa.pub
```
- Uruchomienie agenta SSH:
```bash
eval $(ssh-agent -s)
```
- Dodanie klucza typu ed25519 do agenta (musiałem podać hasło przy wykonaniu polcenia):
```bash
ssh-add ~/.ssh/id_ed25519
```
### 4️⃣ Klonowanie repozytorium wykorzytsując protokół SSH:
```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
### 5️⃣ Obsługa gałęzi:
```bash
cd MDO2025_INO
git checkout main
git pull origin main

git checkout GCL02
git pull origin GCL02

git  checkout -b KM415588
```
Zdjęcie przestawiające wszytskie odwiedzone gałęzie:

![Branches](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/Branches.png)

### 6️⃣ Utowrzenie katalogu KM415588 i git hooka:
W kolejnym kroku utworzyłem katalog KM415588 i a w nim plik commit-msg:
```bash
mkdir -p KM415588/Sprawozdanie_1
cd KM415588/Sprawozdanie_1
nano commit-msg
```
Plik commit-msg:
```bash
#!/bin/bash
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! "$COMMIT_MSG" =~ ^KM415588 ]]; then
    echo "❌ Błąd: Commit message musi zaczynać się od 'KM415588'"
    exit 1
fi
```
A następnie skopiowałem go do folderu ./git/hooks i dodałem mu odpowiednie uprawnienia do wykonywania:
```bash
cp ./commit-msg .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg
```

Po przetestowaniu zwraca on następujące wyniki:

![hook](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/test_hook.png)

### 7️⃣ Dodanie sprawozdania w formacie .md i zrzutów ekranu:
Po utworzeniu odpowiedniej struktury plików i napisaniu sprawozdania wypushowałem zmiany do mojej gałęzi po czym zmergeowałem ją z gałęzią grupy:
```
git add .
git commit -m "KM415588: sprawozdanie i zdjęcia"

git push origin KM415588
git checkout GCL02
git pull origin GCL02
git merge KM415588
```

![merge](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/merge.png)

Na zdjęciu nie widać zakończenia wywołania merge, ale się nie powiódł ze względu na brak uprawnień - wstawiam więc pull request-a na Githubie.

## Laboratorium 2 - Git,Docker

### Wprowadzenie

Zajęcia zajmowały sie zapoznaniem sie z narzędziem Docker - obrazami, kontenerami - oraz automatyzacją tworzenia gotowych do użytku obrazów przy użyciu Dockerfile-i.

### 1️⃣ Instalacja Dockera:
```bash
sudo dnf install docker
```

![Docker Version](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/docker-ver.png)

### 2️⃣ Zalogowanie się do Dockera i pobranie odpowiednich obrazów:
Ze względu na wcześniejsze korzystanie z Docker-a miałem już utworzone konto. Musiałem więc tylko się zalogować:

```bash
docker login
```

![Docker login](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/logowanie_docker.png)

Następnie pobrałem odpoweiednie obrazy:

```bash
docker pull busybox
docker pull hello-world
docker pull fedora
docker pull mysql
```

![pobieranie_img](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/pullowanie_img.png)

Po wykonaniu:

```bash
docker images
```

![initail_img](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/img_docker_initial.png)

### 3️⃣ Uruchamianie kontenerów:
Pierwszym z uruchamianych przez nas kontenerów będzie busybox:

```bash
docker run -it busybox
busybox | head -1
```

![busybox](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/busy.png)

Jak widizmy udało nam się uruchomić kontener. możemy również sprawdzić czy faktycznie istnieje poleceniem:
```bash
docker ps -a
```

Dalej uruchomimy jeszcze kontener z systemem opereacyjnym fedora:

```bash
docker run -it fedora
```

Zdjęcie z wyświetleniem działąjących kontenerów przed powyższym poleceniem, uruchomieniem nowego konetenru i stanu po wyjściu z niego:

![fedoraxbusy](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/busyboxy_tworzenie_fedory.png)

### 4️⃣ Instalacja procps-ng, wyświetlenie PID w konetenerze i aktualziacja pakietu wewnątrz kontenera:

Ponownie uruchamiam kontetener z systemem fedora - najpierw wykonuje docker ps -a żeby poznać jego indywidualną nazwę, następnie wywołuje docker exec z nazwą kontenera, a następnie instaluje odpowiednie pakiety:

```bash
docker ps -a
docker exec -it <CONTAINER_NAME> /bin/bash
dnf install -y procps-ng
ps
dnf update -y
```
Uruchomienie i wyświetlanie PID:

![ps-a](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/fedora_ps.png)

Update systemu:

![update](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/update_fedory.png)

### 5️⃣ Dockerfile i tworzenie włąsnego konteneru:

Napisałem Dockerfile-a, który po uruchomieniu instaluje pakiet git i klonuje repozytorium przedmiotu z moim Personal Access Token-em przesłanym mu jako jeden z argumentów przy uruchomianiu tworzenia konteneru. Struktura Dockerfile:

```dockerfile
FROM fedora:latest

RUN dnf update -y && dnf install -y git && dnf clean all

ARG TOKEN
ENV GITHUB_TOKEN=${TOKEN}

WORKDIR /app


RUN git clone https://${GITHUB_TOKEN}@github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
RUN unset GITHUB_TOKEN

CMD ["/bin/bash"]
```

Następnie w terminalu wywołujemy następujący ciąg komend:

```bash
docker build --buil-arg TOKEN=<PERSONAL_ACCESS_TOKEN> -t gitdockerfile .
docker run -it gitdockerfile /bin/bash
```

Po utworzeniu obrazu i uruchomieniu kontenera wywołujemy:
```bash
ls -al
exit
```

![dockeruruchom](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/utworzenie_dockerfile.png)

### 6️⃣ Usuwanie obrazów i kontenerów:

Wywołuje:
```bash 
docker container prune
```

komenda usunie wszytskie zatrzymane kontenery. Niestety kontener fedory dalej był uruchomiony - wywołałem więc:
```bash
docker stop <fedora_con_name> && docker rm <fedora_con_name>
```

![con_rm](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/usuwanie_con.png)

Tak samo usuwam obrazy:

Wywołuje:
```bash 
docker image prune
```

![im_rm](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/usuwanie_img.png)

### 7️⃣ Dodanie sprawozdania w formacie .md i zrzutów ekranu:
Po utworzeniu odpowiedniej struktury plików i napisaniu sprawozdania wypushowałem zmiany do mojej gałęzi po czym wystawiłem pull request-a:
```
git add .
git commit -m "KM415588: sprawozdanie i zdjęcia"
git push origin KM415588
```

## Laboratorium 3 - Dockerfiles, kontener jako definicja etapu

### Wprowadzenie

Celem labolatorioum było lepsze zapoznanie się z działaniem Dockerfile-ów oraz z narzedziem Docker-compose i lepsze zrozumienie działania obrazów i ich możliwości.

### 1️⃣ Znalezienie repozytorium z wbudowanymi testami:

Do realizacji ćwiczenia wybrałem bibliotekę chalk-pipe posiadającą:
- skrypty npm run build i npm test
- testami AVA
- licencją MIT

LINK: https://github.com/LitoMore/chalk-pipe

![repo_photo](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/repo_photo.png)

#### Pomoc ChatGPT
Do znalezienia repo wykorzystana pomoc ChatGPT:
- Zadane pytanie:
Proszę czy mógłbys mi pomóc znaleźć repozytorium umozliwiające testy jednostkowe w dowolnym środowisku i z uzyciem dowolnego narzędzi (npm, ninja, pytest)
W odpowiedzi uzyskałem kilka repozytoriów a to było jedno z nich.

### 2️⃣ Testy na własnym OS:

Na początku sklonowałem uaktualniłem środowisko, skopiowałem repozytorium i spróbowałem uruchomić testy:

```bash
sudo dnf -y update
git clone https://github.com/LitoMore/chalk-pipe
cd chalk-pipe
npm install
``` 
W terminalu otrzymałem jednak komunikat o nie posiadaniu narzędzia npm - doinstalowałem je i ponowiłem próbę:

```bash
sudo dnf -y install npm
npm install
```

![OS_NPM](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/OS_NPM.png)

Tym razem udał się wstępny etap, więc przeszedłem do dalszych kroków:

```bash
npm run build && npm test
```

![NPM_test](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/NPM_TEST.png)

Jak widzimy testy przebiegły poprawnie

### 3️⃣ Napisanie Dockerfile-ów:

Ze względu na fakt używania npm do testów nie potrzebuję pełnego OS, ale mogę uruchomić swoje testy na Node.js - spowoduje to zmniejszenie wykorzystywanego konteneru i uprości pisanie Dockerfile - nie muszę instalować dodatkowych pakietów. Pierwszy Dockerfile służący do budowy wygląda następująco:
```dockerfile
FROM node

RUN git clone https://github.com/LitoMore/chalk-pipe
WORKDIR /chalk-pipe

RUN npm install
RUN npm run build
```

Po czym uruchamiam w konsoli budowanie obrazu chalk-build:

```bash
sudo docker build -f dockerfile.chalkbuild . -f chalk-build
```

![docker-build-chalk](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/chalk_build.png)

Jak widzimy na zdjęciu powyżej budowa obrazu przebiegła pozytywwnie. Przechodzę do napisania drugiego dockerfile-u:

```dockerfile
FROM chalk-build
WORKDIR /chalk-pipe
RUN npm test > test_output.log || true
CMD ["cat", "test_output.log"]
```

Nowy obraz będzie korzystał z poprzedniego i będzie uruchamiał testy a wyniki, które wypisałyby sie w konsoli wpisze do pliku test_output.log. Przy utworzeniu kontenera na podstawie tego obrazu wynik testów wypisze się w konsoli:

```bash
sudo docker build -t chalk-test -f dockerfile.chalktest .
sudo docker run -it chalk-test
```

![chalk_test_dockefile](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/chalk_test.png)

### 4️⃣ Zakres rozszerzony docker-compose:

Na początku napisałem plik docker-compose.chalk.yml:

```docker-compose
version: '3.7'

services:
  builder:
    build:
      context: .
      dockerfile: dockerfile.chalkbuild

  tester:
    build:
      context: .
      dockerfile: dockerfile.chalktest
    depends_on:
      - builder
```

Kompozycja będzie tworzyła dwie usługi - pierwszą na bazie dockerfile.chalkbuild, a drugą na podstawie dockerfile.chalktest. Skróci to nasze wywołanie i sprawdzenie działania testów do jednej komendy - uwzględniam jednak również instalacje docker compose:

```bash
sudo dnf -y install docker-compose
sudo docker-compose -f docker-compose.chalk.yml up --build
```

![chalk_test_compose1](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/docker-compose-test1.png)

![chalk_test_dockefile](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/img/docker-compose-res2.png)

Jak widać na zdjęciach wdrożenie kompozycji przebiegło pozytywnie.

#### Przygotowanie do wdrożenia (deploy): dyskusje
W przypadku wybranego przeze mnie repozytorium nie ma sensu publikować go jako kontener - jest to biblioteka wykorzystywana do działania z innymi programami a nie sama w sobie. O ile jescze do przeprowadzenia takiej konteneryzacji jw. nadaje się w zupełności to budowanie konteneru z chalk-pipe jako produktem, mija sie z celem.

Pomimo tego faktu porzeprowadzę dalsze rozważania i dywagacje tak, jakbym przygotowywał gotowy kontener z chalk-pipe jako produktem:

- przygotowanie finalnego artefaktu:

    jest to bibliotek, więc lepiej aby finalnym artefaktem była paczka .tgz lub skompilowana wersja. Skupie się na wersji w paczce - pakowania dokonać możemy poleceniem:

    ```bash
    npm pack
    ```

- czyszczenie kontenera:

    tu moje rozważania przestają mieć zastosowanie do wybranego przeze mnie repo. Ale tak - standarodowo powinno sie czyścić kontener przed opulikowaniem aplikacji w formie kontenerowej. Konieczne jest usunięcie testów, zależności deweloperskich, plików źródłowych oraz niepotrzebnych plików cache. Najlepszym podejściem jest jednka zastosowanie tzw. ścieżki deploy and publish. Utworzyć dodatkowy dockerfile, bazujący na czystym obrazie i dostarczający urzytkowniką tylko wysylekcjonowane fragmenty, które pozostały by po oczszczaniu pełnego kontenera.

- dystrybucja programu:

    Przyjmując, iż tworzylibyśmy deploy oparty na JavaScript/TypeScript (czyli gdyby chalk-pipe nie była biblioteką, ale aplikacja do konteneryzacji) to najelpiej utworzyć paczkę .tgz. Jak już powyżej opisałem możemy to osiągnąc jesnym poleceniem npm pack, ale nic nie zatrzymuje nas przed napisaniem dodatkowego dockerfile, po którego zbuildowaniu artefaktem będzie paczka.

## Laboratorium 4 - Dodatkowa terminologia w konteneryzacji, instancja Jenkins

### Wprowadzenie:

Celem jest zapoznanie się z możliowściami woluminów, eksponowania portów oraz instancji Jenkins

### 1️⃣ Zachowanie stanu:
#### 1. Tworzenie woluminów:

Zgodnie z instrukcją tworzę dwa woluminy wejściowy i wyjściowy:

```bash
sudo docker volume create volin && sudo docker colume create volout
```

![vol_create](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/volume_ls1.png)

#### 2. Klonowanie chalk-pipe na wolumin wejściowy i uruchomienie konteneru:

Możemy skopiować repozytorium na wolumin wejściowy pomijając kopiowanie repozytorium bez instalowania usługi git na kontenerze. Wykonamy to poniższym poleceniem:

```bash
sudo docker run --rm -v volin:/repo alpine/git clone https://github.com/LitoMore/chalk-pipe /repo
```

W wydruku otrzymamy standardowe komunikaty o klonowaniu repo:

![volin_repo](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/volin_repo.png)

Następnie uruchamiamy kontener:

```bash
sudo docker run -it --rm -v volin:/src -v volout:/build node:18-alpine sh
```

![volin_repo_conm](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/volin_volout_con.png)

Jak widzimy repo zostało pozytywnie sklonowane. Dalej możemy wykonać standardowy npm install, run build i test - zwrócą one takie same wyniki jak przy postępowaniu na dwóch kontenerach. Na końcu kpoiujemy pliki do katalogu build:

```bash
npm install
npm run build
npm test
cp -r distribution/ ../build
```

Folder skopiował się poprawnie, co możemy sprawdzic uruchamiając kontener z woluminem volout:

```bash
sudo docker tun -it --rm -v volout:/build alpine sh
cd build
ls
```

![volout](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/volout.png)

#### 3. Klonowanie chalk pipe w kontenerze

Usuwamy i tworzymy voluminy z poprzedniego punktu. Następnie uruchamiamy kontener (pomijam krok z klonowaniem repo na volin):


```bash
sudo docker run -it --rm -v volin:/repo -v volout:/build node:18-alpine sh
```

Po wejściu do /repo i wykonaniu ls widzimy pusty katalog:

![con_git](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/container_git.png)

Dalej przeprowadzamy więć klonowanie repo i wszystkie polecenia npm:

```bash
apk add git
git clone https://github.com/LitoMore/chalk-pipe /repo
cd repo
npm install
npm run build
npm test
```

![con_wyn](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/con_run_build.png)

Jak widzimy testy przebiegły poprawnie. Dalej możemy ponownie wykonać kopie do /buil i uruchomić kontener z volout - uzyskamy taki sam wynik jak wcześniej. Na końcu usuwamy oba woluminy

```bash
sudo docker volume rm volin volout
```

#### 4. Dywagacje
Istnieje jeszcze jedna opcja wykonania powyższych kroków przy użyciu dockerfile i RUN --mount. Piszemy poniższy dockerfile:

```dockerfile
FROM node:18

RUN --mount=type=bind,target=/src,source=./chalk-pipe,rw \
    cd /src && npm install && npm run build && cp -r distribution /out
```

Zautomatyzuje to budowanie aplikacji a RUN ---mount połączy kontener z local hostem i prześle mu katalog src a wyniki zapisze w katalog out - utworzy się nowy w folderze z którego wywołujemy nasz dockerfile - musimy w nim też sklonowane chalk-pipe.

![dock-chalk-pipe](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/cahlk-pipe.png)

### 2️⃣ Eksponowanie portu:

#### 1. Tworzenie kontenera z usługą iperf3:

Istnieją dwa sposoby na utworzenie takiego konteneru. Pierwszą z nich jest uruchomienie kontenera korzystającego bezpośrednio z obrazu iperf3:

```bash
sudo docker run -d --name iperf-server -p 5201:5201 networkstatic/iperf3 -s
```

![iperf_init](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/iperfinit.png)

Jak widizmy na zdjęciu kontener utowrzył się poprawnie - w dalszych częściach ćwiczenia jest to główny sposób tworzenia konteneru, używany przeze mnie.

Drugim sposobem jest uruchomienie kontenera w standardowy sposób na podstawie obrazu systmeu linuxowego i zainstalowanie na nim usługi iperf3 i uruchomienie - warto pamiętać przy tworzeniu również tego konteneru mapować go od razau na port 5201

```bash
sudo docker run -it --name iperf-server -p 5201:5201 fedora bash
### w konsoli kontenera
dnf -y install iperf3
iperf3 -s
```

Możemy to również osiągnąc pisząc dedykowanego do tego Dockerfile, ale ja nie używałem tego sposobu wiele razy (uruchomiłem raz w celu przetestowania), więc nie napisałem takiego.

#### 2. Łączenie z serwerem:

- łączenie przy użyciu kontenera:

  z serwerem na kontenerze możemy się połączyć korzystająć z innego konteneru w poniższy sposób:

  ```bash
  sudo docker run --rm networkstatic/iperf3 -c 172.17.0.2
  ###opcjonalnie ale dłużej bo trzeba stworzyć sieć do komunikacji
  sudo docker network create iperf-net
  sudo docker network connect iperf-net iperf-server
  sudo docker run --rm --network iperf-net networkstatic/iperf3 -c  iperf-server
  ```
  Tworzymy tutaj własną sieć mostkową. Jeśli połączenie przebiegnie poprawnie otrzymamy poniższy wydruk:

  ![iperf-con](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/iperf3_con.png)

- łączenie z localhosta:
  
  Jeśli chcemy połączyć się z localhosta w konsoli wpisujemy:

  ```bash
  ###jeśli nie mamy zainstalowanego iperf3
  sudo snf -y install iperf3
  sudo iperf3 -c 172.17.0.2
  ```
  Z loclahosta nie da się łączyć z serwerem na kontenerze po jego nazwie, ponieważ sieć iperf-net jest rozwiązaniem wewnątrz dockerowym, ale istnieje jeszcze jedna opcja:

  ```bash
  sudo iperf3 -c 127.0.0.1 -p 5201
  ```

  Wynik łączenia sie pierwszym sposobem:

  ![iperf_local_host](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/localhost_iperf3.png)

- łączenie z innego komputera:

  Możemy się połączyć z innego komputera z serwerem na kontenerze. Musimy zadbac żeby kontener miał zmapowane porty na 5201 (opcja -p 5201:5201 przy tworzeniu kontenera). Następnie po zainstalowaniu iperf3 na komputerze, z którego chcemy się łączyć wykonujemy:

  ```bash
  iperf3 -c <ip_wirtualnje_maszyny_z_kontenerem>
  ```

  Wynik w moim przypadku:

  ![iper3_my_mach](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/iperf3_my_mach.png)

#### 3. Logi kontenera

Możemy zbadać przepustowść komunikacji z kontenerem odczytując jego logi. Wykonujemy to poleceniem:

```bash
sudo docker logs iperf-server
```

Otrzymamy:

![iperf3_logs](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/iperf3_logs.png)

### 3️⃣ Instancja Jenkins:

Na początku tworzymy sieć dokerową, woluminy wejściowe i wyjściowe, i uruchamiamy w niej DIND

```bash
sudo docker network create jenkins-network
sudo docker volume create jenkins-docker-certs && sudo docker volume create jenkins-data
sudo docker run --name jenkins-docker --rm --detach --priviliged --network jenkins-network --env DOCKER_TLS_CERTDIR=/certs --volume jenkins-docker-certs:/certs/client --volume jenkins-data:/var/jenkins_home docker:dind
sudo docker run --name jenkins-blue --rm --detach --network jekins-network --env DOCKER_HOST=tcp://docker:2376 --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 --publish 8080:8080 --publish 50000:50000 --volume jenkins-data:/var/jenkins_home --volume jenkins-docker-certs:/certs/client:ro jenkins/jenkins:latest
sudo docker ps -a
```
Otrzymujemy dwa kontenery:

![jenkins_cons](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/jenkins_cons.png)

Dalej pobieramy z kontenera jenkins-blue hasło administratora do pierwszego logowania:

```bash
sudo docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```

A dalej na maszynie lokalnej wchodzimy pod adres http://<ip_maszyny_z_kontenerem>:8080

Po wpisaniu hasła otrzymanego w konsoli otrzymamy:

![jenkins_przegl](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/jenkins_przegl.png)

Po wybraniu instalacji wtyczek domyślnych otrzymujemy okno:

![jenkins_wtyk](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/jenkins_wtyczki.png)

Po zainstalowaniu się wtyczek otrzymujemy:

![jenkins_user](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/jenkins_user.png)

A po zalogowaniu:

![jenkins_aftre](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/jenkins_after.png)

### 4️⃣ Zakres rozszerzony:

#### 1. Komunikacja:

Celem ćwiczenie jest zbudowanie kontenera służącego tylko do budowy. W tym celu napiszę przykładowy dockerfile działający dla mojego repo chalk-pipe:

```dockerfile
FROM node:20-alpine

WORKDIR /app
RUN npm install -g typescript

CMD ["sh"]
```

W kontenerze brakuje gita, ale o to chodzi - chcemy żeby był jak najlżejszy i słuzył tylko do buildowania. Następnie tworzymy woluminy wejściowy (na który kopiujemy repo tak jak wcześniej podczas lab w sekcji [2. Klonowanie chalk-pipe na wolumin wejściowy](#2-klonowanie-chalk-pipe-na-wolumin-wej%C5%9Bciowy-i-uruchomienie-konteneru))

Po przygotowaniu dockerfile i voluminów wpisujemy w terminalu komendy:

```bash
sudo docker build -t chalk-pipe-builder -f dockerfile.builder .
sudo docker run --rm -v volin:/repo -v volout:/mnt/output chalk-pipe-builder sh -c "cd /repo && npm install && npm test && cp -r . mnt/output/"
```

Otrzymamy:

![roz_builder](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/roz_builder.png)

Po czym możemy sprawdzić czy utworzyły się pliki na voluminie wyjściowym:

```bash
docker run -it --rm -v volout:/mnt/output alpine sh
### w kontenerze
ls /mnt/output
```

![roz_out](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/roz_volout.png)

#### 2. Usługi w rozumieniu systemu, kontenera i klastra

Piszemy dockerfile.ssh w celu sprawienie, żeby komenda do uruchomienia kontenera była bardziej czytelna:

```dockerfile
FROM fedora:latest

RUN dnf -y update &&  dnf -y install openssh-server passwd &&  dnf clean all
RUN ssh-keygen -A
RUN echo "root:root" | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
```

A potem wykonujemy komendy:

```bash
sudo docker build -t ssh-fedora-image -f dockerfile.ssh .
sudo docker run -d --name ssh-fedora -p 2222:22 ssh-fedora-image
### po utworzeniu sie kontenera w konsoli localhosta
ssh root@localhost -p 2222
### i wpisujemy hasło root
```

![roz_ssh](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM415588/INO/GCL02/KM415588/Sprawozdanie_1/004/img_4/roz_ssh.png)

Zalety komuniakcji przez ssh z kontenerem:
- Łatwy zdalny dostęp np scp
- przydatne w CI/CD np. Jenkins SSH agent
- debugowanie - możliwość podglądania logów tak jak na zwykłym serwerze
- zdalne zarządzania

Wady:
- sprzecznośc z filozofią dockera
- potencjalne niebezpieczeństwo - konieczność pilnowania i zarządzania dostępem
- występują lepsze i bezpieczniejsze alternatywy

Używanie tego rozwiązania ma sens przy używnaiu jako agent Jenkins, środowisko legacy czy przy debugu krótkoterminowym

#### 3. Jenkins: zależność

Co jest potrzebne, żeby Jenkins mógł budowac obrazy z Dockerfile:

Musi mieć dostęp do dockera przez socketa lub DIND oraz opcjonalnie do docker CLI jeśli działa w swoim kontenerze.

Co jest potrzebne w Jenkinsie by uruchomić Docker Compose:

Oprócz tego co poprzednio potrzebny jest dodoatkowo dostęp do docker compose.

## Wykorzystanie AI w pisaniu sprawozdania:

Wykorzystałem ChatGPT do znalezienia Chalk-pipe oraz do konsultacji odnośnie poprawności kroków, które chcę podjąć.


Na końcu pragnę dodać, iż plik z wykorzystanymi komendami może nie zawierac wszystkich wykorzystanych przeze mnie komend ze względu na konieczność postawienia serwera od nowa po realizacji instrukcji 3 - w trakcie realizowania 4 - problem poruszany przeze mnie na zajeciach.