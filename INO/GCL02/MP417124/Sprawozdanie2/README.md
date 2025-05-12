# Sprawozdanie (Zadania 5-7)


## Przygotowanie środowiska

Na początku zajęć przystąpiłam do utworzenia instancji Jenkinsa według instrukcji - `https://www.jenkins.io/doc/book/installing/docker/`. Zainicjowałam sieć Dockera (`jenkins`), a następnie uruchomiłam kontener `docker-in-docker`, który stanowił kluczowy element umożliwiający wykonywanie komend Dockera bezpośrednio z poziomu Jenkinsa. 

Najpierw zaczełam od utworzenia nowej sieci dockera **Jenkins** poprzez komendę `docker network create jenkins`.
Następnie utworzyłam kontener docker-in-docker (dind), kt

![Zrzut ekranu 1 – Uruchomienie kontenera dind i sieci]()

Następnie stworzyłam spersonalizowany obraz Dockera na bazie oficjalnego obrazu Jenkinsa, rozszerzając go o obsługę Docker CLI oraz instalując potrzebne pluginy: `blueocean` i `docker-workflow`. Dzięki temu możliwe było wykorzystanie interfejsu Blue Ocean do wizualizacji pipeline’ów, co w znacznym stopniu poprawia przejrzystość i komfort pracy.

![Zrzut ekranu 2 – Budowanie obrazu Jenkins]()

Całość środowiska została uruchomiona i podłączona do wspólnej sieci Dockera, a interfejs Jenkinsa był dostępny przez przeglądarkę lokalnie. Proces pozyskania hasła oraz instalacji pluginów przebiegł bez zakłóceń.

![Zrzut ekranu 3 – Kontener jenkins-blueocean]()  
![Zrzut ekranu 4 – Strona logowania]()  
![Zrzut ekranu 5 – Hasło jednorazowe]()  
![Zrzut ekranu 6 – Instalacja pluginów]()

---

## Zadania wstępne

W ramach pierwszych prób stworzyłam kilka prostych projektów:

- Komenda `uname` pozwoliła sprawdzić, czy Jenkins wykonuje poprawnie skrypty powłoki.  
  ![Zrzut ekranu 7 – uname]()

  ``` bash
       uname -a
  ```


- Napisałam skrypt, który sprawdza, czy bieżąca godzina jest parzysta. Mimo że to zadanie miało charakter czysto testowy, świetnie obrazuje, jak Jenkins może służyć do uruchamiania warunkowych zadań.  
  ![Zrzut ekranu 8 – Sprawdzenie godziny]()

    ``` bash
  #!/bin/bash
  HOUR=$(date +%H)
  echo "Aktualna godzina: $HOUR"
  if [ $((10#$HOUR % 2)) -eq 0 ]; then
    echo "Godzina jest parzysta"
  else
    echo "Godzina jest nieparzysta"
  fi
  ```

- Utworzyłam job pobierający obraz systemu Ubuntu z Dockera, co potwierdziło poprawność konfiguracji integracji Jenkinsa z Dockerem.  
  ![Zrzut ekranu 9 – docker pull ubuntu]()

  ```bash
    #!/bin/bash
    docker pull ubuntu
  ```

---

## Pipeline – izolacja etapów

W dalszej części laboratorium skonfigurowałam pełnoprawny pipeline w Jenkinsie. Pipeline został podzielony na trzy etapy:

1. **Klonowanie repozytorium** z GitHuba na własną gałąź `MP417124`.
2. **Budowa obrazu Dockera** z pliku `Dockerfile.build`, znajdującego się w strukturze katalogów repozytorium.
3. **Wyświetlenie komunikatu końcowego** o poprawnym przebiegu procesu.

``` bash
pipeline {
    agent any

    stages {
        stage('Clone repo') {
            steps {
                git branch: 'MP417124', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Build Docker image') {
            steps {
                dir ("INO/GCL02/MP417124/docker_build") {
                    script {
                        sh 'ls -la'
                        docker.build('build', '-f Dockerfile.build .')
                    }
                }
            }
        }

        stage('Done') {
            steps {
                echo 'Pipeline ran successfully. Docker image was built.'
            }
        }
    }
}

```

Zmodyfikowano wcześniej utworzony Pipeline, tak aby budował rownież kontener testowy. Kontener testowy zostaje uruchomiony a logi będące wynikami jego działania zostają zapisane w postaci artefaktu.

``` bash
pipeline {
    agent any

    stages {
        stage('Clone repo') {
            steps {
                git branch: 'MP417124', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Build') {
            steps {
                dir ("INO/GCL02/MP417124/docker_build") {
                    script {
                        docker.build('cj-build', '-f Dockerfile.build .')
                    }   
                }
            }
        }
        
        stage('Test') {
            steps {
                dir("INO/GCL02/MP417124/docker_build") {
                    script {
                        docker.build('cj-test', '-f Dockerfile.test .')
                        sh """
                            container_id=\$(docker run -d test-image)
                            mkdir -p logs
                            docker cp \${container_id}:/app/cJSON/logs/test_results.log logs/test_results.log
                            docker rm \${container_id}
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'INO/GCL02/MP417124/docker_build/test_results.log', allowEmptyArchive: true
        }
    }
}
```

