# ĆW 5 - Pipeline, Jenkins, izolacja etapów

## 1. Utwórz instancję Jenkins

#### Wykonane w sprawozdaniu 1 - [Sprawozdanie1](../Sprawozdanie1/README.md#3-instalacja-jenkins-według-dokumentacji)

## 2. Zadanie wstępne: uruchomienie

### - Projekt wyświetlający uname

#### Wybieramy nowy projekt

![alt text](2_1/image.png)

#### Nadajemy nazwę i typ "Ogólny projekt"

![alt text](2_1/image-1.png)

#### W krokach budowania wybieramy "Uruchom powłokę"

![alt text](2_1/image-3.png)

#### Jako polecenie wpisujemy
```sh
uname -a
```

![alt text](2_1/image-4.png)

#### Uruchamiamy i sprawdzamy wynik w logach konsoli

![alt text](2_1/image-5.png)

### Projekt zwracający błąd kiedy godzina jest nieparzysta

#### Tworzymy nowy projekt i wpisujemy polecenie
```sh
#!/bin/bash

current_hour=$(date +%H)
if [ $((current_hour % 2)) -ne 0 ]; then
  echo "BŁĄD: Godzina jest nieparzysta ($current_hour)"
  exit 1
fi
```
![alt text](2_1/image-6.png)

#### Sprawdzamy wynik w konsoli

![alt text](2_1/image-7.png)

### Projekt pobierający obraz kontenera ubuntu (docker pull)

#### Wpisujemy polecenie do nowego projektu
```sh
docker images 
docker pull ubuntu 
docker images
```
![alt text](2_1/image-8.png)

#### Sprawdzamy wynik w konsoli

![alt text](2_1/image-9.png)

## 3. Zadanie wstępne: obiekt typu pipeline

#### Tworzymy nowy projekt typu pipeline
![alt text](2_1/image-10.png)

#### Wybieramy Pipeline script i tworzymy nowy pipeline
```sh
pipeline {
    agent any

    stages {
        stage('Clean') {
            steps {
                cleanWs()
            }
        }
        
        stage('Clone') {
            steps {
                git url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git', branch: 'main'
            }
        }
        
        stage('Checkout Branch') {
            steps {
                sh 'git checkout MS417562'
            }
        }
        
        stage('Remove Docker Images') {
            steps {
                sh 'docker rmi -f my-build-image my-test-image'
            }
        }
        
        stage('Clear Docker Cache') {
            steps {
                sh 'docker builder prune -a -f'
            }
        }
        
        stage('Build image') {
            steps {
                dir('ITE/GCL07/MS417562/Sprawozdanie1/1_3') {
                    sh 'docker build -f Dockerfile_2.build -t node_build_v1 .'
                }
            }
        }
        
        stage('Test image') {
            steps {
                dir('ITE/GCL07/MS417562/Sprawozdanie1/1_3') {
                    sh 'docker build -f Dockerfile_2.test -t node_test_v1 .'
                }
            }
        }
    }
}
```
![alt text](2_1/image-12.png)

#### Wyniki buildow pipeline'a
![alt text](2_1/image-13.png)

#### Pierwsze udane uruchomienie pipeline'a
![alt text](2_1/image-14.png)

#### Drugie udane uruchomienie (Potwierdzenie ponownego działania)
![alt text](2_1/image-15.png)

#### W etapie "Clear Docker Cache" cały cache jest czyszczony
![alt text](2_1/image-16.png)


# ĆW 6/7 - Pipeline własnego projektu

### Wykorzystany projekt to [Express.js](https://github.com/expressjs/express)

## Diagram 
![alt text](2_2/image-23.png)

## Przygotowanie procesu lokalnie

#### Obraz etapu Build
```Dockerfile
FROM node:20
WORKDIR /app
RUN git clone https://github.com/expressjs/express.git
WORKDIR /app/express
RUN npm install
```

#### Budowa obrazu
```sh
docker build -f build.Dockerfile -t express-build-img .
```
![alt text](2_2/image.png)

#### Obraz etapu Test
```Dockerfile
FROM express-build-img

WORKDIR /app/express

RUN npm test
```

#### Budowa obrazu
```sh
docker build -f test.Dockerfile -t express-test-img .
```
![alt text](2_2/image-1.png)

#### Obraz etapu Deploy
```Dockerfile
FROM node:20-slim

COPY --from=express-build-img /app/express /app

WORKDIR /app

CMD ["node", "examples/content-negotiation"]
```

#### Budowa obrazu
```sh
docker build -f deploy.Dockerfile -t express-deploy-img .
```
![alt text](2_2/image-2.png)

#### Stworzenie siecii ci
```sh
docker network create ci
```
![alt text](2_2/image-3.png)

