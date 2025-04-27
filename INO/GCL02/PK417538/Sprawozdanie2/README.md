# Sprawozdanie 2
## Pipeline, Jenkins, izolacja etapów

### Przygotowanie

**Utwórz instancję Jenkins:**

Plik docker-compose.yml tworzy kontener z Jenkins LTS, udostępnia jego porty 8080 i 50000, zapisuje dane w trwałym volume jenkins_home, umożliwia dostęp do Dockera hosta i zapewnia automatyczne uruchamianie kontenera po restarcie systemu.

```
version: '3.8'
services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins-upgraded
    user: root
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped

volumes:
  jenkins_home:
```
```
docker compose up -d
```

---

### Zadanie wstępne: uruchomienie

**Zadanie do wykonania na ćwiczeniach:**

- Konfiguracja wstępna i pierwsze uruchomienie:
  - Utwórz projekt, który wyświetla `uname`.
 
    ```
    uname -a
    ```
    ![obraz](https://github.com/user-attachments/assets/09d43d30-0dfa-4bd7-9ec0-768fd2412fa9)


  - Utwórz projekt, który zwraca błąd, gdy godzina jest nieparzysta.
    
    ```
    HOUR=$(date +%H)
    if [ $((HOUR % 2)) -ne 0 ]; then
      echo "Błąd: Godzina jest nieparzysta ($HOUR)"
      exit 1
    else
      echo "Godzina jest parzysta ($HOUR), budowanie OK."
    fi
    ```
    ![obraz](https://github.com/user-attachments/assets/8bb3a922-2ce4-48f2-8c14-0b6fe90d18b7)

    
  - Pobierz w projekcie obraz kontenera Ubuntu (stosując `docker pull`).
    
    ```
    docker pull ubuntu:latest
    ```
    ![obraz](https://github.com/user-attachments/assets/d1e8fe36-919d-486c-b669-7e37a220f185)


---

### Zadanie wstępne: obiekt typu pipeline

**Ciąg dalszy sprawozdania — zadanie do wykonania po wykazaniu działania Jenkinsa:**

Utworzono nowy obiekt typu pipeline w Jenkinsie. Repozytorium MDO2025_INO zostało sklonowane z gałęzi PK417538. Następnie zbudowano obraz Dockera z pliku Dockerfile znajdującego się w katalogu INO/GCL02/PK417538/Sprawozdanie2, a następnie uruchomiono kontener na jego podstawie. Pipeline został wykonany ponownie w celu weryfikacji poprawności.

```
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'PK417538', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }
        stage('Build Dockerfile') {
            steps {
                sh 'docker build -t my-builder ./INO/GCL02/PK417538/Sprawozdanie2'
            }
        }
        stage('Run Container') {
            steps {
                sh 'docker run --rm my-builder'
            }
        }
    }
}
```

![obraz](https://github.com/user-attachments/assets/252a39dc-c3fd-425f-bfeb-6105c994fd18)

# Opis Pipeline

Pipeline buduje, testuje i pakuje aplikację w czterech głównych etapach:

## Etapy

### 1. Build image
- Budowanie obrazu Dockera (`pytest-examples-builder`) na podstawie targetu `builder` z pliku `Dockerfile`.
- W kroku `builder`:
  - Instalowane są narzędzia: `git`, `python3`, `pip`, `make`, `poetry`, `pipx`, `uv`.
  - Klonowane jest repozytorium `https://github.com/pydantic/pytest-examples.git`.
  - Projekt jest instalowany.
  - Tworzone są pakiety `.whl` w katalogu `dist`.

### 2. Test image
- Budowanie obrazu Dockera (`pytest-examples-tester`) na podstawie targetu `tester`.
- W kroku `tester`:
  - Uruchamiane są testy jednostkowe za pomocą `pytest` w katalogu `/app`.

### 3. Build deploy image
- Budowanie obrazu Dockera (`pytest-examples-deploy`) na podstawie targetu `deploy`.
- W kroku `deploy`:
  - Kopiowane są zbudowane pakiety `.whl` z obrazu `builder` do katalogu `/packages`.

### 4. Package / Deploy artifacts
- Tworzenie tymczasowego kontenera na podstawie obrazu `deploy`.
- Kopiowanie zawartości `/packages` z kontenera do lokalnego `workspace` w Jenkinsie.
- Archiwizacja plików (`packages/**/*`) jako artefaktów.

## Działania po wykonaniu Pipeline (`post`)

- Niezależnie od wyniku pipeline'u, archiwizowany jest plik `test.log` (`archiveArtifacts`).

---

## Struktura Dockerfile

- **Stage 1: builder**
  - Budowa środowiska, instalacja zależności, klonowanie repozytorium, tworzenie pakietów `.whl`.

- **Stage 2: tester**
  - Wykonywanie testów jednostkowych.

- **Stage 3: deploy**
  - Przygotowanie katalogu `/packages` i kopiowanie pakietów z `builder`.

# Uzasadnienie decyzji projektowych

## 1. Brak tworzenia forka `pytest`

W pipeline repozytorium `pytest-examples` zostało **sklonowane bez tworzenia forka** (`git clone https://github.com/pydantic/pytest-examples.git`).  
Powody:
- **Brak potrzeby modyfikacji źródeł** – projekt wykorzystuje kod bez nanoszenia własnych zmian.
- **Uproszczenie procesu** – uniknięcie operacji związanych z zarządzaniem własnym forkiem (aktualizacje, synchronizacja z upstream).
- **Stabilność** – praca bezpośrednio na wersji głównej repozytorium zmniejsza ryzyko błędów wynikających z własnych rozgałęzień.

W przypadku konieczności wprowadzenia modyfikacji w przyszłości, forka można stworzyć w dowolnym momencie.

## 2. Wybór formatu pakietu `.whl`

W pipeline tworzony jest **pakiet w formacie Wheel (`.whl`)** zamiast instalowalnego archiwum `.tar.gz`.  
Powody:
- **Szybsza instalacja** – pliki `.whl` nie wymagają rekompilacji podczas instalacji (`pip install` jest znacznie szybszy).
- **Standaryzacja** – Wheel jest standardowym formatem binarnych pakietów Pythona (`PEP 427`).

---

Dzięki temu pipeline jest **prostszy**, **szybszy** i **bardziej niezawodny**.


## Dockerfile

```
# ┌───────────────────────────┐
# │ Stage 1: builder         │
# └───────────────────────────┘
FROM ubuntu:latest AS builder

ENV PATH="/root/.local/bin:${PATH}"

RUN apt-get update \
 && apt-get install -y \
      git python3 python3-pip make python3-poetry pipx \
 && pipx install uv \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN uv --version \
 && git clone https://github.com/pydantic/pytest-examples.git . \
 && make install \
 && mkdir -p dist \
 && pip3 wheel . --no-deps --wheel-dir dist

# ┌───────────────────────────┐
# │ Stage 2: tester          │
# └───────────────────────────┘
FROM builder AS tester

WORKDIR /app
RUN uv run pytest

# ┌───────────────────────────┐
# │ Stage 3: deploy          │
# └───────────────────────────┘
FROM ubuntu:latest AS deploy

RUN mkdir -p /packages
COPY --from=builder /app/dist /packages

```

## Jenkinsfile

```
pipeline {
  agent any

  stages {
    stage('Build image') {
        steps {
            sh '''
            docker build \
                --target builder \
                -t pytest-examples-builder:0.1.0 \
                -f INO/GCL02/PK417538/pipeline/Dockerfile .
            '''
        }
    }


    stage('Test image') {
      steps {
        sh '''
          docker build \
            --target tester \
            -t pytest-examples-tester:0.1.0 \
            -f INO/GCL02/PK417538/pipeline/Dockerfile .
        '''
      }
    }

    stage('Build deploy image') {
        steps {
            sh """
            docker build \
                --target deploy \
                -t pytest-examples-deploy:0.1.0 \
                -f INO/GCL02/PK417538/pipeline/Dockerfile \
                .
            """
        }
    }


    stage('Package / Deploy artifacts') {
        steps {
            script {
            sh 'docker create --name tmp pytest-examples-deploy:0.1.0'
            sh 'docker cp tmp:/packages $WORKSPACE/packages'
            sh 'docker rm tmp'
            }
            archiveArtifacts artifacts: 'packages/**/*', fingerprint: true
        }
    }


  }

  post {
    always {
      archiveArtifacts artifacts: 'test.log', fingerprint: true
    }
  }
}

```

## Diagram UML

![VP3DhjiW48NtFCLqrqYHeZPTEPkaRbfLwa_bPbyHUsAZO40mEBQgldiDv8P4aUuE3d3c-zWwufPyBzcR1az28LJxyh3xyUNR_ksu08irSTLAX16uWv6nU9-nuZVn5k5T0H-za0s8VjvkM7vy337Q1Vnb0CNdwkTty4Ulo1UI4phQXFYhckkaX5RG4in4dLRhUI7C4df-ndcfaUmKe_7-1](https://github.com/user-attachments/assets/d316efe9-5609-41bd-82bc-ab78dfbdc58e)
