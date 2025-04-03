# Sprawozdanie 1
## Zajęcia 1
### Przedmowa
Na pierwszych dwóch zajęciach niestety z mojej niewiedzy korzystałem z super user'a zamiast user'a. Na drugich zajęciach zapytałem prowadzącego o bład w commicie i przy okazji naprawę mojego błędu (przerpaszam za bycie debilem : D ).
### Zainstalowany został system fedora serwer, wygenerowany został klucz SSH przy uzyciu systemu ed25519
![alt text](r1/Lab1/SSHKEYGEN.png)
### Klucz ten został podpiety pod konto github, aby móc zdalnie łączyć się repozytorium na githubie
![alt text](r1/Lab1/SSHGITHUB.png)

### Następnie sklonowano repozytorium podanego przez prowadzacego
![alt text](r1/Lab1/GITCLONESSH.png)

### Dodanie git hooka, który sprawdze prefix commita (inicjały oraz numer albumy)
![alt text](r1/Lab1/CREATEGITHOOK.png)
![alt text](r1/Lab1/GITHOOK.png)
### Nadanie uprawnień dla pliku commit-msg
![alt text](r1/Lab1/GITHOOK_x.png)
### Sprawdzenie testowego commita
![alt text](r1/Lab1/COMMIT.png)

## Zajęcia 2
### Przed zajęciami
Instalacja oraz rejestracja na dockerhubie.

### Pobranie obrazów: hello-world, busybox, fedora, mysql
![alt text](r1/Lab2/3.png)

### Uruchomienie busybox
![alt text](r1/Lab2/4.1.png)

### Interaktywne uruchomienie busybox'a i wywołanie numeru wersji
![alt text](r1/Lab2/4.2.png)
![alt text](r1/Lab2/5.png)

### Stworzenie [Dockerfile](docker/Dockerfile), który klonuje nasze repo
![alt text](r1/Lab2/6.png)

### Budowanie obrazu, uruchomienie kontenera, wyświetlenie 
![alt text](r1/Lab2/7.png)

### Wyczyszczenie obrazów
![alt text](r1/Lab2/8.png)

## Zajęcia 3
Do zajęć wykorzystano repozytorium zaproponowane przez prowadzącego: irssi oraz nodejsdummy

### Sklonowanie repozytorium z node'm oraz uruchomienie testu
![alt text](r1/lab3/zlab/1.png)

### Powtórzenie ww. kroków na kontenerze
[docker do budowania](docker/Dockerfile.nodebld) \
[docker do testów](docker/Dockerfile.nodetest) 
![alt text](r1/lab3/zlab/2.png)
![alt text](r1/lab3/zlab/2.1.png)

### Zrobienie tego samego z irssi
[docker do budowania](docker/Dockerfile.irssbld) \
[docker do testów](docker/Dockerfile.irssitest)
![alt text](r1/lab3/zlab/3.png)
![alt text](r1/lab3/zlab/3.1.png)
![alt text](r1/lab3/zlab/3.2.png)

## Zajęcia 4
### Tworzenie woluminów
![alt text](r1/lab4/2.png)

### [Dockerfile](docker/Dockerfile.base) dla kontenera
### Uruchomienie kontenera ze zrobienionym bind mount'em z lokalnym katalogiem, a następnie uruchomienie aplikacji noda
![alt text](r1/lab4/3.png)

### Uruchomienie serwera iperf (iperf3)
![alt text](r1/lab4/5.png)

### network create
Stworzenie nowej sieci mostkowej
![alt text](r1/lab4/6.png)

### Przepustowość komunikacji
odwołanie za pomocą IP
![alt text](r1/lab4/7.2.png)
Za pomocą nazwy
![alt text](r1/lab4/7.1.png)

### Wyciągnięcie logów
![alt text](r1/lab4/8.png)

### Instalacja Jenkins 
* bez DIND, bo nie umiem czytać, a na następnych zajęciach dowiedziałem się po co on jest : D *

![alt text](r1/lab4/9.png)
![alt text](r1/lab4/10.png)
![alt text](r1/lab4/10.1.png)
![alt text](r1/lab4/10.2.png)
Instalacja pakietów
![alt text](r1/lab4/10.3.png)
Po zalogowaniu
![alt text](r1/lab4/10.4.png)

## Wnoski i dyskusja
