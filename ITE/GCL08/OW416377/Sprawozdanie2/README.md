# Sprawozdanie 2

Oliwia Wiatrowska


---


## **Laboratorium 05**

### **Pipeline, Jenkins, izolacja etapów**


---

## **1. Przygotowanie**

### 1.1 Utworzenie instancji Jenkins
Instancja Jenkins została utworzona w ramach poprzedniego laboratorium, stąd dokumentacja związana z instalacją Jenkinsa, przygotowaniem i uruchomieniem odpowiednich obrazów oraz logowaniem admina została przedstawiona w [!sprawozdaniu 1](../Sprawozdanie1/README.md).

#### Utworzenie użytkownika
W poprzednim laboratorium admin został nazwany moim imieniem i nazwiskiem, zostało to zmienione ponownie na `admin`. Po naciśnięciu ikony z dzwoneczkiem, przeszłam do zarządzania jenkinsem i tam wybrałam opcję `Create User` i zajęłam się tworzeniem nowego użytkownika `Oliwia Wiatrowska`.

![Create user](lab5ss/panel_tworzenia_uzytkownika.png)

Po utworzeniu widocznych jest dwóch użytkowników:
![Nowy uzytkownik](lab5ss/utworzenie_nowego_uzytkownika.png)

Następnie wylogowałam się z konta admina i zalogowałam na konto nowo utworzonego użytkownika.

## **2. Zadanie wstępne: uruchomienie**
W ramach wstępnej konfiguracji i pierwszego uruchomienia utworzyłam:

### 2.1 Projekt `Uname`
Aby utworzyć nowy projekt wybrałam opcję `+ Nowy projekt`, `Ogólny projekt`, a następnie w `Krokach budowania` `Dodaj krok budowania` wybrałam `Uruchom powłokę` i wpisałam:
```bash
uname -a
```
![Tworzenie uname](lab5ss/tworzenie_projektu_uname.png)

Ekran po utworzeniu projektu:
![alt title](lab5ss/ekran_po_utworzeniu_uname.png)

Następnie wybrałam opcję `Uruchom` i uruchomiłam projekt.
![Ekran po uruchomieniu](lab5ss/ekran_po_uruchomieniu_uname.png)

Po uruchomieniu projektu możliwe było przejście do logów danego uruchomienia projektu:
![Logi uname](lab5ss/logi_uname.png)

Ekran po przejściu do tablicy:
![alt title](lab5ss/ekran_po_przejsciu_do_tablicy.png)

### 2.2 Projekt zwracający błąd, gdy godzina jest nieparzysta
W sposób analogiczny utworzyłam projekt, który zwraca błąd, gdy godzina jest nieparzysta.

Tworzenie projektu `nieparzysta`:
```bash
hour=$(date +%H)

if [ $((hour % 2)) -ne 0 ]; then
  echo "Nieparzysta godzina: ($hour)"
  exit 1
else
  echo "Parzysta godzina ($hour) — kontynuuję"
fi
```
![Tresc nieparzysta](lab5ss/tresc_nieparzystagodzina.png) 

Projekt został kilkukrotnie uruchomiony:
![Ekran po uruchomieniu nieparzysta](lab5ss/ekran_po_uruchomieniu_nieparzysta.png)

Logi konsoli projektu nieparzysta:
![Logi nieparzysta](lab5ss/log_konsola_nieparzysta_godzina.png)

Błąd był oczekiwany.

### 2.3 Projekt, w którym pobrany zostanie obraz kontenera ubuntu
Również wykonując te same kroki, co przy tworzeniu projektu `Uname`, utworzyłam projekt `Ubuntu`, w którym pobrany został obraz kontenera ubuntu.

Treść wpisana w `Uruchom powłokę`:
```bash
docker pull ubuntu
```
![Tworzenie obrazu ubuntu](lab5ss/tworzenie_obrazu_ubuntu.png)

Logi konsoli projektu `Ubuntu`:
![Logi ubuntu](lab5ss/logi_ubuntu.png)

## **3. Zadanie wstępne: obiekt typu pipeline**
### 3.1 Tworzenie pipeline
Tworzenie pipeline jest bardzo podobne do tworzenia wcześniejszych projektów, z taką różnicą, że po naciśnięciu opcji `+ Nowy projekt`, wybieramy `Pipeline`. Swój pipeline nazwałam `RepoPrzedmiotowe`.

![Tworzenie RepoPrzedmiotowe](lab5ss/tworzenie_pipeline_RepoPrzedmiotowe.png)

Następnie korzystając z dokumentacji uzupełniłam w odpowiedni sposób skrypt pipelinu, pamiętając o tym, aby zrobić checkout na swoją gałąź `OW416377`. W stage'u `Clone repository` sklonowałam także repozytorium przedmiotowe. 
W kolejnym stage'u `Build` podałam ścieżkę do katalogu, w którym znajduje się plik [Dockerfile.build](../Sprawozdanie1/lab3_pliki/Dockerfile.build), budujący wybrany na wcześniejszych laboratoriach program. 

```bash
pipeline {
    agent any

    stages {
        stage('Clone repository') {
            steps {
                git branch: 'OW416377', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }
        stage('Build'){
            steps {
                dir('ITE/GCL08/OW416377/Sprawozdanie1/lab3_pliki') {
                    sh 'docker build -t bld -f Dockerfile.build .'
                }
            }
        }
    }
}
```

![Pipeline tresc](lab5ss/pipeline_tresc.png)

### 3.2 Pierwsze uruchomienie pipeline
Następnie uruchomiłam pipeline, aby zbudować Dockerfile:
![Pierwsze uruchomienie pipeline](lab5ss/pierwsze_uruchomienie_pipeline.png)
Uruchomienie trwało ponad 2 minuty.

Logi z konsoli po pierwszym uruchomieniu:
![alt text](lab5ss/screen_z_konsoli_pierwszy_pipeline.png)

### 3.3 Ponowne uruchomienie pipeline
Ponownie uruchomiłam pipline, aby zbudować Dockerfile:
![Drugie uruchomienie pipeline](lab5ss/uruchomienie_drugi_raz_pipeline_krótki_czas_zaznaczenie.png)
Jak widać na załączonym screenie, uruchamianie trwało tylko 4.8 sekundy. Pomimo pozornego poprawnego uruchomienia, tak krótki czas świadczy o tym, że coś jest nietak.

Wobec tego postanowiłam dodać cleanup do pipeline'u, najpierw usuwam potencjalnie istniejący obraz buildera, potem czyszczę build cache, a dopiero na końcu wykonuję build z pliku [Dockerfile.build](../Sprawozdanie1/lab3_pliki/Dockerfile.build). 

```bash
pipeline {
    agent any

    stages {
        stage('Clone repository') {
            steps {
                git branch: 'OW416377', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }
        stage('Build'){
            steps {
                dir('ITE/GCL08/OW416377/Sprawozdanie1/lab3_pliki') {
                    sh 'docker rmi -f bld'
                    sh 'docker builder prune --force --all'
                    sh 'docker build -t bld -f Dockerfile.build .'
                }
            }
        }
    }
}
```
![Zmodyfikowany pipeline](lab5ss/zmodyfikowany_pipeline.png)

Ponownie uruchamiam pipeline:
![Trzecie uruchomienie pipeline](lab5ss/trzecie_uruchomienie_po_zmianie_pipline.png)
Jak widać uruchomienie trwało ponad minutę, co świadczy o tym, że po dodaniu cleanup'u czas builda wrócił do oczekiwanego, potwierdza to, to że wcześniejszy wynik był wynikiem błędnego użycia cache Dockera.