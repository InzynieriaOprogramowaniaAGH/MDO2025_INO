#!/usr/bin/sh

EXPECTED_PREFIX="KM415081"

# Odczytanie treści commit message
COMMIT_MSG=$(cat "$1")

# Sprawdzenie, czy commit message zaczyna się od oczekiwanego prefiksu
if [[ "$COMMIT_MSG" != $EXPECTED_PREFIX* ]]; then
    echo "Błąd: Commit message musi zaczynać się od \"$EXPECTED_PREFIX\"!"
    exit 1
fi

exit 0
