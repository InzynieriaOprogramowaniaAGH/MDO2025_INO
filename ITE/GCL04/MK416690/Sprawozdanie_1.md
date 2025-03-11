# Sprawozdanie 1

## Treść hooka

```bash
#!/bin/bash

INITIALS="MK"
INDEX="416690"

COMMIT_MSG=$(cat "$1")

if ! echo "$COMMIT_MSG" | grep -q "$INITIAL & $INDEX"; then
	echo "Blad: Nazwa commitu musi zaczynac sie od $INITIALS & $INDEX"
	exit 1
fi
```
