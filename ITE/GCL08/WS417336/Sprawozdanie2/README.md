# Sprawozdanie 2
**Wojciech Starzyk gr. 8**
# Lab 5
**Jako repozytorium wybrane zostało: https://github.com/expressjs/express**

**Laboratoria zaczęły się od konfiguracji Jenkinsa. Jak pokazano na poprzednim sprawozdaniu Jenkins działa. Poniższy screenshot pokazuje poprawne zalogowanie**

![alt text](<Zdjecia/lab 5/Zrzut ekranu 2025-04-22 111856.png>)


**Następnie wykonane pierwsze kroki przygotowywawcze. W zakładce *tablica* wybrano *nowy projekt*, następnie po wybraniu nazwy projektu w opcjach konfiguracji kroków budowania wybrano *uruchom powłokę*, a tam komendę ```uname -a```.**

![alt text](<Zdjecia/lab 5/Zrzut ekranu 2025-04-01 185751.png>)


**Kolejny projekt zwraca błąd gdy godzina jest nieparzysta.**
```
HOUR=$(date +%H)
if [ $((HOUR % 2)) -ne 0 ]; then
    echo "Blad, nieparzysta godzina ($HOUR)"
    exit 1
fi
```

![alt text](<Zdjecia/lab 5/Zrzut ekranu 2025-04-01 190051.png>)


**Kolejny wykonuje ```docker pull``` podobnie jak pierwszy projekt**

![alt text](<Zdjecia/lab 5/Zrzut ekranu 2025-04-01 191242.png>)


**Następnie wykonano pipeline, który kopiuje repo przedmiotowe i builduje dockerfile.**

```
pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'WS417336', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }
        
        stage('Build Dockerfile') {
            steps {
                dir('ITE/GCL08/WS417336/Sprawozdanie2') {
                    sh 'docker rmi -f express-build'
                    sh 'docker builder prune --force --all'
                    sh 'docker build -f Dockerfiles/Dockerfile.expressbuild -t express-build .'
                }
            }
        }
    }
}

```

**Stage "Clone repository" jak sama nazwa wskazuje klonuje repozytorium z wybranego brancha i url.**

**Stage "Build Dockerfile" czyści wcześniej występujące pliki aby obraz był zawsze odpalany "na świeżo". Ponieważ nie możnaby się po prostu poruszać po folderach w takim skrypcie wykorzystywana jest instrukcja dir(), która wskazuje na folder z którego wykonywane są wskazane w niej isntrukcje.**

![alt text](<Zdjecia/lab 5/Zrzut ekranu 2025-04-22 113907.png>)


**Jak widać na powyższym screenie, występowały problemy z buildem, w wiekszości jednak chodziło o nieodpowiednie czyszczenie, które powodowało wykorzystywanie cache'a zamiast budowania od nowa.**

![alt text](<Zdjecia/lab 5/Zrzut ekranu 2025-04-22 114202.png>)


