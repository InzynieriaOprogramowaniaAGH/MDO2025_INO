# Sprawozdanie 1

## 001-Class

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


```bash
commit_msg=$(cat "$1")

if ! [[ "$commit_msg" =~ ^JS415003.* ]]; then
    echo "ERROR: Commit message musi zaczynać się od 'JS415003'"
    echo "Twoja wiadomość: $commit_msg"
    exit 1
fi

exit 0
```