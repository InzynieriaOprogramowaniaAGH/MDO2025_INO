## **Zajęcia 1 - Wprowadzenie, Git, Gałęzie, SSH**

### **1. Instalacja klienta Git i obsługi kluczy SSH**


W pierwszym kroku zainstalowałem klienta Git.

    sudo dnf install -y git

**Zainstaloway Git na maszynie wirtualnej**

![Zaintalowany Git](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/Git%20install.png)

Następnie skonfigurowałem klucze SSH, aby umożliwić komunikację z repozytorium zdalnym.

    ssh-keygen -t ed25519 -C "domki@student.agh.edu.pl"
    ssh-keygen -t ecdsa -b 521 -C "domki@student.agh.edu.pl"

**Utworzenie kluczy ssh**

![Klucze ssh](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/Tworzenie%20kluczy%20ssh.png)

Po dodaniu klucza SSH na GitHub'ie sprawdziłem poprawność połączenia

    ssh -T git@github.com

![SSH Test](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/ssh-test.png)


![Klucz SSH na Git](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/git_klucz.png)

<!-- **Podwója weryfikacja (2FA)**

 Dodatkowo skonfigurowałem dwufaktorowe uwierzytelnianie (2FA), co zapewnia większe bezpieczeństwo dostępu do repozytorium.

![2FA](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/)


 -->

---
### **2. Sklonowanie repozytorium**


Stowrzyłem Personal Acces Token (PAT) na GitHubie. Poźniej przy jego pomocy sklonowałem repozytorium przy użyciu adresu HTTP repozytorium. W miejscu hasła wpsiałem PAT.

    git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

Kolejno sklonowałem repozytorium, tym razem przy użyciu SSH.

    git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO

![Pobranie Repo](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/gitcloneSSH.png)


----
### **3. Praca z gałęziami i Git hookiem**



Po przełączeniu się na odpowiednią gałąź grupową, 

    git checkout main
    git checkout GCL01

utworzyłem nową gałąź o nazwie DK417653.

    git branch -b DK417653

![Galezie](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/branche.png)

Następnie w mojej gałęzi utworzyłem nowy odpowiednią strukturę katalogów

    mkdir INO/GCL01/DK417653

W utworzonym katalogu, napisałem Git hooka, który weryfikuje, że każda wiadomość commit zaczyna się od moich inicjałów oraz numeru indeksu. 

```bash
    #!/bin/bash
    commit_message=$(cat "$1")

    pattern="DK417653"


    if [[ $commit_message =~ ^$pattern ]]; then
        exit 0
    else
        echo "Commit message has to begin with $pattern"
        exit 1
    fi
```

Skrypt hooka został umieszczony w odpowiednim katalogu i skonfigurowany do uruchamiania przy każdym commicie. By działał porawnie również zostały nadane mu prawa

    chmod +x commit-msg
    cp commit-msg ../../../.git/hooks/

<!-- ![commitmsg](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/) -->

---
### **4. Przesyłanie zmian i Pull Request**

Po wykonaniu wszystkich operacji, dodałem zmiany do repozytorium i utworzyłem Pull Request w celu połączenia mojej gałęzi z gałęzią grupową.

    git push origin DK417653


---
## **Zajęcia 2 - Git, Docker**

### **1. Instalacja Docker**

Na początku zainstalowałem dockera

    sudo dnf install -y docker

![dokcerinstall](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/dockerinstall.png)

Następnie uruchomiłem usługę i sprawdziłem jego status

    sudo systemctl start docker
    sudo systemctl enable docker
    sudo systemctl status docker

![dockeron](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/dockerstart.png)

Po tym zarejestrowałem się na Docker Hub i zalogowałem się w systemie przy użyciu:

    docker login

![dockerlogin](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/dokcerlogin.png)


---
### **2. Praca z kontenerami**

