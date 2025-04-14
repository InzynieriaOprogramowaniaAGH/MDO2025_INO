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

![tldr]()

Pobrano wymagane zależności:

```bash
npm ci
```

![dependencies]()

Uruchomiono testy jednostkowe:

```bash
npm test
```

![tests]()

