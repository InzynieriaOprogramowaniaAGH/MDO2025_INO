# Sprawozdanie 2 - Pipeline, Jenkins, izolacja etapów

## Przygotowanie
Utworzono instancje jenkinsa zgodnie z instrukcją instalacyjną. 

Utworzono nową sieć dockera Jenkins: 
![image](https://github.com/user-attachments/assets/0ac6a45b-b69f-4088-bf77-4d70b95ff1d8)

# Kompletna Konfiguracja Pipeline CI/CD – XZ Utils

Projekt realizuje pełny cykl Continuous Integration / Continuous Deployment (CI/CD) dla biblioteki [XZ Utils](https://github.com/tukaani-project/xz) w oparciu o Jenkinsa, Docker oraz podejście Docker-in-Docker (DIND).

---

## 🧩 Struktura Pipeline

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
- Gotowe do pobrania lub dalszej redystrybucji.

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
                        // buildujemy obraz
                        docker.build('xz-build', '-f Dockerfile.build .')
                        sh 'mkdir -p artifacts'
                        def cid = sh(script: "docker create xz-build", returnStdout: true).trim()
                        sh "docker cp ${cid}:/app/xz.tar.gz artifacts/xz.tar.gz"
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




