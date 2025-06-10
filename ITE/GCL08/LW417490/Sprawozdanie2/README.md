# Sprawozdanie 2

## Lab 5 - Pipeline, Jenkins, izolacja etapów

### Cel:
Celem ćwiczeń jest praktyczne zapoznanie się z podstawową konfiguracją oraz obsługą narzędzia Jenkins w środowisku Docker, ze szczególnym uwzględnieniem pipeline'ów i automatyzacji procesów budowania oraz testowania oprogramowania. 

#### 1. Utworzenie instancji Jenkins

Na poprzednich zajęciach utworzono instancję Jenkins, której konfiguracja została omówiona w Sprawozdaniu 1. 

Na obecnych zajęciach konieczne było ponowne zalogowanie się oraz weryfikacja poprawności konfiguracji instancji. Poniższy zrzut ekranu przedstawia panel logowania oraz główny interfejs Jenkinsa:
![alt text](<Lab5/Zrzut ekranu 2025-04-01 191218.png>)

#### 2. Utworzenie projektu wyświetlającego *uname*

Najpierw w panelu po lewiej stronie wybieramy *Nowy projekt* i opcję *Ogólny projekt*.
![alt text](<Lab5/Zrzut ekranu 2025-04-01 191728.png>)

I nadajemu mu nazwę *uname*
![alt text](<Lab5/Zrzut ekranu 2025-04-01 191925.png>)

W sekcji *Kroki budowy* wybrano opcję *Uruchom powłokę* i wpisano polecenie:
```
uname
```
![alt text](<Lab5/Zrzut ekranu 2025-04-01 192000.png>)
![alt text](<Lab5/Zrzut ekranu 2025-04-01 192018.png>)

Po zatwierdzeniu konfiguracji, przy uruchomieniu projektu, na konsoli pojawił się wynik polecenia uname, co potwierdziło poprawność działania.

#### 3. Utworzenie projektu zwracającego błąd, jeśli godzina jest nieparzysta

Pierwsze krok jest identyczny jak wcześniej, czyli tworzymy nowy projekt. Nazywamy go *FailOnOddHour*.
![alt text](<Lab5/Zrzut ekranu 2025-04-01 192118.png>)

I ponownie w krokach budowy wybieramy *Uruchomienie powłoki*
![alt text](<Lab5/Zrzut ekranu 2025-04-01 192404.png>)

Kod wygląda nastepująco:
```
#!/bin/bash
HOUR=$(date +%H)
if [ $((HOUR % 2)) -eq 1 ]; then
  echo "Godzina jest nieparzysta ($HOUR), zwracam błąd."
  exit 1
else
  echo "Godzina jest parzysta ($HOUR), build OK."
fi
```
I po uruchomieniu o godzinie 19:25, daje następujący wynik:
![alt text](<Lab5/Zrzut ekranu 2025-04-01 192514.png>)

#### 4. Utworzenie projektu pobierającego obraz kontenera *ubuntu*

Pierwszy krok ponownie jest identyczny jak w dwóch poprzednich przypadkach, nowy projekt tym razem został nazwany *PullUbuntuImage*.
![alt text](<Lab5/Zrzut ekranu 2025-04-01 192604.png>)
I także ponownie wybraliśmy *Urochomienie powłoki*
![alt text](<Lab5/Zrzut ekranu 2025-04-01 192629.png>)
Komenda, której użyliśmy wygląda nastepujaco:
```
docker pull ubuntu:latest
```
![alt text](<Lab5/Zrzut ekranu 2025-04-01 192844.png>)
Na poniższym zrzucie ekranu widać, że wszystko poszło prawidłowo.
![alt text](<Lab5/Zrzut ekranu 2025-04-01 192945.png>)

![alt text](<Lab5/Zrzut ekranu 2025-04-01 193116.png>)

#### 5. Utworzenie obiektu typu pipeline

Przy tym zadania także utworzyliśmy nowy projekt, jednak tym razem typu *Pipeline*. Nazwaliśmy go *PipelineDockerBuilld*.
![alt text](<Lab5/Zrzut ekranu 2025-04-01 193144.png>)

W pole *Definition* znajdujące się się na dole strony wpisaliśmy następujący kod:
```
pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'LW417490', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }
        
        stage('Build Dockerfile') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie1') {
                    sh 'docker rmi -f irssi-build'
                    sh 'docker builder prune --force --all'
                    sh 'docker build -t irssi-build -f Dockerfile.irssibld .'
                }
            }
        }
    }
}
```
![alt text](<Lab5/Zrzut ekranu 2025-04-01 200024.png>)

