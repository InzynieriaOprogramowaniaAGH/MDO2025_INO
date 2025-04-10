# Zajęcia 05

## Utworzenie instancji Jenkins

![alt text](./img/image15.png)

https://www.jenkins.io/doc/book/installing/docker/

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

![alt text](./img/image12.png)

![alt text](./img/dockerfile.png)

    docker build -t myjenkins-blueocean -f Dockerfile.blueocean .

![alt text](./img/image8.png)    

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
    myjenkins-blueocean

![alt text](./img/image18.png)

## Konfiguracja wstępna i pierwsze uruchomienie

![alt text](./img/image16.png)

![alt text](./img/image11.png)

![alt text](./img/image2.png)

![alt text](./img/image1.png)

## Utworzenie projektów

![alt text](./img/image7.png)

![alt text](./img/image14.png)

![alt text](./img/image9.png)

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

![alt text](./img/image5.png)

![alt text](./img/image10.png)

![alt text](./img/image20.png)

![alt text](./img/image19.png)

## Utworzenie pierwszego pipelinea

    pipeline {
        agent any

        stages {
            stage('Clone') {
                steps {
                    git branch: 'AZ416400', 
                        url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
                }
            }

            stage('Build') {
                steps {
                    dir('ITE/GCL08/AZ416400/Sprawozdanie1/Dockerfiles') {
                        sh 'docker rmi -f irssi-build || true'
                        sh 'docker builder prune --force --all'
                        sh 'docker build -t irssi-build -f Dockerfile.irssibld .'
                    }
                }
            }
        }
    }

![alt text](./img/image6.png)

![alt text](./img/image13.png)

![alt text](./img/image3.png)

![alt text](./img/image17.png)

![alt text](./img/image4.png)