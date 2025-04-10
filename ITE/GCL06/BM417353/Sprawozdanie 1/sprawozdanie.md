Lab 1 Git wprowadzenie
1. Instalacja Git i obsługa kluczy SSH
Na początku zainstałem klienta Git oraz sprawdziłem obecność obsługi SSH. Umożliwia to klonowanie repozytoriów i uwierzytelnianie się za pomocą kluczy kryptograficznych. Niestety nie mam zrzutu z tej operacji.

2. Klonowanie repozytorium przedmiotowego przez HTTPS z użyciem Personal Access Token (PAT)
Repozytorium sklonowałem z wykorzystaniem adresu HTTPS. Ze względu na wymogi bezpieczeństwa (brak wsparcia dla login/hasło), do uwierzytelnienia użyłem Personal Access Token wygenerowanego na stronie GitHub.
[ITE/GCL06/BM417353/Sprawozdanie 1/Zrzuty ekranu/Zrzut ekranu (102).png](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/25693861ac96ded84a2f349056de99a50ce603ee/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(102).png)

4. Klonowanie repozytorium z użyciem protokołu SSH
Po poprawnym dodaniu klucza SSH, sklonowałem repozytorium ponownie, tym razem za pomocą protokołu SSH. Zapomniałem zrobić tutaj zrzut ekranu, mam tylko z już sklonowanym repozytorium.

5. Konfiguracja 2FA 
Na koncie GitHub została skonfigurowana opcja 2FA (Two-Factor Authentication) przy użyciu aplikacji autoryzującej, Google Authenticator.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1d67a17d42376e0a71f375d8b5656705aa5e4cf4/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(159).png

6. Utworzenie nowej gałęzi „inicjały & nr indeksu”
Zgodnie z poleceniem, utworzyłem nową gałąź, odgałęziając się od gałęzi grupowej.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/4163d7312daa50391f00a459c8c9cee3d178132a/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(160).png
10. Utworzenie katalogu o tej samej nazwie co gałąź
W katalogu grupowym utworzyłem nowy folder odpowiadający nazwie gałęzi.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1d67a17d42376e0a71f375d8b5656705aa5e4cf4/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(104).png
11. Napisanie i dodanie Git hooka
Stworzyłęm prosty hook commit-msg, który sprawdza, czy komunikat commita zaczyna się od odpowiednich inicjałów i numeru indeksu. Niestety nie hook nie zadziałał poprawnie przesyłam wersje hooka jaką zamierzałem wykorzystać.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1d67a17d42376e0a71f375d8b5656705aa5e4cf4/ITE/GCL06/BM417353/Sprawozdanie%201/githook
12. Wysłanie zmian do zdalnego repozytorium
Po wykonaniu wszystkich zmian, zostały one dodane, zatwierdzone i wypchnięte do zdalnego repozytorium.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1d67a17d42376e0a71f375d8b5656705aa5e4cf4/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(103).png
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/69d55fc3f388456a3d76c6075815eda794f868ec/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(101).png

