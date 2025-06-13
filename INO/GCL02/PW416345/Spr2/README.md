# Sprawozdanie 

**Patrycja Wojdyło**

# LAB5
## Przygotowanie maszyny wirtualnej

Stworzyłam nową sieć `jenkins` poleceniem `docker network create jenkins`. 

Następnie uruchomiłam kontener  na obrazie DIND (Docker-in-Docker), przez co moge wykonywaz operacje na Dockerze.
![alt text](<ss3/Zrzut ekranu 2025-05-10 212912.png>)

Stworzyłam plik Dockerfile
![alt text](<ss2/Zrzut ekranu 2025-04-28 185637.png>)

Używając komendy `docker build -t myjenkins-blueocean:2.492.3-1 .` zbudowałam obraz Dockera.
![alt text](<ss3/Zrzut ekranu 2025-05-10 213131.png>)

i następnie uruchomiłam kontener Jenkinsa 

![alt text](<ss3/Zrzut ekranu 2025-05-10 213347.png>)

W celu uzyskania hasła do Jenkins użyłam w terminalu polecenia `docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword`

### Następne kroki wykonywałam na Jenkinsie.
![alt text](<ss2/Zrzut ekranu 2025-04-28 191749.png>)

Stworzyłam program, który wyświetla informacje poprzez polecenie `uname -a`

![alt text](<ss2/Zrzut ekranu 2025-04-28 192432.png>)

![alt text](<ss2/Zrzut ekranu 2025-04-28 200750.png>)


![alt text](<ss2/Zrzut ekranu 2025-04-28 201132.png>)

Następnie utworzyłam drugi projekt w Jenkinsie, którego zadaniem było sprawdzenie, czy aktualna godzina systemowa jest parzysta. Jeśli godzina była nieparzysta, projekt kończył się błędem, a Jenkins oznaczał go jako nieudany.

```bash
HOUR=$(date +%H)
if [ $((HOUR % 2)) -ne 0 ]; then
  echo "Godzina $HOUR jest nieparzysta – zwracam błąd"
  exit 1
else
  echo "Godzina $HOUR jest parzysta – wszystko OK"
fi
```
![alt text](<ss2/Zrzut ekranu 2025-04-28 200845.png>)

Skrypt warunkowy — pipeline kończy się błędem jeśli godzina jest nieparzysta

![alt text](<ss2/Zrzut ekranu 2025-04-28 211808.png>)

Utworzyłam obiekt pipeline1 typu pipeline, który:

*klonuje nasze repozytorium https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

*przechodzi na osobistą gałąź PW416345

*buduje obrazy z dockerfiles zdefiniowanych na poprzednich zajęciach.

```bash

pipeline {
    agent any

    stages {
        stage('Klonowanie repozytorium') {
            steps {
                git branch: 'PW416345', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Budowanie Dockera') {
            steps {
                sh 'docker build -t moj-obraz-builder -f INO/GCL02/PW416345/Sprawozdanie1/Dockerfile.build .'
            }
        }
    }

    post {
        success {
            echo 'Pipeline udany'
        }
        failure {
            echo 'Pipeline nieudany'
        }
    }
}
```
Wynik uruchomienia:
![alt text](<ss3/Zrzut ekranu 2025-05-10 234050.png>)

Następnie uruchomiłam pipeline ponownie:
![alt text](<ss3/Zrzut ekranu 2025-05-10 234213.png>)

Pierwsze uruchomienie zajęło prawie 10min, a drugie 16s. 

Różnice w czasach wykonania pipeline wynikały głównie z użycia `git fetch` zamiast pełnego `clone` oraz z wykorzystania `cache` przy budowaniu obrazów Docker, co znacząco skróciło czas pobierania i budowy.


Przystąpiłam do stworzenia kompletnego pipeline, którego celem była konfiguracja pełnego procesu CI/CD, obejmującego budowanie aplikacji w kontenerze `Builder`, testowanie `Tester`, wdrażanie `Deploy` oraz `Publish`.

