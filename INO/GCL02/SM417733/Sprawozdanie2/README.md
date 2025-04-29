# Sprawozdanie: Pipeline

Szymon Majdak

## Przygotowanie Jenkinsa

Aby odpowiednio przygotować Jenkinsa stworzyłem ```Dockerfile.jenkins```, który zainstaluje na kontenerze Jenkinsa razem z pluginami: ```git```, ```blueocean```, ```docker-workflow```.

Dockerfile.jenkins:
```
FROM jenkins/jenkins:lts
USER root
RUN apt-get update && apt-get install -y docker.io git
USER jenkins
RUN jenkins-plugin-cli --plugins blueocean git docker-workflow
```

Aby stworzyć i uruchomić taki kontener użyłem pliku ```docker-compose.yml```:
```
version: "3.8"
services:
  jenkins:
    build:
      context: .
      dockerfile: Dockerfile.jenkins
    user: root
    ports:
      - "8080:8080"
    volumes:
      - jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - DOCKER_HOST=unix:///var/run/docker.sock

volumes:
  jenkins_home:
  ```

Po skorzystaniu z komendy ```docker-compose up --build``` stworzyłem i uruchomiłem ten kontener.

Po wejściu na stronę ```{ip_fedory}:8080``` otrzymałem taki wynik:

