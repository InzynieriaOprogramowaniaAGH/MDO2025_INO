# Pipeline, Jenkins, izolacja etapów

Używając kontenerów z poprzednich zajęć po zalgowaniu się do Jenkins przy pomocy hasła, które można sprawdzić za pomocą komedy: 
```
docker logs jenkins-blueocean
```

Należy pobrano polecane wtyczki oraz utworzono użytkownika, po wykonaniu tych kroków strona Jenkins powinna wyglądać następująco :

![alt text](screeny/lab5-jenkins.png)

Teraz do istniejącego Jenkinsa dodamy plugin BlueOcean. Blue Ocean to po prostu rozszerzony interfejs Jenkinsa z dodatkowymi wtyczkami. Ma nowoczesny bardziej przejrzysty UI wraz z możliwością podglądnięcia pipelino'ow graficznie. 
Na głównej stronie Jenkins'a wybieramy Zarządzaj Jenkinsem -> Dostępne wtyczki, wyszukujemy Blue Ocean oraz instalujemy. Po zainstalowaniu w głównym menu pojawiła się zakładka Open Blue Ocean.

![alt text](screeny/image.png)

![alt text](screeny/lab5-blue.png)

Następnie w lewym górnym rogu wybieramy Nowy Projekt -> Ogólny Projekt i tworzymy nowy projekt. 
W konfiguracji przechodzimy do zakładaki Kroki budowania -> Dodaj krok budowania oraz dodajemy komendę:
```
uname -a 
```

Zapisujemy projeky. Po przekierowaniu po lewej stronie klikamy Uruchom, po chwili w zakładce Builds pojawi się nowe zadanie. Przechodzimy do zadania i z lewego menu wybieramy Logi konsoli. W logach powinniśmy otrzymać następujący wynik.


![alt text](screeny/lab5-proj1.png)

Następnie przystępujemy do tworzenia projektu który zwraca błąd o godzinie nieparzystej. Tak jak w poprzednim przypadku tworzymy nowy projekt w sekcji Dodaj kroki budowania wpisujemy:
```
current_hour=$(date +%H)
hour=$((current_hour + 0))

if [ $((hour % 2)) -ne 0 ]; then
  echo " Obecna godzina ($hour) jest nieparzysta – kończę z błędem!"
  exit 1
else
  echo " Obecna godzina ($hour) jest parzysta – wszystko OK."
fi

```

Po uruchomieniu widzimy że zadanie zakończyło się błędem. W logach możemy sprawdzić kod błędu gdzie widać że wszystko działa jak należy (zadanie zostało uruchomione o godzinie 19).

![alt text](screeny/image-1.png)

## Tworzenie projektu pobierającego Ubuntu

Pojawiły się pewne problemy. Aby możliwe było używanie Dockera w projektach Jenkins, szczególnie gdy Jenkins działa w kontenerze, trzeba zadbać o to, żeby kontener Jenkinsa miał dostęp do silnika Dockera. Ponieważ Jenkins sam działa w kontenerze, nie ma natywnie dostępu do polecenia docker, dlatego musimy ten dostęp zapewnić. Jest to możliwe przez użycie tzw. DIND – czyli Docker-in-Docker. W tym podejściu uruchamiasz osobny kontener docker:dind, który sam w sobie działa jako niezależny silnik Dockera. Jenkins nie wykonuje operacji lokalnie, tylko komunikuje się z tym pomocniczym kontenerem przez sieć – używając zmiennych środowiskowych takich jak DOCKER_HOST. Aby to działało, potrzebny jest też dostęp do certyfikatów TLS, ponieważ docker:dind domyślnie wymaga szyfrowanego połączenia. Kontener Jenkinsa musi mieć zainstalowanego klienta Dockera oraz dostęp do tych certyfikatów, zwykle poprzez zamontowany wolumin.

Konieczne jest także doinstalowanie klienta docker wewnątrz kontenera Jenkins. 
```
docker exec -it jenkins-blueocean bash

apt update
apt install -y docker.io
```
Po tej instalacji możliwe jest wywoływanie komendy docker wewnątrz Jenkinsa – np. w projektach, skryptach lub pipeline’ach – ale te komendy nie wykonują się wewnątrz kontenera, tylko są przekazywane dalej do zewnętrznego silnika Dockera (w tym przypadku DIND,  z którym Jenkins łączy się przez zmienne środowiskowe (DOCKER_HOST, DOCKER_CERT_PATH)).

Po wykonaniu tych kroków możemy używać dockera poprzez projekty i pipelin'y w jenkinsie (czyli docker w dockerze).

W kolejnym projekcie pobieramy obraz docker'a komendą:

```
docker pull ubuntu
```

![alt text](screeny/lab5-ubuntu.png)