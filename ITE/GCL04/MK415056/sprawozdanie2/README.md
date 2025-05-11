## Pipeline, Jenkins, izolacja etapów

### Przygotowanie
Utwórz instancję Jenkins
* Upewnij się, że na pewno działają kontenery budujące i testujące, stworzone na poprzednich zajęciach
* Zapoznaj się z instrukcją instalacji Jenkinsa: https://www.jenkins.io/doc/book/installing/docker/
  * Uruchom obraz Dockera który eksponuje środowisko zagnieżdżone
  * Przygotuj obraz blueocean na podstawie obrazu Jenkinsa (czym się różnią?)
  * Uruchom Blueocean
  * Zaloguj się i skonfiguruj Jenkins
  * Zadbaj o archiwizację i zabezpieczenie logów

Czynności wykonywane zgodnie z instrukcją instalacji
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/1.png)

Utworzenie sieci mostkowej w dockerze

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/2.png)
Uruchomienie obrazu `docker:dind` mające na celu pozwolenie nam wykonywania komend wewnątrz Jenkinsa

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/3.png)
Dostosowanie oficjalnego obrazu Jenkinsa poprzez utworzenie customowego pliku `Dockerfile`

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/4.png)
Zbudowanieobrazu

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/5.png)
Dzięki poniższej komendzie możemy uzyskać dostęp do logów utworzonego kontenera `jenkins-blueocean`, co jest dla nas konieczne, żebyśmy mogli odblokować Jenkinsa:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/6.png)

### Zadanie wstępne: uruchomienie
Zadanie do wykonania na ćwiczeniach
* Konfiguracja wstępna i pierwsze uruchomienie
  * Utwórz projekt, który wyświetla `uname`
  * Utwórz projekt, który zwraca błąd, gdy... godzina jest nieparzysta
  * Pobierz w projekcie obraz kontenera `ubuntu` (stosując `docker pull`)

Wydobyte wcześniej z logów kontenera `jenkins-blueocean` hasło jest nam potrzebne aby dostać się do Jenkinsa i rozpocząć instalację:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/8.png)


Projekt, który wyświetla uname
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/11.png)
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/12.png)
Projekt, który zwraca błąd, gdy... godzina jest nieparzysta
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/13.png)
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/14s.png)
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/14f.png)
Projek pobierający obraz kontenera ubuntu (stosując docker pull)
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/15.png)
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/16.png)


