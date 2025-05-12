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

Zmodyfikowano wcześniej utworzony Pipeline, tak aby budował rownież kontener testowy:

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

## 1. Wymagania wstępne środowiska

Aby uruchomić pipeline w środowisku Jenkins, wymagane były następujące zasoby i konfiguracja:

- **Jenkins z wtyczkami do Docker i Git**:
  - Jenkins musi być zainstalowany i skonfigurowany, aby obsługiwał zadania z użyciem Docker.
  - **Wtyczki**:
    - Docker Pipeline
    - Git plugin

- **Kontenery Docker**:
  - Dwa obrazy: `builder` i `tester` (w oparciu o Dockerfile) muszą być dostępne w środowisku.
  - Obraz Docker z wbudowanymi zależnościami (`Dependencies`) powinien zostać stworzony lub pobrany z publicznych repozytoriów (np. obrazy oparte na Ubuntu lub Fedora).

- **Repozytorium kodu źródłowego**:
  - Kod źródłowy aplikacji musi znajdować się w repozytorium Git (w tym przypadku repozytorium znajduje się na GitHubie).

- **Pliki Dockerfile**:
  - Pliki Dockerfile muszą być dostępne i dostosowane do różnych etapów pipeline: `build`, `test`, `deploy`, `publish`.

## 	2. Diagram aktywności - proces CI
Diagram aktywności przedstawiający kolejne etapy procesu CI (Collect, Build, Test, Report) jest następujący:

``` bash
+----------------+      +----------------+      +----------------+      +----------------+
| Collect Sources| ---> | Build Docker   | ---> | Run Tests      | ---> | Report Results |
| (Git Clone)    |      | (Create Image) |      | (Docker Test)  |      | (Log Archival) |
+----------------+      +----------------+      +----------------+      +----------------+

```

Opis etapów:
1. Collect: Źródła aplikacji są zbierane z repozytorium Git za pomocą komendy git clone w Jenkinsie.
2. Build: Kontener jest tworzony na podstawie Dockerfile, w tym etapie jest instalowane oprogramowanie i zależności.
3. Test: Kontener jest uruchamiany, a testy są przeprowadzane. Wyniki testów są zapisywane w logach.
4. Report: Archiwizowanie wyników (artefaktów oraz logów) w celu dalszej analizy.

## 	3. Diagram wdrożeniowy - proces CD
Diagram wdrożeniowy przedstawiający proces deploy i publish aplikacji, uwzględniający interakcje między komponentami i artefaktami, wygląda następująco:

```bash
+----------------+       +------------------+       +--------------------+       +------------------+
| Docker Image   | ----> | Deploy Image     | ----> | Install RPM Package | ----> | Run Application  |
| (Build)        |       | (Target Container)|       | (Target System)     |       | (Verify Output)  |
+----------------+       +------------------+       +--------------------+       +------------------+
```

Opis etapów:
1. Docker Image: Na początku budujemy obraz Dockera zawierający wszystkie zależności.
2. Deploy Image: Obraz Dockera jest wdrażany na docelowym systemie (np. kontenerze).
3. Install RPM Package: Instalacja paczki RPM z aplikacją na systemie docelowym.
4. Run Application: Uruchomienie aplikacji na docelowym systemie i weryfikacja wyników.

## 4. Zdefiniowanie pipeline’u Jenkins

Pipeline Jenkins został zdefiniowany za pomocą pliku `Jenkinsfile`, który automatycznie zarządza procesem budowania, testowania, wdrażania i publikowania aplikacji. Oto kluczowe składniki pipeline’u:

1. **Kontener Builder**:
   - Bazuje na obrazie Ubuntu, który jest wykorzystywany do instalacji zależności, budowy aplikacji i jej pakowania do formatu RPM.
   - Wykorzystuje plik `Dockerfile.build`.

2. **Kontener Tester**:
   - Bazuje na obrazie, który jest wykorzystywany do testowania aplikacji, uruchamiając testy jednostkowe oraz zbierając logi.
   - Wykorzystuje plik `Dockerfile.test`.

3. **Deploy**:
   - Po udanym buildzie i teście, aplikacja jest wdrażana na kontenerze docelowym, gdzie jest instalowana jako paczka RPM.
   - Wykorzystuje plik `Dockerfile.deploy`.

