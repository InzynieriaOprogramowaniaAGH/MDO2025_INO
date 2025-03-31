# Laboratorium 1 - Wprowadzenie, Git, Gałęzie, SSH

## Abstrakt
Celem laboratoriów było przedstawienie procesu konfiguracji i obsługi narzędzi Git oraz SSH. Laboratorium zapoznało nas z konfiguracją kluczy SSH, różnymi sposobami klonowania repozytoriów, a także zarządzaniem gałęziami. Ponadto poznaliśmy przykładowe zastosowanie GitHook'ów.

### Wykonane kroki

1. **Instalacja klienta Git oraz obsługę kluczy SSH**

    ```bash
    sudo dnf install git openssh
    ```

    Powyższa komenda pozwala na pobranie *git* oraz narzędzi *openssh*. W tym przypadku paczki nie zostały pobrane, ponieważ były już zainstalowane ich najnowsze wersje.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/1.png)


2. **Sklonowanie repozytorium przedmiotu - HTTPS oraz Personal Access Token**

    ```bash
    git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
    ```

    Powyższe polecenie pozwala sklonować repozytorium przedmiotowe za pomocą HTTPS.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/2.png)

    ```bash
    git clone https://<TOKEN>@github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
    ```

    Powyższe polecenie pozwala sklonować repozytorium przedmiotowe przy pomocy tokenu PAT. W powyższej komendzie `<TOKEN>` należy zastąpić swoim wygenerowanym tokenem PAT. Ze względów bezpieczeństwa widniejący na zdjęciu token, po wykonaniu ćwiczenia został usunięty.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/3.png)

    Token PAT umożliwia wykonywanie czynności wymagających uwierzytelnienia bez potrzeby podawania hasła. Dodatkowo tworząc token PAT możemy jasno określić, do jakich celów chcemy wykorzystać dany token, przypisując mu tylko konkretne uprawnienia. 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/4.png)


3. **Sklonowanie repozytorium przy pomocy klucza SSH**

    ***A) Generowanie kluczy SSH***

    ```bash
    ssh-keygen -t ed25519 -C wiktorszyszka.priv@gmail.com
    ```

    Powyższa komenda pozwala wygenerować klucz SSH o stałej długości 256 bitów. Technika `ed25519` jest bezpieczniejsza od techniki `RSA` oraz szybsza. Powyższy klucz SSH został dodatkowo zabezpieczony hasłem.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/5.png)


    ```bash
    ssh-keygen -t ecdsa -C wiktorszyszka.priv@gmail.com
    ```

    Powyższa komenda generuje klucz SSH. Technika `ecdsa` jest bezpieczniejsza od techniki `RSA` oraz szybsza. Dzieje się tak, ponieważ technika `ecdsa` wykorzystuje krzywe eliptyczne, które pozwalają zapewnić większe bezpieczeństwo przy znacznie krótszych kluczach. Obecnie najpowszechniejsze klucze wygenerowane przy technice `RSA` mają długość aż 2048 bitów. Powyższy klucz SSH nie został zabezpieczony hasłem.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/6.png)

    ***B) Konfiguracja dostępu do GitHuba poprzez wygenerowany klucz SSH***

    Poniższe zdjęcie przedstawia ekran przypisania klucza SSH do konta GitHub. Z powodów bezpieczeństwa na poniższym zdjęciu klucz SSH został ukryty. W polu `Key` umieściłem klucz znajdujący się w pliku *`id_ed25519.pub`* 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/7.png)

    **C) Sklonowanie repozytorium przy pomocy protokołu SSH**

    ```bash
    git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
    ```

    Powyższa komenda pozwala na sklonowanie repozytorium, korzystając z protokołu SSH. Po wpisaniu komendy otrzymaliśmy komunikat o treści `The authenticity of host 'github.com (140.82.121.3)' can't be established`, jest to standardowy komunikat, który występuje przy pierwszym łączeniu się z nowym serwerem, ponieważ host nie znajdował się na liście znanych hostów. Kolejny komunikat informuje nas o odcisku palca serwera GitHuba, który jest unikalny. Służy on jak informacja zwrotna do użytkownika, aby ten mógł dodatkowo potwierdzić tożsamość hosta, z którym się łączy. Następnie zostaliśmy zapytani, czy na pewno chcemy połączyć się z nieznanym do tej pory hostem - operacja została potwierdzona `yes`. Ponieważ używamy klucza wygenerowanego przy pomocy techniki `ed25519`, który dodatkowo zabezpieczyłem hasłem, zostaliśmy poproszeni o podanie owego hasła. 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/8.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/9.png)

    **D) Konfiguracja 2FA**

    Na swoim koncie od dłuższego czasu używam weryfikacji dwuetapowej w postaci autoryzacji w aplikacji mobilnej.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/10.png)

4. **Zmiana gałęzi**

    **A) Branch `main`**

    ```bash
    git checkout main
    ```

    Powyższa komenda ustawia aktywną gałąź na `main`. W moim przypadku owa gałąź była już domyślnie wybrana.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/11.png)

    
    **B) Branch `GCL07`**
    
    ```bash
    git checkout GCL07
    ```

    Powyższa komenda ustawia aktywną gałąź na `GCL07`, która jest gałęzią przeznaczoną dla mojej grupy laboratoryjnej.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/12a.png)