#### Uruchomienie kontenera
```sh
docker run -dit --rm --network ci --name express-deploy -p 3000:3000 express-deploy-img
```
![alt text](2_2/image-8.png)  


#### Sprawdzenie logów (wszystko działa)
![alt text](2_2/image-9.png)  

#### Udostępnienie portów przez VSC
![alt text](2_2/image-5.png)  

#### Test działania na przeglądarce
![alt text](2_2/image-6.png)  

#### Uruchomienie kontenera który wykonuje curl na adres z naszym porjektem
```sh
docker run --rm --network ci curlimages/curl curl -s express-deploy:3000
```
![alt text](2_2/image-7.png)  

#### Zbudowanie obrazu deploy pod nową nazwą (przygotowanie pod docker push na docker hub'a)
```sh
docker build -f deploy.Dockerfile -t msior/express-deploy-img:latest .
```
![alt text](2_2/image-10.png)  

#### Zalogowanie się na docker'a
![alt text](2_2/image-11.png)

#### Docker push obrazu
```sh
docker push msior/express-deploy-img:latest
```
![alt text](2_2/image-12.png)

## Przygotowanie pipeline na Jenkins

#### Dodanie poświadczeń do docker huba
![alt text](2_2/image-13.png)

#### Stworzenie pipeline'a
```sh
pipeline {
    agent any

    environment {
        APP_DIR = 'ITE/GCL07/MS417562/Sprawozdanie2/2_2'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'MS417562', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Cleaning') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker rmi -f express-build-img || true'
                    sh 'docker rmi -f express-test-img || true'
                    sh 'docker rmi -f msior/express-deploy-img || true'
                    sh 'docker builder prune --force --all || true'
                    sh 'docker network rm ci || true'
                    sh 'docker rm -f express-deploy || true'
                }
            }
        }

        stage('Build Build image') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker build -f build.Dockerfile -t express-build-img .'
                }
            }
        }

        stage('Build Test Image') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker build -f test.Dockerfile -t express-test-img .'
                }
            }
        }
        
        stage('Build Deploy Image') {
            steps {
                dir("${APP_DIR}") {
                    sh 'docker build -f deploy.Dockerfile -t msior/express-deploy-img:latest .'
                }
            }
        }

        stage('Run and Test App') {
            steps {
                dir("${APP_DIR}") {
                    sh '''
                        docker network create ci || true
                        docker run -dit --rm --network ci --name express-deploy -p 3000:3000 msior/express-deploy-img:latest
                        sleep 5
                        docker run --rm --network ci curlimages/curl curl -s --fail express-deploy:3000
                    '''
                }
            }
        }

        stage('Publish to Dockerhub') {
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
                        docker.image("msior/express-deploy-img:latest").push()
                    }
                }
            }
        }
    }
}
```
#### Wynik działania testów (wszystkie przeszły)
![alt text](2_2/image-14.png)  

#### Wynik działania curl'a (Dane otrzymane)
![alt text](2_2/image-15.png)  

#### Wysyłanie obrazu (U mnie trwało to z jakiegoś powodu 40 min dla obrazu ~80 MB)
![alt text](2_2/image-16.png)  

#### Ddane zakończenie pipeline'a
![alt text](2_2/image-19.png)  

#### Obraz znajduje się na docker-hub'ie
![alt text](2_2/image-18.png)  

#### Historia buildów pipeline'a (Większość nieudanych prób to problemy z docker pushem lub miejscem na maszynie)
![alt text](2_2/image-20.png)

#### Dodanie etapu tworzenia artefaktu .tgz
```sh
        stage('Create .tgz Artifact') {
            steps {
                dir("${APP_DIR}") {
                    sh '''
                        docker create --name temp_pack msior/express-deploy-img:latest
                        docker cp temp_pack:/app ./app-content
                        docker rm temp_pack
        
                        docker run --rm -v "$PWD/app-content":/app -w /app node:20 npm pack
                    '''
                    archiveArtifacts artifacts: 'app-content/*.tgz', fingerprint: true
                }
            }
        }
```

#### Stworzenie pliku Jenkinsfile na naszym repo - [Jenkinsfile](2_2/Jenkinsfile)

#### Zmiana konfiguracji pipelnie na SCM - ustawienie repo, brancha i ścieżki do Jenkinsfile
![alt text](2_2/image-17.png)

#### Uruchomienie po zmianie konfiguracji. Jak widać na początku pobiera Jenkinsfile z repo
![alt text](2_2/image-21.png)

#### Kolejny udany build wraz z artefaktem (pipeline po raz kolejny poprawnie się wykonał)
![alt text](2_2/image-22.png)