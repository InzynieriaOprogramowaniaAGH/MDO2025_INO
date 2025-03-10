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