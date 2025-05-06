# ***LAB5***

# 1. Utworzenie instancji Jenkinsa
[Opisane dokładnie w ostatnich labach](../Sprawozdanie1/README.md)

# 2. Zadania wstępne
## Konfiguracja wstępna i pierwsze uruchomienie
### Projekt wywietlajacy uname

W pierwszej kolejnosci Tworzymy projekt w tablicy klikajac Nowy projekt

![alt text](lab5/uname1.png)

Nastepnie nadajemy nazwe oraz wybieramy projekt ogolny

![alt text](lab5/uname2.png) 

Schodzimy do zakladki o nazwie Kroki Budowania > Dodaj krok budowania > Uruchom Powłoke 

![alt text](lab5/uname3.png)

Dodajemy w wyznaczonym miejscu polecenie 
```sh
#!/bin/bash

uname -a
```
a nastepnie zapisujemy konfiguracje

![alt text](lab5/uname4.png)

Nastepnie pojawi nam sie po lewej stronie w projekcie opcja uruchom > po czym efekt powinien sie nam pojawic na dole w Builds

![alt text](lab5/uname5.png)

Po kliknięciu w artefakt uruchomienia (u nas jest to 1 w buildie) >
pojawi nam sie menu do artefaktu 

![alt text](lab5/uname6.png)

Nas interesują tutaj logi

![alt text](lab5/uname7.png)

### Projekt wyswietlajacy blad, gdy godzina jest nieparzysta
TWorzymy projekt analogicznie jak w punkcie wyzej do momentu Uruchomienia powłoki. PO uruchomieniu powloki w wyznaczonym miejscu wpisujemy:
```bash
#!/bin/bash

hour=$(date +%-H)

if (( hour % 2 != 0 )); then
    echo "Błąd: godzina $hour jest nieparzysta"
    exit 1
else
    echo "Godzina $hour jest parzysta"
    exit 0
fi
```
![alt text](lab5/oddhour1.png)

Po zapisaniu i uruchomieniu sprawdzamy artefakt

![alt text](lab5/oddhour2.png)


### Pobranie w projekcie obraz kontenera ubuntu

My to zrobimy w naszym pierwszym projekcie. Wiec w Tablicy Jenkinsa wybieramy nasz pierwszy projekt:

![alt text](lab5/ubuntuPull1.png)

gdzie wchodzimy w konfiguruj:

![alt text](lab5/ubuntuPull2.png)

Dodajemy w konfiguracji linijke docker pulla
```sh
#!/bin/bash

uname -a
docker images
docker pull ubuntu
docker images
```

![alt text](lab5/ubuntuPull3.png)

Nastepnie powinno nam sie pokazac w logach artefaktu:

![alt text](lab5/ubuntuPull4.png)

***Uwaga*** Upewnij sie ze oba kontenery dockerowe dzialaja (blueocean i dind)

## obiekt typu pipeline
### Utwórz nowy obiekt typu pipeline
Tworzymy nowy projekt i tym razem zamiast projektu ogólnego wybieramy pipeline

![alt text](lab5/pipeline1.png)

Nastepnie w pipeline script wpisujemy:

```Dockerfile
pipeline {
    agent any

    stages {
        stage('Clean') {
            steps {
                cleanWs()
                sh 'docker image rm -f docker-irssi-build docker-irssi-test'
                sh 'docker builder prune -a -f'
            }
        }
        
        stage('Git clone') {
            steps {
                git url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git', branch: 'BP417137'
            }
        }
        
        stage('Build') {
            steps {
                dir('ITE/GCL08/BP417137/Sprawozdanie1/lab3') {
                    sh 'docker build -f Dockerfile.build -t docker-irssi-build .'
                }
            }
        }
        
        stage('Test') {
            steps {
                dir('ITE/GCL08/BP417137/Sprawozdanie1/lab3') {
                    sh 'docker build -f Dockerfile.test -t docker-irssi-test .'
                }
            }
        }
    }
}
```
budujemy to wedlug struktury podanej w dokumentacji jenkinsa: https://www.jenkins.io/doc/book/pipeline/

![alt text](lab5/pipeline2.png)

pipeline sie udał

![alt text](lab5/pipeline3.png)

Drugie uruchomienie pipelina

![alt text](lab5/pipeline4.png)

# 3. Kompeltny Pipeline - Express.js
Link do repozytorium wykorzystywanego repozytorium: https://github.com/expressjs/express

## Etap BUILD
### w pierwszej kolejnosci przygodowujemy dockerfila pod image builda

```Dockerfile
FROM node:20
WORKDIR /app
RUN git clone https://github.com/expressjs/express.git
WORKDIR /app/express
RUN npm install
```
### Tworzymy obraz

```sh
docker build -f Dockerfile.build -t express-build-img .
```
![alt text](build1.png)

## Etap TEST
### Przygotowujemy dockerfila pod image test
```Dockerfile
FROM express-build-img

WORKDIR /app/express

RUN npm test
```

### Tworzymy obraz

```sh
docker build -f Dockerfile.test -t express-test-img .
```
![alt text](test1.png)

## Etap DEPLOY

W repozytorium expressa jest wiele róznych przykładów użycia. Ja skorzystałem z przykladu downloads, którego budowa wyglada tak:

![alt text](deploy1.png)

### Przygotowujemy dockerfila pod image deploy

```Dockerfile
FROM node:20-slim

COPY --from=express-build-img /app/express /app

WORKDIR /app

CMD ["node", "examples/downloads"]
```

### Tworzymy Obraz

```sh
docker build -f Dockerfile.deploy -t express-deploy-img .
```
![alt text](deploy2.png)

### Tworzymy nowa sieć