W wyniku działania tego etapu logi testów są zapisywane do katalogu logs, a artefakt z wynikami testów jest archiwizowany w systemie Jenkins. W następnym etapie kontener jest budowany na podstawie pliku Dockerfile.deploy i jest uruchamiany w celu weryfikacji pakietu .rpm poprzez jego instalację i kompilację programu testowego. Działania w tym etapie obejmują:

  1.	Instalację pakietu .rpm.
  2.	Kompilację kodu testowego, który korzysta z biblioteki cJSON.
  3.	Uruchomienie skompilowanego programu w kontenerze.

Kod pipeline’u dla etapu Deploy:

``` bash
pipeline {
    agent any

    stages {
        stage('Clone repo') {
            steps {
                git branch: 'MP417124', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Build') {
            steps {
                dir("INO/GCL02/MP417124/docker_build") {
                    script {
                        docker.build('cj-build', '-f Dockerfile.build .')
                    }   
                }
            }
        }
        
        stage('Test') {
            steps {
                dir("INO/GCL02/MP417124/docker_build") {
                    script {
                        docker.build('cj-test', '-f Dockerfile.test .')
                        sh """
                            container_id=\$(docker run -d cj-test)
                            mkdir -p logs
                            docker cp \${container_id}:/app/cJSON/logs/test_results.log logs/test_results.log
                            docker rm \${container_id}
                        """
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                dir("INO/GCL02/MP417124/docker_build") {
                    script {
                        docker.build('cj-deploy', '-f Dockerfile.deploy .')
                        def deployContainer = sh(script: "docker create cj-deploy", returnStdout: true).trim()

                        sh "docker cp artifacts/cjson-${VERSION}.rpm ${deployContainer}:/tmp/cjson.rpm"
                        sh "docker cp deploy.c ${deployContainer}:/app/deploy.c"
                        sh "docker start ${deployContainer}"
                        sh "docker exec ${deployContainer} dnf install -y /tmp/cjson.rpm"
                        sh "docker exec ${deployContainer} gcc /app/deploy.c -lcjson -o /tmp/deploy_test"
                        sh "docker exec ${deployContainer} /tmp/deploy_test"
                        sh "docker rm -f ${deployContainer}"
                    }
                }
            }
        }
    }
}
```
Po zakończeniu kroku Deploy potwierdzane jest, że zbudowany i zainstalowany pakiet .rpm działa poprawnie.

## Zastosowanie Deploy - uzasadnienie

Wybór kontenera do wdrożenia aplikacji, czyli kroku Deploy, wynika z potrzeby weryfikacji, czy zbudowany pakiet .rpm poprawnie integruje się z systemem Linux. Instalacja pakietu odbywa się w kontenerze z systemem Fedora, co zapewnia środowisko oparte na popularnym systemie do testów.

Dodatkowo, proces wdrożenia pozwala na integrację pakietu z aplikacjami przy użyciu kompilacji testowego programu deploy.c. Celem było zapewnienie, że biblioteka cJSON działa zgodnie z oczekiwaniami po jej zainstalowaniu.

## Krok Publish

W kolejnym etapie dodano proces publikacji wyników w postaci artefaktów. Krok Publish w Jenkinsie jest odpowiedzialny za archiwizowanie wygenerowanych artefaktów, takich jak pliki wyników testów oraz pakiety .rpm. Dzięki temu możliwe jest przechowywanie wyników i łatwiejsze ich udostępnienie innym członkom zespołu lub systemom.

Kod pipeline’u dla etapu Publish:\
``` bash
post {
    always {
        archiveArtifacts artifacts: 'INO/GCL02/MP417124/docker_build/artifacts/cjson-${VERSION}.rpm', allowEmptyArchive: true
        archiveArtifacts artifacts: 'INO/GCL02/MP417124/docker_build/logs/test_results.log', allowEmptyArchive: true
    }
}
```

Proces publikacji wyników ma kluczowe znaczenie w CI/CD, ponieważ umożliwia zbieranie artefaktów z różnych etapów pipeline’u. Dzięki archiwizowaniu wyników testów oraz pakietów .rpm, zapewniamy możliwość ich weryfikacji, a także udostępnianie wyników zainteresowanym stronom. Wartość tego kroku polega na uproszczeniu dostępu do wyników oraz zapewnieniu ciągłości pracy nad projektem.

Z punktu widzenia utrzymania, pipeline CI/CD został zaprojektowany w taki sposób, aby każdy etap był modularny i łatwy do modyfikacji. Zastosowanie kontenerów Docker zapewnia, że środowisko testowe jest izolowane, co umożliwia łatwiejsze identyfikowanie problemów i zapewnia stabilność całego procesu. Ponadto, wersjonowanie obrazów Docker oraz artefaktów pozwala na pełną identyfikację pochodzenia każdego elementu, co ułatwia zarządzanie wersjami i aktualizacjami.


