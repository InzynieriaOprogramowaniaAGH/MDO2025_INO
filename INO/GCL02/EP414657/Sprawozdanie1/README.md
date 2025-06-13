# Sprawozdanie 1

Emilia Pajdo

Inżynieria Obliczeniowa

------------------------------------------------------------------------

## Zajęcia 1

1.  Pracę nad zadaniami rozpoczęłam od instalacji systemu Fedora Server na maszynie wirtualnej. Następnie, aby połączyć się z systemem Fedora, skorzystałam z protokołu SSH, używając wiersza poleceń w systemie Windows oraz polecenia `ssh root@192.168.8.49`.

    ![logowanie ssh](screenshots/1.png)

    Zainstalowałam klienta Git, korzystając z komendy `sudo dnf install git`.

2.  Po instalacji sklonowałam repozytorium przedmiotowe, używając HTTPS oraz Personal Access Token za pomocą polecenia `git clone https://<LOGIN>:<TOKEN>@github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git`.

    ![klonowanie https](screenshots/2.png)

    Następnie wygenerowałam dwa nowe klucze SSH, inne niż RSA, z czego jeden zabezpieczony hasłem: `ssh-keygen -t ed25519 -C "pajdoemilia@gmail.com"`.

    ![generowanie klucza](screenshots/3.png)

    Po wygenerowaniu każdego z kluczy, skopiowałam ich zawartość używając `cat ~/.ssh/id_ed25519.pub`. Dodałam klucze SSH do swojego konta GitHub.

    ![klucze ssh](screenshots/klucze.png)

3.  Upewnieniłam się, że mam dostęp do repozytorium za pomocą komendy `ssh -T git@github.com`.

    ![dostęp do repozytorium](screenshots/4.png)

    Następnie sklonowałam repozytorium za pomocą protokołu SSH: `git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git`.

    ![klonowanie ssh](screenshots/5.png)

4.  Po sklonowaniu repozytorium, przełączyłam się na gałąź main, a następnie na gałąź grupową poprzez polecenia `git checkout main git checkout GCL02`.

5.  Utworzyłam nową gałąź o nazwie zawierającej moje inicjały i numer indeksu oraz przełączyłam się na nią: `git checkout -b EP414657`.

    ![gałęzie](screenshots/6.png)

6.  W katalogu grupy utworzyłam katalog o nazwie odpowiadającej moim inicjałom i numerowi indeksu: `mkdir EP414657`.

7.  Następnie utworzyłam Git hooka, który weryfikował, czy każdy commit message zaczyna się od moich inicjałów i numeru indeksu. Nadałam mu uprawnienia do wykonywania i skopiowałam go do katalogu `.git/hooks`, aby uruchamiał się przy wykonywaniu commitów: `nano check-commit-msg.sh   chmod +x check-commit-msg.sh   cp check-commit-msg.sh ../.git/hooks/commit-msg`.

    ![tworzenie githooka](screenshots/7.png)

8.  Edytowałam plik `commit-msg`, dodając poniższy skrypt:

    ![Githook treść](screenshots/8.png)

    W przypadku błędnego komentarza do commita wyświetla się następujący komunikat:

    ![Błędny commit](screenshots/9.png)

## Zajęcia 2

1.  Na początku zajęć przeprowadziłam instalację Dockera na systemie Fedora.

    ![instalacja Dockera](screenshots/10.png)

2.  W kolejnym kroku zarejestrowałam się w Docker Hub.

3.  Pobrałam potrzebne obrazy wykorzystując `docker pull`.

    ![pobranie obrazów](screenshots/11.png)

4.  Uruchomiłam kontener z obrazu `busybox` komendą `docker run busybox echo "Hello, world!"`, w celu wypisania wewnątrz kontenera napisu.

    ![busybox](screenshots/12.png)

    Połączyłam się z kontenerem interaktywnie używając `docker run -it busybox sh` i wywołałam numer wersji:

    ![łączenie z kontenerem](screenshots/13.png)

5.  Następnie uruchomiłam system w kontenerze za pomocą `docker run -it fedora bash`.

    ![uruchomienie systemu w kontenerze](screenshots/14.png)

    Wyświetliłam PID1 w kontenerze używając komendy `cat /proc/1/status`:

    ![Wyświetlenie PID1](screenshots/15.png)

    ![wyświetlenie PID1](screenshots/16.png)

    ![wyświetlenie PID1](screenshots/17.png)

    Wyświetliłam procesy Dockera na hoście przy wykorzystaniu `ps aux | grep docker`.

    ![procesy na hoście](screenshots/18.png)

    Następnie zaktualizowałam pakiety poprzez `dnf update -y`.

    ![aktualizacja pakietów](screenshots/19.png)

