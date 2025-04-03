# Sprawozdanie

## Lab 1. Wprowadzenie, Git, Gałęzie, SSH

### 1. Instalacja klienta Git i obsługi kluczy SSH

W celu rozpoczęcia pracy z systemem kontroli wersji Git oraz zabezpieczonym połączeniem SSH, konieczne było zainstalowanie odpowiednich narzędzi. Instalacja została wykonana przy użyciu menedżera pakietów `dnf`, który jest domyślnym rozwiązaniem w systemach Fedora.

`dnf install git openssh`

![Instalacja git i openssh](ss/1/1-install-git-openssh.png)

### 2. Sklonowanie repozytorium przedmiotowego

Aby uzyskać lokalną kopię repozytorium przedmiotowego, wykorzystano polecenie git clone, które początkowo używało protokołu HTTPS.

`git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO`

![Sklonowanie repozytorium](ss/1/2-clone-repo.png)

### 3. Stworzenie kluczy SSH i zmiana połączenia na SSH

Aby uniknąć każdorazowego podawania loginu i hasła oraz zapewnić bezpieczne połączenie z GitHubem, wygenerowano dwa klucze SSH: jeden wykorzystujący algorytm `ed25519`, a drugi `ecdsa`.

`ssh-keygen -t ed25519 -C "adres_email"`

![Wygenerowanie pierwszego klucza SSH typu ed25519](ss/1/3-gen-ssh-1.png)

![Wygenerowanie pierwszego klucza SSH typu ecdsa](ss/1/3-gen-ssh-2.png)

Po wygenerowaniu kluczy, zostały one dodane do agenta SSH:

`ssh-add ~/.ssh/id_github_ed25519`

![Dodanie 1. klucza do agenta SSH](ss/1/3-ssh-add-1.png)

![Dodanie 2. klucza do agenta SSH](ss/1/3-ssh-add-2.png)

Zmiana połączenia z repozytorium na SSH:

`git remote set-url origin git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git`

![Zmiana połączenia z repozytorium](ss/1/3-ssh-change.png)

Klucz o nazwie *id_github_ed25519* został skonfigurowany jako metoda dostępu do GitHuba.

![Poprawne dodanie klucza SSH dla dostępu GitHuba](ss/1/3-ssh-key-github.png)

### 4. Zmiana gałęzi

Po poprawnym skonfigurowaniu połączenia SSH, nastąpiło przełączenie na gałęzie main oraz gałęź dedykowaną dla grupy.

`git checkout main`

`git checkout <nazwa-gałęzi-grupy>`

![Zmiana gałęzi](ss/1/4-branch-change.png)

### 5. Stworzenie nowej gałęzi

Utworzono nową gałęź o nazwie KP415903, odgałęziając się od gałęzi grupowej.

`git checkout -b KP415903`

![Stworzenie nowej gałęzi](ss/1/5-new-branch.png)

### 6. Rozpoczęcie pracy na nowej gałęzi

W katalogu dedykowanym dla grupy utworzono nowy folder o nazwie ***KP415903***.

`mkdir KP415903`

![Stworzenie nowego folderu](ss/1/6-new-folder.png)

W celu zapewnienia spójności i poprawności commitów, stworzono hooka pre-commit, który weryfikuje, czy każda wiadomość commit zaczyna się od "KP415903". Skrypt ten został umieszczony we właściwym katalogu, aby był automatycznie wywoływany przy każdej próbie wywołania commita.

Treść Git hooka:
```
#!/bin/bash
EXPECTED_PREFIX="KP415903"
COMMIT_MSG=$(cat "$1")

if [[ "$COMMIT_MSG" != $EXPECTED_PREFIX* ]]; then
  echo "Error: Początek wiadomości musi zaczynać się od '$EXPECTED_PREFIX'."
  exit 1
fi
```

---
## Lab 2. Git, Docker

### 1. Instalacja Dockera w systemie Linux

Docker to popularne narzędzie do zarządzania kontenerami, które umożliwia izolowanie aplikacji w lekkich, przenośnych środowiskach. Instalacja Dockera w systemie Fedora wymaga dodania odpowiedniego repozytorium oraz instalacji pakietów.

```bash
sudo dnf install dnf-plugins-core -y  # Instalacja narzędzi do zarządzania repozytoriami
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo  # Dodanie oficjalnego repozytorium Dockera
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin  # Instalacja Dockera i powiązanych narzędzi
```

![Instalacja Dockera](ss/2/1-docker-install-1.png)

![Instalacja Dockera](ss/2/1-docker-install-2.png)

![Instalacja Dockera](ss/2/1-docker-install-3.png)

### 2. Uruchomienie usługi Docker