### Zadanie wstępne: obiekt typu pipeline
Ciąg dalszy sprawozdania - zadanie do wykonania po wykazaniu działania Jenkinsa
* Utwórz nowy obiekt typu `pipeline`
* Wpisz treść *pipeline'u* bezpośrednio do obiektu (nie z SCM - jeszcze!)
  * https://www.jenkins.io/doc/book/pipeline/syntax/
  * https://www.jenkins.io/doc/pipeline/steps/git/
  * https://www.jenkins.io/doc/pipeline/examples/#unstash-different-dir
  * [https://www.jenkins.io/doc/book/pipeline/docker/](https://www.jenkins.io/doc/book/pipeline/docker/#building-containers)
* Spróbuj sklonować repo przedmiotowe (`MDO2025_INO`)
* Zrób *checkout* do swojego pliku Dockerfile (na osobistej gałęzi) właściwego dla *buildera* wybranego w poprzednim sprawozdaniu programu
* Zbuduj Dockerfile
* Uruchom stworzony *pipeline* drugi raz

Do wcześniejszego sprawozdania wybrałem bibliotekę [Simple Dynamic Strings - sds](https://github.com/antirez/sds), jednak po skonsultowaniu się w trakcie zajęć okazała się ona niewystarczająca do obecnego sprawozdania. Dlatego w ramach zastępstwa zmieniłem program, na którym bazuje to sprawozdanie na [Redis](https://github.com/redis/redis).

 
### Opis celu
Dla osób z wybranym projektem
* Opracuj dokument z diagramami UML, opisującymi proces CI. Opisz:
  * Wymagania wstępne środowiska
  * Diagram aktywności, pokazujący kolejne etapy (collect, build, test, report)
  * Diagram wdrożeniowy, opisujący relacje między składnikami, zasobami i artefaktami
* Diagram będzie naszym wzrocem do porównania w przyszłości
### Pipeline: składnia
Zadanie do wykonania, jeżeli poprawnie działa obiekt *pipeline* i udało się odnaleźć dostęp do plików Dockerfile
* Definiuj pipeline korzystający z kontenerów celem realizacji kroków `build -> test`
* Może, ale nie musi, budować się na dedykowanym DIND, ale może się to dziać od razu na kontenerze CI. Należy udokumentować funkcjonalną różnicę między niniejszymi podejściami
* Docelowo, `Jenkinsfile` definiujący *pipeline* powinien być umieszczony w repozytorium. Optymalnie: w *sforkowanym* repozytorium wybranego oprogramowania

Plik Jenkinsfile zawierający finalną strukturę pipeline'e

```
pipeline {
    agent any
    stages {
        stage('Cleaning') {
            steps {
                sh "rm -fr MDO2025_INO"
                sh "git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git"
                dir("MDO2025_INO") {
                    sh "git checkout MK415056"
                }
            }
        }
        stage('Builder') {
            steps {
                dir("MDO2025_INO") {
                    sh "docker build -t redis-builder -f ITE/GCL04/MK415056/sprawozdanie2/red/Dockerfile ."
                }
            }
        }
        stage('Tester') {
            steps {
                dir("MDO2025_INO") {
                    sh "docker build -t redis-test -f ITE/GCL04//MK415056/sprawozdanie2/red/Dockerfile_test ."
                    sh "docker run redis-test "
                }
            }
        }
	    stage('Deploy') {
            steps {
                   dir("MDO2025_INO") {
    		        sh """ 
                        docker build --no-cache -t marekkubi/pipeline-redis:v1.0.${BUILD_NUMBER} -f ITE/GCL04/MK415056/sprawozdanie2/zaj5/Dockerfile_dep . 
                        docker network inspect network-testing >/dev/null 2>&1 || docker network create network-testing
    		            if [ \$(docker ps -a -q -f name=redis-testing-deploy) ]; then
                            docker rm -f redis-testing-deploy
                        fi
                        docker run -d --name redis-testing-deploy --network network-testing marekkubi/pipeline-redis:v1.0.${BUILD_NUMBER}
                        sleep 10
                        docker run --rm --network network-testing redis redis-cli -h redis-testing-deploy PING | grep PONG
                        docker run --rm --network network-testing redis redis-cli -h redis-testing-deploy SET test_key "MyKey" | grep OK
                        docker run --rm --network network-testing redis redis-cli -h redis-testing-deploy GET test_key | grep MyKey
                        docker stop redis-testing-deploy
                        docker rm redis-testing-deploy
                        docker network rm network-testing
                    """
                }
            }
        }
        stage('Publish') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'pass-dockhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker push marekkubi/pipeline-redis:v1.0.${BUILD_NUMBER}
                        docker tag marekkubi/pipeline-redis:v1.0.${BUILD_NUMBER} marekkubi/pipeline-redis:latest
                        docker push marekkubi/pipeline-redis:latest
                    '''
                }
            }
        }
    }
}
```
### Kompletny pipeline: wymagane składniki
Kompletny *pipeline* (wprowadzenie) - do wykonania po ustaleniu kształu kroków `deploy` i `publish`
*  Kontener Jenkins i DIND skonfigurowany według instrukcji dostawcy oprogramowania
*  Pliki `Dockerfile` wdrażające instancję Jenkinsa załączone w repozytorium przedmiotowym pod ścieżką i na gałęzi według opisu z poleceń README
*  Zdefiniowany wewnątrz Jenkinsa obiekt projektowy *pipeline*, realizujący następujące kroki:
  
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/73a334c8d3cf72b39a4ae6cac7d982cff1cef671/ITE/GCL04/MK415056/sprawozdanie2/scr/21.png)

  * Kontener `Builder`, który powinien bazować na obrazie zawierającym dependencje (`Dependencies`), o ile stworzenie takiego kontenera miało uzasadnienie. Obrazem tym może być np. baza pobrana z Docker Hub (jak obraz node lub 
dotnet) lub obraz stworzony samodzielnie i zarejestrowany/widoczny w DIND (jak np. obraz oparty o Fedorę, doinstalowujący niezbędne zależności, nazwany Dependencies). Jeżeli, jak często w przypadku Node, nie ma różnicy między runtimowym obrazem a obrazem z dependencjami, proszę budować się w oparciu nie o latest, ale o **świadomie wybrany tag z konkretną wersją**


![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/73a334c8d3cf72b39a4ae6cac7d982cff1cef671/ITE/GCL04/MK415056/sprawozdanie2/scr/red1.png)

  * Obraz testujący, w ramach kontenera `Tester`
    * budowany przy użyciu ww. kontenera kod, wykorzystujący w tym celu testy obecne w repozytorium programu
    * Zadbaj o dostępność logów i możliwość wnioskowania jakie testy nie przechodzą

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/73a334c8d3cf72b39a4ae6cac7d982cff1cef671/ITE/GCL04/MK415056/sprawozdanie2/scr/red3.png)

  * `Deploy`
    *  Krok uruchamiający aplikację na kontenerze docelowym
    *  Jeżeli kontener buildowy i docelowy **wydają się być te same** - być może warto zacząć od kroku `Publish` poniżej
    *  Jeżeli to kontener buildowy ma być wdrażany - czy na pewno nie trzeba go przypadkiem posprzątać?
    *  Przeprowadź dyskusję dotyczącą tego, jak powinno wyglądać wdrożenie docelowe wybranej aplikacji. Odpowiedz (z uzasadnieniem i dowodem) na następujące kwestie:
        * czy program powinien zostać *„zapakowany”* do jakiegoś przenośnego pliku-formatu (DEB/RPM/TAR/JAR/ZIP/NUPKG)
        * czy program powinien być dystrybuowany jako obraz Docker? Jeżeli tak – czy powinien zawierać zawartość sklonowanego repozytorium, logi i artefakty z *builda*?
        * Przypomnienie: czym się różni (i jakie ma zastosowanie) obraz `node` od `node-slim`
    *  Proszę opisać szczegółowo proces który zostanie opisany jako `Deploy`, ze względu na mnogość podejść

