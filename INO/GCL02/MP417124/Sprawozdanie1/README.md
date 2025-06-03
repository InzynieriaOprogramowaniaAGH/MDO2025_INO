# Sprawozdanie (Zadania 1-4)

## Wprowadzenie

Celem zadania było zapoznanie się z podstawami systemu kontroli wersji Git oraz obsługą kluczy SSH w celu wygodnego zarządzania repozytoriami na GitHubie. Zadania obejmowały konfigurację Git, kluczy SSH, stworzenie gałęzi, dodanie Git hooka do walidacji commitów oraz wykonanie kilku operacji na repozytorium. Dokumentacja zawiera pełny opis wykonanych kroków, poleceń oraz zrzutów ekranu. Dodatkowo celem zadania było zapoznanie się z Dockerem, instalacją, pobieraniem i uruchamianiem obrazów kontenerów oraz stworzenie własnego obrazu Docker, który będzie zawierał zainstalowanego Gita oraz nasze repozytorium. Dodatkowo, wykonano czyszczenie nieużywanych kontenerów i obrazów.


## Zadanie 1: Wprowadzenie, Git, Gałęzie, SSH

1. **Konfiguracja kluczy SSH:**

   W pierwszym kroku skonfigurowałam klucze SSH, aby umożliwić bezpieczne połączenie z GitHubem. Użyłam klucza typu `ed25519`, który jest bardziej nowoczesny niż RSA.


   - Polecenia:
     ![Generowanie kluczy](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%204.19.21%E2%80%AFPM.png)
   
     ```bash
     ssh-keygen -t ed25519 -C "nazwa"
     ```
     Po utworzeniu klucza SSH skopiowałam go i dodałam do swojego konta GitHub, postępując zgodnie z dokumentacją na GitHubie.

   - Zrzut ekranu:
     ![Zrzut ekranu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%204.27.12%E2%80%AFPM.png)

## Zadanie 2: Klonowanie repozytorium

2. **Dodanie klucza:**

   Następnie skopiowałam repozytorium poporzez usługę SSH, korzystając z odpowiedniego polecenia. 
   - Polecenia:
     ```bash
     git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
     ```
   I zgodnie z poleceniem włączyłam 2FA na GitHub, aby zwiększyć bezpieczeństwo konta.
   
## Zadanie 3: Tworzenie i przełączanie się na gałąź

3. **Przełączenie się na odpowiednią gałąź i utworzenie własnej gałęzi:**

   Po sklonowaniu repozytorium przełączyłam się na gałąź główną (main), a następnie na gałąź swojej grupy (GCL02). Utworzyłam nową gałąź o nazwie `MP417124` (moja inicjały i nr indeksu).

   - Polecenia:
     ```bash
     git checkout -b MP417124
     ```

## Zadanie 4: Tworzenie Git Hooka oraz walidacja commitów

4. **Utworzenie Git Hooka do weryfikacji commit message:**

   We właściwym katalogu stworzyłam Git hooka, który weryfikuje, czy commit message zaczyna się od moich inicjałów oraz nr indeksu. W tym celu utworzyłam skrypt w folderze `.git/hooks`.

   - Skrypt Git Hook:
   
     ![Skrypt Git Hook](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%204.31.45%E2%80%AFPM.png)
     

   - Umieszczenie Git Hooka:
     Skrypt został umieszczony w odpowiednim katalogu `.git/hooks/` w folderze repozytorium, aby działał za każdym razem, gdy wykonuję commit.

6. **Dodanie pliku do repozytorium:**

   Po utworzeniu folderu i dodaniu hooka, dodałam wszystkie zmiany do repozytorium oraz wykonałam commit.

   - Polecenia:
     ```bash
     git add .
     git commit -m "message"
     git push origin MP417124
     ```

   - Zrzut ekranu:
     ![Wysłanie zmian na GitHuba](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%205.03.45%E2%80%AFPM.png)


## Zadanie 2: Git, Docker

1. **Instalacja Dockera na systemie Linux**

   Najpierw zaczełam od zaaktualizwoania systemu oraz zainstalowania Dockera poprzez odpowiednie polecenie: `sudo dnf install -y docker` i następnie uruchomiłam go. W kolejnym kroku pobrałam obrazy: `hello-world`, `busybox`, `ubuntu`, `fedora`, `mysql`. W tym celu wykorzystałam polecenie:

```bash
docker pull [obraz]
```

2. **Uruchomienie kontenera z obrazu busyboxa**
Uruchomiłam kontener z obrazu busybox i podłaczyłam się do niego interaktywnie, następnie wywołując numer wersji systemu.

![Zrzut ekranu busybox](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%207.21.19%E2%80%AFPM.png)

3. **Uruchomienie kontenera z obrazu fedora**

