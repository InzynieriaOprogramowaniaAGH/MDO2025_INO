# Sprawozdanie - Zajęcia 01

## Zalogowanie się na serwerze
![Ss 0](sources/screen1/1-9.png)

## Sklonowanie repozytorium przedmiotowego za pomocą HTTPS 
![Ss 1](sources/screen1/1-12.png)

## Tworzenie dwóch kluczy SSH
![Ss 2](sources/screen1/1-0.png)
![Ss 3](sources/screen1/1-1.png)

## Sklonowanie repozytorium za pomocą protokołu SSH
![Ss 4](sources/screen1/1-13.png)

## Konfiguracja weryfikacji dwuetapowej (2FA)
![Ss 5](sources/screen1/1-11.png)

## Konfiguracja klucza SSH jako metody dostępdu do GitHub
![Ss 6](sources/screen1/1-10.png)

## Utworzenie gałęzi 'AB414799' wychodzącej z gałęzi GCL01
![Ss 7](sources/screen1/1-2.png)
![Ss 8](sources/screen1/1-3.png)
![Ss 9](sources/screen1/1-4.png)

## Pisanie skryptu, nadanie uprawnień do jego uruchamiania oraz umieszczenie go w katalogu ~/MDO2025_INO/.git/hooks/
![Ss 10](sources/screen1/1-5.png)
![Ss 11](sources/screen1/1-6.png)
![Ss 12](sources/screen1/1-7.png)
## Git Hook
```bash
    #!/bin/bash
    REQUIRED_PREFIX="AB414799"
    MESSAGE=$(cat "$1")

    if [[ ! "$MESSAGE" =~ ^$REQUIRED_PREFIX ]]; then
        echo "❌ Commit message musi zaczynać się od: $REQUIRED_PREFIX"
        exit 1
    fi
```
## Dodanie plików do śledzenia przez Git'a
![Ss 13](sources/screen1/1-15.png)

## Wykonanie commita
![Ss 14](sources/screen1/1-14.png)

## Wysłanie zmian na GitHub'a
![Ss 15](sources/screen1/1-17.png)

## Wciągnięcie gałęzi 'AB414799' do gałęzi grupowej GCL01
![Ss 16](sources/screen1/1-16.png)

