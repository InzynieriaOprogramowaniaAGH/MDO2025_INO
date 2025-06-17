# Sprawozdanie 4
## Laboratorium 13 - Shift-left: GitHub Actions

Na podstawie PEGA SKILLS DAYS [DevOps in Action: A Hands-On Guide to Building a Modern SDLC](https://github.com/Bootcamp2025-Pega/instructions)
[Moje repozytorium](https://github.com/tygrysiatkomale/bootcamp-blog-tygrysiatkomale)

### 1. Fork repozytorium projektu
![](/ITE/GCL07/JS415943/Sprawozdanie4/Lab13/1.1-fork.png)

### 2. Konfiguracja GitHub Actions 

Cały plik `.github/workflows/ci-cd.yaml`

```yaml
name: CI/CD Pipeline

on:
  push:
    tags:
      - '*'
    branches:
      - main
  pull_request:
    branches:
      - main

env:
  NODE_VERSION: '18.x'

jobs:
  build-and-test:
    name: Build & Test
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Node.js ${{ env.NODE_VERSION }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ env.NODE_VERSION }}
        cache: 'npm'

    - name: Install Dependencies
      run: |
        npm ci

    - name: Build
      run: |
        DISABLE_DB_CONNECTION=true npm run build

    - name: Run tests with coverage
      run: npx jest
```
Pipeline uruchamia się przy:
- przy wypchnięciu zmian do gałęzi `main`,

- przy pull requestach do `main`,

- oraz przy publikacji nowego taga (np. `v1.0.0`).

A następnie:

- pobiera kod,

- instaluje zależności (npm ci),

- buduje projekt (z wyłączonym połączeniem z bazą danych, by uprościć środowisko CI),

- uruchamia testy jednostkowe wraz z generowaniem raportu pokrycia kodu (jest).

### Konfiguracja Ruleset (branch protection)

![](/ITE/GCL07/JS415943/Sprawozdanie4/Lab13/3.0-ruleset.png)

![](/ITE/GCL07/JS415943/Sprawozdanie4/Lab13/3.1-ruleset.png)

Dzięki temu merge do `main` jest możliwy tylko po przejściu całej akcji CI/CD

### Sekrety

![](/ITE/GCL07/JS415943/Sprawozdanie4/Lab13/4.0-secrets.png)

- `SONAR_TOKEN`	- uwierzytelnienie skanów SonarCloud
- `VERCEL_ORG_ID` - identyfikator organizacji w Vercel
- `VERCEL_PROJECT_ID` - identyfikator projektu w Vercel
- `VERCEL_TOKEN` - token API do automatycznego deployu


### Dependabot

![](/ITE/GCL07/JS415943/Sprawozdanie4/Lab13/5.0-dependabot.png)

Dependabot automatycznie otwiera PR-y z podbiciem zależności.

### CodeQL

![](/ITE/GCL07/JS415943/Sprawozdanie4/Lab13/6.0-codeql.png)

Skanowanie kodu co tydzień oraz przy każdym PR

Wprowadzenie celowej podatności (fragment fetch(url) bez walidacji) wykryło błąd typu svace/tainted-input. PR został odrzucony, co potwierdza poprawne działanie SAST.

