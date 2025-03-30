# Sprawozdanie z przedmiotu Metodyki DevOps z laboratorium nr 1-4
Sprawozdanie wykonała: Amelia Nalborczyk, nr grupy: 2.
Data wykonania: 30.03. 2025 r.
## Laboratorium 1
1. Przygotowałam środowisko pracy
   - Zainstalowałam maszynę wirtualną z systemem Linux Fedora na Oracle VirtualBox.
   - Zalogowałam się do maszyny wirtualnej za pomocą SSH.
   - Skonfigurowałam środowisko Visual Studio Code, korzystając z wtyczki Remote - SSH.
2. Najpierw zainstalowałam klienta Git oraz skonfigurowałam obsługę kluczy SSH. SSH to sposób na bezpieczne łączenie się z GitHub bez potrzeby wpisywania loginu i hasła za każdym razem. Wykonanie tego zadania poprawnie można sprwdzić w sekcji "SSH and GPG keys" jak poniżej:
![Zrzut ekranu 1](screenshots/1.PNG)
3. Za pomocą Personal Access Token sklonowałam repozytorium przedmiotowe MDO2025_INO, używając protokołu HTTPS
![Zrzut ekranu 2](screenshots/2.PNG)
4. Wygenerowałam dwa klucze SSH, przy czym jeden z nich został zabezpieczony hasłem. Użyto polecenia: ssh-keygen
5. Skonfigurowałam klucz SSH jako metodę dostępu do GitHuba
6. By mieć dostęp do repozytorium jako uczestniczka sklonowałam repozytorium za pomocą klucza SSH.
7. Dalej przygotowałam swoją gałąź "AN416663". Od tej pory przełączam gałąź "main" na swoją za pomocą polecenia git branch. Do utworzenia gałęzi użyłam komendy git checkout. Dodany branch:
![Zrzut ekranu 3](screenshots/3.PNG)
8. W katalogu  dla grupy utwórzyłam nowy katalog "AN416663"
9. Aby zapewnić, że każdy commit message zaczyna się od inicjałów i numeru indeksu, utworzyłam Git Hooka. Nadałam plikowi odpowiednie uprawnienia komendą chmod. Git Hook został zamieszczony w nowo powstałym katalogu. Treść Git Hooka znajduje się poniżej:
![Zrzut ekranu 4](screenshots/4.PNG)
10. W katalogu stworzyłam przykładowy plik Sprawozdanie1.md dodałam przykładowy tekst oraz spróbowałam wysłać zmiany w następujący sposób:
![Zrzut ekranu 5](screenshots/5.PNG)
11. Plik został zapisany jednak nie mógł zostać wypchnięty:
![Zrzut ekranu 7](screenshots/7.PNG)   
13. Próba wypchnięcia mojej gałęzi oraz  okazała się niepowodzeniem ze względu na uprawnieia w repozytorium przedmiotowym:
![Zrzut ekranu 6](screenshots/6.PNG)

## Laboratorium 2
1. Laboratorium 2 przebiega w parciu o narzędzie Docker.  Docker umożliwia prace z aplikacjami w kontenerach, czyli izolowanych środowiskach. Pozwalają na uruchamianie aplikacji w różnych środowiskach. Pierwszym krokiem jest przygotowanie środowiska pracy:
   - Zainstalowałam oprogramowanie Docker za pomocą dnf install
   - zarejestrowałam się na stronie https://hub.docker.com/, zapoznałam się z dostępnymi obrazami. Pobrałam obrazy:  hello-world, busybox, ubuntu, fedora, mysql
![Zrzut ekranu 8](screenshots/8.PNG)
2. Uruchomiam kontener z obrazu hello-word. Poniżej zamieszczam efekt takiego uruchomienia:
![Zrzut ekranu 9](screenshots/9.PNG)
3. Ponownie uruchamiam kontener z obrazu busybox, tym razem interaktywnie (-it). Uruchomienie kontenera w trybie interaktywnym pozwala na bezpośrednią interakcję z terminalem kontenera. Poniżej przykład uruchomienia:
![Zrzut ekranu 10](screenshots/10.PNG)
4. Sprawdziłam wersji systemu w kontenerze, jest to możliwe dzięki trybowi interaktywnemu:
![Zrzut ekranu 11](screenshots/11.PNG)
5. Uruchomiłam obraz systemu ubuntu w kontenerze:
![Zrzut ekranu 12](screenshots/12.PNG)
6. Sprawdziłam procesy Dockera i PID1 w kontenerze.
Procesy w kontenerze, czyli tylko procesy uruchomione wewnątrz niego: 
![Zrzut ekranu 14](screenshots/14.PNG)
Procesy Docera na hoście. Widać uruchomiony kontener oraz inne procesy dockera działające na hoście.
![Zrzut ekranu 13](screenshots/13.PNG)
7. Zaaktualizowałam pakiety, a następnie wyszłam z kontenera polecenie exit
![Zrzut ekranu 15](screenshots/15.PNG)
8. Następnie utworzyłam plik Docerfile. Znajduje się on w folderze Sprawozdaniem1. Dockerfile buduje system i klonuje repo.
9. Zbudowałam i uruchomiłam Dockerfile, wobec czego został uruchomiony w trybie interaktywnym kontener z systemem Ubuntu.
![Zrzut ekranu 16](screenshots/16.PNG)
![Zrzut ekranu 17](screenshots/17.PNG)
10. Sprawdzam uruchomione kontenery (nie działające), za pomocą polecenia docker ps -a. Urochomione kontenery to takie, które mogą być zarówno uruchomione, jak i zatrzymane. Oto efekt wywołania tego polecenia. W kolumnie STATUS można sprawdzić które kontenery są zatrzymane (Exited).
![Zrzut ekranu 18](screenshots/18.PNG)
11. Po wykoannym zadaniu należy pamiętać by posprzątać po sobie:
    - Usunęłam kontenery
![Zrzut ekranu 19](screenshots/19.PNG)      
    - Usunęłam obrazy
![Zrzut ekranu 20](screenshots/20.PNG)
## Laboratorium 3

## Laboratorium 4

## Użycie narzędzi GenAI
W ramach laboratorium korzystałam do wykonania ćwiczenia narzędzia ChatGPT - model 4o. 
Narzędzie zostało wykorzystane do 
- Korekty tekstu pisanego sprawozdania.
- Wytłumaczenia zagadnień poznawanych w ramach zajęć.
- Pomoc przy tworzeniu plików
Odpowiedzi były weryfikowane osobiście przeze mnie.

