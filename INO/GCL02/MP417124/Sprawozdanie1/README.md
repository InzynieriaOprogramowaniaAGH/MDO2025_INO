# Sprawozdanie (Zadania 1-4)

## Wprowadzenie

Celem zadania było zapoznanie się z podstawami systemu kontroli wersji Git oraz obsługą kluczy SSH w celu wygodnego zarządzania repozytoriami na GitHubie. Zadania obejmowały konfigurację Git, kluczy SSH, stworzenie gałęzi, dodanie Git hooka do walidacji commitów oraz wykonanie kilku operacji na repozytorium. Dokumentacja zawiera pełny opis wykonanych kroków, poleceń oraz zrzutów ekranu. Celem zadania było zapoznanie się z Dockerem, instalacją, pobieraniem i uruchamianiem obrazów kontenerów oraz stworzenie własnego obrazu Docker, który będzie zawierał zainstalowanego Gita oraz nasze repozytorium. Dodatkowo, wykonano czyszczenie nieużywanych kontenerów i obrazów.


## Zadanie 1: Wprowadzenie, Git, Gałęzie, SSH

1. **Konfiguracja kluczy SSH:**

   W pierwszym kroku skonfigurowałam klucze SSH, aby umożliwić bezpieczne połączenie z GitHubem. Użyłam klucza typu `ed25519`, który jest bardziej nowoczesny niż RSA.


   - Polecenia:
     ![Generowanie kluczy](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%204.19.21%E2%80%AFPM.png)
   
     ```bash
     ssh-keygen -t ed25519 -C "nazwa"
     ```
     Po utworzeniu klucza SSH skopiowałam go i dodałam do swojego konta GitHub, postępując zgodnie z dokumentacją na GitHubie.

   - Zrzut ekranu:
     ![Zrzut ekranu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%204.27.12%E2%80%AFPM.png)

## Zadanie 2: Klonowanie repozytorium

2. **Dodanie klucza:**

   Następnie skopiowałam repozytorium poporzez usługę SSH, korzystając z odpowiedniego polecenia. 
   - Polecenia:
     ```bash
     git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
     ```
   I zgodnie z poleceniem włączyłam 2FA na GitHub, aby zwiększyć bezpieczeństwo konta.
   
## Zadanie 3: Tworzenie i przełączanie się na gałąź

3. **Przełączenie się na odpowiednią gałąź i utworzenie własnej gałęzi:**

   Po sklonowaniu repozytorium przełączyłam się na gałąź główną (main), a następnie na gałąź swojej grupy (GCL02). Utworzyłam nową gałąź o nazwie `MP417124` (moja inicjały i nr indeksu).

   - Polecenia:
     ```bash
     git checkout -b MP417124
     ```

## Zadanie 4: Tworzenie Git Hooka oraz walidacja commitów

4. **Utworzenie Git Hooka do weryfikacji commit message:**

   We właściwym katalogu stworzyłam Git hooka, który weryfikuje, czy commit message zaczyna się od moich inicjałów oraz nr indeksu. W tym celu utworzyłam skrypt w folderze `.git/hooks`.

   - Skrypt Git Hook:
   
     ![Skrypt Git Hook](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%204.31.45%E2%80%AFPM.png)
     

   - Umieszczenie Git Hooka:
     Skrypt został umieszczony w odpowiednim katalogu `.git/hooks/` w folderze repozytorium, aby działał za każdym razem, gdy wykonuję commit.

6. **Dodanie pliku do repozytorium:**

   Po utworzeniu folderu i dodaniu hooka, dodałam wszystkie zmiany do repozytorium oraz wykonałam commit.

   - Polecenia:
     ```bash
     git add .
     git commit -m "message"
     git push origin MP417124
     ```

   - Zrzut ekranu:
     ![Wysłanie zmian na GitHuba](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%205.03.45%E2%80%AFPM.png)


## Historia poleceń

```bash
sudo apt update
sudo apt install git
ssh-keygen -t ed25519 -C "twój_email@domena.com"
git clone https://github.com/user/repository.git
git clone git@github.com:user/repository.git
git checkout main
git pull origin main
git checkout -b MP417124
git add .
git commit -m "MP417124: Created hook to validate commit message"
git push origin MP417124
```


## Zadanie 2: Git, Docker

1. **Instalacja Dockera na systemie Linux**

   Najpierw zaczełam od zaaktualizwoania systemu oraz zainstalowania Dockera poprzez odpowiednie polecenie: `sudo dnf install -y docker` i następnie uruchomiłam go. W kolejnym kroku pobrałam obrazy: `hello-world`, `busybox`, `ubuntu`, `fedora`, `mysql`. W tym celu wykorzystałam polecenie:

```bash
docker pull [obraz]
```
Uruchomiłam kontener z obrazu busybox i podłaczyłam się do niego interaktywnie, następnie wywołując numer wersji systemu.

![Zrzut ekranu busybox](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MP417124/INO/GCL02/MP417124/Sprawozdanie1/Screenshots/Screenshot%202025-03-15%20at%207.21.19%E2%80%AFPM.png)

Kolejno uruchomiłam kontener z obrazu systemu Ubuntu. Wyświetlono procesy w kontenerze w tym PID1: bash. Wyświetlono procesy dockera na hoście. [Zrzut ekranu pracy z obrazem ubutnu](media/m13_ubuntu.png)
- Ponownie uruchomiono kontener z obrazu ubuntu i wywołano aktualizacje pakietów poleceniami `apt update && apt upgrade -y` . ![Zrzut ekranu, update ubtuntu](media/m14_update.png)
- Utworzono własny plik Dockerfile bazujący na systemie fedora. Na tym obrazie zainstalowany zostaje git oraz skopiowane repozytorium przedmiotu. Poniżej znajduje się zawartość pliku Dockerfile
```

 

