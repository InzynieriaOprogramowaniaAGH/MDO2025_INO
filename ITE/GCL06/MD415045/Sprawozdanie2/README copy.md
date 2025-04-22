# Sprawozdanie 2 
### Miłosz Dębowski [MD415045]

# Zajęcia 1 - Pipeline, Jenkins, izolacja etapów

### Utworzenie instancji Jenkinsa

1. **Zapewnienie działania kontenerów budujących i testujących**  
   Upewnij się, że kontenery z poprzednich zajęć są gotowe do użycia i działają poprawnie.

2. **Instalacja Jenkinsa**  
   Zapoznaj się z [instrukcją instalacji Jenkinsa](https://www.jenkins.io/doc/book/installing/docker/).  
   Uruchom obraz Dockera, który eksponuje środowisko zagnieżdżone.

3. **Przygotowanie obrazu BlueOcean**  
   - Stwórz obraz BlueOcean na podstawie obrazu Jenkinsa.  
   - Zbadaj różnice między obrazem podstawowym Jenkinsa a BlueOcean.

4. **Uruchomienie BlueOcean**  
   - Uruchom obraz BlueOcean.  
   - Zaloguj się i skonfiguruj Jenkins.

5. **Archiwizacja i zabezpieczenie logów**  
   - Skonfiguruj system do przechowywania i zabezpieczania logów w celu późniejszej analizy.


### Projekty wstępne

1. **Utworzenie projektu wyświetlającego `uname`**  
   Stworzenie projektu, który wyświetla wynik polecenia `uname`.
   ```groovy
    uname -a
   ```
   ![](./Zrzut%20ekranu%202025-04-22%20161622.png)
   ![](./Zrzut%20ekranu%202025-04-22%20161607.png)

2. **Utworzenie projektu testowego**  
   Stworzenie projektu, który zwraca błąd, gdy godzina jest nieparzysta.
   ```groovy
    #!/bin/bash
    hour=$(date +"%H")
    if [ $((hour % 2)) -ne 0]; then
    echo "FAILURE: The hour is odd."
    exit 1
    fi
    echo "SUCCESS: The hour is even."
   ```
   ![](./Zrzut%20ekranu%202025-04-22%20161853.png)
   ![](./Zrzut%20ekranu%202025-04-22%20161915.png)

3. **Pobranie obrazu kontenera Ubuntu**  
   Utworzenie projektu, który skonfiguruje `docker pull` do pobrania obrazu Ubuntu.
   ```groovy
    docker pull ubuntu
   ```
   ![](./Zrzut%20ekranu%202025-04-22%20162200.png)
   ![](./Zrzut%20ekranu%202025-04-22%20162223.png) 

4. **Obiekt pipeline w Jenkinsie**

Plik [node-build.Dockerfile](node-build.Dockerfile)

```dockerfile
FROM node:23-alpine

RUN apk add --no-cache git
RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test

RUN npm install
```
```groovy
pipeline {
    agent any

    environment {
        IMAGE_NAME = 'obraz'
    }

    stages {
        stage('Klonowanie repozytorium') {
            steps {
                git branch: 'MD415045', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Budowanie obrazu Docker') {
            steps {
                script {
                    sh "docker build -t $IMAGE_NAME -f ./ITE/GCL06/MD415045/lab5/node-build.Dockerfile ."
                }
            }
        }
    }
}
```
![](./Zrzut%20ekranu%202025-04-22%20203831.png)
![](./Zrzut%20ekranu%202025-04-22%20203813.png)

### Pipeline z wybraną aplikacją


```dockerfile
```

```dockerfile
```

```dockerfile
```





