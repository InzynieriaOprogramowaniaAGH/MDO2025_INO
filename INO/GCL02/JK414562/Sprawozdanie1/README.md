## Laboratorium 1: Wprowadzenie, Git, Gałęzie, SSH

### 0) Przygotowanie środowiska pracy
- Uruchomiłem maszynę wirtualną z systemem Linux Ubuntu w Oracle VirtualBox.
- Połączyłem się z nią zdalnie za pomocą SSH.
- Skonfigurowałem Visual Studio Code, używając rozszerzenia Remote - SSH.

### 1) Instalacja Git i kluczy SSH
Aby rozpocząć pracę z systemem Git oraz zapewnić bezpieczne połączenie przez SSH, zainstalowano odpowiednie narzędzia.

![image](https://github.com/user-attachments/assets/de868aad-30c9-49da-9446-c1c1a274cba5)

![image](https://github.com/user-attachments/assets/a2e9937f-8904-4da9-85f5-99163f8ff151)


### 2) Repozytorium przedmiotowe zostało sklonowane za pomocą polecenia `git clone`, początkowo używając protokołu HTTPS:
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO
![image](https://github.com/user-attachments/assets/860f0afb-e664-4c8b-8742-ce2a3192a443)

### 3) Generowanie kluczy SSH i zmiana połączenia na SSH
Aby zapewnić bezpieczne połączenie z GitHubem bez konieczności każdorazowego podawania loginu i hasła, wygenerowano dwa klucze SSH: jeden dla algorytmu ed25519, drugi dla ecdsa.

![image](https://github.com/user-attachments/assets/99d8fbc3-ed10-4a20-a2da-2241bb2d08d3)

![image](https://github.com/user-attachments/assets/4fc70ab6-d38e-4d4b-99b5-9e2067d808f7)

Zmieniono połączenie z repozytorium na SSH:
![image](https://github.com/user-attachments/assets/1325dd9c-7578-49f9-a49f-ff0e4b276a05)


### 4) Zmiana gałęzi
Po skonfigurowaniu połączenia SSH przełączono się na gałąź główną i gałąź dedykowaną dla grupy.

git checkout main git checkout GCL02
   
![image](https://github.com/user-attachments/assets/57dc43cd-e823-4096-8191-ee9de9853dd6)


### 5) Stworzenie nowej gałęzi
Utworzono nową gałąź o nazwie `KP415903`, odgałęziając ją od gałęzi grupowej.
git checkout -b JK414562
![image](https://github.com/user-attachments/assets/85e12db4-9757-4345-9e2c-b952912b19bc)


### 6) Stworzono skrypt `commit-msg`, który wymusza, by każdy komunikat commit zawierał wstęp z inicjałami i numerem indeksu użytkownika. Skrypt został zapisany w katalogu `.git/hooks/` i nadano mu prawa wykonywalności.
    mkdir -p .git/hooks cd .git/hooks touch pre-commit nano pre-commit chmod +x pre-commit
    mkdir -p .git/hooks
    cd .git/hooks
    touch pre-commit
    nano pre-commit
    chmod +x pre-commit

    #!/bin/bash
    EXPECTED_PREFIX="JK414562"
    COMMIT_MSG=$(cat "$1")
    if [[ "$COMMIT_MSG" != $EXPECTED_PREFIX* ]]; then
    echo "Error: Początek wiadomości musi zaczynać się od '$EXPECTED_PREFIX'."
    exit 1
    fi
![image](https://github.com/user-attachments/assets/80e9c452-a24f-46ed-89e3-49ab220374d7)
![image](https://github.com/user-attachments/assets/fd2f3037-08ce-4a95-bc99-1ffe370bc127)
![image](https://github.com/user-attachments/assets/77337adc-6852-41c6-83eb-cc4b61b9d9a4)
## Laboratorium 2 Git, Docker

### 1) Instalacja Docker
Na systemie Ubuntu zainstalowano oprogramowanie Docker przy użyciu polecenia:
      
      sudo dnf install -y docker
   ![image](https://github.com/user-attachments/assets/06e49c26-bc56-4883-aced-96dff7ea6cc8)

### 2) Pobrano obrazy: hello-world, busybox, ubuntu, fedora, mysql. Wykorzystano polecenie docker pull
   ![image](https://github.com/user-attachments/assets/813039e9-a11b-4f80-b570-518c38642e76)
### 3) Uruchomiono kontener z obrazu busybox, podłaczono się do niego interkatywnie i wywołano numer wersji systemu.
   ![image](https://github.com/user-attachments/assets/94f22783-ee04-407e-a86e-7dc5e54ed301)
   Pokaż efekt uruchomienia kontenera
   ![image](https://github.com/user-attachments/assets/9219e997-5a1f-43ce-aa35-5475b8857798)
### 4) Podłącz się do kontenera interaktywnie i wywołaj numer wersji
   ![image](https://github.com/user-attachments/assets/0b147c8b-62f4-4705-b224-583bb073567a)
### 5) Uruchom "system w kontenerze" (czyli kontener z obrazu fedora lub ubuntu)
   - Zaprezentuj PID1 w kontenerze i procesy dockera na hoście
   ![image](https://github.com/user-attachments/assets/a78b95cb-2893-417e-95d4-c1402c5ea4fe)

   - Zaktualizuj pakiety
   ![image](https://github.com/user-attachments/assets/1082390d-dae6-4e05-a1e3-ec8e5491b7c9)
### 6) Stwórz własnoręcznie, zbuduj i uruchom prosty plik Dockerfile bazujący na wybranym systemie i sklonuj nasze repo.
   - Uruchom w trybie interaktywnym i zweryfikuj że jest tam ściągnięte nasze repozytorium
    ![image](https://github.com/user-attachments/assets/63ded7f7-c87f-4898-9a3b-d68440cf123d)

     ![image](https://github.com/user-attachments/assets/27e6b901-8004-4195-86c1-84cc5a0ddab9)

### 7)Pokaż uruchomione ( != "działające" ) kontenery, wyczyść je.
 ![image](https://github.com/user-attachments/assets/9c61aba4-7f9b-4c84-bda3-bcdc245e4138)

### 8) Wyczyść obrazy
   ![image](https://github.com/user-attachments/assets/ceed0dc6-56d2-4ff9-9f36-97a4726514ec)

### 9) Utworzony plik Dockerfile został dodany do katalogu Sprawozdanie1 wewnątrz repozytorium na gałęzi JK414562.

## Laboratorium 3: Dockerfiles, kontener jako definicja etapu
### 1) Do przeprowadzenia ćwiczenia wybrano repozytorium python-examples które skonowałem poleceniem:

![image](https://github.com/user-attachments/assets/1422f88f-440d-4f53-b9c7-f72f239c2baa)

### 2) Sklonowanie niniejszego repozytrium 
![image](https://github.com/user-attachments/assets/a5341b98-07a8-411a-8e45-194e61dea0dc)

### 3) Doinstalowanie wymaganych zależności 
![image](https://github.com/user-attachments/assets/3cec14be-88ad-4f79-80a4-b32db60aa4d6)

### 4) Przeprowadź build programu (doinstaluj wymagane zależności)
![image](https://github.com/user-attachments/assets/d33092ce-393b-4f41-ba0b-b49153553a18)

### 5) Uruchom testy jednostkowe dołączone do repozytorium
![image](https://github.com/user-attachments/assets/e20e7844-e404-49cb-93df-707d5aad8194)

### 6) Uruchomienie kontenera i praca interaktywna
7)      docker run --name pytest-container -it ubuntu:latest bash
![image](https://github.com/user-attachments/assets/669b086a-1a2e-4a49-8b13-8ec5bc822b52)

### 8)Przygotowanie środowiska w kontenerze
![image](https://github.com/user-attachments/assets/7b57c28c-11ca-4968-a7c4-e5c2513b81e1)
![image](https://github.com/user-attachments/assets/802c8fea-221a-4d5c-b0a7-dab0891b7334)

### 9)Sklonowałem repozytorium
![image](https://github.com/user-attachments/assets/fdaa641c-55fb-42a3-a027-5f3f7cca9675)
### 10)Skonfigurowałem środowisko i uruchomilem build
![image](https://github.com/user-attachments/assets/77239e69-cc41-4737-9d29-d997f958732e)

### 11)Uruchomilem testy
![image](https://github.com/user-attachments/assets/8d5e1137-bee2-47df-a44a-018bd2f734c1)

### 12)Stwórz dwa pliki Dockerfile automatyzujące kroki powyżej, z uwzględnieniem następujących kwestii:
- Kontener pierwszy ma przeprowadzać wszystkie kroki aż do builda
![image](https://github.com/user-attachments/assets/b2b5d0ba-753e-4c27-8a91-a273e790f774)
- Kontener drugi ma bazować na pierwszym i wykonywać testy (lecz nie robić builda!)
![image](https://github.com/user-attachments/assets/a509bfe7-153e-454b-9745-05a4ee5b5cd6)
- Budowanie obrazów 
![image](https://github.com/user-attachments/assets/8f8ead0c-fd8b-4bcf-98a7-ba09d6a1fd2e)
- Sprawdzenie pierwszego kontenera (pytest-build)
![image](https://github.com/user-attachments/assets/6330d016-43de-443e-b896-418cc1ae8b29)

## Laboratorium 4 Dodatkowa terminologia w konteneryzacji, instancja Jenkins
### 1) Przygotowanie woluminów wejściowego i wyjściowego oraz podłączenie ich do kontenera bazowego
![image](https://github.com/user-attachments/assets/ed43521d-720c-48e9-98f5-90220c938b18)

### 2) Uruchomienie kontenera Ubuntu z zamontowanymi woluminami wejściowym (input:/mnt/input) i wyjściowym (output:/mnt/output). 
 ![image](https://github.com/user-attachments/assets/999dfa20-7fcb-495a-bf94-9163fafc2649)

### 3) Sklonuj repozytorium na wolumin wejściowy
![image](https://github.com/user-attachments/assets/f59e35f5-eac1-40cb-b583-2bf3ac43f506)
### 4) Repozytorium zostało sklonowane bez użycia kontenera czy bind mount, ale poprzez zapis w katalogu woluminu na hoście (/var/lib/docker/volumes/input/_data). Dzięki temu sklonowane pliki będą dostępne dla kontenerów korzystających z tego woluminu.

### 5) Uruchom build w kontenerze 
![image](https://github.com/user-attachments/assets/85fd0734-cb0d-42c6-b6c3-f8409d4294f5)
### 6) Wykonano hatch build, co wygenerowało pakiety .whl i .tar.gz
![image](https://github.com/user-attachments/assets/dc777161-63c3-421c-83ff-1c915d67f891)

### 7) Skopiowałem repozytorium do wewnątrz kontenera
![image](https://github.com/user-attachments/assets/3a70c3cc-2838-4feb-b250-e3244865377c)

### 8) Zapisz powstałe/zbudowane pliki na woluminie wyjściowym, tak by były dostępne po wyłączniu kontenera.
![image](https://github.com/user-attachments/assets/1207ad9c-15ac-4209-82aa-f734ef880b79)
![image](https://github.com/user-attachments/assets/0aa6fce0-0ad6-4b2a-81cb-0c7586f6166b)

### 9) Ponów operację, ale klonowanie na wolumin wejściowy przeprowadź wewnątrz kontenera (użyj gita w kontenerze)
![image](https://github.com/user-attachments/assets/f2d13143-90ce-4aa4-abdc-09571f3009ce)


### 10) Przedyskutuj możliwość wykonania ww. kroków za pomocą docker build i pliku Dockerfile. (podpowiedź: RUN --mount)
Zawartość pliku Dockerfile
![image](https://github.com/user-attachments/assets/de3f40f1-5377-4b81-9c10-3842b479c421)
Budowanie obrazu Docker z obsługą testów w pytest
![image](https://github.com/user-attachments/assets/737029f0-2ca2-4704-8801-88454adee496)

## Eksponowanie portu
### 1) Zapoznalem się z dokumentacją https://iperf.fr/
### 2) Uruchomienie serwera iperf3 wewnątrz kontenera, z eksponowaniem portu 5201.
![image](https://github.com/user-attachments/assets/38fffff8-9c35-41ca-8fe1-ff4cb1efd439)

### 3) Utworzenie dedykowanej sieci mostkowej o nazwie my_bridge.
![image](https://github.com/user-attachments/assets/386e86cf-1c11-4725-b824-cbee74a8edfe)

### 4) Połącz się z nim z drugiego kontenera, zbadaj ruch
![image](https://github.com/user-attachments/assets/7f3441a8-115e-4bca-bc15-90b9fba9d933)

### 5) Ponów ten krok, ale wykorzystaj własną dedykowaną sieć mostkową (zamiast domyślnej). Spróbuj użyć rozwiązywania nazw
![image](https://github.com/user-attachments/assets/118a1bb5-8a4b-481c-b132-24d024bc0c43)

### 6) Przedstaw przepustowość komunikacji lub problem z jej zmierzeniem
![image](https://github.com/user-attachments/assets/a2907492-2455-4c73-9d01-0274dc1a8cef)

## Instancja Jenkins
### 1) Zapoznałem się z dokumentacją https://www.jenkins.io/doc/book/installing/docker/
### 2) Przeprowadź instalację skonteneryzowanej instancji Jenkinsa z pomocnikiem DIND
### 3) Utworzyłem sieć poleceniem
4)      docker network create jenkins
### 5) Uruchomiłem kontener Jenkins docker run -d --name jenkins --network jenkins \ w tej sieci
![image](https://github.com/user-attachments/assets/7b32f282-f62d-4e39-b6b3-e0b5f38dce35)
### 6) Sprawdziłem, że kontener działa (docker ps), co jest potwierdzeniem zainicjalizowanej instancji Jenkinsa.
### 7) Uzyskanie hasła administratora Jenkins
![image](https://github.com/user-attachments/assets/ca9ecdc0-b663-41a6-aa6e-14b766fd887c)
### 8) Wszedłem na strone https://localhost:8080 i zalogowałem się z użyciem hasła
![image](https://github.com/user-attachments/assets/f154662f-fccb-4e3a-ba04-d635bc00d998)
![image](https://github.com/user-attachments/assets/8e543bd6-7c67-4103-ae4f-39e76fb32285)





























 