6.  Stworzyłam plik `Dockerfile`.

    ![tworzenie Dockerfile](screenshots/20.png)

    Treść wyglądała następująco:

    ![Dockerfile](screenshots/21.png)

    Następnie zbudowałam go: `docker build -t my-fedora-image .` i uruchomiłam `docker run -it my-fedora-image bash`.

    ![budowanie i uruchomienie Dockerfile](screenshots/22.png)

    Sprawdziłam czy ściągnięte jest tam odpowiednie repozytorium poprzez komendę `ls /app`.

    ![repozytorium](screenshots/23.png)

7.  Sprawdziłam uruchomione kontenery poprzez `docker ps -a`.

    ![uruchomione kontenery](screenshots/24.png)

    Wyczyściłam je używając komendy `docker rm $(docker ps -aq)`.

    ![czyszczenie kontenerów](screenshots/25.png)

    Usunęłam obrazy poprzez `docker rmi`.

    ![usunięcie obrazów](screenshots/26.png)

    ![usunięcie obrazu](screenshots/27.png)

## Zajęcia 3

1.  Wykonywane na zajęciach zadanie rozpczełam od znalezienia odpowiedniego oprogramowania. Wybrałam zlib - <https://github.com/madler/zlib> - biblioteke do kompresji danych z otwartym kodem żródłowym, która udostępniona jest wraz z narzędziami Makefile.

2.  Zainstalowałam wymagane narzędzia - make oraz gcc - poleceniem `sudo dnf install gcc make -y`:

    ![instalacja make gcc](screenshots/28.png)

3.  Skolonowałam repozytorium do katalogu `zlib`:

    ![klonowanie](screenshots/29.png)

4.  Następnie użyłam polecenia `./configure`, które przygotowuje pliki Makefile i konfiguracje projektu:

    ![configure](screenshots/30.png)

5.  Zbudowałam aplikacje za pomocą `make`:

    ![make](screenshots/31.png)

6.  Uruchomiłam testy jednostkowe zawarte w repozytorium aplikacji za pomocą `make test`:

    ![make test](screenshots/32.png)

7.  Uruchomiłam interaktywny kontener na bazie obrazu Ubuntu, aby przeprowadzić build, a następnie zainstalowałam w nim wymagane pakiety:

    ![uruchomienie kontenera](screenshots/33.png)

8.  Skolonowałam repozytorium aplikacji wewnątrz kontenera:

    ![kolonowanie do kontenera](screenshots/34.png)

9.  Zbudowałam aplikacje w analogiczny sposób jak poza kontenerem, używając `./configure` i `make`:

    ![configure w kontenerze](screenshots/35.png)

    ![make w kontenerze](screenshots/36.png)

10. Na koniec pracy w kontenerze uruchomiłam testy jednostkowe poprzez `make test`, które dały taki sam wynik jak poza kontenerem:

    ![make test w kontenerze](screenshots/37.png)

11. Wyszłam z kontenera używając `exit`:

    ![exit](screenshots/38.png)

12. Stworzyłam plik `Dockerfile-zlib.build`, który miał za zadanie zautomatyzować proces opisany powyzej do etapu builda. Treść `Dockerfile-zlib.build`:

    ![Dockerfile-zlib.biuld](screenshots/39.png)

13. Następnie stworzyłam drugi plik, `Dockerfile.test`, który bazuje na pierwszym pliku i wykonuje testy:

    ![Dockerfile-zlib.test](screenshots/40.png)

14. Zbudowałam obraz pierwszy za pomocą `docker build -f Dockerfile.build -t zlib-build .`:

    ![budowanie obrazu 1](screenshots/41.png)

15. W kolejnym kroku zbudowałam drugi obraz:

    ![budowanie obrazu 2](screenshots/42.png)

16. Uruchomiłam testy z obrazu testowego za pomocą `docker run --rm --name test-container zlib-test`:

    ![testy](screenshots/43.png)

17. Na koniec za pomocą poleceń `docker images` oraz `docker ps -a`, sprawdziłam poprawność działania uruchomionych wcześniej obrazów oraz kontenerów:

    ![obrazy](screenshots/44.png)

    ![kontenery](screenshots/45.png)

## Zajęcia 4

