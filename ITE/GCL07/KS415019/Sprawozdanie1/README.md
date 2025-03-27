# Sprawozdanie z laboratoriów 
Karolina Starzec

## **Laboratorium 1**

## 1. Instalacja Gita i obsługi kluczy SSH
Zainstalowano system kontroli wersji Git oraz skonfigurowano obsługę kluczy SSH na systemie Fedora. Następnie dla potwierdzenia poprawności konfiguracji, wykonałam komendy:

### Sprawdzenie wersji Gita
```bash
git --version
```
![Wersja Gita](Zrzuty/LAB1/git_version.png)
### Sprawdzenie połączenia SSH z GitHubem
```bash
ssh -T git@github.com
```
![Sprawdzenie połączenia SSH z GitHubem](Zrzuty/LAB1/ssh_t.png)

## 2. Klonowanie repozytorium prze SSH

Po udanej konfiguracji klucza SSH, sklonowano repozytorium: 

```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
## 3. Tworzenie gałęzi

### Przełączenie się na gałąź mojej grupy:
```bash
git checkout main
git checkout GCL07
```
### Utworzenie własnej gałęzi `KS415019` na bazie gałęzi grupowej:

```bash
git checkout -b KS415019
```
![Sprawdzenie gałęzi](Zrzuty/LAB1/git_branch.png)

## 4. Praca na mojej gałęzi

W folderze grupy `GCL07` utworzono podkatalog `KS415019`.

### Napisano Git Hooka `commit-msg` zawierający następującą treść:

```bash
#!/bin/sh
MSG_FILE=$1
COMMIT_MSG=$(cat "$MSG_FILE")

if ! echo "$COMMIT_MSG" | grep -q "^KS415019"; then
  echo "Błąd: Każdy commit message musi zaczynać się od \"KS415019\"" >&2
  exit 1
fi

exit 0
```
### Umieszczenie hooka w katalogu oraz aktywacja
Plik `commit-msg` został dodany do katalogu `KS415019`, a następnie skopiowany do `.git/hooks/` i nadano mu uprawnienia do wykonania:

```bash
cp commit-msg ../../../.git/hooks/
chmod +x ../../../.git/hooks/commit-msg
```
![Dodanie i chmod hooka](Zrzuty/LAB1/chmod.png)

### Test działania hooka – niepoprawny commit

Próba wykonania commita bez prefiksu zakończyła się błędem:

```bash
git commit -m "ok"
```
![Błędny commit](Zrzuty/LAB1/zly_commit.png)

### Test działania hooka – poprawny commit

Wykonano commit z poprawnym prefixem:

```bash
git commit -m "KS415019: dodanie hooka"
```
## 4. Wysłanie zmian do zdalnego repozytorium

```bash
git push --set-upstream origin KS415019
```
![Wysłanie zmian do zdalnego repozytorium](Zrzuty/LAB1/push.png)

## **Laboratorium 2**

## 1. Instalacja Dockera
Docker został zainstalowany na systemie Fedora.

```bash
sudo dnf install -y docker
```
## 2. Rejestracja w DockerHub i przeglądanie obrazów
Zarejestrowano konto i zapoznano się z obrazami: `ubuntu`, `busybox`, `fedora`, `mysql`, `hello-world`.

```bash
docker login
```
![Logowanie do Dockera](Zrzuty/LAB2/docker_login.png)

## 3. Pobranie obrazów
```bash
sudo docker pull hello-world
sudo docker pull busybox
sudo docker pull ubuntu
sudo docker pull fedora
sudo docker pull mysql
```
![Pobieranie obrazów](Zrzuty/LAB2/pobieranieobrazów2.png)


## 4. Uruchomienie kontenera z busybox
```bash
sudo docker run busybox echo "Kontener busybox działa!"
``` 
![Uruchomienie kontenera busybox](Zrzuty/LAB2/uruchomieniekontenera.png)

## 5. Interaktywne połączenie z kontenerem busybox i wywołanie numeru wersji

```bash
sudo docker exec -it busybox sh
```
![Uruchomienie kontenera busybox](Zrzuty/LAB2/busybox_v2.png)

## 6. Uruchomienie systemu w kontenerze (Ubuntu)
```bash
sudo docker run --name ubuntu -dit ubuntu bash
sudo docker ps
```
 
![Kontener Ubuntu](Zrzuty/LAB2/ubuntu_v2.png)

### PID1 w kontenerze:

```bash
sudo docker exec -it ubuntu bash
ps aux
```
  
![PID1 w kontenerze](Zrzuty/LAB2/PID1_ubuntu.png)

### Procesy dockera na hoście:

```bash
ps aux | grep docker
```
![Procesy docker na hoście](Zrzuty/LAB2/grep_docker_ubuntu.png)

### Aktualizacja pakietów w kontenerze Ubuntu:

```bash
apt update && apt upgrade -y
```
![Aktualizacja pakietów](Zrzuty/LAB2/aktualiacja_pakietów.png)

## 7. Stworzenie pliku Dockerfile

```bash
FROM ubuntu:latest