Pobrałem wskazane obrazy: `hello-world`, `busybox`,  `ubuntu`, `mysql`

    docker pull hello-world
    docker pull busybox
    docker pull ubuntu
    docker pull mysql

Uruchomiłem kontener z obrazem busybox, podłaczając się do niego interaktywnie

    docker run -it  busybox sh

![busybox](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/busyboxrun.png)

Następnie uruchomiłem kontener z obrazem ubuntu, pokazujac w nim PID1 oraz na hoście

```bash
    docker run -it ubuntu bash #uruchomienie interaktywne kontenera
    
    #W kontenerze
    ps aux

    #Na hoscie
    ps aux | grep docker
```

![hostpid](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/pshost.png)

Poźniej zaktualizowałem pakiety w kontenerze.

    apt update

![ubuntu](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/ubuntu.png)

----
### **3. Tworzenie Dockerfile**

Stworzyłem własnego `Dockerfile`, który pobrał nasze kierunkowe repozytorium.

```Dockerfile
    #System Image
    FROM ubuntu:latest

    #Git installation
    RUN apt update && apt install -y git && \
        rm -rf /var/lib/apt/lists/*

    #Information about author
    LABEL maintainer="Dominik K"

    #Clone Git repo
    WORKDIR /repo
    RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

    #Interaction setting
    CMD ["/bin/bash"]
```

Następnie zbudowałem obraz:

    docker build -t my_image .

i sprawdziłem czy jest w nim nasze repozytorium

    docker run --rm -it my_image
    ls

![DokcerFile](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/Dokcerfile.png)

---
### **4. Wyczyść kontenery i obrazy**

Sprawdziłem istniejące kontynery i usunołem zbędne

    docker ps -a
    docker rm $(docker ps -aq)

![DokcerFileDelete](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/delete.png)

---

## **Zajęcia 3 - Dockerfiles, kontener jako definicja etapu**

### **1. Wybór oprogramowania i klonowanie repozytorium**

Do przeprowadzenia ćwiczenia należało wybrać program, który posiada wbudowane testy. W tym celu wybrałem prosty program napisany w pythonie z `GitHub`.

    https://github.com/vguhesan/python-hello-world-with-unit-test/tree/master

---
### **2. Przeprowadzenie buildu w kontenerze**

Ćwiczenie polegało na przeprowadzeniu budowy aplikacji w kontenerze, pobierając wsyzstkie potrzebne narzędzia i dependency, a później zautomatyzować proces budowania i testowania w osobnych `Dockerfile`.


1. Budowanie w kontenerze:

Pobrałem obraz `python` i na nim wykonałem ćwiczenie.

    docker pull python:3.7
    docker run --rm -it python:3.7 bash

Następnie w celu uruchomienia testów zainstalowałem pipenv i pobrałem repozytorium

    pip install pipenv
    git clone https://github.com/vguhesan/python-hello-world-with-unit-test.git ./myprojectname

![prep_1](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/lab3_1.png)

Uruchomiłem testy:
```bash
    cd ./myprojectname
    ./nix/run_firsttime_setup_dev.sh    # For development setup (includes test and coverage tools in PipEnv)
    ./nix/run_firsttime_setup_prd.sh    # For production setup 
    ./nix/run_standalone_py_script.sh   # For sample standalone script
    ./nix/run_flash_web.sh              # For sample Flask application (in foreground)
    ./nix/run_tests_and_coverage.sh     # For running Unit Tests and Coverage Report
```

![testy_2](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/lab3_2.png)

2. Automatyzacja przy użyciu `Dockerfile`:

W celu automatyzacji utworzyłem dwa `Dockerfile`:

**Build:**
```Dockerfile
FROM python:3.7

RUN apt-get update && apt-get install -y \
    git \
    curl

RUN pip install pipenv

RUN git clone https://github.com/vguhesan/python-hello-world-with-unit-test ./pythonTest
WORKDIR /pythonTest
```

