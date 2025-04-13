# Sprawozdanie z Pipeline, Jenkins, izolacja etapów

## 1. Przygotowanie

### Utworzenie instancji Jenkins

#### Podążając instrukcjami z dokumentacji: https://www.jenkins.io/doc/book/installing/docker/

Utworzenie sieci jenkins

```
docker network create jenkins
```

![](../screens/class5/1.jpg)

Uruchomienie docker:dind w kontenerze

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

![](../screens/class5/2.jpg)

Utworzenie pliku Dockerfile do zbudowania kontenera blueocean

```
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
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```

![](../screens/class5/3.jpg)

Zbudowanie obrazu z powyższego Dockerfile

```
docker build -t myjenkins-blueocean -f Dockerfile.blueocean .
```

![](../screens/class5/4.jpg)

Uruchomienie jenkins:blueocean w kontenerze

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
  myjenkins-blueocean
```

![](../screens/class5/5.jpg)

Po uruchomieniu blueocean i dind przechodzimy na stronę konfiguracyjną jenkins na porcie 8080: http://localhost:8080/

### Zadanie wstępne: uruchomienie

#### Przechodzimy do tworzenia projektów na jenkinsie

Po podaniu hasła zapisanego w kontenerze z jenkinsem przenosimy się do panelu konfiguracyjnego jenkins, skąd możemy tworzyć projekty i *pipeline'y*

![](../screens/class5/7.jpg)

W zakładce *Nowy projekt* tworzymy nowy projekt i w jego konfiguracji w krokach budowania możemy umieścić treść polecenia, które ma się wykonać po uruchomieniu projektu

![](../screens/class5/8.jpg)

Wynik projektu wyświetlającego ```uname -a```

![](../screens/class5/9.jpg)

Wynik projektu wyświetlającego błąd jeśli godzina jest nieparzysta

![](../screens/class5/10.jpg)

Wynik projektu wykonującego polecenie ```docker pull ubuntu``` wewnątrz DinD

![](../screens/class5/11.jpg)

### Zadanie wstępne: obiekt typu pipeline

#### Tworzyny nowy obiekt *pipeline* analogicznie jak tworzyliśmy poprzednie projekty, jednak z menu wybierając typ projektu jako pipeline

Wewnątrz projektu pipeline'u tworzymy skrypt w składni pipeline, który klonuje repozytorium przedmiotowe oraz korzystając z pliku Dockerfile do zbudowania projektu irssi, buduje obraz na podstawie pliku Dockerfile. Aby zabezpieczyć pipeline przed błędami związanymi z ponownym jego uruchomieniem, czyścimy dotychczasowo utworzone pliki i budujemy obraz na nowo.

#### Treść skryptu:

![](../screens/class5/12.jpg)

Wyniki dwukrotnego uruchomienia pipeline'u

![](../screens/class5/13.jpg)

![](../screens/class5/14.jpg)

Zestawienie czasów trwania procesów buildowania dla obu uruchomień pipeline'u. Obserwujemy podobne wynki czasowe, co sugeruje, że oba pipeline'y wykonały tę samą pracę i żadne czynności nie zostały pominięte chociażby poprzez cache'owanie

![](../screens/class5/15.jpg)

![](../screens/class5/16.jpg)

# Sprawozdanie z Publikacji pakietu npm z express.js

![](../screens/class6/1.jpg)
![](../screens/class6/2.jpg)
![](../screens/class6/3.jpg)
![](../screens/class6/4.jpg)
![](../screens/class6/5.jpg)
![](../screens/class6/6.jpg)
![](../screens/class6/7.jpg)
![](../screens/class6/8.jpg)
![](../screens/class6/9.jpg)
![](../screens/class6/10.jpg)
![](../screens/class6/11.jpg)
![](../screens/class6/12.jpg)
![](../screens/class6/13.jpg)
![](../screens/class6/14.jpg)
![](../screens/class6/15.jpg)