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

4. Utworzony klucz SSH konfigurejemy jako metodę dostępu do GitHub
```
cat .ssh/id_ed25519.pub
```
![obraz](KM/lab1/zajecia/konfiguracja.png)
![obraz](KM/lab1/zajecia/konfiguracja1.png)

5. Za pomocą SSH sklonowano repozytorium przedmiotowego
```
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
![obraz](KM/lab1/zajecia/klonowanie_ssh.png)

6. Skonfigurowano również na GitHubie uwierzytelnianie dwuskładnikowe 2FA
![obraz](KM/lab1/zajecia/2fa.png)

7. W sklonowanym repozytorium przełączono się do gałęzi *main*, a potem na gałąź mojej grupy (5) gdzie został utworzony nowy branch - ```KM417392```
```
cd MDO2025_INO
git checout main
git checkout GCL05
git checkout -b KM417392
```
![obraz](KM/lab1/zajecia/galaz-main.png)
![obraz](KM/lab1/zajecia/galaz%20GCL05.png)

8. Utworzono również nowy folder "KM417392"
```
cd ITE/GCL05/
mkdir KM417392
```
![obraz](KM/lab1/zajecia/folder.png)

9. Następnie w folderze: ```.git/hooks``` napisano nowy skrypt weryfikujący  (każdy "commit message" zaczyna się od "KM417392").
W nowo utworzonym pliku "commit-msg" napisano skrypt oraz przyznano uprawnienia do wykonywania.
Plik został również skopiowany do osobistego folderu.
```
cd ~/MDO2025_INO/.git/hooks/
nano commit-msg
chmod +x commit-msg
```
![obraz](KM/lab1/zajecia/uprawnienia-hook.png)
```
#!/bin/sh

pattern="^KM417392"

if ! grep -qE "$pattern" "$1"; then
    echo "Commit message must start with 'KM417392'" >&2
    exit 1
fi
```
![obraz](KM/lab1/zajecia/git_hook.png)

10. W katalogu ```KM417392``` utworzono folder "Sprawozdanie1" oraz w nim umieszczono ważne pliki (Readme.md oraz zrzuty ekranu - folder "KM")
```
mkdir Sprawozdanie1
cd Sprawozdanie1
touch Readme.md
```
11. Gotowe pliki 





