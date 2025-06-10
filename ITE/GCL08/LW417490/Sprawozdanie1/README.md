# Sprawozdanie 1

## Lab 1 - Wprowadzenie, Git, Gałęzie, SSH

### Cel:
Celem zajęć było zapoznanie się z podstawowymi funkcjonalnościami systemu kontroli wersji Git. Podczas laboratorium nauczyliśmy się instalacji Git, klonowania repozytoriów przy użyciu protokołów HTTPS i SSH, a także tworzenia i zarządzania gałęziami. Dodatkowo, skonfigurowaliśmy klucze SSH, co umożliwia bezpieczny dostęp do repozytoriów.

### Przebieg:

#### 1. Instalacja Git
Najpierw zainstalowaliśmy Git przy użyciu polecenia:

```
sudo dnf install git
```
Po zakończeniu instalacji sprawdziliśmy wersję, aby upewnić się, że Git działa poprawnie:
```
git --version
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 120039.png>)

#### 2. Klonowanie repozytorium

Skopiowaliśmy repozytorium za pomocą HTTPS:
```
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO
```
#### 3. Konfiguracja SSH
Aby umożliwić bezpieczny dostęp do GitHub’a bez konieczności podawania hasła przy każdej operacji, wygenerowaliśmy klucz SSH typu ed25519:
```
ssh-keygen -t ed25519 -C "lucjawuls@gmail.com"
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 120127-1.png>)

Następnie wyświetliliśmy zawartość wygenerowanego klucza:
```
cat ~/.ssh/id_ed25519.pub
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 120151.png>)

![alt text](<Lab1/Zrzut ekranu 2025-03-20 121939.png>)

Skopiowaną zawartość klucza dodaliśmy do ustawień konta GitHub, co umożliwiło autoryzowany dostęp. Uruchomiliśmy również agenta SSH:
```
eval $(ssh-agent)
```
Dzięki temu mogliśmy sklonować repozytorium już przy użyciu protokołu SSH:
```
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 120244-1.png>)

#### 4. Praca z gałęziami

Następnie przełączyliśmy się na gałąź grupową:
```
git checkout remotes/origin/GCL08
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 120302.png>)

Aby zobaczyć wszystkie dostępne gałęzie, wykonaliśmy polecenie:
```
git branch -a
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 120318.png>)

Po weryfikacji gałęzi utworzyliśmy własną gałąź, nadając jej nazwę zgodną z naszymi inicjałami oraz numerem indeksu.

![alt text](<Lab1/Zrzut ekranu 2025-03-20 120335.png>)

#### 5. Tworzenie katalogu i githook'a

Na koniec, utworzyliśmy katalog o tej samej nazwie, w którym umieściliśmy skrypt githook'a. Skrypt sprawdzał, czy commit message zaczyna się od określonego prefiksu, co pomaga w utrzymaniu jednolitości w repozytorium.:

```
#!/bin/bash

PATTERN="^LW417490" 

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! $COMMIT_MSG =~ $PATTERN ]]; then
    echo "BŁĄD: Każdy commit message musi zaczynać się od '$PATTERN'"
    exit 1  
fi

echo "Commit message jest poprawny!"
exit 0 
```

#### 6. Wysyłanie zmian

Po wprowadzeniu zmian w lokalnym repozytorium, wysłaliśmy je do zdalnego repozytorium za pomocą polecenia:
```
git push --set-upstream origin LW417490
```
![alt text](<Lab1/Zrzut ekranu 2025-03-20 123156.png>)

![alt text](<Lab1/Zrzut ekranu 2025-03-20 123314.png>)

## Lab 2 - Git, Docker

### Cel:
Ćwiczenie miało na celu zapoznanie się z podstawową obsługą Dockera. Nauczyliśmy się instalować Dockera, pobierać obrazy z Docker Hub, uruchamiać kontenery oraz budować własne obrazy przy użyciu Dockerfile.

### Przebieg:

#### 1. Instalacja Dockera
Zainstalowaliśmy Dockera za pomocą komendy:
```
sudo dnf install -y moby-engine
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124150.png>)

Po instalacji sprawdziliśmy wersję:
```
docker version
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124256.png>)

#### 2. Uruchomienie Dockera
Aby rozpocząć pracę, uruchomiliśmy usługę Docker i ustawiliśmy jej automatyczne startowanie:
```
sudo systemctl start docker
sudo systemctl enabole docker 
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124313.png>)

#### 3. Rejestracja w Docker Hub

Utworzyliśmy konto w serwisie Docker Hub.
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124240.png>)

#### 4. Pobieranie obrazów z Docker Hub
Następnie pobraliśmy kilka obrazów (hello-world, busybox, fedora, mysql) używając poleceń:
```
docker pull
```
```
sudo docker pull hello-world
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124328.png>)

