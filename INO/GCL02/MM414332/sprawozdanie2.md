 <img width="452" alt="image" src="https://github.com/user-attachments/assets/1790eb71-4321-4fa4-a6d6-f73d7cec44de" />

Zamiast domyślnego BlueOcean, który nie działał poprawnie na moim systemie (błąd 'exec format error' dla architektury ARM), zdecydowałem się użyć oficjalnego obrazu jenkins/jenkins:lts, który uruchomiłem z odpowiednimi woluminami oraz siecią.

 <img width="452" alt="image" src="https://github.com/user-attachments/assets/81031e36-0920-428d-8bb7-71c2a2fb8469" />

Czym różni się jenkinsci/blueocean od jenkins/jenkins:lts?
•	jenkins/jenkins:lts – podstawowy, oficjalny obraz Jenkinsa w wersji LTS.
•	jenkinsci/blueocean – zawiera dodatkowy interfejs graficzny BlueOcean, lepszy do zarządzania pipeline'ami. Jednak nie jest wspierany na wszystkich architekturach (np. ARM64).

Następnie utworzyłem projekt uname:
 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/b86359e1-a3e5-48a6-b7bb-d7b4c5aeebd6" />

W kolejnym kroku utworzyłem krótki skrypt sprawdzający parzystość godziny:

 <img width="452" alt="image" src="https://github.com/user-attachments/assets/2fc73347-9cb3-4c0d-82d8-bb3b59f0ee9e" />


Następnie w kolejnym projekcie pobrałem obraz Ubuntu I otrzymałem pozywywny wynik:

 <img width="452" alt="image" src="https://github.com/user-attachments/assets/ca9f9bd2-9847-421d-8f7f-9836bbdb3b53" />


Z racji, że miałem problemy z dostępem do pliku Dockerfile.build w pipeline w katalogu lab_5 utworzyłem potrzebne pliki jeszcze raz. 

<img width="452" alt="image" src="https://github.com/user-attachments/assets/de15537d-9a16-45fb-b4c7-9cb0aee9e2f7" />

 
Dodałem tam nowy plik Jenkinsfile.

<img width="452" alt="image" src="https://github.com/user-attachments/assets/3d4f9045-66e1-4efb-bd01-55bb1ea12e5e" />

 
Utworzyłem ponownie sieć i uruchomiłem DinD.

```
pipeline {
    agent any

    environment {
        IMAGE_BUILD = 'my-app-build'
        IMAGE_TEST = 'my-app-test'
        WORKDIR = 'lab_5'
    }

    stages {
        stage('Clone Repo') {
            steps {
                sh 'rm -rf MDO2025_INO'
                sh 'git clone --branch MM414332 https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Build Image') {
            steps {
                dir("MDO2025_INO/INO/GCL02/MM414332/${WORKDIR}") {
                    script {
                        docker.build("${IMAGE_BUILD}", '-f Dockerfile.build .')
                    }
                }
            }
        }

        stage('Test Image') {
            steps {
                dir("MDO2025_INO/INO/GCL02/MM414332/${WORKDIR}") {
                    script {
                        docker.build("${IMAGE_TEST}", '-f Dockerfile.test .')
                        def cid = sh(script: "docker create ${IMAGE_TEST}", returnStdout: true).trim()
                        sh "docker start -a ${cid}"
                        sh "docker rm ${cid}"
                    }
                }
            }
        }
    }
}
```
 <img width="284" alt="image" src="https://github.com/user-attachments/assets/379553be-4b08-4a1b-8832-e600b1ee47bf" />

 <img width="452" alt="image" src="https://github.com/user-attachments/assets/343643af-2d99-42fe-a50a-6f4942552988" />

Uruchomiłem pipelina, który po kliku próbach odpalił się pomyślnie. 

<img width="406" alt="image" src="https://github.com/user-attachments/assets/bed2aa1a-7f44-4f3e-9dc9-cdfb3196a195" />

 
W tym kroku wykonałem prosty diagram UML, który w skrócie przedstawia przepływ sterowania w procesie CI/CD. 

