# Sprawozdanie 2

Do wykonywania zadań laboratoryjnych skorzystałam z programu "To do List", wykorzystywanego przeze mnie na poprzednich zajęciach.

Jenkins to  narzędzie do automatyzacji procesów tworzenia, testowania i wdrażania naszej aplikacji, natomiast BlueOcean to jego rozszerzenie, które daje nam bardziej nowoczensy i intuicyjny interfejs do zarządzania procesami CI/CD.

## Zajęcia 05

### Przygotowanie

Upewniłam się, że działają kontenery budujące i testujące, które tworzyłam na poprzednich zajęciach

Zapoznałam się z instrukcją instalacji Jenkinsa.

Pracę rozpoczęłam od utworzenia sieci dla Jenkinsa korzystając z następującego polecenia:

` docker network create jenkins `

Nastepnie uruchomiłam kontener dind (Docker-in-Docker) korzystając z gotowego obrazu:

``` docker run \
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
  --storage-driver overlay2 ```
 

Stworzłam Dockerfile dla własnego obrazu zawierającego Blue Ocean:

``` FROM jenkins/jenkins:2.440.3-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow" ```

Zbudowałam obraz:

docker build -t blueocean -f Blueocean.Dockerfile .

I uruchomiłam kontener:

``` docker run \
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
  blueocean ```

W celu przeprowadzenia konfiguracji Jenkinsa weszłam na stronę http://localhost:8080, wpisałam hasło (pozyskane zgodnie z opisem w poprzednim sprawozdaniu) i utworzyłam nowego użytkownika.

![alt text](screens/użytkownik.png)

Rozpoczęłam pracę nad pierwszym projektem, którego celem było wyświetlenie wyniku polecenia uname. W konfiguracji projektu wybrałam opcję "Uruchomienie powłoki" i dodałam polecenie:

` uname -a `

![alt text](screens/uname2.png)

Zrzut ekranu potwierdzający poprawne działanie projektu:

![alt text](screens/uname.png)

Drugi projekt miał na celu zwracanie błędu, gdy aktualna godzina jest nieparzyst. W powłoce użyłam następującego skryptu:

```
if [ $(( $(date +%H) % 2 )) -eq 1 ]; then
    echo "Godzina jest nieparzysta."
    exit 1
else
    echo "Godzina jest parzysta."
fi
```

![alt text](screens/hour1.png)

![alt text](screens/hour2.png)
