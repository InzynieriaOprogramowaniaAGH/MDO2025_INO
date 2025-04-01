
### Autor: Kamil Wielgomas, 414502, gr. 8
### Lab1


#### Wykonanie:
1. Sprawdziłem, czy `git` oraz klient `ssh` został pomyślnie zainstalowany razem z obrazem Fedora Server
![](lab1/1.png)
a następnie połączyłem się z maszyną wirtualną za pomocą klienta ssh na komputerze osobistym.
![](lab1/1_b.png)
I sklonowalem repozytorium za pomocą https i tokenu
![](lab1/2.png)


2. Stworzyłem klucz ssh za pomocą komendy `ssh-keygen -t ed25519`, a następnie dodałem go jako metodę dostępu do swojego githuba i sklonowałem repozytorium przez ssh
![](lab1/3.png)
3. Przełączyłem się na gałąź main, a następnie na gałąź GCL08 i sttworzyłem gałąź o nazwie `KW414502`
![](lab1/4.png)
4. Stworzyłem katalog o nazwie `KW414502` w `ITE/GCL08` i napisałem git hooka, który sprawdza, czy commit zaczyna się od `KW414502`
```bash
MSG=$1
if ! grep -qE "^KW414502" "$MSG";then
    cat "$MSG"
    echo "Commit musi sie zaczynac od KW414502"
    exit 1
fi
```
Żeby hook zaczął działac dałem mu uprawnienia do wykonywania poprzez `chmod +x`
![](lab1/5.png)


### Lab2


#### Wykonanie:
1. Pobrałem obrazy `hello-world`, `busybox` i `ubuntu` z docker huba za pomocą komendy `docker pull {nazwa_obrazu}`
![pobranie busybox](lab2/1.png)

2. Uruchomiłem kontener `busybox` bez dodatkowych argumentów, co poskutkowało natychmiastowym zamknięciem kontenera
![busybox fail](lab2/2.png)
Następnie połączyłem się w trybie interaktywnym i wywołałem numer wersji komendą `uname -a`
![busybox interactive version](lab2/2_b.png)

3. Uruchomiłem kontener `ubuntu` w trybie interaktywnym i:
- zaprezentowałem procesy poprzez `ps aux`
- zaktualizowałem pakiety przez `apt update`
![](lab2/3.png)

4. Stowrzyłem Dockerfile o następującej treści:
```docker
FROM ubuntu:latest

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
Zbudowałem obraz za pomocą `docker build --no-cache -t lab2:1.0 .`
I zweryfikowałem jego działanie przez `docker run -it lab2:1.0`

![](lab2/4.png)
5. Przy użyciu `docker ps -a` sprawdziłem, czy istnieją nieużywane kontenery
![](lab2/5.png)
I wyczyściłem wszystko używając `docker system prune`
![](lab2/6.png)

### Lab 3

1. Uruchomiłem kontener fedora:42, sklonowałem repozytorium irssi i zainstalowałem potrzebne pakiety do zbudowania aplikacji:
- git 
- meson 
- ninja 
- gcc 
- glib2-devel 
- openssl-devel 
- utf8proc-devel 
- ncurses-devel
- perl

Po zainstalowaniu pakietów zbudowałem irssi komendami `meson Build` oraz `ninja -C Build`, a następnie uruchomiłem testy poprzez `ninja -C Build test`
![](lab3/1.png)

2. W celu automatyzacji procesu stworzyłem Dockerfile, który wykonunje wszystko aż do zbudowaina irssi:
```
FROM fedora:42
RUN dnf install -y git \
    meson \
    ninja \
    gcc \
    glib2-devel \
    openssl-devel \
    utf8proc-devel \
    ncurses-devel \
    perl
RUN git clone https://github.com/irssi/irssi
WORKDIR /irssi
RUN meson Build
RUN ninja -C Build
```
oraz osobny Dockerfile, który uruchamia testy:
```
FROM irssibld
RUN ninja -C Build test
```

3. Uruchomienie kontenerów
![](lab3/2.png)
![](lab3/2b.png)

### Lab 4
