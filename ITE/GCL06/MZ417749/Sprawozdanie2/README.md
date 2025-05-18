Marcin Ziemba 15.05.2025
Sprawozdanie 2

## 1. Przygotowanie Jenkins

Zaczynamy od stworzenia kontenera z jenkinsem, następnie uruchomiamy go z dind.

```
docker network create jenkins
```

![](/Sprawozdanie1/lab4_ss/ss26.png)
```

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

![](/Sprawozdanie1/lab4_ss/ss29.png)

Kolejno uruchamiamy kontenery.

```
sudo docker run  
--name jenkins-blueocean   
--restart=on-failure   
--detach   
--network jenkins   
--env DOCKER_HOST=tcp://docker:2376   
--env DOCKER_CERT_PATH=/certs/client
--env DOCKER_TLS_VERIFY=1   
--publish 8080:8080   
--publish 50000:50000   
--volume jenkins-data:/var/jenkins_home   
--volume jenkins-docker-certs:/certs/client:ro   
myjenkins-blueocean
```

![](/Sprawozdanie2/ss/ss1.png)

Efekt działąjącego jenkinsa przez http, następnie zaainstalowano wtyczki.

![](/Sprawozdanie1/lab4_ss/ss31.png)

### Stworzenie pipeline wyświetlający uname 

Po wejściu w zakładkę Daskboard tworzymy pierwszy projekt i konfigurujemy w zakładce Configure dodając Build Steps z funkcją execute shell. Pierwsze polecenie ma za zadanie pokazać podstawowe informacje o systemie.

![](/Sprawozdanie2/ss/ss2.png)
![](/Sprawozdanie2/ss/ss3.png)

### Stworzenie pipeline sprawdzającego godzine

Program informuje nas czy godzina jest parzysta lub nieparzysta.

![](/Sprawozdanie2/ss/ss4.png)
![](/Sprawozdanie2/ss/ss5.png)

### Stworzenie pipeline pobierający obraz kontenera ubuntu

![](/Sprawozdanie2/ss/ss6.png)
![](/Sprawozdanie2/ss/ss7.png)

### Stworzenie pipeline klonującego nasze repozytorium (MDO2025_INO)

```
pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                git branch: 'MZ417749', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Build Dockerfile') {
            steps {
                sh 'docker build -t my-builder-image -f ITE/GCL06/MZ417749/Sprawozdanie2/Dockerfile.nodeBuild ITE/GCL06/MZ417749/Sprawozdanie2'
            }
        }
    }

    post {
        success {
            echo 'OK'
        }
        failure {
            echo 'ERROR'
        }
    }
}
```

![](/Sprawozdanie2/ss/ss8.png)
![](/Sprawozdanie2/ss/ss9.png)
![](/Sprawozdanie2/ss/ss10.png)
![](/Sprawozdanie2/ss/ss11.png)

Build wykonał się 2 razy bez problemu

![](/Sprawozdanie2/ss/ss12.png)

## 2. Stworzenie pipeline projektu

Jako projekt do stworzenia pipeline wybranu [node-js-dummy](https://github.com/devenes/node-js-dummy-test/tree/master). Został wybrany ze względu na prostote i mały rozmiar i znajome środowisko Node.js.

Diagram UML całego procesu:

![](/Sprawozdanie2/ss/diagram.png)