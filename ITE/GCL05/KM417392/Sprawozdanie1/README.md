# Sprawozdanie 1 
## Zajęcia 01: Wprowadzenie, Git, Gałęzie, SSH

1. Zainstalowano klienta Git oraz obsługę kluczy SSH dla systemu Ubuntu Server 
```
sudo apt update
sudo apt install git openssh-client -y
```
![obraz](KM/lab1/zajecia/1.png)

2. Następnie za pomocą HTTPS oraz personal access token zostało sklonowane repozytorium przedmiotowe
```
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
![obraz](KM/lab1/zajecia/klonowanie_https.png)

3. Utworzono dwa klucze SSH, zabezpieczone hasłem
```
ssh-keygen -t ed25519 -C "katarzynamad@student.agh.edu.pl"
ssh-keygen -t ecdsa -b 521 -C "katarzynamad@student.agh.edu.pl"
```
![obraz](KM/lab1/zajecia/klucz_gen1.png)
![obraz](KM/lab1/zajecia/klucz_ecdsa.png)

4. 

