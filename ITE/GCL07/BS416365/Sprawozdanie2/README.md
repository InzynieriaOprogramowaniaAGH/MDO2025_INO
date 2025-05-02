**Sprawozdanie 2**

Bartosz Skubel 416365
ITE Gr. 7

**Zajęcia 05 - Pipeline, Jenkins, izolacja etapów**

Celem laboratorium było zapoznanie się ze środowiskiem Jenkins, pipeline oraz izolacją CI. Podczas zajęć skonfigurowano Jenkins używając Dockera oraz stworzono pipeline do automatyzacji wszystkich procesów.

1. Utworzenie instancji Jenkins
Sprawdzono działanie curl, który wybrałem do przeprowadzania tych ćwiczeń, przy pomocy:

```make test```

![make test](<Lab 5/1.png>)

Do pobrania i instalacji użyto:

![history](<Lab 5/2.png>)

A następnie stworzono kontener i powtórzono powyższą instalację.

![kontener](<Lab 5/3.png>)

1. Uruchamianie Jenkinsa

Utworzono sieć *jenkins* i woluminy *jenkins_data* i *jenkins_home*.

![sieć, woluminy i obraz Jenkins](<Lab 5/6.png>)

Opisy flag:

    --name jenkins - Nadaje nazwę kontenerowi, w tym przypadku "jenkins".

    --rm - Automatycznie usuwa kontener po jego zatrzymaniu.

    -u root - Uruchamia kontener z uprawnieniami użytkownika root.

    -d - Uruchamia kontener w trybie "detached" (w tle).

    -p 8080:8080 - Mapuje port 8080 z hosta na port 8080 w kontenerze.

    -p 50000:50000 - Mapuje port 50000 z hosta na port 50000 w kontenerze.

    --network jenkins - Łączy kontener z siecią Docker o nazwie "jenkins".

    -v jenkins_data:/var/jenkins_home - Montuje wolumin "jenkins_data" do ścieżki /var/jenkins_home w kontenerze

    -v /var/run/docker.sock:/var/run/docker.sock - Montuje sock Docker-a z hosta do kontenera, umożliwiając kontenerowi zarządzanie Dockerem na hoście

    jenkins/jenkins-lts - Obraz Dockera, na podstawie którego tworzony jest kontener.


Stworzono Dockerfile dla blueocean:

```
FROM jenkins/jenkins:lts
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
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```

Przy pomocy Dockerfile zbudowano obraz:

```
docker build -t myjenkins-blueocean:lts -f Dockerfile.blueocean .
```

![budowanie blueocean](<Lab 5/14.png>)

Na zdjęciu występuje starsza wersja, jednak ostatecznie trzeba było ją zmienić na najnowszą.

Na podstawie obrazu stworzono kontener:

![blueocean](<Lab 5/24.png>)

Opis dla konteneru blueocean:

--name jenkins-blueocean - Nadaje nazwę kontenerowi: jenkins-blueocean.

--restart=on-failure - Automatycznie restartuje kontener, jeśli zakończy się błędem (np. crash).

--detach (-d) - Uruchamia kontener w tle (tryb "detached").

jenkins-data:/var/jenkins_home – Dane Jenkinsa są trwale przechowywane w woluminie jenkins-data.

