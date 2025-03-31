###SPRAWOZDANIE 1

##Monika Krakowska, Informatyka Techniczna





#Instalacja klienta Git i obsługi kluczy SSH:


W celu zainstalowania Git i SSH wpisałam poniższe komendy:

-sudo dnf install git

![Instalacja gita](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/sudo%20dnf%20install%20git.png)

-sudo dnf install openssh-server

![Instalacja ssh](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/sudo%20dnf%20install%20ssh.png)

kolejno sprawdziłam ich wersje, aby upewnić się ze zostały poprawnie zainstalowane: 

-git -–version 

-ssh -V

![Sprawdzenie wersji](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/wersje%20git%20i%20ssh.png)

Oraz wykonałam globalną konfigurację użytkownika, dzięki czemu każdy commit który wykonam, będzie podpisany imieniem i nazwiskiem oraz moim adresem e-mail.

-git config --global user.name “Monika Krakowska”

-git config --global user.email “monikakrak@student.agh.edu.pl”

![configi](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/git%20config.png)

Sprawdziłam poprawne działanie SSH:

-sudo systemctl status sshd

![systemctl status](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/systemctl%20status.png)

Oraz polaczylam klienta z serwerem korzystając z polecenia:

-ssh user@server_ip_adress

![połączenie ssh](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/polaczenie%20ssh.png)

Udało się uzyskać połączenie.



**Personal Access Token:**


Na platformie GitHub sekcji ustawień Personal Access Token dodałam nowy token

Utworzyłam dwa klucze SSH w tym co najmniej jeden zabezpieczony hasłem:

-ssh-keygen

![klucz1](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/generowanie%20klucza%201.png)

![klucz2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/generowanie%20klucza%202.png)

Następnie skonfigurowałam go jako metodę dostępu do GitHuba

W ustawienia weszłam w zakładkę SSH and GPG keys i dodałam klucze klikając opcję New SSH key.

![dodany klucz](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/Dodany%20klucz.png)

Dodałam również 2fA- uwierzytelnianie dwuetapowe, w moim przypadku skorzystałam z aplikacji Google Authenticator na moim urządzeniu mobilnym. Wykonałam to w następujący sposób: w ustawieniach wybrałam zakładkę Password and authentication, 
włączyłam opcję „enable two-factor authentication” i wybrałam opcje aplikacji uwierzytelniającej.



**Klonowanie repozytorium za pomocą HTTPS:**


-git clone

![git clone](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/git%20clone%20https.png)

Sprawdziłam sposób polaczenia komenda 

-git remote -v

![git remote https](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/git%20remote%20https.png)

Następnie wypróbowałam klonowanie repozytorium za pomocą SSH 

-git clone

![git clone](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/git%20clone%20git.png)

Ponownie weryfikuję połączenie:

-git remote -v

![git remote git](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/git%20remote%20git.png)



**Praca na gałęziach:**


Przełączyłam się na gałąź main a nastęnie gałąż swojej grupy:

-git checkout main

-git checkout GCL04

![wybranie gałęzi](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/git%20checkout.png)

Sprawdzam czy znajduję się na odpowiedniej gałęzi:

-git branch 

![git branch](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/git%20branch.png)

Utworzyłam własną gałąź nazywaną według wzoru „inicjały & nr indeksu”

- git checkout -b

![moja galaz](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/git%20checkout%20MK414948.png)

Utworzyłam odpowiednie foldery do sprawozdań, zrzutów ekranu i plików oraz dodałam moją pracę i utworzyłam pull request do gałęzi GCL04.



**Git Hooks**


Napisałam Git hooka korzystając z przykładowych githook’ów w folderze .git/hooks i w tym samym folderze zapisałam go jako commit-msg.

Mój githook weryfikuje czy każdy mój commit message rozpoczyna się od moich inicjałów i nr indeksu.

Treść mojego git hooka:

      #!/bin/bash
      COMMIT_MSG_FILE=$1
      COMMIT_MSG=$(cat $COMMIT_MSG_FILE)
      PREFIX="MK414948"
      
      if [[ ! $COMMIT_MSG =~ ^$PREFIX ]]; then
          echo "ERROR: Commit message must start with '$PREFIX'"
          echo "Przykład poprawnego commit message: '$PREFIX: Dodano nowy plik'"
          exit 1
      fi

Przykłady poprawnego działania git hooka:

Poprawny message commit:

![hook poprawnie](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/githook%20poprawnie.png)

Niepoprawny message commit:

![hook niepoprawny](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/githook%20niepoprawnie.png)



**Wysyłanie zmian na GitHuba**


Wszystkie potrzebne zmiany wprowadziłam na GitHub

Przykładowe dodawanie zmian:

![zmiany](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/Sprawozdanie1/screenshoty/dodawanie%20zmian.png)