![1](https://github.com/user-attachments/assets/2a484776-0ba9-43ef-af98-d881b9ce5056)

Z pliku ```initialAdminPassword``` wyciągnąłem hasło do Jenkinsa:

![2](https://github.com/user-attachments/assets/e90f0b77-a8b9-42fb-9a95-09cb2236266c)

## Proste projekty

Po zalogowaniu się jako admin w Jenkinsie stworzyłem pierwszy pusty ptojekt, który w powłoce uruchamiał ```uname```. Wyniki z logów konsoli poniżej:

![3](https://github.com/user-attachments/assets/c938c8ba-28b5-4b74-82fa-dbc3f3c3fc8e)

Drugim projektem było wyrzucenie błędu, jeśli godzina jest nieparzysta. Kod i wyniki poniżej:

![4](https://github.com/user-attachments/assets/5e517eb9-10a8-4338-b85c-7e400e6d9f1c)
![5](https://github.com/user-attachments/assets/921764c1-cef4-4390-bada-6f791b8449e5)
![6](https://github.com/user-attachments/assets/628e97da-c1a1-465a-814b-f8dbff738b44)

Ostatnim prostym projektem było uruchomienie ```docker pull ubuntu```:

![7](https://github.com/user-attachments/assets/e14bb057-76a3-4881-bb20-5a956d0c9ba9)

Kolejnym krokiem było stworzenie prostego pipeline'u, który sklonuje repozytorium z zajęć i zbuduje redis-a na podstawie Dockerfile.redisbld z poprzednich zajęć. Pipeline wygląda następująco:

```
  pipeline {
    agent any

    stages {
        stage('Clone repo') {
            steps {
                git branch: 'SM417733', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Build Docker image') {
            steps {
                dir ("INO/GCL02/SM417733/Sprawozdanie2")
                {
                    script {
                        docker.build('build', '-f Dockerfile.redibld .')
                    }   
                }
            }
        }

        stage('Print info') {
            steps {
                echo 'Pipeline ran successfully. Docker image was built.'
            }
        }
    }
}
```

Wyniki:

![8](https://github.com/user-attachments/assets/fe67018e-314d-491d-8462-c077fd22cd39)

Pipeline ten uruchomiłem dwa razy:

![9](https://github.com/user-attachments/assets/fa22e3c7-c16c-4da0-b556-291e0198d322)

## Projekt Pipeline CI dla Aplikacji Webowej

Moim wyborem co do aplikacji webowej był, tak jak na poprzednich zajęciach, redis.

Wykorzystałem podejście DinD (Docker-in-Docker), ponieważ pozwala na uruchamianie kontenerów w Jenkisie i używanie takich funkcji jak ```docker build```, ```docker run``` itp., a w moim projekcie korzystam z Dockerfile'ów.

Poniżej znajduje się diagram UML pokazujący działanie pipeline'u.

Mój pipeline składa się z nastepującch etapów:
- Clone repo:
Klonowaie rezpozytorium z zajęć i ustawienie odpowiedniego brancha ```SM417733```
- Build: Budowanie redisa za pomocą ```Dockerfile.redibld``` z poprzednich zajęć. Tutaj funkcja ```--no-cache``` pozwala na uniknięcie cahchowania programu i będziemy mieli oryginalny plik. Następnie skopiowanie ```redis-server``` (serwer) oraz ```redis-cli``` (klient, przyda się do pingowania) do katalogu z artefaktami.
- Test: Zbudowanie kontenera testowego na podstawie kontenera buildowego i pliku z poprzednich zajęć ```Dockerfile.redistest```. Zawarłem również zapisywanie logów z testów do osobnego pliku, który umieszczam w katalogu logs.
- Runtime: Tworzy kontener z plików ```redis-server``` i ```redis-cli``` na kontenerze według ```Dockerfile.deploy```, przez co mamy gotowy do uruchomienia serwer.
- Deploy: Uruchamia serwer lokalnie na porcie 6379 i jest gotowy do nasłuchu.
- Smoke test: Czeka chwilę, a następnie uruchamia ```redis-cli``` z komendą PING, która sprawdza czy redis działa. Redis nie działa na HTTPS API, więc używanie ```curl``` nie jest tu potrzebne.
- 
  ![14](https://github.com/user-attachments/assets/cff2c332-3ccc-40a4-acd5-e15340b23702)

  Jak widać na załączonym obrazku, mamy odpowiedź "PONG", więc redis-server działa.
- Publish: Loguje się na Dockerhub i publikuje tam stworzony kontener z redisem.

  ![15](https://github.com/user-attachments/assets/adb9e91c-062d-44fe-ad39-6058f17338ec)

Całość pipeline'a najpierw uruchomiłem wpisując go bezpośredno do Jenkinsa. Po *kliku* próbach udało się.

![11](https://github.com/user-attachments/assets/c31ff1bc-dcc5-4f79-9043-7d594d06a8f3)

Następnie całość umieściłem w ```Jenknsfile```, który umieściłęm w repozytorium i jeszcze raz uruchomiłem pipeline w Jenkinsie, tym razem popbierając treść Jenkinsfile'a z Githuba.

Poprawne przejście przez cały pipeline oraz zapisanie artefaktów zamieszczam poniżej:

![13](https://github.com/user-attachments/assets/f82e7cdd-6989-412b-b4d5-e36dc465b310)

Jenkinsfile:
```
pipeline {
    agent any
    
environment {
    WORKDIR = "INO/GCL02/SM417733/Sprawozdanie2"
}

    stages {
        stage('Clone repo') {
            steps {
                git url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git', branch: 'SM417733'
            }
        }

        stage('Build') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('redis-build', '-f Dockerfile.redisbld --no-cache .')
                        def containerId = sh(script: "docker create redis-build", returnStdout: true).trim()
			sh 'mkdir -p artifacts'
                        sh "docker cp ${containerId}:/redis/src/redis-server artifacts/redis-server"
                        sh "docker cp ${containerId}:/redis/src/redis-cli artifacts/redis-cli"
                        sh "docker rm ${containerId}"
                    }
                }
            }
        }
        stage('Test') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('redis-test', '-f Dockerfile.redistest .')
                        sh 'mkdir -p logs'
                        def cid = sh(script: "docker create redis-test", returnStdout: true).trim()
                        sh "docker cp ${cid}:/redis/tests/test-results.log logs/redis_test.log || echo 'No logs found'"
                        sh "docker rm ${cid}"
                    }
                }
            }
        }
        stage('Runtime') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('redis_runtime', '-f Dockerfile.deploy .')
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh "docker run -d -p 6379:6379 --name redis_deploy redis_runtime"
                }
            }
        }

        stage('Smoke Test') {
            steps {
                script {
                    sh "sleep 5"
                    sh 'docker exec redis_deploy /app/redis-cli ping || echo "Redis nie odpowiada"'
                }
            }
        }
        stage('Publish') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        def imageName = "pszemo6/redis_runtime:${BUILD_NUMBER}"
                        sh '''
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker tag redis_runtime ''' + imageName + '''
                            docker push ''' + imageName + '''
                        '''
                    }
                }
            }
        }
    }
    post {
        always {
            dir("${WORKDIR}") {
                archiveArtifacts artifacts: 'artifacts/*', fingerprint: true
                archiveArtifacts artifacts: 'logs/**', fingerprint:true
            }
            script {
                sh 'docker stop redis_deploy || true'
                sh 'docker rm redis_deploy || true'
            }
        }
    }
}
```

Dockefile.redisbld:
```
FROM fedora:latest

RUN dnf install -y gcc-c++ make tcl git openssl-devel systemd-devel curl procps-ng && dnf clean all

RUN git clone https://github.com/redis/redis.git /redis

WORKDIR /redis

RUN make
```

Dockerfile.redistest:
```
FROM redis-build

RUN dnf install -y tcl which

WORKDIR /redis

RUN make test | tee /redis/tests/test-results.log || true
```

Dockerfile.deploy:
```
FROM fedora:latest

WORKDIR /app

COPY artifacts/redis-server /app/redis-server
COPY artifacts/redis-cli /app/redis-cli

RUN chmod +x /app/redis-server /app/redis-cli

EXPOSE 6379

CMD ["./redis-server", "--port", "6379"]
```
