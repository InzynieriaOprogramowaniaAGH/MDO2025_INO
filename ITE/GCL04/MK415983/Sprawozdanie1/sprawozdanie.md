# Zajęcia 1 - Wprowadzenie, Git, Gałęzie, SSH


Na wirtualnej maszynie (VM) obsługującej Fedora 41 Server zainstalowano git oraz obsługę ssh. W tym celu potrzebne są komendy
```sh
sudo dnf install git-all
sudo apt install openssh-server
```
Po wykonaniu komend, można uwierzytelnić, że instalcja zaszła poprawnie, poprzez
```sh
git --version
ssh -V
```
![image](1.PNG)
![image](2.PNG)

Wygenerowano klucze ssh poprzez
```sh
ssh-keygen -t ed25519 -C "kolezynski@student.agh.edu.pl"
```
po czym zapisano klucze w bezpieczne miejsce, przy czym klucz publiczny znajduje się w plikue id_ed25519.pub.

![image](3.PNG) 

Dodano klucz SSH do github.

![image](4.PNG)

Sklonowano repozytorium z wykorzystaniem protokołu ssh poprzez
```sh
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
przy czym uwierzytelniono połączenie ssh poprzez zawartość pliku z publicznym kluczem id_ed25519.pub. Tym sposobem sklonowano repozytorium na VM. Dodatkowo, połączono się przez ssh z VM poprzez Visual Studio Code dla ułatwienia pracy. Z pomocą VSC utworzono poprzez branch oraz katalog o nazwie MK415983 (w którym obecnie znajduje się sprawozdanie).

![image](5.PNG)
![image](6.PNG)

Utworzono git hook [commit-msg](commit-msg), który weryfikuje, że wiadomość commita zaczyna się od MK415983.
```
COMMIT_MSG_FILE=$1
PREFIX="MK415983"

COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

if [[ ! "$COMMIT_MSG" =~ ^$PREFIX ]]; then
    echo "Error: Commit message must start with '$PREFIX'."
    exit 1
fi

exit 0
```
Wykonano commit z poprawną wiadomością a następnie 
```sh
git push
```
![image](7.PNG)
Pull request zostanie wykonany na koniec części drugiej.

# Zajęcia 2 - Git, Docker