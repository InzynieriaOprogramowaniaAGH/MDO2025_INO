# Sprawozdanie

## 1. Instalacja Git i obsługa SSH

### Instalacja Git
```sh
sudo dnf install -y git
```
![Instalacja git](image.png)

### Sprawdzenie działania SSH
#### Sprawdzenie adresu IP
```sh
ip a
```
![Adres IP maszyny](image-1.png)

#### Połączenie z serwerem przez SSH
```sh
ssh uzytkownik@ip
```
![Połączenie przez SSH przez VSC](image-2.png)

Jak widać, udało się podłączyć do serwera przez SSH.

---

## 2. Sklonowanie repozytorium przedmiotowego za pomocą HTTPS i personal access token

### Sklonowanie repozytorium przez HTTPS
![Sklonowanie przez HTTPS](image-3.png)

### Historia poleceń
![Historia poleceń](image-4.png)

### Wygenerowanie kluczy SSH
![Klucz SSH 1](image-5.png)
![Klucz SSH 2](image-6.png)

Klucz 1 i 2 (z hasłem)

### Historia poleceń
![Historia poleceń](image-7.png)

---

## 3. Skonfigurowanie dostępu na GitHubie i sklonowanie repozytorium za pomocą SSH

### Dodanie SSH-agenta i podpięcie kluczy
![ssh-agent](image-8.png)

### Dodanie klucza SSH na GitHubie
![Klucz SSH](image-9.png)

### Sklonowanie repozytorium za pomocą SSH
![Klonowanie repo po SSH](image-10.png)

### Historia poleceń
![Historia poleceń](image-11.png)

---

## 4. Przełączenie się na gałąź `main`, a potem na gałąź swojej grupy oraz utworzenie własnego brancha

### Przejście na odpowiednie gałęzie i stworzenie własnej gałęzi
![Przejście na odpowiednią gałąź](image-12.png)

---

## 5. Rozpoczęcie pracy na nowej gałęzi

### Stworzenie katalogu na nowym branchu
![Stworzenie katalogu na branchu](image-13.png)

### Historia poleceń
![Historia poleceń](image-14.png)

### Stworzenie Git Hooka
Plik `commit-msg`:
```sh
#!/bin/sh
FILE=$1
MSG=$(cat "$FILE")

if [[ ! $MSG =~ ^MS417562 ]]; then
    echo "ERROR: Invalid commit message. It has to begin with 'MS417562'."
    exit 1
fi
```
![Git hook](image-15.png)

### Ustawienie dostępu
![Dostęp i położenie git hooka](image-16.png)

### Historia poleceń
![Historia poleceń](image-17.png)

### Dodanie sprawozdania do katalogu
![Sprawozdanie w katalogu](image-18.png)


