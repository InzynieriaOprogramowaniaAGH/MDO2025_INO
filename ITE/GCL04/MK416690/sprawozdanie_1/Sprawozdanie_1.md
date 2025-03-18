# Sprawozdanie 1

## Lab 1

Instalacja Gita

![Instalacja Gita](lab1_screenshots/1.jpg)

Sklonowanie repozytorium przez HTTPS

![Sklonowanie repozytorium przez HTTPS](lab1_screenshots/2.jpg)

Wygenerowanie klucza SSH

![Wygenerowanie klucza SSH](lab1_screenshots/3.jpg)

Sklonowanie repozytorium przez SSH

![Sklonowanie repozytorium przez SSH](lab1_screenshots/4.jpg)

Utworzenie katalogu w odpowiednim branchu

![Utworzenie katalogu w odpowiednim branchu](lab1_screenshots/5.jpg)

Dodanie skryptu walidującego poprawność nazw commitów do odpowiedniego katalogu z hookami

![Dodanie skryptu walidującego poprawność nazw commitów do odpowiedniego katalogu z hookami](lab1_screenshots/6.jpg)

Jak widać, skrypt działa. Niepoprawna nazwa commita nie jest akceptowana

![Jak widać, skrypt działa. Niepoprawna nazwa commita nie jest akceptowana](lab1_screenshots/7.jpg)

Poprawny commit

![Poprawny commit](lab1_screenshots/8.jpg)

Treść hooka

```bash
#!/bin/bash

INITIALS="MK"
INDEX="416690"

COMMIT_MSG=$(cat "$1")

if ! echo "$COMMIT_MSG" | grep "^$INITIALS & $INDEX"; then
	echo "Blad: Nazwa commitu musi zaczynac sie od $INITIALS & $INDEX"
	exit 1
fi
```
## Lab 2

Poprawnie zainstalowany Docker

![Poprawnie zainstalowany Docker](lab2_screenshots/2.jpg)

Pobrane obrazy z Docker Hub

![Pobrane obrazy z Docker Hub](lab2_screenshots/3.jpg)

Uruchomienie kontenera z obrazu busyboxa

![Uruchomienie kontenera z obrazu busyboxa](lab2_screenshots/4.jpg)