Aby uniknąć konieczności wpisywania sudo przy każdym poleceniu, dodałam się do grupy docker.
```
docker pull busybox
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124343.png>)

```
docker pull fedora
```

![alt text](<Lab2/Zrzut ekranu 2025-03-20 124403.png>)

```
docker pull mysql
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124418.png>)


#### 5. Sprawdzenie pobranych obrazów
Aby sprawdzić, czy obrazy zostały poprawnie pobrane, użyliśmy:
```
docker images
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124433.png>)

#### 6. Uruchamianie kontenerów
Następnie uruchomiliśmy kontenery. Przykładowo, kontener z obrazem busybox uruchomiono poleceniem:
```
docker run busybox
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124450.png>)

Aby wejść do interaktywnego trybu kontenera z systemem fedora, użyliśmy:
```
docker run -it fedora
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124506.png>)
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124534.png>)

Sprawdziliśmy PID wewnątrz kontenera oraz zaktualizowaliśmy pakiety:

![alt text](<Lab2/Zrzut ekranu 2025-03-20 124549.png>)

```
dnf update
```
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124603-1.png>)
![alt text](<Lab2/Zrzut ekranu 2025-03-20 124618.png>)

Na koniec sprawdziliśmy procesy Dockera.

![alt text](<Lab2/Zrzut ekranu 2025-03-20 124632.png>)

#### 7. Tworzenie własnego obrazu Docker
Na koniec zajęć stworzyliśmy plik Dockerfile, który budował obraz systemu Fedora z zainstalowanym Git i klonował repozytorium:
```
FROM fedora:latest

RUN dnf update -y &&dnf install -y git && dnf clean all

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["/bin/bash"]
```
Do budowy obrazu wykorzystaliśmy komendę:
```
docker build -t my_fedora .
```
Na koniec zajęć usunęliśmy niepotrzebne obrazy:
```
docker rmi hello-world busybox fedora mysql 
```


## Lab 3 - Dockerfiles, kontener jako definicja etapu

### Cel:
Celem tych ćwiczeń jest praktyczne zrozumienie koncepcji wieloetapowego budowania kontenerów Docker oraz ich zastosowania w automatyzacji procesu tworzenia, testowania i wdrażania oprogramowania.

### Przebieg:

#### 1. Wybranie rypozytorium z kodem oprogromowania
Wybrałam oprogramowanie, które przedstawił nam prowadzący, czy *irssi*.

Następnie skolonowałam repozytorium z GitHub'a:
```
  git clone https://github.com/irssi/irssi
  ```

![alt text](<Lab3/Zrzut ekranu 2025-03-27 213605.png>)
![alt text](<Lab3/Zrzut ekranu 2025-03-27 214253.png>) 

#### 2. Pobranie zależności oraz budowa projektu

Koeljnym krokiem jaki wykonałam było pobranie zależnośći, które umożliwią kompilację aplikacji.

```
sudo dnf -y install gcc glib2-devel openssl-devel perl-devel ncurses-devel meson ninja
```
![alt text](<Lab3/Zrzut ekranu 2025-03-27 214430.png>)

Gdy to było gotowe zbudowałam projekt używając pobranego wcześniej *Meson'a*:
```
meson Build
ninja -C Build
```
![alt text](<Lab3/Zrzut ekranu 2025-03-27 215037.png>)
![alt text](<Lab3/Zrzut ekranu 2025-03-27 215109.png>)

Następnie uruchomiłam testy znajdujące się w pojekcie:
```
ninja -C Build test
```
![alt text](<Lab3/Zrzut ekranu 2025-03-27 215133.png>)

#### 3. Zbudowanie projektu w kontenerze

W kolejnej części ćwiczeń pobraliśmy obraz oraz uruchomiliśmy interaktywny kontener
```
docker pull ubuntu:latest
docker run -it --name my_build ubuntu:latest /bin/bash
 ```
 ![alt text](<Lab3/Zrzut ekranu 2025-03-27 215600.png>)
 ![alt text](<Lab3/Zrzut ekranu 2025-03-27 215621.png>)

 Po czym zainstalowaliśmy zależności ponownie, tym razem w środku kontenera:
 ```
 apt update && apt install -y   build-essential   git   meson   ninja-build   libglib2.0-dev   libssl-dev   libperl-dev   libncurses5-dev   pkg-config
 ```
 ![alt text](<Lab3/Zrzut ekranu 2025-03-27 215851.png>)

 Następnie skolonowaliśmy repozytorium, także wewnątrz kontenera:
 ```
 git clone https://github.com/irssi/irssi
 ```
 ![alt text](<Lab3/Zrzut ekranu 2025-03-27 220152.png>)

 Kolejnym krokiem było zbudowanie projektu:
 ```
 meson Build
 ```
 ![alt text](<Lab3/Zrzut ekranu 2025-03-27 220226.png>)
 ![alt text](<Lab3/Zrzut ekranu 2025-03-27 220235.png>)

 ```
 ninja -C Build
 ```
 ![alt text](<Lab3/Zrzut ekranu 2025-03-27 220241.png>)

 Aktywowaliśmy także testy:
 ```
