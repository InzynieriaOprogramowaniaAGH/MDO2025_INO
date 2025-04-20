# Pipeline, Jenkins, izolacja etapów
## Przygotowanie
Zgodnie z instrukcją instalacji Jenkinsa: https://www.jenkins.io/doc/book/installing/docker/

Wykonano następujące kroki:
1. Utworzono sieć bridge dla Dockera
```
docker network create jenkins
```
2. Uruchomiono kontener z Docker-in-Docker (dind)
```
docker run \
  --name jenkins-docker \
  --rm \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind \
  --storage-driver overlay2
```
*Kontener działa jako "Docker daemon" dla Jenkinsa. Jest niezbędny, by Jenkins mógł wykonywać polecenia **docker** 
3. Stworzono własny obraz z Jenkins +  BlueOcean
a) plik Dockerfile:
```
FROM jenkins/jenkins:2.492.3-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```
b) budowanie obrazu:
```
docker build -t myjenkins-blueocean:2.492.3-1 .
```
4. Uruchomiono kontener z własnym obrazem Jenkins + BlueOcean
```
docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.492.3-1
```
5. Jenkins jest dostępny pod adresem: http://localhost:8080
6. Po wejściu na podany adres, będzie wymagane hasło, które można uzyskać poniższą komendą:
```
sudo docker exec ${CONTAINER_ID or CONTAINER_NAME} cat /var/jenkins_home/secrets/initialAdminPassword
```

### Różnica: Jenkins vs BlueOcean

| Cecha                  | Jenkins (bazowy)                                      | BlueOcean (rozszerzenie Jenkinsa)                          |
|------------------------|-------------------------------------------------------|-------------------------------------------------------------|
| *Interfejs użytkownika (UI)* | Klasyczny, techniczny i mniej intuicyjny                | Nowoczesny, graficzny i bardziej przyjazny dla użytkownika |
| *Obsługa pipeline'ów*       | Wymaga ręcznej konfiguracji i pluginów                 | Wbudowana obsługa pipeline as code z graficznym edytorem    |
| *Tworzenie projektów*      | Ręczne dodawanie i konfiguracja                         | Kreatory projektów z integracją Git, GitHub, Bitbucket      |
| *Zarządzanie buildami*     | Widok listy, mniej przejrzysty                          | Wizualizacja przepływu pracy (pipeline visualization)       |
| *Grupa docelowa*           | Zaawansowani użytkownicy i administratorzy              | Zespoły DevOps, programiści, użytkownicy nietechniczni      |
| *Instalacja*               | Podstawowa instalacja Jenkins                           | Wymaga dodania pluginu blueocean                          |

**Podsumowanie:**  
BlueOcean to nowoczesne rozszerzenie Jenkinsa, które upraszcza zarządzanie pipeline’ami i oferuje przyjazny interfejs graficzny, ale nadal bazuje na podstawowej instalacji Jenkins.


### Zadanie wstępne: uruchomienie

