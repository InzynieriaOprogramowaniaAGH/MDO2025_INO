#Sprawozdanie nr 1

Na zainstalowanej maszynie wirtualnej Fedora zainstalowano klienta Git i obsługę kluczy SSH

![Fedora w Virtual Box](L1.JPG)

```bash
sudo dnf install git
```

Sklonowano repozytorium przedmiotowe:

```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

Utworzono dwa klucze SSH przy pomocy komendy:
```bash
ssh-keygen -t ed25519 -C "2013burl01@gmail.com"
```

![Klucze SSH](SSHs.JPG)