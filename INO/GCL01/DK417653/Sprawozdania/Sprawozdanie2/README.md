# Pipeline, Jenkins, izolacja etapów

## Przygotowanie

### Instalacja Jenkinsa

Instalacja Jenkins w środowisku Docker:

1. Uruchomienie obrazu Dockera z zagnieżdżonym środowiskiem

    Na początku utworzyłem mostek sieciowy w dokerze:
    
    > docker network create jenkins

    Następnie z wykorzystaniem  instrukcji utworzyłem dind (Docker in Docker)

    > docker run \
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

2. Przygotowanie obrazu BlueOcean bazującego na Jenkins

    BlueOcean różni się od podstawowego Jenkinsa tym, że zawiera dodatkowe wtyczki dla nowoczesnego interfejsu użytkownika oraz lepszą obsługę pipelinów

    Do zbudowania obrazu blueocean wykorzystałem `Dockerfile`

    ```Dockerfile
    FROM jenkins/jenkins:2.492.3-jdk21
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

    A następnie zbudowałem komendą:

    > docker build -f Dockerfile.blueocean -t myjenkins-blueocean:2.492.3 .

3. Uruchomienie BlueOcean

    Uruchomiłem Jenkinsa komendą:

    > docker run \
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
    myjenkins-blueocean:2.492.3

4. Zalogowanie i wstępna konfiguracja Jenkins

    By otworzyć Jenskinsa połączyłem się zewnętrznie do hosta przy użyciu przeglądarki, przez którego mogłem połączyć się z Blueocean.
    Po pierwszym uruchomieniu Jenkinsa należało uzyskać hasło, które było wewnątrz kontenera:

    ```bash
    docker exec 92d51862e190 cat /var/jenkins_home/secrets/initialAdminPassword # gdzie 92d51862e190 to id kontenera
    ```

    ![Jenkins haslo](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie2/screen's/jenkins_haslo.png)

    Następnie zainstalowałem domyślne pluginy, skonfigurowałem konto admina i pozostałe opcje.


## Zadanie wstępne: uruchomienie

### Konfiguracja wstępna i pierwsze uruchomienie

Utworzyłem następujące projekty testowe:

1. Projekt wyświetlający wynik komendy `uname`

    W tym celu w projekcie `Freestyle` w polu `Execute Shell` wywołałem następującą komendę:

    > uname -a

    ![Uname](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie2/screen's/uname.png)

2. Projekt zwracający błąd przy nieparzystej godzinie

   Zaimplementowany z wykorzystaniem prostego skryptu w pythonie, który był uruchamiany w `Execute Shell`
  
    Skrypt python:
    ```py
    import datetime

    # Pobierz aktualne minuty
    minute = datetime.datetime.now().minute

    # Sprawdź, czy minuta jest parzysta
    if minute % 2 == 0:
        print("Minuta jest parzysta, kontynuowanie...")
    else:
        print("Minuta jest nieparzysta, kończenie builda!")
        exit(1)
    ```

    Komenda:

    >  python3 /var/jenkins_home/hour_check.py

    Powodzenie

    ![hour_check_true](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie2/screen's/hour_check_true.png)
    
    Niepowodzenie

    ![hour_check_false](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie2/screen's/hour_check_false.png)

3. Projekt pobierający obraz kontenera `ubuntu`

   Wykorzystanie komendy `docker pull ubuntu`

   Wynik:

    ![pull](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie2/screen's/pull.png)

    ![images](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie2/screen's/image.png)

## Zadanie wstępne: obiekt typu pipeline

### Tworzenie i konfiguracja pipeline

Utworzyłem nowy obiekt typu `pipeline` bezpośrednio w Jenkins (bez integracji z SCM). Pobiera repo `MDO2025_INO` do przestrzeni roboczej. Wykorzystuje `Dockerfile` z wcześniejszych zajęć.

Skrypt Pipeline:
    
    pipeline {
        agent any
        stages { 
            stage('Clone Repo') { //Clone our repo
                steps {
                    echo 'Cloning Repository'
                    git branch: 'DK417653' , url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO'
                }
            }
            stage('Build Dockerfile'){
                steps {
                    echo "Build Dockerfile"
                    dir('INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/src/Dokcerfiles'){
                        sh 'docker build -f Dockerfile.bld -t pipelinetest .'
                    }
                }
            }
        }
    post {
            success {
                echo "Build succeeded!"
            }
            failure {
                echo "Build failed!"
            }
        }
    }



Ponowne uruchomienie pipeline przeszło pomyślnie.

![first](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie2/screen's/first.png)


# Implementacji Pipeline

## 1. Wybór aplikacji

Do realizacji zadania wybrałem aplikację `pytest-examples` z repozytorium Pydantic. Projekt zawiera przykłady testów, który idealnie nadaje się do demonstracji procesu CI/CD ze względu na:
- Jasno zdefiniowany proces budowania
- Dostępne testy
- Możliwość pakowania jako biblioteka Python

## 2. Plan procesu CI/CD

### Ścieżka krytyczna
Zaimplementowany pipeline obejmuje wszystkie elementy ścieżki krytycznej:
- **Commit/Trigger** - uruchamiany manualnie w Jenkins
- **Clone** - klonowanie repozytorium w kontenerze
- **Build** - kompilacja kodu do postaci wheel package
- **Test** - uruchomienie testów w dedykowanym kontenerze
- **Deploy** - przygotowanie obrazu wdrożeniowego
- **Publish** - publikacja artefaktów w Jenkins

### Środowisko CI/CD
Do implementacji pipeline'a wykorzystałem następujące technologie:

- Jenkins BlueOcean - nowoczesny interfejs Jenkins
- Docker-in-Docker (DinD) -  umożliwia:

    - Uruchamianie kontenerów Docker wewnątrz kontenera Jenkinsa
    - Izolację środowiska buildowego
    - Elastyczną konfigurację kontenera wdrożeniowego
    - Bezpieczne testowanie bez wpływu na hosta

Wykorzystanie DinD i BlueOcean pozwala na stworzenie izolowanego, powtarzalnego i łatwego w zarządzaniu środowiska CI/CD.

### Diagram UML procesu CI/CD

![UML](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie2/screen's/scr2.png)

## 3. Implementacja etapów procesu

### Kontenery / Dockerfile
Wykorzystuję podejście oparte na wieloetapowym `Dockerfile`, w którym zdefiniowane są trzy główne obrazy:

1. **Builder (ubuntu:latest)** - odpowiedzialny za:
   - Instalację wymaganych narzędzi (git, python, pip, poetry, uv)
   - Klonowanie repozytorium
   - Budowanie pakietu wheel

2. **Tester (bazujący na Builder)** - odpowiedzialny za:
   - Uruchomienie testów
   - Zapisanie logów testów

3. **Deploy (ubuntu:latest)** - odpowiedzialny za:
   - Przechowywanie zbudowanych pakietów
   - Gotowość do wdrożenia

### Jenkinsfile
Pipeline w Jenkins zdefiniowany jest w formie deklaratywnej i składa się z następujących etapów:

1. **Builder** - buduje kontener z kodem źródłowym i kompiluje aplikację
2. **Tester** - wykonuje testy w izolowanym środowisku
3. **Deploy** - przygotowuje kontener wdrożeniowy 
4. **Artifacts deployment** - wyodrębnia i archiwizuje artefakty

Dodatkowo, w sekcji `post` archiwizowane są logi z testów.

## 4. Weryfikacja procesu

### Budowanie aplikacji
Aplikacja buduje się poprawnie w kontenerze `builder`. Proces budowania obejmuje:
- Klonowanie repozytorium
- Instalację zależności za pomocą `make install`
- Utworzenie pakietu wheel

### Testy
Testy są wykonywane w kontenerze `tester`, który dziedziczy po kontenerze `builder`. Wyniki testów są zapisywane do pliku `test.log`.

### Wdrożenie
Obraz wdrożeniowy `deploy` zawiera tylko niezbędne komponenty do uruchomienia aplikacji, bez narzędzi deweloperskich. Artefakty (pakiety wheel) są kopiowane z kontenera `builder`.

### Publikacja artefaktów
Artefakty: pakiety wheel oraz logi testów, są archiwizowane w Jenkins.


### Pipeline:

## 5. Lista kontrolna realizacji

- [x] Aplikacja została wybrana (pytest-examples)
- [x] Licencja potwierdza możliwość swobodnego obrotu kodem (MIT)
- [x] Wybrany program buduje się poprawnie
- [x] Przechodzą dołączone do niego testy
- [x] Zdecydowano o forku repozytorium
- [x] Stworzono diagram UML zawierający planowany proces CI/CD 
- [x] Wybrano kontener bazowy (ubuntu:latest)
- [x] Build został wykonany wewnątrz kontenera
- [x] Testy zostały wykonane wewnątrz kontenera
- [x] Kontener testowy jest oparty o kontener build
- [x] Logi z procesu są odkładane jako artefakt
- [x] Zdefiniowano kontener typu 'deploy'
- [x] Uzasadniono wybór kontenera deploy (lżejszy kontener tylko z niezbędnymi komponentami)
- [x] Wersjonowany kontener 'deploy' jest gotowy do wdrożenia
- [x] Weryfikacja działania aplikacji (testy)
- [x] Zdefiniowano artefakt (pakiet wheel)
- [x] Uzasadniono wybór artefaktu (standardowy format dystrybucji dla Python)
- [x] Dostępność artefaktu (archiwizacja w Jenkins)
- [x] Przedstawiono sposób identyfikacji artefaktu (fingerprinting w Jenkins)
- [x] Pliki Dockerfile i Jenkinsfile są dostępne

## 6. Jenkinsfile

### Główne etapy pipeline'u:
1. **Builder** - budowanie kontenera buildowego
   ```groovy
   stage('Builder') {
       steps {
           sh '''
               docker build --target builder -t pytest_builder \
                   -f /var/jenkins_home/Dockerfiles/Dockerfile /var/jenkins_home
           '''
       }
   }
   ```

2. **Tester** - budowanie kontenera testowego
   ```groovy
   stage('Tester') {
       steps {
           sh '''
               docker build --target tester -t pytest_tester \
                   -f /var/jenkins_home/Dockerfiles/Dockerfile /var/jenkins_home
           '''
       }
   }
   ```

3. **Deploy** - budowanie kontenera wdrożeniowego
   ```groovy
   stage('Deploy') {
       steps {
           sh '''
               docker build --target deploy -t pytest_deploy \
                   -f /var/jenkins_home/Dockerfiles/Dockerfile /var/jenkins_home
           '''
       }
   }
   ```

4. **Artifacts deployment** - wyodrębnianie i archiwizacja artefaktów
   ```groovy
        stage('Artifacts deployment') {
            steps {
                script {
                    sh 'docker create --name tmp pytest_deploy'
                    sh 'docker cp tmp:/packages $WORKSPACE/packages'
                    sh 'docker cp tmp:/app/test.log $WORKSPACE/test.log || echo "No test were found/run"> $WORKSPACE/test.log'
                    sh 'docker rm tmp'
                }
                archiveArtifacts artifacts: 'packages/**/*', fingerprint: true
            }
        }
   ```

## 7. Dockerfile

### Etap 1: Builder
```dockerfile
FROM ubuntu:latest AS builder

