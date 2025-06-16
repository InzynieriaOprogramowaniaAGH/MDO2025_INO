Sprawozdanie 4
----------------
GitHub Actions
----------------

Link do repozytorium z akcjami:
https://github.com/JanekRzodki/node-js-dummy-test/actions

Celem zadania było:
* zapoznanie się z koncepcją GitHub Actions,
* stworzenie własnego pipeline’u do budowania i testowania aplikacji w reakcji na zmiany w gałęzi ino_dev,
* nie modyfikowanie głównego repozytorium uczelni,
* zweryfikowanie działania pipeline’u i załączenie artefaktu (logów).

2. Wykonane kroki
------------------------------

2.1 Forkowanie repozytorium
Sforkowałem repozytorium aplikacji node-js-dummy-test do własnego konta GitHub.

![image](https://github.com/user-attachments/assets/e8de4b00-dece-439d-ab78-285540312006)

Utworzyłem w swoim fork repozytorium gałąź ino_dev, odpowiadającą gałęzi z oryginalnego repo.

![image](https://github.com/user-attachments/assets/8aa098c7-7c22-456b-8959-eccc51e081a5)

2.2 Usunięcie istniejących workflows
Sprawdziłem, czy w projekcie są jakieś istniejące workflow GitHub Actions — usunąłem je.

2.3 Utworzenie własnego workflow
W katalogu .github/workflows dodałem plik build.yml z definicją akcji.

```bash
name: Build and Test Node App

on:
  push:
    branches:
      - ino_dev

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout this repo (not strictly needed)
        uses: actions/checkout@v3

      - name: 🧹 Czyszczenie workspace
        run: |
          rm -rf app LAB_5 temp

      - name: 📥 Klonowanie aplikacji
        run: |
          git clone https://github.com/devenes/node-js-dummy-test app

      - name: 📥 Klonowanie LAB_5 (dockerfiles)
        run: |
          git clone --depth 1 --branch JR414945 https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git temp
          cp -r temp/JR414945/LAB_5 ./LAB_5
          rm -rf temp

      - name: 🔨 Budowanie obrazu aplikacji
        run: |
          docker build -t nodeapp_builder -f LAB_5/Dockerfile.build ./app

      - name: 🧪 Budowanie i uruchamianie testów
        run: |
          docker build -t nodeapp_tester -f LAB_5/Dockerfile.test ./app
          docker run --rm nodeapp_tester
  
      - name: Save logs from docker container
        run: |
          mkdir -p logs
          docker logs $(docker ps -a -q --filter ancestor=nodeapp_tester --format="{{.ID}}") > logs/test.log || true

      - name: Upload test log as artifact
        uses: actions/upload-artifact@v4
        with:
          name: test-logs
          path: logs/test.log

      - name: 🧹 Sprzątanie kontenerów i obrazów
        if: always()
        run: |
          docker rm -f nodeapp_test_helper || true
          docker rm -f nodeapp || true
          docker rmi -f nodeapp_builder || true
          docker rmi -f nodeapp_tester || true
          docker network rm pipeline_network || true
```

Workflow uruchamia się na push do gałęzi ino_dev.

Definicja zawiera etapy:

Collect — czyszczenie workspace, klonowanie repozytorium i plików pomocniczych,

Build — budowanie obrazu Docker z aplikacją,

Test — budowanie obrazu testowego i uruchomienie testów w kontenerze.

2.4 Dodanie artefaktu z logami
Po testach zapisałem logi kontenera testowego do pliku.

Załączyłem ten plik jako artefakt za pomocą akcji actions/upload-artifact@v4.

Dzięki temu logi są dostępne do pobrania w zakładce Actions.

2.5 Weryfikacja działania
Po każdym pushu do gałęzi ino_dev workflow uruchamia się automatycznie.
Wszystkie etapy kończą się sukcesem (zielony znacznik).
Artefakty z logami są dostępne i potwierdzają przebieg testów.

![image](https://github.com/user-attachments/assets/77a2b26e-2ea1-4062-ae49-a5bfbdbf0d36)
