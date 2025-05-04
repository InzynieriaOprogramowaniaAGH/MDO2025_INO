# Sprawozdanie nr 1
Julia Piśniakowska
System operacyjny: Fedora
Wizualizacja: Hyper-V
## Wstęp
Sprawozdanie przedstawia rezultaty wykonanych ćwiczeń 1-4 w ramach zajęć metodyki DevOps, skupiających się na wdrożeniu narzędzi do zarządzania wersjami i konteneryzacji. Początkowo przeprowadzono instalację systemu Fedora wraz z konfiguracją Git i uwierzytelniania SSH. W ramach pracy z repozytorium wykonano operacje klonowania, zarządzania gałęziami oraz synchronizacji zmian ze zdalnym repozytorium.
Następne etapy obejmowały instalację i konfigurację środowiska Docker do pracy z kontenerami. Zrealizowano zadania polegające na pobieraniu i uruchamianiu istniejących obrazów, tworzeniu własnych definicji w Dockerfile, budowaniu obrazów oraz testowaniu ich funkcjonalności. Przeanalizowano również zarządzanie procesami wewnątrz kontenerów. Sprawozdanie kończy się opisem automatyzacji procesów budowy i uruchamiania aplikacji przy użyciu narzędzia Docker Compose.

## LAB 1

### Instalacja Gita:
   ```bash
   sudo dnf install git -y
   ```
Repozytorium projektu zostało skopiowane przy użyciu polecenia 'git clone', korzystając początkowo z protokołu HTTPS

### Klonowanie repozytorium
```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO
```

