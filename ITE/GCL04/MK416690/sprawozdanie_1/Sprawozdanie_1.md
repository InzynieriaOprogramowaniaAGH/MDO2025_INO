# Sprawozdanie 1

## Lab 1

![Instalacja Gita](lab1_screenshots/1.jpg)
Instalacja Gita

![Sklonowanie repozytorium przez HTTPS](lab1_screenshots/2.jpg)
Sklonowanie repozytorium przez HTTPS

![Wygenerowanie klucza SSH](lab1_screenshots/3.jpg)
Wygenerowanie klucza SSH

![Sklonowanie repozytorium przez SSH](lab1_screenshots/4.jpg)
Sklonowanie repozytorium przez SSH

![Utworzenie katalogu w odpowiednim branchu](lab1_screenshots/5.jpg)
Utworzenie katalogu w odpowiednim branchu

![Dodanie skryptu walidującego poprawność nazw commitów do odpowiedniego katalogu z hookami](lab1_screenshots/6.jpg)
Dodanie skryptu walidującego poprawność nazw commitów do odpowiedniego katalogu z hookami

![Jak widać, skrypt działa. Niepoprawna nazwa commita nie jest akceptowana](lab1_screenshots/7.jpg)
Jak widać, skrypt działa. Niepoprawna nazwa commita nie jest akceptowana

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
