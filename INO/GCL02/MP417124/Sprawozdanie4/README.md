# Sprawozdanie (Zadanie 13)

## Wprowadzenie

Celem zadania było utworzenie własnej GitHub Action, która automatycznie buduje dowolną bibliotekę i tworzy pakiet RPM w odpowiedzi na zmiany w 
dedykowanej gałęzi `ino_dev`. W tym celu wykorzystano GitHub Actions oraz obraz kontenera `fedora:41`. 
## Zadanie 13: _Shift-left_: GitHub Actions

1. **Zapoznanie się z dokumentacją GitHub Actions:**

Zadanie rozpoczełam od zapoznania się z koncpecją GitHub Actions na stronie 
serwisu: `https://docs.github.com/en/actions`. Po potwierdzeniu, że darmowy plan w zupełności wystarczy, przeszłam do realizacji ćwiczenia.

2. **Forkowanie repozytorium:**

Zdecydowałam się na bibliotekę `cJSON`, którą sforkowałam z oficjalnego repozytorium dostępnego pod adresem: `https://github.com/DaveGamble/cJSON`. 
Pracowałam na nim we własnym repozytorium, nie naruszając głównej gałęzi `master`.

3.	**Usunięcie istniejących workflowów:**
   
W repozytorium znajdował się domyślny workflow oparty o Makefile. Usunęłam go i zastąpiłam własnym plikiem `.yml`. 
Aby spełnić wymagania zadania, utworzyłam osobną gałąź o nazwie `ino_dev`, w której zdefiniowałam plik workflowa odpowiedzialny 
za proces budowania projektu oraz tworzenia pakietu RPM.


5.	**Stworzenie nowego workflowu:**

Napisałam nowy workflow, który:
	- uruchamia się automatycznie po pushu, pull requestcie lub ręcznie (workflow_dispatch) na gałęzi `ino_dev`,
	- używa kontenera `fedora:41`, aby umożliwić tworzenie paczek `.rpm`,
	- instaluje wszystkie niezbędne zależności (`cmake`, `gcc`, `ruby`, `fpm`, itd.),
	- pobiera kod źródłowy biblioteki `cJSON` z GitHuba,
	- buduje projekt przy pomocy `cmake` i `make`,
	- tworzy pakiet `.rpm` przy użyciu `fpm,`
	- dołącza pakiet jako artefakt GitHub Actions, aby można go było pobrać po zakończeniu działania workflowu.

Kod wyglądał następująco:

```
name: Makefile CI

on:
  push:
    branches: [ "ino_dev" ]
  pull_request:
    branches: [ "ino_dev" ]
  workflow_dispatch:
    inputs:
      tags:
        description: "opis"
  

jobs:
  build:
    runs-on: ubuntu-latest

    container:
      image: fedora:41

    steps:
      - name: Install dependencies
        run: |
          dnf install -y git cmake gcc gcc-c++ make ruby ruby-devel rpm-build rubygems
          gem install --no-document fpm

      - name: Checkout cJSON
        run: |
          git clone https://github.com/DaveGamble/cJSON.git /app

      - name: Build cJSON
        working-directory: /app
        run: |
          mkdir build && cd build
          cmake ..
          make
          make DESTDIR=/tmp/install install

      - name: Create RPM with fpm
        working-directory: /app
        run: |
          fpm -s dir -t rpm \
            -n mycjson \
            -v 1.7.15 \
            -C /tmp/install \
            -p /app/mycjson.rpm

      - name: Upload RPM artifact
        uses: actions/upload-artifact@v4
        with:
          name: mycjson-rpm
          path: /app/mycjson.rpm
```
Zrzut ekranu poprawnie wykonanej akcji:
![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie4/Screenshots/Screenshot%202025-05-13%20at%201.35.10%E2%80%AFPM.png)
