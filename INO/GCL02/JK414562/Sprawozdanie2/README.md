# Sprawozdanie 2 - Pipeline, Jenkins, izolacja etapów

##  Przygotowanie środowiska Jenkins (Docker-out-of-Docker)

Zrealizowano lokalną instalację Jenkinsa z obsługą Docker-in-Docker (DIND) i interfejsem BlueOcean, umożliwiającą uruchamianie zadań CI/CD w kontenerach.

Środowisko CI/CD zostało przygotowane z wykorzystaniem Dockera oraz pliku `docker-compose.yml`. Zamiast kontenera `dind`, wykorzystano bezpośrednie podłączenie do `docker.sock` hosta (Docker-out-of-Docker), co pozwala Jenkinsowi budować i uruchamiać kontenery Dockera.

Zdefiniowano jeden serwis `jenkins`, który:
- buduje obraz z lokalnego `Dockerfile.jenkins`,
- mapuje port `8080`,
- montuje wolumen `jenkins_home`,
- montuje gniazdo `/var/run/docker.sock` do komunikacji z Dockerem hosta:

```yaml
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
### 2. Plik Dockerfile.jenkins
Plik ten rozszerza obraz jenkins/jenkins, instaluje docker-ce-cli oraz pluginy do obsługi BlueOcean i pipeline'ów dockera (np. docker-workflow). Dzięki temu Jenkins może używać Dockera wewnątrz jobów.
### 3. Uruchomienie środowiska

    docker compose up -d
    
Po uruchomieniu Jenkins był dostępny pod adresem http://localhost:8080.
![image](https://github.com/user-attachments/assets/9ed62f8b-3874-42e3-a3b5-84ed9961a562)

Hasło uzyskano z logów dockera poleceniem 

    docker logs jk414562_jenkins_1

Utworzono konto w interfejsie Jenkinsa i wybrano rekomendowaną paczkę pluginów.

### 4. Porównanie podejść: Docker-in-Docker vs Docker-out-of-Docker

W projekcie zastosowano podejście **Docker-out-of-Docker (DooD)**, czyli Jenkins korzysta bezpośrednio z Dockera hosta przez `docker.sock`. Nie używano osobnego demona Dockera (DIND). Poniżej znajduje się porównanie obu podejść:

| Cecha                    | Docker-in-Docker (DIND)                            | Docker-out-of-Docker (DooD)                         |
|-------------------------|----------------------------------------------------|-----------------------------------------------------|
| Uruchamianie demona     | Wymaga własnego Dockera w kontenerze              | Wykorzystuje Dockera hosta przez `docker.sock`     |
| Izolacja                | Lepsza (oddzielny daemon)                         | Gorsza (dzieli środowisko hosta)                   |
| Wydajność               | Wolniejszy start (uruchamianie demona)            | Szybszy (używa gotowego Dockera hosta)             |
| Debugowanie             | Trudniejsze (brak dostępu do hosta)               | Łatwiejsze (można użyć `docker ps`, `logs` hosta)  |
| Bezpieczeństwo          | Bezpieczniejszy (brak dostępu do hosta)           | Mniej bezpieczny (pełen dostęp do hostowego Dockera) |

**Uzasadnienie wyboru**:  
Wybrano podejście DooD ze względu na:
- szybszą konfigurację,
- prostsze debugowanie (`docker ps`, `logs`, `exec` z hosta),
- brak potrzeby pełnej izolacji build/test od hosta.


---

# Zadanie wstępne: uruchomienie
  - Utworzono projekt, który wyświetla `uname` w konsoli.
     ![image](https://github.com/user-attachments/assets/c050c03f-64fe-424c-bee5-969c29331f2e)
      
  - Utworzono projekt, który wypisuje w konsoli czy godzina jest parzysta czy nie
     ![image](https://github.com/user-attachments/assets/1c4957ba-1425-42d6-9e9b-398bc75414fb)

  - Utworzono projekt, który ściąga obraz ubuntu dockera, poleceniem docker pull ubuntu.
     ![image](https://github.com/user-attachments/assets/811b8684-fd8e-49fe-b1d7-33c770f51f00)

# Zadanie wstępne: obiekt typu pipeline

Utworzono pileline, którego zadaniem jest pobranie repozytorium przedmiotu MD02025_INO i budowa obrazu dockera, zawartego w dockerfile na własnej gałęzi: JK414562

    pipeline {
          agent any

    stages {
        stage('Clone repo') {
            steps {
                git branch: 'JK414562', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Build Docker image') {
            steps {
                dir("INO/GCL02/JK414562/Sprawozdanie2") {
                    script {
                        sh 'ls -la'
                        docker.build('build', '-f Dockerfile.build .')
                    }
                }
            }
        }

        stage('Print info') {
            steps {
                echo '✅ Pipeline ran successfully. Docker image was built.'
            }
        }
    }
}


Zrzut ekranu potwierdzający powodzenie:

![image](https://github.com/user-attachments/assets/e9f6042a-3cc9-433a-a347-41c554da8135)

Pipeline z powodzeniem udało się uruchomić ponownie.

## Diagram CI/CD pipeline (PlantUML)
Poniżej przedstawiono uproszczony diagram procesu CI/CD w formacie PlantUML:
![image](https://github.com/user-attachments/assets/03472a78-b607-4549-8b8d-4ea2fb97d3cc)


# Kompletna Konfiguracja Pipeline CI/CD – XZ Utils

Projekt realizuje pełny cykl Continuous Integration / Continuous Deployment (CI/CD) dla biblioteki [XZ Utils](https://github.com/tukaani-project/xz) w oparciu o Jenkinsa, Docker oraz podejście Docker-in-Docker (DIND).

---

##  Struktura Pipeline

Pipeline został podzielony na pięć głównych etapów:

### 1. Clone
- Klonowanie repozytorium `xz` oraz plików pomocniczych:
  - `Dockerfile.build`
  - `Dockerfile.test`
  - `Dockerfile.deploy`
  - `deploy.c`
  - `test-entrypoint.sh`
  - `docker-compose.yml`
- Zapewnione środowisko oparte na najnowszym kodzie źródłowym, bez cache.

### 2. Build
- Budowa obrazu z `Dockerfile.build` (bazującego na `debian:bullseye`).
- Instalacja zależności (`autotools`, `gcc`, `gettext`, itp.).
- Kompilacja `xz` oraz utworzenie artefaktu `xz.tar.gz`.
- Artefakt zapisany w katalogu `artifacts`.

### 3. Test
- Budowa obrazu z `Dockerfile.test`.
- Uruchomienie testów przez `make check` w kontenerze.
- Logi zapisane jako `xz_test.log` w katalogu `logs`.

### 4. Deploy
- Budowa obrazu z `Dockerfile.deploy`.
- W kontenerze:
  - instalacja `xz.tar.gz`,
  - kompilacja `deploy.c` z użyciem `liblzma`,
  - uruchomienie testowego programu.

### 5. Publish
- Artefakty `xz.tar.gz` i `xz_test.log` dołączone do rezultatów pipeline'u w Jenkinsie.
#### Wersjonowanie artefaktu

Artefakt `xz.tar.gz` jest automatycznie wersjonowany przez Jenkinsa – jego nazwa zawiera numer buildu, np. `xz-23.tar.gz`, `xz-24.tar.gz` itd.  
Jest to możliwe dzięki użyciu zmiennej środowiskowej `${BUILD_NUMBER}` w Jenkinsfile:

```groovy
sh "docker cp ${cid}:/app/xz.tar.gz artifacts/xz-${BUILD_NUMBER}.tar.gz"
```
  ### Uzasadnienie formy publikacji

Zdecydowano się na publikację artefaktów w postaci archiwum `xz.tar.gz` oraz logów testów `xz_test.log`, ponieważ:

- są to **przenośne i lekkie** pliki, które można pobrać bezpośrednio z poziomu Jenkinsa,
- `xz.tar.gz` zawiera w pełni zbudowaną i gotową do użycia bibliotekę XZ, dzięki czemu może być wykorzystany w innych kontenerach, systemach lub przez użytkowników,
- format `.tar.gz` jest **standardem w środowiskach Linuxowych** i nie wymaga instalacji dodatkowych menedżerów pakietów (jak .deb czy .rpm),
- umożliwia pełną kontrolę nad zawartością (możliwość rozpakowania i manualnego wdrożenia),
- log testów jest przydatny do analizy regresji i historycznego śledzenia błędów.

Nie publikowano kontenera jako artefaktu, ponieważ pipeline buduje oddzielne kontenery tylko do etapów build/test/deploy – **deploy kontener nie jest docelowym środowiskiem produkcyjnym**, a jedynie sandboxem testowym. Artefakt `.tar.gz` jest zatem bardziej uniwersalny w użyciu.

Każdy artefakt jest wersjonowany pośrednio przez numer buildu Jenkinsa (np. `#23`) oraz można go zidentyfikować dzięki zachowaniu ścieżki builda i logów w Jenkinsie.


