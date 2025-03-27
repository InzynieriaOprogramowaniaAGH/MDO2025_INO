# Sprawozdanie
## Wstęp, Git, Gałęzie, SSH
### 1) Instalacja Git i kluczy SSH Aby rozpocząć pracę z systemem Git oraz zapewnić bezpieczne połączenie przez SSH, zainstalowano odpowiednie narzędzia.
    sudo apt-get install git
    apt-get install openssh-server
![0](https://github.com/user-attachments/assets/07765b4f-d32a-4f9c-affa-23de9d4eb0fd)
![image](https://github.com/user-attachments/assets/895ee287-57fe-4112-a4e4-d5e09884cb07)


### 2) Repozytorium przedmiotowe zostało sklonowane za pomocą polecenia git clone, początkowo używając protokołu HTTPS.
        git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO
![image](https://github.com/user-attachments/assets/e72599c4-0e33-4b7f-b6c6-5c1d67b7c557)


### 3)Generowanie kluczy SSH i zmiana połączenia na SSH Aby zapewnić bezpieczne połączenie z GitHubem bez konieczności każdorazowego podawania loginu i hasła, wygenerowano dwa klucze SSH: jeden dla algorytmu ed25519, drugi dla ecdsa.

![1](https://github.com/user-attachments/assets/46db9f25-13cd-405f-99ed-528a8f4ec90a)
![image](https://github.com/user-attachments/assets/45f65d8c-ff0d-4f9a-a03f-f293719692a7)

Następnie klucze zostały dodane do agenta SSH:

![2](https://github.com/user-attachments/assets/4df17867-5a64-406b-b748-b7c8c7f1f3c5)

Zmieniono połączenie z repozytorium na SSH:

![3](https://github.com/user-attachments/assets/ee421b52-e96b-4656-9902-88015be3ec8a)

### 4) Zmiana gałęzi Po skonfigurowaniu połączenia SSH przełączono się na gałąź główną i gałąź dedykowaną dla grupy.
        git checkout main
        git checkout GCL02
![4 1](https://github.com/user-attachments/assets/f9619c28-f188-4d66-86e0-fff7b3ee38c2)
![4 2](https://github.com/user-attachments/assets/2686ca3a-171f-4db6-be8d-b18f3bace47d)

### 5) Stworzenie nowej gałęzi Utworzono nową gałąź o nazwie KP415903, odgałęziając ją od gałęzi grupowej.

### 6)Praca na nowej gałęzi W odpowiednim katalogu stworzono folder o nazwie KP415903. Utworzono również Git hooka, który sprawdza, czy wiadomość commit zaczyna się od "KP415903".

