# Sprawozdanie 2
## Maciej Serafin [MS416436]

---
Repozytoria programów:
- https://github.com/devenes/node-js-dummy-test

---

### Instancja Jenkins i przygotowanie do tworzenia pipeline'ów

1. Wykonanie kolejno instrukcji instalacji Jenkinsa

```
docker network create jenkins
```
![alt text](<Zrzut ekranu 2025-04-01 024833-1.png>)


- Uruchomienie dockera z jenkinsem z dind

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

```
![alt text](<Zrzut ekranu 2025-04-01 024922-1.png>)


2. Utworzenie dockerfile 

```dockerfile
FROM jenkins/jenkins:2.492.2-jdk17
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
![alt text](<Zrzut ekranu 2025-04-01 025059-1.png>)

3. Stworzenie kontenera
```
docker build -t myjenkins-blueocean:2.492.2-1 .
```

![alt text](<Zrzut ekranu 2025-04-01 025342-1.png>)


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
  myjenkins-blueocean:2.440.2-1
```


![alt text](<Zrzut ekranu 2025-04-01 025446-1.png>)


4. Działające kontenery

![alt text](<Zrzut ekranu 2025-04-01 025931-1.png>)

5. Sprawdzenie czy działa jenkins po http

![alt text](<Zrzut ekranu 2025-04-27 134547-1.png>)

- Pobranie hasła administratora Jenkinsa:
Po uruchomieniu kontenera użyłem docker logs jenkins, aby wyciągnąć początkowe hasło administratora zapisane w /var/jenkins_home/secrets/initialAdminPassword


- Instalacja wtyczek w Jenkinsie:
Następnie przeszedłem do etapu instalacji wtyczek w Jenkinsie.

---
### Stworzenie pierwszego pipeline uname

- Projekt testowy — sprawdzenie systemu:
W Jenkinsie utworzyłem zadanie wykonujące uname -a, które poprawnie zwróciło informacje o jądrze i systemie w logach.


![alt text](<Zrzut ekranu 2025-04-27 130657-1.png>)
![alt text](<Zrzut ekranu 2025-04-27 130924-1.png>)


---
### Stworzenie pipeline sprawdzającego godzinę

- Projekt testowy — sprawdzenie parzystości godziny:
Utworzyłem zadanie w Jenkinsie, które skryptem basha sprawdzało, czy aktualna godzina jest parzysta. Przy nieparzystej godzinie skrypt kończył się błędem "Failure: The hour is odd.".

![alt text](<Zrzut ekranu 2025-04-27 131116-1.png>)
![alt text](<Zrzut ekranu 2025-04-27 131116-1-1.png>)


- Pipeline — klonowanie repozytorium i budowa obrazu:
W Jenkinsie stworzyłem pipeline z trzema etapami: klonowaniem repozytorium z GitHuba (branch MS416436), sprawdzaniem zawartości repo oraz budowaniem obrazu Dockera przy użyciu Dockerfile i polecenia docker build.

- Analiza wyników wykonania pipeline:
W logach konsoli Jenkinsa oraz w Pipeline Overview
![alt text](<Zrzut ekranu 2025-04-27 131826-1.png>) ![alt text](<Zrzut ekranu 2025-04-27 131745-1.png>) ![alt text](<Zrzut ekranu 2025-04-27 131800-1.png>) ![alt text](<Zrzut ekranu 2025-04-27 131808-1.png>) ![alt text](<Zrzut ekranu 2025-04-27 131815-1.png>) ![alt text](<Zrzut ekranu 2025-04-27 131822-1.png>)![alt text](<Zrzut ekranu 2025-04-27 132203-1.png>)

---
- Różnice między DIND a budowaniem w kontenerze CI:
W DIND każde zadanie budowy działa w osobnym kontenerze wewnątrz innego kontenera, zapewniając pełną izolację kosztem większej złożoności i konfiguracji.
Budowanie bezpośrednio w kontenerze CI jest prostsze, szybsze i zużywa mniej zasobów, ale oferuje mniejszą izolację.

---
### Wybór projektu do przeprowadzenia konkretnych zadań

- Wybór repozytorium node-js-dummy-test jest dobrym pomysłem, ponieważ projekt jest prosty, szybki do sklonowania i zbudowania, zawiera przykładowe testy, ma gotowe Dockerfile, a aplikacja po uruchomieniu działa na lekkim serwerze Node.js, co idealnie pasuje do pełnego pipeline’u obejmującego commit/trigger, clone, build, test, deploy i publish.


---
### Pipeline

```
pipeline {
    agent any

    stages {
        stage('Prepare') {
            steps {
                sh '''
                    rm -rf node-js-dummy-test
                    git clone https://github.com/MaciejSerafin/node-js-dummy-test.git
                    cd node-js-dummy-test
                '''
            }
        }

        stage('Logs') {
            steps {
                dir('node-js-dummy-test') {
                    sh 'touch build.log'
                    sh 'touch test.log'
                }
            }
        }

        stage('Build') {
            steps {
                dir('node-js-dummy-test') {
                    sh 'docker build -t node-builder -f jenkins/node-build.Dockerfile . | tee build.log'
                }
                archiveArtifacts artifacts: "node-js-dummy-test/build.log"
            }
        }

        stage('Tests') {
            steps {
                dir('node-js-dummy-test') {
                    sh 'docker build -t node-test -f jenkins/node-test.Dockerfile . | tee test.log'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker network create my_network || true'
                dir('node-js-dummy-test') {
                    sh 'docker build -t node-deploy -f jenkins/node-deploy.Dockerfile .'
                    sh 'docker rm -f app || true'
                    sh 'docker run -d -p 3000:3000 --name app --network my_network node-deploy'
                }
                sleep(10)
            }
        }

        stage('Publish') {
            steps {
                dir('node-js-dummy-test') {
                    archiveArtifacts artifacts: "artifacts/art.tar"
                    sh 'docker system prune --all --volumes --force'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh 'docker rmi node-builder node-test node-deploy || true'
        }
    }
}

```

- Prepare
Pierwszy etap przygotowuje środowisko pracy. Usuwa ewentualny stary katalog projektu, następnie klonuje aktualną wersję repozytorium z GitHuba, aby zapewnić, że pipeline pracuje na najnowszym kodzie.

- Logs
W tym kroku tworzone są pliki build.log i test.log, które będą rejestrować odpowiednio informacje z procesu budowania oraz testowania. Dzięki temu można później łatwo przeanalizować przebieg tych operacji.

- Build
Etap budowania obrazu Docker, który kompiluje aplikację w specjalnie przygotowanym środowisku na podstawie node-build.Dockerfile. Wynik procesu jest zapisywany w pliku build.log, a sam log jest archiwizowany jako artefakt do wglądu.

- Tests
W tym etapie budowany jest kolejny obraz Docker przy użyciu node-test.Dockerfile, w którym wykonywane są testy projektu. Wynik testów jest zapisywany w pliku test.log, co umożliwia późniejszą analizę poprawności działania aplikacji.

- Deploy
Po poprawnym przejściu testów, aplikacja jest wdrażana. Tworzona jest sieć Docker (jeśli jeszcze nie istnieje), budowany jest obraz do wdrożenia (node-deploy) i uruchamiany kontener z aplikacją, dostępny na porcie 3000.

- Publish
Na tym etapie archiwizowany jest artefakt (art.tar), który może zawierać przygotowane pliki lub gotową wersję aplikacji. Następnie wykonywane jest czyszczenie systemu Docker z niepotrzebnych obrazów i wolumenów, aby zachować porządek i oszczędność zasobów.

- Post - Cleanup
Bez względu na wynik działania pipeline’a, wykonywane jest sprzątanie — usuwane są obrazy stworzone podczas procesu (node-builder, node-test, node-deploy), aby zwolnić miejsce i utrzymać porządek w systemie.

![alt text](<Zrzut ekranu 2025-04-27 133644-1.png>) ![alt text](<Zrzut ekranu 2025-04-27 133718-1.png>) ![alt text](<Zrzut ekranu 2025-04-27 133734-1.png>) ![alt text](<Zrzut ekranu 2025-04-27 133749-1.png>) ![alt text](<Zrzut ekranu 2025-04-27 133754-1.png>) ![alt text](<Zrzut ekranu 2025-04-27 133759-1.png>) ![alt text](<Zrzut ekranu 2025-04-27 133809-1.png>)

---
### Błędy na jakie na natrafiłem podczas budowania pipeline'u

-Podczas budowania pipeline'u napotkałem na błędy, takie jak "dial unix /var/run/docker.sock: connect: permission denied" oraz ERROR: error during connect: Head "https://docker:2376/_ping": dial tcp: lookup docker on 127.0.0.11:53: server misbehaving. Problemy te wynikały z uruchamiania kontenerów bez odpowiednich uprawnień oraz braku poprawnie działającego środowiska DIND. W wyniku tych trudności konieczne było kilkukrotne usunięcie instancji Jenkinsa i jej ponowne utworzenie, aby zapewnić prawidłowe działanie całego procesu.

![alt text](<Zrzut ekranu 2025-04-27 134446-1.png>)
![alt text](<Zrzut ekranu 2025-04-27 134752-1.png>)