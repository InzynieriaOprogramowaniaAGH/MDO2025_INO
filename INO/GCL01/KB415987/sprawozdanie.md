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

## Dodanie plików do śledzenia przez Git'a
![Ss 7](resources/s7.png)

## Wykonanie commita
![Ss 8](resources/s8.png)

## Wysłanie zmian na GitHub'a
![Ss 10](resources/s10.png)

## Wciągnięcie gałęzi 'KB415987' do gałęzi grupowej GCL01
![Ss 11](resources/s11.png)
