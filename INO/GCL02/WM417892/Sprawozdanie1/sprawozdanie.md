# Sprawozdanie z zajęć 01

## Wprowadzenie

Celem niniejszego sprawozdania jest udokumentowanie wykonania zadań laboratoryjnych dotyczących podstawowej obsługi systemu kontroli wersji Git oraz platformy GitHub. W ramach ćwiczenia przeprowadzono konfigurację kluczy SSH, sklonowano repozytorium zdalne, utworzono gałęzie zgodnie z przyjętą strukturą oraz wykonano operacje na plikach i repozytorium zgodnie z przyjętą konwencją commitów.

![image](https://github.com/user-attachments/assets/1fabcc99-3dd9-4c52-ba8a-51ea17698f60)
Zrzut ekranu 1.1
Wykonałem polecenie sudo apt update, aby zaktualizować listę dostępnych pakietów w systemie. Dzięki temu mam pewność, że wszystkie instalowane programy będą pochodziły z aktualnych źródeł
#
#
![1 2](https://github.com/user-attachments/assets/0d289fe3-c1ce-4305-af53-c16ac38ec174)
Zrzut ekranu 1.2
Zainstalowałem wymagane pakiety za pomocą polecenia sudo apt install git openssh-client -y. System automatycznie doinstalował również dodatkowe zależności, takie jak openssh-server i openssh-sftp-server.
#
#
![1 3](https://github.com/user-attachments/assets/bc699251-1c4a-444d-9b0f-5787b0108665)
Zrzut ekranu 1.3
Sprawdziłem, czy instalacja przebiegła pomyślnie. Komenda git --version potwierdziła, że mam zainstalowaną wersję Gita 2.43.0, a ssh -V pokazało wersję klienta OpenSSH 9.6p1.
#
#
![1 4](https://github.com/user-attachments/assets/b0fc08a0-22fd-42e9-9a20-9e49730e5d02)
Zrzut ekranu 1.4
Wygenerowałem parę kluczy SSH za pomocą komendy ssh-keygen -t ed25519 -C "wmatys.contact@gmail.com". Klucze zostały zapisane w niestandardowej lokalizacji /home/Wojtek/.ssh/id_devops. Nie wprowadziłem  hasła zabezpieczającego klucz prywatny.
#
#
![1 5](https://github.com/user-attachments/assets/f90fc898-0a57-4b40-9519-ba3e0066fd92)
Zrzut ekranu 1.5
Uruchomiłem agenta SSH poleceniem eval "$(ssh-agent -s)", a następnie dodałem nowo utworzony klucz do agenta za pomocą ssh-add ~/.ssh/id_devops. Sprawdziłem zawartość klucza publicznego komendą cat ~/.ssh/id_devops.pub. Na końcu przetestowałem połączenie z GitHubem za pomocą ssh -T git@github.com – autoryzacja zakończyła się pomyślnie.
#
#
![1X](https://github.com/user-attachments/assets/911b9630-2c3f-43bf-be92-eb5ba71af665)
Utworzyłem, również drugi klucz już zabezpieczony hasłem
#
#
![1 6](https://github.com/user-attachments/assets/559c80ce-9878-47a7-99da-939564d024e3)
Zrzut ekranu 1.6
Sklonowałem repozytorium z GitHuba komendą git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git. Po udanym pobraniu wszystkich plików przeszedłem do katalogu MDO2025_INO i sprawdziłem zdalne repozytorium poleceniem git remote -v. Potwierdziłem, że połączenie zdalne wykorzystuje protokół SSH.
#
#
![1 7](https://github.com/user-attachments/assets/cfc5f14e-5829-4819-b804-b02a11487f6b)
Zrzut ekranu 1.7
Upewniłem się, że jestem na gałęzi main, a następnie wykonałem git pull origin main, aby pobrać najnowsze zmiany z repozytorium. Po tym przełączyłem się na gałąź grupową GCL02, wykonując polecenie git checkout GCL02, co ustawiło lokalną gałąź do śledzenia zdalnej origin/GCL02.
#
#
![1 8](https://github.com/user-attachments/assets/8be4b727-8b87-4c5d-975d-789ae7bfd117)
Zrzut ekranu 1.8
W edytorze Nano utworzyłem plik hooka Git (.git/hooks/commit-msg), który weryfikuje poprawność wiadomości commitów. Skrypt sprawdza, czy pierwszy wiersz wiadomości zaczyna się od mojego identyfikatora WM417892. Jeżeli nie, proces commitowania zostaje przerwany, a użytkownik otrzymuje komunikat o błędzie. Dzięki temu mam pewność, że wszystkie moje commity są odpowiednio oznaczone.
#
#
![1 9](https://github.com/user-attachments/assets/a000013b-c607-467a-ad46-ecf4ab5e1491)
Zrzut ekranu 1.9
Po zapisaniu skryptu hooka nadałem mu uprawnienia do wykonania poleceniem chmod +x. Następnie dodałem do śledzenia nowy plik sprawozdanie.md i wykonałem commit z poprawnie sformatowaną wiadomością zaczynającą się od WM417892. Commit zakończył się powodzeniem, co potwierdza poprawność działania mojego hooka.
#
#
![1 10](https://github.com/user-attachments/assets/99030f59-6c5c-4bc2-a324-846c65ba8b7e)
Zrzut ekranu 1.10
W katalogu INO/GCL02 utworzyłem nowy folder o nazwie WM417892, a następnie przeniosłem do niego plik sprawozdanie.md. Po przeniesieniu usunąłem oryginalny folder z katalogu głównego. Dodałem zmiany do systemu kontroli wersji, zatwierdziłem je z odpowiednią wiadomością commitującą i wypchnąłem gałąź WM417892 do zdalnego repozytorium za pomocą git push origin WM417892.
#
#
#
#
# Sprawozdanie zajęcia 2

## Wprowadzenie
Podczas drugich zajęć zapoznałem się z podstawami pracy z Dockerem oraz przypomniałem sobie najważniejsze komendy związane z systemem kontroli wersji Git. Moim celem było skonfigurowanie środowiska, uruchamianie kontenerów z gotowych obrazów (ubuntu, fedora, busybox, mysql) oraz stworzenie własnego obrazu za pomocą pliku Dockerfile. Dodatkowo zadbałem o wersjonowanie mojej pracy w repozytorium Git oraz stosowanie dobrych praktyk przy commitowaniu zmian.

![2 1](https://github.com/user-attachments/assets/fd68ed6c-cdf5-4a86-b23a-beee65ce2058)
Na powyższym zrzucie ekranu (2.1) widać, że zaktualizowałem system za pomocą polecenia:

```
sudo apt update && sudo apt upgrade -y
```

Dzięki temu upewniłem się, że wszystkie pakiety w systemie są w najnowszych dostępnych wersjach. Jest to dobry krok przygotowawczy przed instalacją nowych narzędzi – w tym przypadku Dockera.
#
#
![2 2](https://github.com/user-attachments/assets/1ac421ff-3e78-4382-977f-7ae0f7e8ada4)
Na zrzucie ekranu 2.2 zainstalowałem pakiety niezbędne do dalszej konfiguracji repozytorium Dockera, używając polecenia:

```
sudo apt install ca-certificates curl gnupg lsb-release
```

Pakiety te odpowiadają m.in. za obsługę certyfikatów SSL, narzędzie `curl` do pobierania danych, system zarządzania kluczami (`gnupg`) oraz identyfikację wersji systemu (`lsb-release`). W moim przypadku były już zainstalowane, więc system ich nie aktualizował.
#
#
![2 3](https://github.com/user-attachments/assets/253727f8-c6ad-4ee6-b295-50badac24f50)
Na zrzucie ekranu 2.3 utworzyłem katalog `/etc/apt/keyrings`, a następnie pobrałem i zapisałem klucz GPG Dockera w systemie. Klucz ten jest potrzebny do weryfikacji autentyczności pakietów Dockera pobieranych z zewnętrznego repozytorium.  
Użyłem poniższych poleceń:

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

Dzięki temu mogłem bezpiecznie dodać zewnętrzne repozytorium Dockera do systemowego APT.
#
#
![2 4](https://github.com/user-attachments/assets/c6475bb9-f240-4d5c-b1af-a6babcf03b1b)
Na zrzucie ekranu 2.4 dodałem repozytorium Dockera do systemowego pliku źródeł APT oraz zaktualizowałem listę pakietów.  

Użyłem polecenia:

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Następnie wykonałem:

```bash
sudo apt update
```

Dzięki temu system wie teraz, skąd pobierać pakiety Dockera z zaufanego źródła.

#
#
![2 5](https://github.com/user-attachments/assets/7d8736ea-767e-4e06-817c-6044a9924cb9)
Na zrzucie ekranu 2.5 zainstalowałem Dockera oraz dodatkowe komponenty za pomocą komendy:

```bash
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Ta komenda instaluje silnik Dockera, jego CLI, oraz wtyczki wspierające tworzenie i zarządzanie kontenerami. Instalacja przebiegła pomyślnie, co umożliwia mi dalszą pracę z kontenerami.
#
#
![2 6](https://github.com/user-attachments/assets/5d8e3f22-e5ab-40d7-9c93-2168cfac29f5)
Na zrzucie ekranu 2.6 sprawdziłem poprawność instalacji Dockera, wpisując komendę:

```bash
sudo docker --version
```

W odpowiedzi otrzymałem informację, że zainstalowana wersja to `Docker version 28.0.4`, co potwierdza, że instalacja przebiegła pomyślnie i Docker jest gotowy do użycia.
#
#
![2 7](https://github.com/user-attachments/assets/320317c7-ee3c-4f8f-9337-195992e23f59)
Na zrzucie ekranu 2.7 uruchomiłem usługę Dockera oraz sprawdziłem jej status. Komenda:

```bash
sudo systemctl start docker
```

uruchomiła usługę, a następnie:

```bash
sudo systemctl status docker
```

pokazała, że Docker działa prawidłowo (status: `active (running)`). Logi potwierdzają, że demony Dockera zostały uruchomione i kontenery mogą być obsługiwane przez system.
#
#
![2 8](https://github.com/user-attachments/assets/2f21779e-c764-4468-b3fe-3300b65d0be0)
Na zrzucie ekranu 2.8 wykonałem polecenia `docker pull`, aby pobrać wymagane obrazy kontenerów: `hello-world`, `busybox`, `ubuntu`, `fedora` oraz `mysql`. Każdy z nich został pomyślnie pobrany z rejestru Docker Hub, co potwierdzają komunikaty `Pull complete` i `Downloaded newer image`. Obrazy te będą wykorzystywane w kolejnych etapach konfiguracji środowiska i pracy z kontenerami.
#
#
![2 9](https://github.com/user-attachments/assets/44c4431c-bc84-4eef-893b-e8ab9c2be589)
Na zrzucie ekranu 2.9 uruchomiłem kontener z obrazu `busybox`, wydając polecenie `sudo docker run -it busybox`. Wewnątrz kontenera sprawdziłem jego działanie za pomocą prostego polecenia `echo "Działa!"`, które zwróciło oczekiwany komunikat. Następnie opuściłem kontener (`exit`) i wyświetliłem listę wszystkich kontenerów (`docker ps -a`), co potwierdziło, że kontener `busybox` został poprawnie uruchomiony i zakończony.
#
#
![2 10](https://github.com/user-attachments/assets/cd61d47a-c1d0-47ca-9047-ddc2b732dc51)
Na zrzucie ekranu 2.10 uruchomiłem kontener na bazie obrazu `ubuntu` z użyciem polecenia `sudo docker run -it ubuntu`. Po zalogowaniu się do kontenera, sprawdziłem działające procesy poleceniem `ps`, a następnie zaktualizowałem listę pakietów systemowych komendą `apt update`. Proces zakończył się sukcesem, informując, że 20 pakietów może zostać zaktualizowanych. Po zakończeniu działań opuściłem kontener komendą `exit`.
#
#
![2 11](https://github.com/user-attachments/assets/13571f54-0aca-4cab-9ca9-640f37ced125)
Na zrzucie ekranu 2.11 stworzyłem nowy katalog `moj-obraz`, w którym utworzyłem plik `Dockerfile`. Następnie zbudowałem własny obraz Dockera o nazwie `moj-pierwszy-obraz` poleceniem `sudo docker build -t moj-pierwszy-obraz .`. Proces budowania rozpoczął się poprawnie i wykorzystuje jako bazę oficjalny obraz `ubuntu:latest`.
#
#
![2 12](https://github.com/user-attachments/assets/7b3621dc-6b74-4802-91c0-fee9aa7242f7)
Na zrzucie ekranu 2.12 znajduje się zawartość mojego pliku `Dockerfile`, który wykorzystałem do zbudowania własnego obrazu. Obraz bazuje na oficjalnym `ubuntu:latest`. W kroku `RUN` zaktualizowałem listę pakietów i zainstalowałem `curl`. Ostatecznie, instrukcja `CMD` ustawia domyślną komendę, która po uruchomieniu kontenera wyświetla komunikat: „Działa z mojego obrazu!”.
#
#
![2 13](https://github.com/user-attachments/assets/30b30c2d-b104-48a2-b49a-7dde0f0d4b4a)
Na zrzucie ekranu 2.13 widoczny jest rezultat uruchomienia mojego własnego obrazu Dockera o nazwie `moj-pierwszy-obraz`. Po poprawnym zbudowaniu obrazu, uruchomiłem go poleceniem `sudo docker run moj-pierwszy-obraz`. Kontener uruchomił się i wyświetlił wiadomość „Działa z mojego obrazu!”, co potwierdza, że wszystko działa zgodnie z założeniami zapisanymi w pliku `Dockerfile`.
#
#
![2 14](https://github.com/user-attachments/assets/f4ade3d7-042c-4938-b4e8-8764d8f3f0a8)
Na zrzucie ekranu 2.14 widać potwierdzenie uruchomienia kontenera na podstawie mojego obrazu `moj-pierwszy-obraz`. Polecenie `docker ps -a` pokazuje listę wszystkich kontenerów, w tym ten najnowszy z komendą `"echo 'Działa z moje…"`, co odpowiada treści z mojego pliku `Dockerfile`. Kontener zakończył działanie poprawnie (status `Exited (0)`), co oznacza, że polecenie wewnątrz obrazu zostało wykonane bez błędów.
#
#
![2 15](https://github.com/user-attachments/assets/fe70529e-3171-404a-abb2-0278a8b6dd32)
Na zrzucie ekranu 2.15 widać, że wykonałem czyszczenie środowiska Dockera za pomocą dwóch poleceń:

1. `docker container prune` – usunąłem wszystkie zatrzymane kontenery, co pozwala zwolnić miejsce i uporządkować środowisko. Polecenie potwierdziłem, wpisując `y`, po czym zostały wypisane ID usuniętych kontenerów oraz informacja o odzyskanym miejscu (62.38MB).

2. `docker image prune -a` – usunąłem wszystkie obrazy, które nie były już używane przez aktywne kontenery. Dzięki temu jeszcze bardziej oczyściłem system z niepotrzebnych danych.

To był końcowy krok przygotowujący środowisko do dalszej pracy – czyste, uporządkowane i bez zbędnych plików.
#
#
![2 16](https://github.com/user-attachments/assets/b9fdaec0-2146-47ac-a1c6-1ccf7505ac34)
Na zrzucie ekranu 2.16 widać, że zakończyłem pracę nad sprawozdaniem i wypchnąłem zmiany do zdalnego repozytorium GitHub na gałęzi `GCL02` przy pomocy polecenia:

```
git push origin GCL02
```

Dodatkowo sprawdziłem, czy repozytorium jest poprawnie powiązane ze zdalnym adresem przy pomocy `git remote -v`, co potwierdza połączenie z GitHubem przez SSH.

Na koniec użyłem `git log --oneline`, aby upewnić się, że wszystkie commity znajdują się na gałęzi `WM417892`. Najnowszy commit (`273fb8ca`) zatytułowany *"Dodano sprawozdanie i pliki Dockera"* został poprawnie zapisany jako aktualna głowa (`HEAD`) tej gałęzi. Wszystko wygląda na uporządkowane i gotowe do oceny.
#
#
#
#
# Sprawozdanie – Zajęcia 03

## Wstęp

Celem ćwiczenia było zapoznanie się z ideą konteneryzacji oprogramowania przy użyciu narzędzia Docker. W ramach zajęć należało znaleźć repozytorium spełniające określone wymagania (m.in. dostępność plików `Makefile`, możliwość uruchomienia testów oraz otwarta licencja), a następnie przeprowadzić proces buildowania i testowania aplikacji wewnątrz kontenera. 

Dodatkowo zrealizowano etap automatyzacji poprzez utworzenie dwóch plików `Dockerfile` – jeden odpowiedzialny za budowanie projektu (`Dockerfile.build`), drugi za jego testowanie (`Dockerfile.test`).
#
#
![3 1](https://github.com/user-attachments/assets/27c90429-edbe-467c-b4ee-dda89da0a439)
Na powyższym zrzucie ekranu widać, że sklonowałem repozytorium `cJSON` z GitHuba do lokalnego katalogu roboczego. Użyłem polecenia `git clone`, aby pobrać wszystkie pliki źródłowe potrzebne do dalszej pracy z projektem. Repozytorium zostało pomyślnie sklonowane, o czym świadczy komunikat o zakończeniu pobierania wszystkich obiektów.
#
#
![3 2](https://github.com/user-attachments/assets/6a725a79-7b19-46d7-9cd2-2ddd723faafc)
Na tym etapie zrealizowałem proces budowania programu przy pomocy polecenia `make`. Kompilator `gcc` skompilował pliki źródłowe, a następnie utworzył pliki wykonywalne oraz biblioteki współdzielone. Wszystkie kroki zostały wykonane poprawnie, co potwierdzają wyświetlone komunikaty bez błędów.
#
#
![3 3](https://github.com/user-attachments/assets/c4f82e6d-279c-4de7-9815-db2bd90ee9ce)
Na zrzucie ekranu widoczny jest wynik działania testów po wykonaniu polecenia `make test`. Uruchomiłem testowy program `./cJSON_test`, który poprawnie zinterpretował i wyświetlił dane w formacie JSON. Oznacza to, że wszystkie testy przebiegły pomyślnie i biblioteka cJSON została zbudowana oraz przetestowana bez błędów.
#
#
![3 4](https://github.com/user-attachments/assets/ba7df10d-866c-43d8-aa89-1ebdb6b02545)
Na powyższym zrzucie ekranu uruchomiłem kontener Dockerowy z obrazem Ubuntu, a następnie wykonałem aktualizację pakietów oraz zainstalowałem niezbędne narzędzia (`git`, `build-essential`). Był to pierwszy krok do zbudowania środowiska do testowania projektu wewnątrz kontenera.
#
#
![3 5x](https://github.com/user-attachments/assets/a7266156-82dc-4502-be9e-a36971648d8f)
Na powyższym zrzucie ekranu, po wejściu do kontenera, sklonowałem repozytorium `cJSON`, a następnie przeprowadziłem proces kompilacji przy pomocy polecenia `make`. Kompilacja przebiegła pomyślnie, po czym uruchomiłem testy jednostkowe (`make test`), które zakończyły się poprawnym wynikiem, co świadczy o prawidłowym działaniu aplikacji.
#
#
![3 7](https://github.com/user-attachments/assets/25403dd2-db02-49b8-a8bf-7c38951b0228)
Na powyższym zrzucie przedstawiono zawartość pliku `Dockerfile.build`, który przygotowuje środowisko do zbudowania aplikacji. W pliku tym określiłem jako bazowy obraz `ubuntu:latest`, ustawiłem katalog roboczy, zainstalowałem wymagane narzędzia (`build-essential`, `git`) oraz sklonowałem repozytorium `cJSON`, przechodząc do jego katalogu i uruchamiając komendę `make`.
#
#
![3 8](https://github.com/user-attachments/assets/69cf73cd-cda5-481b-9bf4-2380b33f25e7)
Na tym zrzucie ekranu pokazany jest plik `Dockerfile.test`, który odpowiada za uruchomienie testów. Bazuje on na wcześniej zbudowanym obrazie o nazwie `program`, ustawia katalog roboczy na `/app/cJSON`, a następnie za pomocą polecenia `CMD ["make", "test"]` uruchamia testy projektu cJSON.
#
#
![3 9](https://github.com/user-attachments/assets/a02a137c-1a9d-41d2-81bf-fc5f77a0a8f6)
Na tym zrzucie ekranu zbudowałem dwa obrazy Dockera:

- Pierwszy obraz `program` został utworzony przy użyciu pliku `Dockerfile.build`. W jego trakcie pobrano potrzebne pakiety i repozytorium cJSON, a następnie przeprowadzono kompilację.

- Drugi obraz `programtest` został zbudowany na podstawie obrazu `program` przy użyciu pliku `Dockerfile.test`. Służy on do uruchamiania testów jednostkowych cJSON. Oba procesy zakończyły się pomyślnie.
#
#
![3 10](https://github.com/user-attachments/assets/0c530a64-2794-4267-b3c3-01dc05aa07c5)
Na tym zrzucie ekranu uruchomiłem kontener zbudowany na podstawie obrazu `programtest`. W wyniku wykonania polecenia `make test`, zostały uruchomione testy jednostkowe dla biblioteki cJSON. Testy zakończyły się sukcesem, a dane wyjściowe zostały poprawnie wyświetlone w formacie JSON, potwierdzając poprawne działanie aplikacji.
#
#
#
#
# Sprawozdanie z zajęć 04 – Konteneryzacja i instancja Jenkins

## Wstęp

Celem ćwiczeń było zapoznanie się z zaawansowaną terminologią dotyczącą konteneryzacji z wykorzystaniem Dockera. Szczególną uwagę poświęcono trwałości danych przy użyciu wolumenów, komunikacji między kontenerami oraz wdrożeniu kontenerowej instancji narzędzia Jenkins w środowisku Docker-in-Docker (DIND).
#
#
![4 1](https://github.com/user-attachments/assets/aecb8fb2-7a69-42fa-8f1b-1572cbb8d4ae)
**Zrzut ekranu 4.1 – Tworzenie i montowanie wolumenu wejściowego**

Na zrzucie widać utworzenie wolumenu o nazwie `wolumen-wejsciowy` oraz uruchomienie kontenera `ubuntu` z zamontowanym wolumenem do ścieżki `/app`. Następnie w kontenerze wykonano aktualizację pakietów i instalację narzędzi `git` oraz `build-essential`.
#
#
![4 2](https://github.com/user-attachments/assets/380989a0-3c70-48dd-9e29-d0c3fb7fae9c)
**Zrzut ekranu 4.2 – Klonowanie repozytorium do wolumenu**

Po wejściu do katalogu `/app` (zamontowanego wolumenu), sklonowano repozytorium `cJSON` z GitHub. Operacja zakończyła się powodzeniem, a dane zostały zapisane w wolumenie, co umożliwia ich wykorzystanie poza kontenerem. Następnie zakończono działanie kontenera komendą `exit`.
#
#
![4 3](https://github.com/user-attachments/assets/22096fcf-4815-482d-bf0e-57b0832f3678)
Zrzut ekranu 4.3 – Powrót do kontenera i przygotowanie środowiska w katalogu projektu
Po wcześniejszym zapisaniu plików cJSON w wolumenie, ponownie uruchomiłem kontener z tym samym wolumenem zamontowanym w katalogu /app. Następnie przeszedłem do katalogu /app/cJSON, czyli miejsca, gdzie został wcześniej sklonowany projekt. W kolejnym kroku zaktualizowałem pakiety i zainstalowałem środowisko kompilacji (build-essential), przygotowując kontener do uruchomienia testów.
#
#
![4 4](https://github.com/user-attachments/assets/20bfe36b-4bf4-4fd3-93ac-d8986a5f0464)
Zrzut ekranu 4.4 – Uruchomienie testów biblioteki cJSON
Po przygotowaniu środowiska i przejściu do katalogu z projektem wykonałem polecenie make test, które skompilowało oraz uruchomiło testy projektu cJSON. Testy zakończyły się powodzeniem, wypisując poprawnie sparsowane dane JSON, takie jak informacje o obrazie, lokalizacjach geograficznych i innych strukturach danych. To potwierdziło, że biblioteka działa prawidłowo w kontenerze.
#
#
![4 5](https://github.com/user-attachments/assets/9c12affb-001b-4e48-b03f-119c3c2ec6d8)
![4 6](https://github.com/user-attachments/assets/b89842b9-eda9-4b59-9290-92267c0b047e)
Zrzut ekranu 4.6 – Zawartość pliku Dockerfile.volume
Zdefiniowałem Dockerfile oparty na obrazie ubuntu:latest. Ustawiłem katalog roboczy, zainstalowałem wymagane pakiety, wskazałem folder cJSON i ustawiłem domyślną komendę make test jako polecenie do wykonania przy uruchomieniu kontenera.
#
#
![4 7](https://github.com/user-attachments/assets/35ba1b33-30ee-4056-916c-0841fa74eced)
Zrzut ekranu 4.7 – Budowanie obrazu Dockera
Na tym etapie uruchomiłem polecenie docker build, aby zbudować obraz o nazwie wolumen-test na podstawie pliku Dockerfile.volume. Proces zakończył się powodzeniem, a obraz został zapisany lokalnie z unikalnym identyfikatorem SHA. Budowanie obrazu przebiegło sprawnie – większość kroków była cache'owana, dzięki czemu proces był szybki.
#
#
![4 8](https://github.com/user-attachments/assets/c7f6d658-4cec-4462-8aba-9a4f75ccdad1)
Zrzut ekranu 4.8:
W tym kroku uruchomiłem kontener na podstawie wcześniej zbudowanego obrazu `wolumen-test`, wykorzystując bind mount:

```bash
--mount type=bind,source="$(pwd)/cJSON",target=/app/cJSON
```

Podmontowałem lokalny katalog `cJSON` do ścieżki `/app/cJSON` wewnątrz kontenera. Po uruchomieniu kontenera automatycznie wykonało się domyślne polecenie `make test`, które przetwarza dane w formacie JSON. Efektem działania programu był wydruk struktury JSON, widoczny na ekranie terminala.
#
#
![4 9](https://github.com/user-attachments/assets/df974074-03f4-4a36-a887-0d2f120c2756)
**Zrzut ekranu 4.9:**  
Na tym etapie utworzyłem własną sieć Docker o nazwie `iperf-net` za pomocą polecenia:

```bash
docker network create iperf-net
```

Następnie pobrałem obraz `networkstatic/iperf3`, który służy do testowania przepustowości sieciowej między kontenerami:

```bash
docker pull networkstatic/iperf3
```

Obraz został poprawnie pobrany z Docker Hub. Będzie on wykorzystany do dalszych testów sieciowych z użyciem narzędzia `iperf3`, zarówno w trybie klienta, jak i serwera, w ramach wcześniej utworzonej sieci.

#
#
![4 10](https://github.com/user-attachments/assets/b43596ca-2f03-49d4-abec-587a19bd6ec7)
**Zrzut ekranu 4.10:**  
Na tym etapie uruchomiłem dwa kontenery `iperf3` w tej samej, wcześniej utworzonej sieci `iperf-net`. Jeden z nich działał jako serwer:

```bash
docker run --rm -d --network iperf-net --name iperf-server networkstatic/iperf3 -s
```

A drugi jako klient, który łączy się z serwerem po jego nazwie (`iperf-server`) i przeprowadza test przepustowości:

```bash
docker run --rm --network iperf-net networkstatic/iperf3 -c iperf-server
```

Połączenie zostało zestawione poprawnie, a wynik testu pokazuje bardzo dobrą przepustowość sieci między kontenerami – średnio około 4.05 Gbit/s. Test został przeprowadzony w obrębie prywatnej sieci Dockera i potwierdził, że kontenery mogą się ze sobą komunikować z dużą wydajnością przy użyciu nazw hostów.

#
#
![4 11](https://github.com/user-attachments/assets/f5d76c49-6ba5-4ef9-a9d0-28f0cd0df18a)
**Zrzut ekranu 4.11:**  
Tym razem utworzyłem własną sieć o nazwie `mojabrigada` z użyciem sterownika `bridge`:

```bash
docker network create --driver bridge mojabrigada
```

Następnie uruchomiłem dwa kontenery `iperf3` w tej sieci — pierwszy jako serwer:

```bash
docker run --rm --network mojabrigada --name serwer-testowy networkstatic/iperf3 -s
```

A drugi jako klient:

```bash
docker run --rm --network mojabrigada networkstatic/iperf3 -c serwer-testowy
```

Połączenie pomiędzy kontenerami zostało nawiązane, a test przepustowości wykazał średni transfer na poziomie **4.49 Gbit/s**. Dzięki wykorzystaniu nazw kontenerów jako hostów mogłem łatwo sprawdzić komunikację w obrębie jednej, dedykowanej sieci typu `bridge`.
#
#
![4 12](https://github.com/user-attachments/assets/fd111a50-69f7-4f27-a688-a198a07697a5)
**Zrzut ekranu 4.12:**  
W tym kroku najpierw usunąłem wcześniej uruchomiony kontener `iperf-server` poleceniem:

```bash
docker rm -f iperf-server
```

Następnie ponownie uruchomiłem kontener `iperf-server`, tym razem mapując port 5201 kontenera na port 5201 hosta, dzięki czemu mogę testować połączenia spoza kontenera:

```bash
docker run -d --name iperf-server -p 5201:5201 networkstatic/iperf3 -s
```

Polecenie `docker ps` pokazuje, że kontener działa i ma prawidłowo przekierowany port 5201.

Na końcu próbowałem uruchomić `iperf3` bezpośrednio z poziomu hosta jako klient (`iperf3 -c localhost`), jednak pojawił się komunikat o braku tej komendy. Oznacza to, że `iperf3` nie jest zainstalowany na systemie hosta. Wskazówka mówi, że można go zainstalować za pomocą:

```bash
sudo apt install iperf3
```

Ten etap był próbą sprawdzenia działania serwera `iperf3` z zewnątrz (spoza kontenera), ale wymaga doinstalowania narzędzia na hoście.
#
#
![4 13](https://github.com/user-attachments/assets/9fcbcd01-03df-41b1-8770-9dc206b60b57)
**Zrzut ekranu 4.13:**  
Po wcześniejszej instalacji narzędzia `iperf3` na hoście, uruchomiłem test jako klient, łącząc się do działającego kontenera `iperf-server` przez `localhost`:

```bash
iperf3 -c localhost
```

Połączenie zostało nawiązane z portem 5201, który był wystawiony przez kontener. Test wykazał średnią przepustowość na poziomie **4.42 Gbit/s**, co potwierdza poprawne działanie połączenia między hostem a kontenerem. Widać też 58 retransmisji, co może być wynikiem lokalnych obciążeń, ale ogólnie transfer jest bardzo dobry i stabilny.

Dzięki temu potwierdziłem, że kontener `iperf-server` jest dostępny z poziomu hosta, jeśli porty są prawidłowo zmapowane.
#
#
![4 14](https://github.com/user-attachments/assets/3e957c5f-2243-4b01-bcc9-6fedd8d77559)
**Zrzut ekranu 4.14:**  
Tutaj wyświetliłem logi kontenera `iperf-server` za pomocą polecenia:

```bash
docker logs iperf-server
```

W logach widać, że serwer `iperf3` odebrał połączenie od klienta z hosta `172.17.0.1`. Połączenie zostało nawiązane na porcie 5201, a transfer danych przebiegał przez 10 sekund. Wyniki testu pokazują, że transfer utrzymywał się na poziomie około **4.40 Gbit/s**.

Dzięki temu mogłem potwierdzić, że serwer iperf działał poprawnie, nasłuchiwał na odpowiednim porcie i odbierał dane od klienta – logi zawierają szczegóły dotyczące każdego interwału transmisji.
#
#
![4 15](https://github.com/user-attachments/assets/c4a9c7cb-3068-4ea0-bab4-51ffedf6b314)
**Zrzut ekranu 4.15:**  
Na tym screenie sprawdziłem logi kontenera `serwer-testowy` za pomocą polecenia:

```bash
docker logs serwer-testowy
```

Logi pokazują, że serwer `iperf3` działający w kontenerze przyjął połączenie od klienta z IP `172.19.0.2`, który łączył się na porcie 5201. Transfer danych trwał 10 sekund, a średnia przepustowość wyniosła **4.48 Gbit/s**.

Wyniki wskazują, że komunikacja w ramach własnej sieci mostkowanej (`mojabrigada`) działa poprawnie i umożliwia bardzo wydajne przesyłanie danych między kontenerami. Serwer poprawnie przyjął i zarejestrował cały przebieg sesji testowej.
#
#
![4 16](https://github.com/user-attachments/assets/b9b1c049-def1-4238-a9c7-98bafc6b95f2)
**Zrzut ekranu 4.16:**  
Tutaj utworzyłem dedykowaną sieć o nazwie `jenkins-net`, która będzie służyć do komunikacji między kontenerami w środowisku Jenkins:

```bash
docker network create jenkins-net
```

Następnie uruchomiłem kontener `docker:dind` (Docker-in-Docker), który umożliwia wykonywanie poleceń Dockera wewnątrz kontenera – co jest niezbędne w przypadku używania Jenkinsa do budowania obrazów Dockera:

```bash
docker run --rm --privileged --network jenkins-net --name dind -d docker:dind
```

System nie znalazł lokalnie obrazu `docker:dind`, więc rozpoczął jego pobieranie z rejestru. Na ekranie widać kolejne warstwy obrazu, które zostały pobrane i zakończone komunikatem o sukcesie. Teraz kontener `dind` jest gotowy do dalszego użycia przez Jenkinsa.
#
#
![4 17](https://github.com/user-attachments/assets/fe44129f-a6b5-4754-99e0-0970bff39e97)

**Zrzut ekranu 4.17:**  
Na tym etapie uruchomiłem kontener z instancją Jenkinsa, przypisując go do sieci `jenkins-net`, a także wystawiając odpowiednie porty (8080 dla interfejsu webowego i 50000 dla agentów Jenkins):

```bash
docker run --rm --network jenkins-net -p 8080:8080 -p 50000:50000 \
-v jenkins_home:/var/jenkins_home \
--name jenkins \
-d jenkins/jenkins:lts
```

Ponieważ obraz `jenkins/jenkins:lts` nie był wcześniej pobrany lokalnie, system automatycznie rozpoczął jego pobieranie z rejestru Docker Hub. Na ekranie widać listę warstw obrazu, które zostały pomyślnie pobrane i złożone.

W ten sposób przygotowałem i uruchomiłem podstawową instancję Jenkinsa w kontenerze, gotową do dalszej konfiguracji poprzez przeglądarkę.
#
#
![4 18](https://github.com/user-attachments/assets/cc37afab-54a0-4fc9-bd1c-84a6c1d21588)
**Zrzut ekranu 4.18:**  
Na tym screenie uruchomiłem kontener z Jenkinsem w trybie odseparowanym (`-d`), przypisując go do wcześniej utworzonej sieci `jenkins-net`, a także mapując porty:

```bash
docker run -d --network jenkins-net -p 8080:8080 -p 50000:50000 \
-v jenkins_home:/var/jenkins_home \
--name jenkins \
jenkins/jenkins:lts
```

Użycie woluminu `jenkins_home` pozwala zachować dane konfiguracyjne Jenkinsa nawet po zatrzymaniu kontenera. Na końcu terminala widać hash ID nowo uruchomionego kontenera, co potwierdza, że Jenkins został poprawnie uruchomiony i działa w tle. Teraz mogłem przejść do przeglądarki i otworzyć panel webowy Jenkinsa pod adresem `localhost:8080`.
#
#![4 19](https://github.com/user-attachments/assets/e583d85e-64e8-475c-a139-c7a6e0b6fb92)

  **Zrzut ekranu 4.19:**  
Na tym etapie sprawdziłem, czy kontener Jenkins działa poprawnie, używając komendy:

```bash
docker ps
```

Na liście widać uruchomiony kontener `jenkins`, bazujący na obrazie `jenkins/jenkins:lts`. Porty 8080 i 50000 zostały prawidłowo zmapowane na hosta, co umożliwia dostęp do interfejsu webowego oraz komunikację z agentami Jenkins.

Następnie, aby uzyskać hasło potrzebne do pierwszego logowania się do panelu administracyjnego, użyłem polecenia:

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Z terminala odczytałem wartość hasła (`d02d54453ce042a78c9d4b2f524a330a`), którą mogłem wkleić na stronie startowej Jenkinsa (`localhost:8080`) w celu zakończenia procesu inicjalizacji.
![4 20](https://github.com/user-attachments/assets/1cec5aa0-46cd-42bb-a80e-f73c1c857f12)