```sh
docker network create express
```
![alt text](deploy3.png)

### Uruchamiamy kontener deploya

```sh
docker run -d --rm --network express --name express-deploy-container -p 3000:3000 express-deploy-img
```

![alt text](deploy4.png)

Upewniamy się, że wszystko działa

```sh
docker logs express-deploy-container
```

![alt text](deploy5.png)

Teraz aby sprawdzić co nam przeglądarka pokazuje na porcie 3000, musimy ten port udostępnić. Ja skorzystalem z możliwości udostępnienia portu przez VSC

![alt text](deploy6.png)

![alt text](deploy7.png)

### Tworzymy kontener z curlem 
curl jest minimalistyczny i wysyla zapytanie o to co jest na stronie - idealne narzedzie do sprawdzenia dzialania kontenera

```sh
docker run --rm --network express curlimages/curl curl -s express-deploy-container:3000
```

![alt text](deploy8.png)

## Etap Publish
bedziemy to publikowac na dockerhuba wiec do tego musimy poczynic pewne przygotowania
### Tworzymy obraz pod docker pusha

```sh
docker build -f Dockerfile.deploy -t bpajda/express-deploy-img:latest .
```

![alt text](publish1.png)

### Nastepnie logujemy sie na docker huba

![alt text](publish2.png)

### Pushujemy obraz na dockerhuba

```sh
docker push bpajda/express-deploy-img:latest
```
![alt text](publish3.png)

![alt text](publish4.png)

### Przygotowanie pipelina
 W pierwszej kolejnosci aby mozna bylo sie logowac do docker huba trzeba dodac na jenkinsie credsy

![alt text](publish5.png)

### Tworzymy pipeline

```Dockerfile
pipeline {
    agent any

    environment {
        APP_DIR = 'ITE/GCL08/BP417137/Sprawozdanie2/lab6'
    }

    stages {
        stage('Etap Clone') {
            steps {
                git branch: 'BP417137', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Etap Clean') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker rmi -f express-build-img || true'
                    sh 'docker rmi -f express-test-img || true'
                    sh 'docker rmi -f bpajda/express-deploy-img || true'
                    sh 'docker builder prune --force --all || true'
                    sh 'docker network rm express || true'
                    sh 'docker rm -f express-deploy-container || true'
                }
            }
        }

        stage('Etap Build') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker build -f Dockerfile.build -t express-build-img .'
                }
            }
        }

        stage('Etap Test') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker build -f Dockerfile.test -t express-test-img .'
                }
            }
        }
        
        stage('Etap Deploy') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker build -f Dockerfile.deploy -t bpajda/express-deploy-img:latest .'
                }
            }
        }

        stage('Etap Test2') {
            steps {
                dir("${APP_DIR}") {
                    sh '''
                        docker network create express || true
                        docker run -d --rm --network express --name express-deploy-container -p 3000:3000 bpajda/express-deploy-img:latest
                        sleep 5
                        docker run --rm --network express curlimages/curl curl -s --fail express-deploy-container:3000
                    '''
                }
            }
        }

        stage('Etap Publish') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                    }

                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-creds') {
                        docker.image("bpajda/express-deploy-img:latest").push()
                    }
                }
            }
        }
    }
}
```
### etap Build (przeszło)

![alt text](publish6.png)

### etap test (przeszło)

![alt text](publish7.png)

### etap deploy (przeszło)

![alt text](publish8.png)

### etap test2 (przeszło)

![alt text](publish9.png)

### etap publish (przeszło)

![alt text](publish10.png)

### obraz spushowany na dockerhuba

![alt text](publish11.png)

### Uzupelnienie skryptu o utworzenie artefaktu oraz zapisanie w formie Jenkinsfila w repo

```Dockerfile
pipeline {
    agent any

    environment {
        APP_DIR = 'ITE/GCL08/BP417137/Sprawozdanie2/lab6'
    }

    stages {
        stage('Etap Clone') {
            steps {
                git branch: 'BP417137', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Etap Clean') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker rmi -f express-build-img || true'
                    sh 'docker rmi -f express-test-img || true'
                    sh 'docker rmi -f bpajda/express-deploy-img || true'
                    sh 'docker builder prune --force --all || true'
                    sh 'docker network rm express || true'
                    sh 'docker rm -f express-deploy-container || true'
                }
            }
        }

        stage('Etap Build') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker build -f Dockerfile.build -t express-build-img .'
                }
            }
        }

        stage('Etap Test') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker build -f Dockerfile.test -t express-test-img .'
                }
            }
        }
        
        stage('Etap Deploy') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker build -f Dockerfile.deploy -t bpajda/express-deploy-img:latest .'
                }
            }
        }

        stage('Etap Test2') {
            steps {
                dir("${APP_DIR}") {
                    sh '''
                        docker network create express || true
                        docker run -d --rm --network express --name express-deploy-container -p 3000:3000 bpajda/express-deploy-img:latest
                        sleep 5
                        docker run --rm --network express curlimages/curl curl -s --fail express-deploy-container:3000
                    '''
                }
            }
        }

        stage('Etap Publish') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                    }

                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-creds') {
                        docker.image("bpajda/express-deploy-img:latest").push()
                    }
                }
            }
        }

        stage('Etap Artefakt') {
            steps {
                dir("${APP_DIR}") {
                    sh '''
                        docker create --name temp_pack bpajda/express-deploy-img:latest
                        docker cp temp_pack:/app ./app-content
                        docker rm temp_pack
        
                        docker run --rm -v "$PWD/app-content":/app -w /app node:20 npm pack
                    '''
                    archiveArtifacts artifacts: 'app-content/*.tgz', fingerprint: true
                }
            }
        }
    }
}
```