RUN apt-get update  \
&&  apt-get install -y  \ 
        git python3 python3-pip make python3-poetry pipx \
&&  pipx install uv  \
&&  rm -rf /var/lib/apt/lists/* 
    
ENV PATH="/root/.local/bin:${PATH}" 

WORKDIR /app

RUN uv --version  \
&&    git clone https://github.com/pydantic/pytest-examples.git . \
&&    make install  \
&&    mkdir -p wheel_dir  \
&&    pip3 wheel . --no-deps --wheel-dir wheel_dir 
```

### Etap 2: Tester
```dockerfile
FROM builder AS tester

WORKDIR /app
RUN uv run pytest -v > test.log
```

### Etap 3: Deploy
```dockerfile
FROM ubuntu:latest AS deploy

RUN mkdir -p /packages
COPY --from=builder /app/wheel_dir /packages
COPY --from=tester /app/test.log /app/test.log
```

## 8. Wnioski

Zaimplementowany pipeline CI/CD spełnia wszystkie wymagania ścieżki krytycznej:
- Poprawnie buduje aplikację w izolowanym środowisku
- Wykonuje testy w dedykowanym kontenerze
- Przygotowuje kontener wdrożeniowy z artefaktami
- Archiwizuje wyniki procesu

Pipeline skutecznie produkuje artefakt gotowy do wdrożenia w postaci pakietu wheel, który może być zainstalowany w dowolnym środowisku Python za pomocą standardowych narzędzi (`pip`). Artefakt jest archiwizowany w Jenkins wraz z logami testów, co zapewnia pełną dokumentację procesu.
Dodatkowo, proces jest w pełni zautomatyzowany, powtarzalny i zapewnia izolację poszczególnych etapów, co ułatwia diagnostykę potencjalnych problemów.

![work](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie2/screen's/work.png)

![artif](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie2/screen's/arti.png)

## Uzasadnienie decyzji projektowych

### 1. Tworzenie forka pytest-examples
W pipeline wykorzystano sforkowane repozytorium pytest-examples, zamiast bezpośrednio klonować oryginalne repozytorium.
Powody:

- Kontrola nad kodem - fork umożliwia wprowadzanie zmian bez wpływu na oryginalne repozytorium
- Niezależność - uniezależnienie od zmian w oryginalnym repozytorium, które mogłyby wpłynąć na stabilność pipeline'a
- Dodanie plików CI/CD - możliwość dodania własnych plików konfiguracyjnych (Jenkinsfile, Dockerfile) do repozytorium

### 2. Wybór formatu pakietu .whl

W pipeline tworzony jest pakiet w formacie Wheel (.whl) zamiast instalowalnego archiwum .tar.gz.

Powody:

- Szybka instalacja - brak potrzeby rekompilacji
- Standaryzacja – Wheel jest standardowym formatem binarnych pakietów Pythona
- Konsystencja – zapewnia identyczne zachowanie pakietu w różnych środowiskach
- Wsparcie narzędzi – lepsze wsparcie narzędzi takich jak pip, pytest i innych narzędzi deweloperskich

### 3. Wybór Ubuntu jako obrazu bazowego
W pipeline wykorzystano Ubuntu jako bazowy obraz kontenera zamiast dedykowanych obrazów Pythona.
Powody:

- Znajomość - Ubuntu jest powszechnie znanym i dobrze udokumentowanym systemem
- Elastyczność - łatwe dodawanie dodatkowych zależności systemowych
- Kontrola - pełna kontrola nad środowiskiem
- Przenośność - kontener będzie działał na większości platform hostujących
