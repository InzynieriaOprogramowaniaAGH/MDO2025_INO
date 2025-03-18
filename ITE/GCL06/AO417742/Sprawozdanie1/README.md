Sprawozdanie 1

1. Instalacja Git i SSH

Na początku zainstalowałem Git oraz OpenSSH na maszynie wirtualnej z systemem Ubuntu, aby umożliwić pracę z repozytorium i obsługę kluczy SSH.



1. Sprawdzenie poprawnej instalacji:

   git --version

   ssh -V	



2. Wygenerowanie dwóch  kluczy SSH do uwierzytelniania na GitHub:

   ssh-keygen -t ed25519 -C "aolech55@gmail.com"

   ssh-keygen -t ecdsa -b 521 -C "aolech55@gmail.com"



3. Dodałem klucz prywatny do agenta SSH: 

   eval "$(ssh-agent -s)"

   ssh-add ~/.ssh/id_ed25519

	

   oraz skopiowałem klucz publiczny do GitHub:

   cat ~/.ssh/id_ed25519.pub



4. Aby zweryfikować poprawność połączenia SSH wykonałem polecenie: 

   ssh -T git@github.com



 

2. Klonowanie repozytorium

Następnym krokiem było sklonowanie repozytorium przedmiotowego na maszynę wirtualną.

W pierwszej kolejności użyłem metody HTTPS, a następnie SSH. 



1. Utworzyłem Personal Access Token (PAT) na github oraz skopiowałem token do pliku 



2. Klonowanie repozytorium przez HTTPS:



git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git



3. Klonowanie repozytorium przez SSH



git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git



5. Sprawdziłem status repozytorium za pomocą polecenia:



git status



6. Dodatkowo zgodnie z poleceniem włączyłem 2FA na GitHub, aby zwiększyć bezpieczeństwo konta 





3. Praca na gałęziach Git



Kolejnym krokiem było przełączenie się na odpowiednie gałęzie w repozytorium.



1. Przełączenie się na gałąź main:

   git checkout main

   git pull origin main



2. Sprawdzenie dostępnych gałęzi odbywa się za pomocą polecenia:

   git branch -r



3. Następnie przełączyłem się na gałąź grupową i utworzyłem nową gałaz 

   git checkout -b GCL06 origin/GCL06

   git checkout -b AO417742

   git push -u origin AO417742



4. Implementacja Git Hooka:

Aby zapewnić jednolity format commit message zaimplementowałem skrypt GitHook commit-msg, który sprawdza czy każdy commit zaczyna się od AO417742



1. Utworzyłem folder dla mojej pracy o nazwie AO417742

   cd GCL06 

   mkdir AO417742



2. Następnie napisałem skrypt commit-msg

#!/bin/bash

commit_msg=$(cat "$1")

if [[ ! $commit_msg =~ ^AO417742 ]]; then
    echo " BŁĄD: commit message musi zaczynać się od 'AO417742'"
    exit 1
fi

echo "Commit message poprawny!"
exit 0

3. Testowanie dodawania commita

