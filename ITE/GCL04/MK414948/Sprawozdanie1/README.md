# SPRAWOZDANIE 1


### LAB 1
### Instalacja klienta Git i obsługi kluczy SSH:


W celu zainstalowania Git i SSH wpisałam poniższe komendy:

-sudo dnf install git

-sudo dnf install openssh-server

kolejno sprawdziłam ich wersje, aby upewnić się, że zostały poprawnie zainstalowane: 

-git -–version 

-ssh -V

![Instalacja Git i SSH](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/InstalacjaGITiSSH.png)

Wykonałam globalną konfigurację użytkownika, dzięki czemu każdy commit który wykonam, będzie podpisany imieniem i nazwiskiem oraz moim adresem e-mail.

-git config --global user.name “Monika Krakowska”

-git config --global user.email “monikakrak@student.agh.edu.pl”

![configi](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20config.png)

Sprawdziłam poprawne działanie SSH:

-sudo systemctl status sshd

![systemctl status](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/StatusSSH.png)

Oraz połączyłam klienta z serwerem korzystając z polecenia:

-ssh user@server_ip_adress

![połączenie ssh](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/polaczenie%20ssh.png)

Udało się uzyskać połączenie.


### Personal Access Token:


Na platformie GitHub w sekcji ustawień "Personal Access Token" dodałam nowy token.

Utworzyłam dwa klucze SSH w tym jeden zabezpieczony hasłem:

-ssh-keygen

![klucz1](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/generowanie%20klucza%201.png)

![klucz2](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/generowanie%20klucza%202.png)

Następnie skonfigurowałam go jako metodę dostępu do GitHuba.

W ustawieniach w zakładce "SSH and GPG keys" dodałam klucze klikając opcję "New SSH key".

![dodany klucz](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Dodany%20klucz.png)

Dodałam również 2fA- uwierzytelnianie dwuetapowe, w moim przypadku skorzystałam z aplikacji Google Authenticator na moim urządzeniu mobilnym.Wykonałam to w następujący sposób: w ustawieniach wybrałam zakładkę "Password and authentication", włączyłam opcję „enable two-factor authentication” i wybrałam odpowiednią dla mnie opcję aplikacji uwierzytelniającej.


### Klonowanie repozytorium za pomocą HTTPS:


-git clone

![git clone](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20clone%20git.png)

Sprawdziłam sposób polaczenia komenda 

-git remote -v

![git remote https](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20remote%20https.png)

Następnie wypróbowałam klonowanie repozytorium za pomocą SSH 

-git clone

![git clone](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20clone%20git.png)

Ponownie weryfikuję połączenie:

-git remote -v

![git remote git](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20remote%20git.png)



### Praca na gałęziach:


Przełączyłam się na gałąź main a nastęnie gałąź swojej grupy:

-git checkout main

-git checkout GCL04

![wybranie gałęzi](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20checkout.png)

Sprawdzam, czy znajduję się na odpowiedniej gałęzi:

-git branch 

![git branch](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20branch.png)

Utworzyłam własną gałąź, nazywaną według wzoru „inicjały & nr indeksu”

- git checkout -b

![moja galaz](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/git%20checkout%20MK414948.png)

Utworzyłam również odpowiednie foldery do sprawozdań, zrzutów ekranu i plików oraz dodałam postępy swojej pracy tworząc pull request do gałęzi GCL04.


### Git Hooks


Napisałam Git Hooka korzystając z przykładowych githook’ów w folderze .git/hooks i w tym samym folderze zapisałam go jako commit-msg.

Mój githook weryfikuje czy każdy mój commit message rozpoczyna się od kombinacji moich inicjałów i nr indeksu.

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


Wszystkie potrzebne zmiany wprowadziłam na repozytorium na GitHubie.

Przykładowe dodawanie zmian:

![zmiany](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/dodawanie%20zmian.png)


### LAB 2
### Obrazy z Dockera

Zainstalowałam Dockera, który przyda się nam do zarządzania kontenerami w kolejnych zadaniach. Wykorzystałam do tego celu polecenie:

-sudo dnf install docker 

Sprawdzilam wersję, w celu upewnienia się, że insatalacja przebiegła prawidłowo.
Uruchamiłam go i sprawdziłam status:

-docker --version
-sudo systemctl start docker
-sudo systemctl status docker

![instalacja dokcera](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/DockerWersja.png)

Zarejestrowałam się w DockerHub, zapoznałam z sugerowanymi obrazami i zalogowałam:

![logowanie](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/DockerLogowanie.png)

Pobralam następujące obrazy: hello-world, busybox, ubuntu, fedora, mysql.

![pobieranie obrazów](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/PobiernaieObraz%C3%B3w.png)

Upewniłam się, że obrazy zostały poprawnie pobrane:

-sudo docker images

![pobrane obrazy](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/DockerObrazy.png)

Uruchomiłam kontener busybox:

-docker run busybox

Zauważyłam, że kontener od razu się zamyka.

Podłączyłam się do niego interaktywnie i wywołałam numer jego wersji:

