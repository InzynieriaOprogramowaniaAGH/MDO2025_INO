# Sprawozdanie 

# Pierwsze zajęcia

## Logowanie do serwera
![Ss 0](sources/screen1/1-9.png)

## Klonowanie repozytorium za pomocą HTTPS
![Ss 1](sources/screen1/1-12.png)

## Generowanie dwóch kluczy SSH
![Ss 2](sources/screen1/1-0.png)
![Ss 3](sources/screen1/1-1.png)

## Klonowanie repozytorium z wykorzystaniem SSH
![Ss 4](sources/screen1/1-13.png)

## Aktywacja weryfikacji dwuetapowej (2FA)
![Ss 5](sources/screen1/1-11.png)

## Ustawienie klucza SSH jako metody autoryzacji w GitHub
![Ss 6](sources/screen1/1-10.png)

## Utworzenie gałęzi „AB414799” na podstawie „GCL01”
![Ss 7](sources/screen1/1-2.png)
![Ss 8](sources/screen1/1-3.png)
![Ss 9](sources/screen1/1-4.png)

## Tworzenie skryptu, nadawanie uprawnień i umieszczanie go w katalogu hooków Git
![Ss 10](sources/screen1/1-5.png)
![Ss 11](sources/screen1/1-6.png)
![Ss 12](sources/screen1/1-7.png)
## Konfiguracja Git Hooka do sprawdzania wiadomości commitów
```bash
    #!/bin/bash
    REQUIRED_PREFIX="AB414799"
    MESSAGE=$(cat "$1")

    if [[ ! "$MESSAGE" =~ ^$REQUIRED_PREFIX ]]; then
        echo "❌ Commit message musi zaczynać się od: $REQUIRED_PREFIX"
        exit 1
    fi
```
## Dodawanie plików do kontroli wersji w Git
![Ss 13](sources/screen1/1-15.png)

## Tworzenie commita w repozytorium
![Ss 14](sources/screen1/1-14.png)

## Wysyłanie zmian do GitHub
![Ss 15](sources/screen1/1-17.png)

## Scalanie gałęzi „AB414799” z „GCL01”
![Ss 16](sources/screen1/1-16.png)


# Drugie zajęcia
## Instalacja Dockera `sudo dnf install -y docker`
![Ss 17](sources/screen2/2-0.png)

## Pobieranie obrazów „hello-world”, „busybox”, „ubuntu” i „mysql”
![Ss 18](sources/screen2/2-1.png)
## Uruchamianie kontenera na bazie „busybox”
![Ss 19](sources/screen2/2-2.png)
## Interaktywne podłączenie do kontenera i sprawdzenie wersji
![Ss 20](sources/screen2/2-3.png)

## Start systemu „ubuntu” i analiza procesów Dockera
![Ss 21](sources/screen2/2-4.png)

## Aktualizacja pakietów `ubuntu`:
![Ss 22](sources/screen2/2-5.png)

## Tworzenie pliku `Dockerfile`:
```Dockerfile
FROM ubuntu:latest
RUN apt update && apt install -y git
WORKDIR /repo
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /repo
CMD ["bash"]
```
## Budowanie obrazu z pliku `Dockerfile`
```bash
docker build -t new_image .
```
![Ss 23](sources/screen2/2-6.png)

## Uruchamianie kontenera na podstawie nowego obrazu
```bash
docker run -it new_image
```
![Ss 24](sources/screen2/2-7.png)
#### Repozytorium przedmiotowe zostało pomyślnie sklonowane.
#
## Sprawdzenie uruchomionych kontenerów i ich usuwanie
![Ss 25](sources/screen2/2-8.png)
![Ss 26](sources/screen2/2-9.png)
## Wyświetlanie dostępnych obrazów i ich usuwanie
![Ss 27](sources/screen2/2-10.png)

## Umieszczenie pliku „Dockerfile” w katalogu „Sprawozdanie1”
![Ss 28](sources/screen2/2-11.png)

# Trzecie zajęcia
