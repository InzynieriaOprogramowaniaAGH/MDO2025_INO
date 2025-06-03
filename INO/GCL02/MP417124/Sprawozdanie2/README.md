# Sprawozdanie (Zadania 5-7)


## Przygotowanie środowiska

Na początku zajęć przystąpiłam do utworzenia instancji Jenkinsa według instrukcji - `https://www.jenkins.io/doc/book/installing/docker/`. Zainicjowałam sieć Dockera (`jenkins`), a następnie uruchomiłam kontener `docker-in-docker`, który stanowił kluczowy element umożliwiający wykonywanie komend Dockera bezpośrednio z poziomu Jenkinsa. 

Najpierw zaczełam od utworzenia nowej sieci dockera **Jenkins** poprzez komendę `docker network create jenkins`.
Następnie utworzyłam kontener docker-in-docker (dind), kt

![Zrzut ekranu 1 – Uruchomienie kontenera dind i sieci](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie2/Screenshots/Screenshot%202025-05-02%20at%205.14.38%E2%80%AFPM.png)


Następnie stworzyłam spersonalizowany obraz Dockera na bazie oficjalnego obrazu Jenkinsa, rozszerzając go o obsługę Docker CLI oraz instalując potrzebne pluginy: `blueocean` i `docker-workflow`. Dzięki temu możliwe było wykorzystanie interfejsu Blue Ocean do wizualizacji pipeline’ów, co w znacznym stopniu poprawia przejrzystość i komfort pracy.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie2/Screenshots/Screenshot%202025-05-02%20at%205.17.59%E2%80%AFPM.png)

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie2/Screenshots/Screenshot%202025-05-02%20at%205.23.42%E2%80%AFPM.png)


Całość środowiska została uruchomiona i podłączona do wspólnej sieci Dockera, a interfejs Jenkinsa był dostępny przez przeglądarkę lokalnie. Proces pozyskania hasła oraz instalacji pluginów przebiegł bez zakłóceń.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie2/Screenshots/Screenshot%202025-05-02%20at%205.30.54%E2%80%AFPM.png)


Udało się uzyskać hasło:
![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie2/Screenshots/Screenshot%202025-05-02%20at%205.31.31%E2%80%AFPM.png)

---

## Zadania wstępne

W ramach pierwszych prób stworzyłam kilka prostych projektów:

- Komenda `uname` pozwoliła sprawdzić, czy Jenkins wykonuje poprawnie skrypty powłoki.  
  ![Zrzut ekranu 7 – uname](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie2/Screenshots/Screenshot%202025-05-02%20at%205.49.51%E2%80%AFPM.png)

  ``` bash
  uname -a
  ```
  
- Napisałam skrypt, który sprawdza, czy bieżąca godzina jest parzysta. Mimo że to zadanie miało charakter czysto testowy, świetnie obrazuje, jak Jenkins może służyć do uruchamiania warunkowych zadań.  
  ![Zrzut ekranu 8 – Sprawdzenie godziny](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie2/Screenshots/Screenshot%202025-05-02%20at%205.53.48%E2%80%AFPM.png)

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
  ![Zrzut ekranu 9 – docker pull ubuntu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie2/Screenshots/Screenshot%202025-05-02%20at%205.55.23%E2%80%AFPM.png)

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

 ![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie2/Screenshots/Screenshot%202025-05-02%20at%207.36.40%E2%80%AFPM.png)

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

- **System operacyjny hosta:** Linux z obsługą Dockera 
- **Docker Engine:** minimum wersja 20.10 — pipeline intensywnie wykorzystuje budowanie i uruchamianie kontenerów
- **Jenkins lub inny system CI/CD:** skonfigurowany agent z dostępem do Dockera 
- **Uprawnienia:** użytkownik uruchamiający pipeline musi mieć prawo do wykonywania poleceń Docker (`docker build`, `docker cp`, `docker exec` itd.)


## 2. Diagram aktywności - proces CI

Diagram aktywności przedstawiający kolejne etapy procesu CI (Clone, Build, Test, Deploy, Report) jest następujący:

