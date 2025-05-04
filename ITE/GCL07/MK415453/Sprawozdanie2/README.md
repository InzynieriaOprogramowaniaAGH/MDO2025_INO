# LAB 5 - Jenkins pipeline
## Zadanie 1 
Utworzenie 2 projektów. Pierwszy polegał na wyświetlenie polecenia uname. Drugi polegał na napisaniu skryptu, który zwraca błąd, gdy godzina jest nieparyzsta. \
Pierwszy projekt:
![alt text](images/uname.png)
![alt text](images/unamekod.png)
Drugi projekt: 
![alt text](images/hourcode.png)
![alt text](images/hourscript.png)
![alt text](images/hourresult.png)

# LAB 6/7 - Pipeline do własnego projektu
## Wykorzystanie projektu nodedummytest.js 
Diagram:
![alt text](<images/Diagram.png>)
Dodany credentials:
![alt text](<images/Credentials.png>)
Stworzony [Jenkinsfile](dockers/Jenkinsfile) z wykorzystaniem następujących plików:
* [Builder](dockers/Dockerfile.builder) - budowanie środowiska
* [Test](dockers/Dockerfile.test) - uruchamianie testów
* [Deploy](dockers/Dockerfile.deploy) - przygotowanie do wdrozenia

Screany z pomyślnie wykonanych kroków:
* Clone ![alt text](images/clone.png)
* Build ![alt text](images/build.png)
* Test ![alt text](images/test.png)
* Deploy ![alt text](images/deploy.png)
* Curl ![alt text](images/curl.png)
* Artefakt ![alt text](images/artefakt.png)
* Dockerhub ![alt text](images/wypchaniedodockerhub.png)
![alt text](images/dockerhub.png)
* Done ![alt text](images/dzialaessa.png)
* Zakończony pipeline ![alt text](images/dzialaessav2.png)
* Sprawdzenie czy dobrze się wszystko czyści, czyli uruchomienie pipeline jeszcze raz ![alt text](images/dziala2razy.png)


# Dyskusja - omówienie etapów pipeline'u
## Stage: Clean

Na tym etapie środowisko robocze jest czyszczone z poprzednich danych. Pozwala to uniknąć problemów wynikających z pozostałości po wcześniejszych buildach, zapewniając czysty start całego procesu.

## Stage: Collect
Etap odpowiedzialny za przygotowanie środowiska. Usuwa istniejące kopie repozytorium, klonuje je ponownie, przełącza się na odpowiedni branch i tworzy pliki logów. Dzięki temu mamy pewność, że pracujemy na świeżym, aktualnym kodzie w stabilnym środowisku.

## Stage: Build
Na tym etapie budowany jest obraz kontenera na podstawie [Dockerfile.builder](dockers/Dockerfile.builder). Celem jest utworzenie środowiska, w którym aplikacja może być kompilowana lub przygotowywana do testowania. Jest to kluczowy krok dla weryfikacji poprawności środowiska buildowania.

## Stage: Test
Ten etap odpowiada za przygotowanie kontenera testowego. Budowany jest obraz przy użyciu [Dockerfile.test](dockers/Dockerfile.test), który pozwala uruchamiać automatyczne testy. Jest to ważny punkt kontrolny pozwalający wykryć błędy przed wdrożeniem.

## Stage: Deploy
Obraz aplikacji jest budowany z użyciem [Dockerfile.deploy](dockers/Dockerfile.deploy), uruchamiany w kontenerze oraz podłączany do utworzonej wcześniej sieci. Umożliwia to działanie aplikacji w warunkach przypominających środowisko produkcyjne.

## Stage Test HTTP
Weryfikacja dostępności aplikacji. Kontener curl sprawdza, czy endpoint HTTP aplikacji jest aktywny i odpowiada. To proste, ale bardzo przydatne sprawdzenie końcowej funkcjonalności po wdrożeniu.

## Stage Artefact
Zawartość aplikacji jest kopiowana z kontenera i pakowana jako plik .tgz. Taki artefakt użyty jest potem do dalszego wdrażania, archiwizacji i publikacji w systemach dystrybucyjnych.

## Stage: Publish
Gotowy obraz aplikacji jest logowany i wypychany do DockerHub. To pozwala na łatwe udostępnienie i ponowne wykorzystanie obrazu w innych środowiskach — np. produkcyjnym lub testerskim.

## Post Actions
Po zakończeniu całego pipeline’u wyświetlana jest informacja końcowa, sygnalizująca jego zakończenie. W fazie cleanup automatycznie usuwany jest uruchomiony kontener aplikacji, co pozwala na zwolnienie zasobów systemowych. Dzięki temu nie ma potrzeby ręcznego czyszczenia środowiska — co w przeszłości prowadziło do nieoczekiwanych problemów z brakiem miejsca na maszynie wirtualnej. Automatyzacja tego kroku zapobiega też potencjalnym konfliktom przy kolejnych uruchomieniach.