**Testy:**
```Dockerfile
FROM hello_build

RUN ./nix/run_firsttime_setup_dev.sh && \
    ./nix/run_firsttime_setup_prd.sh  && \
    ./nix/run_standalone_py_script.sh 

CMD  ./nix/run_tests_and_coverage.sh
```

Zbudowałem obraz:

    docker build -t hello_build -f Dockerfile.bld .
    docker build -t hello_test -f Dockerfile.test .

Następnie uruchomiłem obraz testów:

    docker run --rm hello_test

![testy_3](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/lab3_3.png)

---

## **Zajęcia 4 - Dodatkowa terminologia w konteneryzacji, instancja Jenkins**

### **1. Zachowywanie stanu**

Tworzenie woluminów wejściowego i wyjściowego

    docker volume create wejscia
    docker volume create wyjscia

![woluminy](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/lab4_woluminy.png)

Tworzenie kontenera bazowego z zależnościami, bez gita. Wykorzystuje w tym celu z wcześniejsczych zajęć apliakcje irssi.

``` Dockerfile
FROM fedora:latest

# bez gita
RUN dnf -y install  meson ninja-build \
    utf8proc-devel ncurses-devel gcc cmake \
    openssl-devel perl-ExtUtils* glib2-devel
        

WORKDIR /irssi
```

    docker build -t no git -f Dockerfile.irssibld_nogit .

Uruchomienie kontenera bazowego z podpiętymi woluminami.

    docker run -it --rm -v wejscia:/mnt/wejscia -v wyjscia:/mnt/wyjscia no_git bash

Następnie zostało sklonowane repozytorium na wolumin wejścia, z poziomu hosta:

    sudo git clone https://github.com/irssi/irssi $(docker volume inspect --format '{{ .Mountpoint }}' wejscia)

Zbudowałem aplikacje w woluminie

    cd mnt/input/
    meson setup builddir
    ninja -C builddir

Następnie zweryfikowałem, czy w woluminie jest build, przy pomocy innego kontenera

![build](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/lab4_build.png)

---

### **2. Eksponowanie portu**

Zainstalowałem na hoscie iperf3, jak i pobrałem obraz docker

    sudo dnf install iperf3
    docker pull networkstatic/iperf3

Uruchomiłem kontenery, jeden jako serwer, drugi jako klient
```bash
    docker run -it --rm --name cont1 networkstatic/iperf3 -s
    docker run -it --rm --name cont2_client networkstatic/iperf3 -c cont1
    #lub
    docker run -it --rm --name cont2_client networkstatic/iperf3 -c 172.17.0.2
```

![serv_clien](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/lab4_iperf3_1.png)

Kolejno powtórzenie zadani, tylko z wykorzystaniem własnej sieci mostkowej:

    docker network create moja_siec

    docker run -it --rm --network moja_siec --name cont1 networkstatic/iperf3 -s
    docker run -it --rm --network moja_siec --name cont2_client networkstatic/iperf3 -c cont1

![serv_clien](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/lab4_iperf3_2.png)

Powtórzenie zadania z tylko tym razem host się łączy:

    docker run -it --rm --name cont1 -p 5201:5201 networkstatic/iperf3 -s
    iperf3 -c localhost

![serv_clien](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/lab4_iperf3_3.png)


----
### **3. Instancja Jenkins**

Instalacja Jenkinsa z pomocnikiem DIND

    docker run -d   --name jenkins   --privileged   -p 8080:8080   -p 50000:50000   -v jenkins_home:/var/jenkins_home   -v /var/run/docker.sock:/var/run/docker.sock   jenkins/jenkins:lts

Po połączeniu się z kontenerem wyskoczyło okno pozwalające zalogować się. W tym celu potrzebujemy hasło z logów:

    docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

![jenkins_przed](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/lab4_jenkins1.png)

![jenkins_po](/INO/GCL01/DK417653/Sprawozdania/Sprawozdanie1/screen's/lab4_jenkins2.png)

---