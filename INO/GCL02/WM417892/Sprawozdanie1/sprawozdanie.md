# Sprawozdanie 1

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
Wygenerowałem parę kluczy SSH za pomocą komendy ssh-keygen -t ed25519 -C "wmatys.contact@gmail.com". Klucze zostały zapisane w niestandardowej lokalizacji /home/Wojtek/.ssh/id_devops. Wprowadziłem również hasło zabezpieczające klucz prywatny.
#
#
![1 5](https://github.com/user-attachments/assets/f90fc898-0a57-4b40-9519-ba3e0066fd92)
Zrzut ekranu 1.5
Uruchomiłem agenta SSH poleceniem eval "$(ssh-agent -s)", a następnie dodałem nowo utworzony klucz do agenta za pomocą ssh-add ~/.ssh/id_devops. Sprawdziłem zawartość klucza publicznego komendą cat ~/.ssh/id_devops.pub. Na końcu przetestowałem połączenie z GitHubem za pomocą ssh -T git@github.com – autoryzacja zakończyła się pomyślnie.
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

  

