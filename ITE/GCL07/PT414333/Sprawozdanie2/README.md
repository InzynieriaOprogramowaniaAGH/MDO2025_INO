# Class 4
## Pipeline, Jenkins

## 1. Tworzenie instancji Jenkinsa

[Zostało udokumentowane na popzrednich zajęciach](../Sprawozdanie1/README.md#3-jenkins-setup)

## 2. Zadanie do wykonania na ćwiczeniach

### 1. Utworzenie projektu wyświetlającego `uname`

1. Tworzymy nowy projekt

![alt text](class5/1.png)

2. Nadajemy mu nazwe i wybieramy tryb `Projekt Ogólny`

![alt text](class5/1.1.png)

3. W sekcji `Enviroment`> `Kroki budowania` dodajemy krok `Uruchom powłokę` i jako komendę wpisujemy polecenie i zapisujemy:

```sh
#!/bin/bash

uname -a

docker ps
```

![alt text](class5/2.png)

4. Uruchom utworzony projekt

![alt text](class5/3.png)

5. Otwórz artefakty uruchomienia

![alt text](class5/4.png)

6. Otwórz logi

![alt text](class5/5.png)

Polecenie zwarca ten sam `uname` co host.
![alt text](class5/6.png)


### 2. Utworzenie projektu zwracającego błąd, gdy godzina jest nieparzysta


1. Tworzymy nowy projekt (powtarzamy kroki 1. i 2. z [poprzedniego punkut](#1-utworzenie-projektu-wyświetlającego-uname))
2. W sekcji `Enviroment`> `Kroki budowania` dodajemy krok `Uruchom powłokę` i jako komendę wpisujemy poniższe polecenie i zapisujemy:

```sh
#!/bin/bash

current_hour=$(date +%H)
if (( current_hour % 2 != 0 )); then
  echo "Godzina jest nieparzysta. Błąd!"
  exit 1
else
  echo "Godzina jest parzysta. Sukces!"
  exit 0
fi
```

![alt text](class5/7.png)


3. Uruchom projekt

![alt text](class5/3.png)

4. Otwórz artefakty uruchomienia

![alt text](class5/4.png)

5. Otwórz logi

![alt text](class5/5.png)

![alt text](class5/8.png)


### 3. Pobierz w projekcie obraz kontenera

Otwórz [pierwszy projekt](#1-utworzenie-projektu-wyświetlającego-uname)

1. Wchodzimy w konfiguracje projektu

![alt text](class5/9.png)

2. W sekcji `Enviroment`> `Kroki budowania` modyfikujemy krok `Uruchom powłokę` i jako komendę wpisujemy poniższe polecenie i zapisujemy

```sh
#!/bin/bash

uname -a

docker ps

docker pull ubuntu
```

3. Uruchom projekt

![alt text](class5/3.png)

4. Otwórz artefakty uruchomienia

![alt text](class5/10.png)

5. Otwórz logi

![alt text](class5/5.png)

Na początku można zauważyć, że nie posiadamy żadnych obrazów kontenerów, co pokazuje nam, iż jest to osobna instajca docker'a od hosta.

Pobranie obrazu powiodło się.

![alt text](class5/11.png)

## 3. Tworzenie Pipeline

1. Utwórz nowy projekt

![alt text](class5/1.png)

2. Nadajemy mu nazwe i wybieramy tryb `Pipeline`

![alt text](class5/12.png)

3. W sekcji `Pipeline` jako `Pipeline script` wpisujemy:

```groovy
pipeline {
    agent any

    stages {
        stage('Clean') {
            steps {
                cleanWs()
                sh 'docker image rm -f irssi-build irssi-test'
                sh 'docker builder prune -a -f'
            }
        }
        
        stage('Git clone') {
            steps {
                git url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git', branch: 'PT414333'
            }
        }
        
        stage('Build build image') {
            steps {
                dir('ITE/GCL07/PT414333/Sprawozdanie1/class3') {
                    sh 'docker build -f Dockerfile.irssi_b -t irssi-build .'
                }
            }
        }
        
        stage('Build test image') {
            steps {
                dir('ITE/GCL07/PT414333/Sprawozdanie1/class3') {
                    sh 'docker build -f Dockerfile.irssi_t -t irssi-test .'
                }
            }
        }
    }
}
```
![alt text](class5/13.png)


4. Uruchom projekt

![alt text](class5/3.png)

5. Otwórz artefakty uruchomienia

![alt text](class5/4.png)

6. Otwórz logi

![alt text](class5/5.png)

Pipeline poprawnie wyczyścił sobie środwisko, poczym sklonował repozydorium i zbudował 2 obrazy.

Proces może być powtarzany wielokrotnie, bez żadnych dodatkowych akcji.

![alt text](class5/14.png)