5. **Utworzenie nowej gałęzi**

    ```bash
    git checkout -b WSZ417391
    ```

    Komenda poprzez sprecyzowanie flagi [-b] utworzy nowy *branch* o wskazanej nazwie: `WSZ417391`. Tak utworzony *branch* będzie odgałęzieniem branch `GCL07`, a więc będzie zawierał całą historię commitów z GCL07 do momentu jego utworzenia.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/12.png)

6. **Utworzenie katalogu**

    ```bash
    mkdir WSZ417391
    ```

    Komenda tworzy katalog o podanej nazwie: `WSZ417391`.
    
    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/13.png)

7. **Utworzenie GitHook'a**

    ```bash
    touch /home/wsz/MDO2025_INO/.git/hooks/commit-msg
    ```

    Powyższa komenda utworzy GitHook'a, który będzie weryfikował pewne zdefiniowane zasady. W naszym przypadku zdefiniowaną zasadą będzie sprawdzenie, czy każda wiadomość w commicie zaczyna się od inicjałów i numeru indeksu: `WSZ417391`.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/14.png)

    `Skrypt`

    ```bash
    #!/bin/bash

    EXPECTED_PREFIX="WSZ417391"
    COMMIT_MSG_FILE="$1"
    COMMIT_MSG=$(head -n1 "$COMMIT_MSG_FILE")

    if [[ ! $COMMIT_MSG =~ ^$EXPECTED_PREFIX ]]; then
    echo "❌ Error: Commit message must start with \"$EXPECTED_PREFIX\"."
    exit 1
    fi
    ```

    ```bash
    chmod +x /home/wsz/MDO2025_INO/.git/hooks/commit-msg
    ```

    Powyższa komenda nadaje uprawnienia do wykonywania dla skryptu `commit-msg`.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/15.png)

    ```bash
    cp /home/wsz/MDO2025_INO/.git/hooks/commit-msg /home/wsz/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/
    ``` 

    Powyższa komenda skopiuje skrypt do folderu `WSZ417391`.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/16.png)

8. **Próba wysłania zmian do zdalnego źródła**

    ```bash
    git status
    ```

    Powyższa komenda sprawdzi stan repozytorium. Otrzymaliśmy informację o nieśledzonych plikach, które utworzyliśmy. 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/17.png)

    ```bash 
    git add .
    ```

    Powyższa komenda dodaje wszystkie dokonane zmiany do `stage area`. `Stage area` jest obszarem przygotowawczym do zapisania zmian w repozytorium. Jest to etap poprzedzający zapisanie zmian w historii projektu. 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/18.png)

    ```bash
    git commit -m "Pierwszy commit"
    ``` 

    Powyższe polecenie zgodnie ze zdefiniowaną zasadą w GitHook'u zakończyło się niepowodzeniem, ponieważ wiadomość nie zaczynała się od `WSZ417391`.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/19.png)

    ```bash
    git commit -m "WSZ417391: Pierwszy commit"
    ``` 

    Powyższe polecenie zgodnie ze zdefiniowaną zasadą w GitHook'u zakończyło się powodzeniem, ponieważ wiadomość zaczynała się od `WSZ417391`.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/20.png)

    ```bash
    git push origin GCL07
    ```

    Powyższe polecenie wysyła zmiany do zdalnego repozytorium. W moim przypadku wystąpił błąd `Permission to InzynieriaOprogramowaniaAGH/MDO2025_INO.git denied to WinterWollf`, ponieważ na moment wykonywania zadanie nie zostałem dodany do organizacji `InzynieriaOprogramowaniaAGH`. 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/21.png)

9. **Próba wyciągnięcia gałęzi `WSZ417391` do gałęzi `GCL07`**

    ```bash
    git checkout GCL07
    git merge WSZ417391
    ```

    Powyższe komendy służą wciągnięciu gałęzi `WSZ417391` do gałęzi `GCL07`. Pierwsza z nich zmienia aktywną gałąź na `GCL07`, natomiast druga z nich merguje zmiany z gałęzi `WSZ417391` do gałęzi `GCL07`. Z powodu braku uprawnień wcześniejsze zadanie wysłania zmian do zdalnego repozytorium zakończyła się niepowodzeniem, co bezpośrednio uniemożliwia wciągnięcie gałęzi `WSZ417391` do gałęzi `GCL07`.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/22.png)

10. **Faktyczne wysłanie do zdalnego źródła**

    ```bash
    git push origin WSZ417391
    ```

    Po przypisaniu poprawnych uprawnień wysłanie zakończyło się pomyślnie.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/23.png)

11. **Próba wyciągnięcia gałęzi `WSZ417391` do gałęzi `GCL07`**

    ```bash
    git checkout GCL07
    git merge WSZ417391
    ```

    Powyższe komendy służą wciągnięciu gałęzi `WSZ417391` do gałęzi `GCL07`. Pierwsza z nich zmienia aktywną gałąź na `GCL07`, natomiast druga z nich merguje zmiany z gałęzi `WSZ417391` do gałęzi `GCL07`. Po przypisaniu poprawnych uprawnień wciągnięcie gałęzi zakończyło się pomyślnie.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_1/Zdjecia/24.png)

