#!/bin/bash

# Pobierz treść wiadomości commita
commit_msg=$(cat "$1")

# Sprawdź, czy wiadomość zaczyna się od "JS415003"
if ! [[ "$commit_msg" =~ ^JS415003.* ]]; then
    echo "ERROR: Commit message musi zaczynać się od 'JS415003'"
    echo "Twoja wiadomość: $commit_msg"
    exit 1
fi

# Jeśli jesteśmy tutaj, to wszystko jest OK
exit 0
