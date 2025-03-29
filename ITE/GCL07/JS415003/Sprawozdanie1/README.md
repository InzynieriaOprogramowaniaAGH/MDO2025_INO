# Sprawozdanie 1

## 001-Class
Niestety źle przemyślałem sprawę i w przypadku pierwszych laboratoriów zapomniałem robić screenów więc postarałem się zrobić później takie screeny które pokazują, że zainstalowałem odpowiednie rzeczy i ustawiłem na githubie.

1. Zainstaluj klienta Git i obsługę kluczy SSH
    
    <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/001-Class/lab1_1.png" /> 

2. Sklonowanie repozytorium za pomocą HTTPS i personal access token.

    Najpierw sklonowałem repozytorium za pomocą HTTPS i później dodałem personal access token do githuba.
    <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/001-Class/lab1_2.png" />

3. Upewnij się w kwestii dostępu do repozytorium jako uczestnik i sklonuj je za pomocą utworzonego klucza SSH, zapoznaj się [dokumentacją](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
   - Utwórz dwa klucze SSH, inne niż RSA, w tym co najmniej jeden zabezpieczony hasłem
   <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/001-Class/lab1_4.png" />

   - Skonfiguruj klucz SSH jako metodę dostępu do GitHuba
   <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/001-Class/lab1_5.png" />

   - Sklonuj repozytorium z wykorzystaniem protokołu SSH

   Po sklonowaniu przeze mnie repozytorium za pomocą HTTPS musiałem później zmienić URL zdalnego repozytorium na mojej maszynie stosując komendę:
    
    ```bash
    git remote set-url origin NOWY_URL
    ```

    Efektem tego później są zmienione URL.

    <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/001-Class/lab1_3.png" />

   - Skonfiguruj 2FA
   <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/001-Class/lab1_6.png" />

4. Przełącz się na gałąź ```main```, a potem na gałąź swojej grupy
<img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/001-Class/lab1_7.png" />

5. Utwórz gałąź o nazwie "inicjały & nr indeksu" np. ```KD232144```. Miej na uwadze, że odgałęziasz się od brancha grupy!
    Na poprzednim screenie widać że utworzyłem gałąź ze swoimi inicjałami.

6. Rozpocznij pracę na nowej gałęzi
   - W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu" np. ```KD232144```
   <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/001-Class/lab1_8.png" />

   - Dodaj ten skrypt do stworzonego wcześniej katalogu.

        Na poprzednim screenie już widać, że plik jest w folderze.

   - Skopiuj go we właściwe miejsce, tak by uruchamiał się za każdym razem kiedy robisz commita.

        Tutaj przykład, że rzeczywiście hook działa dobrze.
        <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/001-Class/lab1_9.png" />

   - Umieść treść githooka w sprawozdaniu.
    ```bash
    commit_msg=$(cat "$1")

    if ! [[ "$commit_msg" =~ ^JS415003.* ]]; then
        echo "ERROR: Commit message musi zaczynać się od 'JS415003'"
        echo "Twoja wiadomość: $commit_msg"
        exit 1
    fi

    exit 0
    ```

## 002-Class
1. Instalacja Dockera na Fedorze
<img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/002-Class/1.png" title="Docker instalacja" /> 

2. Rejestracja na Docker Hub
<img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/002-Class/Docker_registration.png" title="Docker rejestracja" /> 

3. Pobranie obrazów

    Pobranie każdego z nich to użycie komendy "docker pull [obraz]".
    <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/002-Class/2.png" title="Pobieranie obrazów" /> 

4. Uruchom kontener z obrazu `busybox`
   - Pokaż efekt uruchomienia kontenera
   - Podłącz się do kontenera **interaktywnie** i wywołaj numer wersji

   <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/002-Class/3.png" title="Uruchomienie busyboxa" /> 
   
   Wersja busyboxa ukazała mi się dopiero po wpisaniu komendy "busybox --help".

5. Uruchom "system w kontenerze" (czyli kontener z obrazu `fedora` lub `ubuntu`)
   - Zaprezentuj `PID1` w kontenerze i procesy dockera na hoście
   - Zaktualizuj pakiety
   - Wyjdź

   <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/002-Class/4.png" title="Uruchomienie kontenera ubuntu" />  

6. Tworzenie Dockerfile i testowanie działania
    - Treść Dockerfile 

    <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/002-Class/5.png" title="Dockerfile" />

    - Budowanie i uruchomienie z pliku Dockerfile

    <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/002-Class/6.png" title="Uruchomienie kontenera ubuntu" />

7. Sprawdzenie czy kontener się utworzył i czy jest wyłączony.

    <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/002-Class/7.png" title="Kontenery" />

    Po sprawdzeniu wyczyszczenie kontenera.

    <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/002-Class/8.png" title="Czyszczenie kontenera" />

8. Czyszczenie obrazu.

    <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/002-Class/9.png" title="Czyszczenie obrazu" />

9. Dodanie plików do folderu.

    <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/002-Class/10.png" title="Foldery" />

## 003-Class