Na zrzucie widać, że mimo kliku nie udanych prób końcowo wsyzstko zadziałało prawidłowo.
![alt text](<Lab5/Zrzut ekranu 2025-04-01 200042.png>)



## Lab 6/7 - Pipeline: lista kontrolna/Jenkinsfile: lista kontrolna

### Cel:
Celem ćwiczeń jest zaprojektowanie i wdrożenie kompletnego procesu CI/CD dla wybranej aplikacji, który obejmuje automatyzację kluczowych etapów takich jak budowanie, testowanie, wdrażanie oraz publikacja artefaktów. 


#### 1. Diagram UML

![alt text](<Lab6-7/Zrzut ekranu 2025-04-22 131123.png>)

#### 2. Wybranie aplikacji
Na potrzeby ćwiczenia zdecydowano się wykorzystać aplikację Express.js, dostępną w oficjalnym repozytorium:

https://github.com/expressjs/express

Projekt ten został wybrany ze względu na swoją popularność oraz dobrze zdefiniowany proces budowania i testowania. Posiada on otwartą licencję typu MIT, co potwierdza możliwość swobodnego wykorzystania kodu:

https://github.com/expressjs/express/blob/master/LICENSE

#### 3. Dockerfile – budowanie i testowanie
W ramach prac przygotowano dwa podstawowe Dockerfile:

Dockerfile.expbuild

Służy do budowania aplikacji:
```
FROM node AS express-build

RUN git clone https://github.com/expressjs/express

RUN npm install -g express-generator@4

RUN express /tmp/foo

WORKDIR /tmp/foo

RUN npm install
```

Dockerfile.exptest

Odpowiedzialny za uruchomienie testów:

```
FROM node AS express-build

RUN git clone https://github.com/expressjs/express.git /app

WORKDIR /app

RUN npm install

RUN npm test
```
Obydwa Dockerfile zostały przetestowane lokalnie oraz wykorzystane w procesie CI w Jenkinsie.

#### 4. Jenkins – konfiguracja pipeline’u

Po uruchomieniu Jenkinsa 

```
https://www.jenkins.io/doc/book/installing/docker/
```

Utworzono nowy projekt typu Pipeline. 

![alt text](<Lab6-7/Zrzut ekranu 2025-04-22 115215.png>)
![alt text](<Lab6-7/Zrzut ekranu 2025-04-22 115430.png>)

W konfiguracji zdefiniowano kolejne etapy budowania i uruchamiania aplikacji:
![alt text](<Lab6-7/Zrzut ekranu 2025-04-22 115441.png>)

Kod ten wyglądał nastepująco:
```
pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'LW417490', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Cleaning') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie2') {
                    sh 'docker rmi -f express-build'
                    sh 'docker rmi -f express-app'
                    sh 'docker builder prune --force --all'
                    sh 'docker network inspect ci >/dev/null 2>&1 && docker network rm ci || true'
                }
            }
        }

        stage('Build Dockerfile') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie2') {
                    sh 'docker build -f Dockerfile.expbuild -t express-build .'
                }
            }
        }

        stage('Publish Dockerfile') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie2') {
                    sh 'docker build -f Dockerfile.exppub -t express-app .'
                }
            }
        }

        stage('Run app') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie2') {
                    sh 'docker network create ci'
                    sh 'docker run --rm -d --network ci --name app -p 3000:3000 express-app'
                    sh 'docker run --rm --network ci fedora curl -s app:3000'
                }
            }
        }
    }
docker build -f Dockerfile.expbuild -t myapp-build .
```
Podczas realizacji pipeline’u początkowo występowały błędy – głównie związane z konfiguracją. Po kilku próbach pipeline zakończył się sukcesem. Widoczne jest to na poniższym zrzucie ekranu:

![alt text](<Lab6-7/Zrzut ekranu 2025-04-22 115656.png>)

![alt text](<Lab6-7/Zrzut ekranu 2025-04-22 115705.png>)

Warto zaznaczyć, że pipeline, który zakończył się sukcesem, był już trzecią próbą – wcześniejsze konfiguracje zostały przypadkowo usunięte.

