## 1) Instalacja Git i kluczy SSH Aby rozpocząć pracę z systemem Git oraz zapewnić bezpieczne połączenie przez SSH, zainstalowano odpowiednie narzędzia.
![image](https://github.com/user-attachments/assets/de868aad-30c9-49da-9446-c1c1a274cba5)

![image](https://github.com/user-attachments/assets/a2e9937f-8904-4da9-85f5-99163f8ff151)

## 2) Repozytorium przedmiotowe zostało sklonowane za pomocą polecenia git clone, początkowo używając protokołu HTTPS.
     git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO
     ![image](https://github.com/user-attachments/assets/860f0afb-e664-4c8b-8742-ce2a3192a443)
## 3)Generowanie kluczy SSH i zmiana połączenia na SSH Aby zapewnić bezpieczne połączenie z GitHubem bez konieczności każdorazowego podawania loginu i hasła, wygenerowano dwa klucze SSH: jeden dla algorytmu ed25519, drugi dla ecdsa.
   ![image](https://github.com/user-attachments/assets/99d8fbc3-ed10-4a20-a2da-2241bb2d08d3)

![image](https://github.com/user-attachments/assets/4fc70ab6-d38e-4d4b-99b5-9e2067d808f7)

Zmieniono połączenie z repozytorium na SSH:
![image](https://github.com/user-attachments/assets/1325dd9c-7578-49f9-a49f-ff0e4b276a05)

## 4) Zmiana gałęzi Po skonfigurowaniu połączenia SSH przełączono się na gałąź główną i gałąź dedykowaną dla grupy.

         git checkout main
         git checkout GCL02
   
![image](https://github.com/user-attachments/assets/57dc43cd-e823-4096-8191-ee9de9853dd6)
## 5) Stworzenie nowej gałęzi Utworzono nową gałąź o nazwie KP415903, odgałęziając ją od gałęzi grupowej.
 git checkout -b JK414562
![image](https://github.com/user-attachments/assets/85e12db4-9757-4345-9e2c-b952912b19bc)

## 6)Stworzono skrypt commit-msg, który wymusza, by każdy komunikat commit zawierał wstęp z inicjałami i numerem indeksu użytkownika. Skrypt został zapisany w katalogu .git/hooks/ i nadano mu prawa wykonywalności.
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
![image](https://github.com/user-attachments/assets/7b41b221-467e-444b-a126-c13d7e46f26c)









