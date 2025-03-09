# Sprawozdanie 1
### 1. Instalacja git i konfiguracja kluczy ssh
Zainstalowano git za pomocą polecenia:
```bash
sudo dnf install git
```

Następnie wygenerowano parę kluczy ssh za pomocą polecenia:
```bash
ssh-keygen -t ed25519 -C "kuba.swierczynski4@gmail.com"
```
Oraz dodano klucz publiczny do githuba:

![ssh-key](/ITE/GCL07/JS415943/Sprawozdanie1/ssh-key1.png)

Przy użyciu klucza ssh sklonowano repozytorium przedmiotu:
```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

Po sklonowaniu przełączono się na gałąź grupy 7 a z niej stworzono nową 
```bash
git checkout  GCL07
git checkout -b JS415943
```

Następnie utworzono podfolder z inicjałami, numerem indeksu oraz sprawozdniem:
```bash
mkdir JS415943
cd JS415943
mkdir Sprawozdanie1
cd Sprawozdanie1
touch README.md
touch commit-msg
chmod +x commit-msg
```

Treść skryptu git hooka:
```bash
#!/bin/bash

EXPECTED_PREFIX="JS415943"

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! $COMMIT_MSG =~ ^$EXPECTED_PREFIX ]]; then
    echo "ERROR: Commit message must start with '$EXPECTED_PREFIX'"
    exit 1
fi
```
Skopiowano git hooka do folderu .git/hooks
```bash
cp commit-msg ../../../../.git/hooks/
```

![ssh-key](/ITE/GCL07/JS415943/Sprawozdanie1/git-hook1.png)