Lab 2
Git, Docker
1. Zestawienie środowiska
System operacyjny: Linux (Fedora)
Instalacja Dockera została wykonana z repozytorium dystrybucji (APT), bez użycia Snap.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/f069544e0b1ee19eef1c76e68588cfef9a0742f2/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(110).png
2. Rejestracja w Docker Hub i pobieranie obrazów
Utworzyłem konto na hub.docker.com i zapoznałem się z dostępnymi, oficjalnymi obrazami. Następnie pobrałem obrazy: hello world busybox ubuntu fedora mysql
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/dc5b6e3530f0904cb2fd60d653acf6fdeadf753f/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(133).png
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/f069544e0b1ee19eef1c76e68588cfef9a0742f2/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(111).png
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/094b7978cf929a24c4efa8aff332e70788e9821f/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(115).png
4. Uruchomienie kontenera z obrazu busybox
Za pomocą polecenia docker run busybox echo "Hello from Busybox!" uruchomiono jednorazowy kontener na podstawie obrazu busybox. Kontener poprawnie wykonał polecenie i zwrócił komunikat tekstowy, co potwierdziło jego działanie.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/2b7b9443660d27e651d1e4aeb261949236cf6a71/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(113).png
5. Podłączenie do kontenera interaktywnie 
Uruchomiłem kontener w trybie interaktywnym z dostępem do terminala (sh) używając polecenia docker run -it busybox sh.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/2b7b9443660d27e651d1e4aeb261949236cf6a71/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(123).png
6. System w kontenerze (Fedora/Ubuntu)
Uruchomiłem kontener z obrazem systemu ubuntu w trybie interaktywnym, co pozwoliło mi na pełny dostęp do powłoki systemowej. Wewnątrz kontenera sprawdziłem PID procesu 1, a na hoście przeanalizowałem aktywność demona Dockera (ps aux | grep dockerd), aby zobaczyć powiązania kontenera z hostem.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/aadb66116d16e16747cf2577a9269d77be71cb66/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(116).png
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6709bf8306ce078314b77ba273168b08cd103bd0/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(117).png
7. Aktualizacja pakietów w kontenerze
W kontenerze uruchomionym z systemem Ubuntu wykonałem polecenie upgrade -y, aby zaktualizować wszystkie dostępne pakiety systemowe. Po zakończeniu procesu aktualizacji, zakończyłem pracę w kontenerze komendą exit.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6709bf8306ce078314b77ba273168b08cd103bd0/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(116).png
8. Stworzenie własnego obrazu z Dockerfile
Utworzyłem plik Dockerfile, który bazuje na obrazie fedora:latest i zawiera instrukcje instalacji Gita za pomocą menedżera pakietów dnf, a także klonowania zdalnego repozytorium z GitHuba do katalogu roboczego /app. Dzięki użyciu dnf clean all, obraz jest lżejszy i zgodny z dobrymi praktykami.
Obraz zbudowałem przy użyciu polecenia docker build -t my-fedora-git ., a następnie uruchomiłem kontener interaktywnie, sprawdzając zawartość katalogu /app, aby upewnić się, że repozytorium zostało poprawnie sklonowane.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6709bf8306ce078314b77ba273168b08cd103bd0/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(118).png
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6709bf8306ce078314b77ba273168b08cd103bd0/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(120).png
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/b84cc41d4f8df4562f23fca6888add95467d725f/ITE/GCL06/BM417353/Sprawozdanie%201/Dockerfile
10. Zarządzanie kontenerami i obrazami
Za pomocą docker ps -a sprawdziłem wszystkie utworzone kontenery, zarówno aktywne, jak i zakończone. Następnie wykonałem komendy docker container prune -f, aby wyczyścić środowisko z niepotrzebnych kontenerów i obrazów.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6709bf8306ce078314b77ba273168b08cd103bd0/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(122).png
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/6709bf8306ce078314b77ba273168b08cd103bd0/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(124).png

Lab 3

1. Wybór oprogramowania – irssi
Na potrzeby laboratorium wybrałem aplikację irssi – przedstawioną na zajęciach. Projekt dostępny jest publicznie na GitHubie. Repozytorium zawiera wymagane pliki Makefile.am, configure.ac oraz zestaw testów jednostkowych.

2. Build i test lokalnie (poza kontenerem)

Sklonowałem repozytorium:
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/38f67548a0d7679234a8721ea9db64610f779d2d/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(172).png

Zainstalowałem wymagane pakiety:
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a2816b2e7af7e59ed983f71c35b85713c02376d0/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(171).png

Następnie wykonałem proces konfiguracji, builda i testów:
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a2816b2e7af7e59ed983f71c35b85713c02376d0/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(173).png
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a2816b2e7af7e59ed983f71c35b85713c02376d0/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(174).png

3. Praca w kontenerze – build i test interaktywnie

Uruchomiłem kontener bazowy z obrazem ubuntu oraz podłączyłem się w trybie interaktywnym użyłem polecenia "docker run -it --name irssi-build ubuntu:latest /bin/bash":

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1c1c23e8acaca91978532cb084c2bf3c62d36e93/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(161).png

W kontenerze zainstalowałem potrzebne pakiety:
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1c1c23e8acaca91978532cb084c2bf3c62d36e93/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(162).png

Sklonowałem repozytorium i zrobiłem builda:
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1c1c23e8acaca91978532cb084c2bf3c62d36e93/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(166).png

Przeprowadziłem testy wewątrz kontenera:
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1c1c23e8acaca91978532cb084c2bf3c62d36e93/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(167).png