Plik `Dockerfile.deploy` zawiera informacje potrzebne do stworzenia obrarzu przeznaczonego później do publikacji. 
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/73a334c8d3cf72b39a4ae6cac7d982cff1cef671/ITE/GCL04/MK415056/sprawozdanie2/scr/red3.png)
Powstały obraz docker będzie zawierał niezbędne elementy potrzebne do odpowiedniego funkcjonowania, aplikację redis i serwer. Ten serwer będzie uruchomiony od razu po zbudowaniu no porcie 6379 z wyłączonym ograniczeniem dostępu (--protected-mode no) . Argument (--no cache) powoduje budowanie nowych wersji obrazu bez opierania się na plikach z pamięci cache, zapewniając gwarancję wprowadzenia najnowszych zmian.

  * `Publish`
    * Przygotowanie wersjonowanego artefaktu, na przykład:
      * Instalator
      * NuGet/Maven/NPM/JAR
      * ZIP ze zbudowanym runtimem
    * Opracuj odpowiednią postać redystrybucyjną swojego artefaktu i/lub obrazu (przygotuj instalator i/lub pakiet, ewentualnie odpowiednio uporządkowany obraz kontenera Docker)
      * Musi powstać co najmniej jeden z tych elementów
      * Jeżeli ma powstać artefakt, dodaj go jako pobieralny obiekt do rezultatów „przejścia” *pipeline’u* Jenkins (https://www.jenkins.io/doc/pipeline/steps/core/).
    * Opcjonalnie, krok `Publish` (w przypadku podania parametru) może dokonywać promocji artefaktu na zewnętrzne *registry*


Pomyślne uruchomienie pipeline'u
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/22.png)

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/16.png)
Kilka udanych wersji pipeline'u na dockerhubie dowodzi, że nie jest to jednorazowy sukces.

Połączenie między Jenkinsem i dockerhubem jest możliwe dzięki ustawieniu globalnych Credential'i w agencie Jenkinsa. Ustawione Credentials zawierają dane logowania do dockerhuba i to takie połączenie pozwala publikować obraz kontenera zawierającego nasz program.



![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6f342a6f34b987730cfe540c07da3b76a35ad4ef/ITE/GCL04/MK415056/sprawozdanie2/scr/16.png)
Pobranie obrazu i uruchomienie na jego podstawie kontenera zawierającego w sobie program Redis. 
