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

Na zdjęciu widać, iż merge się nie powiódł ze względu na brak uprawnień - wstawiam więc pull request-a na Githubie.

## Laboratorium 2 - Git,Docker

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