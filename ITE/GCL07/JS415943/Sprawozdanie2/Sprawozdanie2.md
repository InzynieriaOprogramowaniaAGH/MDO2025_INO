# Sprawozdanie 2
## Laboratorium 5 - Pipeline, Jenkins, izolacja etapów
### 1. Uruchomienie czystego Jenkinsa w Dockerze
1.1 Sieć mostkowa
```bash
sudo docker network create jenkins
```
![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/1.1docker-network-create-jenkins-1.png)

1.2 Docker-in-Docker (dind)
```bash
sudo docker run -d --name jenkins-docker \
  --privileged \
  --network jenkins --network-alias docker \
  -e DOCKER_TLS_CERTDIR=/certs \
  -v jenkins-docker-certs:/certs/client \
  -v jenkins-data:/var/jenkins_home \
  -p 2376:2376 \
  docker:dind --storage-driver overlay2
  ```
  ![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/1.2dind.png)

  1.3 Kontroler Jenkins
  ```bash
  sudo docker run -d --name jenkins \
  --network jenkins \
  -e DOCKER_HOST=tcp://docker:2376 \
  -e DOCKER_CERT_PATH=/certs/client \
  -e DOCKER_TLS_VERIFY=1 \
  -u root \
  -v jenkins-docker-certs:/certs/client:ro \
  -v jenkins-data:/var/jenkins_home \
  -p 8080:8080 -p 50000:50000 \
  jenkins/jenkins:lts-jdk17
```
![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/1.3jenkins.png)

1.4 Pozyskanie hasła administratora
![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/1.4admin.png)

1.5 Uzyskanie ip maszyny poprzez polecenie `ip add`
![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/1.5ipadd.png)

1.6 Wejście na adres `192.168.100.40:8080` oraz zalogowanie się
![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/1.6login.png)

1.7 Instalacja wtyczek, stworzenie administratora i konfiguracja instancji
![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/1.7konfiguracja.png)

### 2. Uruchamianie

2.1 Projekt który wyświetla `uname`
![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/2.1.1status.png)
![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/2.1.2wynik.png)

2.2 Projekt, który zwraca błąd gdy godzina jest nieparzysta

```bash
H=$(date +%H)
if [ $((H % 2)) -eq 1 ]; then
  echo "Jest godzina $H – nieparzysta, zadanie konczy sie bledem"
  exit 1
else
  echo "Godzina $H parzysta – wszystko OK"
fi
```

![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/2.2wynik.png)

2.3 Projekt, który pobiera obraz ubuntu poprzez `docker pull ubuntu`

![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/2.3wynik.png)

3. Obiekt typu pipeline

Pipeline klonuje repozytorium przedmiotowe, przełącza się na gałąź JS415943, a następnie buduje dwa obrazy Dockera: node-build (instalujący zależności aplikacji Node.js) oraz node-run (uruchamiający aplikację). Na końcu uruchamiany jest kontener z obrazu node-run, co pozwala na automatyczne sprawdzenie działania aplikacji.
```groovy
pipeline {
    agent any

    stages {
        stage('Zadanie') {
            steps {
                echo 'Klonowanie repozytorium przedmiotu'
                sh 'git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
                dir('MDO2025_INO') {
                    sh 'git checkout JS415943'
                }
                dir('MDO2025_INO/ITE/GCL07/JS415943/Sprawozdanie2/Lab5') {
                    sh '''
                    docker build -f ./Dockerfile.build -t node-build .
                    docker build -f ./Dockerfile.run -t node-run .
                    docker run -d --rm node-run
                    '''
                }
            }
        }
    }
}
```
![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/2.4konsola.png)


Przy kolejnym uruchomieniu pojawił się błąd ponieważ w kontenerze znajduje się już sklonowane repozytorium

![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/2.5drugieuruchomienie.png)

Zmiana skryptu 