### Historia terminala znajduje się w pliku `historia.txt`.

    [-b]: https://git-scm.com/docs/git-checkout#Documentation/git-checkout.txt-emgitcheckoutem-b-Bltnew-branchgtltstart-pointgt


# Laboratorium 2 - Git, Docker

## Abstrakt
Celem laboratorium było zapoznanie się z podstawami pracy z narzędziem Docker. Omówiono sposoby tworzenia obrazów oraz uruchamiania kontenerów oraz zasad pisania Dockerfile. 

### Wykonane kroki

1. **Zainstalowanie Docker w systemie Linux**

    ```bash
    sudo dnf install docker
    ```

    Powyższe polecenie pobierze i zainstaluje `Docker` z oficjalnych bibliotek Fedora.
    
    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/1.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/2.png)

2. **Rejestracja na platformie `Docker-Hub`**

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/dockerHub.png)

3. **Pobranie obrazów `hello-world`, `busybox`, `fedora`, `mysql`**

    ```bash
    docker pull hello-world
    ```

    Powyższe polecenie pobierze obraz `hello-world`

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/3.png)

    ```bash
    docker pull busybox
    ```

    Powyższe polecenie pobierze obraz `busybox`

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/4.png)

    ```bash
    docker pull fedora
    ```

    Powyższe polecenie pobierze obraz `fedora`

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/5.png)

    ```bash
    docker pull mysql
    ```

    Powyższe polecenie pobierze obraz `mysql`

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/6.png)

    ```bash
    docker image ls
    ```

    Powyższe polecenie wyświetli listę pobranych obrazów.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/7.png)

4. **Uruchomienie kontenera z obrazu `busybox`**

    *4.1 Zwykłe uruchomienie*
    ```bash
    docker ps
    docker run busybox
    docker ps
    ```

    Powyższe polecenia uruchomiło kontener `busybox` lecz bez dodatkowych argumentów obraz `busybox` nie wykonuje żadnego długotrwałego procesu. Spowodowało to natychmiastowe zakończenie pracy kontenera.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/8.png)

    *4.2 Interaktywne połączenie i wywołanie numeru wersji*

    ```bash
    docker ps
    docker run -it -d busybox
    docker ps
    docker exec -it 5868ef4f3ea1 sh
    busybox
    ```

    Powyższe polecenia uruchamiają kontener `busybox` w trybie interaktywnym. Prowadzi to do powstania działającego kontenera - w przeciwieństwie do wersji z punktu *4.1*. Dodatkowa opcja `-d` (detached) powoduje uruchomienie kontenera w tle (bez pojawienia się nowego terminala, który działa w kontenerze). Polecenie `docker exec` uruchamia polecenie `sh` w uruchomionym kontenerze. Na koniec używając polecenia `busybox` wyświetlono numer wersji busybox'a.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/9.png)

5. **System w kontenerze**

    ```bash
    docker run -d -it fedora
    docker ps
    ```

    Polecenie uruchomi kontener, w którym będzie działać system `Fedora`. Kontener zostanie uruchomiony w trybie interaktywnym opcja `-it` oraz w trybie odłączonym `-d`.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/10.png)

    ```bash
    docker exec -it a7 bash
    ```

    Polecenie `docker exec` uruchamia `bash` w uruchomionym kontenerze. 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/11.png)

    *5.1 `PID1` procesy Docker na hoście*

    ```bash
    ps -fp 1
    ```

    Polecenie wyświetli pełne informacje (`-f`) procesu o ID 1 (`-p 1`). 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/12.png)

    ```bash
    ps aux | grep docker
    ```

    Powyższe polecenie zaprezentuje procesy dockera na hoście. 
    
    a) `a` - pokazuje procesy wszystkich użytkowników,
    b) `u` - wyświetla szczegółowy format z informacjami o użytkowniku, zużyciu procesora, pamięci itd,
    c) `x` - uwzględnia procesy, które nie są powiązane z terminalem (np. demony systemowe).
    
    Wyniki polecenia `ps aux` są przekazywane za pomocą operatora potoku `|` jak wejście do polecenia `grep docker`, które filtruje wyniki do takich, które zawierają słowo *docker*.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/12b.png)

    *5.2 Zaktualizuj pakiety*

    ```bash
    sudo dnf update
    ```

    Powyższe polecenie zaktualizuje pakiety systemu `Fedora`.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/13.png)
    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/14.png)

