# Sprawozdanie nr 1

## Zadanie 1:

### 1. Po zainstalowaniu i skonfigurowaniu systemu Fedora Server na maszynie wirtualnej połączyłem się z nim przez wiersz poleceń w systemie Windows za pomocą polecenia:
```sh
ssh root@192.168.100.38
``` 

![Interfejs systemu Fedora oraz ip z którym się łączymy][screenshots/zrzut1.png]

Kolejnym krokiem jest instalacja klienta Git poprzez polecenie
```sh
sudo dnf install git
```
### 2. Następnie sklonowałem repozytorium przez HTTPS i Personal Access Token:
```sh
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
### 3. Utworzyłem dwa klucze SSH w tym jeden zabezpieczony hasłem używając komendy:
```sh
ssh-keygen -t ed25519 -C "milosznowak25@gmail.com"
```
Dodałem utworzony klucz do SSH agent:
```sh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```
**Zrzut ekranu:**

![Utworzone klucze na Github](screenshots/zrzut2.png)

Upewniłem się że mam dostęp do repozytorium:

**Zrzut ekranu:**

![Komenda ssh -T git@github.com](screenshots/zrzut3.png)
Następnie sklonowałem repozytorium za pomocą SSH:
```sh
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

**Zrzut ekranu:**

![Sklonowane repozytorium widoczne w systemie Fedora](screenshots/zrzut4.png)
