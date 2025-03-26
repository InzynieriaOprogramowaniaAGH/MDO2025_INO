# Sprawozdanie 1

## 001-Class
Niestety źle przemyślałem sprawę i w przypadku pierwszych laboratoriów zapomniałem robić screenów więc postarałem się zrobić później takie screeny które pokazują, że zainstalowałem odpowiednie rzeczy i ustawiłem na githubie.

1. Zainstaluj klienta Git i obsługę kluczy SSH
    
    <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/001-Class/lab1_1.png" /> 

2. Sklonowanie repozytorium za pomocą HTTPS i personal access token.

    Najpierw sklonowałem repozytorium za pomocą HTTPS i później dodałem personal access token do githuba.
    <img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/001-Class/lab1_2.png" />

6. Praca na nowej gałęzi
    - Treść githooka
    
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