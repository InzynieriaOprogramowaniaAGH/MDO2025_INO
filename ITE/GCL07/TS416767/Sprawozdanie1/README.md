# Sprawozdanie 1

## Lab 1

1.  **Instalacja Git i konfiguracja SSH**

    Do instalacji Gita użyto polecenia:
    ```bash
    sudo dnf install git
    ```

    Sprawdzenie powodzenia instalacji wykonano za pomocą:
    ```bash
    git --version
    ```
    ![Sprawdzenie wersji Git](Lab1/git_version.png)

    Wygenerowano dwa klucze SSH

    ```bash
    ssh-keygen -t ed25519 -C "tomek.sieminski23@gmail.com"
    ```
    Klucze zostały zapisane na GitHubie

    Po skonfigurowaniu kluczy, repozytorium zostało sklonowane przy użyciu SSH:
    ```bash
    git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
    ```
    ![Pobieranie SSH](Lab1/git_clone_ssh.png)

2. **Konfiguracja gałęzi w Git**

    Przełączono się na gałąź main, a potem na gałąź grupy 7
    Utworzono gałąź o nazwie 'TS416767':
    ```bash
    git checkout -b TS416767
    ```
    [Git branch](Lab1/git_branch.png)
