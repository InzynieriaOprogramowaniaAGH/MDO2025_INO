# Sprawozdanie 2

Do wykonywania zadań laboratoryjnych skorzystałam z programu "To do List", wykorzystywanego przeze mnie na poprzednich zajęciach.

Jenkins to  narzędzie do automatyzacji procesów tworzenia, testowania i wdrażania naszej aplikacji, natomiast BlueOcean to jego rozszerzenie, które daje nam bardziej nowoczensy i intuicyjny interfejs do zarządzania procesami CI/CD.


### Przygotowanie

Upewniłam się, że działają kontenery budujące i testujące, które tworzyłam na poprzednich zajęciach

Zapoznałam się z instrukcją instalacji Jenkinsa.

Pracę rozpoczęłam od utworzenia sieci dla Jenkinsa korzystając z następującego polecenia:

` docker network create jenkins `

Nastepnie uruchomiłam kontener dind (Docker-in-Docker) korzystając z gotowego obrazu:

``` docker run \
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
 

Stworzłam Dockerfile dla własnego obrazu zawierającego Blue Ocean:

``` 
FROM jenkins/jenkins:2.440.3-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow" 

```

Zbudowałam obraz:

docker build -t blueocean -f Blueocean.Dockerfile .

I uruchomiłam kontener:

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
  blueocean 
  
  ```

W celu przeprowadzenia konfiguracji Jenkinsa weszłam na stronę http://localhost:8080, wpisałam hasło (pozyskane zgodnie z opisem w poprzednim sprawozdaniu) i utworzyłam nowego użytkownika.

![alt text](screens/użytkownik.png)

### Zadanie wstępne: uruchomienie

Rozpoczęłam pracę nad pierwszym projektem, którego celem było wyświetlenie wyniku polecenia uname. W konfiguracji projektu wybrałam opcję "Uruchomienie powłoki" i dodałam polecenie:

` uname -a `

![alt text](screens/uname2.png)

Zrzut ekranu potwierdzający poprawne działanie projektu:

![alt text](screens/uname.png)

Drugi projekt miał na celu zwracanie błędu, gdy aktualna godzina jest nieparzyst. W powłoce użyłam następującego skryptu:

```

if [ $(( $(date +%H) % 2 )) -eq 1 ]; then
    echo "Godzina jest nieparzysta."
    exit 1
else
    echo "Godzina jest parzysta."
fi

```

![alt text](screens/hour1.png)

![alt text](screens/hour2.png)

Kolejno przeszłam do pobierania w projekcie obraz kontenera ubuntu stosując docker pull:

![alt text](screens/docker_pull2.png)

![alt text](screens/docker_pull.png)

### Pipeline: 

Zaimplementowałam obiekt typu pipeline, który klonuje repozytorium, buduje i testuje obrazy Dockera, a następnie uruchamia aplikację i sprawdza jej działanie oraz publikuje ją w lokalnym rejestrze pakietów. Na końcu automatycznie czyści wszystkie kontenery, obrazy i pliki, żeby zostawić czyste środowisko.

Kod pipeline:

```
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                sh '''
                #!/bin/bash
                docker system prune -f
                docker image prune -f
                docker container prune -f
                rm -rf ITE
                '''
                git branch: 'MK414948', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }
        stage('Build') {
            steps {
                dir('ITE/GCL04/MK414948/Sprawozdanie1/pliki/Dockerfiles') {
                    script {
                        docker.build('nodebld', '-f Dockerfile.nodebld .')
                    }
                }
            }
        }
        stage('Test') {
            steps {
                dir('ITE/GCL04/MK414948/Sprawozdanie1/pliki/Dockerfiles') {
                    script {
                        docker.build('nodetest', '-f Dockerfile.nodetest .')
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'docker network create deploy || true'

                    def node = docker.build('nodedeploy', '-f ITE/GCL04/MK414948/Sprawozdanie2/pliki/Dockerfile.nodedeploy .')
                    def container = node.run("--rm -d -p 3000:3000 --network=deploy --name node")

                    sh 'docker run --rm --network=deploy curlimages/curl:latest -L -v  http://node:3000'

                    sh "docker stop node"
                    sh 'docker network rm deploy'
                    sh 'docker rmi nodedeploy'
                }
            }
        }
        stage('Publish') {
            steps {
                script {
                    sh "docker network create publish || true"

                    sh '''
                    docker run --network=publish --name verdaccio -d -p 4873:4873 verdaccio/verdaccio || docker start verdaccio
                    '''

                    def publishImg = docker.build('nodepublish', '-f ITE/GCL04/MK414948/Sprawozdanie2/pliki/Dockerfile.nodepublish .')

                    def container = publishImg.run("--network=publish --name node")
                    sleep 5

                    sh 'docker stop node'
                    sh 'docker stop verdaccio'
                    sh "docker network rm publish"
                }
            }
        }
    }

    post {
        always {
            sh 'docker system prune -af'
            sh 'rm -rf ITE'
        }
    }
}
```
![alt text](screens/pipeline.png)


Wybrany projekt: "ToDoWebApp" bazujący na Node.js.

Pipeline składa się z następujących etapów:

Checkout- etap, ktory pobiera zawartość mojej gałęzi zawierającej wymagane Dockerfile. Na początku wykonuje skrypt oczszczający workspace oraz Dockera, aby zwolnić pamięć.

Build- Jenkins uruchamia proces budowania obrazu Docker w DIND. Jeśli wszystko pójdzie pomyślnie zwróci gotowy obraz, w przeciwnym wypadku buid zakończy się niepowodzeniem. Dockerfile, który jest używany w tym stage'u został wykonany na jednych z poprzednich zajęć.

Test- uruchamia proces budowania obrazu, ale tym razem z użyciem innego Dockerfile (również napisanego na jednych z poprzednich zajęć) przeznaczonego do testowania. Po zbudowaniu obrazu uruchamianane sa testy jednostkowe, aby upewnić się, że wszystko działa poprawnie. Etap uznany jest za zakończony sukcesem jeśli wszystkie testy przejdą pomyślnie. 

Deploy- ten etap sprawdza, czy uruchomiona aplikacja działa poprawnie i jest dostępna na wskazanym porcie. W tym celu, tworzy dedykowaną sieć Docker, uruchamia aplikację w kontenerze i wykonuje test łączności za pomocą kontenera z curlem, który sprawdza dostępność aplikacji na porcie 3000. Jeśli aplikacja jest dostępna to test łączności uznany zostaje jako udany. Po zakończeniu usuwane są wszystkie kontenery i sieć, aby zwolnić zasoby.

Pubish- ten etap tworzy lokalne repozytorium (jeśli jeszcze nie istnieje) i publikuje w nim nową wersję pakietu aplikacji. Używany jest do tego kontener z aplikacją verdaccio. Po opublikowaniu nowej wersji kontenery są zatrzymywane a sieć usuwana. 

Sekcja post działa zawsze po zakończeniu pipeline'u niezależnie od tego, czy zakończył się sukcesem, czy nie. U mnie odpowiada za usunięcie wszystkich pozostałości i przywraca czyste środowisko do kolejnych uruchomień pipeline'a.

