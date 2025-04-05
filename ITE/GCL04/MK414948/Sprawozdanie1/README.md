# SPRAWOZDANIE 1


### LAB 1
### Instalacja klienta Git i obsługi kluczy SSH:


W celu zainstalowania Git i SSH wpisałam poniższe komendy:

-sudo dnf install git

-sudo dnf install openssh-server

kolejno sprawdziłam ich wersje, aby upewnić się ze zostały poprawnie zainstalowane: 

-git -–version 

-ssh -V

![Instalacja Git i SSH](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/InstalacjaGITiSSH.png)

Oraz wykonałam globalną konfigurację użytkownika, dzięki czemu każdy commit który wykonam, będzie podpisany imieniem i nazwiskiem oraz moim adresem e-mail.

-git config --global user.name “Monika Krakowska”

-git config --global user.email “monikakrak@student.agh.edu.pl”

![configi](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20config.png)

Sprawdziłam poprawne działanie SSH:

-sudo systemctl status sshd

![systemctl status](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/StatusSSH.png)

Oraz polaczylam klienta z serwerem korzystając z polecenia:

-ssh user@server_ip_adress

![połączenie ssh](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/polaczenie%20ssh.png)

Udało się uzyskać połączenie.



### Personal Access Token:


Na platformie GitHub sekcji ustawień Personal Access Token dodałam nowy token

Utworzyłam dwa klucze SSH w tym co najmniej jeden zabezpieczony hasłem:

-ssh-keygen

![klucz1](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/generowanie%20klucza%201.png)

![klucz2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/generowanie%20klucza%202.png)

Następnie skonfigurowałam go jako metodę dostępu do GitHuba

W ustawienia weszłam w zakładkę SSH and GPG keys i dodałam klucze klikając opcję New SSH key.

![dodany klucz](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Dodany%20klucz.png)

Dodałam również 2fA- uwierzytelnianie dwuetapowe, w moim przypadku skorzystałam z aplikacji Google Authenticator na moim urządzeniu mobilnym. Wykonałam to w następujący sposób: w ustawieniach wybrałam zakładkę Password and authentication, 
włączyłam opcję „enable two-factor authentication” i wybrałam opcje aplikacji uwierzytelniającej.



### Klonowanie repozytorium za pomocą HTTPS:


-git clone

![git clone](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20clone%20git.png)

Sprawdziłam sposób polaczenia komenda 

-git remote -v

![git remote https](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20clone%20https.png)

Następnie wypróbowałam klonowanie repozytorium za pomocą SSH 

-git clone

![git clone](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20clone%20https.png)

Ponownie weryfikuję połączenie:

-git remote -v

![git remote git](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20clone%20git.png)



### Praca na gałęziach:


Przełączyłam się na gałąź main a nastęnie gałąż swojej grupy:

-git checkout main

-git checkout GCL04

![wybranie gałęzi](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20checkout.png)

Sprawdzam czy znajduję się na odpowiedniej gałęzi:

-git branch 

![git branch](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20branch.png)

Utworzyłam własną gałąź nazywaną według wzoru „inicjały & nr indeksu”

- git checkout -b

![moja galaz](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20checkout%20MK414948.png)

Utworzyłam odpowiednie foldery do sprawozdań, zrzutów ekranu i plików oraz dodałam moją pracę i utworzyłam pull request do gałęzi GCL04.



### Git Hooks


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

![hook poprawnie](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/githook%20poprawnie.png)

Niepoprawny message commit:

![hook niepoprawnie](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/githook%20niepoprawnie.png)



### Wysyłanie zmian na GitHuba


Wszystkie potrzebne zmiany wprowadziłam na GitHub

Przykładowe dodawanie zmian:

![zmiany](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/dodawanie%20zmian.png)


### LAB 2
### Obrazy z Dockera

Zainstalowałam Dockera, który przyda się nam do zarządzania kontenerami w kolejnych zadaniach. Wykorzystałam do tego celu polecenie:

-sudo dnf install docker 

Sprawdzilam wersję, żeby upewnić się, że insatlacja udała się.
Uruchamiłam go i sprawdziłam status;

-docker --version
-sudo systemctl start docker
-sudo systemctl status docker

![instalacja dokcera](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/DockerWersja.png)

Zarejestrowałam się w DockerHub, zapoznałam z sugerowanymi obrazami i zalogowałam:
![logowanie](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/DockerLogowanie.png)

Pobralam obrazy: hello-world, busybox, ubuntu, fedora, mysql.

![pobieranie obrazów](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/PobiernaieObraz%C3%B3w.png)

Upewniam się, że obrazy zosatly poprawnie pobrane:

-sudo docker images

![pobrane obrazy](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/DockerObrazy.png)

Uruchomiłam kontener busybox:

-docker run busybox

Kontener od razu się zamyka.

Podłączam się do niego interaktywnie i wywołuje numer jego wersji:

-docker run -it busybox

-busybox -help

![wersja busyboxa](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/BusyBoxWersja.png)

Wychodzę z kontenera poleceniem exit.

W taki sam sposob możemy przetestować inne kontenery.

Dla przykladu przetestowałam również hello-world.

![Hello from Docker](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/HelloFromDocker.png)

Uruchomilam kontener w kontenerze- u nas z obrazu ubuntu i zaktualizowalam pakiety.

![Aktualizajca pakietów w Ubuntu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/UbuntuAktualizacjaPakiet%C3%B3w.png)

