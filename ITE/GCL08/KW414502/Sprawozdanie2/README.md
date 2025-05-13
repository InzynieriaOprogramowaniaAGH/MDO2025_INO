# Kamil Wielgomas DevOps Sprawozdanie 2
## Lab5, 6 i 7.

### 1. Zadania wstępne

### Wyswietl uname
Na początku stworzyłem nowy projekt ogólny o nazwie uname.
![alt text](lab5/1.png)
W zakładce Kroki budowania dodałem krok "Uruchom powłokę", do której wpisałem
```sh
#!/bin/bash

uname -a
```
Po zapisaniu konfiguracji uruchomiłem projekt i sprawdziłem logi konsoli w celu weryfikacji poprawności działania.
![alt text](lab5/2.png)

### Wyświetl błąd, gdy godzina jest nieparzysta
Tak jak w poprzednim kroku stworzony został projekt ogólny o nazwie oddHourCrash
W kroku "Uruchom powłokę" został wpisany następujący skrypt:
```bash
#!/bin/bash

hour=$(date +%-H)

if (( hour % 2 != 0 )); then
    echo "Błąd: godzina $hour jest nieparzysta"
    exit 1
else
    echo "Godzina $hour jest parzysta"
    exit 0
fi
```
W celu weryfikacji projekt uruchomiłem o godzinie nieparzystej:
![alt text](lab5/3.png)
Oraz o godzinie parzystej:
# PLACEHOLDER

### Pobierz kontener ubuntu
Projekt został stworzony tak jak poprzednie dwa, jednak tym razem w kroku "Uruchom powłokę" znajduje się:
```sh
#!/bin/bash

uname -a
docker images
docker pull ubuntu
docker images
```
W celu weryfikacji sprawdziłem logi konsoli:
![alt text](lab5/4.png)

## Pipeline
Stworzyłem nowy projekt typu pipeline o nazwie irssiDocker
![alt text](lab5/5.png)
W zakładce pipeline znajduje się poniższy skrypt:
```Dockerfile
pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'KW414502', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }
        stage('Clean Docker and Build Irssi'){
            steps{
                dir('ITE/GCL08/KW414502/Sprawozdanie1/lab3'){
                    sh 'docker system prune -af && docker image prune -af && docker system prune -af --volumes && docker system df'
                    sh 'docker build -t irssibld -f ./Dockerfile.irssibld .'
            } 
            }

        }
    }
}

```
Stworzony zgodnie z dokumentacją jenkins: https://www.jenkins.io/doc/book/pipeline/
Pipeline klonuje repozytorium, a następnie czyści dockera i buduje obraz irssi korzystając z dockerfile'a stworzonego podczas wcześniejszych laboratoriów.

W celu weryfikacji pipeline należy uruchomić wielokrotnie, żeby się upewnić, że poprzednie uruchomienia nie wpływają na obecne.

### Uruchomienie 1
![alt text](lab5/6.png)
### Uruchomienie 2
![alt text](lab5/7.png)
![alt text](lab5/8.png)
![alt text](lab5/9.png)

Jak można zauważyć, pierwsze uruchomienie nie wpłynęło na drugie, więc skrypt został napisany poprawnie.