```bash
+-------------------+      +----------------------------+      +---------------------+      +-------------------+      +---------------------+
| Clone Repo        | ---> | Build Docker Image (cJSON)  | ---> | Run Tests            | ---> | Deploy Package     | ---> | Report Results      |
| (git clone)       |      | (Create Build Image)        |      | (Run Test Container) |      | (Install RPM)      |      | (Archive Artifacts) |
+-------------------+      +----------------------------+      +---------------------+      +-------------------+      +---------------------+

```

Opis etapów:


**1. Clone Repo (Collect):**
- W tym etapie źródła aplikacji są pobierane z repozytorium Git za pomocą komendy `git clone`. Repozytorium zawiera kod źródłowy projektu `cJSON` oraz wszystkie niezbędne pliki konfiguracyjne.
- Repozytorium jest klonowane w określonym branchu (`MP417124`), a dane są przekazywane do kolejnego etapu pipeline’a.

**2. Build Docker Image (Build):**
- Na podstawie pliku `Dockerfile.build`, kontener jest budowany. W tym etapie instalowane są wszystkie zależności wymagane do skompilowania projektu `cJSON` oraz stworzenia paczki `.rpm` z biblioteką.
- Zawiera to takie kroki jak: instalacja wymaganych narzędzi, sklonowanie repozytorium `cJSON`, kompilacja i budowanie paczki RPM.
- Rezultatem tego etapu jest plik `.rpm`, który będzie użyty w dalszych krokach.

**3. Run Tests (Test):**
- Kontener testowy jest tworzony na podstawie pliku `Dockerfile.test`. Testy są uruchamiane w tym kontenerze, który sprawdza poprawność działania kompilacji i funkcji w projekcie `cJSON`.
- Testy są uruchamiane na pliku `deploy.c`, który wykorzystuje bibliotekę `cJSON` do generowania danych JSON. Wyniki testów są zapisywane do pliku logów.
- Logi testów są przekazywane do następnego etapu.

**4. Deploy Package (Deploy):**
- W tym etapie tworzony jest kontener na podstawie pliku `Dockerfile.deploy`. Następnie paczka `.rpm` jest instalowana w tym kontenerze.
- Kontener wykonuje instalację pakietu, kompiluje kod źródłowy (plik `deploy.c`) oraz uruchamia testy w środowisku zainstalowanej biblioteki `cJSON`.
- Po zainstalowaniu pakietu i uruchomieniu testów kontener jest usuwany.

**5. Report Results (Report):**
- Po zakończeniu wszystkich etapów, wyniki są archiwizowane w celu dalszej analizy. Zawiera to:
  - Artefakty (np. paczka RPM),
  - Logi z testów.
- Archiwizowanie wyników umożliwia późniejszą weryfikację oraz diagnozowanie ewentualnych problemów w przypadku niepowodzenia któregoś z testów.

## 	3. Diagram wdrożeniowy - proces CD
Diagram wdrożeniowy przedstawiający proces deploy i publish aplikacji, uwzględniający interakcje między komponentami i artefaktami, wygląda następująco:

```bash
+-----------------------------------------------------------+
|                        Jenkins CI/CD                      |
|-----------------------------------------------------------|
| - Uruchamia pipeline                                      |
| - Buduje obrazy Docker: build, test, deploy               |
| - Kopiuje artefakty i pliki (cjson.rpm, deploy.c)         |
| - Tworzy i uruchamia kontener cj-deploy                   |
| - Archiwizuje artefakty (.rpm, logi)                      |
+------------------------+----------------------------------+
                         |
                         v
         +------------------------------------------+
         |          Docker container: cj-deploy     |
         |------------------------------------------|
         | - Bazowy obraz: Fedora 41                |
         | - Odbiera:                               |
         |     • cjson-1.0.0.rpm                    |
         |     • deploy.c                           |
         | - Działania:                             |
         |     • Instalacja paczki RPM              |
         |     • Kompilacja deploy.c (gcc)          |
         |     • Uruchomienie deploy_test           |
         |     • Walidacja działania biblioteki     |
         +----------------------+-------------------+
                                  |
                                  v
          +-----------------------------------------+
          |      Host Jenkins – System plików       |
          |-----------------------------------------|
          | artifacts/                              |
          |   • cjson-1.0.0.rpm                     |
          | logs/                                   |
          |   • test_results-1.0.0.log              |
          |                                         |
          | -> Archiwizacja przez `archiveArtifacts`|
          +-----------------------------------------+
```

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

