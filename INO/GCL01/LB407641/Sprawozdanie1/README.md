# Sprawozdanie nr 1

Na zainstalowanej maszynie wirtualnej Fedora zainstalowano klienta Git i obsługę kluczy SSH

![Fedora w Virtual Box](L1.JPG)

```bash
sudo dnf install git
```

Sklonowano repozytorium przedmiotowe:

```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

Utworzono dwa klucze SSH przy pomocy komendy i skonfigurowano je jako metodę dostępu do githuba:
```bash
ssh-keygen -t ed25519 -C "2013burl01@gmail.com"
```

![Klucze SSH](SSHs.JPG)

Rozpoczęto pracę na gałęzi main/GCL01/LB407641:

![inicjały + indeks branch](branch.JPG)

Utworzono katalog w grupie GCL01:
```bash
mkdir LB407641
```
![katalog LB407641](katalog.JPG)

Stworzono Git hooka, który weryfikuje commit message (commit ma rozpoczynać się od inicjałów oraz numeru indeksu):

```bash
commit_message=$(cat "$1")

case "$commit_message" in
  "$prefix"*) 
    echo "commit poprawny"
    exit 0 ;;
  *) 
    echo "commit nie zaczyna sie od $prefix"
    exit 1 ;;
esac
```

# Zajęcia 2
Zainstalowano Docker na Fedorze

```bash
sudo dnf -y install dnf-plugins-core
```

Pobrano obrazy `hello-world`, `busybox`, `ubuntu`, `fedora`, `mysql`

Skorzystano z pomocy LLM (ChatGPT), by pokazać daty pobrań kontenerów. Treść zapytania: 

``Jak pokazać kiedy obrazy zostały pobrane?``


Wykorzystano komendę:
```bash
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.CreatedAt}}"
```

Otrzymano wynik:

![obrazy + data](S2_pngs/docker_images.JPG)

PID1 w kontenerze

![PID1 + procesy](S2_pngs/system_and_processes.JPG)

Zaktualizowano pakiety:

```bash
dnf update -y
```

![pakiety](S2_pngs/docker_pakiety.JPG)

Stworzono Dockerfile bazujący na ubuntu:

```bash
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y git && apt clean

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /repo

WORKDIR /repo
```

Zbudowano i uruchomiono obraz:

![build + run](S2_pngs/docker_build_run.JPG)

Sprawdzono czy udało się pobrać repo:

![repo](S2_pngs/docker_is_repo.JPG)

Pokazanie uruchomionych kontenerów:

```bash
sudo docker ps -a --format "table {{.Image}}\t{{.Status}}"
```

![uruchomione](S2_pngs/docker_run_inactive.JPG)

Wyczyszczono kontenery:

```bash
sudo docker rm $(sudo docker ps -aq)
```

![wyczyszczone kontenery](S2_pngs/docker_remove.JPG)

Wyczyszczono obrazy:

```bash
sudo docker rmi $(sudo docker images -q)
```

![wyczyszczone obrazy](S2_pngs/rmi.JPG)

# Sprawozdanie 3

Pobrano repo `tldr`. Projekt ma na celu zapewnienie prostszego i przystępniejszego manuala niż linuksowy. Jest na licencji MIT oraz zawiera testy jednostkowe (npm).

![clone](S3_pngs/git_clone.JPG)

![tldr](S3_pngs/catalogs.JPG)

Pobrano wymagane zależności:

```bash
npm ci
```

![dependencies](S3_pngs/dependencies.JPG)

Uruchomiono testy jednostkowe:

```bash
npm test
```

![tests](S3_pngs/tests.JPG)

Docker build:

![docker->build](S3_pngs/docker_build.JPG)

Uruchomienie dockera:

![docker](S3_pngs/docker.JPG)

Te same czynności w dockerze:

![docker clone](S3_pngs/docker_clone.JPG)

Instalowanie zależności

![docker install](S3_pngs/docker_install.JPG)

Plik Dockerfile (wszystkie kroki do builda):

```bash
FROM node:18

WORKDIR /app
RUN apt update && apt install -y make git

RUN git clone https://github.com/tldr-pages/tldr.git .
RUN npm install
RUN npm markdown
```

Plik Dockerfile.test:

```bash
FROM node:18

WORKDIR /app
COPY --from=build /app /app

RUN npm test
```

# Sprawozdanie 4

Stworzono woluminy - wejściowy/wyjściowy:

```bash
docker volume create input_volume
docker volume create output_volume
```

![volumes](S4_pngs/in_out.JPG)

oraz kontener bazowy:

```bash
docker run -it --name base_container -v input_volume:\input -v output_volume:\output ubuntu:22.04
```

![volumes](S4_pngs/base_container.JPG)

instalacja wymaganych zależności:

```bash
apt update && apt install -y build-essential
```

![dependencies](S4_pngs/docker_dependencies.JPG)

klonowanie repo spoza kontrolera na wolumin wejściowy:

![clone](S4_pngs/volume_clone.JPG)


# .....

# Eksponowanie portu (iperf3)

```bash
sudo docker run -it --rm --name iperf-server-2 -p 5201:5201 networkstatic/iperf3 -s
```

![create](S4_pngs/iperf3_ip.JPG)

![listening](S4_pngs/server.JPG)

Połączono się spoza kontenera:

![connection](S4_pngs/connection.JPG)

Stworzono sieć:

```bash
docker network create --driver bridge custom_net
```

![bridge](S4_pngs/bridge.JPG)

Uruchomiono serwer i klient w tej samej sieci:

![C-S](S4_pngs/server_client.JPG)