#### 5. Publikacja obrazu na DockerHub

Aby móc opublikować obraz na Docker Hub, utworzyłam wcześniej Access Token:

![alt text](<Lab6-7/Zrzut ekranu 2025-04-22 122648.png>)

Następnie dodałam token do sekcji Credentials w Jenkinsie:

![alt text](<Lab6-7/Zrzut ekranu 2025-04-22 123016.png>)

W kolejnym kroku stworzyłam osobny projekt typu Pipeline w Jenkinsie o nazwie publish_express, którego celem było zbudowanie aplikacji, jej uruchomienie oraz publikacja finalnego obrazu Dockera do Docker Hub.
```
pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'LW417490', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Cleaning') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie2') {
                    sh 'docker rmi -f express-build'
                    sh 'docker rmi -f express-app'
                    sh 'docker builder prune --force --all'
                    sh 'docker network inspect ci >/dev/null 2>&1 && docker network rm ci || true'
                }
            }
        }

        stage('Build Dockerfile') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie2') {
                    sh 'docker build -f Dockerfile.expbuild -t express-build .'
                }
            }
        }

        stage('Publish Dockerfile') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie2') {
                    sh 'docker build -f Dockerfile.exppub -t express-app .'
                }
            }
        }

        stage('Run app') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie2') {
                    sh 'docker network create ci'
                    sh 'docker run --rm -d --network ci --name app -p 3000:3000 express-app'
                    sh 'docker run --rm --network ci fedora curl -s app:3000'
                }
            }
        }
        
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker_hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                    sh 'docker tag express-app lucyferryt/express-app:latest'
                    sh 'docker push lucyferryt/express-app:latest'
                }
            }
        }
    }
}
```
#### 6. zdalny Jenkinsfile z SCM

Kolejnym krokiem było utworzenie osobnego projektu typu Pipeline w Jenkinsie, tym razem z wyborem opcji *Pipeline script from SCM*. W ten sposób Jenkinsfile został pobrany bezpośrednio z repozytorium git, co jest zgodne z dobrymi praktykami.

Konfiguracja wyglądała następująco:

![alt text](<Lab6-7/Zrzut ekranu 2025-04-22 123336.png>)

Konfiguracja wyglądała nastepująco:

![alt text](<Lab6-7/Zrzut ekranu 2025-04-22 123450.png>)
![alt text](<Lab6-7/Zrzut ekranu 2025-04-22 123501.png>)

Jenkinsfile, z którego korzysta ten proejkt wygląda nastepująco:
```
pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'LW417490', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Cleaning') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie2') {
                    sh 'docker rmi -f express-build'
                    sh 'docker rmi -f express-app'
                    sh 'docker rmi -f express-test'
                    sh 'docker builder prune --force --all'
                    sh 'docker stop app || true'
                    sh 'docker rm app || true'
                    sh 'docker network inspect ci >/dev/null 2>&1 && docker network rm ci || true'
                }
            }
        }

        stage('Build Dockerfile') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie2') {
                    sh 'docker build -f Dockerfile.expbuild -t express-build .'
                }
            }
        }

        stage('Test Dockerfile') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie2') {
                    sh 'docker build --no-cache -f Dockerfile.exptest -t express-test .'
                    sh 'docker run --rm express-test'
                }
            }
        }
        

        stage('Publish Dockerfile') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie2') {
                    sh 'docker build -f Dockerfile.exppub -t express-app .'
                }
            }
        }

        stage('Run app') {
            steps {
                dir('ITE/GCL08/LW417490/Sprawozdanie2') {
                    sh 'docker network create ci'
                    sh 'docker run --rm -d --network ci --name app -p 3000:3000 express-app'
                    sh 'docker run --rm --network ci curlimages/curl -s app:3000'
                }
            }
        }
        
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker_hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                    sh 'docker tag express-app lucyferryt/express-app:latest'
                    sh 'docker push lucyferryt/express-app:latest'
                }
            }
        }
    }
}
```

Kod zadziałał poprawnie przy drugiej próbie, jednak wtedy zapomniałam o testach, następnie napotkałam kilka problemów, które okazały się brakiem "/" w ścieżce. 

![alt text](<Lab6-7/Zrzut ekranu 2025-04-22 123625.png>)
![alt text](<Lab6-7/Zrzut ekranu 2025-04-22 123734.png>)