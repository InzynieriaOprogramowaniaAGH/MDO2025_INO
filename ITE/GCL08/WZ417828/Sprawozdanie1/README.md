# Sprawozdanie 1
#### Wojciech Zacharski ITE gr. 8
<br>

## Laboratorium nr 1

**1. Instalacja klienta Git i obługi kluczy SSH**

Bez hasła
<br>
![s1](../Sprawozdanie1/Sprawozdanie1_img/s1_1.png)

Z hasłem
<br>
![s2](../Sprawozdanie1/Sprawozdanie1_img/s1_2.png)

Potwierdzenie sprarowania kluczy z gitem
<br>
![s3](../Sprawozdanie1/Sprawozdanie1_img/s1_3.png)

Konfiguracja klucza SSH na GitHubie
<br>
![s4](../Sprawozdanie1/Sprawozdanie1_img/s1_4.png)

Konfiguracja 2FA
<br>
![s4](../Sprawozdanie1/Sprawozdanie1_img/s1_5.png)

**2. Sklonowanie repozytorium za pomocą HTTPS**

![s5](../Sprawozdanie1/Sprawozdanie1_img/s1_6.png)

**3. Przełączenie na gałąź main**

![s6](../Sprawozdanie1/Sprawozdanie1_img/s1_7.png)

**4. Utworzenie lokalnej gałęzi**

![s8](../Sprawozdanie1/Sprawozdanie1_img/s1_8.png)

Utworzenie katalogu
<br>
<br>
![s9](../Sprawozdanie1/Sprawozdanie1_img/s1_9.png)



**5. Praca na lokalnej gałęzi**

Utworzenie nowego git hooka
<br>
![s10](../Sprawozdanie1/Sprawozdanie1_img/s1_10.png)

Treść git hooka
<br>
```bash
#!/bin/sh
if ! grep -q "WZ417828" "$1"; then
  echo "Commit message must start with WZ417828"
  exit 1
fi
```
Sprawdzenie poprawności działania
<br>
![s3](../Sprawozdanie1/Sprawozdanie1_img/s1_13.png)

**6. Wypchnięcie gałęzi**

![s3](../Sprawozdanie1/Sprawozdanie1_img/s1_12.png)

<br>

## Laboratorium nr 2

**1. Instalacja Dockera**

![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_1.png)

Dodanie użytkownika do grupy (żeby nie musieć urochamiać za pomocą sudo)
<br>
![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_2.png)

