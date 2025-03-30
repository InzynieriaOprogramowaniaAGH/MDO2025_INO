# Sprawozdanie nr 1

## Zadanie 1:

1. Po zainstalowaniu i skonfigurowaniu systemu Fedora Server na maszynie wirtualnej połączyłem się z nim przez wiersz poleceń w systemie Windows za pomocą polecenia:
```sh
ssh root@192.168.100.38
```
 
**Interfejs systemu Fedora oraz ip z którym się połączyłem:**

![Zrzut1][screenshots/Zrzut1.png]

Kolejnym krokiem jest instalacja klienta Git poprzez polecenie
```sh
sudo dnf install git
```
2. Następnie sklonowałem repozytorium przez HTTPS i Personal Access Token:
```sh
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
3. Utworzyłem dwa klucze SSH w tym jeden zabezpieczony hasłem używając komendy:
```sh
ssh-keygen -t ed25519 -C "milosznowak25@gmail.com"
```
Dodałem utworzony klucz do SSH agent:
```sh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```
**Utworzone klucze na Github:**

![Zrzut2](screenshots/Zrzut2.png)

Upewniłem się że mam dostęp do repozytorium:

**Komenda ssh -T git@github.com:**

![Zrzut3](screenshots/Zrzut3.png)

Następnie sklonowałem repozytorium za pomocą SSH:
```sh
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

**Repozytorium widoczne w systemie Fedora po sklonowaniu:**

![Zrzut4](screenshots/Zrzut4.png)

4. Kolejnym krokiem było przełączenie się na gałąź "main", a następnie na gałąź swojej grupy. Zrobiłem to kolejno poleceniami:
```sh
git checkout main
git checkout GCL02
```
Następnie utworzyłem własną gałąź:
```sh
git checkout -b MN417158
```
I upewniłem się że znajduję się na nowo utworzonej gałęzi:
```sh
git branch
```

**Aktualna gałąź:**

![Zrzut5](screenshots/Zrzut5.png)

5. Pracę na nowej gałęzi rozpocząłem od utworzenia nowego katalogu o takiej samej nazwie jak moja gałąź ```sh mkdir MN417158```

6. W nim utworzyłem skrypt git hook, którego zadaniem jest sprawdzanie czy każdy mój commit zaczyna się od moich inicjałów i numeru grupy ```sh nano commit-msg.sh```

**Treść skryptu git hook:**

![Zrzut6](screenshots/Zrzut8.png)

Utworzony skrypt przekopiowałem do odpowiedniego pliku z innymi skryptami .git/hook aby działał poprawnie, a następnie nadałem mu odpowiednie uprawnienia za pomocą ```sh chmod +x .git/hooks/commit-msg```

**Sprawdzenie poprawnego kopiowania i nadania skryptowi uprawnień:**

![Zrzut7](screenshots/Zrzut6.png)

**Działanie skryptu w przypadku błędnej treści commitu:**

![Zrzut8](screenshots/Zrzut7.png)