6. **Prosty plik Dockerfile**

    ```Dockerfile
    FROM fedora:latest

    RUN dnf install -y git && dnf clean all

    WORKDIR /repozytorium

    RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git .

    CMD ["/bin/bash"]
    ```

    Dockerfile wykorzystuje jako obraz bazowy obraz systemu `Fedora` w wersji *latest*. W kolejnym kroku pobierany i instalowany jest `git` opcja `-y` automatycznie akceptuje wszystkie pytania o akceptację instalacji. Polecenie `&& dnf clean all` czyści pamięć podręczną dnf, aby zmniejszyć rozmiar obrazu, ponieważ pamięć podręczna nie jest potrzebna w finalnym obrazie, a co za tym idzie tylko zwiększa jego rozmiar. Następnie ustawiany jest katalog roboczy `/repozytorium` - oznacza to, że wszystkie polecenia będą wykonywane w tym katalogu. Kolejno klonowane jest repozytorium przedmiotowe. Na sam koniec uruchomiona zostanie powłoka `bash`.

    ```bash
    cd /MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2
    docker build -t fedora-git .
    ```

    Polecenie zbuduje obraz `Dockera` na podstawie `Dockerfile` znajdującego się w bieżącym katalogu. Opcja `-t` nadaje nazwę i tag obrazowi - w naszym przypadku *fedora-git*. 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/15.png)

    ```bash
    docker run -it --rm fedora-git
    ls -la /repozytorium
    ```

    Powyższe polecenie uruchamia kontener na bazie obrazu *fedora-git* w trybie interaktywnym `-it` oraz z opcją `--rm`, która sprawi, że po wyjściu z kontenera ten zostanie automatycznie usunięty. Na poniższym zdjęciu widać, że repozytorium przedmiotowe zostało automatycznie sklonowane i znajduje się w kontenerze. 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/16.png)

7. **Uruchomione kontenery**

    ```bash
    docker ps
    ```

    Polecenie pokazuje aktualnie uruchomione kontenery. 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/17.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/17b.png)

8. **Wyczyszczenie obrazów**

    ```bash
    docker images
    docker rmi $(docker images -q)
    ```
    
    Pierwsze polecenie wylistuje wszystkie obrazy. Drugie polecenie usunie wszystkie obrazy na podstawie ich ID, które są podstawiane przez polecenie `$(docker images -q)` - opcja `-q` zapewnia, że w przypadku wystąpienia duplikatów obrazu te również zostaną usunięte. 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/18.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/19.png)

9. **Wystawienie Pull Request**

    ```bash
    git add /home/wsz/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2
    git commit -m "WSZ417391: Dodatkowy wymagany w spr Pull Request"
    git push
    ```

    Powyższe komendy dodają zmiany z folderu `Lab_2`. Następnie tworzą komita z odpowiednim komentarzem, a na koniec wypychają zmiany do repozytorium.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/pullRequest.png)
    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/pullRequest2.png)
    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/pullRequest3.png)
    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_2/Zdjecia/pullRequest4.png)

### Historia terminala znajduje się w pliku `historia2.txt`.


# Laboratorium 3 - Dockerfiles, kontener jako definicja etapu

## Abstrakt
Celem laboratorium było zapoznanie się z narzędziem do konteneryzacji aplikacji Docker. W ramach zajęć wybrano i sklonowano repozytorium aplikacji ToDo Web App napisanej w Node.js i Express.js. Następnie przeprowadzono proces budowania i uruchamiania aplikacji zarówno poza kontenerem, jak i wewnątrz kontenera Docker. Stworzono odpowiednie pliki Dockerfile do budowania, testowania i uruchamiania aplikacji w kontenerach. Dodatkowo, w ramach rozszerzonego zakresu, utworzono plik docker-compose.yml, który umożliwia automatyczne zarządzanie kontenerami, eliminując konieczność ręcznego budowania i uruchamiania.

### Wykonane kroki

1. **Wybór repozytorium - ToDo Web App**

    ```
    https://github.com/devenes/node-js-dummy-test
    ```

    Aplikacja typu ToDo wykonana w Node.js i Express.js

2. **Build programu (poza kontenerem)**

    ```bash
    git clone https://github.com/devenes/node-js-dummy-test
    cd node-js-dummy-test
    sudo dnf install npm
    npm install
    npm start
    ```

    Projekt wykorzystuje `Node Package Manager`, ponieważ nie wchodzi on w skład dystrubucji `Fedora 41` doinstalowano go poleceniem `sudo dnf install npm`. Za pomocą polecenia `npm install` zainstalowano wszystkie wymagane zależności potrzebne do poprawnego działania aplikacji. Na koniec uruchomiono aplikację za pomocą polecenia `npm start`.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/1.png) 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/2.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/3.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/4.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/5.png)

3. **Uruchomienie testów jednostkowych**

    ```bash
    npm test
    ```

    Polecenie uruchamia dołączone z projektem testy jednostkowe.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/6.png)

4. **Utworzenie kontenera**

    ```bash
    docker pull node:22.10
    ```

    Pobranie obrazu `Node` w wersji `22.10`.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/7.png)

    ```bash
    docker run -it node:22.10 bash
    git clone https://github.com/devenes/node-js-dummy-test
    cd node-js-dummy-test
    npm install
    npm start
    npm test
    ```

    Komenda `docker run -it node:22.10 bash` uruchamia kontener w trybie interaktywnym (`-it`) z obrazem `Node` w wersji 22.10. Wszystkie kolejne komendy są analogiczne względem poprzedniego punktu - *Build programu (poza kontenerem)*. Ze względu na brak ekspozycji portu kontenera nie jest możliwe załadowanie strony w celu zilustrowania działania programu, lecz nie znaczy to, że program nie działa. Program działa w 100% poprawnie.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/8.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/9.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/10.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/11.png)

