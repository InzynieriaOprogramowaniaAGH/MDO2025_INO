
## Lab 13 – GitHub Actions: Automatyzacja procesu build i testów

### Cel:
Celem ćwiczenia było stworzenie workflow GitHub Actions.

### 1. Przygotowanie pliku workflow

Pierwszym krokiem było przygotowanie pliku workflow *.github/workflows/build_ino_dev.yml*. W pliku tym skonfigurowano akcje, które uruchamiają procesy budowania i testowania aplikacji po każdym pushu lub pull requeście do gałęzi *ino_dev*.

```
name: Build and Test Express.js on ino_dev (Node.js 20)

on:
  push:
    branches:
      - ino_dev
  pull_request:
    branches:
      - ino_dev

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js 20
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm install

      - name: Run tests
        run: npm test

      - name: Upload test results (if any)
        if: success()
        uses: actions/upload-artifact@v4
        with:
          name: test-results
          path: test/
```

### 2. Opis działania workflow

Workflow jest uruchamiany na dwóch zdarzeniach:
- *push* do gałęzi *ino_dev*
- *pull_request* do gałęzi *ino_dev*

Workflow wykonuje następujące kroki:
1. **Checkout code** – pobranie kodu źródłowego z repozytorium.
2. **Setup Node.js 20** – instalacja wersji Node.js 20.
3. **Install dependencies** – instalacja zależności przy użyciu *npm install*.
4. **Run tests** – uruchomienie testów jednostkowych aplikacji za pomocą *npm test*.
5. **Upload test results** – w przypadku sukcesu, wyniki testów są przesyłane jako artefakty do GitHub.


### 3. Wyniki działania

Zgodnie z konfiguracją, workflow zakończyło się sukcesem po zacommitowaniu zmiany do gałęzi *ino_dev*, a proces buildowania i testowania aplikacji przebiegł pomyślnie.

![alt text](<Zrzut ekranu 2025-06-10 112656.png>)

### Podsumowanie

W ramach ćwiczenia stworzono workflow GitHub Actions, który automatycznie wykonuje proces budowania, instalacji zależności oraz testowania aplikacji Express.js po każdym pushu do gałęzi *ino_dev*. Dzięki temu, workflow zapewnia automatyczną weryfikację poprawności aplikacji bez potrzeby ręcznego uruchamiania testów.
