# Sprawozdanie 2 
## Lab 5-7
### 1.  Instalacja Jenkins
Utworzyłam plik `dockerfile.jenkins`:

Wtyczki: Docker-workflow – integracja Dockera z potokami Jenkinsa. Blueocean – interfejs użytkownika dla Jenkinsa. Pipeline-utility-steps – dodatkowe funkcje dla potoków. Aby umożliwić Jenkinsowi komunikację z Dockerem, w kontenerze zainstalowałam narzędzia Docker CLI. Ze względów bezpieczeństwa po instalacji narzędzi zmieniłam użytkownika z root na jenkins.
![zdj0](screenshots2/51.png)
![zdj1](screenshots2/50.png)


Utworzyłam sieć mostkowana jenkins-net
![zdj2](screenshots2/52.png)


Następnie pobrałam i uruchomiłam kontenery docker dind i jenkinsa i sprawdziłam działające kontenery:
![zdj3](screenshots2/53.png)
![zdj4](screenshots2/55.png)
![zdj5](screenshots2/56.png)

Po wejsciu na stroję Jenkinsa za pomocą IP: `http://192.168.0.116:8080/`. Uzyskałam hasło, które wprowadziłam na stronie poleceniem:
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
![zdj6](screenshots2/58.png)
![zdj7](screenshots2/57.png)


Następnie prześledziłam wszytskie kroki logowania i instalacji:
![zdj8](screenshots2/59.png)
![zdj9](screenshots2/60.png)


Utworzyłam nowy projekt (ogólny projekt) i w `kroki budowania` -> `Uruchom powłokę` zwróciłam informacje o systemie operacyjnym poleceniem `uname -a`:
![zdj10](screenshots2/61.png)
![zdj11](screenshots2/62.png)


Po uruchomieniu i poprawnym wykonaniu się zadania logi z konsoli:
![zdj12](screenshots2/63.png)


Następnie utworzyłam nowy projekt `projekt2` poprzez wyranie opcji `pipeline` i wprowadziłam kod, który wyrzuca błąd, kiedy godzina jest nieparzysta:
![zdj13](screenshots2/65.png)
![zdj14](screenshots2/66.png)
![zdj15](screenshots2/64.png)
logi:
![zdj16](screenshots2/68.png)


Następnie utworzyłam nowy projekt 3 poprzez wyranie opcji `pipeline` i wprowadziłam kod, który pobiera w projekcie obraz kontenera ubuntu (stosując docker pull):
![zdj17](screenshots2/71.png)
![zdj18](screenshots2/70.png)
Całe logi z projektu 3 znajdują się w pliku [logi3](screenshots2/logi3.txt)


Kolejnym krokiem było utworzenie projektu `projekt4` znowu poprzez wybranie `pipeline`. 
Kod zawiera:
1) Klon repozytorium MDO2025_INO i wykonuje checkout na mój branch `PS417478`,
2) Budowanie obrazu dockera `Dockerfile.build`,
3) Budowanie obrazu testowego `Dockerfile.test`,
4) Uruchomienie testów
5) publikacja logów z testów

Pliki Dockerfile, skopiowałam z poprzednich zajęc, natomiast poleceniem `fingerprint` pozwalam Jenkinsowi śledzić między różnymi etapami, przepływ danego pliku.
```bash
pipeline {
    agent any

    stages {
        stage('Klonowanie repozytorium') { 
            steps {
                git branch: 'PS417478', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Budowanie obrazu buildera') {
            steps {
                dir ("INO/GCL02/PS417478/Sprawozdanie2")
                {
                    script {
                        docker.build('cjson-builder-image', '-f Dockerfile.build .')
                    }
                }
            }
        }

        stage('Budowanie obrazu testowego') {
            steps {
                dir ("INO/GCL02/PS417478/Sprawozdanie2")
                {
                    script {
                        docker.build('cjson-test-image', '-f Dockerfile.test .')
                    }
                }
            }
        }

        stage('Testy') {
            steps {
                dir ("INO/GCL02/PS417478/Sprawozdanie2")
                {
                    sh "mkdir -p artifacts"

                    sh """
                        docker run --rm cjson-test-image | tee artifacts/test.log
                    """
                }    
            }
        }

        stage('Publikacja logów z testów') {
            steps {
                archiveArtifacts artifacts: 'INO/GCL02/PS417478/Sprawozdanie2/artifacts/test.log', fingerprint: true
            }
        }
    }
}
```
![zdj20](screenshots2/72.png)
![zdj21](screenshots2/73.png)

Całe logi z projektu 4 znajdują się w pliku [logi4](screenshots2/logi4.txt)


