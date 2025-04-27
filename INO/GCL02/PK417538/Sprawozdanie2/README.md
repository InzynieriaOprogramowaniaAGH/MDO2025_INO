# Sprawozdanie 2
## Pipeline, Jenkins, izolacja etapów

### Przygotowanie

**Utwórz instancję Jenkins:**

Plik docker-compose.yml tworzy kontener z Jenkins LTS, udostępnia jego porty 8080 i 50000, zapisuje dane w trwałym volume jenkins_home, umożliwia dostęp do Dockera hosta i zapewnia automatyczne uruchamianie kontenera po restarcie systemu.

```
version: '3.8'
services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins-upgraded
    user: root
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped

volumes:
  jenkins_home:
```
```
docker compose up -d
```

---

### Zadanie wstępne: uruchomienie

**Zadanie do wykonania na ćwiczeniach:**

- Konfiguracja wstępna i pierwsze uruchomienie:
  - Utwórz projekt, który wyświetla `uname`.
 
    ```
    uname -a
    ```
    ![obraz](https://github.com/user-attachments/assets/09d43d30-0dfa-4bd7-9ec0-768fd2412fa9)


  - Utwórz projekt, który zwraca błąd, gdy godzina jest nieparzysta.
    
    ```
    HOUR=$(date +%H)
    if [ $((HOUR % 2)) -ne 0 ]; then
      echo "Błąd: Godzina jest nieparzysta ($HOUR)"
      exit 1
    else
      echo "Godzina jest parzysta ($HOUR), budowanie OK."
    fi
    ```
    ![obraz](https://github.com/user-attachments/assets/8bb3a922-2ce4-48f2-8c14-0b6fe90d18b7)

    
  - Pobierz w projekcie obraz kontenera Ubuntu (stosując `docker pull`).
    
    ```
    docker pull ubuntu:latest
    ```
    ![obraz](https://github.com/user-attachments/assets/d1e8fe36-919d-486c-b669-7e37a220f185)


---

### Zadanie wstępne: obiekt typu pipeline

**Ciąg dalszy sprawozdania — zadanie do wykonania po wykazaniu działania Jenkinsa:**

Utworzono nowy obiekt typu pipeline w Jenkinsie. Repozytorium MDO2025_INO zostało sklonowane z gałęzi PK417538. Następnie zbudowano obraz Dockera z pliku Dockerfile znajdującego się w katalogu INO/GCL02/PK417538/Sprawozdanie2, a następnie uruchomiono kontener na jego podstawie. Pipeline został wykonany ponownie w celu weryfikacji poprawności.

```
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'PK417538', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }
        stage('Build Dockerfile') {
            steps {
                sh 'docker build -t my-builder ./INO/GCL02/PK417538/Sprawozdanie2'
            }
        }
        stage('Run Container') {
            steps {
                sh 'docker run --rm my-builder'
            }
        }
    }
}
```

![obraz](https://github.com/user-attachments/assets/252a39dc-c3fd-425f-bfeb-6105c994fd18)