5. **Stworzenie `Dockerfile` dla budowania i testowania programu**

    *5.1 Kontener budujący*

    ```dockerfile
    FROM node:22.10
    RUN git clone https://github.com/devenes/node-js-dummy-test
    WORKDIR /node-js-dummy-test
    RUN npm install
    ```

    Dockerfile wykorzystuje jako obraz bazowy obraz systemu `Node` w wersji *22.10*. Kolejno klonowane jest repozytorium projektu. Następnie ustawiany jest katalog roboczy `node-js-dummy-test` - oznacza to, że wszystkie polecenia będą wykonywane w tym katalogu. Na sam koniec instalowane są wszystkie potrzebne zależności.

    ```bash
    docker build -f ./Dockerfile.build -t node-build .
    ```

    Powyższa komenda tworzy obraz o nazwie `node-build` na podstawie `Dockerfile.build` opcja `-f`. Kropka `.` na końcu polecenia określa katalog, który Docker przesyła do demona Dockera podczas budowania obrazu - w tym przypadku katalog bieżący.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/12.png)

    *5.2 Kontener testujący*

    ```dockerfile
    FROM node-build
    RUN npm test
    ```
    Dockerfile wykorzystuje jako obraz bazowy utworzony przez nas wcześniej obraz `node-build`. Nie musimy ustawiać katalogu roboczego, ponieważ jest on dziedziczony z obrazu `node-build`. Na koniec uruchamiane są testy jednostkowe.

    ```bash
    docker build -f ./Dockerfile.test -t node-test .
    ```

    Powyższa komenda tworzy obraz o nazwie `node-test` na podstawie `Dockerfile.test` opcja `-f`. Kropka `.` na końcu polecenia określa katalog, który Docker przesyła do demona Dockera podczas budowania obrazu - w tym przypadku katalog bieżący.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/13.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/14.png)

6. **Uruchomienie kontenera**

    ```dockerfile
    FROM node-build
    CMD ["npm", "start"]
    ```

    Dockerfile wykorzystuje jako obraz bazowy utworzony przez nas wcześniej obraz `node-build`. Nie musimy ustawiać katalogu roboczego, ponieważ jest on dziedziczony z obrazu `node-build`. Na koniec tworzymy entry-point `CMD ["npm", "start"]`.

    ```bash
    docker build -f ./Dockerfile.run -t node-run .
    ```

    Powyższa komenda tworzy obraz o nazwie `node-run` na podstawie `Dockerfile.run` opcja `-f`. Kropka `.` na końcu polecenia określa katalog, który Docker przesyła do demona Dockera podczas budowania obrazu - w tym przypadku katalog bieżący.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/15.png)

    ```bash
    docker run -d --rm node-run
    ```

    Powyższe polecenie uruchamia kontener na bazie obrazu *node-run* w trybie odłączonym `-d` oraz z opcją `--rm`, która sprawi, że po zakończeniu pracy kontenera, ten zostanie automatycznie usunięty.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/16.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/17.png)

### Zakres rozszerzony 

1. **Stworzenie Dockerfile**

    ```dockerfile
    FROM node:22.10
    RUN git clone https://github.com/devenes/node-js-dummy-test
    WORKDIR /node-js-dummy-test
    RUN npm install
    ```

    ```yml
    version: "3.8"
    services:
    app:
        build: 
            context: .
            dockerfile: Dockerfile.compose
        container_name: node-compose
        ports:
        - "3000:3000"
        command: ["npm", "start"]
        restart: always
    test:
        build: 
            context: .
            dockerfile: Dockerfile.compose
        container_name: node-compose-test
        command: ["npm", "test"]
        depends_on:
        - app
    ```

    Plik docker-compose.yml pozwala na automatyczne zarządzanie kontenerami, eliminując konieczność ręcznego budowania i uruchamiania. Definiuje dwa serwisy: app (uruchamiający aplikację) oraz test (uruchamiający testy jednostkowe).
    

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/18.png)

    ```bash
    docker-compose up -d
    ```

    Polecenie zbuduje i uruchomi kontenery.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/19.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/20.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_3/Zdjecia/21.png)
    
2. **Dyskusja**

    Decyzja, czy aplikacja powinna być publikowana jako kontener, zależy od jej przeznaczenia oraz sposobu interakcji. W tym przypadku mamy aplikację Node.js, która bez problemu może działać w kontenerze.

    **1) Czy aplikacja nadaje się do wdrażania jako kontener?**

    Aplikaja nadaje się do wdrożenia jako kontener jeśli:
    - Aplikacja to serwer HTTP,
    - Środowisko uruchomieniowe wymaga wielu zależności, które łatwiej zarządzać w obrazie Dockera,
    - Ma działać w środowisku chmurowym (np. Kubernetes, AWS),
    
    Aplikaja nie nadaje się do wdrożenia jako kontener jeśli:
    - Aplikacja wymaga interakcji użytkownika (GUI).

    **2) Jak przygotować finalny artefakt?**
    - Publikacja jako kontener -> Należy usunąć niepotrzebne pliki builda i upewnić się, że obraz jest optymalny.
    - Dystrybucja jako pakiet (JAR, DEB, RPM, EGG) -> Jeśli konteneryzacja nie jest odpowiednia (sytuacje opisane powyżej) można zdecydować się na dystrybucję jako pakiety.
    - Dystrybucję w różnych formatach -> Można wykorzystać trzeci kontener, który przygotuje finalny artefakt.

### Historia terminala znajduje się w pliku `historia3.txt`.


# Laboratorium 4 - Dodatkowa terminologia w konteneryzacji, instalacja Jenkins