4. Dockerfile 1 – Budowanie aplikacji
Ten plik Dockerfile tworzy obraz bazujący na Ubuntu, w którym instalowane są wszystkie niezbędne zależności potrzebne do zbudowania aplikacji irssi. Zawiera też instrukcje sklonowania repozytorium, przygotowania środowiska (autogen, configure) oraz kompilacji kodu za pomocą make. Pojawiły się problemy ostatnim krokiem dockerfile, ale zostały rozwiązane przez dodanie perla do dockerfile.

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/bcfbb9b4504d3fc85b31427b7c9cb50f363ca8ae/ITE/GCL06/BM417353/Sprawozdanie%201/Dockerfile.build

Wykonałem build za pomocą dockerfile:
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/bcfbb9b4504d3fc85b31427b7c9cb50f363ca8ae/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(127).png

5. Dockerfile 2 – Uruchamianie testów na bazie pierwszego obrazu
Drugi Dockerfile oparty jest na obrazie wygenerowanym z pierwszego pliku i nie wykonuje już kompilacji, lecz jedynie uruchamia testy jednostkowe. Dzięki temu proces testowania jest szybszy i bardziej modularny, a także oddzielony logicznie od etapu budowania.

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/bcfbb9b4504d3fc85b31427b7c9cb50f363ca8ae/ITE/GCL06/BM417353/Sprawozdanie%201/Dockerfile.test

Przeprowadziłem testy przy użyciu dockerfile.test:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/bcfbb9b4504d3fc85b31427b7c9cb50f363ca8ae/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(128).png

6. Budowanie obrazów
Obrazy tworzy się za pomocą polecenia docker build, w którym określa się nazwę oraz plik Dockerfile, z którego ma zostać zbudowany obraz. Proces budowania automatycznie pobiera zależności, wykonuje komendy z Dockerfile i tworzy gotowe środowisko pracy.
Budowanie obrazu buildującego:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/51056805b7e996ccd3614f2facf38994af18a2f9/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(175).png

Budowanie obrazu testującego:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/51056805b7e996ccd3614f2facf38994af18a2f9/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(176).png

Uruchomienie kontenera testowego:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/51056805b7e996ccd3614f2facf38994af18a2f9/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(177).png

Różnica między konteneram a obrazem:

Obraz w Dockerze to niezmienny szablon zawierający wszystkie potrzebne elementy do uruchomienia aplikacji – system operacyjny, zależności, kod źródłowy i instrukcje uruchomienia. Kontener natomiast to działający, uruchomiony z obrazu proces, który posiada własną przestrzeń nazw, system plików i środowisko wykonawcze, ale współdzieli jądro z systemem hosta. To właśnie kontener „pracuje” – wykonuje polecenia zdefiniowane w obrazie, np. kompiluje kod, uruchamia testy czy działa jako serwer. Obraz jest tylko instrukcją, a kontener to jego realizacja w działającym środowisku. W tym przypadku kontener uruchamia procesy takie jak make build lub make test, rzeczywiście wykonując kompilację i testy aplikacji irssi wewnątrz odizolowanego środowiska.

Lab 4 Dodatkowa terminologia w konteneryzacji, instancja Jenkins

1. Zachowywanie stanu – woluminy wejściowy i wyjściowy
Klonowanie repozytrium bez git
Tworzenie woluminów zdrzut z stworzonymi woluminami za pomocą poleceń docker volume create volumin_wej, docker volume create volumin_wyj:
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/0900bb534c152f43c961b03d9a1cd605c59ccfa5/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(140).png

Uruchomienie kontenera bazowego bez git (Użyłem obrazu fedora, który ma już narzędzia do budowania).
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/0841b6bd2f39492f4ab0a236e062c3751b864983/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(136).png

W kontenerze: Instalacja zależności:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/0900bb534c152f43c961b03d9a1cd605c59ccfa5/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(143).png

Klonowanie repozytorium na wolumin wejściowy (z poziomu hosta):

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/d98b097d55dd3314f33a415b66197fcf270d6419/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(141).png

Kompilacja i zapis wyników na woluminie wyjściowym: We wnętrzu kontenera:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/ddfed437f6bdaf6a2b2670d80f5ebcd148696c11/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(143).png
Weryfikcja:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/42cc7bec6ae24586ee4e3a72a2775440659d973f/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(142).png

