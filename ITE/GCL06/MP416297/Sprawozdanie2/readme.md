### Instalacja Jenkinsa

#### Utworzenie sieci
Pierwszym krokiem instatlacji jest utworzenie mostkowej sieci w Dockerze. 
```bash
docker network create jenkins
```

#### DIND
Kolejnym krokiem jest uruchomienie konteneru na obrazie docker::dind czyli docker in docker, który pozwala na wykonywanie poleceń Docker wewnątrz węzłów Jenkinsa. Warto dodać, że dinda trzeba uruchamiać manualnie po każdym restarcie hosta bo nie ma on autostartu.
```bash
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

#### Dockerfile Jenkinsa
Następnie tworzymy Dockerfile i wklejamy do niego gotową konfigurację obrazu z dokumentacji Jenkinsa.
```dockerfile
FROM jenkins/jenkins:2.504.1-jdk21
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
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow json-path-api"
```

A następnie budujemy obraz z utworzonego Dockerfile'a. (komendę trzeba odpalić w terminalu w katalogu zawierającym Dockerfile)
```bash
docker build -t myjenkins-blueocean:2.504.1-1 .
```

#### Uruchomienie Jenkinsa
Ostatnim krokiem instalacji jest uruchomienie kontenera z Jenkinsem.

```bash
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
  myjenkins-blueocean:2.504.1-1 
```

#### Logowanie i konfiguracja
Aby zalogować się do nowo postawionego Jenkinsa potrzebujemy hasło, które znajduje się w katalogu `/var/jenkins_home/secrets/initialAdminPassword`, i możemy je pozyskać np. przy pomocy poniższej komendy:

```bash
docker exec jenkins-blueocean ls /var/jenkins_home/secrets/
```

Następnie zainstalowałem automatycznie proponowane wtyczki i zabrałem się do testowania działania.

### Przykładowe projekty
