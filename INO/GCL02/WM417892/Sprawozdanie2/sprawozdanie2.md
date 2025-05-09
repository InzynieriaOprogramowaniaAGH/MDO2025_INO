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