ninja -C Build test
 ```
 ![alt text](<Lab3/Zrzut ekranu 2025-03-27 220247.png>)


#### 3. Stworzenie Dockerfile

Pod koniec zajęć stworzyliśmy Dockerfile (u mnie nazwany Dockerfile.irssibld), który odpowiada za budowanie programu, jego treść wygląda następująco:
```
# Bazowy obraz
FROM fedora:latest

# Instalacja wymaganych zależności
RUN dnf install -y git meson ninja-build gcc glib2-devel ncurses-devel perl libtool autoconf automake pkg-config

# Klonowanie repozytorium
WORKDIR /app
RUN git clone https://github.com/irssi/irssi && cd irssi

# Konfiguracja i kompilacja
WORKDIR /app/irssi
RUN meson setup build && ninja -C build

```
Aby go wykorzystać należy:
```
docker build -t build_image -f Dockerfile.irssibld .
```
![alt text](<Lab3/Zrzut ekranu 2025-03-27 221119.png>)

Natomiast treść Dockerfile do zbudowania testów, wyglądała następująco:
```
# Bazujemy na wcześniej zbudowanym obrazie
FROM irssi-build

# Ustawienie katalogu roboczego
WORKDIR /app/irssi

# Uruchomienie testów jednostkowych
CMD ["meson", "test", "-C", "build"]

```
Po czym zbudowaliśmy drugio obraz:
```
docker build -t test_image -f Dockerfile.test .
```
![alt text](<Lab3/Zrzut ekranu 2025-03-27 221133.png>)

I go uruchomiliśmy:
```
docker run --rm --name test_container test_image
```
![alt text](<Lab3/Zrzut ekranu 2025-03-27 221154.png>)


## Lab 4 - Dodatkowa terminologia w konteneryzacji, instancja Jenkins

### Cel:
Ćwiczenie miało na celu zapoznanie się z zaawansowanymi technikami konteneryzacji, w tym konfiguracją woluminów, bind mountów oraz dedykowanych sieci, co umożliwia trwałe przechowywanie danych i sprawną komunikację między kontenerami. Dodatkowo, zadanie obejmowało wdrożenie instancji Jenkins.

### Przebieg:

#### 1.Przygotowanie woluminów

Na początku utworzyliśmy dwa woluminy
```
docker volume create Vin
docker volume create Vout
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 125216.png>)

Uruchomiliśmy kontener na bazie obrazu Fedory, podpinając wcześniej utworzone woluminy
```
docker run -it --rm -v Vin:/input -v Vout:/output fedora /bin/bash
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 125245.png>)

W kontenerze wykonaliśmy ainstalację niezbędnych pakietów, jednak z pominięciem git'a:
```
dnf -y update && dnf -y install meson ninja gcc glib2-devel openssl-devel utf8proc-devel ncurses-devel perl-ExtUtil*
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 125304.png>)

#### 2. Klonowanie repozytorium nw wolumin wejściowy

W celu ustalenia ścieżki do woluminu „Vin” na hoście, wykonaliśmy:
```
docker volume inspect Vin
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 125419.png>)

Po czym z wykorzystaniem sudo przeszłam do wskazanego folderu i sklonowałam tam repozytorium
```
sudo su
cd /var/lib/docker/volumes/Vin/_data
git clone https://github.com/irssi/irssi.git 
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 125436.png>)
![alt text](<Lab4/Zrzut ekranu 2025-03-30 125443.png>)

Wracając do terminala w kontenerze, przeszliśmy do budowy projektu:
```
meson Build
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 130909.png>)
```
ninja -C /input/irssi/Build
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 130915.png>)

