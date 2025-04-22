# Sprawozdanie 2 
### Miłosz Dębowski [MD415045]

# Zajęcia 1 - Pipeline, Jenkins, izolacja etapów

### Pobranie i uruchomienie Jenkinsa w Dockerze
1. **Utworzenie sieci w Dockerze, używając polecenia** 
    ```ssh
    docker network create (nazwa sieci)
    ```
    ![network create](./Zrzut%20ekranu%202025-04-22%20153853.png)

2. **Pobranie i uruchomienie `Dind`** za pomocą `docker run`
    ```
    docker run --name jenkins-docker --rm --detach --privileged --network jenkins --network-alias docker --env DOCKER_TLS_CERTDIR=/certs --volume jenkins-docker-certs:/certs/client --volume jenkins-data:/var/jenkins_home --publish 2376:2376 docker:dind --storage-driver overlay2
    ```
    ![run docker](./Zrzut%20ekranu%202025-04-22%20161048.png)

3. **Utworzenie pliku [Dockerfile](../Sprawozdanie2/Dockerfile)**
    ```dockerfile
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
    ![dockerfile](./Zrzut%20ekranu%202025-04-22%20154444.png)
4. **Zbudowanie obrazu na podstawie powyższego Dockefile'a za pomocą `docker build`**
    ```
    docker build -t myjenkins-blueocean:2.492.3-1 .
    ```
    ![build blueocean](./Zrzut%20ekranu%202025-04-22%20161107.png)
5. **Uruchomienie Jenkins'a w dokerze za pomocą `docker run`**
    ```
    docker run   --name jenkins-blueocean   --restart=on-failure   --detach   --network jenkins   --env DOCKER_HOST=tcp://docker:2376   --env DOCKER_CERT_PATH=/certs/client   --env DOCKER_TLS_VERIFY=1   --publish 8080:8080   --publish 50000:50000   --volume jenkins-data:/var/jenkins_home   --volume jenkins-docker-certs:/certs/client:ro   myjenkins-blueocean:2.492.3-1
    ```
    ![run blueocean](./Zrzut%20ekranu%202025-04-22%20161313.png)

6. **Otwarcie Jenkins'a na porcie `8080`**
![unlock jenkins](./Zrzut%20ekranu%202025-04-22%20154851.png)

7. **Uzyskanie hasła do Jenkins'a**
    ![paswd-exec](./Zrzut%20ekranu%202025-04-22%20154949.png)

8. **Instalacja wtyczek**
    ![addons](./Zrzut%20ekranu%202025-04-22%20155023.png)

9. **Rozpoczęcie pracy z Jenkins**
    ![home](./Zrzut%20ekranu%202025-04-22%20155135.png)



### Projekty wstępne

1. **Utworzenie projektu wyświetlającego `uname`**  
   Stworzenie projektu, który wyświetla wynik polecenia `uname`.
   ```groovy
    uname -a
   ```
   ![](./Zrzut%20ekranu%202025-04-22%20161622.png)
   ![](./Zrzut%20ekranu%202025-04-22%20161607.png)

2. **Utworzenie projektu testowego**  
   Stworzenie projektu, który zwraca błąd, gdy godzina jest nieparzysta.
   ```groovy
    #!/bin/bash
    hour=$(date +"%H")
    if [ $((hour % 2)) -ne 0]; then
    echo "FAILURE: The hour is odd."
    exit 1
    fi
    echo "SUCCESS: The hour is even."
   ```
   ![](./Zrzut%20ekranu%202025-04-22%20161853.png)
   ![](./Zrzut%20ekranu%202025-04-22%20161915.png)

3. **Pobranie obrazu kontenera Ubuntu**  
   Utworzenie projektu, który skonfiguruje `docker pull` do pobrania obrazu Ubuntu.
   ```groovy
    docker pull ubuntu
   ```
   ![](./Zrzut%20ekranu%202025-04-22%20162200.png)
   ![](./Zrzut%20ekranu%202025-04-22%20162223.png) 

4. **Obiekt pipeline w Jenkinsie**

Plik [node-build.Dockerfile](node-build.Dockerfile)

```dockerfile
FROM node:23-alpine

RUN apk add --no-cache git
RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test

