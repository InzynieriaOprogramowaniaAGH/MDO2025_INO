Lab 1 Git wprowadzenie
1. Instalacja Git i obsługa kluczy SSH
Na początku zainstalowano klienta Git oraz sprawdzono obecność obsługi SSH. Umożliwia to klonowanie repozytoriów i uwierzytelnianie się za pomocą kluczy kryptograficznych.

2. Klonowanie repozytorium przedmiotowego przez HTTPS z użyciem Personal Access Token (PAT)
Repozytorium zostało sklonowane z wykorzystaniem adresu HTTPS. Ze względu na wymogi bezpieczeństwa (brak wsparcia dla login/hasło), do uwierzytelnienia użyto Personal Access Token wygenerowanego na stronie GitHub.
[ITE/GCL06/BM417353/Sprawozdanie 1/Zrzuty ekranu/Zrzut ekranu (102).png](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/25693861ac96ded84a2f349056de99a50ce603ee/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(102).png)

4. Klonowanie repozytorium z użyciem protokołu SSH
Po poprawnym dodaniu klucza SSH, sklonowano repozytorium ponownie, tym razem za pomocą protokołu SSH. Zapomniałem zrobić tutaj zrzut ekranu, mam tylko z już sklonowanym repozytorium.

5. Konfiguracja 2FA 
Na koncie GitHub została skonfigurowana opcja 2FA (Two-Factor Authentication) przy użyciu aplikacji autoryzującej, Google Authenticator.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1d67a17d42376e0a71f375d8b5656705aa5e4cf4/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(159).png

6. Utworzenie nowej gałęzi „inicjały & nr indeksu”
Zgodnie z poleceniem, utworzono nową gałąź, odgałęziając się od gałęzi grupowej.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/4163d7312daa50391f00a459c8c9cee3d178132a/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(160).png
10. Utworzenie katalogu o tej samej nazwie co gałąź
W katalogu grupowym utworzono nowy folder odpowiadający nazwie gałęzi.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1d67a17d42376e0a71f375d8b5656705aa5e4cf4/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(104).png
11. Napisanie i dodanie Git hooka
Stworzono prosty hook commit-msg, który sprawdza, czy komunikat commita zaczyna się od odpowiednich inicjałów i numeru indeksu. Niestety nie hook nie zadziałał poprawnie przesyłam wersje hooka jaką zamierzałem wykorzystać.
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