Kolejno uruchomiłam kontener z obrazu systemu Fedora. Wyświetliłam procesy w kontenerze w tym PID1. Wyświetliłam procesy dockera na hoście. Najpierw użyłam komendy `docker run -it fedora sh`. Ta komenda uruchomiła interaktywną sesję shell (sh) w kontenerze na bazie obrazu Fedora. Po jej wykonaniu znalazłam się w środowisku kontenera, ale zauważyłam, że nie mogę uruchomić polecenia `ps`, które służy do wyświetlania listy procesów działających w systemie.

![Zrzut ekranu pracy z obrazem fedora_1](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%207.28.55%E2%80%AFPM.png)

Po próbie użycia komendy ps, kontener zwrócił błąd wskazujący na brak tej komendy. Wynika to z faktu, że obraz Fedory nie zawiera domyślnie wszystkich narzędzi, w tym narzędzi do monitorowania procesów. Aby rozwiązać ten problem, zainstalowałem brakujący pakiet, który zawiera komendę ps, wykonując następującą komendę:

```bash
dnf install -y procps-ng
```
Komenda ta zainstalowała pakiet procps-ng, który zawiera narzędzia do monitorowania procesów, w tym ps. Po jej wykonaniu mogłam ponownie uruchomić komendę ps i zobaczyć listę procesów działających w kontenerze.

![Zrzut ekranu pracy z obrazem fedora_2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%207.28.43%E2%80%AFPM.png)

Ponownie uruchomiłam kontener z obrazu fedora i zaktualizowałam pakiety w systemie kontenera, aby upewnić się, że wszystkie oprogramowanie jest najnowsze i posiada najnowsze poprawki zabezpieczeń. Aby zaktualizować pakiety w kontenerze, wykonałam komendę:

```bash
dnf update -y
```

![Zrzut ekranu zaktualizowanie pakietów](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%207.30.44%E2%80%AFPM.png)

4. **Stworzenie własnego obrazu Dockera (Dockerfile)**

Następnie własnoręcznie napisałam prosty plik `Dockerfile` bazujący na systemie fedora i sklonowałam ćwiczeniowe repozytorium.
Plik wyglądał następująco:

![Zrzut ekranu dockerfile](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%207.35.46%E2%80%AFPM.png)

Kolejno zbudowałam i uruchomiłam go:

![Zrzut ekranu budowanie](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%207.37.33%E2%80%AFPM.png)

W kontenerze po uruchomieniu wykonałam komendę `ls`, aby sprawdzić czy repozytrium zostało poprawnie sklonowane. Po wykonaniu polecenia, poprawnie wyświetiły się pliki:

![Zrzut ekranu sklonowane repozytorium](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%207.49.27%E2%80%AFPM.png)

Upewniłam się, że obraz miał `git`-a, co widać na załączonym zrzucie ekranu:

![Zrzut ekranu git](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%207.50.50%E2%80%AFPM.png)

Zgodnie z poleceniem w instrukcji wyświetliłam wszystkie uruchomione kontenery i które działają poprzez komendę `docker ps` oraz wszystkie kontenery, które nie są uruchomione poprzez `docker ps -a`. Następnie wyczyściłam je.

![Zrzut ekranu ps](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%207.55.26%E2%80%AFPM.png)
![Zrzut ekranu ps-a](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%207.52.55%E2%80%AFPM.png)

Po wyświetleniu listy uruchomionych kontenerów postanowiłam oczyścić system z niepotrzebnych, zatrzymanych kontenerów. W tym celu użyłam komendy: `docker container prune -f`. Ta komenda usuwa wszystkie zatrzymane kontenery, co pozwala na zwolnienie zasobów systemowych i poprawienie wydajności środowiska Docker. Flaga -f (force) sprawia, że proces usuwania odbywa się bez konieczności potwierdzenia, co przyspiesza operację. Po jej wykonaniu ponownie wyświetliłam listę kontenerów, używając poprzedniej komendy.
![Zrzut ekranu container prune](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%207.57.42%E2%80%AFPM.png)

Ostatnią czynnością było dodanie stworzonego pliku `Dockerfile` do folderu `Sprawozdanie1` w repozytorium.
![Zrzut ekranu dodany dockerfile na repozytorium](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%207.59.30%E2%80%AFPM.png)

..
## Zadanie 3: Dockerfiles, kontener jako definicja etapu

Zaczełam od sklonowania repozytorium oprogramowania o otwartej licencji, cJSON, zawierające działający Makefile, który ma zdefiniowany zestaw testów.
![Zrzut ekranu git clone]()

Przed kompilacja wykonałam polecenia `/bootstrap` i  `./configure` zgodnie z instrukcją w repozytorium. Następnie wykonałam kompilację poprzez `make`, zaś uruchomienie testów poleceniem `make test`.
![Zrzut ekranu bootstrap](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%204.36.57%E2%80%AFPM.png)
![Zrzut ekranu bootstrap](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%204.37.02%E2%80%AFPM.png)
![Zrzut ekranu make](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%204.37.11%E2%80%AFPM.png)
![Zrzut ekranu make test](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%204.37.20%E2%80%AFPM.png)