## 5. Krok `Deploy` i `Publish`

W omawianym pipeline'ie kroki `Deploy` i `Publish` odgrywają istotną rolę w zapewnieniu poprawności i jakości zbudowanego artefaktu w postaci paczki RPM. Celem tych etapów jest nie tylko potwierdzenie, że paczka została zbudowana poprawnie, ale również zweryfikowanie jej działania w środowisku zbliżonym do docelowego oraz jej archiwizacja do późniejszego użytku lub publikacji.

Etap `Deploy` realizowany jest poprzez budowę osobnego obrazu Dockera na podstawie systemu Fedora 41, w którym następnie instalowana jest paczka RPM z biblioteką `cJSON`. Do obrazu kopiowany jest również plik `deploy.c` — prosty program testowy, który wykorzystuje funkcje udostępniane przez bibliotekę `cJSON`. W ramach tego etapu wykonywane są następujące czynności: budowa obrazu Dockera (`cj-deploy`), utworzenie i uruchomienie kontenera, instalacja paczki RPM, kompilacja programu testowego i jego uruchomienie. Jeżeli którakolwiek z tych operacji zakończy się błędem — na przykład z powodu brakujących plików nagłówkowych, błędów w instalacji czy niekompatybilności zależności — pipeline zostaje przerwany. Dzięki temu etap `Deploy` pełni funkcję testu wdrożeniowego, sprawdzającego, czy artefakt działa w odizolowanym środowisku w taki sposób, jak był zaprojektowany.

Z kolei funkcję `Publish` pełni w tym przypadku sekcja `post`, która automatycznie archiwizuje zbudowane artefakty: paczkę `cjson-1.0.0.rpm` oraz logi z testów jednostkowych. Dzięki temu możliwa jest trwała rejestracja wyników danego uruchomienia pipeline’a, a także ich ewentualna publikacja w repozytorium artefaktów, dalsze testowanie integracyjne lub przekazanie zespołowi wdrożeniowemu. Choć w tym pipeline'ie nie wykorzystano osobnego narzędzia typu Artifactory czy Nexus, mechanizm `archiveArtifacts` pełni analogiczną rolę na poziomie lokalnym lub w systemie CI/CD takim jak Jenkins.

Zaprojektowanie tych dwóch kroków w ten sposób ma uzasadnienie praktyczne i zgodne jest z dobrymi praktykami DevOps. `Deploy` zapewnia test środowiskowy — paczka jest instalowana i wykorzystywana dokładnie tak, jak zrobiłby to użytkownik końcowy. Pozwala to wykryć błędy wynikające z niekompletnej paczki (brak plików `.h`, `.so`, itp.) czy niepoprawnego działania funkcji biblioteki. `Publish`, nawet jeśli ograniczony do archiwizacji lokalnej, zapewnia trwałość wyników i ich dostępność po zakończeniu pipeline’a. 

W przypadku użytego repozytorium (`https://github.com/DaveGamble/cJSON.git`) oraz wykorzystania narzędzi takich jak `fpm`, `rpm` i `gcc`, takie podejście pozwala na pełne przetestowanie i zweryfikowanie poprawności paczki RPM przed przekazaniem jej dalej, np. do systemu produkcyjnego, środowiska testów integracyjnych lub jako zależności w innym projekcie.


---

## 6. Dyskusja dotycząca wdrożenia i publikacji

1. **Pakowanie aplikacji**:
   - W przypadku tej aplikacji, pakowanie do formatu RPM jest odpowiednie, ponieważ jest to aplikacja, która może być łatwo zainstalowana na systemach Linux opartych na Red Hat.
   - Inne formaty, takie jak DEB (dla systemów Debian/Ubuntu) mogłyby być użyte w alternatywnych środowiskach.

2. **Dystrybucja jako obraz Docker**:
   - Aplikacja może być dystrybuowana jako obraz Docker. To rozwiązanie ma sens, ponieważ pozwala na łatwą replikację środowiska, w którym aplikacja będzie działała, bez konieczności instalowania jej na każdym systemie.

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




