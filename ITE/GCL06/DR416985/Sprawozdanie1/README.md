# Sprawozdanie 1 – DR416985
# LAB1
## Opis

W ramach pierwszego zadania wykonano pełną konfigurację środowiska Git, SSH oraz repozytorium zdalnego z uwzględnieniem wymagań dotyczących kluczy, 2FA i hooków.

---

## 1. Instalacja Gita i SSH
```sh
git --version
```
```sh
ssh -V
```
```sh
ls
```

![sreen1](./ss1.png)

## 2. Klonowanie repozytorium przez HTTPS

```sh
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
![screen](./gitclone.png)

## 3. Generowanie kluczy SSH

```sh
ssh-keygen -t ed25519 -C "drusin@student.agh.edu.pl"
ssh-keygen -t ecdsa -b 521 -C "drusin@student.agh.edu.pl"
```

![screen](./gkluczy.png)


## 4. Dodanie klucza do GitHuba

Dodano klucz publiczny id_ed25519.pub do ustawień GitHuba.


![screen](./ss4.png)



## 5. Klonowanie repozytorium przez SSH

```sh
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```


## 6. Przejście na swojego brancha
```sh
git checkout DR416985
```

![screen](./DR41.png)


## 7. Włączenie 2FA


## 9. Hook commit-msg

```sh
#!/bin/bash
MESSAGE=$(cat $1)
if [[ ! $MESSAGE =~ ^DR416985 ]]; then
  echo "ERROR: Commit message must zaczynać się od 'DR416985'"
  exit 1
fi
```

Nadanie uprawnien

![screen](./chmod.png)



## 10. Test działania hooka

```sh
chmod +x .git/hooks/commit-msg
git add .
git commit -m "test"
git add .
git commit -m "DR416985.."

```
![screen](./testhook.png)


## 11. Push zmian
```sh
git push origin DR416985
```
![screen](./push.png)

# Lab 2

## Zainstalowanie dockera

```sh
sudo dnf install docker -y
```
![screen](./docker.png)
## Pobranie wymaganych obrazów

```sh
docker pull hello-world
docker pull busybox
docker pull ubuntu
docker pull mysql
```

![screen](./pull.png)

## Uruchomienie kontenerów
```ssh
docker run ubuntu
```

### Interaktywne uruchomienie
```sh
docker run -it ubuntu
```

![screen](./run.png)
## Tworzenie dockerfile

## Budowanie i urucomienie obrazu

```sh
docker build -t ubuntu .
```

![screen](./ubuntu.png)

## Czyszczenie konternerów i obrazów

```sh
dcoker rm $(docker ps -aq)
docker rmi $(docker imgaes -q)
```
![screen](./u1.png)
Jeden z konteów był wciąż uruchomiony więc się nie usunoł

```sh
dcoker rm -f c10e92bac8f0
```
![screen](./u2.png)

# LAB 3

### Oprogramowanie
**irssi, Node-js-dummy-test**

### klnowanie repo 
```sh
git clone https://github.com/irssi/irssi.git
```

### Instalacja potrzebnych zależności 

```sh
 dnf install -y meson gcc glib2-devel openssl-devel ncurses-devel utf8proc-devel perl-ExtUtils* cmake libgcrypt-config libgcrypt libotr-devel cap_enter-devel pkg-config
```
### Zbudowanie aplikacji i testy

```sh
meson build
ninja test
```
### Zbudowanie irssi w kontenerze

```sh
dokcer run -it --rm fedora bash
git clone https://github.com/irssi/irssi.git
dnf -y install meson gcc glib2-devel openssl-devel ncurses-devel utf8proc-devel cmake pkg-config libssl-devel perl-devel perl-ExtUtils*
meson build
ninja -C build
```

### Dockerfile



**irssi-build.Dockerfile**

```sh
 FROM fedora
 RUN dnf -y update && dnf -y install git meson ninja* gcc glib2-devel utf8proc* ncurses* perl-Ext*
 RUN git clone https://github.com/irssi/irssi.git
 WORKDIR /irssi
 RUN meson Build
 RUN ninja -C /irssi/Build
```

**irssi-test.Dockerfile**

```sh
 FROM irssi-builder
 WORKDIR /irssi/Build
 RUN ninja test
```

### Budowanie obrazu

```sh
docker build -t irssi-builder -f ./irssi-build.Dockerfile .
```

**Kontener uruchamiamy poleceniem**

```sh
docker run irssi-builder
```
**Testujemy kontener**

```sh
 docker build -t irssi-tester -f ./irssi-test.Dockerfile .
```

**Podgląd zbudowanych obrazów kontenera**


### Aplikacja w Nodzie

**Interaktywne uruchomienie kontenera**

```sh
sudo docker run --rm -it node /bin/bash
```
**Akutalizacja pakietów, instalacja zależności + testy**

```sh
apt-get update
npm install
npm run test
```

### Dockerfile

**node-build.Dockerfile**

```sh
FROM node
RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test
RUN npm install
```
**node-test.Dockerfile**

```sh
FROM node-builder
RUN npm test
```

**node-deploy.Dockerfile**
```sh
FROM node-builder
CMD ["npm","start"]
```

**Budowanie obrazów**
```sh
docker build -t node-builder -f ./node-build.Dockerfile .
docker build -t node-tester -f ./node-test.Dockerfile .
docker build -t node-deploy -f ./node-deploy.Dockerfile .
```

**uruchomienie aplikacji**

```sh
docker run --rm node-deploy
```

**Podglą obrazów konternerów**

# LAB 4

