Treść githooka, który odpowiada za poprawny początek każdego commita (ma się on zaczynać od inicjałów i numer indeksu, w moim przypadku FN414313)

## Skrypt

```bash
#!/bin/bash

PREFIX="FN414313"

COMMIT_MSG_FILE="$1"

FIRST_LINE=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! "$FIRST_LINE" =~ ^"$PREFIX" ]]; then
    echo  "Błąd: Commit message musi zaczynać się od: '$PREFIX'"
    exit 1
fi

exit 0
```

Instalcja ssh i gita

![ss1](screeny/Screenshot_1.png)
![ss2](screeny/Screenshot_2.png)

Stworzenie tokenu

![ss3](screeny/Screenshot_3.png)

Próba klonowania repozytorium użytkownika (wymagane poświadczenie tokenem)

![ss4](screeny/Screenshot_4.png)

Sklonowanie repozytorium przy użyciu tokenu

![ss5](screeny/Screenshot_5.png)

Tworzenie kluczy SSH (gdzie klucz ed25519 posiada passphrase)

![ss6](screeny/Screenshot_6.png)
![ss7](screeny/Screenshot_7.png)

Nieudane klonowanie (nie dodano klucza do Githuba)

![ss8](screeny/Screenshot_8.png)

Dodanie klucza do githuba

![ss9](screeny/Screenshot_9.png)

Udane klonowanie

![ss10](screeny/Screenshot_10.png)

Skonfigurowanie 2fa

![ss34](screeny/Screenshot_34.png)

Gałęź main

![ss11](screeny/Screenshot_11.png)

Przełączono na gałęź swojej grupy

![ss12](screeny/Screenshot_12.png)

Utworzenie i przełączenie na gałęź FN414313

![ss13](screeny/Screenshot_13.png)

Utworzenie git hooka

![ss14](screeny/Screenshot_15.png)

Prezentacja działania git hooka

![ss16](screeny/Screenshot_16.png)

Utworzenie sprawozdania

![ss17](screeny/Screenshot_17.png)

Commit z dotychczasowymi zmianami

![ss18](screeny/Screenshot_18.png)

Przejście na gałęź GCL05

![ss19](screeny/Screenshot_19.png)

Wciągnięcie gałęzi FN414313 do GCL05

![ss20](screeny/Screenshot_20.png)

Pobieranie i uruchamianie dockera

![ss21](screeny/Screenshot_21.png)
![ss22](screeny/Screenshot_22.png)

Pobieranie obrazów i wyświetlanie wszystkich obrazów

![ss23](screeny/Screenshot_23.png)
![ss24](screeny/Screenshot_24.png)

Uruchomienie kontenera busybox i wyświetlenie wersji

![ss25](screeny/Screenshot_25.png)

Uruchomienie konteneru na postawie obrazu fedora

![ss26](screeny/Screenshot_26.png)

Wyświetlenie pierwszego procesu (jest to proces bash)

![ss27](screeny/Screenshot_27.png)

Aktualizacja pakietów

![ss28](screeny/Screenshot_28.png)

Wyjście z kontenera

![ss29](screeny/Screenshot_29.png)

Treść dockerfile na podstawie lekkiego obrazu fedora, na którym instalowane są aktualizację, git oraz kolonowane jest repozytorium

## Skrypt

```bash
FROM fedora:latest

LABEL maintainer="Filnaw <filipnaw@student.agh.edu.pl>"

ENV DEBIAN_FRONTEND=noninteractive

RUN dnf update && dnf install git && dnf clean all

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /app

CMD ["/bin/bash"]
```

Zbudowanie prostego obrazu na podstawie pliku Dockerfile

![ss30](screeny/Screenshot_30.png)

Stworzenie i uruchomienie kontenera, wyświetlenie sklonowanego repozytorium

![ss31](screeny/Screenshot_31.png)

Wyświetlenie i wyczyszczenie kontenerów

![ss32](screeny/Screenshot_32.png)

Wyczyszczenie obrazów
 
![ss33](screeny/Screenshot_33.png)