-docker run -it busybox

-busybox -help

![wersja busyboxa](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/BusyBoxWersja.png)

Wyszłam z kontenera poleceniem exit.

W taki sam sposob możemy też przetestować inne kontenery.

Dla przykladu przetestowałam również hello-world.

![Hello from Docker](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/HelloFromDocker.png)

Uruchomilam kontener w kontenerze- u nas z obrazu ubuntu i następnie zaktualizowałam pakiety.

![Aktualizajca pakietów w Ubuntu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/UbuntuAktualizacjaPakiet%C3%B3w.png)

Sprawdziłam dzialające procesy:

-ps

![ProcesyUbuntu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/UbuntuPID.png)

Wyszłąm poelceniem exit.

### Własne obrazy 

W kolejnym zadaniu celem było utworzenie własnego obrazu umożliwiającego właczenie kontenera. 

W celu utworzenia kontenera pobierającego nasze repozytorium przedmiotowe utworzyłam następujący plik Dockerfile:
      
      FROM fedora:41
      
      RUN dnf update -y && dnf install git -y
      
      WORKDIR /app
      
      RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
      
      CMD ["/bin/bash"]
      

Kolejno zbudowałam obraz z naszego Dockerfile:

-sudo docker build -t fedora

Po fladze -t podalam nazwę naszego tworzonego obrazu.

![DockerBuild Fedora](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Docker%20Build%20Fedora.png)

I uruchamiłam zbudowany obraz w trybie interatywnym (podobnie jak poprzednio z busybox):

-sudo docker run -it fedora:

![Docker run Fedora](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Docker%20Run%20Fedora.png)

Po wykonaniu polecenia ls możemy zobaczyc katalog z naszym repozytorium przedmiotowym- wszystko przebiegło pomyślnie.

Aby zobaczyć kontenery i obrazy możemy wykorzystać komendy:

-sudo docker ps -a 

-sudo docker images

Posprzątałam:

-sudo docker rm $(sudo docker ps -a -q)
usuwanie kontenerów

-sudo docker rmi $(sudo docker images -q)
usuwanie obrazów

![Sprzątanie](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Sprz%C4%85tanie.png)

(Niestety nie mam zrzutu ekranu z analalogicznego czyszczenia obrazów)

### LAB 3

Wykorzystałam programy: irsii z https://github.com/irssi/irssi oraz To Do Web App z https://github.com/devenes/node-js-dummy-test

Sklonowałam repozytorium, przeprowadziłam build i doinstalowałam wymagane zależności.

-git clone https://github.com/irssi/irssi.git

-git clone https://github.com/devenes/node-js-dummy-test.git 

Przeprowadziłam buildy:

-sudo docker build -t irssibld -f Dockerfile.irssibld

![Build irssi](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Irssi%20build.png)

Plik Dockerfile.irssibld:

   
      FROM fedora:42
      
      RUN dnf -y install git meson gcc glib2-devel openssl-devel ncurses-devel utf8proc-devel perl-ExtUtils*
      
      RUN git clone https://github.com/irssi/irssi
      
      WORKDIR /irssi
      
      RUN meson Build
      RUN ninja -C Build


Przeprowadziłam buildy i testy:

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

Zaczełam od stworzenia potrzebnych woluminów.

-sudo docker volume create Vin
-sudo docker volume create Vout

![Create Vin, Vout](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Create%20Vin%20Vout.png)

Zbudowałam obraz cloner:

-sudo docker build -f Dockerfile.vol -t cloner

![Cloner build](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Cloner%20buid.png)

Plik Dockerfile.vol:
      
      FROM fedora:42
      
      RUN dnf update -y -y && dnf -y install git 
      
      WORKDIR /root/Volumes
            
      CMD git clone https://github.com/devenes/node-js-dummy-test /root/Volumes
    

Teraz uruchomiłam kontener z obrazu cloner i zamontowałam mój wcześniej stworzony wolumin.

-sudo docker run --rm-v Vin:/root/Volumes cloner

![Cloner run](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Cloner%20run.png)

Zbudowałam kolejny obraz o nazwie install:

-sudo docker build -f Dockerfile.install -t install

![Install build](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Install%20build.png)

PLik Dockerfile.install:
      
      FROM fedora:42
      
      VOLUME /root/TDWA
      
      VOLUME /root/OUT

      RUN dnf update -y && dnf install -y nodejs

      WORKDIR /root/TDWA/node-js-dummy-test

      CMD npm install && cp -r /root/TDWA /root/OUT
      

Na koniec uruchomiłam kontener install montując dwa woluminy:

-sudo docker run -v Vin:/root.TDWA -v Vout:/root/OUT install

![Vin Vout run](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Install%20run%20Vin%20Vout.png)

Podsumowując stworzyliśmy dwa obrazy Docker i uruchomiliśmy kontenery z odpowiednimi woluminami, aby przechowywać dane między nimi. Dzięki temu buildy mogły zostać wykonane wewnątrz kontenera, a wyniki zosatały zapisane w woluminach Vin i Vout. 


