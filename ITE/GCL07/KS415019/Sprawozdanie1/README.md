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
### Wykonanie testu:

```bash
npm test
```
![Test kontenera](Zrzuty/LAB3/weryfikacja_npm_test.png)

## **Laboratorium 4**

## 1. Zachowywanie stanu
### Utworzono wolumin wejściowy in_vol i wyjściowy out_vol.

```bash
 sudo docker volume create in_vol
 sudo docker volume create out_vol
```
![Tworzenie woluminów](Zrzuty/LAB4/tworzenie_vol.png)

### Uruchomiono kontener bazowy oraz podłączono go do woluminów

```bash
 sudo docker run -it -v in_vol:/input -v out_vol:/output --name kontenerlab4 node:slim /bin/bash
```
![Kontener](Zrzuty/LAB4/zrzut.png)

### Sklonowanie repozytorium na wolumin wejściowy in_vol

Po sprawdzeniu lokalizacji pliku za pomocą:
```bash
 sudo docker volume inspect in_vol
```
![Inspect](Zrzuty/LAB4/inspect_invol.png)

W odpowiednim katalogu przełączono się na root, aby sklonować repozytorium bezpośrednio do woluminu:

```bash
 git clone https://github.com/devenes/node-js-dummy-test.git
```
![Klonowanie repo](Zrzuty/LAB4/git_clone1.png)

### Instalacja zależności w kontenerze

```bash
npm install
```
![Zaleznosci](Zrzuty/LAB4/zależności.png)

### Zapisanie plików na woluminie in_vol

```bash
cp -r /input/ /output
```
### Weryfikacja poprawności

```bash
ls -l /var/lib/docker/volumes/in_vol/_data
ls -l /var/lib/docker/volumes/out_vol/_data
```
![Weryfikacja](Zrzuty/LAB4/weryfikacja.png)

### Klonowanie repozytorium na wolumin wewnątrz kontenera

Instalacja gita wewnątrz kontenera:
```bash
sudo apt update && apt install git
```
![GIT](Zrzuty/LAB4/install_git.png)

Różnica w stosunku do poprzedniej metody jest taka, że wcześniej przechodziło się do /var/lib/docker/volumes/in_vol/_data na hoście i tam wykonywało git clone. Teraz wszystko odbywa się wewnątrz kontenera.

### Możliwość wykonania ww. kroków za pomocą docker build i pliku Dockerfile. 
Zamiast klonować repozytorium i budować projekt „ręcznie” wewnątrz kontenera, wszystkie te kroki można zdefiniować w pliku Dockerfile i uruchomić za pomocą polecenia docker build. Dzięki temu proces jest w pełni zautomatyzowany. Mechanizm RUN --mount pozwala np. bezpiecznie korzystać z kluczy SSH do prywatnych repozytoriów, unikając ich trwałego zapisania w warstwach obrazu. Dodatkowo, w wieloetapowej konfiguracji  można oddzielić etap instalacji i kompilacji od finalnego obrazu, co zmniejsza rozmiar i zwiększa bezpieczeństwo gotowego kontenera.

## 2. Eksportowanie portu


### Pobrano iperf3:
```bash
sudo dnf -y install iperf3
```
![Instalacja iperf3](Zrzuty/LAB4/install_iperf3.png)

###  Uruchomieno serwer wewnątrz nowego kontenera:
```bash
sudo docker run --name serwer1 -p 5201:5201 networkstatic/iperf3 -s
```
### Sprawdzono jego lokalizację:

```bash
sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' serwer1
```
![Sprawdzenie lokalizacji](Zrzuty/LAB4/inspect_serwer1.png)

### Nawiązano połączenie z drugiego kontenera:

```bash
sudo docker run --name klient1  networkstatic/iperf3 -c 172.17.0.3
```
![Połączenie](Zrzuty/LAB4/polaczenie2.png)
![Połączenie1](Zrzuty/LAB4/polaczenie.png)

### Utworzono sieć mostkową:

```bash
sudo docker network create --driver bridge siec
```
![Sieć](Zrzuty/LAB4/siec.png)

### Ponownie uruchomiono nowe kontenery z użyciem sieci:

Kontener serwerowy:
```bash
sudo docker run --rm -it --name serwer --network siec networkstatic/iperf3 -s
```
Kontener klienta:
```bash
sudo docker run --rm -it --name klient --network siec networkstatic/iperf3 -c serwer
```
![Połączenie2](Zrzuty/LAB4/polaczenie4.png)
![Połączenie3](Zrzuty/LAB4/polaczenie3.png)

Wykazano przepustowość na poziomie około 28.1 Gbit/s.

## 3. Instalacja Jenkinsa

W celu uruchomienia środowiska Jenkins z dostępem do Dockera, wykorzystano kontener w trybie uprzywilejowanym z mapowaniem portów 8080 i 50000 (komunikacja z agentami), a także woluminami do zachowania danych Jenkinsa (jenkins_home) oraz umożliwienia Jenkinsowi korzystania z Dockera hosta poprzez mapowanie gniazda /var/run/docker.sock.

```bash
sudo docker run --priviliged --name jenkins-dind -d -p 8080:8080 -p 50000:50000 \
-v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock \
jenkins/jenkins:lts
```
![Instalacja Jenkins](Zrzuty/LAB4/jenkins.png)

Kontener jenkins-dind został uruchomiony poprawnie.
```bash
sudo docker ps
```
![Dowód poprawnego uruchomienia](Zrzuty/LAB4/docker_ps.png)

Poprawne połączenie się i dostęp do ekranu logowania:

![Dowód poprawnego uruchomienia v2](Zrzuty/LAB4/jenkins_v2.png)
