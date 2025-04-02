# Sprawozdanie 1
**Autor:** Paweł Socała  
**System:** Fedora  
**Wirtualizacja** VirtualBox

<br>

# Lab 1 - Wprowadzenie, Git, Gałęzie, SSH

## Klonowanie repozytorium (https i ssh)

Na początku zainstalowano gita oraz obsługę kluczy ssh. Następnie sklonowano repozytorium przedmiotowe za pomocą https i personal access data.

<br>

Wersja https:
```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

![Klonowanie repozytorium https](lab_1/git_clone.png)

<br>

Wersja ssh:
Najpierw stworzono dwa klucze ssh: jeden z hasłem, a drugi bez hasła.
```bash
ssh-keygen -t ed25519 -C "psocala12@gmail.com"
```

![klucz 1](lab_1/first_token_with_pass.png)


```bash
ssh-keygen -t ecdsa -b 521 -C "psocala12@gmail.com"
```

![klucz 2](lab_1/second_token_no_pass.png)

<br>

Po stworzeniu kluczy dodano go do prywatnych kluczy na stronie github. Kolejno uruchomiono agenta ssh oraz dodano do niego klucz co pozwoliło na uwierzytelnienie użytkownika oraz sklonowanie repozytorium przy użyciu ssh.


```bash
eval "$(ssh-agent -s)"
Agent pid 1054
ssh-add ~/.ssh/id_ed25519

git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

![agent ssh](lab_1/authentification_ssh.png)

![Klonowanie repozytorium ssh](lab_1/git_clone_ssh.png)

<br>

## Konfiguracja F2A
Konfiguracja F2A:

![F2A](lab_1/F2A.png)

<br>

## Git hook oraz push
Przełączenie na gałąź main, a następnie gałąź GCL07. Po przełączeniu utworzono prywatną gałąź PS417836.

```bash
git checkout main
git checkout GCL07
git branch
git checkout -b PS417836
```

![PS417836](lab_1/stworzenie_mojej_gałęzi.png)

<br>

Następnie stworzono odpowiedni katalog oraz git hooka `commit-msg`, który odpowiada za prawidłową nazwę commitów. 

```bash
mkdir -p GCL07/PS417836
cd GCL07/PS417836
nano commit-msg
chmod +x commit-msg
cp commit-msg ../../.git/hooks/commit.msg
```

![treść hooka](lab_1/skrypt_git_hooks.png)

![treść hooka](lab_1/treść_hooka.png)


<br>

Na końcu ćwiczeń zatwierdzono i spushowano zmiany do gałęzi grupowej.

```bash
git commit -m "PS417836 sprawozdanie i git hook"
git push origin PS417836
```

![push](lab_1/push.png)

<br>

# Lab 2 - Git, Docker

## Instalacja Dockera
Na początku ćwiczeń zaistalowano dockera w systemie Fedora oraz zarejestrowano się w Docker Hub. 

```bash
sudo docker install -y docker
```

![docker install](lab_2/docker_instalacja.png)

![docker hub](lab_2/docker_hub.png)

<br>

## Pobranie obrazów
Kolejnym krokirm było pobranie obrazów: hello-world, busybox, ubuntu lub fedora i mysql. Po pobraniu sprawdzono dostępne obrazy. 

```bash
sudo docker pull hello-world
sudo docker pull ubuntu
sudo docker pull mysql
sudo docker pull fedora
sudo docker pull busybox

sudo docker images
```
![obrazy](lab_2/docker_hello_world_instal.png)
![obrazy](lab_2/docker_images.png)

<br>

## Uruchomienie kontenera z obrazem busybox
Uruchomiono kontener interaktywnie oraz sprawdzono wersję.

```bash
sudo docker run -it busybox
busybox --version               # w kontenerze
```
![busybox](lab_2/busybox_uruchomienie_weersja.png)

<br>