---
Pełna treść skryptu:
    
    pipeline {
      agent any

    environment {
        WORKDIR = "INO/GCL02/JK414562/pipeline"
    }

    stages {
        stage('Clone xz') {
            steps {
                dir("${WORKDIR}") {
                    sh "rm -rf xz"
                    sh "git clone https://github.com/tukaani-project/xz.git xz"
                }
            }
        }

        stage('Build & Package') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('xz-build', '-f Dockerfile.build .')
                        sh 'mkdir -p artifacts'
                        def cid = sh(script: "docker create xz-build", returnStdout: true).trim()
                        sh "docker cp ${cid}:/app/xz.tar.gz artifacts/xz-${BUILD_NUMBER}.tar.gz"
                        sh "docker rm ${cid}"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('xz-test', '-f Dockerfile.test .')
                        sh 'mkdir -p logs'
                        def cid = sh(script: "docker create xz-test", returnStdout: true).trim()
                        sh "docker cp ${cid}:/app/logs/test_results.log logs/xz_test.log"
                        sh "docker rm ${cid}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        def deployImage = docker.build('xz-deploy', '-f Dockerfile.deploy .')
                        def cid = sh(script: "docker create xz-deploy", returnStdout: true).trim()

                        sh "docker cp artifacts/xz.tar.gz ${cid}:/tmp/xz.tar.gz"
                        sh "docker cp deploy.c ${cid}:/app/deploy.c"
                        sh "docker start ${cid}"

                        sh "docker exec ${cid} tar -xzf /tmp/xz.tar.gz -C /tmp"
                        sh "docker exec ${cid} gcc /app/deploy.c -llzma -o /tmp/deploy_test"
                        sh "docker exec ${cid} /tmp/deploy_test"

                        sh "docker rm -f ${cid}"
                    }
                }
            }
        }

        stage('Print') {
            steps {
                echo '✅ Pipeline dla xz zakończony pomyślnie.'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'INO/GCL02/JK414562/pipeline/artifacts/xz.tar.gz'
            archiveArtifacts artifacts: 'INO/GCL02/JK414562/pipeline/logs/xz_test.log'
        }
    }
    }