1.  Przygotowałam woluminy: wejściowy i wyjściowy. Użyłam do tego komendy `docker volume create`. Nadałam woluminom nazwy: `wolumin_wejsciowy` oraz `wolumin_wyjsciowy`.

    ![tworzenie woluminów](screenshots/46.png)

    Wolumin wejściowy został stworzony by przechować dane, takie jak repozytorium aplikacji `zlib`, natomiast wolumin wyjściowy miał za zadanie przechować zbudowane pliki.

2.  Uruchomiłam kontener bazowy `Ubuntu` oraz podłączyłam do niego woluminy komendą `docker run -it kontener_bazowy -v wolumin_wejsciowy:/mnt/wejsciowy -v wolumin_wyjsciowy:/mnt/wyjsciowy ubuntu:latest bash`.

    ![kontener bazowy](screenshots/47.png)

3.  Wewnątrz kontenera zainstalowałam wymagane narzędzia poprzez `apt-get update` oraz `apt-get install -y build-essential curl wget`.

    ![instalacja narzędzi](screenshots/48.png)

4.  Następnie sklonowałam repozytorium na wolumin wejściowy. Zrobiłam to poprzez klonowanie repozytorium aplikacji `zlib` z hosta bezpośrednio do woluminu. Po zalogowaniu na swojego hosta w osobnym terminalu użyłam komendy `git clone https://github.com/madler/zlib.git /var/lib/docker/volumes/wolumin_wejsciowy/_data`.

    ![klonowanie repozytorium](screenshots/49.png)

    Metoda ta jest poprawna, jednak uznawana jest za niebezpieczną, ponieważ bezpośrednia edycja katalogu `var/lib/docker` może prowadzić do uszkodzenia danych, konfilktów z Dockerem - Docker nie wie o bezpośrednich zmianach w katalogu woluminów, problemów z bezpieczeństem.

5.  W kontenerze bazowym przeszłam do katalogu `mnt`, a następnie do katalogu `wejsciowy`. Użyłam tam polecenia `ls` aby wyświetlić zawartość. Tym samym sprawdziłam czy repozytorium zostało poprawnie skopiowane.

    ![zawartość katalogu wejsciowy](screenshots/50.png)

6.  W katalogu `wejsciowy` w kontenerze uruchomiłam proces kompilacji aplikacji `zlib`. Najpierw użyłam polecenia `./configure`.

    ![configure](screenshots/51.png)

    Następnie użyłam polecenia `make`.

    ![make](screenshots/52.png)

7.  Skopiowałam skompilowane pliki `libz.a` oraz `zlib.h` na wolumin wyjściowy za pomocą poleceń: `cp libz.a /mnt/wyjsciowy/` oraz `cp zlib.h /mnt/wyjsciowy/`.

    ![kopiowanie skompilowanych plików](screenshots/53.png)

8.  Sprawdziłam zawartość `wyjsciowy` poprzez użycie w nim polecenia `ls`, aby sprawdzić czy pliki zostały poprawnie skopiowane.

    ![wyjsciowy](screenshots/54.png)

9.  W kolejnym kroku doinstalowałam do kontenera gita używając `apt-get update && apt-get install -y git`.

    ![instalacja git](screenshots/55.png)

10. Skolonowałam repoytorium `zlib` do woluminu wewnątrz kontenera za pomocą komendy `git clone https://github.com/madler/zlib.git /mnt/wejsciowy/zlib_rep`.

    ![klonowanie wewnątrz kontenera](screenshots/56.png)

11. Sprawdziłam, używjąc `ls`, zawartość katalogu `zlib_repo`, gdzie sklonowane zostało repozytorium.

    ![zlib_repo](screenshots/57.png)

12. Tak jak poprzednio, uruchomiłam proces kompilacji poprzez `./configure` oraz `make`.

    ![configure](screenshots/58.png)

    ![make](screenshots/59.png)

13. Utworzyłam w katalogu `wyjściowy` katalog `zlib_build`- `mkdir zlib_build`, w celu skopiowania tam wyników kompilacji z woluminu wejściowego.

    ![tworzenie katalogu zlib_build](screenshots/60.png)

14. Następnie skopiowałam tam pliki `libz.a` oraz `zlib.h`poleceniami `cp libz.a /mnt/wyjsciowy/zlib_build/` oraz `cp zlib.h /mnt/wyjsciowy/zlib_build/`.

    ![exit](screenshots/61.png)

