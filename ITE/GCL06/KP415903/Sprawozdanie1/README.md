# Sprawozdanie: Wprowadzenie, Git, Gałęzie, SSH

### 1. Instalacja klienta Git i obsługi kluczy SSH

W pierwszym kroku zainstalowano klienta Git oraz narzędzia do obsługi kluczy SSH, aby umożliwić bezpieczne połączenia z repozytorium.

`dnf install git openssh`

![Instalacja git i openssh](ss/1-install-git-openssh.png)

### 2. Sklonowanie repozytorium przedmiotowego

Repozytorium przedmiotowe zostało początkowo sklonowane przy użyciu protokołu HTTPS.

`git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO`

![Sklonowanie repozytorium](ss/2-clone-repo.png)

### 3. Stworzenie kluczy SSH i zmiana połączenia na SSH

Wygenerowano dwa klucze SSH, przy czym przynajmniej jeden z nich zabezpieczono hasłem.

`ssh-keygen -t ed25519 -C "adres_email"`

![Wygenerowanie pierwszego klucza SSH typu ed25519](ss/3-gen-ssh-1.png)
![Wygenerowanie pierwszego klucza SSH typu ecdsa](ss/3-gen-ssh-2.png)

Dodawanie kluczy SSH do agenta SSH, który zarządza połączeniami SSH i przechowuje klucze w pamięci, aby nie trzeba było podawać hasła za każdym razem.

`ssh-add ~/.ssh/id_github_ed25519`

![Dodanie 1. klucza do agenta SSH](ss/3-ssh-add-1.png)
![Dodanie 2. klucza do agenta SSH](ss/3-ssh-add-2.png)

Zmiana połączenia z repozytorium na SSH.

`git remote set-url origin git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git`

![Zmiana połączenia z repozytorium](ss/3-ssh-change.png)

Klucz o nazwie *id_github_ed25519* został skonfigurowany jako metoda dostępu do GitHuba.

![Poprawne dodanie klucza SSH dla dostępu GitHuba](ss/3-ssh-key-github.png)

### 4. Zmiana gałęzi

Po poprawnym skonfigurowaniu połączenia SSH, nastąpiło przełączenie na gałęzie main oraz gałęź dedykowaną dla grupy.

`git checkout main`

`git checkout <nazwa-gałęzi-grupy>`

![Zmiana gałęzi](ss/4-branch-change.png)

### 5. Stworzenie nowej gałęzi

Utworzono nową gałęź o nazwie KP415903, odgałęziając się od gałęzi grupowej.

`git checkout -b KP415903`

![Stworzenie nowej gałęzi](ss/5-new-branch.png)

### 6. Rozpoczęcie pracy na nowej gałęzi

W katalogu dedykowanym dla grupy utworzono nowy folder o nazwie ***KP415903***.

`mkdir KP415903`

![Stworzenie nowego folderu](ss/6-new-folder.png)

W celu zapewnienia spójności i poprawności commitów, stworzono hooka pre-commit, który weryfikuje, czy każda wiadomość commit zaczyna się od KP415903. Skrypt ten został umieszczony we właściwym katalogu, aby był automatycznie wywoływany przy każdej próbie wywołania commita.

Treść Git hooka:
```
#!/bin/bash
EXPECTED_PREFIX="KP415903"
COMMIT_MSG=$(cat "$1")

if [[ "$COMMIT_MSG" != $EXPECTED_PREFIX* ]]; then
  echo "Error: Początek wiadomości musi zaczynać się od '$EXPECTED_PREFIX'."
  exit 1
fi
```