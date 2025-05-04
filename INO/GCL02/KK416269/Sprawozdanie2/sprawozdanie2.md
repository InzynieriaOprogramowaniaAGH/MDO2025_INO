# **Sprawozdanie 2** - Metodyki DevOps
_________________________________________________________________________________________________________________________________________________________
## **LAB 5-7 Pipeline & Jenkins** 

Celem niniejszego laboratorium było zapoznanie się z koncepcją pipeline’ów CI/CD w Jenkinsie. W ramach zajęć skonfigurowano środowisko oparte na kontenerach Docker, przygotowano instancję Jenkinsa z pluginami BlueOcean, skonfigurowano procesy build/test/deploy oraz uruchomiono pipeline dla własnej aplikacji (Redis). Efektem końcowym było pełne uruchomienie aplikacji oraz archiwizacja logów i artefaktów z procesu.


### Przygotowanie - Utwórzenie instancji Jenkins 🌵
- [x] **Zapoznaj się z instrukcją instalacji Jenkinsa (https://www.jenkins.io/doc/book/installing/docker/)**
  - **Uruchom obraz Dockera który eksponuje środowisko zagnieżdżone**

  Uruchomiłam środowisko docker:dind, które umożliwia użycie Dockera wewnątrz kontenera:
  ```bash
    docker run --name jenkins-docker --rm --detach \
  --privileged --network jenkins --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind --storage-driver overlay2
  ```

  - **Przygotuj obraz blueocean na podstawie obrazu Jenkinsa**

Czym różni się zwykły jenkins od blue ocean? Jenkins to tradycyjne narzędzie do automatyzacji CI/CD. Jenkins Blue Ocean to bardziej nowoczesne rozszerzenie oferujące bardziej intuicyjny i wizualny interfejs, ułatwiający tworzenie, analizę i debugowanie pipeline’ów. Blue Ocean lepiej prezentuje przebieg pipeline’ów w formie graficznej, ale wymaga Jenkinsa jako bazy.
    
Przygotowałam własny obraz oparty o jenkins/jenkins, rozszerzony o pluginy, Docker CLI i wtyczki (musiałam je tu dodać gdyż w nnym wypadku coś nie chciało działać). Plik Dockerfile:
    
```bash
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
RUN jenkins-plugin-cli --plugins \
    blueocean \
    docker-workflow \
    github \
    github-branch-source \
    git \
    email-ext \
    token-macro \
    json-path-api \
    pipeline-stage-view
``` 

  - **Uruchom Blueocean**
Build komendą `docker build -t myjenkins-blueocean:fixed .`

![image](https://github.com/user-attachments/assets/785e3557-c6e4-4b42-bdff-448d8f98209c)


i uruchomiłam aby kontener działał jako serwer Jenkins z Blue Ocean, gotowy do zarządzania pipeline’ami.
``` bash
docker run --name jenkins-blueocean --restart=on-failure --detach \
    --network jenkins \
    --env DOCKER_HOST=tcp://docker:2376 \
    --env DOCKER_CERT_PATH=/certs/client \
    --env DOCKER_TLS_VERIFY=1 \
    --publish 8080:8080 --publish 50000:50000 \
    --volume jenkins-data:/var/jenkins_home \
    --volume jenkins-docker-certs:/certs/client:ro \
    myjenkins-blueocean:fixed
```

![image](https://github.com/user-attachments/assets/6d4f99fe-a371-4344-8b54-f279e5045e1f)


  - **Zaloguj się i skonfiguruj Jenkins**
Uruchomiłam kontener z obrazem myjenkins-blueocean i zalogowałam się przez przeglądarkę. Zainstalowałam wtyczki oraz skonfigurowałam podstawowe ustawienia.

![image](https://github.com/user-attachments/assets/4ef72433-238b-4642-83d7-237a6ddd165e)


### Zadanie wstępne: uruchomienie 🌵
- [x] **Konfiguracja wstępna i pierwsze uruchomienie**
  - **Utwórz projekt, który wyświetla uname**
W jenkinsie stworzyłam mój pierwszy prosty projekt któr wyświetlał wyniki komendy uname. W tym celu stworzyłam nowy projekt który w stworzonej powłoce włączał komendę `uname`. Wyniki przedstawiono poniżej:

![image](https://github.com/user-attachments/assets/32f424b8-e195-4b93-ae54-58d9cb769dfc)


  - **Utwórz projekt, który zwraca błąd, gdy... godzina jest nieparzysta**
Projekt wykonałam analogicnzie jak wcześniejszy, jedynie zmiana nastąpiła w kodzie, wyglądał on tak:
```bash
HOUR=$(date +%H)
if [ $(($HOUR % 2)) -eq 1 ]; then
  echo "Godzina jest nieparzysta - kończę zadanie z błędem."
  exit 1
else
  echo "Godzina jest parzysta - zadanie zakończone pomyślnie."
fi
```
Wyniki o godzinie 15:

![image](https://github.com/user-attachments/assets/ac5d9461-3e37-4f38-8109-717518d23158)

  - **Pobierz w projekcie obraz kontenera ubuntu (stosując docker pull)**
Znowu stworzyłam nowy projekt jak poprzednio, który wykonywał polecenie `docker pull ubuntu`
![image](https://github.com/user-attachments/assets/1bd8ec17-d554-4600-b856-da108c4bcd65)


### Zadanie wstępne: obiekt typu pipeline 🌵
- [x] **Utwórz nowy obiekt typu pipeline**
- [x] **Wpisz treść pipeline'u bezpośrednio do obiektu (nie z SCM - jeszcze!)**
- [x] **Spróbuj sklonować repo przedmiotowe (`MDO2025_INO`)**
Jak uprzednio stworzyłam nowy porjekt jednak tym razem był on typu pipeline. Aby wykonać w nim coś musiłam stworzyć nowy kod, w Jenkins Pipeline kod pisze się w języku Groovy.

Polecenie pipeline:
```bash
pipeline {
    agent any
    stages {
        stage('Clone repo') {
            steps {
                git url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git', branch: 'KK416269'
            }
        }
        stage('Build Docker (BUILD)') {
            steps {
                script {
                    sh 'docker build -t moj-builder -f INO/GCL02/KK416269/Sprawozdanie1/redis_obraz/Dockerfile.build .'
                }
            }
        }
    }
}
```
Działanie:

![image](https://github.com/user-attachments/assets/caabc8bc-932f-4521-a31f-a9b53f95c173)

##Moja aplikacja - Redis

##Lista kontrolna - Pipeline
- [x] **Aplikacja została wybrana**
Moją aplikacją jest Redis czyli baza danych typu klucz-wartość, która działa wyjątkowo szybko, przechowując dane w pamięci RAM.

- [x] **Licencja potwierdza możliwość swobodnego obrotu kodem na potrzeby zadania**
Redis jest dostępny na licencji open-source BSD 3-clause, która pozwala na swobodne używanie, modyfikowanie i dystrybucję kodu :)

- [x] **Wybrany program buduje się**
- [x] **Przechodzą dołączone do niego testy**
- [x] **Zdecydowano, czy jest potrzebny fork własnej kopii repozytorium**
Nie zdecydowałam się na wykonanie forka repozytorium, ponieważ miałam możliwość pracy bezpośrednio na osobnej gałęzi (mojej KK416269) w repozytorium przedmiotowym.

- [x] **Stworzono diagram UML zawierający planowany pomysł na proces CI/CD**
  Oba diagramy na końcu

- [x] **Wybrano kontener bazowy lub stworzono odpowiedni kontener wstępny (runtime dependencies)**

Użyłam obrazu bazowego ubuntu, na którym zainstalowałam wszystkie niezbędne zależności do zbudowania Redis. Dzięki temu zapewniłam spójne i odseparowane środowisko builda.
```
FROM ubuntu
RUN apt-get update && apt-get install -y build-essential ...
```

- [x] **Build został wykonany wewnątrz kontenera**

Proces kompilacji Redis przeprowadziłam w kontenerze redis_build_container, co pozwoliło uniknąć zależności od środowiska lokalnego. Skopiowałam gotowe binaria jako artefakty.

`docker.build('redis_build_container', '-f Dockerfile.build --no-cache .')`

- [x] **Testy zostały wykonane wewnątrz kontenera (kolejnego)**

Przygotowałam osobny kontener testowy na bazie buildowego, w którym uruchomiłam testy Redis. Logi testowe zostały wyciągnięte i zapisane lokalnie.

```
FROM redis_build_container
RUN make test | tee /redis/tests/test-results.log || true
```

- [x] **Kontener testowy jest oparty o kontener build**
Kontener testowy zbudowałam w oparciu o redis_build_container, dzięki czemu nie musiałam powielać konfiguracji środowiska buildowego.

`FROM redis_build_container`

- [x] **Logi z procesu są odkładane jako numerowany artefakt, niekoniecznie jawnie**

Logi z testów zapisałam w katalogu logs/ i dodałam je jako artefakty w Jenkinsie. Dzięki temu mogę je łatwo odnaleźć dla danego numeru builda.

archiveArtifacts artifacts: 'INO/GCL02/KK416269/redis_clone/logs/**'`

- [x] **Zdefiniowano kontener typu 'deploy' pełniący rolę kontenera, w którym zostanie uruchomiona aplikacja (niekoniecznie docelowo - może być tylko integracyjnie)**

Przygotowałam kontener redis_runtime, zawierający tylko binaria Redis, przeznaczony do uruchomienia aplikacji
`FROM ubuntu
COPY artifacts/redis-server /app/redis-server
`

- [x] **Uzasadniono czy kontener buildowy nadaje się do tej roli/opisano proces stworzenia nowego, specjalnie do tego przeznaczenia**

Uznałam, że kontener buildowy zawiera zbyt dużo zbędnych zależności, dlatego przygotowałam osobny, uproszczony kontener runtime z samym Redisem.

- [x] **Wersjonowany kontener 'deploy' ze zbudowaną aplikacją jest wdrażany na instancję Dockera**
Stworzyłam wersjonowany obraz kontenera redis_runtime, oznaczony numerem builda z Jenkinsa, i wdrożyłam go lokalnie.
```groovy
def imageName = "kaoina666/redis_runtime:${BUILD_NUMBER}"
docker push ${imageName}
```
- [x] **Następuje weryfikacja, że aplikacja pracuje poprawnie (smoke test) poprzez uruchomienie kontenera 'deploy'**

Uruchomiłam kontener redis_runtime, a następnie wykonałam prosty test działania Redis poprzez redis-cli ping

`docker exec redis_deploy_container /app/redis-cli ping`

- [x] **Zdefiniowano, jaki element ma być publikowany jako artefakt**

Wskazałam, że artefaktami są pliki binarne redis-server, redis-cli oraz logi z testów.

`archiveArtifacts artifacts: 'artifacts/*', fingerprint: true`

- [x] **Uzasadniono wybór: kontener z programem, plik binarny, flatpak, archiwum tar.gz, pakiet RPM/DEB**

Zdecydowałam się na publikację jako kontener, ponieważ ułatwia on wdrażanie i testowanie w różnych środowiskach, bez konieczności instalacji zależności.

- [x] **Opisano proces wersjonowania artefaktu (można użyć semantic versioning)**

Do wersjonowania używam zmiennej BUILD_NUMBER z Jenkinsa, która może zostać rozwinięta do schematu semantycznego.

`"kaoina666/redis_runtime:${BUILD_NUMBER}"`

- [x] **Dostępność artefaktu: publikacja do Rejestru online, artefakt załączony jako rezultat builda w Jenkinsie**

Publikuję kontener do Docker Hub, a artefakty binarne i logi są dołączane do wyników joba w Jenkinsie.

![image](https://github.com/user-attachments/assets/27ac1b4a-76af-4162-a7db-5e67a8e364dd)

- [x] **Przedstawiono sposób na zidentyfikowanie pochodzenia artefaktu**

Dzięki fingerprintowaniu oraz numerowi builda mogę jednoznacznie ustalić pochodzenie każdego artefaktu i przypisać go do konkretnego joba.

- [x] **Pliki Dockerfile i Jenkinsfile dostępne w sprawozdaniu w kopiowalnej postaci oraz obok sprawozdania, jako osobne pliki**

Pliki załączam w całości kopiowalnie poniżej, jako osobne pliki znajdują się w tym samym folderze co sprawozdanie. 

Dockerfile.build:
```bash
FROM ubuntu

RUN apt-get update && apt-get install -y \
    build-essential \
    tcl \
    git \
    libssl-dev \
    libsystemd-dev \
    make \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/redis/redis.git /redis

WORKDIR /redis

RUN make
```

Dockerfile.runtime:
```bash
FROM ubuntu

WORKDIR /app

COPY artifacts/redis-server /app/redis-server
COPY artifacts/redis-cli /app/redis-cli

RUN chmod +x /app/redis-server /app/redis-cli

EXPOSE 6379

CMD ["./redis-server", "--port", "6379"]

```

Dockerfile.test:
```bash
FROM redis_build_container

WORKDIR /redis

RUN make test | tee /redis/tests/test-results.log || true
```

Jenkinsfile:
```groovy
pipeline {
    agent any

    environment {
        WORKDIR = "INO/GCL02/KK416269/redis_clone"
    }

    stages {
        stage('Clone') {
            steps {
                git url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git', branch: 'KK416269'
            }
        }

        stage('Build') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('redis_build_container', '-f Dockerfile.build --no-cache .')
                        def containerId = sh(script: "docker create redis_build_container", returnStdout: true).trim()
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
                        docker.build('redis-test', '-f Dockerfile.test .')
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
                        docker.build('redis_runtime', '-f Dockerfile.runtime .')
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh '''
                        docker stop redis_deploy_container || true
                        docker rm redis_deploy_container || true
                        docker run -d -p 6379:6379 --name redis_deploy_container redis_runtime
                    '''
                }
            }
        }

        stage('Connection') {
            steps {
                script {
                    sh '''
                        sleep 5
                        docker exec redis_deploy_container /app/redis-cli ping || echo "Redis nie odpowiada"
                    '''
                }
            }
        }

        stage('Publish') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        def imageName = "kaoina666/redis_runtime:${BUILD_NUMBER}"
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
            script {
                sh 'docker stop redis_deploy_container || true'
                sh 'docker rm redis_deploy_container || true'
            }
            dir("${WORKDIR}") {
                archiveArtifacts artifacts: 'artifacts/*', fingerprint: true
            }
            archiveArtifacts artifacts: 'INO/GCL02/KK416269/redis_clone/logs/**'
        }
    }
}
```

- [x] **Zweryfikowano potencjalną rozbieżność między zaplanowanym UML a otrzymanym efektem**

##Lista kontrolna - Jenkins
- [x] **Przepis dostarczany z SCM, a nie wklejony w Jenkinsa lub sprawozdanie (co załatwia nam `clone`)**

Jenkinsfile trzymam w repozytorium Git i pobieram go automatycznie przy klonowaniu. Dzięki temu zachowuję spójność wersji pipeline'u i kodu.

`git url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git', branch: 'KK416269'`

- [x] **Posprzątaliśmy i wiemy, że odbyło się to skutecznie - mamy pewność, że pracujemy na najnowszym (a nie *cache'owanym* kodzie)**

Dodałam opcję --no-cache do budowy obrazu, co gwarantuje brak użycia zcache'owanych warstw Dockera.

`docker.build('redis_build_container', '-f Dockerfile.build --no-cache .')`

- [x] **Etap `Build` dysponuje repozytorium i plikami `Dockerfile`**

Przed budowaniem wchodzę do odpowiedniego katalogu z Dockerfile i kodem źródłowym, dzięki czemu mam dostęp do wszystkich potrzebnych plików.

```groovy
dir("${WORKDIR}") {
    docker.build(...)
}
```

- [x] **Etap `Build` tworzy obraz buildowy, np. `BLDR`**

Zbudowałam obraz redis_build_container, który kompiluje Redis i stanowi podstawę dla dalszych etapów.

`docker.build('redis_build_container', '-f Dockerfile.build --no-cache .')`

- [x] **Etap `Build` (krok w tym etapie) lub oddzielny etap (o innej nazwie), przygotowuje artefakt - jeżeli docelowy kontener ma być odmienny, tj. nie wywodzimy `Deploy` z obrazu `BLDR`**

Po kompilacji kopiuję binaria do lokalnego katalogu artifacts/, które następnie używam przy tworzeniu kontenera runtime.

`sh "docker cp ${containerId}:/redis/src/redis-server artifacts/redis-server"`

- [x] **Etap `Test` przeprowadza testy**

Zbudowałam osobny kontener testowy na bazie buildowego, w którym uruchomiłam make test, a logi zapisałam do logs/.

`docker.build('redis-test', '-f Dockerfile.test .')`

- [x] **Etap `Deploy` przygotowuje obraz lub artefakt pod wdrożenie.**

Stworzyłam lekki obraz redis_runtime zawierający tylko potrzebne binaria i zdefiniowany CMD, co czyni go gotowym do uruchomienia.

`CMD ["./redis-server", "--port", "6379"]`

- [x] **Etap `Deploy` przeprowadza wdrożenie (start kontenera docelowego lub uruchomienie aplikacji na przeznaczonym do tego celu kontenerze sandboxowym)**

Wdrażam kontener redis_runtime, uruchamiając go w tle z odpowiednimi portami.

`docker run -d -p 6379:6379 --name redis_deploy_container redis_runtime`

- [x] **Etap `Publish` wysyła obraz docelowy do Rejestru i/lub dodaje artefakt do historii builda**

Publikuję obraz na Docker Hub z wersją opartą o numer builda, a artefakty i logi dołączam jako rezultaty builda.

```groovy
docker push kaoina666/redis_runtime:${BUILD_NUMBER}
archiveArtifacts artifacts: 'artifacts/*', fingerprint: true
```

- [x] **Ponowne uruchomienie naszego *pipeline'u* powinno zapewniać, że pracujemy na najnowszym (a nie *cache'owanym*) kodzie. Innymi słowy, *pipeline* musi zadziałać więcej niż jeden raz**

Pipeline działa niezawodnie przy wielokrotnym uruchomieniu – zawsze pobiera świeży kod i buduje obrazy bez cache’a.

`docker.build(..., '--no-cache .')`

## Opis ogólny (podsumowanie):
Pipeline składa się z etapów: Clone, Build, Test, Runtime, Deploy, Connection oraz Publish.

Aplikacja została pobrana z oficjalnego repozytorium Redis (licencja BSD 3-clause), a następnie zbudowana w osobnym kontenerze typu build, z użyciem pliku Dockerfile.build. W kontenerze tym wykonywana jest kompilacja binariów Redis (redis-server, redis-cli), które następnie są kopiowane jako artefakty do lokalnego folderu artifacts/. Artefakty te są przechowywane oraz archiwizowane przez Jenkinsa.

W kolejnym etapie Test, uruchamiany jest osobny kontener oparty na obrazie buildowym. W nim wykonywane są testy Redis, a ich logi (test-results.log) są przechowywane w folderze logs/ oraz również archiwizowane.

Po przejściu testów tworzony jest obraz runtime (Dockerfile.runtime) zawierający tylko niezbędne binaria i minimalne środowisko uruchomieniowe. Obraz ten jest uruchamiany w kontenerze redis_deploy_container, eksponując port 6379.

Etap Deploy automatycznie zatrzymuje i usuwa poprzednią instancję (jeśli istnieje), a następnie uruchamia najnowszy kontener. Weryfikacja działania Redis odbywa się poprzez polecenie redis-cli ping, co stanowi prosty smoke test. Jeżeli Redis odpowiada PONG, uznajemy wdrożenie za udane.

Na końcu pipeline’u w etapie Publish, gotowy obraz redis_runtime jest wersjonowany i publikowany do rejestru Docker Hub (konto kaoina666). Dzięki temu możliwe jest łatwe śledzenie historii wdrożeń oraz identyfikacja pochodzenia każdego obrazu.

Całość została zdefiniowana w pliku Jenkinsfile znajdującym się w repozytorium Git. Pipeline uruchamia się w pełni automatycznie z kodu SCM, nie korzystając z wklejanej treści. Wszelkie artefakty (binaria, logi) są archiwizowane po każdym przebiegu.

## UML
**Diagram aktywności**
opisuje kolejność etapów w pipeline Jenkinsa:

![image](https://github.com/user-attachments/assets/ce1e84bc-d13a-46ba-90c4-78862b13463d)

**Diagram wdrożeniowy**
diagram przedstawia techniczną architekturę procesu CI/CD z wykorzystaniem Jenkinsa i Dockera. Pokazuje jak artefakty przepływają między kontenerami:
- Repozytorium GitHub (MDO2025_INO) jest źródłem kodu
- Build Server (agent Jenkinsa) buduje obraz redis_build_container, z którego wyciągane są binaria redis-server i redis-cli
- Następnie budowany jest redis-test, który służy do uruchamiania testów, a logi testów są zapisywane do pliku test-results.log
- Z binariów budowany jest docelowy obraz redis_runtime, który jest:
  -uruchamiany jako redis_deploy_container (na potrzeby testów integracyjnych)
  - publikowany do DockerHuba (kaoina666/redis_runtime)

![image](https://github.com/user-attachments/assets/791393aa-1760-4923-81bc-ee3ab59ea033)


Końcowy efekt mojego piplenie:

![image](https://github.com/user-attachments/assets/f2604526-0a6c-4f88-8261-45c3475c54b9)


