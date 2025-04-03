# Sprawozdanie 1
## Zajęcia 1
### Przedmowa
Na pierwszych dwóch zajęciach niestety z mojej niewiedzy korzystałem z super user'a zamiast user'a. Na drugich zajęciach zapytałem prowadzącego o bład w commicie i przy okazji naprawę mojego błędu (przepraszam za bycie debilem).
### Zainstalowany został system fedora serwer, wygenerowany został klucz SSH przy uzyciu systemu ed25519
![alt text](images/Lab1/SSHKEYGEN.png)
### Klucz ten został podpiety pod konto github, aby móc zdalnie łączyć się repozytorium na githubie
![alt text](images/Lab1/SSHGITHUB.png)

### Następnie sklonowano repozytorium podanego przez prowadzacego
![alt text](images/Lab1/GITCLONESSH.png)

### Dodanie git hooka, który sprawdze prefix commita (inicjały oraz numer albumy)
![alt text](images/Lab1/CREATEGITHOOK.png)
![alt text](images/Lab1/GITHOOK.png)
### Nadanie uprawnień dla pliku commit-msg
![alt text](images/Lab1/GITHOOK_x.png)
### Sprawdzenie testowego commita
![alt text](images/Lab1/COMMIT.png)

## Zajęcia 2
### Przed zajęciami
Instalacja oraz rejestracja na dockerhubie.

### Pobranie obrazów: hello-world, busybox, fedora, mysql
![alt text](images/Lab2/3.png)

### Uruchomienie busybox
![alt text](images/Lab2/4.1.png)

### Interaktywne uruchomienie busybox'a i wywołanie numeru wersji
![alt text](images/Lab2/4.2.png)
![alt text](images/Lab2/5.png)

### Stworzenie [Dockerfile](docker/Dockerfile), który klonuje nasze repo
![alt text](images/Lab2/6.png)

### Budowanie obrazu, uruchomienie kontenera, wyświetlenie 
![alt text](images/Lab2/7.png)

### Wyczyszczenie obrazów
![alt text](images/Lab2/8.png)

## Zajęcia 3
Do zajęć wykorzystano repozytorium zaproponowane przez prowadzącego: irssi oraz nodejsdummy

### Sklonowanie repozytorium z node'm oraz uruchomienie testu
![alt text](images/lab3/zlab/1.png)

### Powtórzenie ww. kroków na kontenerze
[docker do budowania](docker/Dockerfile.nodebld) \
[docker do testów](docker/Dockerfile.nodetest) 
![alt text](images/lab3/zlab/2.png)
![alt text](images/lab3/zlab/2.1.png)

### Zrobienie tego samego z irssi
[docker do budowania](docker/Dockerfile.irssbld) \
[docker do testów](docker/Dockerfile.irssitest)
![alt text](images/lab3/zlab/3.png)
![alt text](images/lab3/zlab/3.1.png)
![alt text](images/lab3/zlab/3.2.png)

## Zajęcia 4
### Tworzenie woluminów
![alt text](images/lab4/2.png)

### [Dockerfile](docker/Dockerfile.base) dla kontenera
### Uruchomienie kontenera ze zrobienionym bind mount'em z lokalnym katalogiem, a następnie uruchomienie aplikacji noda
![alt text](images/lab4/3.png)

### Uruchomienie serwera iperf (iperf3)
![alt text](images/lab4/5.png)

### network create
Stworzenie nowej sieci mostkowej
![alt text](images/lab4/6.png)

### Przepustowość komunikacji
odwołanie za pomocą IP
![alt text](images/lab4/7.2.png)
Za pomocą nazwy
![alt text](images/lab4/7.1.png)

### Wyciągnięcie logów
![alt text](images/lab4/8.png)

### Instalacja Jenkins 
* bez DIND, bo nie umiem czytać, a na następnych zajęciach dowiedziałem się po co on jest : D *

![alt text](images/lab4/9.png)
![alt text](images/lab4/10.png)
![alt text](images/lab4/10.1.png)
![alt text](images/lab4/10.2.png)
Instalacja pakietów
![alt text](images/lab4/10.3.png)
Po zalogowaniu
![alt text](images/lab4/10.4.png)

## Wnioski i dyskusja
### Z zajęć 3
* Konteneryzacja oferuje istotne zalety w postaci spójnego środowiska wykonawczego i łatwości wdrażania co likwiduje problemu z kompatybilnościami, jednak wiąże się z większym rozmiarem dystrybucji i potencjalnymi problemami bezpieczeństwa.
* Buildowanie natomiast ma mniejszy rozmiar spowodawany tylko kodem wykonawczym. Posiada lepsze dopasowanie do specyficznych środowisk jak i łatwiejszą interacje z istniejącymi systemami. Jednak moze wywoływać potencjalne konflikty z innymi zainstalowanymi komponentami oraz wymagać dodatkowej konfiguracji przez użytkownika końcowego.
* Program nadaje się do publikowania jako kontener, jeśli: jest złożoną aplikacją z wieloma zależnościami,
ma być uruchamiany w różnych środowiskach i
użytkownik końcowy oczekuje prostego wdrożenia "click-and-run". \
Natomiast dystrybucja jako artefakt jest bardziej odpowiednia gdy: program jest biblioteką lub komponentem integrowanym z innymi systemami,
docelowe środowisko jest ściśle kontrolowane oraz
istotna jest optymalizacja rozmiaru dystrybucji
### Z zajęć 4
Usługi w rozumieniu systemu, kontenera i klastra
* Implementacja usługi SSHD w kontenerze umożliwia zdalny dostęp do środowiska kontenera. Po odpowiedniej konfiguracji w Dockerfile i ekspozycji portu, można uzyskać dostęp do kontenera podobnie jak do zwykłego serwera. \
Zalety tego rozwiązania: bezpośredni do powłoki i systemu plików, łatwy transfer plików, szyfrowana komunikacja, możliwość interaktywnej diagnostyki i debugowania. \
Wady: zwiększenie powierzchni ataku, komplikacje z zarządzaniem kluczami SSH, dodatkowe zuzycie zasobów, sprzeczne z filozowią orkiestracji kontenerów \
Alternatywne podejścia, takie jak docker exec czy narzędzia specyficzne dla klastrów, są zazwyczaj bardziej zgodne z paradygmatem konteneryzacji.

## LLM Uzywanie sztucznej inteligencji:

* Trobleshooting - który skutkowal stratą czasu poniewaz chat mało potrafi, a zapytanie prowadzącego zawsze powodowało szybsze i poprawaniejsze rozwiązanie mojego problemu. 
* Wytłumaczenie teoretecznej wiedzy z danego tematu:
> Prompt: Wytłumacz mi co to / po co / dlaczego 

* Jednakze potem (czwarte zajęcia) odkryłem ładnie napisaną dokumentacje i uwierzyłem w nią, co poprawiło szybkość zdobywania wiedzy. 