### Wygenerowanie SSH bez hasła i z hasłem
![devops1](https://github.com/user-attachments/assets/fa86b741-0aa6-4e32-9d33-b4d1356203a9)
![devops2](https://github.com/user-attachments/assets/71c2f648-af5a-43a1-be79-64d72ca8e196)


### Git Hook
```bash
#!/bin/bash
commit_msg=$(head -n1 "$1")
pattern="^JP416100"

if [[ ! $commit_msg =~ $pattern ]]; then
  echo "ERROR: Commit message musi zaczynać się od 'JP416100'"
  exit 1
fi
```

## LAB 2

Pobranie obrazów hello-world, busybox, ubuntu lub fedora, mysql

Obrazy pobieramy komendą:
```docker pull <nazwa_obrazu>```

Pobranie obrazów hello-world, busybox, ubuntu, mysql

```docker pull hello-world```

```docker pull busybox```

```docker pull mysql```

```docker pull ubuntu```

Pobrane obrazy można wyświetlić poleceniem:

```docker images```
![image](https://github.com/user-attachments/assets/d0245840-845f-48ce-af76-fe862be37959)

* Efekt uruchomienia kontenera

Uruchamiamy nowy kontener Docker z obrazem BusyBox, który będzie działał w tle (demon) i będzie miał nazwę "busybox-container".

```docker run -d --name busybox-container busybox```

gdzie:

*docker run* - komenda do uruchamiania nowego kontenera na podstawie obrazu

*-d* - opcja, która oznacza tryb działania w tle 

*--name busybox-container* - nadaje kontenerowi nazwę *"busybox-container"*

*busybox* - nazwa obrazu, na podstawie którego zostanie uruchomiony kontener
### Odpalenie BusyBox
![devops_docker](https://github.com/user-attachments/assets/fdf54491-927c-46f9-9817-ba78e469f85f)
### Wersja BusyBox
![devops_docker2](https://github.com/user-attachments/assets/293150d5-1dd1-476f-b494-60395f02a704)
### Aktualizacja pakietów w kontenerze Fedory
![devops_docker4](https://github.com/user-attachments/assets/eb9c92b3-c486-45c1-b1a9-e7cd68c3ff10)
###Przygotowałam na zajęciach plik Dockerfile z następującą treścią i wrzuciłam go na repo:
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/JP416100/Dockerfile
```
# Użyj obrazu bazowego Fedora
FROM fedora:latest

# Zaktualizuj system i zainstaluj git
RUN dnf -y update && dnf -y install git

# Ustaw katalog roboczy
WORKDIR /app

# Skopiuj repozytorium z GitHuba (zmień na własne repozytorium)
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

# Ustaw domyślne polecenie, które zostanie uruchomione w kontenerze
CMD ["/bin/bash"]
```
### Usunięcie wszystkich obrazów
![wyczyszcone](https://github.com/user-attachments/assets/42013427-01cc-4707-acdc-ff5191d526a3)

## LAB 3

Wybrałam zaproponowane repo:
```https://github.com/devenes/node-js-dummy-test```

Repozytorium dysponuje otwartą licencją:
```https://github.com/devenes/node-js-dummy-test?tab=Apache-2.0-1-ov-file```

## Przeprowadzenie buildu w kontenerze

1. Wykonaj kroki `build` i `test` wewnątrz wybranego kontenera bazowego (```node``` dla Node.js)
	* uruchom kontener
	* podłącz do niego TTY celem rozpoczęcia interaktywnej pracy
	* zaopatrz kontener w wymagania wstępne (jeżeli proces budowania nie robi tego sam)

Uruchamiam kontener poleceniem:

```docker run -it nazwa_obrazu_kontenera node bash```

gdzie:

*-i* - umożliwia interaktywne wejście do kontenera (opzwala na wprowadzanie poleceń)

*-t* - umożliwia interaktywną pracę z konsolą

*--name* - opcją *name* nadaje nazwę nowoutworzonemu kontenerowi

Po zainstalowaniu zależności przechodzimy do uruchomienia testów jednostkowych za pomocą polecenia:

```npm test```

![testy](https://github.com/user-attachments/assets/c959a213-c246-439c-9c89-c22799d06481)

Wszystkie testy przeszły pomyślnie.

## Stwórzyłam dwa pliki Dockerfile automatyzujące kroki powyżej.
Dockerfile.test
```docker build -t test-image -f Dockerfile.test .```
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/JP416100/Dockerfile.test
![image](https://github.com/user-attachments/assets/dfa865ef-323e-46dc-81f2-10e008c667cf)
![image](https://github.com/user-attachments/assets/239262d3-956f-48c3-a3c3-ac3dc3fe284f)
```docker build -t build-image -f Dockerfile.build .```
Dockerfile.build
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/JP416100/Dockerfile.build
![image](https://github.com/user-attachments/assets/1a862501-9cb1-45cb-a25b-b2aaa0aa22ad)

## LAB 4
Utworzenie wolumenów input i output

```bash
docker volume create wejde
docker volume create wyjde
```
Sprawdzenie, czy wolumeny zostały utworzone:
![image](https://github.com/user-attachments/assets/72126be5-dc7c-47ee-91e9-236ea30cc8c3)

Uruchomienie kontenera bazowego node

```bash
docker run -it --name node-container \
  -v wejde:/app/input \
  -v wyjde:/app/output \
  node bash
```
![image](https://github.com/user-attachments/assets/69035a3e-21a1-4ab9-ab0e-d3342fe3c099)

Instalacja wymaganych narzędzi (bez gita!)
W kontenerze Ubuntu:
```apt update && apt install -y build-essential```
wychodzimy z kontenera za pomocą ```exit```

Klonowanie repozytorium na hoście i kopiowanie do woluminu

```bash
git clone https://github.com/lodash/lodash ~/input_repo
docker cp ~/input_repo node-container:/app/input
```
Sprawdzenie zawartości woluminu:
```bash
docker exec -it node-container ls /app/input
```
![image](https://github.com/user-attachments/assets/7b8a5847-672b-4040-b4eb-313dace275a0)


Uruchomienie builda w kontenerze node
```bash
docker exec -it node-container bash -c "
  cd /app/input &&
  npm install &&
  npm run build &&
  cp -r dist /app/output"
```

Sprawdzamy zawartość output:

```bash
docker run --rm -v output:/app busybox ls /app
```
![image](https://github.com/user-attachments/assets/394d6d3c-6d53-43a7-a37e-7719295e9231)

automatyzacja z Dockerfilem
![image](https://github.com/user-attachments/assets/145a1176-87ca-420b-b976-c48bb8512e09)

Zbudowanie obrazu Dockera
![image](https://github.com/user-attachments/assets/910a636d-3e19-4d0d-9401-7644c7bb7d49)

`docker inspect iperf-server | grep IP`: Sprawdzenie adresu IP kontenera `iperf-server` na hoście, aby użyć go do połączenia się z kontenerem z zewnątrz.
![image](https://github.com/user-attachments/assets/462d9943-e391-4d23-95d2-1fd813744d03)

Użycie IP maszyny wirtualnej
![image](https://github.com/user-attachments/assets/04fc9760-cd5a-4243-9573-91894a73e548)

```docker network create jenkins-net```
Tworzę nową sieć Docker o nazwie jenkins-net. Dzięki tej sieci kontenery mogą komunikować się ze sobą w izolowanym środowisku.
```docker run -d --name jenkins-dind --network jenkins-net --privileged docker:dind```
Uruchamiam kontener w tle (-d) o nazwie jenkins-dind.
Kontener korzysta z obrazu docker:dind (Docker-in-Docker), umożliwiającego uruchamianie instancji Dockera wewnątrz kontenera.
Kontener jest połączony z siecią jenkins-net i ma uprawnienia --privileged, co pozwala mu na dostęp do bardziej zaawansowanych funkcji systemowych (np. uruchamianie Dockera w Dockerze).
```docker volume create jenkins_home```
Tworzy wolumen Docker o nazwie jenkins_home, który służy do przechowywania danych Jenkins, takich jak konfiguracje, wtyczki i inne pliki. Wolumen zapewnia trwałość danych między restartami kontenera.
```docker run -d --name jenkins   --network jenkins-net   -p 8080:8080 -p 50000:50000   -v jenkins_home:/var/jenkins_home   jenkins/jenkins:lts```
Mapuje porty: 8080 na 8080 i 50000 na 50000, aby umożliwić dostęp do interfejsu Jenkins i komunikację z agentami.
Wolumen jenkins_home jest zamontowany do katalogu /var/jenkins_home w kontenerze, co zapewnia przechowywanie danych konfiguracyjnych Jenkinsa.
To wszystko tworzy środowisko Jenkins z Dockerem w środku, umożliwiając uruchamianie i zarządzanie zadaniami CI/CD.
![image](https://github.com/user-attachments/assets/09f091dd-7228-4533-bdf8-0999d0b4f744)
