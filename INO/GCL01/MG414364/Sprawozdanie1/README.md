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
- Dodałem commit
![commit](image-3.png)
*(błąd naprawiłem instrukcją `chmod +x commit-msg`)*
- Wypchnąłem zmiany na mój branch
![fancy git push](image-2.png)
- Zaktualizowałem zmiany w sprawozdaniu
- Wciągnąłem swoją gałąź do gałęzi grupowej
![merge](image-4.png)

## Lab 02
1. Zainstalowałem docker: `dnf install docker`
2. Konto na Docker miałem już stworzone po zajęciach z BazDanych rok temu.
3. Poprałem wszystkie wymagane obrazy (jeden przykład)
![docker pull](image-5.png)
4. Uruchomiłem `BusyBox` i pobrałem wersję
![BusyBox](image-6.png)
5. Uruchomiłem Ubutnu w Docker
![Ubuntu Docker](image-7.png)
- PID1 w kontenerze
![PID1 Docker](image-8.png)
- PID1 na hoście
![PID1 Host](image-9.png)
- Zaktualizowałem pakiety
![apt update](image-10.png)
![aut upgrade](image-11.png)
- Wyszedłem
![exit](image-12.png)
6. Stworzyłem plik Dockerfile i uzupełniłem go:
```Docker
# syntax=docker/dockerfile:1
FROM ubuntu:24.04
RUN apt update -y && apt upgrade -y
RUN apt install git -y
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
- Uruchomiłem nowy docker Ubuntu i zweryfikowałem poprawność działania
![docker build, docker run](image-13.png)
7. Uruchomione kontenery
![docker ps](image-14.png)
8-9. Wylistowałem i wyczyściłem uruchomione wcześniej obrazy
![docker ps, docker rm](image-15.png)
