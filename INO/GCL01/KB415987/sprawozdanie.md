# Sprawozdanie - Zajęcia 01
## Git Hook
    #!/bin/bash
    COMMIT_MSG=$(cat "$1")
    if [[ ! "$COMMIT_MSG" =~ ^KB415987 ]]; then
        echo "Error: Commit message have to start with 'KB415987'"
        exit 1
    fi


## Zalogowanie się na serwerze
![Ss 0](resources/s0.png)

## Sklonowanie repozytorium przedmiotowego za pomocą HTTPS 
![Ss 1](resources/s1.png)

## Tworzenie dwóch kluczy SSH
![Ss 2](resources/s2.png)

## Sklonowanie repozytorium za pomocą protokołu SSH
![Ss 3](resources/s3.png)

## Konfiguracja weryfikacji dwuetapowej (2FA)
![Sg 0](resources/g0.png)

## Konfiguracja klucza SSH jako metody dostępdu do GitHub
![Sg 1](resources/g1.png)
## Utworzenie gałęzi 'KB415987' wychodzącej z gałęzi GCL01
![Ss 4](resources/s4.png)

## Pisanie skryptu, nadanie uprawnień do jego uruchamiania oraz umieszczenie go w katalogu ~/MDO2025_INO/.git/hooks/
![Ss 5](resources/s5.png)

## Dodanie pliku ze sprawodzaniem, umieszczenie w nim treści napisanego wcześniej git hooka oraz dodanie zrzutów ekranu wraz z opisem zrealizowanych kroków
![Ss 6](resources/s6.png)

# Historia poleceń
    1   ls
    2   git --version
    3   git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
    4   ls
    5   ls ~/.ssh/
    6   ssh-keygen -t ecdsa -b 521 -f ~/.ssh/id_ecdsa
    7   ls ~/.ssh/
    8   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "k...@gmail.com"
    9   cat ~/.ssh/id_ed25519.pub
    10  ssh -T git@github.com
    11  git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
    12  ls
    13  cd MDO2025_INO/
    14  git branch
    15  git checkout GCL01
    16  git branch -v
    17  git checkout -b KB415987
    18  ls
    19  cd INO/
    20  cd GCL01/
    21  mkdir KB415987
    22  cd KB415987/
    23  nano commit-msg
    24  chmod +x commit-msg
    25  cp commit-msg ../../../.git/hooks/
    26  nano sprawozdanie.md
    27  cat commit-msg
    28  nano sprawozdanie.md
    29  history