4. **Publish**:
   - Artefakt (np. paczka RPM) jest publikowany i archiwizowany, aby był dostępny do pobrania w przyszłości.

---

## 5. Zasady dotyczące budowy kontenerów, testów i publikacji

1. **Kontener Builder**:
   - Obraz powinien zawierać wszystkie zależności niezbędne do zbudowania aplikacji. Może to obejmować narzędzia takie jak `make`, `gcc`, `fpm`, oraz zależności systemowe. Dzięki temu budowa aplikacji jest możliwa w odizolowanym środowisku.

2. **Kontener Tester**:
   - Kontener musi mieć zainstalowane odpowiednie narzędzia do uruchamiania testów (np. `gcc`, `make` oraz inne zależności w zależności od typu testów).
   - Testy są uruchamiane w ramach kontenera i ich wyniki są zapisywane w logach.

3. **Kontener Deploy**:
   - Obraz deploy powinien zawierać minimalną konfigurację (np. Fedora), która umożliwia instalację paczki RPM i uruchomienie aplikacji.
   - Po zainstalowaniu aplikacji, jest ona uruchamiana i sprawdzana, czy działa zgodnie z oczekiwaniami.

4. **Publikacja Artefaktów**:
   - Artefakty, takie jak paczki RPM, są archiwizowane w wyniku pipeline’u, dzięki czemu mogą być pobrane później.
   - W przypadku potrzeby, artefakty mogą być również publikowane w zewnętrznych rejestrach (np. Docker Hub).

---

## 6. Dyskusja dotycząca wdrożenia i publikacji

1. **Pakowanie aplikacji**:
   - W przypadku tej aplikacji, pakowanie do formatu RPM jest odpowiednie, ponieważ jest to aplikacja, która może być łatwo zainstalowana na systemach Linux opartych na Red Hat.
   - Inne formaty, takie jak DEB (dla systemów Debian/Ubuntu) mogłyby być użyte w alternatywnych środowiskach.

2. **Dystrybucja jako obraz Docker**:
   - Aplikacja może być dystrybuowana jako obraz Docker. To rozwiązanie ma sens, ponieważ pozwala na łatwą replikację środowiska, w którym aplikacja będzie działała, bez konieczności instalowania jej na każdym systemie.
   - Obraz Docker powinien zawierać tylko niezbędne zależności oraz artefakty buildowe. Sklonowanie repozytorium oraz logi buildowe mogą być również przechowywane w kontenerze, ale nie powinny być częścią finalnego obrazu.

3. **Różnica między obrazem `node` a `node-slim`**:
   - Obraz `node` zawiera pełną wersję Node.js wraz ze wszystkimi zależnościami, podczas gdy obraz `node-slim` jest wersją odchudzoną, która nie zawiera wielu zbędnych pakietów, co może zaoszczędzić miejsce i przyspieszyć czas ładowania.

---

## 7. Wnioski

1. **Pipeline Jenkins** zapewnia ciągłość integracji i testowania aplikacji, automatyzując proces budowania, testowania, wdrażania i publikowania aplikacji.
2. **Użycie kontenerów** zapewnia elastyczność i odizolowanie środowiska, co minimalizuje problemy z zależnościami między systemami.
3. **Publikacja artefaktów i wdrożenie za pomocą obrazów Docker** stanowi wygodne i przenośne rozwiązanie dla aplikacji, które mają być uruchamiane w różnych środowiskach.


 ## 8. Kod

