# Zajęcia 05
## Przygotowanie
### Test uprzednio utworzonych kentenerów: budującego i testującego.

![Opis obrazka](lab5_screenshots/1.png)

![Opis obrazka](lab5_screenshots/1.png)

### Utworzenie i konfiguracja Jenkins
Uruchomiono kontener DIND, zbudowano obraz jenkinsa przy użyciu Dockerfila podanego w dokumentacji, stworzono kontener

![Opis obrazka](KM415081/Sprawozadnie1/lab4_screenshots/10.png)

![Opis obrazka](KM415081/Sprawozadnie1/lab4_screenshots/11.png)

Dockerfile.jenkins
```sh
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
Uruchomiono jenkins w przeglądarce na porcie 8080 dzięki odpowiedniej konfiguracji kontenerów, odblokowano kodem z konsoli, utworzono konta admina i zainstalowano rekomendowane pluginy.

![Opis obrazka](KM415081/Sprawozadnie1/lab4_screenshots/j1.png)

![Opis obrazka](KM415081/Sprawozadnie1/lab4_screenshots/j2.png)

## Utworzenie i uruchomienie projektów
### Projekt 1 - wyświetlenie uname
```sh
#!/bin/bash

HOUR=$(date +%H)
HOUR=$((10#$HOUR))  

if [ $((HOUR % 2)) -ne 0 ]; then
    echo "Błąd: Godzina ($HOUR) jest nieparzysta!"
    exit 1
else
    echo "OK: Godzina ($HOUR) jest parzysta."
    exit 0
fi
```
![Opis obrazka](lab5_screenshots/3.png)

### Projekt 2 - błąd jeśli godzina jest nieparzysta
```sh
uname -a
```
![Opis obrazka](lab5_screenshots/4.png)

### Projekt 3 - pobranie w projekcie obrazu kontenera ubuntu stosując docker pull
```sh
docker pull ubuntu
```
![Opis obrazka](lab5_screenshots/5.png)

Pierwsza próba zakończyły się niepowodzeniem, lecz po zrestartowaniu kontenera docker:dind udało się to wykonać.

![Opis obrazka](lab5_screenshots/6.png)

## Utworzenie projektu typu pipeline
Pipeline:
```sh
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                sh 'rm -fr MDO2025_INO'
                sh 'git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
                dir("MDO2025_INO"){
                    sh 'git checkout KM415081'
                }
            }
        }

        stage('Build') {
            steps {
                dir('MDO2025_INO/ITE/GCL05/KM415081/Sprawozadnie1/lab_3_dockerfile') {
                    sh 'docker rmi -f dummy-builder || true'
                    sh 'docker builder prune --force --all'
                    sh 'docker build -t dummy-builder -f Dockerfile.nodebld .'
                }
            }
        }
        
        stage('Test') {
            steps {
                dir('MDO2025_INO/ITE/GCL05/KM415081/Sprawozadnie1/lab_3_dockerfile') {
                    sh 'docker build -t dummy-test -f Dockerfile.nodetest .'
                }
            }
        }
    }
}
```
Definiujemy nowy obiekt pipeline, czyli zestaw zautomatyzowanych kroków służących do budowania, testowania i (ewentualnie) wdrażania aplikacji. Dzięki zapisaniu całego procesu w jednym pliku konfiguracyjnym, możliwa jest jego automatyzacja oraz łatwe powtarzanie przy kolejnych uruchomieniach.

Pierwszy etap polega na pobraniu kodu źródłowego z repozytorium Git. Na początku dla bezpieczeństwa usuwana jest ewentualnie wcześniej istniejąca kopia repozytorium, po czym następuje jego ponowne sklonowanie. W dalszej kolejności następuje przejście na wskazaną gałąź projektu.

Po przejściu do konkretnego katalogu, pipeline podejmuje próbę usunięcia istniejącego lokalnie obrazu Dockera, aby uniknąć potencjalnych konfliktów. Następnie czyszczone są zalegające dane oraz cache'e buildów Dockera, które mogłyby wpłynąć na wynik budowania.

Kiedy środowisko jest już przygotowane, budowany jest pierwszy obraz na podstawie pliku Dockerfile.nodebld. Po jego utworzeniu, w kolejnym kroku budowany jest drugi obraz — tym razem z użyciem Dockerfile.nodetest, który służy do przeprowadzenia testów.

### Pierwsze uruchomienie
Console output

![Opis obrazka](lab5_screenshots/7.png)

![Opis obrazka](lab5_screenshots/8.png)

![Opis obrazka](lab5_screenshots/9.png)

![Opis obrazka](lab5_screenshots/10.png)

![Opis obrazka](lab5_screenshots/11.png)

![Opis obrazka](lab5_screenshots/12.png)

### Drugie uruchomienie

![Opis obrazka](lab5_screenshots/13.png)

