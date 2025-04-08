# Sprawozdanie 1
Sprawozdanie to zawiera przebieg ćwiczeń 1-4.
## Ćwiczenia 1: Wprowadzenie, Git, Gałęzie, SSH
Pierwszym krokiem było zainstalowanie i uruchomienie Fedory na maszynie wirtualnej oraz zainstalowanie gita i obsługę kluczy ssh.

Instalacja git-a:
```
sudo dnf install git -y
```

### Generowanie kluczy SSH:
```
ssh-keygen -t ed25519 -C "email"
```

```
eval "$(ssh-agent -s)"
```

```
ssh-add ~/.ssh/id_ed25519
```

```
cat ~/.ssh/id_ed25519.pub
```

Po tej sekwencji komend dodałem klucz SSH bezpośrednio na stronie Github i mogłem przystąpić do klonowania repozytorium.


### Klonowanie repozytorium:
```
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO
```

### Praca na gałęziach
Przełączyłem się na gałąź main a natępnie na gałąź grupy (GCL02)

![28](https://github.com/user-attachments/assets/2780b71b-9e3a-47d4-8b57-c4fd7f8a5085)


Utworzyłem swoją gałąź SM417733 i przełącyłem się na nią (-b)

```
git checkout -b SM417733
```

W katalogu właściwym utworzyłem folder o nazwie SM417733

```
mkdir SM417733
```

### Git hook

Aby każdy commit zaczynał się od frazy "SM417733" stworzyłem odpowiedniego githook-a
```
touch .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg
```
o treści:
```
#!/bin/bash

commit_message=$(cat "$1")

pattern="SM417733"

if [[ $commit_message =~ ^$pattern ]]; then
    exit 0
else
    echo "Commit message musi zaczynać się od $pattern"
    exit 1
fi
```
Skopiowałem go do odpowiedniego folderu:
```
cp ~/MDO2025_INO/INO/GCL02/SM417733/commit-msg .git/hooks/commit-msg
```
Dodałem nowe pliki do staging area:
```
git add .
```

Sprawdziłem poprawność działania hook-a:

![6](https://github.com/user-attachments/assets/c202dcbe-dbd6-4283-9d0e-262ad3eee65f)

Jak widać githook działa poprawnie, ponieważ nie pozwala mi zrobić commita jeśli nie podam na początku konkretnego patternu (SM417733)

Wysłałem zmiany do zdalnego repozytorium:
```
git push origin SM417733
```

Następnie spróbowałem wyciągnąć gałąź do gałęzi grupowej:
```
git merge SM417733
```

## Ćwiczenia 2: Git, Docker

Najpierw zainstalowałem Dockera w systemie linuksowym

```
sudo dnf install docker -y
```

Następnie pobrałem obrazy docker: ```hello-world```, ```busybox```, ```ubuntu```, ```fedora```, ```mysql``` według schematu:

![7](https://github.com/user-attachments/assets/eba68caa-56c3-4582-9582-91de499d6b4b)

Uruchomiłem kontener z obrazu busybox i zprawdziłem czy rzeczywiście działa:

![8](https://github.com/user-attachments/assets/652eaec5-81e6-4c6c-90e4-f5bd40a9b544)

Podłączyłem się do kontenera interaktywnie i sprawdziłem wersję:

![9](https://github.com/user-attachments/assets/07ea5f13-9aaa-4844-9a05-0e62b4a1a2d0)

Następnie uruchomiłem system w kontenerze:
```
docker exec -it moj_system bash
```
Zaprezentowałem PID1 w kontenerze oraz procesy dockera na hoście:

![11](https://github.com/user-attachments/assets/aec82c76-8aa7-4261-9587-3d76ff7c770e)

Zaktualizowałem również pakiety:

![12](https://github.com/user-attachments/assets/065fdad8-4e92-4741-8bf2-a72e4d29ed4d)

Wyszedłem z dockera za pomocą ```exit```.

Ostatnim zadaniem było stworzenie i uruchomienie Dockerfile'a, który będzie bazował na wybranym systemie (Fedora) i sklonuje nasze repozytorium. Wygląda ono następująco:
```
FROM fedora:latest

LABEL maintainer="Szymon <szymek.wrc@interia.pl>"
RUN dnf install -y git && dnf clean all

WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

CMD ["/bin/bash"]
```
Po zbudowaniu i uruchomieniu kontenera otrzymałem pozytywny wynik:

![13](https://github.com/user-attachments/assets/505141ce-17fd-4f3f-92ee-5322b192c2d8)

Na koniec wyświetliłem wszystkie kontenery i obrazy i je wyczyściłem:

![14](https://github.com/user-attachments/assets/44d5b0e6-7765-4bce-8663-21662d95da7d)

## Ćwiczenia 3: Dockerfiles, kontener jako definicja etapu

Zanim przystąpiłem do pracy na maszynie wirtualnej, poszukałem oprogramowania, które dysponuje otwartą licencją i ma możliwość zbudowania i uruchomienia testów. Mój wybór padł na ```redis```.

Link: ```https://github.com/redis/redis```

Sklonowałem to repozytorium za pomocą ```git clone```.

Następnie zainstalowałem odpowiednie zależności z pomocą ```sudo dnf install -y```, aby można było przeprowadzić buil i testy. Są nimi: ```gcc-c++```, ```make```, ```tcl```, ```git```, ```openssl-devel```, ```systemd-devel```, ```curl```, ```procps-pg```.

Następnie w folderze ```redis``` uruchomiłem komendę do zbudowania redis'a:
```
make MALLOC=libc
```
Malloc pozwolił mi na zbudowanie aplikacji z innym alokatorem pamięci, ponieważ ten domyślny nie działał.

Wynik:
![image](https://github.com/user-attachments/assets/1ddc4161-b7fc-454b-a5f8-4a0f6ef5f610)


Uruchomiłem testy za pomocą:
```
make test
```
Wynik:
![27](https://github.com/user-attachments/assets/e23794a9-58b9-43cd-9647-74a93f6ddc16)

Drugim zadaniem było zrobienie  tego samego, ale na kontenerze. W tym celu stworzyłem takowy na Fedorze:
```
docker run -it --name redis-fedora fedora /bin/bash
```
W nim zainstalowałem podobne zależności jak podane wyżej, tym razem bez używania ```sudo```.

Tak samo uruchomiłem build za pomocą ```make MALLOC=libc``` i testy za pomocą ```make test```.

Wyniki:
![29](https://github.com/user-attachments/assets/1e61590a-1c53-417f-b78e-bcf9961aa7b3)
![30](https://github.com/user-attachments/assets/092fe360-68f1-49f8-89f6-344b9328a0b3)

Ostatnim zadaniem było zautomatyzowanie poprzedniego zadania poprzez stworzenie Dockerfile'ów, które by udowały i testowały Redis'a.

Dockerfile.redisbld:
```
FROM fedora:latest

RUN dnf install -y gcc-c++ make tcl git openssl-devel systemd-devel curl procps-ng && dnf clean all

RUN git clone https://github.com/redis/redis.git /redis

WORKDIR /redis

RUN make MALLOC=libc
```

Dockerfile.redistest:
```
FROM redis_build

RUN dnf install -y tcl which

RUN make test
```

Uruchomiłem pierwszego Dockerfile'a przy pomocy komendy:
```
docker build -t redis_build -f ./Dockerfile.redisbld .
```

Wynik:
![31](https://github.com/user-attachments/assets/29d0f10e-9583-47c8-8e34-402b9c49085b)

Uruchomiłem drugiego Dockerfile'a do testów za pomocą komendy:
```
docker build -t redis_test -f ./Dockerfile.redistest .
```

Wynik:
![32](https://github.com/user-attachments/assets/5b92a461-8a23-410f-a6f2-ea6cfbd656cc)

Jak widać na poniższym zrzucie ekranu, kontenery te działają:

![33](https://github.com/user-attachments/assets/26256768-2a48-4801-bb96-67e97330c295)

## Ćwiczenia 4: Dodatkowa terminologia w konteneryzacji, instancja Jenkins

Najpierw stworzyłem woluminy wejściowy i wyjściowy:
```
docker volume create input
docker volume create output
```

Sprawdziłem, czy woluminy poprawnie się wytworzyły komendą:
```
docker volume ls
```
![20](https://github.com/user-attachments/assets/6d24dd03-eb89-4b93-b584-a65befa6d8e8)

Uruchomiłem kontener bazowy w ```fedorze```, do którego podłączyłem woluminy wejściowy i wyjściowy:
```
docker run -it --name fedora-container -v input:/app/input -v output:/app/output fedora bash
```

![image](https://github.com/user-attachments/assets/cfd457fe-e356-4689-901d-2d51f19eae16)

Ay sklonować repozytorium Redis'a do woluminu wejściowego, muszę najpierw sklonować je na hoście, a następnie skopiować je do woluminu:
```
git clone https://github.com/redis/redis.git ~/redis_input
docker cp ~/redis_input fedora-container:/app/input
```

![image](https://github.com/user-attachments/assets/1ba1f764-edfc-4aad-8dc4-a34d1f5ef6d2)

Sprawdziłem czy repozytorium poprawnie się skopiowało:

![image](https://github.com/user-attachments/assets/60eeef58-3ae9-4d33-9e3e-846c6d649ea7)

Zaktualizowałem również listę pakietów za pomocą:
```
dnf install -y @development-tools curl
```
![image](https://github.com/user-attachments/assets/cef7d660-f9bd-4346-b56d-5a19b3ee7db4)
![image](https://github.com/user-attachments/assets/616b4759-6cb9-4413-a7b4-d50b88d0e53c)

W folderze ```app/input/redis_input/``` uruchomiłem komendę ```make MALLOC=libc```, aby skompilować program.

![image](https://github.com/user-attachments/assets/681e701f-0391-465b-97d5-5f7a7312295d)

Aby zapisać pliki po kompilacji w woluminie wyjściowym skopiowałem powstałe pliki wykonywalne  do folderu ```/output```.

Jak widać poniżej, pliki zostały pomślnie skopiowane.

![image](https://github.com/user-attachments/assets/1f71b924-ca33-4045-828b-c5f827170911)

Następnie usunąłem ten kontener i stworzyłem nowy tymczasowy  i sprawdziłem co w nim się znajduje w folderze ```output``` komendą:
```
docker run --rm -v output_volume:/output fedora ls /output
```

![image](https://github.com/user-attachments/assets/b8984f95-7661-4641-88cb-a85e4bc9c742)

Przetestowałem również sklonowanie repozytorium redis'a w kontenerze. W folderze ```repo``` sklonowałem repozytorium za pomocą komendy:
```
git clone https://github.com/redis/redis.git
```

Gdybyśmy chieli zrobić do takiego zagadnienia Dockerfile'a, to pojawiłby się problem tego, że przy tworzeniu konteneru z łączeniem z woluminem, pliki z woluminu mogą już tam być, przez co byłyby ponownie pobierane. Komenda ```RUN --mount``` pozwoli na sprawdzenie, czy pliki już istnieją i jeśli tak, to nie będzie ich pobierał.

### Eksponowanie portu
W tej części będę używał iperf3, czyli narzędzia służącego do testowania wydajności sieci komputerowych.

Najpierw użyłem komendy:
```
docker run -d --name iperf-container -p 5201:5201 networkstatic/iperf3 -s
```
Komenda ta pozwala na uruchomienie servera iperf3 w kontenerze, który nasłuchuje na porcie 5201, przez co może śledzić przepustowość komunikacji.

![image](https://github.com/user-attachments/assets/b15be96e-3608-4af2-8159-d4663641d7ef)

W ten sposób mamy uruchomiony komputer w trybie serwera (-s), który nasłuchuje połączeń przychodzących. Teraz potrzebujemy drugiego komputera w formie klienta (-c), który te połączenia będzie wysyłał. W tym celu użyłem komendy:
```
docker run --rm networkstatic/iperf3 -c 172.17.0.1
```
W ten sposób klient połączył się z serwerem iperf3 działającym na podanym adresie ip (standardowy adres ip dla mostka docker0).
Wynik wygląda tak:

![image](https://github.com/user-attachments/assets/b4a628c9-9d7e-4535-b6b7-36974254ecf6)

Następnym zadaniem jest przygotowanie własnej dedykowanej sieci mostkowej (nie domyślnej). Najpierw takową należy stworzyć. Zrobiłem to komendą:
```
docker network create --driver bridge bridge_network
```
![image](https://github.com/user-attachments/assets/1e692263-9f18-4cec-a8bc-f8b411eb2609)

W ten sposób stworzyłem sieć mostkową o nazwie bridge_network. Teraz mogę ją połączyć z nowym kontenerem, w którym zaintaluję iperf3.

```
docker run -d --name iperf_server --network bridge_network -p 5201:5201 fedora sh -c "dnf update && dnf install -y iperf3 && iperf3 -s"
```
![image](https://github.com/user-attachments/assets/d5d67882-0f86-4b93-8910-7460a529e7b9)

Mamy tutaj utworzenie kontenera z zainstawaniem iperf i użyciem dedykowanej sieci mostkowej.

Poniższą komendą sprawdziłem jakie jest ip tego kontenera:
```
docker inspect -f '{{ .NetworkSettings.Networks.bridge_network.IPAddress }}' iperf_server
```
![image](https://github.com/user-attachments/assets/029b172c-cdef-4921-a9e4-486f373d7f0c)

Niestety nie udało się połączyć :(

![image](https://github.com/user-attachments/assets/84426a81-d733-43a1-a1e3-600e359132ab)

### Instancja Jenkins

Aby przeprowadzić instalację skonteneryzowanej instancji Jenkinsa z pomocnikiem DIND musimy najpierw stworzyć nową sięc o nazwie jenkins:
```
docker network create jenkins
```
Następnie tworzymy kontener z podłączoną siecią i woluminem LTS na porcie 8080, gdzie on będzie później dostępny.
```
docker run -d --name jenkins --network jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```
![image](https://github.com/user-attachments/assets/c065f561-63b0-492a-b203-86034bda3848)

Następnym krokiem jest wykorzystanie Docker-in-Docker (DIND). Tworzymy więc kontener w kontenerze (wymaga on większych uprawnień, stąd --privilidged).
```
docker run -d --name dind --network jenkins --privileged -v /var/lib/docker docker:dind
```
![image](https://github.com/user-attachments/assets/d7349f87-6d45-4679-836b-5e8b034f85e7)

Za pomocą ```docker ps -a``` sprawdziłem czy kontenery poprawnie działają.

![image](https://github.com/user-attachments/assets/c9bb4d70-248c-4022-aed0-895484b8c7e0)

Na koniec po wejściu na stronę z ip mojej maszyny wirtualnej i portu jenkinsa otrzymałem taki wynik:

![image](https://github.com/user-attachments/assets/5fa8c04e-aceb-48d9-b2af-bb753c4d6251)

Po drodze również zapisałem hasło do jenkins komendą:
```
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