## Abstrakt
Celem laboratorium było zapoznanie się z tworzeniem i zarządzaniem woluminami oraz konfiguracją sieci. Dodatkowo przeprowadzono testy wydajnościowe z użyciem iperf3, skonfigurowano środowisko Jenkins do automatyzacji procesów CI/CD oraz omówiono różne aspekty usług w kontekście systemu, kontenerów i klastrów.

### Wykonane kroki

### Zachowanie stanu

1. **Przygotowanie woluminów**

    ```bash
    docker volume create --name input_volumin
    ```

    Powyższa komedna tworzy wolumin przeznaczony na dane wejściowe.

    ```bash
    docker volume create --name output_volumin
    ```

    Powyższa komedna tworzy wolumin przeznaczony na dane wyjściowe

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/1.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/2.png)

2. **Dostosowanie kontenera bazowego (zmiana wersji Node)**

    ```dockerfile
    FROM node:22.10-slim

    WORKDIR /node-js-dummy-test
    ```

    Zdecydowano się na zmianę wersji `Node`. Jak obraz kontenera Dockerowego posłuży obraz node w wersji `22.10-slim`, ponieważ spełnia ona wymagania i nie dostarcza domyślnie zainstalowanego narzędzia `git`. Polecenie `VOLUME` deklaruje punkty montowania, ale nie przpisuje konkretnych woluminów.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/3.png)

3. **Zbudowanie obrazu**

    ```bash
    docker build -f ./Dockerfile -t node-slim-build .
    ```

    Powyższa komenda tworzy obraz o nazwie node-slim-build na podstawie Dockerfile - opcja -f. Kropka . na końcu polecenia określa katalog, który Docker przesyła do demona Dockera podczas budowania obrazu - w tym przypadku katalog bieżący.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/4.png)

4. **Uruchomienie kontenera oraz potwierdzenie braku `git`**

    ```bash
    docker run -it --rm node-slim-build bash
    git --version
    ```

    Pierwsza komenda uruchamia kontener na bazie obrazu `node-slim-build`. Kontener uruchamiany jest w trybie interaktywnym. Druga komenda sprawdza zainstalowaną wersję `git`.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/5.png)

5. **Sklonowanie repozytorium na wolumin wejściowy (kontener pomocniczy)**

    ```bash
    docker run --rm -v input_volumin:/mnt/input node:22.10 git clone https://github.com/devenes/node-js-dummy-test /mnt/input
    ```

    Uruchomienie kontenera pomocnicznego, jako obrazu użyto `node-22.10`, który ma domyślnie zainstalowanego `git`. Za pomocą opcji `-v` podłączono wolumin `input_volumin`.  Następnie sklonowano docelowe repozytorium z projektem.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/6.png)

6. **Uruchomienie kontenera**

    ```bash
    docker run -it --rm -v input_volumin:/mnt/input -v output_volumin:/mnt/output node-slim-build bash
    ```

    Uruchomienie kontenera bazowego. Za pomocą opcji `-v` podłączono wolumin `inpu_volumin` oraz wolumin `output_volumin`.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/7.png)

7. **Zbudowanie projektu w kontenerze oraz zapisanie powstałych plików na woluminie wyjściowym**

    ```bash
    cd ../mnt/input
    npm install
    ```

    Za pomocą polecenia npm install zainstalowano wszystkie wymagane zależności potrzebne do poprawnego działania aplikacji. 

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/8.png)

    ```bash
    cp -r /mnt/input/node_modules /mnt/output/
    ```

    Polecenie `cp` przy określeniu flagi `-r` kopiuje katalog `node_modules` na wolumin `output_volumin`.

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/9.png)

    ![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/10.png)

8. **Możliwości uproszczeń**

    ```yaml
    ...
    volumes:
        input_volumin:
        output_volumin:
    ```

    Korzystajać z `compose.yaml` możemy uprościć procedurę uruchamiania kontenera, aby nie potrzeba było specyfikować za każdym razem woluminów przy uruchamianiu kontenera.

### Eksponowanie portu

1.1 *Utworzenie kontenera*

```bash
docker run -it --name kontener_1 -t ubuntu bash
```

Powyższa komenda uruchomi kontener o nazwie `kontener_1` (flaga `--name`) w trybie interaktywnym  flaga `-it`. Jak obraz kontenera posłuży `ubuntu`.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/12.png)

1.2 *Instalacja `iperf` w kontenerze*

```bash
apt update && apt install -y iperf3
```

Powyższa komenda instaluje `iperf3`.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/11.png)

1.3 *Uruchomienie serwera `iperf3`*

```bash
iperf3 -s
```

Uruchomienie serwera iperf3.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/14.png)

