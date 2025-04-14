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
    ![Git branch](Lab1/git_branch.png)

3. **Tworzenie katalogu i githooka**

    Utworzono katalog w /ITE/GCL07
    ```bash
    mkdir TS416767
    ```

    ![Katalog roboczy](Lab1/katalog.png)

    Napisano hooka commit-msg do walidacji prefiksu w commitach
    ```bash
    #!/bin/bash
    COMMIT_MSG_FILE=$1
    COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

    if [[ ! "$COMMIT_MSG" =~ ^TS416767 ]]; then
        echo "ERROR: Każdy commit MUSI zaczynać się od 'TS416767'!!!"
        exit 1
    fi
    exit 0		
    ```

    Umieszczono go w odpowiednim katalogu

    ![Hook w folderze](Lab1/hook.png)

    Dodano odpowiednie uprawnienia
    ```bash
    chmod +x .git/hooks/commit-msg
    ```

    Przetestowano czy hook działa

    ![Hook test](Lab1/hook_test.png)

4. **Dodanie zrzutów ekranu i utworzenie sprawozdania**

    Dodano zrzuty ekranu do katalogu 'Lab1'

    Stworzono sprawozdanie i przesłano je do repozytorium zdalnego

    ![Sprawozdanie](Lab1/sprawozdanie.png)

## Lab 2

1. **Instalacja Dockera**
    ```bash
    sudo dnf install -y dnf-plugins-core
    sudo dnf install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
    ```

    Sprawdzenie wersji Dockera
    ![Docker version](Lab2/docker_version.png)

2. **Rejestracja w DockerHub**

    Zarejestrowano się w DockerHub

    ![Konto DockerHub](Lab2/docker_hub.png)

    Zalogowano się na utworzone konto w Fedorze

    ![Logowanie do Dockera](Lab2/docker_lohin.png)

3. **Pobieranie obrazów Dockera**

    Pobrano wybrane obrazy przy pomocy komend:

    ```bash
    docker pull hello-world
    docker pull busybox
    docker pull ubuntu
    docker pull fedora
    docker pull mysql
    ```

    Pobrane obrazy

    ![Pobrane obrazy](Lab2/doker_images.png)

4. **Uruchomienie kontenera BusyBox**

    Uruchomienie proste:
    ![BusyBox](Lab2/bb_działa.png)

    Uruchomienie w trybie interaktywnym:
    ![BusyBox inter](Lab2/bb_inter.png)


5. **Uruchomienie Ubuntu w kontenerze**

    Sprawdzenie procesu PID 1 w kontenerze:  

    ![Ubuntu PID](Lab2/ubuntu_pid.png)

    Aktualizacja pakietów w kontenerze:
    ```bash 
    apt update && apt upgrade -y
    ```

    Wyjście z kontenera
    ```bash 
    exit
    ```
6. **Tworzenie Dockerfile**

    Utworzono plik Dockerfile  

    ```bash 
    FROM ubuntu:latest

    RUN apt update && apt install -y git

    WORKDIR /repo
    RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

    CMD ["bash"]                        
    ```

    Zbudowano obraz
    ![Ubuntu z Dockerfile](Lab2/repo_ubuntu.png)

    Uruchomiono kontener i sprawdzono repozytorium
    ![Ubuntu z repo](Lab2/repo.png)

7. **Usuwanie kontenerów i obrazów**

    Sprawdzono listy wszystkich kontenerów, a następnie zatrzymano i usunięto:

    ![Usuwanie](Lab2/usuwanie.png)

## Lab 3
