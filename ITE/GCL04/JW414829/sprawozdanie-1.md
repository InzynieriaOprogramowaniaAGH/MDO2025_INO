## Zajęcia 01

### 1. Instalacja Gita i konfiguracja kluczy SSH
Zainstalowałem Gita w systemie i wygenerowałem klucze SSH:
![Generowanie kluczy](./lab1/ssh-keygen.png)

Klucze publiczne dodałem w ustawieniach GitHuba (zakładka **SSH and GPG keys**).
![Dodany klucz](./lab1/github-key.png)

Skonfigurowałem 2FA na koncie GitHub.
![alt text](./lab2/github-2fa.png)

---

### 2. Klonowanie repozytorium
Klonowanie bez uzycia ssh wymagało zalogowania się do konta na githubie.

Klonowanie przez SSH:
![Klonowanie przez SSH](./lab1/repo-clone.png)

### 3. Przełączanie się na gałęzie
Przełączyłem się na gałąź `main`, a następnie na gałąź grupową `GCL04`. Następnie utworzyłem gałąź składającą się z moich inicjałów i numeru indeksu (`JW414829`):

![Zmiana brancha](./lab1/switch-branch.png)

---

### 4. Utworzenie katalogu i napisanie Git hooka
W katalogu **ITE/GCL04** stworzyłem folder `JW414829`.
![Mkdir](./lab1/mkdir.png)

W tym folderze umieściłem plik **sprawozdanie-1.md**.

Pracowałem na hooku bezpośrednio w katalogu `.git/hooks/`, więc nie musiałem nadawać mu uprawnień. Następnie skopiowałem go do mojego katalogu.

#### Treść hooka (`commit-msg`)

```bash
#!/usr/bin/sh

required_prefix="JW414829"
first_line=$(head  -n1  "$1")

case  "$first_line"  in
"$required_prefix"*)
;;
*)
echo  "Błąd: commit musi zaczynać się od '$required_prefix'." >&2
exit  1
;;

esac
```

Następnie przetestowałem działanie hooka.

![Test hooka](./lab1/hook-test.png)

---

### 5. Dodanie sprawozdania, zrzutów ekranu i wysłanie zmian
Utworzyłem/zmodyfikowałem pliki, dodałem je i zrobiłem commit:
![Commit i push](./lab1/commit-push.png)

Wykonałem próbę wciągnięcia mojej gałęzi do gałęzi grupowej aczkolwiek nie pushowalem tego na remote.
![Test merge](./lab1/merge.png)

---

## Zajęcia 02

### 1. Instalacja dockera i rejestracja w dockerhub
Ten krok wykonałem jeszcze na poprzednich zajęciach po poleceniu prowadzącego.
![Docker install](./lab2/docker-install.png)

---

### 2. Pobranie obrazów `hello-world`, `busybox`, `ubuntu`, `fedora` i `mysql`
Pobrałem wszystkie obrazy z polecenia. Na zrzuce ekranu zamieszczam tylko przykład z fedorą.
![Docker pull fedora](./lab2/pull-fedora.png)

---

### 3. Uruchomienie busybox
Uruchomiłem kontener busybox z poleceniem echo, a następnie uruchomiłem ten sam kontener interaktywnie i sprawdzilem numer wersji oraz z niego wyszedłem.
![Busybox](./lab2/busybox.png)

---

### 4. Uruchomienie ubuntu w kontenerze
Uruchomiłem ubuntu w kontenerze a następnie pokazałem PID1 w tym kontenerze, zaaktualizowałem pakiety i z niego wyszedłem.
![Ubuntu](./lab2/ubuntu.png)

---

### 5. Stworzyłem, zbudowałem i uruchomiłem prosty plik Dockerfile.
W dockerfile upewniłem się, ze kontener będzie miał gita
```bash
RUN apt-get update && \
    apt-get install -y git curl && \
    rm -rf /var/lib/apt/lists/*
```
oraz ze repozytorium będzie sklonowane

```bash
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /app
```

