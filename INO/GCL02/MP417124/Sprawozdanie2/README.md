# Sprawozdanie (Zadania 5-7)


## Przygotowanie środowiska

Na początku zajęć przystąpiłam do utworzenia instancji Jenkinsa według instrukcji - `https://www.jenkins.io/doc/book/installing/docker/`. Zainicjowałam sieć Dockera (`jenkins`), a następnie uruchomiłam kontener `docker-in-docker`, który stanowił kluczowy element umożliwiający wykonywanie komend Dockera bezpośrednio z poziomu Jenkinsa. 

Najpierw zaczełam od utworzenia nowej sieci dockera **Jenkins** poprzez komendę `docker network create jenkins`.
Następnie utworzyłam kontener docker-in-docker (dind), kt

![Zrzut ekranu 1 – Uruchomienie kontenera dind i sieci]()

Następnie stworzyłam spersonalizowany obraz Dockera na bazie oficjalnego obrazu Jenkinsa, rozszerzając go o obsługę Docker CLI oraz instalując potrzebne pluginy: `blueocean` i `docker-workflow`. Dzięki temu możliwe było wykorzystanie interfejsu Blue Ocean do wizualizacji pipeline’ów, co w znacznym stopniu poprawia przejrzystość i komfort pracy.

![Zrzut ekranu 2 – Budowanie obrazu Jenkins]()

Całość środowiska została uruchomiona i podłączona do wspólnej sieci Dockera, a interfejs Jenkinsa był dostępny przez przeglądarkę lokalnie. Proces pozyskania hasła oraz instalacji pluginów przebiegł bez zakłóceń.

![Zrzut ekranu 3 – Kontener jenkins-blueocean]()  
![Zrzut ekranu 4 – Strona logowania]()  
![Zrzut ekranu 5 – Hasło jednorazowe]()  
![Zrzut ekranu 6 – Instalacja pluginów]()

---

## Zadania wstępne

W ramach pierwszych prób stworzyłam kilka prostych projektów:

- Komenda `uname` pozwoliła sprawdzić, czy Jenkins wykonuje poprawnie skrypty powłoki.  
  ![Zrzut ekranu 7 – uname]()

- Napisałam skrypt, który sprawdza, czy bieżąca godzina jest parzysta. Mimo że to zadanie miało charakter czysto testowy, świetnie obrazuje, jak Jenkins może służyć do uruchamiania warunkowych zadań.  
  ![Zrzut ekranu 8 – Sprawdzenie godziny]()

- Utworzyłam job pobierający obraz systemu Ubuntu z Dockera, co potwierdziło poprawność konfiguracji integracji Jenkinsa z Dockerem.  
  ![Zrzut ekranu 9 – docker pull ubuntu]()

Każdy z projektów zakończył się sukcesem, co dało mi dużą satysfakcję, szczególnie że początkowo miałam wątpliwości co do konfiguracji kontenerów i poprawnego montowania woluminów.

---

## Pipeline – izolacja etapów

W dalszej części laboratorium skonfigurowałam pełnoprawny pipeline w Jenkinsie. Pipeline został podzielony na trzy etapy:

1. **Klonowanie repozytorium** z GitHuba na wskazanej gałęzi `MP417124`.
2. **Budowa obrazu Dockera** z pliku `Dockerfile.build`, znajdującego się w strukturze katalogów repozytorium.
3. **Wyświetlenie komunikatu końcowego** o poprawnym przebiegu procesu.

```groovy
pipeline {
    agent any

    stages {
        stage('Clone repo') {
            steps {
                git branch: 'MP417124', url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
            }
        }

        stage('Build Docker image') {
            steps {
                dir ("INO/GCL02/MP417124/docker_build") {
                    script {
                        sh 'ls -la'
                        docker.build('build', '-f Dockerfile.build .')
                    }
                }
            }
        }

        stage('Done') {
            steps {
                echo 'Pipeline ran successfully. Docker image was built.'
            }
        }
    }
}