``` bash
pipeline {
    agent any

    environment {
        VERSION = "1.0.0"
    }

    stages {
        stage('Clone repo') {
            steps {
                git branch: 'MP417124', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Build Docker image for cJSON') {
            steps {
                script {
                    docker.build("cj-build:${VERSION}", '-f INO/GCL02/MP417124/docker_build/Dockerfile.build .')
                    sh 'mkdir -p artifacts'
                    def buildContainer = sh(script: "docker create cj-build:${VERSION}", returnStdout: true).trim()
                    sh "docker cp ${buildContainer}:/app/cJSON/build/output/cjson.rpm artifacts/cjson-${VERSION}.rpm"
                    sh "docker rm ${buildContainer}"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    docker.build("cj-test:${VERSION}", '-f INO/GCL02/MP417124/docker_build/Dockerfile.test .')
                    sh 'mkdir -p logs'
                    def testContainer = sh(script: "docker create cj-test:${VERSION}", returnStdout: true).trim()
                    sh "docker cp ${testContainer}:/app/cJSON/logs/test_results.log logs/test_results-${VERSION}.log"
                    sh "docker rm ${testContainer}"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    docker.build("cj-deploy:${VERSION}", '-f INO/GCL02/MP417124/docker_build/Dockerfile.deploy .')
                    def deployContainer = sh(script: "docker create cj-deploy:${VERSION}", returnStdout: true).trim()
                    sh "docker cp artifacts/cjson-${VERSION}.rpm ${deployContainer}:/tmp/cjson.rpm"
                    sh "docker cp INO/GCL02/MP417124/docker_build/deploy.c ${deployContainer}:/app/deploy.c"
                    sh "docker start ${deployContainer}"
                    sh "docker exec ${deployContainer} dnf install -y /tmp/cjson.rpm"
                    sh "docker exec ${deployContainer} gcc /app/deploy.c -lcjson -o /tmp/deploy_test"
                    sh "docker exec ${deployContainer} /tmp/deploy_test"
                    sh "docker rm -f ${deployContainer}"
                }
            }
        }

        stage('Print') {
            steps {
                echo "Pipeline finished successfully for version ${VERSION}."
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: "artifacts/cjson-${VERSION}.rpm", allowEmptyArchive: true
            archiveArtifacts artifacts: "logs/test_results-${VERSION}.log", allowEmptyArchive: true
        }
    }
}
```

Dockerfile.test:

```
FROM ubuntu:22.04

WORKDIR /app

RUN apt update && \
    apt install -y git make gcc ruby ruby-dev build-essential rpm

RUN gem install --no-document fpm

WORKDIR /app/cJSON

COPY deploy.c /app/cJSON/deploy.c

RUN make

RUN gcc deploy.c -lcjson -o deploy_test && \
    ./deploy_test > /app/cJSON/logs/test_results.log

CMD ["/bin/bash"]


```
Dockerfile.build:
```
FROM ubuntu:22.04

WORKDIR /app

RUN apt update && \
    apt install -y git make gcc ruby ruby-dev build-essential rpm

RUN gem install --no-document fpm

RUN git clone https://github.com/DaveGamble/cJSON.git

WORKDIR /app/cJSON

RUN make

RUN mkdir -p /tmp/cjson-install/usr/include/cjson \
             /tmp/cjson-install/usr/lib && \
    cp cJSON.h cJSON_Utils.h /tmp/cjson-install/usr/include/cjson && \
    cp libcjson*.so libcjson*.a /tmp/cjson-install/usr/lib


RUN mkdir -p /app/cJSON/build/output


RUN fpm -s dir -t rpm \
    -n cjson \
    -v 1.0.0 \
    -C /tmp/cjson-install \
    -p /app/cJSON/build/output/cjson.rpm .


CMD ["/bin/bash"]
```

Dockerfile.deploy:
```
FROM fedora:41

RUN dnf install -y gcc && dnf clean all

WORKDIR /app

COPY cjson.rpm /tmp/cjson.rpm
COPY deploy.c /app/deploy.c

RUN dnf install -y /tmp/cjson.rpm

RUN gcc /app/deploy.c -lcjson -o /app/deploy_test

CMD ["tail", "-f", "/dev/null"]


```


deploy.c:
```

#include <stdio.h>
#include "cJSON.h"

int main() {

    cJSON *user = cJSON_CreateObject();
    cJSON_AddStringToObject(user, "username", "CI_User");
    cJSON_AddNumberToObject(user, "build", 1025);

    char *json_str = cJSON_Print(user);
    if (json_str == NULL) {
        printf("Blad przy generowaniu JSON\n");
        cJSON_Delete(user);
        return 1;
    }

    printf("Wygenerowany JSON: %s\n", json_str);

    free(json_str);
    cJSON_Delete(user);

    return 0;
}

```