## System w kontenerze
Uruchomiono obraz Fedory w systemie Fedora. Następnie zaprezentowano procesy oraz zaktualizowano pakiety.

```bash
sudo docker run -it fedora
dnf install procps -y       # w kontenerze
ps -aux                     # w kontenerze
```

![fedora](lab_2/fedora_w_kontenerze.png)
![fedora](lab_2/procesy.png)
![fedora](lab_2/aktualizacja_pakietow.png)

<br>

## Własny Dockerfile
Stworzono plik `Dockerfile`, który następnie zbudowano oraz uruchomiono. Na końcu sprawdzono czy repozytorium przedmiotowe znajduje się wewnątrz kontenera. Plik Dockerfile znajduje się w folderze `lab_2`. 

```bash
sudo docker build -t fedora_my_image
sudo docker run -it fedora_my_image
ls /MMDO2025_INO                    # w kontenerze
```

![my_docker](lab_2/Dockerfile_treść.png)

![my_docker](lab_2/zbudowanie_fedora.png)

![my_docker](lab_2/uruchomienie_fedora.png)

<br>

## Wyczyszczenie aktywnych kontenerów
Na koniec ćwiczeń sprawdzono aktywne kontenery, wyczyszczono je oraz aktywne obrazy. 

*Niestety zgubiłem screeny z widocznym czyszczeniem obrazów oraz kontenerów.*

```bash
sudo docker ps
sudo docker rm fedora_my_image
sudo docker image prune
```

![kontenery](lab_2/aktywne_kontenery.png)

<br>

# Lab 3 - Dockerfiles, kontener jako definicja etapu
Do wykonania ćwiczeń wybrano repozytrium irssi: https://github.com/irssi/irssi

<br>

## Repozytorium irssi poza kontenerem
Na początku ćwiczeń sklonowano repozytroium irssi poza kontenerem, zainstalowano potrzebne zależności oraz przeprowadzono build programu wraz z testami.

```bash
git clone https://github.com/irssi/irssi.git
cd irssi
sudo dnf install -y make automake autoconf gcc-c__ pkg-config ncurses-devel openssl-devel curl-devel perl-devel glib2-devel

ninja -C build
ninja -C build test
```
![irssi](lab_3/clone_poza_kontenerem_1.png)

![irssi](lab_3/meson_build_poz_kontenerem.png)

![irssi](lab_3/itssi_test_poza_kontenerem.png)

<br>

## Build irssi za pomocą stworzonych Dockerfiles

Na początku stworzono pliki `Dockerfile` oraz `Dockerfile.test` (bazujący na `Dockerfile`). Pliki znajdują się w folderze `lab_3/docker_irssi`. 


![dockerfile](lab_3/dockerfile_irss.png)

![dockerfile_test](lab_3/dockerfile_irssi_test.png)

<br>

Następnie wykonano build oraz testy na kontenerze.

```bash
sudo docker run -it --name irssi-build-container irssi-docker /bin/bash

sudo docker build -t irssi-test -f Dockerfile.test .
```
![dockerfile_build](lab_3/irrsi_build_run.png)

![dockerfile_test](lab_3/irssi_test_build.png)

> W samym kontenerze pracuje instancja systemu oraz wszystkie zależności i aplikacje potrzebne do działania. 


<br>

# Lab 4 - Dodatkowa terminologia w konteneryzacji, instancja Jenkins

## Stworzenie woluminów oraz kontenera bazowego
Na początku ćwiczeń stworzono dwa woluminy: wejscie oraz wyjscie.

```bash
sudo docker volume create wejscie
sudo docker volume create wyjscie
```
![woluminy](lab_4/stworzenie_woluminów.png)

Następnie stworzono kontener bazowy `Dockerfile.irssivolumes` do połączenia go z woluminami. Na tym etapie kontener nie posiada zależności git ani repozytrium irssi.

![irsivolumes_docker](lab_4/docker_volumes.png)