/var/run/docker.sock:/var/run/docker.sock - Udostępnia Docker socket z hosta do kontenera, umożliwiając Jenkinsowi uruchamianie innych kontenerów (np. dla pipeline'ów Docker-in-Docker).

--privileged - Daje kontenerowi pełne uprawnienia do systemu hosta (dostęp do urządzeń, modułów jądra itp.).

Uzyskano hasło początkowe dla Jenkinsa przy użyciu:

```
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```

![Hasło](<Lab 5/9.png>)

Po odblokowaniu powyższym hasłem Jenkinsa zainstalowano potrzebne wtyczki:

![Wtyczki](<Lab 5/10.png>)

W celu poprawnego użytkowania należało stworzyć pierwszego administratora:

![admin](<Lab 5/11.png>)

Następnie skonfigurowano instancję:

![konfiguracja](<Lab 5/12.png>)

Adres ze zdjęcia to adres maszyny wirtualnej.

Po wykonaniu powyższych kroków możemy się zalogować:

![login](<Lab 5/13.png>)

1. Uruchomienie

Utworzono projekt *uname*

```
uname -a
```

Polecenie wyświetla informacje o systemie operacyjnym i sprzęcie.

![uname-status](<Lab 5/17.png>)
![uname-log](<Lab 5/18.png>)


Utworzono projekt, który zwraca błąd w nieparzystą godzinę:

![Godzina](<Lab 5/19.png>)

Skrypt sprawdza, czy godzina jest podzielna przez 2 i, jeżeli nie jest to zwraca błąd.

Dla godziny 9:
![Godzina-źle](<Lab 5/20.png>)

Dla godziny 10:
![Godzina-dobrze](<Lab 5/22.png>)


Pobieranie *ubuntu*

```
docker pull ubuntu
```

Komenda pobiera obraz *ubuntu*

![Ubuntu](<Lab 5/23.png>)

4. Pipeline

```
pipeline {
    agent any

    stages {
        stage('Zadanie') {
            steps {
                echo 'Klonowanie repozytorium przedmiotowego'
                sh 'git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git'
                dir('MDO2025_INO') {
                    sh 'git checkout BS416365'
                }
                dir('MDO2025_INO/ITE/GCL07/BS416365/curl') {
                    sh '''
                    docker build -f ./Dockerfile.curlbld -t curl-build .
                    docker run --rm curl-build bash -c "curl --version"
                    '''
                }
            }
        }
    }
}

```

Powyższy skrypt klonuje repozytorium przedmiotu, wchodzi w gałąź *BS416365*, tworzy kontener przy pomocy *Dockerfile.curlbld* i wyświetla w nim wersję curla.

![Pipeline_1_raz](<Lab 5/25.png>)

(Log tego wywołania jest zbyt długi, aby go tu zamieścić i znajduje się w <Lab 5/Pipeline_1_uruchomiony_1_raz.txt>)

Pierwsze wywołanie zakończyło się poprawnie.

![Pipeline_2_raz](<Lab 5/26.png>)
![Pipeline_2_raz_log](<Lab 5/27.png>)

Drugie wywołanie pipelinu powoduje błąd, ponieważ repozytorium było już tam skopiowane.

W poprawionym pipelinie zostało to już naprawione:

```
pipeline {
    agent any

    stages {
        stage('Zadanie') {
            steps {
                echo 'Czyszczenie i klonowanie repozytorium przedmiotowego'
                sh '''
                    rm -rf MDO2025_INO
                    git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
                '''
                dir('MDO2025_INO') {
                    sh '''
                        git checkout BS416365
                    '''
                }
                dir('MDO2025_INO/ITE/GCL07/BS416365/curl') {
                    sh '''
                        echo "Czyszczenie dockerowych śmieci"
                        docker container prune -f
                        docker builder prune -f
                        docker image prune -f

                        echo "Budowanie obrazu curl-build"
                        docker build -f ./Dockerfile.curlbld -t curl-build .

                        echo "Testowanie wersji curl wewnątrz kontenera"
                        docker run --rm curl-build bash -c "curl --version"
                    '''
                }
            }
        }
    }
}
```

Poprawiony Pipeline używa *container prune* do usuwania zatrzymanych kontenerów, *builder prune* do usuwania pamięci podręcznej cache i *docker image prune* usuwa wiszące obrazy (te bez tagu i niepowiązane z kontenerami).

![Pipeline_poprawiony](<Lab 5/28.png>)

(Log tego wywołania znajduje się w <Lab 5/Pipeline_1_poprawiony.txt>)

**Zajęcia 06 - Pipeline dla wybranego repozytorium (curl)**

Celem laboratorium było stworzenie procesu CI z pomocą Dockera i Jenkinsa. Stworzono środowiska dla budowania, testowania oraz wdrażania aplikacji.

1. DIND vs CI

DIND polega na uruchomieniu kontenera w kontenerze , co jest bezpieczniejsze, ale wolniejsze od CI, który ma dostęp do hosta i ciągle scala zmiany w kodzie i automatycznie buduje, testuje i raportuje rezultaty.
CI może korzystać z DIND, ale obejmuje znacznie szerszy proces.

2. Digram UML

![Diagram](<Lab 6/curl-deploy-publish.png>)

Diagram przedstawia wstępny Pipeline, na którym możemy się wzorować wdrażając Go dla curla.

3. Builder

```
FROM fedora:41
RUN dnf -y update && \
    dnf -y install gcc make openssl openssl-devel libcurl-devel zlib-devel \
    autoconf automake libtool git wget perl perl-Memoize perl-Test-Harness && \
    dnf clean all

RUN git clone https://github.com/curl/curl.git
WORKDIR /curl
RUN ./buildconf && ./configure --with-openssl && make && make install

CMD ["/bin/bash"]
```

Dockerfile instaluje potrzebne zależności oraz repozytorium git curla a następnie go buduje.

```
docker build -f Dockerfile.curlbld -t curl-build .
```

Tworzymy obraz o nazwie curl-build.

![Builder](<Lab 6/1.png>)

4. Tester

```
FROM curl-build
WORKDIR /curl
CMD ["make", "test"]
```

Przy użyciu poniższej komendy tworzymy obraz testowy.

```
docker build -f Dockerfile.curltest -t curl-test
```

![Tester](<Lab 6/2.png>)

5. Deploy

```
FROM fedora:41
COPY --from=curl-build /usr/local/bin/curl /usr/local/bin/curl
COPY --from=curl-build /usr/local/lib /usr/local/lib
ENV LD_LIBRARY_PATH=/usr/local/lib
CMD ["curl", "--version"]
```

W wersji deploy pobieramy tylko najważniejsze pliki z *curl-build*.

Do pobrania tych plików z *curl-build* używamy tymczasowego kontenera *temp-container*.

![temp-container](<Lab 6/3.png>)

Tymczasowy kontener kopiuje te pliki, a następnie zostaje usunięty.

Kontener deploy budujemy z pomocą:

```
docker build -f Dockerfile.deploy-t curl-final .
```

![Deploy](<Lab 6/4.png>)

6. Uruchomienie kontenera i Smoke Test

Do uruchomienia kontenera najpierw tworzymy sieć CI, a następnie tworzymy kontener, który wykonuje *curl www.metal.agh.edu.pl*, aby sprawdził poprawność wykonania naszej pracy:

![Kontener i Smoke Test](<Lab 6/5.png>)

Smoke Test przeszedł pomyślnie, co oznacza, że poprzednie kroki zostały wykonane poprawnie.

7. Push

```
docker tag curl-final bskubel/curl-final
docker push bskubel/curl-final
```

Tworzymy znacznik obrazu a następnie wysyłamy go do zdalnego repozytorium DockerHub.

![Tag, push](<Lab 6/6.png>)
![DockerHub](<Lab 6/7.png>)

Jak widać na zdjęciu obraz został poprawnie wysłany.

Curl może być dystrybuowany jako obraz Dockera i jest to powszechna praktyka.

8. Publish

```
zip -r curl-binary-v1.zip dist/
```

Powyższa komenda tworzy *.zip* gotowy do dystrybucji.

![ZIP](<Lab 6/8.png>)

Tworzymy archiwum z programem, aby zaoszczędzić na miejscu i przyśpieszyć przesył.

9. Diagram UML a rzeczywistość

W oryginalnym diagramie nie używano tymczasowego kontenera do kopiowania plików z *curl-build*


**Zajęcia 07 - Jenkinsfile dla wybranego repozytorium (curl)**

Celem laboratorium było stworzenie pipeline przy użyciu Jenkinsfile, który będzie automatycznie przeprowadzał wszystkie kroki do uzyskania poprawnego i działającego *curl*.

1. Credentials

Ponieważ wysyłamy obraz na Dockerhub musimy wprowadzić dane logowania w Jenkinsie.

![Credentials](<Lab 7/1.png>)

2. Pipeline from SCM

Tworzymy nowy projekt Pipeline, ale tym razem z użyciem SCM.

![SCM](<Lab 7/2.png>)

3. Jenkinsfile

```
pipeline {
    agent any

    environment {
        IMAGE_CURL_BUILD = 'curl-build'
        IMAGE_CURL_TEST = 'curl-test'
        IMAGE_CURL_FINAL = 'curl-final'
        VERSION = "v${BUILD_NUMBER}"
        ZIP_NAME = "curl-${BUILD_NUMBER}.tar"
    }

    stages {
        stage('Klonowanie repozytorium') {
            steps {
                echo 'Klonuję projekt'
                sh '''
                    rm -rf MDO2025_INO
                    git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
                    cd MDO2025_INO
                    git checkout BS416365
                '''
            }
        }

        stage('Build') {
            steps {
                dir('MDO2025_INO/ITE/GCL07/BS416365/curl') {
                    sh "docker build -f Dockerfile.curlbld -t ${IMAGE_CURL_BUILD} ."
                }
            }
        }

        stage('Test') {
            steps {
                dir('MDO2025_INO/ITE/GCL07/BS416365/curl') {
                    sh '''
                        docker build -f Dockerfile.curltest -t ${IMAGE_CURL_TEST} .
                        docker run --rm ${IMAGE_CURL_TEST}
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                dir('MDO2025_INO/ITE/GCL07/BS416365/curl') {
                    sh '''
                        docker build -f Dockerfile.curlfinal -t ${IMAGE_CURL_FINAL}:${VERSION} .
                        docker run --rm ${IMAGE_CURL_FINAL}:${VERSION} curl --version
                    '''
                }
            }
        }

        stage('Smoke Test') {
            steps {
                echo 'Smoke test do www.metal.agh.edu.pl'
                sh '''
                    docker run --rm ${IMAGE_CURL_FINAL}:${VERSION} curl -s --fail http://www.metal.agh.edu.pl \
                        && echo "SMOKE TEST PASSED" \
                        || echo "SMOKE TEST FAILED"
                '''
            }
        }

        stage('Publish') {
            steps {
                echo 'Publikacja obrazu do archiwum'
                sh '''
                    docker save ${IMAGE_CURL_FINAL}:${VERSION} -o ${ZIP_NAME}
                '''
                archiveArtifacts artifacts: "${ZIP_NAME}", onlyIfSuccessful: true

                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag ${IMAGE_CURL_FINAL}:${VERSION} bskubel/curl-final:${VERSION}
                        docker push bskubel/curl-final:${VERSION}
                    '''
                }
                
            }
        }
    }

    post {
        always {
            echo 'Czyszczenie zasobów'
            sh '''
                docker container prune -f
                docker image prune -f
            '''
        }
    }
}
```

Ważne elementy z powyższego Jenkinsfile:

- agent any: Pipeline może być uruchomiony na dowolnym dostępnej maszynie/workerze agenta Jenkins.

- Definiuje zmienne środowiskowe używane w pipeline:

    IMAGE_CURL_BUILD – nazwa obrazu do budowania curl.

    IMAGE_CURL_TEST – obraz do testów curl.

    IMAGE_CURL_FINAL – obraz końcowy do wdrożenia.

    VERSION – wersja obrazu (tu dynamicznie na podstawie numeru builda).

    ZIP_NAME – nazwa pliku .tar, w którym zostanie zarchiwizowany obraz Dockerowy.

Etapy
1. Klonowanie repozytorium

    Usuwa istniejący katalog MDO2025_INO (jeśli istnieje).

    Klonuje repozytorium Git z GitHuba.

    Przełącza się na gałąź BS416365.

2. Build

    W katalogu z Dockerfile buduje obraz curl-build za pomocą Dockerfile.curlbld.

3. Test

    Buduje obraz testowy curl-test z Dockerfile.curltest.

    Uruchamia kontener z tego obrazu, aby wykonać testy (make test).

4. Deploy

    Buduje finalny obraz produkcyjny curl-final z Dockerfile.curlfinal, oznaczony wersją ${VERSION}.

    Uruchamia kontener i wykonuje curl --version, żeby sprawdzić poprawność obrazu.

5. Smoke Test

    Uruchamia kontener curl-final:${VERSION} i testuje połączenie do http://www.metal.agh.edu.pl.

    Test kończy się powodzeniem lub nie, ale nie przerywa pipeline’u – to prosty test „czy działa”.

6. Publish

    Zapisuje finalny obraz do archiwum.

    Archiwum jest przechowywane jako artefakt w Jenkinsie.

    Loguje się do DockerHuba za pomocą withCredentials.

    Taguje i wysyła obraz do zdalnego repozytorium DockerHub.

![Curl-jenkinsfile](<Lab 7/4.png>)

Jak widać na powyższym zdjęciu proces działa nawet przy kolejnych wykonaniach.

Gotowy produkt tych laboratoriów powinien działać bez problemów i dodatkowych modyfikacji na innych urządzeniach.

**Historia terminala znajduje się w pliku history.txt**