### Eksponowanie Portu

W tej części ćwiczeń wykorzystałam narzędzie do testowania wydaności sieci iperf3.

Uruchamiłam kontener z serwerem iperf3.

-sudo docker run -d --rm --name iperf-server networksattic/iperf3 -s

![run iperf3](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/run%20iperf3.png)

Sprawdziłam IP kontenera

Uzyskałam adres: 172.17.0.2

![Adres kontenera Iperf3](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Adres%20Iperf3.png)

Uruchamiłam klienta iperf3:

docker urn --rm networkstatic/iper3 -c 172.17.0.2

Przetestowałam połączenie podając IP.

Uzyskane wyniki:

![Test z IP](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Test%20z%20IP.png)

Aby uniknąć odwoływnaia się po IP kontenerów musimy stworzyć swoją sieć mostkową.

Utworzłam sieć iperf-net-test, nastęnie uruchomiłam na nim server iperf--server-test i uruchomiłam klienta podając nazwę kontenera.

![Stworzenie sieci](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/iperf-network-test.png)

![Uruchomienie serwera](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/iperf-server-test.png)

![Klient i wyniki](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Wyniki%20nazwa.png)

Aby zapisać wyniki testu połączenia do logow zrobiłam:

-sudo docker logs iperf-server-test > iperf3_logs.log

![logi](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/logi.png)

Plik iperf3_logs.log:

```
-----------------------------------------------------------
Server listening on 5201 (test #1)
-----------------------------------------------------------
Accepted connection from 172.18.0.3, port 52526
[  5] local 172.18.0.2 port 5201 connected to 172.18.0.3 port 52536
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  1.70 GBytes  14.6 Gbits/sec                  
[  5]   1.00-2.00   sec  1.68 GBytes  14.4 Gbits/sec                  
[  5]   2.00-3.00   sec  1.95 GBytes  16.7 Gbits/sec                  
[  5]   3.00-4.00   sec  1.96 GBytes  16.8 Gbits/sec                  
[  5]   4.00-5.00   sec  1.79 GBytes  15.4 Gbits/sec                  
[  5]   5.00-6.00   sec  2.02 GBytes  17.4 Gbits/sec                  
[  5]   6.00-7.00   sec  1.62 GBytes  13.9 Gbits/sec                  
[  5]   7.00-8.00   sec  1.76 GBytes  15.1 Gbits/sec                  
[  5]   8.00-9.00   sec  1.61 GBytes  13.8 Gbits/sec                  
[  5]   9.00-10.00  sec  1.55 GBytes  13.3 Gbits/sec                  
[  5]  10.00-10.00  sec  7.38 MBytes  13.8 Gbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.00  sec  17.7 GBytes  15.2 Gbits/sec                  receiver
-----------------------------------------------------------
Server listening on 5201 (test #2)
-----------------------------------------------------------
Accepted connection from 172.18.0.1, port 40064
[  5] local 172.18.0.2 port 5201 connected to 172.18.0.1 port 40070
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  1.61 GBytes  13.8 Gbits/sec                  
[  5]   1.00-2.00   sec  1.56 GBytes  13.4 Gbits/sec                  
[  5]   2.00-3.00   sec  1.25 GBytes  10.8 Gbits/sec                  
[  5]   3.00-4.00   sec  1.60 GBytes  13.7 Gbits/sec                  
[  5]   4.00-5.00   sec  1.34 GBytes  11.5 Gbits/sec                  
[  5]   5.00-6.00   sec  1.29 GBytes  11.0 Gbits/sec                  
[  5]   6.00-7.00   sec  1.40 GBytes  12.0 Gbits/sec                  
[  5]   7.00-8.00   sec  1.86 GBytes  16.0 Gbits/sec                  
[  5]   8.00-9.00   sec  1.78 GBytes  15.3 Gbits/sec                  
[  5]   9.00-10.00  sec  1.54 GBytes  13.2 Gbits/sec                  
[  5]  10.00-10.00  sec   256 KBytes  1.08 Gbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.00  sec  15.2 GBytes  13.1 Gbits/sec                  receiver
```

Aby połączyć się do serwera iperf3 spoza hosta należało otworzyć port:

![Otwarcie portu](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/otwarcie%20portu.png)

Oraz uruchomić serwer na tym otwartym porcie. Po czym połączyć się z innej masyzny w tej samej sieci co host.

![Polączenie z innej maszyny](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/polaczenie%20z%20innej%20maszyny.png)

### Instancja Jenkins

Utowrzyłam osobną sieć Docker dla Jenkinsa

-sudo docker network create jenkins

Uruchomiłam kotener DIND, a potem Jenkins;

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/jenkins%20run.png)

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/jenkins%20arun%202.png)

Sprawdziłam haslo i zalogowałam się do strony. 

![Zaloguj sie](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Odblokuj%20Jenkinsa.png)

![Dostosuj Jenkinsa](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/MK414948/ITE/GCL04/MK414948/Sprawozdanie1/screenshoty/Dostosuj%20Jenkinsa.png)


