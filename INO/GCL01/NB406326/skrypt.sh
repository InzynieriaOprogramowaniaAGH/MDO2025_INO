#!/bin/bash

regex="^NB406326.*"

commit_msg=$(cat "$1")

if [[ ! $commit_msg =~ $regex ]]; then
    echo "Błąd: Commit message nie zaczyna się od NB406326!"
    exit 1
fi