# Sprawozdanie 1

## 002-Class
1. Instalacja Dockera na Fedorze
<img src="/home/jakub/MDO2025_INO/ITE/GCL07/JS415003/Sprawozdanie1/lab2 docker/1.png" title="Docker installation" /> 

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