Weryfikacja czy docker jest poprwanie zainstalowany i czy działa 
```bash
[wzacharski@vbox MDO2025_INO]$ docker --version
Docker version 27.3.1, build 2.fc41
[wzacharski@vbox MDO2025_INO]$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
e6590344b1a5: Pull complete 
Digest: sha256:bfbb0cc14f13f9ed1ae86abc2b9f11181dc50d779807ed3a3c5e55a6936dbdd5
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

Zalogowanie się do dockera
<br>
<br>
![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_3.png)

**2. Pobieranie obrazów**

Hello-world
<br>
![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_4.png)

busybox
<br>
![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_5.png)

ubuntu
<br>
![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_6.png)

fedora
<br>
![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_7.png)

mysql
<br>
![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_8.png)

**3. Odpalenie busybox**

![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_9.png)

![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_10.png)

Wywołaenie rumeru wersji
<br>
![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_11.png)

**4. Urochomienie obrazu systemu operacyjnego**

Procesy wewnątrz kontenera
<br>
![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_12.png)

Procesy hosta
<br>
![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_13.png)

Aktualizacja pakietów w konenerze
<br>
![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_14.png)


**5. Stworzenie Dockerfile**

Treść Dockerfile
<br>
![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_15.png)


Zbudowanie obrazu
```bash
$ docker build -t fedora_git .
```

![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_16.png)

Urochomienie obrazu w konenerze i sprawdzenie, czy zostało pobrane repozytorium
<br>
![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_17.png)

**6. Działające konenery**

![s1](../Sprawozdanie1/Sprawozdanie2_img/s2_18.png)
<br>
Można również wykorzystać polecenie 
```$ sudo docker ps -a```

## Laboratorium nr 3

**1. Przygotowanie plików, na którym będzie odbywać się praca**

Sklonowanie repozytorium
<br>
![s1](../Sprawozdanie1/Sprawozdanie3_img/s3_1.png)

Zbudowanie projektu
<br>
![s1](../Sprawozdanie1/Sprawozdanie3_img/s3_2.png)

Uruchomienie testów
<br>
![s1](../Sprawozdanie1/Sprawozdanie3_img/s3_3.png)

**2. Zbudwanie programu w kontenerze**

Uruchomienie kontenera
<br>
![s1](../Sprawozdanie1/Sprawozdanie3_img/s3_4.png)

Sklonowanie repozytorium za pomocą HTTPS
<br>
![s1](../Sprawozdanie1/Sprawozdanie3_img/s3_5.png)

Zbudowanie plików
<br>
![s1](../Sprawozdanie1/Sprawozdanie3_img/s3_6.png)

Uruchomienie testów
<br>
![s1](../Sprawozdanie1/Sprawozdanie3_img/s3_7.png)


**3. Utworzenie plików Dockerfile**

Plik Dockerfile_build zawierający i budujący repozytorium
<br>
![s1](../Sprawozdanie1/Sprawozdanie3_img/s3_8.png)

Plik Dockerfile_test uruchuchamiający tesy
<br>
![s1](../Sprawozdanie1/Sprawozdanie3_img/s3_9.png)

Zbudowanie obrazu Dockerfile_build
<br>
![s1](../Sprawozdanie1/Sprawozdanie3_img/s3_10.png)

Zbudowanie obrazu Dockerfile_test
<br>
![s1](../Sprawozdanie1/Sprawozdanie3_img/s3_11.png)

Uruchomienie kontenera zawierającego testy
<br>
![s1](../Sprawozdanie1/Sprawozdanie3_img/s3_12.png)

## Laboratorium nr 4

### Zachowywanie stanu

### Zachowywanie stanu

**1. Przygotowanie woluminu wejściowego i wyjściowego**

![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_1.png)

**2. Uruchomienie kontenera**

![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_2.png)

Zainstalowanie niezbędnych narzędzi w kontenerze (bez gita)
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_3.png)

![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_4.png)

**3. Sklonowanie repozytorium do tymczasowego kontenera i przeniesienie do woluminu wejściowego**

![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_5.png)
<br>
Ze względu na tymczasowe przeznaczenie kontenera i mały rozmiar zadania wykorzystałem obraz alpine.

**4. Zbudowanie projektu w kontenerze**

Skopiowanie plików repozytorium z woluminu wejściowego 
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_6.png)

Zbudowanie projektu wewnątrz kontenera za pomocą make
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_7.png)


**5. Skopiowanie zbudowanych plików do woluminu wyjściowego**

![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_8.png)

**6. Klonowanie repozytorium wewnątrz konenera**

Instalacja gita
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_9.png)

Sklonowanie repozytorium za pomocą HTTPS do woluminu
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_10.png)

### Eksponowanie portu

**1. Uruchomienie serwera wewnątrz kontenera**

Uruchomienie kontenera i pobranie potrzebnych narzędzi
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_11.png)

Efekt uruchomienia kontenera
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_12.png)

**2. Połączenie z innego kontenera**

Uruchomienie kontenera wraz z niezbędnymi zależnościami
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_13.png)

Potwierdzenie połączenia 
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_14.png)

**3. Połączenie za pomocą sieci ```network create```**

Utworzenie sieci
</br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_15.png)

Uruchomienie kontenera serwerowego
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_17.png)

Uruchomienie kontenera służącego do połączenia z serwerem
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_16.png)

**4. Połączenie z hosta**

![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_18.png)
<br>
Wystąpił problem z widocznością portu. Rozwiązaniem było uruchomienie kontenera z widocznym portem
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_19.png)

Wynik połączenia na hoście
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_20.png)

Wynik połączenia w konenerze
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_21.png)

**5. Instalacja Jenkinsa**

Utworzenie sieci
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_22.png)

Uruchomienie kontener DIND (Docker in Docker)
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_27.png)

Makefile z jenkinsem
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_28.png)

Zbudowanie obrazu
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_29.png)

Uruchomienie kontenera
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_30.png)

Dodanie portu do NAT w VirtualBox
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_25.png)

Strona logowania
<br>
![s1](../Sprawozdanie1/Sprawozdanie4_img/s4_26.png)