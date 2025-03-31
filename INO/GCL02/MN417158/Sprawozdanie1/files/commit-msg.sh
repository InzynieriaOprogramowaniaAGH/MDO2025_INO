#!/bin/bash

EXPECTED_PREFIX="MN417158" 
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! $COMMIT_MSG =~ ^"$EXPECTED_PREFIX" ]]; then
    echo "Błąd: Commit message musi zaczynać się od \"$EXPECTED_PREFIX\""
    exit 1
fi

