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
