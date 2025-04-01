# Sprawozdanie 1

## Instalacja klienta Git i SSH
Po instalacji systemu operacyjnego Fedora Linux 41 (Server Edition) doinstalowujemy paczki z których będziemy korzystać.

Instalacja Git: 
``` sudo dnf install git ```

Instalacja SSH-Server
``` sudo dnf install openssh-server```

Sprawdzamy czy ssh działa poprawanie poprzez sprawdzenie statusu:
```sudo systemctl status sshd```

Jeśli status to active (running) oznacza to że wszystko działa poprawnie. 
![alt text](screeny/sshd_status.png)

Następnie łączymy się zdalnie z klienta do serwera, poprzez komendę:
```ssh USER_NAME@REMOTE_SERVER_ADDRESS```

## Klonowanie repozytorium z github
Następny wykonany krok to pobranie przedmiotowego repozytorium. Możemy to zrobić przy użyciu komendy:
```git clone https://PAT@github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git```

Możemy sprawdzić w jaki sposób jesteśmy połączeni do repozytorium za pomocą polecenia:
```git remote -v ```

## Tworzenie kluczy SSH i dodawanie do konta GitHub
Aby utworzyć klucze bezpiecznego połączenia używamy komendy: 
```ssh-keygen -t ed25519 -C "your_github_email@example_domain.com"```

Korzystamy z szyfrowania ed25519. Domyślnie klucze zapisywane są w folderze ~/.ssh, ale program pozwala na zmianę ich miejsca. Należy przy tym pamiętać że musimy je później dodać do ssh-agent. Możemy również dodać passphrase co jest zalecane. Kopiujemy całą treść klucza publicznego.

Logujemy się do serwisu GitHub i przechodzimy do ustawień. W zakładce SSH and GPG keys klikamy przycisk New SSH key i wklejamy zawartość wcześniej skopiowanego klucza publicznego.

Prawidłowo dodany klucz powinien wyglądać tak:
![alt text](screeny/ssh_key.png)

## Klonowanie repozytorium za pomocą SSH

Aby sklonować repo za pomocą SSH używamy:
```git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git```

Żeby zweryfikować czy jesteśmy połączeni z repozytorium za pomocą SSH, możemy wpisać:
```git remote -v```

![alt text](screeny/git_remote.png)

## Gałęzie w Git

Praca na osobnych gałęziach jest jedną z podstaw pracowania w środowisku git. Umożliwia to pracowanie nad konkretnym zadaniem, bez przeszkadzania innym developerom, piszących swoje części kodu.

Domyślną gałęzią w git jest main  jednak gdy tak nie jest, możemy się na nią przełączyć korzystając z komendy:
```git checkout main```

Aby sprawdzić na jakiej gałęzi obecnie się znajdujemy wpisujemy : 
```git branch```
Podświetlona na zielono gałąź to ta na której sie znajdujemy.
![alt text](screeny/git_branch.png)

Aby otworzyć nową gałąź korzystamy z komendy git checkout z parametrem -b:
```git checkout -b MP416070```

## Utworzenie Git Hooka

Kolejny krok to utworzenie Git Hooka sprawdzającego czy każdym z naszych commit message, zaczyna się od odpowiednich inicjałów. Aby to zrobić należy wybrać plik o odpowiedniej nazwie, aby skrypt wykonał się po odpowiedniej komendzie. W tym przypadku to commit-msg.sample. Teraz trzeba napisać odpowiedni skrypt i zmienić nazwę na commit-msg, pamiętając że plik ma znajdować się w katalogu .git/hooks.

#!/bin/bash

commit_msg_file=$1
prefix="MP416070"

if ! grep -q "^$prefix" "$commit_msg_file"; then
    echo "Błąd: Commit message musi zaczynać się od: $prefix"
    exit 1
fi

## Tworzenie commit'a i wysyłanie na GitHub

Aby stworzyć commita możemy zrobić to w następujący sposób.

Sprawdzamy który pliki zostały zmienione i/lub dodane za pomocą:
``` git status ```

Jeśli zobaczymy pliki o czerwonym kolorze tekstu, oznacza to że te zmiany nie są dodane tzn. nie zostaną uwzględnione gdy będziemy tworzyć commit. Aby je dodać korzystamy z komendy:

```git add .```

Tutaj . oznacza że dodajemy wszystkie zmienione pliki, aby dodać konkretny plik zamiast wszystkich zmieionych, zmieniamy . na nazwe pliku. 

Następnie tworzymy commit zawierający dodane zmiany : 
```git commit -m "MP416070 :  message"``

To polecenie tworzy commit ale póki co jest on tylko lokalnie na naszej maszynie. Aby wysłać go na github należy 'wypchnąć' zmiany za pomocą komendy : 
``` git push ```
![alt text](screeny/sshd_status.png)