Aby wynik był dostępny poza kontenerem, skopiowaliśmy zawartość woluminu wejściowego do wyjściowego:
```
cp -r /input/ /output
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 130921.png>)

Aby sprawdzić poprawność wykonania, sprawdziliśmy lokalizację woluminu wyjściowego na hoście:
```
docker volume inspect Vout
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 130926.png>)

Ponownie wykorzystaliśmy sudo, ponieważ w innym wypadku nie mamy uprawnień
```
 cd /var/lib/docker/volumes/Vout/_data
 ls
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 130933.png>)

#### 3. Instalacja iperf3 i uruchomienie kontenerów

Na hoście zainstalowaliśmy iperf3:
```
sudo dnf -y install iperf3
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 131814.png>)

Uruchomiliśmy dwa kontenery (jeden jako serwer, drugi jako klient)

Polecenia dotyczące serwera zostały oznaczone żółtym obramowaniem, zaś te dotyczące kleinta niebieskim.

```
docker run -it --rm --name server fedora bash
docker run -it --rm --name client fedora bash
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 132305.png>)
![alt text](<Lab4/Zrzut ekranu 2025-03-30 132259.png>)
![alt text](<Lab4/Zrzut ekranu 2025-03-30 131823.png>)

#### 4. Badanie ruchu

Na hoście sprawdziliśmy adres IP kontenera serwerowego:
```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} c98efae8649a 
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 132313.png>)

W kontenerze serwera uruchomiliśmy iperf3 w trybie serwera:
```
iperf3 -s
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 132323.png>)


W kontenerze klienta przetestowaliśmy połączenie, podając adres IP serwera:
```
iperf3 -c 172.17.0.2 -p 5201
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 132527.png>)

#### 5. Tworzenie sieci

Kolejnym krokiem było utworzenie własnej sieci, w tym celu użyliśmy komendy
```
docker network create my_net
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 132534.png>)
![alt text](<Lab4/Zrzut ekranu 2025-03-30 132539.png>)

Uruchomiliśmy kontenery serwera i klienta, podłączone do sieci my_net:
```
docker run --rm -it --network=my_net --name server fedora bash
docker run --rm -it --network=my_net --name client fedora bash
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 134012.png>)
![alt text](<Lab4/Zrzut ekranu 2025-03-30 132603.png>)

W kontenerze serwera uruchomiliśmy:
```
iperf3 -s
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 134023.png>)

Natomiast na kliencie dzięki temu, że kontenery są w wspólnej sieci wystarczyła jego nazwa
```
iperf3 -c server
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 134029.png>)

A następnie na terminalu hosta ponownie sprawdziliśmy ip serwera:
![alt text](<Lab4/Zrzut ekranu 2025-03-30 134501.png>)

Po czym z hosta za pomocą ip połączyliśmy sie z serwerem

![alt text](<Lab4/Zrzut ekranu 2025-03-30 134559.png>)

#### 6. Instalacja Jenkins

Następne kroki wykonywaliśmy zgodnie z dokumentacją https://www.jenkins.io/doc/book/installing/docker/

Utworzyliśmy dedykowaną sieć dla Jenkinsa:
```
docker network create jenkins
```
![alt text](<Lab4/Zrzut ekranu 2025-03-30 134656.png>)
![alt text](<Lab4/Zrzut ekranu 2025-03-30 134659.png>)

W pierwszej kolejności uruchomiliśmy kontener DIND, który będzie służył jako pomocnik Jenkinsa:
```
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
  ![alt text](<Lab4/Zrzut ekranu 2025-03-30 134704.png>)

 Stworzyliśmy plik Dockerfile.jen o następującej treści:
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
Następnie zbudowaliśmy obraz:
![alt text](<Lab4/Zrzut ekranu 2025-03-30 134711.png>)

Na końcu uruchomiliśmy kontener z instancją Jenkinsa:
```
docker run \
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

![alt text](<Lab4/Zrzut ekranu 2025-03-30 134716.png>)

Następnie chcąc połączyć się ze stroną logowania Jenkinsa z wykorzystaniem:
```
localhost:8080
```
Musiałam przekierować porty z wirtualnej maszyny do hosta
![alt text](<Lab4/Zrzut ekranu 2025-03-30 135531.png>)

Po wykonnaiu tej operacji wszystko działało juz poprawnie

![alt text](<Lab4/Zrzut ekranu 2025-03-30 135312.png>)
![alt text](<Lab4/Zrzut ekranu 2025-03-30 135317.png>)
![alt text](<Lab4/Zrzut ekranu 2025-03-30 135330.png>)