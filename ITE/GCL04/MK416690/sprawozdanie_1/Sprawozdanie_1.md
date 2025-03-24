# Sprawozdanie 1

## Lab 1

Instalacja Gita

![Instalacja Gita](lab1/1.jpg)

Sklonowanie repozytorium przez HTTPS

![Sklonowanie repozytorium przez HTTPS](lab1/2.jpg)

Wygenerowanie klucza SSH

![Wygenerowanie klucza SSH](lab1/3.jpg)

Sklonowanie repozytorium przez SSH

![Sklonowanie repozytorium przez SSH](lab1/4.jpg)

Utworzenie katalogu w odpowiednim branchu

![Utworzenie katalogu w odpowiednim branchu](lab1/5.jpg)

Dodanie skryptu walidującego poprawność nazw commitów do odpowiedniego katalogu z hookami

![Dodanie skryptu walidującego poprawność nazw commitów do odpowiedniego katalogu z hookami](lab1/6.jpg)

Jak widać, skrypt działa. Niepoprawna nazwa commita nie jest akceptowana

![Jak widać, skrypt działa. Niepoprawna nazwa commita nie jest akceptowana](lab1/7.jpg)

Poprawny commit

![Poprawny commit](lab1/8.jpg)

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

![Poprawnie zainstalowany Docker](lab2/2.jpg)

Pobrane obrazy z Docker Hub

![Pobrane obrazy z Docker Hub](lab2/3.jpg)

Uruchomienie kontenera z obrazu busyboxa

![Uruchomienie kontenera z obrazu busyboxa](lab2/4.jpg)

Podłączenie się do kontenera i wyświetlenie wersji

![Podłączenie się do kontenera i wyświetlenie wersji](lab2/5.jpg)

Uruchomienie Fedory w kontenerze i pokazanie PID1

![Uruchomienie Fedory w kontenerze i pokazanie PID1](lab2/6.jpg)

Aktualizacja pakietów

![Aktualizacja pakietów](lab2/7.jpg)

Procesy Dockera

![Procesy Dockera](lab2/8.jpg)

Przygotowanie Dockerfile, który będzie tworzył nam kontener z Fedorą, instalował Gita i klonował nasze repozytorium

![Przygotowanie Dockerfile, który będzie tworzył nam kontener z Fedorą, instalował Gita i klonował nasze repozytorium](lab2/9.jpg)

Zbudowanie obrazu na podstawie Dockerfile

![Zbudowanie obrazu na podstawie Dockerfile](lab2/10.jpg)

Uruchomienie kontenera z naszego obrazu, jak widać wszystko działa elegancko

![Uruchomienie kontenera z naszego obrazu, jak widać wszystko działa elegancko](lab2/11.jpg)

Wszystkie kontenery, jak widać uruchomiony i działający jest tylko jeden

![Wszystkie kontenery, jak widać uruchomiony i działający jest tylko jeden](lab2/12.jpg)

Usuwanie wszystkich kontenerów oraz obrazów

![Usuwanie wszystkich kontenerów oraz obrazów](lab2/13.jpg)