Pipeline został zapisany w pliku `Jenkinsfile`

W Jenkinsie utworzyłam nowy projekt typu Pipeline, wybierając w konfiguracji opcję `Pipeline script from SCM`. Jako źródło SCM wskazałam Git, podając adres repozytorium na GitHubie oraz ścieżkę do pliku Jenkinsfile, co pozwoliło Jenkinsowi automatycznie pobierać najnowszą wersję skryptu przy każdym uruchomieniu zadania.

![alt text](<ss3/Zrzut ekranu 2025-05-11 000228.png>)
![alt text](<ss3/Zrzut ekranu 2025-05-11 000311.png>)


Efekty uruchomienia pipeline'u i wytłumaczenie pooszczególnych etapów

Pierwszy etap to `Checkout SCM`, gdzie łączy się z repozytorium i uzyskuje ścieżke do Jenkinsfile

Drugim etap- `Clone`, w którym następuje klonowanie repozytorium zdalne z określonego brancha.

```bash
stage('Klonowanie') {
                steps {
                    git branch: 'PW416345', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git' 
                }
            }
```

Etap Build odpowiada za stworzenie obrazu aplikacji na podstawie pliku `Dockerfile.build`. 

```bash
stage('Build') {
                steps {
                    script {
                        docker.build("${IMAGE_NAME}-build", "-f ${DOCKERFILES_DIR}/Dockerfile.build .")
                    }
                }
            }
```

Etap `Test`- Z wykorzystaniem pliku `Dockerfile.test` zbudowano obraz testowy. Testy zostały uruchomione w osobnym kontenerze, aby nie wpływały na środowisko build. Sprawdzają dostępnośći aplikacji i zapisują logi

```bash
stage('Test') {
                steps {
                    script {
                        docker.build("${IMAGE_NAME}-test", "-f ${DOCKERFILES_DIR}/Dockerfile.test .")
                        sh """
                            docker run --name test-runner ${IMAGE_NAME}-test || true
                            docker cp test-runner:/app/reports ./reports
                            docker rm test-runner
                        """
                    }
                }
            }
```
Zbudowałam finalny obraz aplikacji z wykorzystaniem `Dockerfile.deploy`
```bash
stage('Deploy') {
                steps {
                    script {
                        docker.build("${IMAGE_NAME}:${VERSION}", "-f ${DOCKERFILES_DIR}/Dockerfile.deploy .")
                    }
                }
            }
```

Aplikacja została uruchomiona w kontenerzetestowym, po czym sprawdzono jej działanie.

```bash
stage('Website Test') {
                steps {
                    script {
                        sh """
                            docker rm -f website-test || true
                            docker run -d --rm --network ${DOCKER_NETWORK} --name website-test ${IMAGE_NAME}:${VERSION}
                            sleep 5
                            docker run --rm --network ${DOCKER_NETWORK} curlimages/curl:latest http://website-test:8000
                        """
                    }
                }
            }

```

W etapie `Publish` raporty testowe zostały skopiowane do katalogu `artifacts` i zarchiwizowane w Jenkinsie

```bash
stage('Publish') {
                steps {
                    script {
                        sh 'mkdir -p artifacts'
                        sh 'cp -r reports/* artifacts/'
                        archiveArtifacts artifacts: 'artifacts/**'
                    }
                }
            }
```
Ostatni etap - Po każdym uruchomieniu pipeline’a usuwany jest kontener testowy, aby nie zaśmiecać środowiska CI.
```bash
post {
            always {
                echo "Sprzątanie" 
                sh "docker rm -f website-test || true"
            }
        }

```

![alt text](<ss3/Zrzut ekranu 2025-05-11 002818.png>)

Pipeline został podzielony na osobne etapy (Build, Test, Deploy, Publish), co ułatwia jego analizę i modyfikację.
Skrypt Jenkinsfile jest zapisany w repozytorium, więc łatwo śledzić zmiany i w razie potrzeby je poprawić.
Dzięki temu pipeline łatwo zmieniać i rozwijać, gdy zajdzie taka potrzeba.