W kolejnej części utworzyłem pipeline który generował artefakt:
```
pipeline {
    agent any

    environment {
        WORKDIR = "MDO2025_INO/INO/GCL02/MM414332/lab_5"
    }

    stages {
        stage('Clone Repo') {
            steps {
                sh 'rm -rf MDO2025_INO'
                sh 'git clone --branch MM414332 https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Build & Package') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('my-app-build', '-f Dockerfile.build .')
                        sh 'mkdir -p artifacts'
                        def cid = sh(script: "docker create my-app-build", returnStdout: true).trim()
                        sh "docker cp ${cid}:/app/xz.tar.gz artifacts/xz-${env.BUILD_NUMBER}.tar.gz"
                        sh "docker rm ${cid}"
                    }
                }
            }
        }

        stage('Print') {
            steps {
                echo 'Build & packaging done. Artifact xz.tar.gz is inside artifacts/'
            }
        }
    }

    post {
        always {
            dir("${WORKDIR}") {
                archiveArtifacts artifacts: 'artifacts/xz-*.tar.gz', fingerprint: true
            }
        }
    }
}
```

 <img width="452" alt="image" src="https://github.com/user-attachments/assets/e0f13481-6409-4669-a87a-d76da8796311" />

Aby wykonać pełny zakres pipeline’a, klonuję repozytorium z gałęzi MM414332, buduję aplikację i tworzę wersjonowany artefakt .tar.gz. Następnie uruchamiam testy w osobnym kontenerze, zapisuję logi z ich przebiegu i archiwizuję je. Po zakończeniu testów buduję obraz runtime i uruchamiam aplikację w kontenerze. Na koniec publikuję artefakt do katalogu publish/ oraz archiwizuję go, informując o pomyślnym zakończeniu pipeline’a.
```
pipeline {
    agent any

    environment {
        WORKDIR = "MDO2025_INO/INO/GCL02/MM414332/lab_5"
    }

    stages {
        stage('Clone Repo') {
            steps {
                sh 'rm -rf MDO2025_INO'
                sh 'git clone --branch MM414332 https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Build & Package') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        def gitCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                        docker.build('my-app-build', '-f Dockerfile.build .')
                        sh 'mkdir -p artifacts'
                        def cid = sh(script: "docker create my-app-build", returnStdout: true).trim()
                        sh "docker cp ${cid}:/app/xz.tar.gz artifacts/xz-${gitCommit}.tar.gz"
                        sh "docker rm ${cid}"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('my-app-test', '-f Dockerfile.test .')
                sh 'mkdir -p logs'

                // Uruchom kontener testowy (uruchomi testy)
                sh "docker run --name my-app-test-container my-app-test || true"

                // Skopiuj logi
                sh "docker cp my-app-test-container:/app/test-results logs/test-results"

                // Usuń kontener
                sh "docker rm my-app-test-container"

                // Archiwizuj wszystko z logs/
                archiveArtifacts artifacts: 'logs/**/*', fingerprint: true

                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('my-app-runtime', '-f Dockerfile.runtime .')
                        sh 'docker stop my-app || true && docker rm my-app || true'
                        sh 'docker run -d --name my-app -p 8080:8080 my-app-runtime'
                    }
                }
            }
        }

        stage('Publish') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        def gitCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                        sh "mkdir -p publish"
                        sh "cp artifacts/xz-${gitCommit}.tar.gz publish/xz-${gitCommit}.tar.gz"
                        archiveArtifacts artifacts: 'publish/**', fingerprint: true
                    }
                }
            }
        }

        stage('Print') {
            steps {
                echo 'Build, Test, Deploy & Publish completed successfully!'
            }
        }
    }

    post {
        always {
            dir("${WORKDIR}") {
                archiveArtifacts artifacts: 'artifacts/xz-*.tar.gz', fingerprint: true
            }
        }
    }
}
```

<img width="452" alt="image" src="https://github.com/user-attachments/assets/571be93a-db23-4520-b8c5-34c1ab2e8084" />
 
W tym przypadku wersjonowaniem jest hash commita. To dobry sposób, bo wersjonowanie po hashu commita zapewnia unikalność artefaktów, pozwala łatwo powiązać je z konkretną wersją kodu i umożliwia szybki powrót do dowolnej wersji w przyszłości.