ponizej znajduje się cały plik Dockerfile

```bash
FROM ubuntu:latest

LABEL maintainer="JW414829"

RUN apt-get update && \
    apt-get install -y git curl && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /app

WORKDIR /app

CMD ["/bin/bash"]
```

Zbuildowałem Dockerfile:
![Dockerfile run](./lab2/dockerfile-build.png)

A następnie go uruchomiłem oraz aby sprawdzić działanie gita jeszcze raz, sklonowałem drugi raz repozytorium.
![Dockerfile run](./lab2/dockerfile-run.png)



---

### 6. Sprawdziłem uruchomione kontenery i wyczyściłem je

Polecenie `docker ps -aq` generuje listę identyfikatorów wszystkich kontenerów, a `docker rm` usuwa te kontenery. 

![Uruchomione kontenery](./lab2/uruchomione-kontenery.png)
![Usuniecie kontenerow](./lab2/usuniecie-kontenerow.png)

---

Polecenie `docker images -aq` generuje listę identyfikatorów wszystkich obrazów, a `docker rmi` usuwa te obrazy.

### 7. Wyczyściłem obrazy
![Czyszczenie obrazow](./lab2/usuniecie-obrazow.png)

---

### 8. Dockerfile dodałem do sprawozdania i do repozytorium w /lab2/docker-repo/Dockerfile

---
## Zajęcia 03

### 1. Wybór oprogramowania

Jako oprogramowanie wybrałem repozytorium irssi.

Sklonowałem repozytorium z aplikacją i zbuildowałem program.
![Klonowanie repo](./lab3/repo-clone.png)


A następnie doinstalowałem wymagane pakiety i uruchomiłem testy.

![dnf install](./lab3/dnf-install.png)
![test](./lab3/test.png)


### 2. Przeprowadzenie buildu w kontenerze

Jako bazowy obraz uruchomiłem kontener ubuntu z interaktywnym terminalem.
![kontener bazowy pod aplikacje](./lab3/ubuntu-container.png)

Zaaktualizowałem zalezności i upewniłem się, ze git jest zainstalowany.
![apt get](./lab3/apt-get.png)

Następnie sklonowałem repozytorium wewnątrz kontenera.
![git clone](./lab3/repo-clone-container.png)

Przeszedłem do katalogu z aplikacją i pobrałem wymagane zalezności a następnie zbudowałem aplikację.
![apt get in container](./lab3/apt-get-container.png)
![build in container](./lab3/build-container.png)

Uruchomiłem testy
![test in container](./lab3/test-container.png)

### 2. Utworzenie plików Dockerfile w celu zautomatyzowania wcześniejszych kroków

Utworzyłem dwa pliki:
* `Dockerfile.build`
* `Dockerfile.test`

`Dockerfile.build` opiera się na obrazie Ubuntu. Instaluje on wszystkie wymagane zalezności, klonuje repozytorium projektu do odpowiedniego folderu a następnie konfiguruje środowisko builda wykorzystując do tego Meson i kompiluje projekt przy uzyciu Ninja.

Do zbudowania obraz builda wykorzystałem `docker build`:
![irssi-build](./lab3/build-irssi-build.png)


`Dockerfile.test` bazuje na obrazie utworzonym przez poprzedni Dockerfile i wykonuje jedynie testy bez ponownego budowania projektu.

Do zbudowania obrazu testującego aplikację takze wykorzystałem `docker build`. W Dockerfile uwzględniłem nazwę poprzedniego obrazu `irssi-build`.
![irssi-build](./lab3/build-irssi-test.png)

Aby upewnić się, ze kontener z buildem pracuje poprawnie uruchomiłem go w trybie interaktywnym i upewniłem się, ze w katalogu build znajduje się zbudowany projekt
![irssi-build run](./lab3/run-irssi-build.png)

Następnie uruchomiłem kontener z testami, który takze zadziałał w oczekiwany sposób.
![irssi-test run](./lab3/run-irssi-test.png)

## Zajęcia 04
### 1. 