```groovy
pipeline {
    agent any

    stages {
        stage('Zadanie') {
            steps {
                echo 'Czyszczenie poprzedniego klonu (jeśli istnieje)'
                sh 'rm -rf MDO2025_INO'

                echo 'Klonowanie repozytorium przedmiotu'
                sh 'git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'

                dir('MDO2025_INO') {
                    sh 'git checkout JS415943'
                }

                dir('MDO2025_INO/ITE/GCL07/JS415943/Sprawozdanie2/Lab5') {
                    sh '''
                    docker build -f ./Dockerfile.build -t node-build .
                    docker build -f ./Dockerfile.run -t node-run .
                    docker run -d --rm --name node-app node-run
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Zatrzymywanie działającego kontenera (jeśli istnieje)'
            sh 'docker rm -f node-app || true'
            cleanWs()
        }
    }
}
```
Dodano `rm -rf MDO2025_INO` przed `git clone` oraz zatrzymywanie działającego kontenera, aby uniknąć błędu przy kolejnym uruchomieniu. 

![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab5/2.6zmianapipeline.png)


## Laboratorium 6: Pipeline: lista kontrolna

Wybrana aplikacja: [node-js-dummy-test](https://github.com/devenes/node-js-dummy-test)

Kontenery: 
  - `Dockerfile.build`
  - `Dockerfile.test`
  - `Dockerfile.deploy`

### Zawartość kontenerów: 
- `Dockerfile.build` 

Kontener odpowiedzialny za proces budowania aplikacji. Klonuje repozytorium node-js-dummy-test, ustawia katalog roboczy i instaluje zależności za pomocą npm install. Jest bazą do dalszych etapów pipeline'u (test, deploy).
```Dockerfile
FROM node:22.10
RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test
RUN npm install
  ```

- `Dockerfile.test`

Kontener testujący, oparty na obrazie node-build, który zawiera już zbudowaną aplikację z zależnościami. W katalogu roboczym uruchamiane są testy jednostkowe (npm test).

```Dockerfile
FROM node-build
WORKDIR /node-js-dummy-test
CMD ["npm", "test"]
```

- `Dockerfile.deploy`

Lekki kontener uruchomieniowy (bazujący na node:22.10-slim), do którego kopiowane są jedynie niezbędne pliki: zależności (node_modules), źródła (src, views) i plik package.json. Służy do uruchomienia aplikacji (npm start) w środowisku produkcyjnym.
```Dockerfile
FROM node:22.10-slim
WORKDIR /app
COPY node_modules/ ./node_modules/
COPY package.json ./package.json
COPY src/ ./src/
COPY views/ ./views/
CMD ["npm", "start"]
```
Polecenia do budowania kontenerów:

```bash
docker build -f ./Dockerfile.build -t node-build .
docker build -f ./Dockerfile.test -t node-test .
docker create --name temp-build-container node-build
```

### Etapy pipeline:

- `Clone`
```groovy
stage('Clone') {
            steps {
                git branch: 'JS415943', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO'
            }
        }
```
Pobranie projektu z brancha

- `Clean`
```groovy
stage('Clean') {
            steps {
                dir('ITE/GCL07/JS415943/Sprawozdanie2/Lab6') {
                    sh '''
                        docker container ls -a -q | xargs -r docker rm -f
                        docker volume ls -q | xargs -r docker volume rm -f
                        docker network ls -q --filter type=custom | xargs -r docker network rm -f
                        docker builder prune --all --force
                        docker images -q | sort -u | grep -vE '^(node:22\\.10|node:22\\.10-slim)$' | xargs -r docker rmi -f
                    '''
                }
            }
        }
```
Usunięcię zbędnych kontenerów, wolumenów, sieci i obrazów w celu wyczyszczenia środowiska przed kolejnym buildem

- `Build`
```groovy
stage('Build') {
            steps {
                dir('ITE/GCL07/JS415943/Sprawozdanie2/Lab6') {
                    sh 'docker build -f Dockerfile.build -t $IMAGE_BUILD .'
                }
            }
        }
```
Zbudowanie obrazu `node-build` zawierającego zależności i źródło aplikacji

- `Test`
```groovy
stage('Test') {
            steps {
                dir('ITE/GCL07/JS415943/Sprawozdanie2/Lab6') {
                    sh 'docker build -f Dockerfile.test -t $IMAGE_TEST .'
                    sh 'docker run --rm $IMAGE_TEST > test-${VERSION}.log'
                    archiveArtifacts artifacts: "test-${VERSION}.log", onlyIfSuccessful: true
                }
            }
        }
```
Zbudowanie obrazu testowego `node-test` bazującego na build, uruchomienie testów poprzez `npm test` oraz zapisanie logów jako artefakt w `.log`

- `Deploy`
```groovy
stage('Deploy') {
            steps {
                dir('ITE/GCL07/JS415943/Sprawozdanie2/Lab6') {
                    sh '''
                        docker create --name temp-build-container $IMAGE_BUILD
                        docker cp temp-build-container:/node-js-dummy-test/node_modules ./node_modules
                        docker cp temp-build-container:/node-js-dummy-test/package.json .
                        docker cp temp-build-container:/node-js-dummy-test/src ./src
                        docker cp temp-build-container:/node-js-dummy-test/views ./views
                        docker rm temp-build-container
                        docker build -f Dockerfile.deploy -t $IMAGE_DEPLOY:$VERSION .
                    '''
                }
            }
        }
```
Stworzenie nowego odchudzonego kontenera `node-deploy` poprzez skopiowanie tylko niezbędnych plików (bez .git, dev-tools itd.)

- `SmokeTest`
```groovy
stage('SmokeTest') {
            steps {
                dir('ITE/GCL07/JS415943/Sprawozdanie2/Lab6') {
                    sh '''
                        docker network create ci || true
                        docker run -dit --network ci --name deploy -p 3000:3000 $IMAGE_DEPLOY:$VERSION
                        sleep 5
                        docker run --rm --network ci curlimages/curl curl http://deploy:3000
                        docker stop deploy
                        docker rm deploy
                        docker network rm ci
                    '''
                }
            }
        }
```

Uruchomienie aplikacji poprzez kontener `node-deploy` w sieci ci, sprawdzenie odpowiedzi aplikacji poprzez curl na porcie 3000, zamknięcie kontenera i usunięcie sieci

- `Publish`
```groovy
stage('Publish') {
            steps {
                dir('ITE/GCL07/JS415943/Sprawozdanie2/Lab6') {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            docker run --rm -v $PWD:/app -w /app debian bash -c "apt-get update && apt-get install -y zip && zip -r ${ZIP_BASE}-${VERSION}.zip node_modules/ src/ views/ package.json"
                        '''
                        archiveArtifacts artifacts: "${ZIP_BASE}-${VERSION}.zip", onlyIfSuccessful: true

                        sh '''
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker tag $IMAGE_DEPLOY:$VERSION $IMAGE_TAG
                            docker push $IMAGE_TAG
                        '''
                    }
                }
            }
        }
```
Stworzenie pliku zip zawierającego aplikacje, zarchiwizowanie go w Jenkinsie, zalogowanie do DockerHub oraz wypchnięcie obrazu

![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab6/Screenshots/1.2wynikpipe.png)

### Ostateczny diagram UML
![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab6/Screenshots/UML.png)

## Laboratorium 7: Jenkinsfile: Lista kontrolna

-  Jenkinsfile dostarczany z SCM

![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab7/1.0SCM.png)

- Zawsze najnowszy kod
 
![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab7/2.0niecache.png)

- Proces publikacji artefaktu

Artefakt ZIP zawiera minimalną wersję aplikacji (node_modules, src, views, package.json). Jest tworzony w kontenerze debianowym i zapisywany jako artefakt Jenkinsa.
Obraz kontenera deploy jest pushowany do DockerHub pod tagiem `tygrysiatkomale/node-deploy:vX`, co umożliwia jego uruchomienie na dowolnej maszynie:

```bash
docker pull tygrysiatkomale/node-deploy:v3
docker run -p 3000:3000 tygrysiatkomale/node-deploy:v3
```

![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab7/3.0dockertygrysiatko.png)
![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab7/3.1app.png)

### "Definition of done"

- Opublikowany obraz tygrysiatkomale/node-deploy:vX może zostać pobrany i uruchomiony na dowolnej maszynie z Dockerem. Obraz zawiera wszystkie niezbędne pliki (`node_modules`, `src`, `views`, `package.json`) oraz ma zdefiniowany poprawny entrypoint (`npm start`), co umożliwia jego natychmiastowe uruchomienie bez dodatkowej konfiguracji.

- Pipeline generuje także artefakt ZIP zawierający `node_modules`, `src`, `views`, `package.json`. Jest on archiwizowany w Jenkinsie jako wynik builda. Po pobraniu może zostać pobrany oraz uruchomiony lokalnie za pomocą Node.js:
```bash
npm install
npm start
```

![](/ITE/GCL07/JS415943/Sprawozdanie2/Lab7/4.0artefakt.png)