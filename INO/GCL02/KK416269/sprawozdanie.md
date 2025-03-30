# **Sprawozdanie 1** - Metodyki DevOps
_________________________________________________________________________________________________________________________________________________________________
## **LAB 1** - Wprowadzenie, Git, Gałęzie, SSH
### Przygotowanie
Przed rozpoczęciem kolejnych zajęć laboratoryjnych musiałam skonfigurować odpowiednie środowisko pracy. W tym celu, zgodnie z zaleceniami, utworzyłam maszynę wirtualną z systemem Fedora przy użyciu programu Hyper-V.

Następnie przetestowałam komunikację z serwerem, przesyłając przykładowe pliki między urządzeniem lokalnym a serwerem za pomocą polecenia scp. Aby usprawnić i zrobić pracę bardziej przejrzystą, w programie Visual Studio Code zainstalowałam wtyczkę Remote-SSH. Dzięki niej mogłam połączyć się z serwerem poprzez Command Palette (klawisz F1), wprowadzając niezbędne dane, takie jak adres IP serwera, wybranie systemu Linux oraz podanie hasła.

Dodatkowo na maszynie wirtualnej musiałam zainstalować narzędzia git i tar, aby wszystko poprawnie mogło działać.

  ``` bash
  # Komendy:
  # przesyłanie z serwera na lokalny komputer
  scp kaoina@172.18.148.33:/home/kaoina/hello_from_Fedora.txt C:\Users\kkuro\Desktop\Studia\semestr_6\DevOps\

  # przesyłanie z lokalnego komputera na serwer
  scp .\Desktop\Studia\semestr_6\DevOps\bonjour.txt kaoina@172.18.148.33:/home/kaoina/

  # instalowanie potrzebnych narzędzi
  sudo dnf install -y tar
  sudo dnf install -y git
  ```

### Wykonanie zadania
#### Cel
Celem wykonywanych zadań jest wprowadzenie do pracy na sklonowanym repozytorium zajęć, nauka podstaw Gita poprzez stworzenie własnej gałęzi, zarządzanie commitami (z użyciem git hook) oraz nauka wprowadzania aktualizacji.

- [x] **Zainstaluj klienta Git i obsługę kluczy SSH**

Jak widać na załączonym screenie, nie musiałam już pobierać ani klienta Git, ani obsługi kluczy SSH. Git został przezemnie pobrany w trakcie przygotowania środowiska do zajęć, a obsługa SSH była pradowpodbnie dostępna razem z systemem Fedora. 

<img src="https://github.com/user-attachments/assets/f2255642-c4cf-4b5a-af48-58ef040834f8" style="width:50%;">


- [x] **Sklonuj repozytorium przedmiotowe za pomocą HTTPS i personal access token**

 Utworzyłam personal access token do pobrania repozytorium (nie było to jednak konieczne, gdyż repozytorium było publiczne i nie wymagało odemnie 
 hasła (bądz zastępczego tokena)).
 
 <img src="https://github.com/user-attachments/assets/331e7971-31ba-4ae3-be59-8b5c00d14a5d" style="width:70%;"> 

 Skopiowałam repozytorium poleceniem: `git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git`

- [x] **Upewnij się w kwestii dostępu do repozytorium jako uczestnik i sklonuj je za pomocą utworzonego klucza SSH, zapoznaj się dokumentacją.**
  - **Utwórz dwa klucze SSH, inne niż RSA, w tym co najmniej jeden zabezpieczony hasłem**
  
  Klucze SSH pozwalają na bezpieczne logowanie do serwerów bez użycia haseł. Wygenerowałam klucze (typ klucza ed25519) za pomocą komendy: `ssh-keygen -t ed25519 -C "kkurowka600@gmail.com"`
 
 <img src="https://github.com/user-attachments/assets/97475e2b-143c-4a06-96de-e26d6bddb043" style="width:50%;">

  Dodatkowo uruchomiłam agenta SSH (który jest procesem zarządzającym kluczami SSH) komendą `eval "$(ssh-agent -s)"`. Przechowuje on klucze w pamięci RAM, dzięki czemu nie będzie trzeba wpisywać hasła za każdym razem, gdy skorzystam z klucza. Dodałam klucz do agenta poleceniem `ssh-add ~/.ssh/id_ed25519` 