Opis jak wykonałem kolowanie bez użycia git: 
Wykonałem zadanie polegające na klonowaniu repozytorium bez użycia Gita, wykorzystując woluminy Dockera jako sposób na przekazanie danych do kontenera. Na początku utworzyłem dwa woluminy przy pomocy poleceń docker volume create wolumin_wej oraz docker volume create wolumin_wyj, które odpowiednio odpowiadały za dane wejściowe i wyjściowe. Następnie uruchomiłem kontener o nazwie zadanie4, bazujący na obrazie fedora:latest, z zamontowanymi wcześniej utworzonymi woluminami. Kontener uruchomiłem z dostępem do terminala (TTY), aby pracować w nim interaktywnie.

Po wejściu do kontenera wykonałem aktualizację repozytoriów i zainstalowałem potrzebne narzędzia buildowe, takie jak make, gcc, meson oraz ninja-build, jednak  bez gita. Upewniłem się, że git nie jest dostępny, wpisując which git, co zwróciło komunikat informujący o jego braku.

Repozytorium projektu przeniosłem do kontenera bezpośrednio z hosta, korzystając z polecenia docker cp, wskazując lokalizację projektu na moim systemie oraz docelowy katalog /dane_wej/irssi wewnątrz kontenera. W ten sposób „sklonowałem” repozytorium bez korzystania z git.

Po przekopiowaniu projektu przeszedłem do katalogu /dane_wej/irssi w kontenerze, uruchomiłem konfigurację przy pomocy meson setup build, a następnie wykonałem kompilację komendą ninja -C build. Wytworzone pliki binarne oraz cały katalog build skopiowałem do katalogu /dane_wyj, czyli na wolumin wyjściowy, który służył do trwałego przechowywania wyników, na zrzucie jest to udokomentowane w fomie histori poleceń dokera.

Na koniec, w osobnym terminalu na hoście, sprawdziłem zawartość woluminu wyjściowego, uruchamiając tymczasowy kontener alpine i wypisując pliki przy pomocy ls -la /sprawdz/build, upewniając się, że build został wykonany poprawnie i pliki są dostępne po zamknięciu kontenera.

2. Ponowienie z klonowaniem w kontenerze (z git):

Uruchomienie nowego kontenera z git:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af7f53cc69fee54520d9b6256563dd0414b9f4cc/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(3).png

Wewnątrz kontenera:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/42cc7bec6ae24586ee4e3a72a2775440659d973f/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu(4).png

3. Stworzenie dedykowanej sieci mostkowej
Tworzymy sieć o nazwie siec_testowa:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/321149722bd72e6b908c415dd10aa3dd4bd99145/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(180).png

4. Uruchomienie kontenera z serwerem iperf3

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/810035edaed7193c8877ae2b65c77c8c553c411a/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(182).png

5. Uruchomienie klienta iperf3 w drugim kontenerze

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/810035edaed7193c8877ae2b65c77c8c553c411a/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(181).png

6. Połączenie z hosta (spoza kontenera)

Najpierw uruchomienie iperf_server, ale z eksponowanym portem:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/810035edaed7193c8877ae2b65c77c8c553c411a/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(184).png

Teraz połączenie z hosta:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/810035edaed7193c8877ae2b65c77c8c553c411a/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(183).png

7.Instancja Jenkins stworzenie sieci jenkins

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/905074d509e011c0984c04c4cf9689542cc30bcd/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(186).png

8. Stworzenie woluminów do trwałego przechowywania danych:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/905074d509e011c0984c04c4cf9689542cc30bcd/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(186).png
9. Uruchomienie kontenera pomocniczego (Docker-in-Docker)

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/905074d509e011c0984c04c4cf9689542cc30bcd/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(186).png\

10. Uworzenie własnego pliku dockerfile jenkins:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/905074d509e011c0984c04c4cf9689542cc30bcd/ITE/GCL06/BM417353/Sprawozdanie%201/Zajecia04/Dockerfile.jenkins

11. Zbudowanie obrazu:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/905074d509e011c0984c04c4cf9689542cc30bcd/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(186).png

12. Uruchomienie jenkins (pojawiłły się problemy z zajętym już portem 8080, ale udało mi się go zwolnić):

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/879ceff187530f3168f8355a3094aa11bcfaf17e/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(5).png

13. Sprawdźenie logów:

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/879ceff187530f3168f8355a3094aa11bcfaf17e/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(6).png

14: Zalogowanie w jenkins: 

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/879ceff187530f3168f8355a3094aa11bcfaf17e/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(156).png


