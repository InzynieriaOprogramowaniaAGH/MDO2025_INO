# Sprawozdanie z laboratoriów: Pipeline, Jenkins, izolacja etapów
- Przedmiot: DevOps
- Kierunek: Inżynieria Obliczeniowa
- Autor: Filip Rak
- Data: 06/04/2025

## Przebieg Ćwiczeń
### Jenkins
- Utworzono instancje jenkinsa zgodnie z [instrukcją instalacyjną](https://www.jenkins.io/doc/book/installing/docker/).
  - Utworzono nową sieć dockera **Jenkins**: `docker network create jenkins`.
  - Utworzono kontener *docker-in-docker (dind)*, który pozwala na wywołanie poleeceń Dockera wewnątrz Jenkinsa: `docker run --name jenkins-docker --rm --detach \
  --privileged --network jenkins --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind --storage-driver overlay2`. Połączono go z siecią **Jenkins** oraz ustawiono alias **docker** w sieci.
  - Utworzono plik `Dockerfile.myjenkins-blueocean`, który tworzy niestandardowy obraz **Jenkinsa** oparty na wersji `jenkins/jenkins:2.492.2-jdk17`, który dodaje obsługę `Docker CLI` oraz instaluje pluginy **blueocean** i **docker-workflow**, umożliwiając uruchamianie zadań Jenkinsowych z wykorzystaniem Dockera w interfejsie **Blue Ocean**.
    ```
    ### Dockerfile.myjenkins-blueocean ###
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
    Obraz utworzono poleceniem: `docker build -t myjenkins-blueocean:2.492.3-1 .`
  - *Zrzut erkanu z tworzenia kontenera `dind` i obrazu `myjenkins-blueocean:2.492.3-1`*:
    
    ![Zrzut ekranu z tworzenia kontenerów 1](media/m1_setup.png)
  - Uruchomiono kontener **jenkins-bluocean** poleceniem: `docker run --name jenkins-blueocean --restart=on-failure --detach \
    --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
    --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
    --publish 8080:8080 --publish 50000:50000 \
    --volume jenkins-data:/var/jenkins_home \
    --volume jenkins-docker-certs:/certs/client:ro \
    myjenkins-blueocean:2.492.3-1` podłączając go do sieci i odpowiednich woluminów.
  - *Zrzut erkanu uruchomienia kontnera `jenkins-bluocean`*:
    
    ![Zrzut ekranu z tworzenia kontenerów 2](media/m2_ocean.png)
  - Na hoście maszyny wirtualnej, prxzez przeglądarkę,  odwiedzono interfejs **Jenkinsa** pod adresem maszyny: `192.168.1.102:8080`
  - *Zrzut ekranu strony logowania*:
 
    ![Zrzut ekranu strony logowania](media/m3_unlock.png)
  - Hasło uzyskano z logów dockera poleceniem `docker logs jenkins-blueocean`
  - *Zrzut ekranu uzyskanego hasła jednorazowego*:
 
    ![Zrzut ekranu hasła](media/m4_pass.png)

  - Utworzono konto w interfejsie **Jenkinsa** i wybrano rekomendowaną paczkę pluginów.
  - *Zrzut erkanu z instalacji pluginów:*

    ![Zrzut ekranu konfiguracji](media/m5_getting_started.png)
  - 