LABEL maintainer="Karolina Starzec"

RUN apt update && apt install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

CMD ["bash"]
```

## 8. Budowa własnego obrazu z Dockerfile

```bash
sudo docker build -t obraz .
```
 
![Budowanie obrazu](Zrzuty/LAB2/build_t_obraz.png)

## 9. Uruchomienie kontenera z własnego obrazu

```bash
sudo docker run --name Kontener -it obraz
```
### Weryfikacja obecności repozytorium i gita

```bash
ls /app
git --version
```
 
![Repozytorium i git](Zrzuty/LAB2/lsapp_gitversion.png)

## 10. Usunięcie kontenerów i wyczyszczenie obrazów:
### Wyświetlenie obrazów:

```bash
sudo docker images
```
![Wyświetlenie obrazów](Zrzuty/LAB2/docker_images.png)

### Usunięcie kontenerów:
```bash
sudo docker stop $(sudo docker ps -q)
sudo docker rm $(sudo docker ps -aq)
```
### Usunięcie obrazów:

```bash
sudo docker rmi $(sudo docker images -q)
```

![Usuwanie kontenerów i obrazów](Zrzuty/LAB2/usuwanie_obrazów.png)

## **Laboratorium 3**

## 1. Wybór repozytorium

Wybrane repozytorium: **[dummy-nodejs-todc](https://github.com/todogroup/dummy-nodejs-todc)**  
## 2. Klonowanie repozytorium i instalacja zależności

### Klonowanie repozytorium
```bash
git clone https://github.com/todogroup/dummy-nodejs-todc.git
```
![git clone](Zrzuty/LAB3/git_clone.png)

### Instalacja zależności
```bash
cd dummy-nodejs-todc
sudo dnf install nodejs
sudo npm install
```
![dnf install](Zrzuty/LAB3/install_nodejs.png)
![npm install](Zrzuty/LAB3/npm_install.png)

### Weryfikacja wersji node i npm

```bash
node --version
npm --version
``` 
![Wersje Node i npm](Zrzuty/LAB3/sprawdzenie_wersji.png)

### Uruchomienie testów 

```bash
npm test
```
![npm test](Zrzuty/LAB3/npm_test.png)

## 3. Praca w kontenerze (Node.js)

```bash
sudo docker run -it --rm node:22.14.0 bash
```
 
![Uruchomienie kontenera](Zrzuty/LAB3/uruchomienie_kontenera.png)

### Wewnątrz kontenera:
Sklonowanie repozytorium:
```bash
git clone https://github.com/todogroup/dummy-nodejs-todc.git
```
Instalacja zależności:
```bash
npm install
```
![Zależności](Zrzuty/LAB3/npm_install_v2.png)

Test dla potwierdzenia poprawności działania aplikacji:
```bash
npm test
```
![Test w kontenerze](Zrzuty/LAB3/npm_test_v2.png)

## 6. Stworzenie dwóch plików Dockerfile 

### Dockerfile.build
Pierwszy Dockerfile.build ma za zadanie przygotować środowisko do kompilacji aplikacji. Obejmuje to wybór obrazu bazowego (np. node:22.14.0), utworzenie katalogu roboczego, pobranie kodu źródłowego z repozytorium, instalację wymaganych zależności oraz wykonanie procesu budowania aplikacji, jeśli jest on zdefiniowany.

```Dockerfile
FROM node:22.14.0
RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test
RUN npm install
```
### Budowanie kontenera buildowego:
```bash
sudo docker build -t kontener_build -f ./Dockerfile.build .
```
![Budowanie kontenera buildowego](Zrzuty/LAB3/kontener_build.png)

### Dockerfile.test
Drugi Dockerfile.test służy do uruchomienia testów.

```Dockerfile
FROM kontener_build
RUN npm test
```
### Budowanie kontenera testowego:

```bash
sudo docker build -t kontener_test -f ./Dockerfile.test .

```
![Budowanie kontenera testowego](Zrzuty/LAB3/kontener_test.png)

## 7. Sprawdzenie działania

### Sprawdzeie listy dostępnych obrazów:

```bash
sudo docker images
```
![Sprawdzenie listy](Zrzuty/LAB3/docker_images.png)

### Uruchomienie kontenera buildowego w trybie interaktywnym:

```bash
sudo docker run -it --rm kontener_build bash
```

### Sprawdzenie katalogu node_modules:

```bash
ls -l node_modules
```
![Sprawdzenie](Zrzuty/LAB3/node_modules.png)

### Uruchomienie kontenera testowego w trybie interaktywnym:

```bash
sudo docker run --rm kontener_test bash
```
### Wyonanie testu:

```bash
npm test
```
![Test kontenera](Zrzuty/LAB3/weryfikacja_npm_test.png)