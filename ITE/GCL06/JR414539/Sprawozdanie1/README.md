# Sprawozdanie 1

---

## **Zajęcia 1**

## 1. **Zainstalowanie Gita oraz obsługi kluczy SSH**

Weryfikacja poprawnej instalacji Git.

![Zrzut ekranu – instalacja gita](zrzuty_ekranu/1.png)

Instalacja i sprawdzenie działania klienta SSH.

![Zrzut ekranu – obsługa kluczy SSH](zrzuty_ekranu/2.png)

## 2. **Sklonowanie repozytorium przedmiotowego za pomocą HTTPS i personal access token**

Sklonowanie repozytorium oraz weryfikacja połączenia zdalnego i aktualizacja gałęzi main.

![Zrzut ekranu – Sklonowanie repozytorium przedmiotowego za pomocą HTTPS](zrzuty_ekranu/3.png)

Utworzenie personal access token do uwierzytelniania przez HTTPS.

![Zrzut ekranu – personal access token](zrzuty_ekranu/4.png)

## 3. **Utworzenie dwóch kluczy SSH, w tym co najmniej jeden zabezpieczony hasłem**

Wygenerowanie dwóch kluczy SSH: ED25519 bez hasła oraz ECDSA zabezpieczonego hasłem, wraz z uruchomieniem agenta SSH.

![Zrzut ekranu – Utworzenie dwóch kluczy SSH ](zrzuty_ekranu/5.png)

## 4. **Skonfigurowanie klucza SSH jako metodę dostępu do GitHuba oraz sklonowanie repozytorium z wykorzystaniem protokołu SSH**

Dodanie kluczy ED25519 i ECDSA do agenta SSH za pomocą ssh-add.

![Zrzut ekranu – Skonfigurowanie klucza SSH jako metodę dostępu do GitHuba ](zrzuty_ekranu/6.png)

Weryfikacja poprawnego połączenia SSH z GitHub oraz klonowanie repozytorium za pomocą protokołu SSH.

![Zrzut ekranu – Skonfigurowanie klucza SSH jako metodę dostępu do GitHuba ](zrzuty_ekranu/8.png)

## 5. **Pokazanie kluczy na githubie**

Pokazanie jak to wygląda na githubie

![Zrzut ekranu – Pokazanie kluczy na githubie ](zrzuty_ekranu/9.png)

## 6. **Skonfigurowanie 2FA**

Włączenie dwuskładnikowego uwierzytelniania (2FA) na koncie GitHub z wykorzystaniem aplikacji Authenticator

![Zrzut ekranu – 2FA ](zrzuty_ekranu/10.png)

## 7. **Utworzenie gałęci o nazwie "inicjały & nr indeksu"**

Utworzyłem gałąź JR414539 oraz wypchnąłem ją na GitHub.

![Zrzut ekranu – Utworzenie gałęci o nazwie "inicjały & nr indeksu ](zrzuty_ekranu/12.png)

## 8. **Napisanie Git hooka - skrypt weryfikujący czy każdy mój "commit message" zaczyna się od moich inicjałów i numeru indeksu(JR414539)**

Stworzenie katalogu oraz nadanie uprawnień.

![Zrzut ekranu – Stworzenie katalogu oraz nadanie uprawnień ](zrzuty_ekranu/14.png)

Sprawdzenie czy stworzony skrypt działą.

![Zrzut ekranu – Sprawdzenie czy git-hook działą ](zrzuty_ekranu/15.png)

Kod skryptu:

#!/bin/bash

commit_msg=$(cat "$1")

prefix="JR414539"

if [[ "$commit_msg" != "$prefix"* ]]; then
    echo "Błąd: Commit message musi zaczynać się od '$prefix'."
    exit 1
fi

exit 0

## **Zajęcia 2**

## 1. **Zainstalowanie Dockera w systemie linuksowym oraz zalogowanie się**

Dodanie oficjalnego repozytorium Docker do systemu Ubuntu przy użyciu GPG i curl.

![Zrzut ekranu – GPG i curl ](zrzuty_ekranu/17.png)

Zakończenie instalacji Dockera, uruchomienie usługi i dodanie użytkownika do grupy docker.

![Zrzut ekranu – dodanie użytkownika, instalacja Dockera ](zrzuty_ekranu/18.png)

Weryfikacja działania Dockera poprzez uruchomienie kontenera hello-world oraz logowanie do konta Docker Hub.

![Zrzut ekranu – Weryfikacja działania dockera ](zrzuty_ekranu/19.png)

Zalogowanie do Docker Hub oraz wyszukiwanie dostępnych obrazów systemu Ubuntu.

![Zrzut ekranu – sprawdzenie dostępnych obrazów systemu Ubuntu ](zrzuty_ekranu/20.png)

## 2. **Pobranie obrazów hello-world, busybox, ubuntu, mysql**

Pobranie obrazów Docker: busybox, ubuntu, mysql oraz wyświetlenie listy dostępnych obrazów.

![Zrzut ekranu – pobranie obrazów ](zrzuty_ekranu/21.png)

## 3. **Uruchomienie kontenera z obrazu busybox**

Podłączenie się do kontenera interaktywnie i wywołanie numeru wersji

![Zrzut ekranu – Podłączenie się do kontenera interaktywnie i wywołanie numeru wersji ](zrzuty_ekranu/22.png)

## 4. **Uruchomienie "systemu w kontenerze", wybrałem kontener z obrazu ubuntu**

Zaprezentowanie PID1 w kontenerze i procesów dockera na hoście, a także zaktualizowanie pakietów

![Zrzut ekranu – PID1 i zaktualizowanie pakietów ](zrzuty_ekranu/24.png)

![Zrzut ekranu – procesy ](zrzuty_ekranu/25.png)

## 5. **Stworzenie własnoręcznie, zbudowanie i uruchomienie prostego pliku Dockerfile bazującego na wybranym systemie i sklonowanie repozytorium**

Stworzenie katalogu

![Zrzut ekranu – PID1 i zaktualizowanie pakietów ](zrzuty_ekranu/26.png)

Stworzenie Dockerfilea, jego kod:

FROM ubuntu:latest

LABEL maintainer="Jakub Robak"

RUN apt update && apt upgrade -y && \
    apt install -y git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

CMD ["/bin/bash"]

Zbudowanie własnego obrazu Dockera na bazie Ubuntu z Gitem oraz uruchomienie kontenera zawierającego sklonowane repozytorium.

![Zrzut ekranu – PID1 i zaktualizowanie pakietów ](zrzuty_ekranu/28.png)

Wyświetlenie wszystkich utworzonych kontenerów, zatrzymanie ich oraz usunięcie przy pomocy poleceń docker stop oraz docker rm.

![Zrzut ekranu – PID1 i zaktualizowanie pakietów ](zrzuty_ekranu/29.png)

Wyświetlenie listy dostępnych obrazów oraz ich usunięcie za pomocą polecenia docker image prune -a.

![Zrzut ekranu – PID1 i zaktualizowanie pakietów ](zrzuty_ekranu/30.png)

