Następnie wyświetliłam klucz poleceniem `cat ~/.ssh/id_ed25519.pub` i skopiowałam w celu dodania do serwisu GitHub.
  
  ![image](https://github.com/user-attachments/assets/514122d0-127f-4972-841c-59d645b82284)

  - **Skonfiguruj klucz SSH jako metodę dostępu do GitHuba**
    
Wykonałam to poprzez wklejenie wcześniej pobranego klucza w odpowiednie miejsce w ustawieniach GitHub: `Settings > SSH and GPG keys > New SSH key`

  ![image](https://github.com/user-attachments/assets/8ec2b355-f6be-4f73-a68e-4da89e06680a)

  - **Skonfiguruj 2FA**
  Zabezpieczyłam też swoje konto włączając uwierzetylnaine dwuskładnikowe (two-factor authentication)

  <img src="https://github.com/user-attachments/assets/0a065ed2-f477-4842-8822-2609c1e9057f" style="width:50%;">

- [x] **Przełącz się na gałąź main, a potem na gałąź swojej grupy (pilnuj gałęzi i katalogu!)**

Wykonałam to poleceniem *git checkout* które służy do przełączania się pomiędzy różnymi gałęziami (branchami). Komenda: `git checkout GCL02`

 <img src="https://github.com/user-attachments/assets/726b7a2d-5e56-438f-9b0c-fe482540caa7" style="width:50%;">

- [x] **Utwórz gałąź o nazwie "inicjały & nr indeksu" np. KD232144.**

Tworzenie nowych gałęzi odbywa się poprzez dodanie do wcześniejszej komendy parametru *-b* (od branch) i zapisania po niej nazwy nowej gałęzi. Komenda: `git checkout -b KK416269`

 <img src="https://github.com/user-attachments/assets/020cfaa7-460d-46b8-8645-676cf8261c68" style="width:50%;">

- [x] **Rozpocznij pracę na nowej gałęzi**

  - **W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu" np. KD232144**
W tym katalogu zawarte będą wszytkie pliki i foldery na których pracować będę podczas zajęć. Tworzenie katalogu: `[kaoina@KaoinaFedora GCL02]$ mkdir KK416269`

  - **Napisz Git hooka - skrypt weryfikujący, że każdy Twój "commit message" zaczyna się od "twoje inicjały & nr indexu".**

W ścieżce `.git/hooks/commit-msg.sample` znalazłam przykładowy Git hook, który pozwala kontrolować treść wiadomości commitów. Aby z niego skorzystać, należało nadać mu odpowiednie uprawnienia do uruchamiania. `chmod +x .git/hooks/commit-msg`

  - **Dodaj ten skrypt do stworzonego wcześniej katalogu.**

Utworzyłam plik poleceniem `touch commit-msg`, o kodzie który widnieje powyżej.

  - **Skopiuj go we właściwe miejsce, tak by uruchamiał się za każdym razem kiedy robisz commita.**

  Jeśli wcześniej nie nadałabym odpowiednich uprawnień do pliku w katalogu .git/hooks/, teraz sensowne byłoby wykonanie poniższej operacji: skopiowanie skryptu, który został utworzony w moim folderze, do katalogu .git/hooks, aby działał poprawnie. Plik w katalogu .git/hooks zostanie nadpisany. Polecenie : `[kaoina@KaoinaFedora MDO2025_INO]$ cp ~/MDO2025_INO/INO/GCL02/KK416269/commit-msg .git/hooks/commit-msg`

 W trakcie testowania działania gita hooka okazało się, że musiałam również skonfigurować adres e-mail oraz nazwę użytkownika dla mojego konta Git, aby móc wykonywać commity. W tym celu wykonałam następujące komendy:
  ``` bash
  git config --global user.email "kkurowska600@gmail.com"`
  git config --global user.name "kaoina"
  ```

  - **Umieść treść githooka w sprawozdaniu**

``` bash
#!/bin/bash

commit_message=$(cat "$1")

pattern="KK416269"

if [[ $commit_message =~ ^$pattern ]]; then
    exit 0
else
    echo "Commit message musi zaczynać się od $pattern"
    exit 1
fi 
``` 
  - **W katalogu dodaj plik ze sprawozdaniem**

Podobnie jak wcześniej, utworzyłam w moim katalogu plik o rozszerzeniu .md za pomocą polecenia: `touch sprawozdanie.md`. Jest to rozszerzenie, które jest obsługiwane przez GitHub i pozwala na tworzenie dokumentów w formacie Markdown.

  - **Dodaj zrzuty ekranu (jako inline)**

Korzystałam z dwóch składni
``` HTML
1. ![image](ścieżka_do_screena)
2. <img src="ścieżka_do_screena" style="width:50%;"> (opcja *style* dodatkowo)
```

Druga składnia była szczególnie przydatna, gdy moje zrzuty ekranu były zdecydowanie za duże i psuły czytelność sprawozdania. Korzystała ona ze składni HTML, która również jest wspierana przez GitHub.

  - **Wyślij zmiany do zdalnego źródła**

  Wszystkie zmiany dodałam do zdalnego repozytorium za pomocą standardowego ciągu instrukcji:
  ```
  git add .
  git commit -m "KK416269 treść"
  git push origin KK416269 `
  ```
Pierwsza komenda git add . dodaje wszystkie zmienione pliki do strefy staging, następnie git commit zapisuje je w lokalnym repozytorium z wiadomością opisującą zmiany. Na końcu, za pomocą git push origin KK416269, wysyłam swoją gałąź do zdalnego repozytorium na serwerze GitHub.

  - **Spróbuj wciągnąć swoją gałąź do gałęzi grupowej**

Pierwszą komendą przełączyłam się na gałąź grupową. Następnie, dzięki git pull pobrałam najnowsze zmiany z tej gałęzi. Kolejno, git merge KK416269 próbuje połączyć moją gałąź z gałęzią grupową, a ostatnia komenda (git push origin GCL02) wysyła zaktualizowaną gałąź grupową z powrotem do zdalnego repozytorium.
  ``` bash
  git checkout GCL02
  git pull origin GCL02
  git merge KK416269
  ```
Próba wciągnięcia mojej gałęzi do gałęzi grupowej (GCL02) nie powiodła się z powodu zabezpieczeń w repozytorium. Taką zmianę należy wprowadzać za pomocą pull request, aby zapewnić kontrolę nad wprowadzanymi zmianami co jednak nie było jeszcze konieczne w tym laboratorium.

  - **Zaktualizowanie sprawozdania**

Korzystając już z wcześniej poznanych komend dokończyłam sprawozdanie i dodałam do zdalnego repozytorium.

_________________________________________________________________________________________________________________________________________________________________
## **LAB 2** - Git, Docker
### Wykonane zadania
#### Cel
Zajęcia miały na celu pomóc zrozumieć podstawowe koncepcje DevOpsowe jakimi są kontenery, oraz nauczyć samodzielnie tworzyć i zarządzać prostymi kontenerami Dockera.
  
- [x] **Zainstaluj Docker w systemie linuksowym**
      - użyj repozytorium dystrybucji, jeżeli to możliwe (zamiast Community Edition)
Ponieważ repozytorium dystrybucji zapewnia stabilniejsze i lepiej zintegrowane z systemem wersje dockera, instalujemy go za pomocą komendy `sudo dnf install docker`. Następnie poniższymi komendami uruchamiamy usługę, oraz ustalamy, że Docker będzie włączał się automatycznie przy starcie systemu. Na końcu weryfikujemy czy zainstalowanie powiodło się pomyślnie (wyświetlamy dostępną wersję).

```bash
sudo systemctl start docker
sudo systemctl enable docker

sudo docker --version
```

![image](https://github.com/user-attachments/assets/87d13b71-6be6-4b9c-81ee-a5d236f8c9f0)

- [x] **Zarejestruj się w Docker Hub i zapoznaj z sugerowanymi obrazami**

Docker Hub to publiczne repozytorium obrazów Docker, gdzie można pobrać gotowe kontenery z aplikacjami i systemami.
Zarejestrowałam się w serwisie i przejrzałam dostępne obrazy.

![image](https://github.com/user-attachments/assets/2124867f-1f26-40ac-961d-d0dc171dedbc)

- [x] **Pobierz obrazy hello-world, busybox, ubuntu lub fedora, mysql**

Pobrałam kilka podstawowych obrazów (`hello-world` to testowy obraz do sprawdzenia poprawności działania Dockera, a `busybox` to minimalistyczna dystrybucja Linuxa, zawierająca podstawowe narzędza np. do testów), dzięki poniższym komendom:

```bash
docker pull hello-world
docker pull busybox
docker pull ubuntu
docker pull fedora
docker pull mysql
```

![image](https://github.com/user-attachments/assets/16a641fa-7291-488c-8160-b5f0089a0525)

- [x] **Uruchom kontener z obrazu busybox**
  - **Pokaż efekt uruchomienia kontenera**

Uruchomiłam kontener i zmusiłam do wyświetlenia testowej wiadomości instrukcją `docker run busybox echo "Test działania kontenera busybox"`
Następnie sprawdziłam listę uruchomionych przeze mnie kontenerów dzięki `sudo docker ps -a`.

![image](https://github.com/user-attachments/assets/8fbfe249-dfc4-47fa-a4c2-32891810ac82)

  - **Podłącz się do kontenera interaktywnie i wywołaj numer wersji**

Uruchomienie kontenera w trybie interaktywnym można wykonać dodając do polecenia argument `-it` oraz `sh` które uruchamia powłokę i pozwala na interakcję z systemem: `sudo docker run -it busybox sh`.

Następnie już wewnątrz kontenera wpisałam komendę `busybox --help` która wyświetliła informację o wersji i licencji (mogłam też użyć po prostu `busybox --version`)

![image](https://github.com/user-attachments/assets/a671736d-ad85-4d6a-831c-623550916f88)


- [x] **Uruchom "system w kontenerze" (czyli kontener z obrazu fedora lub ubuntu)**
  - **Zaprezentuj PID1 w kontenerze i procesy dockera na hoście**

PID 1 (Process ID 1) to pierwszy proces uruchamiany w systemie lub w kontenerze (nadrzędny dla wszystkich innych procesów)
Aby go zaprezentować uruchomiłam interaktywnie kontener w bash (w moim przypadku fedora). 
`sudo docker run -it fedora bash`

![image](https://github.com/user-attachments/assets/93f173a8-f2eb-46db-b846-d880f7387d8e)

Aby komenda `ps aux` (która pokazuje listę procesów w kontenerze) działała, należało doinstalować pakiet `dnf install -y procps-ng`, który zawiera `ps`.

![image](https://github.com/user-attachments/assets/09d342d3-81fe-4fdd-8ccb-12e9b0354370)

```bash
ps aux
ps -ef
```

Dodatkowo sprawdziłam hierarchię procesów poleceniem `ps -ef`, gdzie jak widać na screenie, w kolumnie PPID (pokazuje rodzica procesu). Dla bash PPID = 0, co oznacza, że proces nie ma rodzica (czyli jest procesem startowym systemu).

![image](https://github.com/user-attachments/assets/df3aadc7-2955-4801-922a-b2df67d8b423)

Zgodnie z instrukcją wyszukałam procesy dockera. Zrobiłam to dzięki poniższej komendzie. Polecenie wypisało procesy dockera, ponieważ komenda `grep` zwróci tylko te procesy które zawierają słowo docker.

`ps aux | grep docker` 

![image](https://github.com/user-attachments/assets/ea2cb66b-3878-4f2f-80a4-7d97b247c9da)


  - **Zaktualizuj pakiety**

W celu aktualizacji pakietów w kontenerze korzystamy z komendy `dnf update -y`. 

![image](https://github.com/user-attachments/assets/d4f4536c-a226-474a-a379-9fe070ee4262)

  - **Wyjdź**

Aby wyjść wpisujemy w konsolę `exit`.

- [x] **Stwórz własnoręcznie, zbuduj i uruchom prosty plik Dockerfile bazujący na wybranym systemie i sklonuj nasze repo.**
  - **Kieruj się dobrymi praktykami**
  - **Upewnij się że obraz będzie miał git-a**
  - **Uruchom w trybie interaktywnym i zweryfikuj że jest tam ściągnięte nasze repozytorium**

Dockerfile:

``` bash
# Używamy najnowszej wersji Fedory jako bazowego obrazu
FROM fedora:latest

# Informacje o autorze (opcjonalnie)
LABEL maintainer="Kaoina <kkurowska600@gmail.com>"

# Instalacja Git-a i usunięcie zbędnych plików cache (dobre praktyki)
RUN dnf install -y git && dnf clean all

# Ustawienie katalogu roboczego
WORKDIR /app

# Sklonowanie repozytorium
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

# Domyślny tryb interaktywny
CMD ["/bin/bash"]
```

Aby zbudować nasz własny kontener na podstawie kryteriów podanych w pliku `Dockerfile` należy go najpierw zbudować przy pomocy `docker build -t moj_git_kontener`.
Następnie możemy go uruchomć jak poprzednio interaktywnie przy pomocy polecenia `docker run -it --name testowy_kontener moj_git_kontener`.

W środku listujemy (`ls`) katalog roboczy w którym pobraliśmy nasze repozytorium, aby zweryfikować czy nie popełniłam błędów. Upewniamy się również czy pobrał się git poleceniem `git --version`.

![image](https://github.com/user-attachments/assets/5993fbba-5636-49ba-9f66-3cc3ad0a6edb)

- [x] **Pokaż uruchomione ( != "działające" ) kontenery, wyczyść je.**

Poniższymi poleceniami dockera wypisałam w konsoli wszystkie uruchamiane przezemnie kontenery, a następnie wszystkie wyczyściłam. 

`docker ps -a` - wypisanie

![image](https://github.com/user-attachments/assets/378744ac-b5bc-40c2-9468-9513187de5b4)

`docker rm $(docker ps -a -q)` - czyszczenie (flaga `-q` zwraca tylko ID kontenerów)

![image](https://github.com/user-attachments/assets/85598821-4775-4029-8df7-ea598fef74bb)

- [x] **Wyczyść obrazy**

`docker rmi $(docker images -q)` - polecenie wewnątrz zwraca listę ID obrazów (analogicznie jak powyżej). Następnie polecenie `docker rmi` usuwa wszystkie wskazane obrazy.

![image](https://github.com/user-attachments/assets/f8a474e4-d6cf-4fa9-8fd8-1534208b253c)

- [x] **Dodaj stworzone pliki Dockefile do folderu swojego Sprawozdanie1 w repozytorium.**

Na koniec zgodnie z instrukcją dodałam plik Dockerfile do folderu Sprawozdanie1 (w folderze moj_obraz), i zgodnie z zapoznanym schematem uaktualniłam zdalne repozytorium.

```bash
git add moj_obraz/Dockerfile
git commit -m "KK416269 Dodanie Dockerfile do Sprawozdanie1"
git push origin KK416269 
```

![image](https://github.com/user-attachments/assets/a7661e21-b5e8-46ed-a20d-57da3b370241)
_________________________________________________________________________________________________________________________________________________________________
## **LAB 3** - Dockerfiles, kontener jako definicja etapu
### Wykonane zadania
#### Cel
Celem tych laboratoriów była nauka tworzenia i wykorzystywania plików Dockerfile do automatyzacji budowania i testowania programów w kontenerach

#### Wybór oprogramowania na zajęcia

Znalezione przeze mnie Repozytorium to *Redis*, serwer struktur danych (https://github.com/redis/redis.git). Wybrałam go ze względu na dużą popularność i dokładny opis korzystania z repozytorium w pliku README.md. Sczegółowo wyjaśnia, czym jest Redis, jak przeprowadzić kompilację (build), jakie zależności są wymagane, jak uruchomić testy itp.

- [x] **Znajdź repozytorium z kodem dowolnego oprogramowania, które:**
  - **dysponuje otwartą licencją**
  
  Licencja: dostępny na licencji BSD 3-Clause (otwartoźródłowy)
    
  - **jest umieszczone wraz ze swoimi narzędziami Makefile tak, aby możliwe był uruchomienie w repozytorium czegoś na kształt make build oraz make test. Środowisko Makefile jest dowolne. Może to być automake, meson, npm, maven, nuget, dotnet, msbuild...**
  
  Posiada w swoim repozytorium plik Makefile do kompilacji (poleceniem `make build`).
    
  - **Zawiera zdefiniowane i obecne w repozytorium testy, które można uruchomić np. jako jeden z "targetów" Makefile'a. Testy muszą jednoznacznie formułować swój raport końcowy (gdy są obecne, zazwyczaj taka jest praktyka)**
 
  Repozytorium znajdują się też testy, które można zgodnie z repo urchomić za pomocą komendy `make test`.


- [x] **Sklonuj niniejsze repozytorium, przeprowadź build programu (doinstaluj wymagane zależności)**

Tą część ćwiczenia przeprowadziłam na irssi (redis użyję w drugiej części ćwiczenia).

`git clone https://github.com/irssi/irssi.git`

Weszłam do katalogu z pobranym repozytorium (`cd irssi`) i spróbowałam wykonać `meson Build`. Komenda ta tworzy katalog Build, i będą tam umieszczone pliki kompilacji. Sprawdza też czy są pobrane wszystkie wymagane zależności. 

![image](https://github.com/user-attachments/assets/fc948cfe-e3b4-461d-90d2-0391dc0117ed)

Brakowało jednak wielu zależności które doinstalowałam (dla usprawnienia w jednej) w kolejnej komendzie.

`sudo dnf install meson gcc glib2-devel ninja openssl-devel utf8proc-devel ncurses-devel perl-ExtUtils-Embed`

Opis pakietów (chat GPT):

meson – narzędzie do konfiguracji budowy oprogramowania.

gcc – kompilator języka C, potrzebny do budowania kodu źródłowego.

glib2-devel – biblioteka GLib, używana przez Irssi.

ninja – narzędzie do szybkiej kompilacji kodu (Meson używa go w tle).

openssl-devel – biblioteki OpenSSL wymagane do obsługi szyfrowania.

utf8proc-devel – biblioteka do obsługi tekstu w UTF-8.

ncurses-devel – biblioteka do obsługi interfejsu tekstowego w terminalu.

perl-ExtUtils-Embed – moduł Perla wymagany przez Irssi.

![image](https://github.com/user-attachments/assets/4e14295c-9b9d-4352-bcf0-4a3c37f5ca25)

Tym samym wróciłam do kroku z  `meson Build`, a następnie zgodnie z README repozytorium wprowadziłam komednę `ninja -C Build` (uruchamia proces budowy)
oraz `sudo ninja -C Build install` (kopiuje plik wykonywalny do katalogu `/usr/local/bin/` skąd system szyka programów).

![image](https://github.com/user-attachments/assets/7192852d-f3ca-4cc1-bf3a-555b3e0ebf45)

![image](https://github.com/user-attachments/assets/a67ebd8e-970e-4ab1-b022-9bf8964727f8)

- [x] **Uruchom testy jednostkowe dołączone do repozytorium**

w katalogu Build wpisałam komendę `ninja test` która przeprowadza testy. Przeszły one pomyślnie.

![image](https://github.com/user-attachments/assets/8d9b8889-de9d-4b94-b56c-a8cb0c988e43)


#### Przeprowadzenie buildu w kontenerze
Ponów ww. proces w kontenerze, interaktywnie.
Tą część ćwiczenia przeprowadziłam na repozytorium node. 

- [x] **Wykonaj kroki build i test wewnątrz wybranego kontenera bazowego. Tj. wybierz "wystarczający" kontener, np ubuntu dla aplikacji C lub node dla Node.js**

  - **Uruchom kontener & Podłącz do niego TTY celem rozpoczęcia interaktywnej pracy**

Pobrałam obraz Node.js: `docker pull node` i uruchomiłam interktywnie `sudo docker run -it node bash`.

![image](https://github.com/user-attachments/assets/8d99cdc0-93cd-4f69-801f-047587b33794)

  - **Zaopatrz kontener w wymagania wstępne (jeżeli proces budowania nie robi tego sam)**

Zaktualizowałam listę dostępnych pakietów, pobrałam `git` ktry przyda się do sklonowania repozytorium oraz `sudo`.
``` bash
apt update
apt install -y git
apt install sudo
```

![image](https://github.com/user-attachments/assets/94d42bbd-bf13-4698-bef8-33d5384224e8)

![image](https://github.com/user-attachments/assets/4ae63204-f03d-43c8-9cd2-ad3c56a1d4e3)


  - **Sklonuj repozytorium**

Sklonowałam komendą `git clone https://github.com/devenes/node-js-dummy-test.git`

![image](https://github.com/user-attachments/assets/50b02d9b-9cc7-46b6-bd8d-58bde75fcf16)


  - **Skonfiguruj środowisko i uruchom build & uruchom testy**

`npm install` instaluje potrzebne zależności zapisane w pliku `package.json.`

`npm test` uruchamia testy. Jak widać na zrzucie ekranu, wszystkie testy przeszły poprawnie.

![image](https://github.com/user-attachments/assets/310fd347-2154-4180-87ba-854cbfbc7211)

- [x] **Stwórz dwa pliki Dockerfile automatyzujące kroki powyżej, z uwzględnieniem następujących kwestii:**

Tą część ćwiczenia przeprowadziłam na wybranym przeze mnie repozytorium redis.

  - **Kontener pierwszy ma przeprowadzać wszystkie kroki aż do builda**

Kod pliku `Dockerfile.build` :

```bash
FROM ubuntu

RUN apt-get update && apt-get install -y \
    build-essential \
    tcl \
    git \
    libssl-dev \
    libsystemd-dev \
    make \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/redis/redis.git /redis

WORKDIR /redis

RUN make

```

Komenda do uruchomienia: `docker build -t redis_build_container -f ./Dockerfile.build .`

![image](https://github.com/user-attachments/assets/f46a1890-195b-4978-b210-be402db2ea86)


  - **Kontener drugi ma bazować na pierwszym i wykonywać testy (lecz nie robić builda!)**

Kod pliku `Docker.test` bazuje na wcześniej utworzonym kontenerze z kodem aplikacji i uruchamia testy.

```bash
FROM redis_build_container

RUN make test 
```

Komenda uruchamiająca: `docker build -t redis_test_container -f ./Dockerfile.test .  `

![image](https://github.com/user-attachments/assets/9c8a1f66-031e-42c1-801d-706698797415)

- [x] **Wykaż, że kontener wdraża się i pracuje poprawnie. Pamiętaj o różnicy między obrazem a kontenerem. Co pracuje w takim kontenerze?** 

`docker images` pokazało czy stworzyły się szablony (obrazy) do tworzenia kontenerów.
Pojawiły się obrazy redis_build_container oraz redis_test_container. 
Mogłam też wpisać komendę `docker ps` która poakzałaby listę działających kontenerów (ss z sprawdzania innego kontenera).
![image](https://github.com/user-attachments/assets/873661f0-6e98-499c-91cc-fae24b769623)

![image](https://github.com/user-attachments/assets/efb6281c-2e99-4fa0-9281-e62a3df70e84)