<br>

## Sklonowanie repozytrium na wolumin wejściowy
Na początku tego kroku przeniesiono sie do folderu `/_data` wewnątrz woluminu i sklonowano do niego repozytrium irssi. Kolejno wykonano build oraz run kontenera razem z woluminami.

```bash
cd /var/lib/docker/volumes/wejscie/_data
git clone https://github.com/irssi/irssi.git

sudo docker build -t irssi-volumes -t Dockerfile.irssivolues .

sudo docker run -it --rm wejscie:/input -v wyjscie:/output irssi-volues /bin/bash
```
![run](lab_4/git_clone_w_volume_wejscie.png)

![build](lab_4/build_docker_bez_git.png)

![run](lab_4/docker_bez_git_run.png)

<br>

## Zapisanie plików do woluminu wyjściowego
Aby zbudowane pliki były dostępne poza kontenerem zapisano je w woluminie wyjściowym. Na końcu sprawdzono czy pliki rzeczywiście dostępne są poza kontenerem.

```bash
ninja -C /output

ls -ls /var/lib/docker/volumes/wyjscie/_data
```
![wyjscie](lab_4/zapisanie_plików.png)

![wyjscie](lab_4/sprawdzenie.png)

<br>

## Eksponowanie portu, serwer iperf3
Na początku uruchomiono wewnątrz kontenera serwer iperf3, połączono się z nim za pomocą drugiego kontenera oraz zbadano ruch.

```bash
cd lab_4
ls
docker pull networkstatic/iperf3
docker run -it -d --name iperf3-server -p 5201:5201 networkstatic/iperf3 -s

docker run -it --name iperf3-client networkstatic/iperf3 -c 172.17.0.2
```
![wyjscie](lab_4/iperf_docker_pull_run.png)

![wyjscie](lab_4/połączenie_z_kontenerem_clienta.png)

<br>

## Eksponowanie portu, stworzenie sieci
W tym etapie stworzono customową sieć oraz dodano do niej nowe kontenery.

```bash
docker rn -d --name iperf3-server-net iperf3-network networkstatic/iperf3 -s

docker run -it --name iperf3-client-net --network iperf3-network networkstatic/iperf3 -c iperf3-server-net
```
![kontenery](lab_4/tworzenie_kontenerów_w_network.png)

<br>

## Przepustowość komunikacji
Sprawdzono przepustowość komunikacji między kontenerami w sieci poprzez ukazanie logów.

```bash
docker logs iperf3-server-net
```
![kontenery](lab_4/przepustowosc.png)

<br>

## Jenkins, inicjalizacja
Na początku zapoznano się z dokuentacją Jenkinsa, a następnie przeprowadzono instalację. Plik `Docker.jenkins` znajduje się w folderze `lab_4`.

```bash
docker network create jenkins
docker build -f Dockerfile.jenkins -t myjenkins-blueocean:2.492.2-1 .

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

  docker ps -a
```
Stworzenie sieci Jenkins:
![jenkins](lab_4/jenkins_network_i_DIND.png)

Stworzenie obrazu:
![jenkins](lab_4/jenkins_build.png)

Uruchomienie kontenera z pomocą DIND:
![jenkins](lab_4/jenkins_kontener_run.png)

Sprawdzenie czy kontener jest uruchomiony:
![jenkins](lab_4/działające_kontenery.png)

<br>

## Jenkins w przeglądarce
W tym etapie otworzono Jenkinsa w przeglądarce za pomocą adresu: https://localhost:8080


![jenkins](lab_4/jenkins_1.png)  
<br>
Następnie zdobyto hasło do logowania i zalogowano się na stronie.

```bash
sudo cat /var/lib/docker/volumes/jenkins-data/_data/secret/initialAdinPassword
```
![jenkins](lab_4/jenkins_hasło.png)

![jenkins](lab_4/jenkins2.png)
