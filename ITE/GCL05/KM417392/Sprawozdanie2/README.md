# Pipeline, Jenkins, izolacja etapów
Repozytorium wykorzystane do zadań: https://github.com/mruby/mruby.git
## Przygotowanie
Zgodnie z instrukcją instalacji Jenkinsa: https://www.jenkins.io/doc/book/installing/docker/

Wykonano następujące kroki:
1. Utworzono sieć bridge dla Dockera
```
docker network create jenkins
```
2. Uruchomiono kontener z Docker-in-Docker (dind)
```
docker run \
  --name jenkins-docker \
  --rm \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind \
  --storage-driver overlay2
```
![obraz](KM/lab5/siec-jenkins.png)

*Kontener działa jako "Docker daemon" dla Jenkinsa. Jest niezbędny, by Jenkins mógł wykonywać polecenia **docker** 
3. Stworzono własny obraz z Jenkins +  BlueOcean
a) plik Dockerfile:
```
FROM jenkins/jenkins:2.492.3-jdk17
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
![obraz](KM/lab5/Dockerfile.png)
- [Dcokerfile](http://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM417392/ITE/GCL05/KM417392/Sprawozdanie2/KM/lab5/wazne_pliki/Dockerfile)
b) budowanie obrazu:
```
docker build -t myjenkins-blueocean:2.492.3-1 .
```
![obraz](KM/lab5/budowanie-ocean.png)

4. Uruchomiono kontener z własnym obrazem Jenkins + BlueOcean
```
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
  myjenkins-blueocean:2.492.3-1
```
![obraz](KM/lab5/run-ocean.png)

5. Jenkins jest dostępny pod adresem: http://localhost:8080
6. Po wejściu na podany adres, będzie wymagane hasło, które można uzyskać poniższą komendą:
```
sudo docker exec ${CONTAINER_ID or CONTAINER_NAME} cat /var/jenkins_home/secrets/initialAdminPassword
```

**Podsumowanie:**  
BlueOcean to nowoczesne rozszerzenie Jenkinsa, które upraszcza zarządzanie pipeline’ami i oferuje przyjazny interfejs graficzny, ale nadal bazuje na podstawowej instalacji Jenkins.


### Zadanie wstępne: uruchomienie
```Nowy projekt``` > ```Ogólny projekt``` > ```Kroki budowania``` > ```Dodaj krok budowania``` > ```Uruchom powłokę```
1. Uname - wyświetla nazwę systemu operacyjnego
```
uname -a
```
![obraz](KM/lab5/Uname.png)

2. Hour - zwraca błąd, gdy... godzina jest nieparzysta
```
#!/bin/bash

GODZINA=$(date +%H)
echo "Aktualna godzina: $GODZINA"

if [ $((GODZINA % 2)) -ne 0 ]; then
  echo "Błąd: godzina $GODZINA jest nieparzysta."
  exit 1
else
  echo "OK: godzina $GODZINA jest parzysta."
fi
```
![obraz](KM/lab5/Hour.png)

3. Obraz - pobiera obraz kontenera ```ubuntu```
```
docker pull ubuntu
```
![obraz](KM/lab5/Obraz.png)

### Zadanie wstępne: obiekt typu pipeline
- Sklonowano repozytorium przedmiotowe (MDO2025_INO)
- Zrobiono checkout do pliku Dockerfile (na osobistej gałęzi) właściwego dla buildera wybranego programu - mruby.
- Zbudowano Dockerfile do budowania i testowania
```
pipeline {
    agent any

    stages {
        stage('Clean') {
            steps {
                echo 'Cleaning ...'
                sh 'rm -rf MDO2025_INO'
            }
        }

        stage('Checkout') {
            steps {
                echo 'Checkout ...'
                sh 'git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO'
                dir('MDO2025_INO') {
                    sh 'git checkout KM417392'
                }
            }
        }

        stage('Build') {
            steps {
                echo 'Building ...'
                dir('MDO2025_INO/ITE/GCL05/KM417392/Sprawozdanie1/KM/lab3/lab3-wazne-pliki') {
                    sh 'docker build -f Dockerfile.build -t r-build .'
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Testing ...'
                dir('MDO2025_INO/ITE/GCL05/KM417392/Sprawozdanie1/KM/lab3/lab3-wazne-pliki') {
                    sh 'docker build -f Dockerfile.test -t r-test .'
                }
            }
        }
    }
}
```

![obraz](KM/lab5/pipeline-success.png)
![obraz](KM/lab5/pipeline-success2.png)
