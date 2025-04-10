# Zajęcia 05

## Utworzenie instancji Jenkins

Aby rozdzielić pracę i bardziej ją uporządkować utworzono nową gałąz na której od teraz będzie przeprowadzana cała praca.

Następne kroki wykonywane były według dokumentacji na stronie internetowej: https://www.jenkins.io/doc/book/installing/docker/

Rozpoczynamy od utworzenia sieci:

![alt text](./img/image15.png)

Według poradnika pierwszym krokiem jest utworzenie kontenera <code style="color:rgb(35, 186, 101);"> docker:dind</code> z wykorzystaniem komendy:

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

Wszystkie parametry polecenia są szczegółowo opisane na stronie zawierającej dokumentacje.

Pomyślne wykonanie powyższego polecenia:

![alt text](./img/image12.png)

Dalej, należy utworzyć plik Dockerfile do zbudowania kontenera blueocean:

![alt text](./img/dockerfile.png)

Budujemy kontener z wykorzystaniem polecenia:

    docker build -t myjenkins-blueocean -f Dockerfile.blueocean .

![alt text](./img/image8.png)    

Uruchomienie utworzonego wcześniej obrazu kontenera:

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

![alt text](./img/image18.png)

Podobnie jak poprzednio wszystkie parametry zostały dokładnie opisane w dokumentacji.

## Konfiguracja wstępna i pierwsze uruchomienie

Jenkins domyślne dotępny jest dla nas w przeglądarce jako localhost na porcie 8008 dzięki odpowiedniej konfiguracji kontenerów która opiana zotała powyżej.

Po odblokowaniu i pierwszym uruchomieniu Jenkinsa (co pokazane zotało w poprzednim prawozdaniu) ukazuje się nam ekran konfiguracji i zotajemy poprozeni o zaintalowanie pluginów. W tym wypadku została wybrana opcja intalacja standardowa: 

![alt text](./img/image16.png)

Utworzenie konta adminitratora:

![alt text](./img/image11.png)

![alt text](./img/image2.png)

Konfiguracja zakończona:

![alt text](./img/image1.png)

## Utworzenie projektów

Aby utworzyć nowy projekt wybieramy odpowiednia opcje dotępną po lewej tronie ekranu gdzie natępnie możemy nadać mu nazwę oraz okrelić jego typ:

![alt text](./img/image7.png)

Przedoimy ię do zakładki konfiguracji gdzie natępnie w ekcji kroki budowania możemy umieścić treść polecenia, które ma się wykonać po uruchomieniu projektu:

![alt text](./img/image14.png)

Test utworzonego projektu:

![alt text](./img/image9.png)

Natępny test polega na utworzeniu skryptu ktory wyświetla błąd jeśli godzina jest nieparzysta. Jego kod io wynik działania widoczny jest poniżej:

    #!/bin/bash

    HOUR=$(date +%H)
    HOUR=$((10#$HOUR))  

    if [ $((HOUR % 2)) -ne 0 ]; then
        echo "Błąd: Godzina ($HOUR) jest nieparzysta!"
        exit 1
    else
        echo "OK: Godzina ($HOUR) jest parzysta."
        exit 0
    fi

![alt text](./img/image5.png)

Na zakończenie wypróbowano działanie docker in docker. Pierwsze próby zakończyły się niepowodzeniem.

![alt text](./img/image10.png)

Restart kontenera dind naprawił sytuacje: 

![alt text](./img/image20.png)

![alt text](./img/image19.png)

## Utworzenie pierwszego pipelinea

Tworzyny nowy obiekt pipeline analogicznie jak tworzyliśmy poprzednie projekty, jednak z menu wybierając odpowiedni tym projektu.
Pipeline to zautomatyzowany zestaw kroków, które są wykonywane w celu zbudowania, przetestowania i wdrożenia aplikacji. Pozwala zdefiniować cały proces w pliku konfiguracyjnym co umożliwia powtarzalność i automatyzację.

W pierwszym etapie, klonowane jest zdalne repozytorium Git włanie w nim znajduje się dockerfile którego będziemy używać. Najpierw próbuje się usunąć istniejący obraz Dockera, jako zabezpieczenie przed ewentualnymi błędami. Potem usuwane są wszystkie nieużywane dane i cache'e builda Dockera. Na końcu tworzony budowany jest obraz według z podanego Dockerfilea.

    pipeline {
        agent any

        stages {
            stage('Clone') {
                steps {
                    git branch: 'AZ416400', 
                        url: 'https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
                }
            }

            stage('Build') {
                steps {
                    dir('ITE/GCL08/AZ416400/Sprawozdanie1/Dockerfiles') {
                        sh 'docker rmi -f irssi-build || true'
                        sh 'docker builder prune --force --all'
                        sh 'docker build -t irssi-build -f Dockerfile.irssibld .'
                    }
                }
            }
        }
    }

![alt text](./img/image6.png)

Uruchomienie skryptu:

![alt text](./img/image13.png)

![alt text](./img/image3.png)

![alt text](./img/image17.png)

![alt text](./img/image4.png)

Obserwując czay wykonania obu pipelineów możemy zauważyć podobne wynki czasowe, co sugeruje, że oba pipeline'y wykonały tę samą pracę i żadne czynności nie zostały pominięte chociażby poprzez cache'owanie

