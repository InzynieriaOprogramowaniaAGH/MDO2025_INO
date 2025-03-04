Tutaj jest mój plik commit message
#!usr/bin/sh

EXPECTED_PREFIX="MK416388"

COMMIT_MSG=$(cat "$1")

if [[ "$COMMIT_MSG" != $EXPECTED_PREFIX* ]]; then
    echo "Błąd: Commit message musi zaczynać się od "$EXPECTED_PREFIX"!"
    exit 1
fi

exit 0
