# Sprawozdanie z laboratoriów: Pipeline, Jenkins
### Instancja Jenkinsa została utworzona zgodnie z oficjalną instrukcją instalacyjną.

### Utworzono dedykowaną sieć Docker o nazwie jenkins:

` docker network create jenkins `

### Kontener Docker-in-Docker (DinD):
Uruchomiono kontener docker:dind, który umożliwia wykonywanie poleceń Docker wewnątrz Jenkinsa. Kontener został podłączony do sieci jenkins i otrzymał alias docker:

`docker run --name jenkins-docker --rm --detach \
  --privileged --network jenkins --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind --storage-driver overlay2`

### Niestandardowy obraz Jenkins (Dockerfile.myjenkins-blueocean)
Stworzono własny obraz Dockera na podstawie jenkins/jenkins:2.492.2-jdk17, który:

- dodaje obsługę klienta Docker (CLI),

- instaluje pluginy: Blue Ocean oraz docker-workflow.

Dzięki temu możliwe jest uruchamianie zadań Jenkinsowych z wykorzystaniem Dockera poprzez przyjazny interfejs Blue Ocean.

`### Dockerfile.myjenkins-blueocean ###
FROM jenkins/jenkins:2.492.2-jdk17
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
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"`

Obraz utworzono poleceniem: 
`docker build -t myjenkins-blueocean:2.492.3-1 .`

### Uruchomienie kontenera jenkins-blueocean
Kontener Jenkinsa został uruchomiony na podstawie wcześniej zbudowanego obrazu myjenkins-blueocean:2.492.3-1, z wykorzystaniem poniższego polecenia:

`docker run --name jenkins-blueocean --restart=on-failure --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.492.3-1`

  Kontener został podłączony do sieci jenkins oraz przypisano mu odpowiednie woluminy.

### Dostęp do interfejsu webowego
Z poziomu przeglądarki na hoście maszyny wirtualnej odwiedzono interfejs Jenkinsa pod adresem http://192.168.1.102:8080
W celu pierwszego logowania, hasło jednorazowe zostało uzyskane z logów kontenera:
![6](https://github.com/user-attachments/assets/8c21a6d8-757d-4e23-9fde-d95c1007dec7)

# Projekt: wyświetlenie informacji o systemie
Zrealizowano zadanie, które po uruchomieniu wypisuje w konsoli wynik polecenia uname, czyli podstawowe informacje o systemie operacyjnym.

![2](https://github.com/user-attachments/assets/aaa80ec4-ff6a-4c55-8f31-0ed6b348f82d)

![3](https://github.com/user-attachments/assets/ff01bcd2-9f40-4666-a24c-1fd5c867da0f)

### sprawdzenie parzystości godziny
Kolejny projekt wykonuje skrypt Bash, który sprawdza, czy aktualna godzina (w formacie 24-godzinnym) jest parzysta czy nie:

![5](https://github.com/user-attachments/assets/182bc9c3-caa7-4ec1-8456-a6cf84674070)

![4](https://github.com/user-attachments/assets/40f8bf73-c1a4-47d6-9da6-812e45bc99fb)

# pobieranie obrazu Dockera

`docker pull ubuntu`

![7](https://github.com/user-attachments/assets/1b146a0a-b53c-4d1f-a166-ef9521dce044)




