Sprawozdanie

Tresc hooka:
#!/bin/bash
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat $COMMIT_MSG_FILE)
PREFIX="MK414948"

if [[ ! $COMMIT_MSG =~ ^$PREFIX ]]; then
    echo "❌ ERROR: Commit message must start with '$PREFIX'"
    echo "✅ Przykład poprawnego commit message: '$PREFIX: Dodano nowy plik'"
    exit 1
fi

