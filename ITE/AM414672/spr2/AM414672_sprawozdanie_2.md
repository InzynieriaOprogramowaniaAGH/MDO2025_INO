## Zajecia 4

# Woluminy

Tworzymy plik Dockerfile.

![git](lab4/1.png)

Budujemy kontener.

![create](lab4/2.png)

Tworzymy wolumin wejściowy i wyjściowy.

![vols](lab4/3.png)

Kopiujemy repozytorium na wolumin wejściowy.

![coping](lab4/4.png)

Odpalamy wolumin z podłączonymi woluminami wejściowym i wyjściowym, oraz sprawdzamy, czy repozytorium zostało poprawnie sklonowane.

![running](lab4/5.png)

Następnie budujemy nasz projekt.

![building](lab4/13.png)

Po zbudowaniu projektu, kopiujemy pliki na wolumin wyjściowy.

![coping](lab4/6.png)

Kopiujemy pliki także na kontener.

![coping](lab4/7.png)

W drugiej wersji nie kopiujemy repozytorium zewnętrznie, lecz wewnątrz naszego kontenera.

![cloning](lab4/14.png)

# iperf3

Pobieramy obraz iperf3 w dockerze.

![downloading](lab4/8.png)

Włączamy serwer iperf3 w Dockerze.

![running](lab4/9.png)

Zapisujemy adres IP naszego serwera w zmiennej, aby móc mieć do niego łatwy dostęp, oraz sprawdzamy, czy został poprawnie zapisany.

![ipping](lab4/10.png)

Łączymy się kontenerem z naszym serwerem podając mu jako IP naszą zmienną.

![connecting](lab4/11.png)

Następnie zatrzymujemy nasz serwer.

![stopping](lab4/12.png)

# iperf3 bridge

Tworzymy sieć którą wykorzystamy jako nasz bridge.

![netting](lab4/17.png)

Tworzymy nasz kontener, oraz odpalamy naszą sieć.

![running](lab4/18.png)

Włączamy test naszej sieci.

![testing](lab4/19.png)

# zapisywanie wyników testówa na woluminach

Tworzymy woluminy dla serwera i klienta.

![creating](lab4/20.png)

Testujemy naszą sieć, oraz zapisujemy wyniki w odpowiednich woluminach.

![saving](lab4/21.png)

Sprawdzamy zapisy w naszych woluminach.

![checking](lab4/22.png)


![checking](lab4/23.png)

# łączenie się z komputerem

Tworzymy serwer z którym będziemy się łączyć.

![making](lab4/24.png)

Instalujemy iperf3 na naszej maszynie.

![installing](lab4/25.png)

Aby połączyć się z serwerem wystarczy użyć adresu localhost.

![running](lab4/26.png)

# Jenkins

Tworzymy sieć dla naszego serwera Jenkins.

![jenk](lab4/27.png)

Odpalamy serwer Jenkins wraz z opcją dind

![jink](lab4/28.png)

![jink](lab4/29.png)

Wyciągamy hasło do Jenkins'a.

![pswd](lab4/30.png)

Upewniamy się, że kontener pracuje poprawnie.

![ver](lab4/31.png)

W ustawieniach VSCode forward'ujemy port 8080, tak aby można było odpalić Jenkins'a spoza maszyny wirtualnej.

![forwd](lab4/32.png)

Logujemy się na Jenkins'a przy użyciu wyciągniętego wcześniej hasła.

![jenk](lab4/33.png)


## lab 5

Tworzymy sieć dla Jenkins'a.

![netting](lab5/1.png)

Odpalamy nasz serwer Jenkins.

![jenking](lab5/2.png)

![jenking](lab5/3.png)

Tworzymy plik Dockerfile dla Jenkins'a z dodatkiem blueocean

![jenking](lab5/4.png)

Budujemy kontener.

![jenking](lab5/5.png)

Odpalamy serwer Jenkins z dodatkiem blueocean.

![jenking](lab5/7.png)

Forward'ujemy port 8080.

![jenking](lab5/8.png)

Wchodzimy na localhost:8080, gdzie pojawi się ekran logowania Jenkins.

![log](lab5/9.png)

Aby znaleźć hasło do Jenkins'a sprawdzamy logi.

![log](lab5/10.png)

![log](lab5/11.png)

Logujemy się na naszej stronie, oraz wykonujemy inicjalizację.

![log](lab5/12.png)

Po udanej inicjalizacji znajdziemy się na głównej stronie Jenkins'a.

![jenk](lab5/13.png)

# Parzysta godzina

Aby wykonać skrypt sprawdzający parzystość obecnej godziny, tworzymy nowy skrypt, a następnie umieszczamy w nim zamieszczony poniej kod wykonywalny.

![script](lab5/14.png)

Następnie wykonujemy kod. W moim przypadku wynik pojawia się jako error, gdy tak skrypt oznacza nieparzyste godziny.

![odd](lab5/15.png)

# pipeline

Aby przejść do następnego kroku, nalezy najpierw stwozyc nowy pipeline. Następnie wybieramy w środku skrypt shell'owy i wklejamy znajudący się ponizej kod.

![pip](lab5/16.png)

Następnie odpalamy nasz pipeline, co utworzy nowy kontener, oraz sklonuje na niego nasze wybrane repozytorium.

![workin](lab5/17.png)

Po pobraniu repozytorium, projekt powinien się zbudować, oraz odpalić testy jednostkowe.

![test](lab5/18.png)


## lab 6/7

Odpalamy jenkinsa z dodatkiem blueocean.

![jenk](lab6/screenshots/1.png)

Po przeprowadzonej inicjalizacji tworzymy nowy Pipeline, do którego zamieszczamy ponizszy plik Jenkinsfile, pozwala on na deploy naszej aplikacji.

![12](lab6/screenshots/12.png)


Tworzymy następujący plik DockerFile, odpowiada on za pobranie aplikację redis, oraz przygotowanie kontenera do jej odpalenia.

![donk](lab6/screenshots/2.png)

Zadaniem kolejnego pliku Dockerfile, jest pobranie aktualizacji, oraz skopiowanie odpowiednich plików, co pozwala na deploy aplikacji.

![cop](lab6/screenshots/5.png)

Odpalenie pipeline powinno zakończyć się sukcesem.

![pip](lab6/screenshots/15.png)

Na tym etapie, mozemy sprawdzić czy nasze kontenery zostały skutecznie zapisane w DockerHub'ie. Z racji wykonania pipeline parę razy mozna zobaczyć kilka kontenerów.

![hub](lab6/screenshots/7.png)

Kolejnym krokiem jest przetestowanie działania deploy'a. W tym celu wykonujemy podaną ponizej komendę, a następnie testujemy czy aplikacja odpala się w przewidywalny sposób.

![pull](lab6/screenshots/9.png)