1.4 *Sprawdzenie adresu IP kontenera*

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 3bca2c8ef0ed85f3b10d252363a70139744f046c58cd3406bde95dfcbbaea1ef
```

Powyższa komenda wyświetli adres IP kontenera o podanym ID. Flaga `-f` pozwala wyciągnąć tylko konkretne dane – w tym przypadku adres IP z sekcji NetworkSettings.Networks. Opcja {{range}} iteruje po wszystkich sieciach, do których kontener jest podłączony i wyświetla odpowiadające im adresy IP. ID kontenera *wyciągnięto* z jego logów.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/15.png)

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/16.png)

1.5 *Utworzenie kontenera*

```bash
docker run -it --name kontener_2 -t ubuntu bash
```

Powyższa komenda uruchomi kontener o nazwie `kontener_2` (flaga `--name`) w trybie interaktywnym  flaga `-it`. Jak obraz kontenera posłuży `ubuntu`.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/17.png)

1.6 *Instalacja iperf3*

```bash
apt update && apt install -y iperf3
```

Powyższa komenda instaluje `iperf3`.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/18.png)

1.7 *Połączenie do serwera*

```bash
iperf3 -c 172.17.0.2
```

Powyższa komenda łączy się z serwerm iperf3, który działa na adresie `172.17.0.2`. Poniżej przedstawiono statystyki przepustowości w GB/s oraz inne statystyki przesyłu.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/19.png)

1.8 *Utworzenie własnej sieci mostkowej*

```bash
docker network create wlasny_mostek
```

Powyższa komenda tworzy sieć sieć mostkową o nazwie `wlasny_mostek`.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/20.png)

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/21.png)

1.9 *Utworzenie kontenera połączonego do własnej sieci mostkowej*

```bash
docker run -it --name kontener_1 --network=wlasny_mostek -t ubuntu bash
apt update && apt install -y iperf3
iperf3 -s
```

Powyższa komenda uruchomi kontener o nazwie `kontener_1` (flaga `--name`) w trybie interaktywnym  flaga `-it`. Jak obraz kontenera posłuży `ubuntu`. Opcja `--network` pozwala zdefiniować konkretną sieć z jakiej ma korzystać kontener. Pozostałe komendy instalują i uruchamiają serwer iperf3.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/22.png)

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/23.png)

1.10 *Utworzenie kontenera połączonego do własnej sieci mostkowej*

```bash
docker run -it --name kontener_2 --network=wlasny_mostek -t ubuntu bash
apt update && apt install -y iperf3
```

Powyższa komenda uruchomi kontener o nazwie `kontener_2` (flaga `--name`) w trybie interaktywnym  flaga `-it`. Jak obraz kontenera posłuży `ubuntu`. Opcja `--network` pozwala zdefiniować konkretną sieć z jakiej ma korzystać kontener. Pozostałe komendy instalują iperf3.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/24.png)

1.11 *Połączenie do serwera (z kontenera)*

```bash
iperf3 -c kontener_1
```

Stworzenie swojej własnej sieci mostkowej daje nam dodatkową funkcjonalność w porównaniu do sieci domyślnej - dostajemy od razu gotowego i działającego DNS'a.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/25.png)

1.12 *Połączenie do serwera (z hosta)*

```bash
docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq)
```

Ponieważ nasz host nie korzysta z naszej własnej sieci mostkowej `wlasny_mostek` nie ma dostępu do jego DNS'a, co za tym idzie nie ma możliwości połączenia się do serwera po nazwie kontenera. W celu połączenia się z poziomu hosta do serwera należy użyć adresu IP kontenera. 

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/26.png)

```bash
iperf3 -c 172.18.0.2
```

Powyższa komenda połączy hosta z serwerem działającym w kontenerze o takim adresie IP.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/27.png)

1.13 *Opis uzyskanych wyników*

W każdym z przeprowadzanych przypadków przeprowadzone testy zakończyły się powodzeniem. W każdym z testów nastapiła retransmisja danych na poziomie od 1 do 4 retransmisji na test. Bitrate na przestrzeni wszystkich testów waha się na poziomie od 18.3 Gb/s do 19.6 Gb/s. Każdy z testów trwał 10 sekund, dane były wysyłane w interwałach czasowych co 1 sekundę.

### Jenkins

Wszystkie poniższe kroki zostały wykonane na bazie dokumentacji Jenkins'a: https://www.jenkins.io/doc/book/installing/docker/

1.1 *Utworzenie nowej sieci mostkowej*

```bash
docker network create jenkins
```

Powyższa komenda tworzy sieć mostkową o nazwie `jenkins`.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/28.png)

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/29.png)

1.2 *Uruchomienie pomocnika DIND*

```bash
docker run \
--name jenkins-docker \
--detach \
--privileged \
--network jenkins \
--network-alias docker \
--env DOCKER_TLS_CERTDIR=/certs \
--volume jenkins-docker-certs:/certs/client \
--volume jenkins-data:/var/jenkins_home \
--publish 2376:2376 \
docker:dind \
--storage-driver overlay2
```

Opisy flag:
- `--name` - pozwala określić nazwę kontenera 
- `--detach` - uruchamia kontener w tle
- `--privileged` - obecnie uruchomienie *Docker in Docker* wymaga podania tego parametru
- `--network` - określenie z jakiej sieci ma korzystać stworzony kontener
- `--network-alias` - udostępnia *Docker in Docker* jako *docker* w sieci *jenkins*
- `--env` - umożliwia korzystanie z protokołu TLS na serwerze. Ze względu na użycie flagi `--privileged` uzycie tej flagi jest zalecane
- `--volume` - mapuje określone foldery wewnątrz kontenera na określone woluminy
- `--publish` - Udostępnia port demona Docker na hoscie (opcjonalne)

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/30.png)

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/31.png)

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/32.png)

1.3 *Stworzenie Dockerfile*

```dockerfile
FROM jenkins/jenkins:2.492.2-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```

1.4 *Zbudowanie obrazu*

```bash
docker build -f ./Dockerfile.jenkins -t myjenkins .
```

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/33.png)

1.5 *Zbudowanie kontenera*

```bash
docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins
```

Opisy flag:
- `--name` - pozwala określić nazwę kontenera 
- `--restart` - określa w jakich przypadkach kontener zostanie uruchomiony ponownie
- `--detach` - kontener zostanie uruchomiony w tle
- `--network` - określenie z jakiej sieci ma korzystać stworzony kontener
- `--env` - określenie zmiennych środowiskowych 
- `--publish` - mapuje porty konteneru na porty hosta
- `--volume` - mapuje określone foldery wewnątrz kontenera na określone woluminy

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/34.png)

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/35.png)

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/36.png)

1.6 *Strona logowania*

```bash
ip add
```
    
Dzieki tej komendzie otrzymamy adres IP naszej wirtualnej maszyny `Feodra 41`.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/37.png)

```http
192.168.1.51:8080
```

W naszym przypadku adresem IP maszyny wirtualnej jest `192.168.1.51`. Port `8080` został określony w poprzednich krokach. 

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/38.png)

Po wpisaniu hasła znajdującego się w `\var\jenkins_home\secrets\initialAdminPassword` uzyskalismy dostęp do możliwości zainstalowania wtyczek.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/39.png)

### Usługi w rozumieniu systemu, kontenera i klastra

1.1 *Utworzenie kontenera z Fedora*

```bash
docker run -d --name ssh_ubuntu -p 2222:22 ubuntu bash -c "apt update && apt install -y openssh-server && service ssh start && tail -f /dev/null"
docker exec -it ssh_ubuntu bash
```

Powyższa komenda tworzy kontener na bazie obrazu `Ubuntu` o nazwie *ssh_ubuntu* - opcja `--name`. Kontener zostanie uruchomiony w tle - `-d`. Dodatkowo zostało ustawione przekierowanie portów za pomocą flagi `-p`. Dodatkowo przy pomocy falgi `-c` przekazujemy `bash` komendę do wykonania - wtym przypadku polecenie instalacji serwera ssh, polecenie włączenia usługi ssh, oraz polecenie utrzymania kontenera w stanie uruchomionym (nieskończona pętla).

1.2 *Dodanie użytkownika i ustawienie haseł*

```bash
useradd -m user && echo "user:password" | chpasswd
```

Powyższa komenda dodaje użytkownika o nazwie `user`. Opcja `-m` tworzy katalog domowy dla nowego użytkownika. Druga część komendy generuje ciąg tekstowy. Narzędzie `chpasswd` ustawia hasło dla użytkownika, w naszym przypadku hasło dla użytkownika `user` to `passwoard`.

```bash
mkdir -p /home/user/.ssh && chmod 700 /home/user/.ssh
```

Powyższa komenda utworzy (jeśli jest taka potrzeba - flaga `-p`) nadrzędne katalogi. Druga część komendy zmieni uprawnienia do katalogów - w naszym przypadku `700` oznacza pełne prawa – odczyt, zapis, wykonanie dla właściciela (user) oraz brak uprawnień dla grup i innych.

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/42.png)

1.3 *Połączenie po SSH*

```bash
ssh user@localhost -p 2222
```

Powyższa komenda nawiązuje połączenie SSH z lokalnym komputerem na określonym porcie. 

![Zdjecie](/MDO2025_INO/ITE/GCL07/WSZ/417391/Sprawozdanie1/Lab_4/Zdjecia/41.png)

1.4 *Podsumowanie*

Zalety:
- Łatwość integracji,
- Stałe IP,
- Zdalny dostęp – Możliwość zarządzania kontenerem bez użycia docker exec (jeśli nie ma takiej możliwości).

Wady:
- Overhead – Dodatkowa warstwa (proces SSHD) zwiększa zasoby CPU/RAM,
- Niepotrzebne w większości przypadków – Kontenery mają docker exec,
- Bezpieczeństwo – Źle skonfigurowane SSH w kontenerze to dodatkowy wektor ataku.

Przypadki użycia:
- Gdy zarządzanie kontenerem wymaga dostępu z zewnętrznych maszyn.

### Jenkins - zależności

1.1 *Co jest potrzebne by w naszym Jenkinsie uruchomić Dockerfile dla buildera?*

By w Jenkinsie uruchomić Dockerfile dla buildera, potrzebny jest zainstalowany Docker na maszynie Jenkinsa, odpowiednio skonfigurowany pipeline (np. Jenkinsfile) z krokami budowania obrazu oraz dostęp do Dockera z poziomu użytkownika Jenkinsa. 

1.2 *Co jest potrzebne w Jenkinsie by uruchomić Docker Compose?* 

Do uruchomienia Docker Compose w Jenkinsie wymagane jest zainstalowanie Docker Compose na serwerze Jenkinsa, plik `docker-compose.yml` w repozytorium projektu oraz skonfigurowany pipeline wywołujący komendy Docker Compose, jak np. *docker-compose* up, z zapewnionym dostępem do Dockera.

### Historia terminala znajduje się w pliku `historia4.txt`.