15. Sprawdziłam zawartość katalogu `zlib_build` poprzez wykonanie w nim `ls`.

    ![zlib_build](screenshots/62.png)

16. Pobrałam obraz iPerf za pomocą komendy `docker pull networkstatic/iperf3`.

    ![iperf](screenshots/63.png)

17. Uruchomiłam kontener, który pełnił rolę serwera za pomocą `docker run --rm --name iperf-server -p 5201:5201 networkstatic/iperf3 -s`. Uruchamiało to serwer iPerf3 na porcie 5201.

    ![serwer](screenshots/64.png)

18. Następnie uruchomiłam drugi kontener, który łączył się z serwerm. Uruchomienie odbywało się poprzez komendę `docker run --rm --name iperf-client networkstatic/iperf3 -c 172.17.0.1`.

    ![client](screenshots/65.png)

19. Po uruchomieniu kontera-klienta, w kontenerze z serwerem pojawił się wydruk:

    ![serwer wydruk](screenshots/66.png)

20. Poleceniem `docker network create my-bridge-network` utworzyłam własną sieć mostkową.

    ![tworzenie sieci](screenshots/67.png)

21. Uruchomiłam serwer na nowej sieci poprzez `docker run --rm --name iperf-server --network my-bridge-network -p 5201:5201 networkstatic/iperf3 -s`.

    ![serwer na sieci](screenshots/68.png)

22. Uruchomiłam również klienta na nowej sieci, używając nazwy kontenera serwera zamiast adresu IP `docker run --name iperf-client --network my-bridge-network networkstatic/iperf3 -c iperf-server`.

    ![klient na sieci](screenshots/69.png)

23. Po wykonaniu kroku wyżej w kontenerze z serwerem pojawił się wydruk:

    ![serwer wydruk własna sieć](screenshots/70.png)

24. Używając iPerf3 zainstalowanego na hoście wykonałam test przepustowości za pomocą komendy `iperf3 -c 127.0.0.1`.

    ![test host](screenshots/71.png)

25. Wydruk kontenera z serwerem po wykonaniu testu na hoście:

    ![serwer po teście na hoście](screenshots/72.png)

26. Następnie przeprowadziłam test spoza hosta, z innego urządzenia w tej samej sieci. Po zainstalowaniu `iPerf` na urządzenie użyłam komendy `.\iperf3.exe -c 192.168.8.51`.

    ![test spoza hosta](screenshots/73.png)

27. Powyższy krok dał wynik kontenera z serwerem:

    ![serwer po teście spoza hosta](screenshots/74.png)

28. Wyciągnełąm logi z kontenerów i zapisałam je w plikach `server.log` oraz `client.log` za pomocą polecenia `docker logs iperf-server > server.log` oraz `docker logs iperf-client > client.log`.

    ![logi](screenshots/75.png)
    
    Po analizie logów można zauważyć różnice w przepustowości, w zależności od sposobu komunikacji. Pierwszy test obejmował komunikację między dwoma kontenerami uruchomionymi w dedykowanej sieci mostkowej, w wyniku czego osiągnięto wysoką średnią przepustowość wynoszącą 5.76 Gbits/sec, co świadczy o efektywnej wymianie danych w obrębie tej sieci. Drugi test sprawdzał komunikację między kontenerem a hostem systemowym, gdzie zaobserwowano niższą przepustowość – 1.78 Gbits/sec. Trzeci test objął komunikację między kontenerem a urządzeniem spoza hosta w sieci LAN, a średnia przepustowość wyniosła 358 Mbits/sec.

29. Zainstalowałam `Jenkins` w kontenerze używając `docker pull jenkins/jenkins:lts`.

    ![Jenkins](screenshots/76.png)

30. Uruchomiłam instancję Jenkinsa w kontenerze z pomocą DIND poprzez polecenie `docker run --rm -d --name jenkins --network host --privileged \   -p 8080:8080 -p 50000:50000 \   -v jenkins_home:/var/jenkins_home \   -v /var/run/docker.sock:/var/run/docker.sock \   jenkins/jenkins:lts`. Sprawdziłam czy kontener działa poprawnie za pomocą polecenia `docker ps`.

    ![kontener Jenkins](screenshots/77.png)

31. W przeglądarce wpisałam `http://192.168.8.51:8080/`, po czym ukazał się ekran logowania Jenkinsa.

    ![logowanie Jenkins](screenshots/78.png)

32. Uzyskałam hasło administratora poprzez polecenie `docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword`.

    ![uzyskanie hasla](screenshots/79.png)
