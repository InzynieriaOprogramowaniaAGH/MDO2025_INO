# Lab 1
## Git hook commit-msg:
Treść:
```
#!/bin/bash

PREFIX="SK417309"

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(head -n 1 "COMMIT_MSG_FILE")

if [[ ! "$COMMIT_MSG" =~ ^$PREFIX ]];
  echo "ERROR: commit message musi zaczac sie od inicjalow i numeru indeksu"
  exit 1
fi

exit 0
```
Sprawdzenie działania:
![Screen z ekranu - hook DZIALA es](test-commita.png)

# Lab 2
## Kontener z obrazu busybox'a

Efekt uruchomienia:
![Screen z ekranu - busybox uruchomiony](efekt-uruchomienia-busyboxa.png)

Numer wersji busyboxa:
![Screen po sprawdzeniu wersji busyboxa](numer-wersji-busyboxa.png)