W ramach kolejnego etapu zadania, uruchomiłam kontener na podstawie obrazu ubuntu w trybie interaktywnym. W tym celu wykorzystałam polecenie:
```bash
docker run -it ubuntu:latest /bin/bash
```
![Zrzut ekranu docker run](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%204.40.39%E2%80%AFPM.png)

Po uruchomieniu kontenera, zainstalowałam wszystkie wymagane zależności, takie jak git, make oraz gcc. Aby zainstalować niezbędne pakiety, wykonałam poniższe polecenie:
```bash
apt-get update
apt-get install -y build-essential git cmake
```
![Zrzut ekranu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%204.41.16%E2%80%AFPM.png)
![Zrzut ekranu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%204.41.32%E2%80%AFPM.png)

Następnie, w ramach kontenera, sklonowałam repozytorium z projektem libyaml z GitHub. Użyłam do tego polecenia:
```bash
git clone https://github.com/yaml/libyaml.git
```
![Zrzut ekranu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%204.42.17%E2%80%AFPM.png)

Repozytorium zostało pomyślnie sklonowane, a następnie mogłam przystąpić do dalszych działań zgodnych z wymaganiami zadania. Kolejnym zadaniem było utworzenie dwóch plików Dockerfile, które miały odpowiedzialność za przygotowanie środowiska, kompilację oprogramowania oraz uruchomienie testów. Pierwszy plik `Dockerfile.build` przygotowuje środowisko i przeprowadza kompilację oprogramowania, a drugi plik `Dockerfile.test` uruchamia testy na skompilowanym oprogramowaniu.

Poniżej znajdują się zawartości obu plików:
![Zrzut ekranu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%205.03.43%E2%80%AFPM.png)
![Zrzut ekranu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%205.06.00%E2%80%AFPM.png)

Pliki zostały skompilowane jeden po drugim za pomocą poniższych poleceń:
![Zrzut ekranu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%205.03.29%E2%80%AFPM.png)
![Zrzut ekranu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%205.05.52%E2%80%AFPM.png)

Pierwsze polecenie buduje obraz libyaml-build, który przygotowuje środowisko oraz kompiluje oprogramowanie. Drugie polecenie buduje obraz libyaml-test, który jest odpowiedzialny za uruchomienie testów w kontenerze.


W celu weryfikacji poprawności działania, uruchomiłam kontener na bazie obrazu stworzonego przy użyciu Dockerfile.test w trybie interaktywnym. Dzięki temu możliwe było manualne sprawdzenie, czy kontener działa zgodnie z oczekiwaniami. Potwierdzono, że kontener wdraża się i pracuje poprawnie.

**Różnica między obrazem a kontenerem**

Ważnym aspektem jest zrozumienie różnicy między obrazem a kontenerem. Obraz to statyczna jednostka, która zawiera wszystkie pliki, zależności oraz instrukcje potrzebne do stworzenia kontenera. Jest to jakby szablon aplikacji, który może być przechowywany w repozytoriach (np. Docker Hub).

Z kolei kontener to uruchomiona instancja obrazu. Jest to dynamiczna jednostka, która działa w określonym czasie na podstawie obrazu. Kontener posiada swoje własne środowisko wykonawcze i jest izolowany od innych kontenerów oraz systemu gospodarza.

**Co pracuje w kontenerze?**

W kontenerze uruchomionym na bazie obrazu stworzonego z pliku `Dockerfile.test` znajduje się środowisko, które zawiera wszystkie zależności oraz instrukcje do przeprowadzenia testów. Kontener ten obejmuje:

1. Zainstalowane niezbędne narzędzia, takie jak `git`, `make`, `gcc`, które umożliwiają pobranie kodu źródłowego oraz kompilację aplikacji.
2. Skrypty i narzędzia odpowiedzialne za przeprowadzenie testów aplikacji, takie jak np. uruchomienie odpowiednich plików testowych z repozytorium.
3. Pliki wynikowe, takie jak logi z testów lub inne raporty, które pomagają w weryfikacji poprawności działania aplikacji.

**Weryfikacja działania kontenera**

Po uruchomieniu kontenera w trybie interaktywnym, ręcznie zweryfikowano jego działanie. Sprawdzono, czy wszystkie wymagane pliki są obecne, a testy wykonują się poprawnie. Kontener wdrożył się bez problemów, a przeprowadzenie testów zakończyło się zgodnie z oczekiwaniami.

Dzięki pracy w trybie interaktywnym możliwa była bezpośrednia interakcja z kontenerem, co pozwoliło na dokładne monitorowanie jego stanu oraz przebiegu testów. Po zakończeniu weryfikacji, kontener został zatrzymany, a wszystkie operacje zakończone pomyślnie.

![Zrzut ekranu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%205.21.23%E2%80%AFPM.png)
![Zrzut ekranu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-28%20at%205.21.31%E2%80%AFPM.png)



![Zrzut ekranu]()
![Zrzut ekranu]()