Następnym zadaniem było utworzyć pełny pipeline z etapami: Clone, Clear Docker Cache, build, test, deploy, oraz publish za pomocą kontenera. 
Do tego stworzyłam plik Jenkinsfile, który wygląda nastepująco:
[Jenkinsfile](Jenkinsfile)
```bash
pipeline {
    agent any

    stages {
        stage('Clone') { 
            steps {
                git branch: 'PS417478', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Clear Docker cache') {
            steps {
                sh 'docker builder prune -af'
            }
        }

        stage('Build') {
            steps {
                dir("INO/GCL02/PS417478/Sprawozdanie2/pipeline") {
                    script {
                        docker.build('cjson-builder-image', '-f Dockerfile.build .')

                        sh '''
                            mkdir -p ../artifacts
                            CID=$(docker create cjson-builder-image)
                            docker cp $CID:/app/mycjson.rpm ../artifacts/
                            docker rm $CID
                        '''
                    }
                }
            }
        }

        stage('Test') {
            steps {
                dir("INO/GCL02/PS417478/Sprawozdanie2/pipeline") {
                    script {
                        docker.build('cjson-test-image', '-f Dockerfile.test .')

                        sh """
                            docker run --rm cjson-test-image | tee ../artifacts/cjson_test.log
                        """
                    }
                }    
            }
        }

        stage('Deploy') {
            steps {
                dir("INO/GCL02/PS417478/Sprawozdanie2/pipeline") {
                    script {
                        sh 'cp ../artifacts/mycjson.rpm .'
                        docker.build("cjson-deploy-image", "-f Dockerfile.deploy .")

                        sh """
                            docker run --rm cjson-deploy-image | tee ../artifacts/cjson_deploy.log
                        """
                    }      
                }
            }
        }

        stage('Publish') {
            steps {
                archiveArtifacts artifacts: 'INO/GCL02/PS417478/Sprawozdanie2/artifacts/*.log', fingerprint: true
                archiveArtifacts artifacts: 'INO/GCL02/PS417478/Sprawozdanie2/artifacts/*.rpm', fingerprint: true
            }
        }
    }
}
```
Plik ten:
`Clone` - pobiera z mojego brancha repozytorium pliki potrzebne do budowy pipeline-a,

`Clear Docker cache` - czyści pamięć podręczną tak aby każdy kolejny build wykonywany był na "nowym" środowisku,

`Build` - buduje obraz dockera [dockerfile.build](pipeline/Dockerfile.build), oraz pakiet .rpm - artefakt,

`Test` - buduje obraz dockera [dockerfile.test](pipeline/Dockerfile.test), uruchamia test biblioteki cJSON i zapisuje jego wyniki do pliku cjson_test.log,

`Deploy` - buduje obraz dockera [dockerfile.deploy](pipeline/Dockerfile.deploy), uruchamia program testujący biblioteke [main.c](pipeline/main.c) i wynik zapisuje w pliku cjson_deploy.log,

`Publish` - archiwuzuje utworzone artefakty, które są dostępne do pobrania z interfejsu Jenkinsa.


Utworzyłam nowy `pipeline` z opcją `pipeline script from SCM`, w SCM `git`, oraz odpowiednio repository URL, mój Branch, oraz ścieżkę do mojego Jenkinsfile:
![zdj20](screenshots2/74.png)

Po uruchomieniu - wyniki:
![zdj21](screenshots2/75.png)
![zdj22](screenshots2/76.png)
[cjson_test.log](screenshots2/cjson_test.log.txt)

[cjson_deploy.log](screenshots2/cjson_deploy.log.txt)

[logi z konsoli1](screenshots2/logiP1.txt)

Pliki po ponownym uruchomieniu:
![zdj23](screenshots2/77.png)
[cjson_test2.log](screenshots2/cjson_test2.log.log)

[cjson_deploy2.log](screenshots2/cjson_deploy2.log)

[logi z konsoli2](screenshots2/logiP1.txt)

Następnie pobrałam archiwum [cjson.rpm](mycjson.rpm) i przeprowadziłam instalacje biblioteki:
![zdj24](screenshots2/78.png)


Diagram UML - przedstawia uproszczone kolejne kroki realizowane w moim pipeline:

![zdj25](screenshots2/80.png)


Dlaczego w Projekcie wybrałam podejście DIND?

Istnieją dwa główne sposoby uruchamiania Dockera w Jenkinsie:

`1. Docker Outside of Docker (DOoD)` – Jenkins korzysta z Dockera działającego na hoście.

Zalety: prosta konfiguracja, niskie zużycie zasobów.

Wady: słaba izolacja, ryzyko ingerencji w system hosta, mniejsza przenośność pipeline’u.


`2. Docker-in-Docker (DIND)` – Jenkins łączy się z własnym kontenerem z demonem Dockera.

Zalety: dobra izolacja, lepsze bezpieczeństwo, łatwe przenoszenie środowiska, możliwość uruchamiania wielu buildów niezależnie.

Wady: większa złożoność, większe zużycie zasobów.


Wybrałam DIND, ponieważ zapewnia większe bezpieczeństwo i umożliwia łatwe przenoszenie oraz odtwarzanie środowiska CI/CD na różnych maszynach.


--- 
Do pomocy korzystałam ze sztucznej inteligencji takej jak `Chat GPT`, `DeepSeak`, oraz `Perplexity.ai`, każdorazowo weryfikując informacje w róznych źródłach.