Po instalacji konieczne jest uruchomienie usługi Docker oraz ustawienie jej do automatycznego startu przy uruchamianiu systemu. Dzięki temu Docker będzie działał w tle i obsługiwał kontenery bez konieczności każdorazowego uruchamiania usługi.

```bash
sudo systemctl start docker  # Uruchomienie usługi
sudo systemctl enable docker  # Włączenie automatycznego uruchamiania przy starcie systemu
sudo systemctl status docker  # Sprawdzenie statusu usługi
```

![Uruchomienie Dockera (start)](ss/2/2-docker-start-1.png)

![Uruchomienie Dockera (enable)](ss/2/2-docker-start-2.png)

![Uruchomienie Dockera (status)](ss/2/2-docker-start-3.png)

### 3. Dodanie użytkownika do grupy Docker

Domyślnie Docker wymaga uprawnień administratora do uruchamiania kontenerów. Aby umożliwić zwykłemu użytkownikowi korzystanie z Dockera bez konieczności używania `sudo`, dodano użytkownika do grupy `docker`.

```bash
sudo usermod -aG docker $USER  # Dodanie użytkownika do grupy docker
newgrp docker  # Odświeżenie uprawnień grupy
```

![Dodanie użytkownika do grupy Docker](ss/2/3-docker-usergroup.png)

### 4. Rejestracja w Docker Hub i pobranie sugerowanych obrazów

Docker Hub to publiczne repozytorium, w którym znajdują się gotowe obrazy systemów oraz aplikacji. Po rejestracji w Docker Hub pobrano sugerowane obrazy: `busybox` (lekki system operacyjny) oraz `fedora` (pełna dystrybucja Linuxa).

```bash
docker pull busybox  # Pobranie minimalnego obrazu systemu BusyBox
docker pull fedora  # Pobranie obrazu systemu Fedora
```

![Lista pobranych obrazów](ss/2/4-docker-login.png)

![Pobranie obrazu "busybox"](ss/2/4-docker-pull-busybox.png)

![Pobranie obrazu "fedora"](ss/2/4-docker-pull-fedora.png)

### 5. Uruchomienie kontenera z obrazu `busybox`

Kontener to odizolowane środowisko, które może być uruchomione z określonego obrazu. Uruchomiono kontener na podstawie obrazu `busybox` w trybie interaktywnym (`-it`), co pozwala na interakcję z systemem wewnątrz kontenera.

```bash
sudo docker run -it busybox  # Uruchomienie kontenera w trybie interaktywnym
busybox --help  # Wyświetlenie dostępnych komend BusyBox
```

![Uruchomienie kontenera busybox](ss/2/5-docker-run-hello.png)

![Sprawdzenie wersji systemu](ss/2/5-docker-version.png)

![Uruchomienie kontenera busybox](ss/2/5-docker-status.png)

### 6. Uruchomienie systemu w kontenerze (Fedora/Ubuntu)

W kolejnym kroku uruchomiono kontener z pełnym systemem Fedora i sprawdzono jego procesy.

```bash
docker run -it fedora /bin/bash  # Uruchomienie systemu Fedora w kontenerze
```

Sprawdzono listę działających kontenerów oraz procesy Dockera na hoście:

```bash
docker ps -a  # Wyświetlenie listy kontenerów
ps aux | grep docker  # Sprawdzenie procesów powiązanych z Dockerem
```

![Uruchomienie konteneru](ss/2/6-docker-run.png)

![Lista kontenerów](ss/2/6-docker-ps-1.png)

![Lista kontenerów](ss/2/6-docker-ps-2.png)

### 7. Aktualizacja pakietów w kontenerze

Po uruchomieniu systemu Fedora w kontenerze przeprowadzono aktualizację pakietów, co pozwala na uzyskanie najnowszych wersji oprogramowania.

```bash
dnf update -y  # Aktualizacja pakietów systemowych wewnątrz kontenera
```

![Aktualizacja pakietów](ss/2/7-docker-update.png)

![Wyjście z systemu](ss/2/7-docker-exit.png)

### 8. Stworzenie i uruchomienie własnego obrazu z Dockerfile

Dockerfile to plik konfiguracyjny definiujący, jak powinien wyglądać obraz Dockera. W tym przypadku stworzono obraz bazujący na `fedora:latest`, który instaluje `git` i klonuje repozytorium.

**Treść `Dockerfile`**:

```dockerfile
FROM fedora:latest
RUN dnf install -y git procps
WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
CMD ["/bin/bash"]
```

Zbudowano i uruchomiono obraz:

```bash
sudo docker build -t my-fedora-repo .  # Budowanie obrazu
sudo docker run -it my-fedora-repo /bin/bash  # Uruchomienie kontenera z nowego obrazu
```

![Zbudowanie obrazu](ss/2/8-docker-build.png)

