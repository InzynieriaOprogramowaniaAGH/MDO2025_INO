# Sprawozdanie 1
## Lab 01

1. Zainstalowałem `git` przy pomocy komendy `dnf install git`
2. Sklonowałem repozytorium poleceniem `git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git`
3. Skonfigurowałem `SSH` z pomocą [poradnika na GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
![ssh KeyGen](sshKeyGen.png)
Oraz dodałem klucz do GitHub'a
![ssh github](Gitssh.png)
Na koniec pobrałem repozytorium jeszcze raz, tym razem przy pomocy ssh:
![ssh clone][GitPullSSH.png]
4. Przełączyłem się na gałąź main i na gałąź grupy
![git checkout](gitcheckout.png)
5. Stworzyłem `branch` o poprawnej nazwie wcześniej, więc jest to
![create branch](gitchechoutb.png)
6. Praca na gałęzi
- utworzyłem katalog
![mkdir...](image.png)
- Napisałem githook'a i wrzuciłem go do odpowiedniego folderu
```bash
#!/bin/bash

if ! grep -q "^MG414364" "$1"; then
	echo "Bad commit!"
	exit 1
fi

exit 0
```
- Dodałem katalog oraz plik ze sprawozdaniem
![mkdir oraz touch!!!!](image-1.png)
- Wypchnąłem zmiany na mój branch
![fancy git push](image-2.png)
- Zaktualizowałem zmiany w sprawozdaniu
![ospdjgoiseghs](image-3.png)