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


# Sprawozdanie – Pipeline i proces CI/CD

## Wybrany projekt

W ramach realizacji zadania zdecydowałem się na wykorzystanie projektu **Full Stack FastAPI PostgreSQL**, dostępnego publicznie pod adresem:

[https://github.com/tiangolo/full-stack-fastapi-postgresql](https://github.com/tiangolo/full-stack-fastapi-postgresql)

Projekt ten udostępnia kompletną aplikację webową REST API stworzoną przy użyciu frameworka **FastAPI**, obsługuje bazę danych **PostgreSQL**, a także zawiera system testów jednostkowych napisanych w **Pytest**. Co ważne, projekt oparty jest na środowisku kontenerowym Docker i umożliwia prostą integrację z systemami CI/CD.

---

## Uzasadnienie wyboru

Projekt spełnia wszystkie wymagania stawiane przez instrukcję:
- Posiada Dockerfile do budowania aplikacji oraz środowisko testowe,
- Zawiera testy automatyczne, które można uruchamiać w pipeline’ie,
- Umożliwia zdefiniowanie osobnych kontenerów typu **Builder** i **Tester**,
- Umożliwia wdrożenie gotowego obrazu jako aplikacji działającej w środowisku runtime (kontener produkcyjny),
- Jest wystarczająco złożony, by wykazać pełny proces CI/CD, ale na tyle przejrzysty, by skutecznie wdrożyć wymagane etapy w Jenkinsie.

---

## Koncepcja działania pipeline’u

Pipeline zostanie zdefiniowany w pliku **`Jenkinsfile`**, który będzie umieszczony w sforkowanym repozytorium projektu. Proces będzie obejmować następujące etapy:

1. **Collect** – sklonowanie repozytorium oraz checkout do właściwej gałęzi.
2. **Build** – budowa obrazu Docker na podstawie `Dockerfile`, przy użyciu kontenera typu **Builder**.
3. **Test** – uruchomienie testów zdefiniowanych w `pytest`, przy użyciu kontenera typu **Tester**; logi zostaną zapisane jako artefakty.
4. **Deploy** – uruchomienie gotowego obrazu aplikacji w kontenerze runtime, test dostępności aplikacji przez wywołanie endpointu.
5. **Publish** – opcjonalne zapisanie gotowego obrazu lub paczki `.zip` jako artefaktu do pobrania, ewentualnie wysłanie do rejestru (lokalnego lub zewnętrznego).

---

## Cel

Celem sprawozdania jest nie tylko uruchomienie pipeline’u, ale także jego dokumentacja w postaci diagramów UML oraz analiza zastosowanego podejścia, w tym różnic między środowiskiem buildowym i runtime’owym. W kolejnych sekcjach zostaną zaprezentowane:
- wymagania środowiskowe,
- diagram aktywności (etapy CI),
- diagram wdrożeniowy (relacje między komponentami),
- szczegóły pliku Jenkinsfile i funkcjonalnych różnic między podejściami.