Dodałem do Dockerfile. Runtime budowanie z artefaktem:
```
pipeline {
    agent any

    environment {
        WORKDIR = "MDO2025_INO/INO/GCL02/MM414332/lab_5"
    }

    stages {
        stage('Clone Repo') {
            steps {
                sh 'rm -rf MDO2025_INO'
                sh 'git clone --branch MM414332 https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Build & Package') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        def gitCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                        docker.build('my-app-build', '-f Dockerfile.build .')
                        sh 'mkdir -p artifacts'
                        def cid = sh(script: "docker create my-app-build", returnStdout: true).trim()
                        sh "docker cp ${cid}:/app/xz.tar.gz artifacts/xz-${gitCommit}.tar.gz"
                        sh "docker rm ${cid}"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        docker.build('my-app-test', '-f Dockerfile.test .')
                sh 'mkdir -p logs'

                // Uruchom kontener testowy (uruchomi testy)
                sh "docker run --name my-app-test-container my-app-test || true"

                // Skopiuj logi
                sh "docker cp my-app-test-container:/app/test-results logs/test-results"

                // Usuń kontener
                sh "docker rm my-app-test-container"

                // Archiwizuj wszystko z logs/
                archiveArtifacts artifacts: 'logs/**/*', fingerprint: true

                    }
                }
            }
        }

        stage('Deploy') {
    steps {
        dir("${WORKDIR}") {
            script {
                def gitCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()

                // Budowanie runtime z artefaktem
                docker.build("my-app-runtime", '-f Dockerfile.runtime .')

                // Uruchomienie kontenera w tle (nieblokujące)
                sh 'docker stop my-app || true && docker rm my-app || true'
                sh 'docker run -d --name my-app -p 8080:8080 my-app-runtime'

                // Sprawdzenie, że działa
                sh 'sleep 2 && docker logs my-app || true'
            }
        }
    }
}
        stage('Publish') {
            steps {
                dir("${WORKDIR}") {
                    script {
                        def gitCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                        sh "mkdir -p publish"
                        sh "cp artifacts/xz-${gitCommit}.tar.gz publish/xz-${gitCommit}.tar.gz"
                        archiveArtifacts artifacts: 'publish/**', fingerprint: true
                    }
                }
            }
        }

        stage('Print') {
            steps {
                echo 'Build, Test, Deploy & Publish completed successfully!'
            }
        }
    }

    post {
        always {
            dir("${WORKDIR}") {
                archiveArtifacts artifacts: 'artifacts/xz-*.tar.gz', fingerprint: true
            }
        }
    }
}
```

```
# Dockerfile.runtime
FROM node:18-slim
WORKDIR /app

# Skopiuj artefakt builda (stworzony wcześniej w pipeline)
COPY artifacts/xz-*.tar.gz xz.tar.gz

# Rozpakuj i przygotuj runtime
RUN mkdir build && tar -xzf xz.tar.gz -C build

# Ustaw komendę startową
CMD ["node", "build/index.js"]
```

 <img width="452" alt="image" src="https://github.com/user-attachments/assets/0611b91b-9bb4-4fec-8605-38a35b9b3940" />

<img width="452" alt="image" src="https://github.com/user-attachments/assets/d41959fb-3d69-4fc9-97ba-ae0d71a324ae" />

W katalogu lab_5 dostępne są uzyskane artefakty.

Podsumowanie:
W ramach realizacji zadania z CI/CD udało mi się przejść przez całą ścieżkę krytyczną – od commita i klonowania repozytorium, przez budowę aplikacji, testy i wdrożenie, aż po publikację wersjonowanego artefaktu. Użyłem podejścia opartego o kontenery Docker i Jenkinsfile zdefiniowany w repozytorium, co zapewnia powtarzalność i niezależność środowiskową. Proces builda odbywa się w osobnym kontenerze, z którego tworzony jest artefakt .tar.gz, a testy są wykonywane w kontenerze opartym na obrazie buildowym. W kolejnym kroku powstaje obraz runtime, który uruchamiany jest w tle, a jego logi archiwizowane — co stanowi dowód, że aplikacja działa.
Wdrożony pipeline spełnia założenia deklaratywnego, dobrze udokumentowanego procesu CI/CD i zapewnia możliwość identyfikacji wersji artefaktów (poprzez skrót commita). Artefakty są automatycznie publikowane w Jenkinsie jako pliki do pobrania, a cały proces może być łatwo uruchamiany ponownie bez ryzyka działania na nieaktualnym kodzie. Jednocześnie pipeline pokazuje dobry podział ról między build, test i deploy, dzięki czemu łatwo go utrzymać i rozwijać.