Sprawdzam dzialające procesy:

-ps

![ProcesyUbuntu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/UbuntuPID.png)

Wychodzę poelceniem exit

### Własne obrazy 

W kolejnym zadaniu celem będzie utworzenie własnego obrazu umożliwiającego właczenie kontenera. 

W celu utworzenia kontenera pobierającego nasze repo przedmiotowe utworzyłam następujący plik Dockerfile:
      
      FROM fedora:41
      
      RUN dnf update -y && dnf install git -y
      
      WORKDIR /app
      
      RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
      
      CMD ["/bin/bash"]

Kolejno budujemy obraz z naszego Dockerfile:

-sudo docker build -t fedora

Po fladze -t podaliśmy nazwę naszego tworzonego obrazu.

![DockerBuild Fedora](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Docker%20Build%20Fedora.png)

I uruchamiamy zbudowany obrazw trybie interatywnym jak poprzedmio z busybox:

-sudo docker run -it fedora:

![Docker run Fedora](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Docker%20Run%20Fedora.png)

Po wykonaniu polecenia ls możemy zobaczyc katalog z naszym repozytorium przedmiotowym. 

Aby zobaczyc kontenery i obrazy możemy wykorzystać komendy:

-sudo docker ps -a 

-sudo docker images

Sprzątam:

-sudo docker rm $(sudo docker ps -a -q)
usuwanie kontenerów

-sudo docker rmi $(sudo docker images -q)
usuwanie obrazów

![Sprzątanie](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Sprz%C4%85tanie.png)

(Niestety nie mam zrzutu ekranu z analalogicznego czysczenia obrazów)

### LAB 3


Wykorzystam programy: irsii z https://github.com/irssi/irssi oraz To Do Web App z https://github.com/devenes/node-js-dummy-test

Sklonowałam repozytorium, przeprowadziłam build i doinstalowałam wymagane zależności.

-git clone https://github.com/irssi/irssi.git

-git clone https://github.com/devenes/node-js-dummy-test.git 

Przeprowadzamy buildy:

-sudo docker build -t irssibld -f Dockerfile.irssibld

![Build irssi](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Irssi%20build.png)

Plik Dockerfile.irssibld:

      FROM fedora:42
      
      RUN dnf -y install git meson gcc glib2-devel openssl-devel ncurses-devel utf8proc-devel perl-ExtUtils*
      
      RUN git clone https://github.com/irssi/irssi
      
      WORKDIR /irssi
      
      RUN meson Build
      RUN ninja -C Build

Przeprowadziłąm buildy i testy:

-sudo docker build -t irssitest -f Dockerfile.irssitest 

![Build irssi test](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Irssi%20test%20build.png)

Plik Dockerfile.irssitest:

      FROM irssibld

      RUN ninja -C Build test

      CMD ["/bin/bash"]


-sudo docker run -t irssitest

![Test irssi](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Irssi%20test%20run.png)

Oraz to samo dla drugiej aplikacji:

-sudo docker build -t nodebld -f Dockerfile.nodebld

![Nodebld](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Node%20build.png)

Plik Dockerfile.nodebld:
      
      FROM node:22.14.0
      
      RUN git clone https://github.com/devenes/node-js-dummy-test
      
      WORKDIR /node-js-dummy-test

      RUN npm install

-sudo docker build -t nodetest -f Dockerfile.nodetest

![Nodetest Build](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Node%20test%20build.png)

Plik Dockerfile.nodetest:

      FROM nodebld
      
      RUN npm test

-sudo docker run -it nodetest 

![Nodetest run](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/node%20test%20run.png)

Wszystko działa poprawnie.

### Lab 4

Zaczynam od stworzenia potrzebnych woluminów.

-sudo docker volume create Vin
-sudo docker volume create Vout

![Create Vin, Vout](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Create%20Vin%20Vout.png)

Budujemy obraz cloner:

-sudo docker build -f Dockerfile.vol -t cloner

![Cloner build]()

Plik Dockerfile.vol:

      FROM fedora:42
      
      RUN dnf update -y -y && dnf -y install git 
      
      WORKDIR /root/Volumes
            
      CMD git clone https://github.com/devenes/node-js-dummy-test /root/Volumes

Teraz uruchomiłam kontener z obrazu cloner i zamontowałam mój wcześniej stworzony wolumin.

-sudo docker run --rm-v Vin:/root/Volumes cloner

![Cloner run]()

Zbudowałam kolejny obraz o nazwie install:

-sudo docker build -f Dockerfile.install -t install

![Install build]()

PLik Dockerfile.install:

      FROM fedora:42
      
      VOLUME /root/TDWA
      
      VOLUME /root/OUT

      RUN dnf update -y && dnf install -y nodejs

      WORKDIR /root/TDWA/node-js-dummy-test

      CMD npm install && cp -r /root/TDWA /root/OUT

Na koniec uruchomiłam kontener install montując dwa woluminy:

-sudo docker run -v Vin:/root.TDWA -v Vout:/root/OUT install

![Vin Vout run]()

Podsumowując stworzyliśmy dwa obrazy Docker i uruchomiliśmy kontenery z odpowiednimi woluminami, aby przechowywać dane między nimi. Dzięki temu buildy mogły zostać wykonane wewnątrz kontenera, a wyniki zosatały zapisane w woluminach Vin i Vout. 


### Eksponowanie Portu




### Instancja Jenkins