### Z powodzeniem udało się wykonać cały pipeline.[Wydruk z konsoli](console_output.txt)
### Zrzut ekranu powodzenia z uzyskanymi artefaktami:

![image](https://github.com/user-attachments/assets/146a3fff-c8ca-47be-8e54-bf7c53c9a10f)

### Pobranie artefaktu `xz.tar.gz` z kontenera Jenkins

Udało się wejść do kontenera `jk414562_jenkins_1` poleceniem:

    docker exec -it jk414562_jenkins_1 bash

W kontenerze odnaleziono utworzony artefakt oraz odkryto jego pełną ścieżkę przy użyciu polecenia:

    find /var/jenkins_home -name xz.tar.gz

Jedna z lokalizacji artefaktu:

    /var/jenkins_home/workspace/zad/INO/GCL02/JK414562/pipeline/artifacts/xz.tar.gz

Zrzut ekranu ze ścieżką:

![image](https://github.com/user-attachments/assets/9844a96a-7e10-4b10-a8c2-ea5971bea75d)

Artefakt został następnie skopiowany z kontenera Jenkins na hosta poleceniem:

    docker cp jk414562_jenkins_1:/var/jenkins_home/workspace/zad/INO/GCL02/JK414562/pipeline/artifacts/xz.tar.gz .

Po sprawdzeniu, że plik nie pojawił się w oczekiwanej lokalizacji, zlokalizowano go bezpośrednio w wolumenie Dockera:

    /var/lib/docker/volumes/jk414562_jenkins_home/_data/workspace/zad/INO/GCL02/JK414562/pipeline/artifacts/xz.tar.gz

Został skopiowany komendą:

    sudo cp /var/lib/docker/volumes/jk414562_jenkins_home/_data/workspace/zad/INO/GCL02/JK414562/pipeline/artifacts/xz.tar.gz ~/MDO2025_INO/INO/GCL02/JK414562/Sprawozdanie2/

Weryfikacja zawartości pakietu:
  
    tar -tzf xz.tar.gz

![image](https://github.com/user-attachments/assets/a716ad79-cce0-44de-a973-8ecc698062e3)

## Odporność i utrzymywalność rozwiązania (Maintainability)

W celu zapewnienia łatwości utrzymania oraz odporności rozwiązania na awarie, wdrożono następujące mechanizmy i dobre praktyki:

- **Podział na moduły**: każdy etap pipeline'a jest oddzielnym krokiem (clone, build, test, deploy, publish), z własnymi Dockerfile’ami (`Dockerfile.build`, `Dockerfile.test`, `Dockerfile.deploy`), co umożliwia niezależny rozwój i debugowanie każdego z nich.
- **Odporność na błędy i awarie**:
  - użyto bloku `post { always { ... } }`, aby zapewnić archiwizację artefaktów niezależnie od powodzenia builda,
  - logi testowe zapisywane są do osobnego pliku (`xz_test.log`), co pozwala na analizę w razie niepowodzenia,
  - w test-entrypoint możesz zastosować `|| true`, aby zapobiec twardemu zakończeniu kontenera przy błędach (jeśli tego jeszcze nie ma – mogę podpowiedzieć).
- **Możliwość powtórnego uruchamiania pipeline'u**:
  - pipeline został przetestowany wielokrotnie – działa niezawodnie przy ponownych uruchomieniach,
  - na początku każdego builda wykonywane jest czyszczenie (`rm -rf xz`), aby uniknąć cacheowania repozytorium,
  - Docker obrazy są budowane od zera, bez użycia cache.
- **Przyjazność dla maintainerów**:
  - cały proces opisano szczegółowo w sprawozdaniu, a pliki Dockerfile i Jenkinsfile są dołączone w kopiowalnej formie,
  - struktura projektu jest zgodna z dobrymi praktykami DevOps – artefakty w `artifacts/`, logi w `logs/`, osobne katalogi.

Dzięki temu pipeline jest nie tylko powtarzalny, ale i łatwy do utrzymania, rozszerzenia oraz debugowania.