RUN npm install
```
```groovy
pipeline {
    agent any

    environment {
        IMAGE_NAME = 'obraz'
    }

    stages {
        stage('Klonowanie repozytorium') {
            steps {
                git branch: 'MD415045', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Budowanie obrazu Docker') {
            steps {
                script {
                    sh "docker build -t $IMAGE_NAME -f ./ITE/GCL06/MD415045/lab5/node-build.Dockerfile ."
                }
            }
        }
    }
}
```
![](./Zrzut%20ekranu%202025-04-22%20203831.png)
![](./Zrzut%20ekranu%202025-04-22%20203813.png)

### Pipeline z wybraną aplikacją

[node-build.Dockerfile](node-build.Dockerfile)
```dockerfile
FROM node:23-alpine

RUN apk add --no-cache git
RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test

RUN npm install
```
[node-test.Dockerfile](node-test.Dockerfile)
```dockerfile
FROM node-build:23-alpine

WORKDIR /node-js-dummy-test
RUN npm run test
```
[node-deploy.Dockerfile](node-deploy.Dockerfile)
```dockerfile
FROM node-build:23-alpine

WORKDIR /node-js-dummy-test
CMD ["npm", "start"]
```
Skrypt Pipeline'a w języku groovy
```groovy
pipeline {
    agent any

    environment {
        PROJECT_DIR = 'MDO2025_INO/ITE/GCL06/MD415045/lab5'
        BUILD_NUMBER = "1.0"
        NODE_VERSION = '23-alpine'
        BUILD_IMAGE = "node-build:${NODE_VERSION}"
        TEST_IMAGE = "node-test:v${BUILD_NUMBER}"
        DEPLOY_IMAGE = "node-deploy:v${BUILD_NUMBER}"
        
    }

    stages {
        stage('Prepare') {
            steps {
                sh '''
                    rm -rf MDO2025_INO
                    git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
                    cd MDO2025_INO
                    git checkout MD415045
                '''
            }
        }

        stage('Logs') {
            steps {
                dir(env.PROJECT_DIR) {
                    sh 'mkdir -p logs && touch logs/build.log logs/test.log'
                }
            }
        }

        stage('Build') {
            steps {
                dir(env.PROJECT_DIR) {
                    sh "docker build -t ${BUILD_IMAGE} -f node-build.Dockerfile . | tee logs/build.log"
                }
            }
        }

        stage('Tests') {
            steps {
                dir(env.PROJECT_DIR) {
                    sh "docker build -t ${TEST_IMAGE} -f node-test.Dockerfile . | tee logs/test.log"
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker network create my_network || true'
                dir(env.PROJECT_DIR) {
                    sh """
                        docker build -t ${DEPLOY_IMAGE} -f node-deploy.Dockerfile .
                        docker rm -f app || true
                        docker run -d -p 8081:8080 --name app --network my_network ${DEPLOY_IMAGE}
                    """
                }
            }
        }

        stage('Publish') {
            steps {
                dir(env.PROJECT_DIR) {
                    sh '''
                        mkdir -p artifacts_${BUILD_NUMBER}
                        tar -cvf artifacts_${BUILD_NUMBER}.tar logs/*.log
                    '''
                    archiveArtifacts artifacts: "artifacts_${BUILD_NUMBER}.tar"
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh """
                docker rmi ${BUILD_IMAGE} ${TEST_IMAGE} ${DEPLOY_IMAGE} || true
                docker system prune --all --volumes --force || true
            """
        }
    }
}

```
![artefakty](./Zrzut%20ekranu%202025-04-22%20205317.png)
![stage](./Zrzut%20ekranu%202025-04-22%20205330.png)

![post](./Zrzut%20ekranu%202025-04-22%20205815.png)
```groovy
post {
        always {
            echo 'Cleaning up...'
            sh """
                docker rmi ${BUILD_IMAGE} ${TEST_IMAGE} ${DEPLOY_IMAGE} || true
                docker system prune --all --volumes --force || true
            """
        }
}
```

![publish](./Zrzut%20ekranu%202025-04-22%20205811.png)
```groovy
stage('Publish') {
            steps {
                dir(env.PROJECT_DIR) {
                    sh '''
                        mkdir -p artifacts_${BUILD_NUMBER}
                        tar -cvf artifacts_${BUILD_NUMBER}.tar logs/*.log
                    '''
                    archiveArtifacts artifacts: "artifacts_${BUILD_NUMBER}.tar"
                }
            }
}
```

![deploy](./Zrzut%20ekranu%202025-04-22%20205801.png)
```groovy
stage('Deploy') {
            steps {
                sh 'docker network create my_network || true'
                dir(env.PROJECT_DIR) {
                    sh """
                        docker build -t ${DEPLOY_IMAGE} -f node-deploy.Dockerfile .
                        docker rm -f app || true
                        docker run -d -p 8081:8080 --name app --network my_network ${DEPLOY_IMAGE}
                    """
                }
            }
}
```

![tests](./Zrzut%20ekranu%202025-04-22%20205756.png)
```groovy
stage('Tests') {
            steps {
                dir(env.PROJECT_DIR) {
                    sh "docker build -t ${TEST_IMAGE} -f node-test.Dockerfile . | tee logs/test.log"
                }
            }
}
```

![build](./Zrzut%20ekranu%202025-04-22%20205751.png)
```groovy
stage('Build') {
            steps {
                dir(env.PROJECT_DIR) {
                    sh "docker build -t ${BUILD_IMAGE} -f node-build.Dockerfile . | tee logs/build.log"
                }
            }
}

```

![logs](./Zrzut%20ekranu%202025-04-22%20205746.png)
```groovy
stage('Logs') {
            steps {
                dir(env.PROJECT_DIR) {
                    sh 'mkdir -p logs && touch logs/build.log logs/test.log'
                }
            }
}
```

![prepare](./Zrzut%20ekranu%202025-04-22%20205742.png)
```groovy
stage('Prepare') {
            steps {
                sh '''
                    rm -rf MDO2025_INO
                    git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
                    cd MDO2025_INO
                    git checkout MD415045
                '''
            }
}
```

![env](./Zrzut%20ekranu%202025-04-22%20210043.png)
```groovy
environment {
        PROJECT_DIR = 'MDO2025_INO/ITE/GCL06/MD415045/lab5'
        BUILD_NUMBER = "1.0"
        NODE_VERSION = '23-alpine'
        BUILD_IMAGE = "node-build:${NODE_VERSION}"
        TEST_IMAGE = "node-test:v${BUILD_NUMBER}"
        DEPLOY_IMAGE = "node-deploy:v${BUILD_NUMBER}"
        
}
```
![dind](./Zrzut%20ekranu%202025-04-22%20161755.png)