**Nie sposób byłoby umieścic cały wypis konsoli, natomiast widać, iż nie wykorzystywany jest cache (build #29).**

**Poniżej zawarty zostaje diagram UML wdrożenia aplikacji na kolejne laboratoria.**

![alt text](<Zdjecia/lab 5/Zrzut ekranu 2025-04-22 114956.png>)


# Lab 6 i 7
**Do działania z aplikacją tak jak wskazano na diagramie uml stworzono pliki Dockerfile do: testów, budowania oraz deploy'a, zgodnie z instrukcją na githubie aplikacji. Prezentują się one następująco:**

*Dockerfile.expresstest:*
```
FROM node AS express-build

RUN git clone https://github.com/expressjs/express.git /app

WORKDIR /app

RUN npm install

RUN npm test
```


**Dockerfile testujący klonuje nie opiera się na tym budującym ze względu na specyfikę testów tej aplikacji.**


*Dockerfile.expressbuild:*
```
FROM node AS express-build

RUN git clone https://github.com/expressjs/express

RUN npm install -g express-generator@4

RUN express /tmp/foo

WORKDIR /tmp/foo

RUN npm install
```

*Dockerfile.expresspublish:*
```
FROM node:18-slim

COPY --from=express-build /tmp/foo /app

WORKDIR /app

CMD ["npm", "start"]
```


**Następnie potrzebujemy wykorzystać te pliki w naszym pierwszej iteracji pipeline'a:**

```
pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'WS417336', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }
        
        stage('Cleaning') {
            steps {
                dir('ITE/GCL08/WS417336/Sprawozdanie2') {
                    sh 'docker rmi -f express-build'
                    sh 'docker rmi -f express-app'
                    sh 'docker builder prune --force --all'
                    sh 'docker network inspect ci >/dev/null 2>&1 && docker network rm ci || true'
                }
            }
        }
        
        stage('Build Dockerfile') {
            steps {
                dir('ITE/GCL08/WS417336/Sprawozdanie2') {
                    sh 'docker build -f Dockerfiles/Dockerfile.expressbuild -t express-build .'
                }
            }
        }
        
        stage('Publish Dockerfile') {
            steps {
                dir('ITE/GCL08/WS417336/Sprawozdanie2') {
                    sh 'docker build -f Dockerfiles/Dockerfile.expresspublish -t express-app .'
                }
            }
        }
        
        stage('Run app') {
            steps {
                dir('ITE/GCL08/WS417336/Sprawozdanie2') {
                    sh 'docker network create ci'
                    sh 'docker run --rm -d --network ci --name app -p 3000:3000 express-app'
                    sh 'docker run --rm --network ci fedora curl -s app:3000'
                }
            }
        }
    }
}

```

**Ten Jenkinsfile jest tak naprawdę bardziej rozbudowaną wersją poprzedniego. Dodatkowe stage służa do tego aby plik był bardziej przejrzysty. Oddzielono chociażby czysczenie oraz konkretne buildy.**

**Stage "run app" to ten najważniejszy w tym pliku, gdyż uruchamia on deployowaną aplikację oraz sprawdza jej działanie poprzez wykonanie curla na port 3000. Początkowo były problemy z tym jak tego curla wykonać gdyż nie było efektu, należało więc stworzyć kontener w fedorze na tej samej sieci co aplikacja i w nim wykonać komendę.**

![alt text](<Zdjecia/lab 6 i 7/Zrzut ekranu 2025-04-22 120456.png>)


**Działający curl z zwracający "Welcome to Express".**

**Kolejna (i finalna) iteracja Jenkinsfile'a dodała testy oraz publish na dockerhub.**

```
pipeline {
    agent any
    environment {
    DOCKER_IMAGE = 'zbogenza/express-app:latest'
    }   
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'WS417336', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }
        
        stage('Cleaning') {
            steps {
                dir('ITE/GCL08/WS417336/Sprawozdanie2') {
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
                dir('ITE/GCL08/WS417336/Sprawozdanie2') {
                    sh 'docker build --no-cache -f Dockerfiles/Dockerfile.expressbuild -t express-build .'
                }
            }
        }
        
        stage('Publish Dockerfile') {
            steps {
                dir('ITE/GCL08/WS417336/Sprawozdanie2') {
                    sh 'docker build --no-cache -f Dockerfiles/Dockerfile.expresspublish -t express-app .'
                }
            }
        }

        stage('Test Dockerfile') {
            steps {
                dir('ITE/GCL08/WS417336/Sprawozdanie2') {
                    sh 'docker build --no-cache -f Dockerfiles/Dockerfile.expresstest -t express-test .'
                    sh 'docker run --rm express-test'
                }
            }
        }
        
        stage('Run app') {
            steps {
                dir('ITE/GCL08/WS417336/Sprawozdanie2') {
                    sh 'docker network create ci'
                    sh 'docker run --rm -d --network ci --name app -p 3000:3000 express-app'
                    sh 'docker run --rm --network ci fedora curl -s app:3000'
                }
            }
        }

        stage('Docker Login and Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials2', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                    sh 'docker tag express-app $DOCKER_IMAGE'
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }
    }
}
```

**Dodano stage "test dockerfile" oraz "docker login and push" których nazwy tłunaczą ich zastosowanie. Dodano również zmienna globalną ```DOCKER_IMAGE``` dla przejrzystości.**

**Testowanie wykorzystuje wcześniej pokazany dockerfile, wycinek wyniku testowego wygląda następująco:**

![alt text](<Zdjecia/lab 6 i 7/Zrzut ekranu 2025-04-22 121112.png>)


**Aby można było się zalogować dodano do jenkinsa credentiale z danymi logowania do dockerhub'a.**

![alt text](<Zdjecia/lab 6 i 7/Zrzut ekranu 2025-04-22 121245.png>)


**W zakładce użytkownika wchodzę w "credentials". Stamtąd w "stores from parent" dodaje globalne credentiale (nie może to być storowane w danym użytkowniku - w taki sposób nie działało). Aby nie dodawać hasło wygenerowany został klucz dostępu na stronie dockerhub'a, który dodano jako hasło dostępu.**


![alt text](<Zdjecia/lab 6 i 7/Zrzut ekranu 2025-04-22 121506.png>)


**Tak dodane credentiale jenkinsfile wykorzystuje poprzez instrukcję ```withCredentials```**

**Taki jenkinsfile następnie skonfigurowano jako SCM**

![alt text](<Zdjecia/lab 6 i 7/Zrzut ekranu 2025-04-22 121719.png>)


**Tak skonfigurowany SCM kopiuje najpierw repo przemiotowe aby dostać się do jenkinsfile'a, który to później znowu kopiuje to repo aby dostać się do dockerfile'ów, co nie jest optymalne, ale działa.**


![alt text](<Zdjecia/lab 6 i 7/Zrzut ekranu 2025-04-22 122123.png>)


**Wypis finalnie działającego pipeline'a z pomyślnym zalogowaiem na dockerhub.**

![alt text](<Zdjecia/lab 6 i 7/Zrzut ekranu 2025-04-22 122506.png>)


**Publish dostępny na stronie dockerhub**

**Pipeline działa również wielokrotnie, bez cache'a (należało zmodyfikować lekko cleanowanie bo sieć sprawiała problemy).**