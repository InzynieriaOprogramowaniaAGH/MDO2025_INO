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



## Lab 6 - 

### Cel: