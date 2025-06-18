# Laboratorium 13 - Shift-left: GitHub Actions

## Abstrakt

Celem laboratorium było praktyczne zapoznanie się z platformą GitHub Actions oraz jej możliwościami w zakresie automatyzacji procesów CI/CD. W ramach ćwiczenia skonfigurowano workflow, wykorzystano różne triggery uruchamiania akcji, a także zintegrowano narzędzie do analizy statycznej kodu (ESLint). Dodatkowo, laboratorium obejmowało przygotowanie artefaktów wdrożeniowych oraz weryfikację poprawności działania procesu na przykładzie projektu `node-js-dummy-test`.

### Zapoznanie z platformą

**1) Triggery**

W GitHub Actions wyróżniamy następujące Triggery:
- `on push` - wykonywany po każdym commicie do konkretnej gałęzi,
- `pull_request` - wykonywany przy każdym Pull Request do konkretnej gałęzi,
- `workflow_dispatch` - wykonywany ręcznie na żądanie przez użytkownika z odpowiednimi uprawnieniami,
- `schedule` - wykonywanie w konkretnym czasie (datowo),
- `fork` - wykonywany przy forkowaniu repozytorium,
- itp. - [Pełna lista dostępnych triggerów](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows)

**2) Cennik**

GitHub Actions podobnie jak Azure jest płatną usługą, chociaż istnieje darmowy plan, który jest bardzo ograniczony względem możliwości jego wykorzystania.

![Zdjecie](./Zdjecia/1.png)

**3) Fork repozytorium `node-js-dummy-test`**

![Zdjecie](./Zdjecia/2.png)

![Zdjecie](./Zdjecia/3.png)

![Zdjecie](./Zdjecia/4.png)

**4) Sklonowanie repozytorium**

```bash
git clone git@github.com:WinterWollf/node-js-dummy-test.git
```

Powyższa komenda sklonuje sforkowane repozytorium, ponieważ zdecydowałem się na zklonowanie repozytorium przy pomocy uwieżytelnienia przez SSH, musiałem podać hasło do klucza SSH.

![Zdjecie](./Zdjecia/5.png)

**5) Utworzenie nowego brancha**

```bash 
cd node-js-dummy-test
git checkout -b ino_dev
git push -u origin ino_dev
```

Powyższe komendy tworzą nowego brancha o nazwie `ino_dev`. Ostatnia komenda wypycha zmiany do zdalnego repozytorium.

![Zdjecie](./Zdjecia/6.png)

**6) Usunięcie istniejących `workflows`**

Obecnie repozytorium zawiera 3 workflows. Zostały one usunięte, następnie zostało utworzone workflow o nazwie `build_and_test.yml`.

![Zdjecie](./Zdjecia/7.png)

![Zdjecie](./Zdjecia/8.png)

**7) Plik `workflow`**

```yaml
name: Build and Test

on:
  push:
    branches:
      - ino_dev
  pull_request:
    branches:
      - ino_dev
  workflow_dispatch:
    inputs:
      tags:
        description: 'Test tags'

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm install

      - name: Run tests
        run: npm test
```

Akcja o nazwie `Build and Test` będzie wykonywana zawsze przy:
- commitowaniu do repozytorium zdalnego na gałąź `ino_dev` -> sekcja `on push`,
- wykonywaniu pull requesta do gałęzi `ino_dev` -> sekcja `on pull_request`,
- po ręcznym wymuszeniu przez użytkownika (kliknięcie odpowiedniego przycisku) -> sekcja workflow_dispatch,

Sekcja `jobs` definiuje zadania do wykonania. W tym przypadku zadanie o nazwie `build`, które będzie uruchamiane na wirtualnej maszynie z systemem `ubuntu-latest`.
- pierwszy krok klonuje repozytorium do środowiska GitHub Actions -> `actions/checkout`,
- drugi krok ustawia środowisko uruchomieniowe Node.js w wersji `20` -> `setup-node`,
- trzeci krok instaluje zależności projektu z pliku `package.json`,
- czwarty krok uruchamia testy jednostkowe. 

![Zdjecie](./Zdjecia/9.png)

![Zdjecie](./Zdjecia/10.png)

![Zdjecie](./Zdjecia/11.png)

**8) Dodanie ESLint**

Zdecydowano się na dodanie narzędzia do analizy kodu ESLint. Sforkowany projekt nie wspierał natywnie narzędzia ESLint, aby dodać takie wsparcie należało zainstalować narzędzie ESLint oraz utworzyć jego konfigurację w katalgou `eslint.config.js`.

```bash
npm install --save-dev eslint@latest
```

Powyższa komenda instaluje narzędzie ESLint w najnowszej wersji. Dopisek `--save-dev` oznacza, że pakiet zostanie zainstalowany jako zależność deweloperska - nie jest ona wymagana w środowisku produkcyjnym. 

![Zdjecie](./Zdjecia/12.png)

```js
export default [
  {
    files: ['**/*.js', '**/*.ts', '**/*.jsx', '**/*.tsx'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
    },
    rules: {
      semi: ['error', 'always'],
      quotes: ['error', 'single'],
    },
  },
];
```

Powyższy plik przedstawia konfigurację ESLint, która definiuje reguły dla plików JavaScript i TypeScript, wymuszając użycie średników i pojedynczych cudzysłowów oraz ustawiając najnowszą wersję ECMAScript i typ źródła jako moduł.

Następnie dodano odpowiednią sekcję do pliku `build_and_test.yml`.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      ...

      - name: Run ESLint
        run: npx eslint . --ext .js,.jsx,.ts,.tsx
        
      - name: Run tests
        run: npm test
```

Dodanie powyższego fragmentu sprawi, że przed uruchomieniem testów, kod będzie analizowany przez narzędzie ESLint.

![Zdjecie](./Zdjecia/13.png)

![Zdjecie](./Zdjecia/14.png)

![Zdjecie](./Zdjecia/15.png)

![Zdjecie](./Zdjecia/16.png)

Akcja skończyła się niepowodzeniem, ponieważ narzędzie ESLint wykryło nieprawidłowości w analizowanym kodzie - były to błędy związane z użyciem podwójnego cudzysłowia zamiast pojedynczego. 

**9) Pull Request**

W momencie utworzenia `Pull Requesta` została uruchomiona `Akcja`, ponieważ tak jak wyżej zakończyła się ona niepowodzeniem, otrzymaliśmy o tym stosowny komunikat. Ustawienia repozytorium pozwalają na `Merge` takiego `Pull Requesta`, nawet w sytuacji, gdy akcja zakończyła się niepowodzeniem. 

![Zdjecie](./Zdjecia/17.png)

Zmieniono ustawienia repozytorium poprzez dodanie `Ruleset`, który wymusza poprawne przejście akcji, w celu dokonania merga.

![Zdjecie](./Zdjecia/18.png)

![Zdjecie](./Zdjecia/19.png)

W celu zaprezentowania poprawności działania, dodano do polecenia uruchamiania narzędzia ESLint flagę `--fix`, która w miarę możliwości jakie oferuje to narzędzie spróbuje "naprawić" kod.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      ...

      - name: Run ESLint
        run: npx eslint . --ext .js,.jsx,.ts,.tsx --fix
        
      - name: Run tests
        run: npm test
```

Zastosowanie falgi `--fix` "naprawiło" kod, co umożliwiło akcji pomyślne zakończenie. Spowodowało to możliwość mergowania 

![Zdjecie](./Zdjecia/19.png)

![Zdjecie](./Zdjecia/21.png)

**10) Artefakt - paczka ZIP**

Tak jak w przypadku Jenkinsa zdecydowano się na stworzenie artefaktu w postaci paczki ZIP. W pliku `build_and_test.yml` dodano odpowienie sekcje.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      ...

      - name: Run tests
        run: npm test

      - name: Create deployment package (.zip)
        run: |
          mkdir -p dist
          cp -r node_modules src views package.json dist/
          cd dist
          zip -r app-${{ github.run_number }}.zip ./*
        shell: bash

      - name: Upload deployment artifact
        uses: actions/upload-artifact@v4
        with:
          name: app-${{ github.run_number }}.zip
          path: dist/app-${{ github.run_number }}.zip
```

Po pomyślnym zakończeniu testów dodane zostały dwa kroki odpowiedzialne za utworzenie oraz opublikowanie artefaktu.

1. Pierwszy krok o nazwie `Create deployment package (.zip)` tworzy katalog `dist`, kopiuje do niego katalogi `node_modules`, `src`, `views` oraz plik `package.json` – czyli wszystko, co potrzebne do wdrożenia aplikacji. Wchodzi do katalogu `dist` i pakuje całość do pliku `.zip`, gdzie `github.run_number` to numer kolejnego uruchomienia workflow.

2. Drugi krok o nazwie `Upload deployment artifact` używa oficjalnej akcji `upload-artifact`, przesyła utworzony plik `.zip` jako artefakt do podglądu i pobrania bezpośrednio z interfejsu GitHub Actions.
