# Sprawozdanie 2  
**Autor:** Wojciech Matys  
**Temat:** Pipeline, Jenkins, izolacja etapów  

---

## Etap 1: Przygotowanie środowiska

### Uruchomienie kontenerów testujących

W pierwszym kroku upewniłem się, że kontenery budujące i testujące działają poprawnie. W tym celu wykorzystałem obraz Dockera z plikiem `Dockerfile.volume`, który tworzy środowisko do testowania biblioteki `cJSON`.

- Komenda `docker build -t test-cjson -f Dockerfile.volume .` pozwoliła mi zbudować obraz.  
- Następnie uruchomiłem kontener za pomocą `docker run --rm test-cjson`, który poprawnie wyświetlił wersję biblioteki i dane testowe.

**Zrzut ekranu:**

![1 1](https://github.com/user-attachments/assets/0606b2fa-a056-40c9-9e78-4006998555bb)

---

### Instalacja i konfiguracja Jenkinsa

Po przetestowaniu środowiska przeszedłem do instalacji Jenkinsa zgodnie z dokumentacją: [https://www.jenkins.io/doc/book/installing/docker/](https://www.jenkins.io/doc/book/installing/docker/)

- Uruchomiłem kontener `jenkinsci/blueocean` z odpowiednimi wolumenami:
  - `jenkins_home` dla zachowania danych konfiguracyjnych,
  - `/var/run/docker.sock`, by Jenkins miał dostęp do Dockera.
- Podczas pierwszego uruchomienia kontener pobrał wymagany obraz z Docker Hub.

**Zrzuty ekranu:**

![1 2](https://github.com/user-attachments/assets/7421675f-a439-4921-9866-d322796bd179)

![1 3](https://github.com/user-attachments/assets/dab1d812-bc12-4680-a7d7-7534f07dec28)

---

### Przygotowanie własnego obrazu Jenkinsa

Dodatkowo przygotowałem własny obraz na podstawie `jenkins/jenkins:lts`, rozszerzony o potrzebne narzędzia i wtyczki do obsługi pipeline’ów i Dockera.

- W pliku `Dockerfile.myjenkins-blueocean` dodałem:
  - instalację `docker-ce-cli`,
  - dodanie repozytorium Dockera,
  - instalację wtyczek `blueocean` i `docker-workflow` poprzez `jenkins-plugin-cli`.

Obraz zbudowałem komendą:  
`docker build -t myjenkins-blueocean:2.492.3-1 -f Dockerfile.myjenkins-blueocean .`

**Zrzuty ekranu:**

![1 4](https://github.com/user-attachments/assets/6e390605-d052-4271-a1ff-d692df610aca)

![1 5](https://github.com/user-attachments/assets/3435e20d-8bcf-4c6a-b5b9-9a022bc44dce)


---

### Uruchomienie kontenera Jenkins z własnym obrazem

Po zbudowaniu własnego obrazu uruchomiłem kontener z bardziej rozbudowaną konfiguracją:

- Porty 8080 i 50000 wystawione na hosta,
- Dane Jenkinsa zapisują się w wolumenie `jenkins-data`,
- Włączony dostęp do Dockera poprzez zmienne środowiskowe i zamontowane certyfikaty.

**Zrzut ekranu:**

![1 6](https://github.com/user-attachments/assets/fee17229-1348-4b03-b099-1836cf1e0aa3)


---

### Pierwsze uruchomienie i konfiguracja Jenkinsa

Po odpaleniu kontenera Jenkins poprosił o wpisanie hasła z pliku `secrets/initialAdminPassword`, co umożliwiło odblokowanie dostępu administratora. Następnie wybrałem opcję instalacji sugerowanych wtyczek.

**Zrzuty ekranu:**

![1 7](https://github.com/user-attachments/assets/69c9bed2-7913-47db-ba72-6f66794541e9)

![1 8](https://github.com/user-attachments/assets/df919659-1668-4e84-984c-00f7c053730f)

![1 9](https://github.com/user-attachments/assets/c2fc4418-8792-4dd6-baf3-9ad30af0b09b)


---

## Zadanie wstępne: obiekt typu pipeline

W ramach tego etapu stworzony został pipeline typu declarative wpisany bezpośrednio w interfejsie Jenkins (bez SCM). Pipeline składa się z trzech głównych etapów: sklonowania repozytorium, zbudowania obrazu Dockera oraz potwierdzenia sukcesu.

---

### 1. Etap: Clone repo

Pierwszym krokiem było sklonowanie repozytorium projektu MDO2025_INO z gałęzi prywatnej WM417892.

**Kod etapu:**
```
stage('Clone repo') {
    steps {
        git branch: 'WM417892', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
    }
}
```
**Zrzut ekranu:**  
![1 12](https://github.com/user-attachments/assets/0e8510a8-32ea-490f-8ba5-fb8838680a78)


---

### 2. Etap: Build Docker image

W tym etapie nastąpiło przejście do katalogu zawierającego plik Dockerfile oraz budowa obrazu z wykorzystaniem polecenia `docker build` przez połączenie TCP z demonem Dockera.

**Kod etapu:**
```
stage('Build Docker image') {
    steps {
        dir('INO/GCL02/WM417892/Sprawozdanie1/moj-obraz') {
            sh '''
                echo Listing files: 
                ls -la

                echo Building image...
                env -u DOCKER_TLS_VERIFY -u DOCKER_CERT_PATH docker -H tcp://docker:2375 build -t wojtek-builder -f Dockerfile .
            '''
        }
    }
}
```

**Zrzuty ekranu:**
- Lista plików i logi:
  
  ![1 13_1](https://github.com/user-attachments/assets/5fa8fb2a-e977-4404-9fda-6d478b69abeb)
  ![1 13_2](https://github.com/user-attachments/assets/fc5236f5-7972-4be1-8822-ec36501dfee4)

- Logi Jenkinsa z budowy:
  
  ![1 13_3](https://github.com/user-attachments/assets/02227524-66b2-4fcd-a858-08639fcd1db4)

- Widok graficzny zakończonego pipeline:
  
  ![1 13_4](https://github.com/user-attachments/assets/4e4ab1c6-c5b6-4fdf-b466-bd4f6c994ecc)

---

### 3. Etap: Print success

Pipeline kończy się wypisaniem komunikatu o poprawnym zakończeniu budowy obrazu.

**Kod etapu:**
```
stage('Print success') {
    steps {
        echo "Pipeline zakończony sukcesem. Obraz został zbudowany."
    }
}
```
---

### Dodatkowa walidacja - test Dockera

Po zbudowaniu obrazu przetestowano jego działanie lokalnie przy użyciu pliku `Dockerfile.test`, a następnie uruchomiono kontener i test jednostkowy w pytest.

**Komendy użyte lokalnie:**

docker build -t cj-test -f Dockerfile.test .  
docker run --rm cj-test

**Zrzuty ekranu:**
- Budowanie i uruchamianie:
  
  ![1 14](https://github.com/user-attachments/assets/4dbac6c5-9ab4-4ac3-993e-641bb5fb9763)

- Wynik testu: `
  
  ![image](https://github.com/user-attachments/assets/ed5fcdf5-811b-4985-9876-e72917a82f6c)


---

### Wnioski

Cały pipeline zakończył się sukcesem. Repozytorium zostało poprawnie sklonowane z prywatnej gałęzi, obraz Dockera został zbudowany, a testy potwierdziły jego poprawność. Jenkins wykonał cały proces bez błędów, co zostało potwierdzone zarówno logami tekstowymi, jak i widokiem graficznym przebiegu.


# Sprawozdanie – Własny pipeline i proces CI/CD

## Wybrany projekt

W ramach realizacji zadania zdecydowałem się na wykorzystanie projektu **TypeScript Node Starter**, dostępnego publicznie pod adresem:

[https://github.com/WojMats/TypeScript-Node-Starter](https://github.com/WojMats/TypeScript-Node-Starter)

Projekt ten stanowi szkielet aplikacji webowej stworzonej w Node.js z wykorzystaniem TypeScript, Express i MongoDB. Zawiera gotowe testy jednostkowe napisane w frameworku **Jest**, a także pełną strukturę opartą o środowisko kontenerowe Docker, co czyni go idealnym kandydatem do zintegrowania z systemem CI/CD (Continuous Integration / Continuous Delivery).

## Uzasadnienie wyboru

Projekt spełnia wszystkie wymagania stawiane przez instrukcję:

- Posiada plik `Dockerfile`, umożliwiający budowanie obrazu aplikacji oraz środowiska runtime,
- Zawiera testy automatyczne, które można uruchamiać w pipeline’ie,
- Umożliwia zdefiniowanie osobnych kontenerów typu **Builder** i **Tester**,
- Obraz aplikacji może zostać wdrożony do środowiska **runtime** (produkcyjnego),
- Jest wystarczająco przejrzysty, aby na jego podstawie zbudować kompletny pipeline CI/CD w Jenkinsie.

## Koncepcja działania pipeline’u

Pipeline został zdefiniowany w pliku `Jenkinsfile`, umieszczonym bezpośrednio w sforkowanym repozytorium projektu. Proces obejmuje następujące etapy:

1. **Collect** – klonowanie repozytorium i checkout do odpowiedniej gałęzi,
2. **Build** – budowa obrazu Docker na podstawie pliku `Dockerfile.app` (kontener typu Builder),
3. **Test** – uruchomienie testów z użyciem `jest`, działających w kontenerze testerowym,
4. **Deploy** – utworzenie obrazu z gotową aplikacją i uruchomienie jej w kontenerze runtime (weryfikacja działania, smoke test),
5. **Publish** – zapisanie artefaktów w formacie `.zip` oraz `.tar` (kontener), udostępnienie do pobrania w Jenkinsie.

## Cel

Celem sprawozdania jest nie tylko zbudowanie i uruchomienie funkcjonalnego pipeline’u, ale również przygotowanie dokumentacji zawierającej:

- wymagania środowiskowe,
- diagram aktywności (etapy CI),
- diagram wdrożeniowy (relacje między komponentami),
- szczegółowy plik `Jenkinsfile` oraz omówienie różnic między podejściami builder/runtime.

## Wymagania wstępne środowiska

Poniższe zrzuty ekranu przedstawiają przygotowanie środowiska lokalnego oraz potwierdzenie dostępności wymaganych narzędzi niezbędnych do realizacji pipeline'u CI/CD.

### Klonowanie repozytorium

Na poniższym zrzucie zaprezentowano proces klonowania sforkowanego repozytorium projektu `TypeScript-Node-Starter` z GitHuba do środowiska lokalnego:

![2 1](https://github.com/user-attachments/assets/beda503f-6720-42a4-9b96-0040ca219ddf)


Polecenie `git clone https://github.com/WojMats/TypeScript-Node-Starter.git` umożliwia pobranie pełnej historii repozytorium. Repozytorium zawiera niezbędne pliki źródłowe, testy oraz konfigurację pipeline'u w pliku `Jenkinsfile`.

---

### Weryfikacja środowiska narzędziowego

Drugi zrzut ekranu przedstawia wersje głównych narzędzi wykorzystywanych do budowy i uruchamiania aplikacji oraz pipeline'u:

![2 2](https://github.com/user-attachments/assets/d9d6eb46-add8-4604-85cb-634d7635887b)


- `node -v`: wersja Node.js – **v18.19.1**
- `npm -v`: wersja npm – **9.2.0**
- `docker --version`: wersja Dockera – **28.0.4**

Zgodność wersji tych narzędzi z wymaganiami projektu została potwierdzona. Środowisko lokalne umożliwia zarówno budowę obrazów Docker, jak i uruchamianie oraz testowanie kontenerów zgodnie z definicją pipeline'u.

---

Wymienione wersje są w pełni kompatybilne z zależnościami projektu oraz konfiguracją zawartą w plikach Dockerfile i Jenkinsfile, co pozwala na poprawne wykonanie pełnego cyklu CI/CD.

ap budowania obrazu aplikacji – Builder

W ramach procesu budowania aplikacji zdefiniowany został dedykowany Dockerfile o nazwie Dockerfile.builder, którego zadaniem jest stworzenie obrazu kontenerowego środowiska buildowego (Builder). Jego zawartość przedstawiono poniżej:

# --- ETAP BUILD: budujemy aplikację i instalujemy dependencje ---
FROM node:18-alpine AS builder
WORKDIR /app

# kopiujemy metadata o zależnościach i instalujemy
COPY package*.json ./
RUN npm install

# kopiujemy cały projekt i robimy build
COPY . .
RUN npm run build

![2 3](https://github.com/user-attachments/assets/1d133ad5-79d0-4562-af22-f197e5a0dd74)


Na powyższym screenie widoczna jest cała definicja etapu build, bazująca na lekkim obrazie node:18-alpine.

Budowanie obrazu kontenerowego z Dockerfile

Po przygotowaniu pliku Dockerfile.builder, uruchomiono proces budowania obrazu Docker przy użyciu poniższego polecenia:

docker build -f Dockerfile.builder -t ts-node-starter:builder .

Proces ten zakończył się sukcesem i doprowadził do utworzenia lokalnego obrazu ts-node-starter:builder.

![2 4](https://github.com/user-attachments/assets/18441e4f-5f47-4ee2-8a34-dd179aa87d9c)


Na screenie przedstawiono cały proces builda – od pobrania warstw node:18-alpine po zainstalowanie zależności i wykonanie komendy npm run build.

Testowe uruchomienie kontenera i instalacja zależności

W ramach weryfikacji działania przygotowanego kontenera Builder, wykonano testowe uruchomienie kontenera w celu zainstalowania zależności:

docker run --rm -v "$PWD":/app -w /app ts-node-starter:builder npm install

Jak widać na zrzucie, proces zakończył się poprawnie – zależności zostały zainstalowane (802 pakiety), mimo występowania ostrzeżeń o przestarzałych bibliotekach i potencjalnych lukach bezpieczeństwa.

![2 5](https://github.com/user-attachments/assets/41510794-c10e-40fd-96a8-8d144a8c1d4a)


W logach wyraźnie widać, że aplikacja przygotowana jest do dalszych kroków CI/CD.

Podsumowanie

Powyższe kroki stanowią fundament etapu budowania (Build) w pipeline i jednocześnie potwierdzają skuteczność definicji Dockerfile oraz możliwość instalacji i kompilacji aplikacji w izolowanym kontenerze Builder.


### Etap budowania aplikacji w kontenerze Builder

W tym etapie wykorzystano obraz typu `Builder` o nazwie `ts-node-starter:builder`, zbudowany wcześniej na podstawie pliku `Dockerfile.app`. Obraz ten zawiera wszystkie niezbędne zależności do procesu budowania aplikacji.

Polecenie wykonujące build wyglądało następująco:

```
docker run --rm \
  -v "$PWD":/app \
  -w /app \
  ts-node-starter:builder \
  npm run build
```

Uruchomienie polecenia `npm run build` wywołało zestaw kroków zdefiniowanych w `package.json`:

1. `build-sass` – kompilacja pliku SCSS do CSS za pomocą `sass`,
2. `build-ts` – transpilacja kodu TypeScript do JavaScript przy użyciu `tsc`,
3. `lint` – analiza statyczna kodu z użyciem ESLint,
4. `copy-static-assets` – kopiowanie zasobów statycznych do katalogu `dist`.

Rezultat budowania widoczny był na terminalu – każdy krok zakończył się sukcesem bez błędów.

#### 📸 Rysunek 2.6 – Proces budowania aplikacji w kontenerze Builder
![2 6](https://github.com/user-attachments/assets/cb873e7b-ad4a-4f80-a035-97fdf05ed04d)


---

### Struktura katalogu `dist`

Po zakończeniu procesu builda wygenerowany został katalog `dist/` zawierający wszystkie pliki wynikowe:

```
ls -l dist/
```

Zawartość obejmuje m.in.:

* główne pliki JavaScript (`app.js`, `server.js`),
* odpowiadające im mapy (`.map`),
* podkatalogi `config`, `controllers`, `models`, `util`, `public` zawierające zbudowany kod.

Dzięki temu katalog `dist` może służyć jako gotowy artefakt do dalszych etapów testowania lub publikacji.

#### 📸 Rysunek 2.7 – Zawartość katalogu `dist/` po buildzie
![2 7](https://github.com/user-attachments/assets/702ae092-223c-4aba-ae27-0dc815a39e84)

---

### Przygotowanie obrazu Tester

Na podstawie wcześniej zbudowanego obrazu Builder przygotowano osobny obraz testowy. Został on zdefiniowany w pliku `Dockerfile.test`:

```
# Obraz tester bazuje na obrazie buildera
FROM ts-node-starter:builder
WORKDIR /app

# Kopiowanie kodu źródłowego
COPY . .

# Uruchamianie testów
CMD ["npm", "test"]
```

Plik ten służy do stworzenia środowiska testowego na bazie kodu i zależności z Buildera.

#### 📸 Rysunek 2.8 – Treść pliku Dockerfile.test
![2 8](https://github.com/user-attachments/assets/9c1dad8c-e9ea-460e-8e32-1dede2330d16)

---

### Budowanie obrazu testowego

Zbudowano obraz testowy poleceniem:

```
docker build -f Dockerfile.test -t ts-node-starter:tester .
```

Proces zakończył się sukcesem, a obraz `ts-node-starter:tester` został zapisany lokalnie. Jest on gotowy do użycia w kolejnym kroku pipeline – uruchamianiu testów jednostkowych w kontenerze.

#### 📸 Rysunek 2.9 – Tworzenie obrazu Tester
![2 9](https://github.com/user-attachments/assets/10d635fb-0d4e-4297-a85d-fc88abd228cd)




### Uruchamianie testów przy użyciu `docker-compose`

W celu uruchomienia testów wykorzystano plik `docker-compose.test.yml`, który definiuje dwa kontenery: `mongo` oraz `tester`. Uruchomienie kompozycji nastąpiło z wykorzystaniem parametru `--abort-on-container-exit`, który kończy działanie po zakończeniu pracy `tester`:

```
docker compose -f docker-compose.test.yml up --abort-on-container-exit
```

Kontenery zostały poprawnie uruchomione:

* `typescript-node-starter-mongo-1` – instancja MongoDB,
* `typescript-node-starter-tester-1` – uruchomienie testów w kontenerze Tester.

#### 📸 Rysunek 2.10 – Uruchomienie testów w kontenerze tester przy użyciu `docker-compose`
![2 10](https://github.com/user-attachments/assets/03a173cc-be72-4b2f-babb-11b7c7dc59c8)

---

### Wyniki testów jednostkowych

Po zakończeniu działania kontenera testowego wyświetlone zostały wyniki testów wykonanych przez `jest`:

* Wszystkie 5 zestawów testowych zakończyło się sukcesem,
* Przetestowano 10 przypadków testowych,
* Szczegółowe dane pokrycia kodu zostały wyświetlone w tabeli końcowej, z podziałem na pliki i zakresy niepokrytych linii.

Z testów wynika, że system działa poprawnie i spełnia wymagania CI/CD.

#### 📸 Rysunek 2.11 – Wyniki testów jednostkowych i pokrycie kodu
![2 11](https://github.com/user-attachments/assets/57c1d238-922f-43bb-884c-58c679e7b2d3)

---

### Budowanie kontenera Runtime

Do wdrożenia przygotowano osobny, lekki obraz uruchomieniowy (runtime) na bazie `node:18-alpine`. Jego definicję umieszczono w pliku `Dockerfile.runtime`:

```
FROM node:18-alpine
WORKDIR /app

COPY package*.json ./
RUN npm install --only=production

COPY dist ./dist
COPY views ./views
COPY dist/public ./public
COPY .env.example .env

CMD ["node", "dist/server.js"]
```

Obraz został zbudowany lokalnie za pomocą:

```
docker build -f Dockerfile.runtime -t ts-node-starter:runtime .
```

#### 📸 Rysunek 2.12 – Treść Dockerfile.runtime oraz wynik jego budowania
![2 12](https://github.com/user-attachments/assets/7b17af10-9d7c-4037-b387-9a0b5f8589d5)

---

### Uruchomienie aplikacji w kontenerze Runtime

Kontener aplikacyjny został uruchomiony przy użyciu pliku `.env.example` jako konfiguracji środowiskowej. Dodatkowo uruchomiona została instancja MongoDB:

```
docker run -d --name mongo -p 27017:27017 mongo:4.4

docker run -d \
  --name ts-node-app \
  --link mongo:mongo \
  -v "$PWD/.env.example":/app/.env.example:ro \
  -p 3000:3000 \
  ts-node-starter:runtime
```

Aby sprawdzić poprawność działania, sprawdzono logi kontenera:

```
docker logs -f ts-node-app
```

Z logów wynika, że:

* Aplikacja została uruchomiona pod `http://0.0.0.0:3000`,
* Połączenie z MongoDB przebiegło poprawnie,
* Nie pojawiły się błędy krytyczne.


### Weryfikacja działania aplikacji

Ostatecznie, potwierdzono poprawność działania aplikacji poprzez otwarcie w przeglądarce strony `http://localhost:3000`. Aplikacja została załadowana i wyświetliła interfejs frontendowy.

To kończy etap wdrożenia i weryfikacji działania kontenera typu Runtime.

#### 📸 Rysunek 2.14 – Widok działającej aplikacji na porcie 3000
![2 15 1](https://github.com/user-attachments/assets/b3318009-c423-442c-9967-1da183707642)

### Konfiguracja kontenera Jenkins oraz integracja z repozytorium

Poniższe zrzuty ekranu dokumentują uruchomienie kontenera Jenkins oraz konfigurację projektu pipeline w oparciu o repozytorium z GitHub.

#### Budowanie i uruchamianie kontenera Jenkins

```bash
$ docker-compose up -d --build
```

W wyniku powyższej komendy, zbudowany został obraz na podstawie pliku `Dockerfile.jenkins`, który bazuje na oficjalnym obrazie `jenkins/jenkins:lts-jdk17`. W etapie budowania obrazu, doinstalowane zostały potrzebne pakiety (`docker.io`, `zip`) oraz użytkownik `jenkins` został dodany do grupy `docker`, aby umożliwić dostęp do Dockera z poziomu środowiska Jenkins.

Po zbudowaniu obrazu uruchomiony został kontener o nazwie `jenkins`, dostępny pod portem `8080`, zgodnie z informacją z `docker ps`:

```bash
CONTAINER ID   IMAGE                             PORTS
fd30b618df3b   typescript-node-starter_jenkins  0.0.0.0:8080->8080/tcp
```

#### Konfiguracja źródła pipeline w Jenkinsie

W interfejsie graficznym Jenkinsa zdefiniowano projekt typu *Pipeline* i ustawiono źródło kodu jako *Pipeline script from SCM*, wykorzystując system kontroli wersji Git.

* **Repository URL**: `https://github.com/WojMats/TypeScript-Node-Starter.git`
* **Branch**: `*/WM417892`
* **Script Path**: `Jenkinsfile`
* **Lightweight checkout**: zaznaczone, co oznacza szybkie pobranie samego pliku Jenkinsfile bez klonowania całego repozytorium.

Ta konfiguracja zapewnia pełną automatyzację procesu CI/CD, ponieważ pipeline zostaje wywoływany bezpośrednio z repozytorium i śledzi wybraną gałąź projektu.
![image](https://github.com/user-attachments/assets/d23d50e1-a254-4924-bad2-6390eb02a6e0)

---

### Jenkinsfile

```groovy
pipeline {
  agent any

  environment {
    APP_IMAGE = "ts-node-starter:ci-${env.BUILD_NUMBER}"
    MONGO_IMAGE = 'mongo:4.4'
    NETWORK = 'ci-net'
  }

  stages {

    stage('Prepare network') {
      steps {
        echo '🔧 Tworzenie sieci Docker (jeśli nie istnieje)'
        sh "docker network create ${NETWORK} || true"
      }
    }

    stage('Build app image') {
      steps {
        echo '🛠️ Budowanie obrazu aplikacji z Dockerfile.app'
        sh "docker build -t ${APP_IMAGE} -f Dockerfile.app ."
      }
    }

    stage('Start Mongo') {
      steps {
        echo '🧬 Uruchamianie kontenera MongoDB'
        sh "docker run -d --name ci-mongo --network ${NETWORK} ${MONGO_IMAGE}"
        sh "sleep 5"
      }
    }

    stage('Test') {
      steps {
        echo '🧪 Uruchamianie testów'
        sh """
          docker run --rm --network ${NETWORK} \
            -e MONGODB_URI_LOCAL="mongodb://ci-mongo:27017/express-typescript-starter" \
            ${APP_IMAGE} npm test
        """
      }
    }

    stage('Cleanup Mongo') {
      steps {
        echo '🧹 Sprzątanie MongoDB'
        sh "docker rm -f ci-mongo || true"
      }
    }

    stage('Publish artifacts') {
      steps {
        echo '📦 Wyciąganie dist/ z obrazu i archiwizacja'
        sh """
          docker create --name extract-container ${APP_IMAGE}
          docker cp extract-container:/app/dist ./dist
          docker rm extract-container
        """
        archiveArtifacts artifacts: 'dist/**/*', fingerprint: true
      }
    }

    stage('Publish (docker save, zip)') {
      steps {
        echo '📦 Tworzenie .tar obrazu i archiwum .zip z dist/'
        sh """
          docker save ${APP_IMAGE} -o ts-node-starter.tar
          zip -r dist.zip dist/
        """
        archiveArtifacts artifacts: 'ts-node-starter.tar', fingerprint: true
        archiveArtifacts artifacts: 'dist.zip', fingerprint: true
      }
    }
  }

  post {
    always {
      echo '🧼 Czyszczenie środowiska po pipeline'
      sh "docker rm -f ci-mongo || true"
      sh "docker network rm ${NETWORK} || true"
    }
  }
}
```

#### Analiza kroków Jenkinsfile

* **agent any**: wykonuje pipeline na dowolnym dostępnym agencie (maszynie wykonawczej).

* **environment**: definiuje zmienne środowiskowe używane w pipeline:

  * `APP_IMAGE`: wersjonowany obraz aplikacji,
  * `MONGO_IMAGE`: oficjalny obraz MongoDB,
  * `NETWORK`: nazwa sieci Docker, która umożliwia komunikację między kontenerami.

* **Prepare network**: tworzy sieć Docker, jeżeli jeszcze nie istnieje – zapewnia izolowane środowisko dla aplikacji i bazy danych.

* **Build app image**: buduje obraz aplikacji na podstawie pliku `Dockerfile.app`, oznaczając go wersją opartą o numer builda.

* **Start Mongo**: uruchamia kontener MongoDB na przygotowanej sieci – baza danych wymagana do testów.

* **Test**: uruchamia testy aplikacji z wykorzystaniem obrazu aplikacyjnego – wykonuje polecenie `npm test`, przekazując URI do instancji Mongo.

* **Cleanup Mongo**: zatrzymuje i usuwa kontener MongoDB, porządkując środowisko po testach.

* **Publish artifacts**: tworzy tymczasowy kontener z obrazu aplikacji i kopiuje katalog `dist/`, zawierający zbudowane pliki aplikacji, archiwizuje je jako artefakty.

* **Publish (docker save, zip)**: zapisuje zbudowany obraz jako plik `.tar`, dodatkowo tworzy archiwum `.zip` z zawartością `dist/`. Oba pliki są dostępne jako artefakty z budowania.

* **post > always**: końcowy etap czyszczący – niezależnie od wyniku pipeline'u usuwa sieć i kontener bazy danych, aby uniknąć konfliktów w przyszłych uruchomieniach.
