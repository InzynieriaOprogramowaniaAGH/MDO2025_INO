![image](https://github.com/user-attachments/assets/06dd7eaf-d676-4c9a-bef6-905ef73b83d3)# Sprawozdanie z laboratoriów: Pipeline, Jenkins
### Instancja Jenkinsa została utworzona zgodnie z oficjalną instrukcją instalacyjną.

### Utworzono dedykowaną sieć Docker o nazwie jenkins:

` docker network create jenkins `

### Kontener Docker-in-Docker (DinD):
Uruchomiono kontener docker:dind, który umożliwia wykonywanie poleceń Docker wewnątrz Jenkinsa. Kontener został podłączony do sieci jenkins i otrzymał alias docker:

`docker run --name jenkins-docker --rm --detach \
  --privileged --network jenkins --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind --storage-driver overlay2`

### Niestandardowy obraz Jenkins (Dockerfile.myjenkins-blueocean)
Stworzono własny obraz Dockera na podstawie jenkins/jenkins:2.492.2-jdk17, który:

- dodaje obsługę klienta Docker (CLI),

- instaluje pluginy: Blue Ocean oraz docker-workflow.

Dzięki temu możliwe jest uruchamianie zadań Jenkinsowych z wykorzystaniem Dockera poprzez przyjazny interfejs Blue Ocean.

`### Dockerfile.myjenkins-blueocean ###
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
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"`

Obraz utworzono poleceniem: 
`docker build -t myjenkins-blueocean:2.492.3-1 .`

### Uruchomienie kontenera jenkins-blueocean
Kontener Jenkinsa został uruchomiony na podstawie wcześniej zbudowanego obrazu myjenkins-blueocean:2.492.3-1, z wykorzystaniem poniższego polecenia:

`docker run --name jenkins-blueocean --restart=on-failure --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.492.3-1`

  Kontener został podłączony do sieci jenkins oraz przypisano mu odpowiednie woluminy.

### Dostęp do interfejsu webowego
Z poziomu przeglądarki na hoście maszyny wirtualnej odwiedzono interfejs Jenkinsa pod adresem http://localhost:8080/
W celu pierwszego logowania, hasło jednorazowe zostało uzyskane z logów kontenera:
![hasło](https://github.com/user-attachments/assets/dcc42ca1-38a2-4d1d-8cab-b01717379503)

![6](https://github.com/user-attachments/assets/8c21a6d8-757d-4e23-9fde-d95c1007dec7)

# Projekt: wyświetlenie informacji o systemie
Zrealizowano zadanie, które po uruchomieniu wypisuje w konsoli wynik polecenia uname, czyli podstawowe informacje o systemie operacyjnym.

![2](https://github.com/user-attachments/assets/aaa80ec4-ff6a-4c55-8f31-0ed6b348f82d)

![3](https://github.com/user-attachments/assets/ff01bcd2-9f40-4666-a24c-1fd5c867da0f)

### sprawdzenie parzystości godziny
Kolejny projekt wykonuje skrypt Bash, który sprawdza, czy aktualna godzina (w formacie 24-godzinnym) jest parzysta czy nie:

![5](https://github.com/user-attachments/assets/182bc9c3-caa7-4ec1-8456-a6cf84674070)

![4](https://github.com/user-attachments/assets/40f8bf73-c1a4-47d6-9da6-812e45bc99fb)

# pobieranie obrazu Dockera

`docker pull ubuntu`

![7](https://github.com/user-attachments/assets/1b146a0a-b53c-4d1f-a166-ef9521dce044)

# Utworzenie pileline, którego zadaniem jest pobranie repozytorium przedmiotu MD02025_INO i budowa obrazu dockera, zawartego w dockerfile na własnej gałęzi: KL414598.

![image](https://github.com/user-attachments/assets/5a6adea7-1d2c-422b-be43-7ca3530528a5)

Koniec loga potwierdzający działanie pipeline'u:

![image](https://github.com/user-attachments/assets/06eb1d6c-6df5-4f4e-8885-54624dbf1927)

- [Pełna treść wydruku z konsoli](log.txt)
- [Pełna treść wydruku z konsoli po powtórnym uruchomieniu](log.txt)

# Kompletny Pipeline z wykorzystaniem xz

Diagram UML(wygenerowany przez chatGPT) przedstawiający działanie pipeliniu: 
![uml](https://github.com/user-attachments/assets/2273e2e7-1cef-45c2-a9dd-ffc97c2730d9)


1. Clone – Przygotowanie środowiska
Klonowanie repozytorium z kodem xz oraz plików pomocniczych:

Dockerfile.build, Dockerfile.test, Dockerfile.deploy, deploy.c, test-entrypoint.sh, docker-compose.yml
![tree](https://github.com/user-attachments/assets/9fb9e062-27ac-4c3a-87be-d53c6d04688c)


2. Build – Kompilacja projektu
   
Budowa obrazu z Dockerfile.build, bazującego na debian:bookworm.

Instalacja wymaganych zależności:autotools, gcc, gettext, make, automake, libtool, itp.

Kompilacja narzędzia xz w kontenerze.

Utworzenie i zapisanie artefaktu xz.tar.gz w katalogu artifacts.

Zawartość Jenkinsfile:
```
pipeline {
    agent any

    environment {
        WORKDIR = "INO/GCL02/KL414598/zadaniePipeline/pipeline"
    }

    stages {
        stage('Clone xz') {
            steps {
                dir("${WORKDIR}") {
                    sh "rm -rf xz"
                    sh "git clone https://github.com/tukaani-project/xz.git xz"
                }
            }
        }

        stage('Build & Package') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('xz-build', '-f Dockerfile.build .')
                        sh 'mkdir -p artifacts'
                        def cid = sh(script: "docker create xz-build", returnStdout: true).trim()
                        sh "docker cp ${cid}:/app/xz.tar.gz artifacts/xz.tar.gz"
                        sh "docker rm ${cid}"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('xz-test', '-f Dockerfile.test .')
                        sh 'mkdir -p logs'
                        def cid = sh(script: "docker create xz-test", returnStdout: true).trim()
                        sh "docker cp ${cid}:/app/logs/test_results.log logs/xz_test.log"
                        sh "docker rm ${cid}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        echo "Uruchamiam aplikację z obrazu xz-build..."
                        sh "docker run -d --rm --name xz-deploy xz-build"
                    }
                }
            }
        }

        stage('Print') {
            steps {
                echo 'Pipeline dla xz zakończony pomyślnie.'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'INO/GCL02/KL414598/zadaniePipeline/pipeline/artifacts/xz.tar.gz'
            archiveArtifacts artifacts: 'INO/GCL02/KL414598/zadaniePipeline/pipeline/logs/xz_test.log'
        }
    }
}

```


Sukces wykonania
![succes](https://github.com/user-attachments/assets/b27d1872-f278-43a7-8831-29de8c38d7d9)


Utworzony Artefakt oraz log
![artefakty](https://github.com/user-attachments/assets/0084c2e0-c4e3-42b5-9fea-3c0e292c0048)

W kontenerze odnaleziono utworzony artefakt oraz wypisano jego pełną ścieżkę:
![path](https://github.com/user-attachments/assets/3a0de287-5317-4aaa-8b96-8d782ba2250d)
oraz udało się go pobrać z kontenera:
![pobra](https://github.com/user-attachments/assets/6c72d1af-09fa-475c-9ca6-16f94ec24ad4)

- [xz.tar.gz](xz.tar.gz)
- [Log testów](xz_test.log)