![Uruchomienie obrazu](ss/2/8-docker-run.png)

### 9. Lista i czyszczenie kontenerów oraz obrazów

Po zakończeniu pracy usunięto nieużywane kontenery oraz obrazy, aby zwolnić miejsce na dysku.

```bash
sudo docker ps -a  # Wyświetlenie wszystkich kontenerów
sudo docker rm $(sudo docker ps -a -q -f status=exited)  # Usunięcie zakończonych kontenerów
sudo docker rmi $(sudo docker images -q)  # Usunięcie wszystkich obrazów
```

![Lista kontenerów](ss/2/9-docker-status.png)

![Usunięcie zakończonych kontenerów](ss/2/9-docker-rm.png)

![Usunięcie wszystkich obrazów Dockera](ss/2/9-docker-rmi.png)

---
## Lab 3. Dockerfiles, kontener jako definicja etapu

### 1. Wybór oprogramowania na zajęcia

Znalezienie repozytorium z kodem dowolnego oprogramowania (https://github.com/devenes/node-js-dummy-test) i sklonowanie go.

```bash
git clone https://github.com/devenes/node-js-dummy-test
```

![Sklonowanie repozytorium](ss/3/1-git-clone.png)

Przeprowadzenie buildu programu (+ doinstalowanie wymaganych zależności).

```bash
docker build -t lab3-dummy-test .
docker run -it lab3-dummy-test /bin/sh
```

![Zbudowanie obrazu przy użyciu gotowego Dockerfile](ss/3/2-docker-build.png)
![Uruchomienie kontenera w trubie interaktywnym](ss/3/3-docker-run.png)

```bash
npm install
npm run
npm test
```

![Instalacja zależności](ss/3/4-npm-install.png)
![Sprawdzenie możliwości uruchomienia](ss/3/5-npm-run.png)
![Uruchomienie testów](ss/3/6-npm-test.png)

Wykonanie `build` oraz `test` wewnątrz kontenera bazowego, w tym przypadku `node`. Uruchomienie kontenera z oficjalnego obrazu `node`, który zapewnia środowisko do uruchamiania aplikacji napisanych w Node.js. Następnie instalacja podstawowych narzędzi.

```bash
docker run -it node /bin/bash
apt update install -y git make
```

![Uruchomienie kontenera bazowego](ss/3/7-docker-run-apt.png)

Sklonowanie repozytorium.

```bash
git clone https://github.com/devenes/node-js-dummy-test app
```

![Sklonowanie repozytorium](ss/3/8-git-clone-app.png)

Instalacja wymagań.

```bash
cd app
npm install
```


![Instalacja zależności](ss/3/10-npm-install.png)

Uruchomienie testów.

```bash
npm test
```

![Uruchomienie testów](ss/3/11-npm-test.png)

Stworzenie dwóch plików `Dockerfile`, którę będą automatyzować wykonanie powyższych kroków.

Pierwszy kontener przeprowadza wszystkie kroki aż do `build`.

```dockerfile
FROM node

WORKDIR /app
RUN git clone https://github.com/devenes/node-js-dummy-test . 
RUN npm install

CMD ["npm", "start"]
```

Drugi kontener bazuje na pierwszym i uruchamia testy.

```dockerfile
FROM nodebuild

CMD ["npm", "test"]
```

Zbudowanie obrazów na podstawie `Dokcerfiles`.

![Budowa obrazu pierwszego kontenera](ss/3/12-docker-build.png)
![Budowa obrazu drugiegoo kontenera](ss/3/13-docker-build.png)

Weryfikacja poprawności wykonania testów.

![Przeprowadzenie testów](ss/3/14-docker-run-test.png)

Różnica między obrazem a kontenerem:

Obraz to definicja środowiska, która zawiera wszystkie zależności aplikacji. Innymi słowami - wzorzec do tworzenia kontenerów.

Kontener to uruchomiona instancja obrazu. Jest to działające środowisko aplikacji, w którym można wykonywać operacje.

Co pracuje w takim kontenerze?

W kontenerze działa środowisko Node.js wraz z aplikacją pobraną z repozytorium. Ostatecznie proces wdrażania w kontenerze polega na zbudowaniu środowiska, uruchomieniu aplikacji i przeprowadzeniu testów, co zostało zweryfikowane poprzez działające komendy Dockera i wyniki testów aplikacji.

---
## Lab 4. Dodatkowa terminologia w konteneryzacji, instancja Jenkins

### 1. Zachowywanie stanu

Aby zapewnić trwałość danych pomiędzy restartami kontenerów, wykorzystano mechanizm woluminów Docker. Utworzono dwa woluminy:

vol1 – przechowujący wejściowe pliki kodu źródłowego,
vol2 – przechowujący wyniki kompilacji.

Utworzenie woluminów: wejściowego i wyjściowego.

```bash
docker volume create vol1
docker volume create vol2
```

![Utworzenie woluminów: wejściowego i wyjściowego.](ss/4/1-docker-volume-create.png)

Uruchomienie kontenera z podpiętymi woluminami i instalacja zależności.

```bash
docker run -it -v vol1:/input -v vol2:/output ubuntu bash
```

![Uruchomienie kontenera z woluminami](ss/4/2-docker-run-vol.png)

Klonowanie repozytorium na wolumin (z hosta)

```bash
docker volume inspect vol1`
```

![Sprawdzenie szczegółów woluminu](ss/4/3-docker-volume-inspect.png)

Sklonowanie repozytorium do folderu który zawiera dane woluminu wejściowego ("Mountpoint").

```bash
git clone https://github.com/irssi/irssi.git /var/lib/docker/volumes/vol1/_data
```

![Sklonowanie repozytorium](ss/4/4-git-clone.png)

Zbudowanie programu w folderze woluminu wejściowego:

```bash
meson Build
```

![Wykonanie buildu](ss/4/5-build.png)

Przeniesienie builda do kontenera wyjściowego.

```bash
cp -r /input /output
```

![Przeniesienie builda](ss/4/6-cp.png)

Weryfikacja poprawności przeniesienia na hoście.

```bash
sudo ls /var/lib/docker/volumes/vol2/_data
```

![Weryfikacja poprawności przeniesienia](ss/4/7-sudo-ls.png)

Powtórka operacji tym razem z klonowaniem wewnątrz kontenera.

```bash
apt install -y git
git clone https://github.com/irssi/irssi.git
```

![Instalacja git'a](ss/4/8-apt-install.png)
![Sklonowanie repozytorium](ss/4/9-git-clone.png)

Alternatywnie, można byłoby zautomatyzować ten proces za pomocą `Dockerfile`, wykorzystując `RUN --mount`.

```bash
FROM ubuntu
WORKDIR /app
RUN --mount=type=volume,target=/input git clone https://github.com/irssi/irssi.git /input
RUN --mount=type=volume,target=/output meson /input /output
```





Instalowanie `iperf3` i uruchomienie serwera `iperf` w kontenerze. Uruchomienie konteneru z serwerem `iperf3` w tle, który będzie nasłuchiwał na porcie 5201. Używamy obrazu networkstatic/iperf3, aby uruchomić serwer iperf3 w kontenerze. Port 5201 jest otwarty na zewnątrz, aby umożliwić połączenie z serwerem.

```bash
docker run --rm -d --name iperf-server -p 5201:5201 networkstatic/iperf3 -s
```

![Uruchomienie kontenera z iperf3](ss/4/10-iperf3.png)

Połączenie z serwerem iperf3 z drugiego kontenera:

```bash
ip=$(sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' iperf-server)
sudo docker run -it --rm networkstatic/iperf3 -c $ip
```

![Połączenie z serwerem z drugiego kontenera](ss/4/11-ip-docker-run.png)

Tworzymy nową sieć mostkową o nazwie *bridge-net*, która będzie używana do połączenia kontenerów w izolowanej sieci:

```bash
docker network ls
docker network create -d bridge bridge-net
```

Uruchomienie serwera *iperf3* w kontenerze na nowej sieci mostkowej:

```bash
docker run -it --rm --name iperf-server --network bridge-net ubuntu
apt update && apt install -y iperf3
iperf3 -s
```

![Uruchomienie serwera iperf3](ss/4/12-docker-run-server.png)
![Uruchomienie serwera iperf3](ss/4/13-iperf3-s.png)

Uruchomienie klienta *iperf3* w drugim kontenerze, który łączy się z serwerem:

```bash
docker run -it --rm --name iperf-me2 --network bridge-net ubuntu
iperf3 -c iperf-server
```

![Uruchomienie instancji klienta iperf3](ss/4/14-run-me2.png)
![Przedstawienie przepustowości komunikacji](ss/4/15-iperf3-c.png)

Tworzymy nową sieć jenkins dla instancji *Jenkinsa*:

```bash
docker network create jenkins
```

![Stworzenie sieci jenkins](ss/4/16-docker-network.png)

Uruchamienie instancji Jenkinsa z dostępem do Dockera w kontenerze:

```bash
docker run --privileged --name jenkins-dind -d -p 8080:8080 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkins/jenkins:lts
docker ps
```

![Uruchomienie instancji](ss/4/17-jenkins-ps.png)

Weryfikacja poprawności instalacji, aby uzyskać dostęp do interfejsu logowania:

![Ekran logowania Jenkinsa](ss/4/18-jenkins-login.png)