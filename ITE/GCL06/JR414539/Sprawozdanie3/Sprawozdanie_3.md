# Sprawozdanie 3 - Poznawanie Ansible, kickstart, ...

---

# **Cel** 

---

**Celem ćwiczeń było nauczenie się podstaw ansible, kickstart, ....**

---

# **Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible** 

---

## **Instalacja zarządcy Ansible**

Na początku utworzyłem drugą maszynę wirtualną z takim samym systemem jak maszyna głowna(UbuntuServer):
  - Zapewniłem obecność programu tar oraz serwera OpenSSH(podczas instalacji)
  - Nadałem maszynie hostname ansible-target(podczas instalacji)
  - Utworzyłem uzytkownika ansible(podczas instalacji)
  - Zrobiłem migawkę maszyny po instalacji

![Zrzut ekranu – 1 - migawka](zrzuty_ekranu_sprawozdanie_3/1.png)

Na głównej maszynie wirtualnej(UbuntuServer) zainstalowałem oprogramowanie Ansible

![Zrzut ekranu – 2 - ansible i openssh check](zrzuty_ekranu_sprawozdanie_3/2.png)

Wymieniłem klucze SSH między użytkownikiem w głównej maszynie wirtualnej, a użytkownikiem ansible z nowej tak, by logowanie ssh ansible@ansible-target nie wymagało podania hasła.

Żeby to zrobić, najpierw użyłem komendy:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ansible -C" "ansible" -N ""
```
by wygenerować klucz ssh o id_ansible oraz bez proszenia o passphrase.

Następnie użyłem poniższej komendy:

```bash
ssh-copy-id -i ~/.ssh/id_ansible.pub ansible@ansible-target 
```

![Zrzut ekranu – 3 - ansible i openssh check](zrzuty_ekranu_sprawozdanie_3/3.png)

by skopiować ten klucz na maszynę drugą (ansible-target)

Dla pewności jeszcze ustawiłem poprawne nazwy hostów na obu maszynach za pomocą komendy:

```bash
sudo hostnamectl set-hostname kuba123/ansible-target
```
![Zrzut ekranu – 4 - ansible i openssh check](zrzuty_ekranu_sprawozdanie_3/4.png)

Połączenie ssh przebiegło pomyślnie

![Zrzut ekranu – 5 - ansible i openssh check](zrzuty_ekranu_sprawozdanie_3/5.png)

## **Inwentaryzacja**

Dokonałem inwentaryzacji systemów:
  - Ustaliłem przewidywalne nazwy komputerów (maszyn wirtualnych) stosując hostnamectl(pokazałem wcześniej).
  - Wprowadziłem nazwy DNS dla maszyn wirtualnych, edytując /etc/hosts - tak, aby możliwe było wywoływanie komputerów za pomocą nazw, a nie tylko adresów IP. Plik /etc/hosts:
    
![Zrzut ekranu – 6 - ](zrzuty_ekranu_sprawozdanie_3/6.png)

  - Zweryfikowałem łączność za pomocą komend:
```bash
ping ansible-target
```
```bash
ping kuba123
```

![Zrzut ekranu – 7 - ](zrzuty_ekranu_sprawozdanie_3/7.png)

  - Stworzyłem plik inwenatryzacji
  - W sekcjach Orchestrators oraz Endpoints umieściłem nazwy moich maszyn wirtualnych w odpowiednich miejscach

![Zrzut ekranu – 8 - ](zrzuty_ekranu_sprawozdanie_3/8.png)

  - Użyłem dwóch maszyn wirtualnych
  - Upewniłem się, że łączność SSH między maszynami jest możliwa i nie potrzebuje haseł

![Zrzut ekranu – 9 - ](zrzuty_ekranu_sprawozdanie_3/9.png)

![Zrzut ekranu – 10 - ](zrzuty_ekranu_sprawozdanie_3/10.png)

  - Edytowałme jeszcze plik /home/ansible/.ssh/config

![Zrzut ekranu – 11 - ](zrzuty_ekranu_sprawozdanie_3/11.png)

  - Wysłałem żądanie ping do wszystkich maszyn

![Zrzut ekranu – 12 - ](zrzuty_ekranu_sprawozdanie_3/12.png)

## **Zdalne wywoływanie procedur**

Za pomocą playbooka Ansible:
  - Wysłałem żądanie ping do wszystkich maszyn

![Zrzut ekranu – 13 - ](zrzuty_ekranu_sprawozdanie_3/13.png)

  - Skopiowałem plik inwentaryzacji na maszynę Endpoints za pomocą komendy:

```bash
ansible -i inventory.ini ansible-target -m copy -a "src=inventory.ini dest=/home/ansible/inventory.ini"
```
![Zrzut ekranu – 14 - ](zrzuty_ekranu_sprawozdanie_3/14.png)

Następnie stworzyłem plik ping.yml, aby:
  - Zaktualizować pakiety w systemie
  - Zrestartować usługi  sshd i rngd

Ale najpierw zauważyłem, że nie mam usługi rngd na maszynie ansible-target. Zatem zainstalowałem ją i sprawdziłem jak się nazywa, żeby dobrą nazwę wpisać w pliku ping.yml

![Zrzut ekranu – 15 - ](zrzuty_ekranu_sprawozdanie_3/15.png)

![Zrzut ekranu – 16 - ](zrzuty_ekranu_sprawozdanie_3/16.png)

Plik ping.yml

![Zrzut ekranu – 17 - ](zrzuty_ekranu_sprawozdanie_3/17.png)
![Zrzut ekranu – 18 - ](zrzuty_ekranu_sprawozdanie_3/18.png)

Efekt po wykonaniu komendy:

```bash
ansible-playbook -i inventory.ini ping.yml
```
![Zrzut ekranu – 19 - ](zrzuty_ekranu_sprawozdanie_3/19.png)

Przeprowadziłem 2 testy względem maszyny:
  - z wyłączonym serwerem SSH

![Zrzut ekranu – 20 - ](zrzuty_ekranu_sprawozdanie_3/20.png)
![Zrzut ekranu – 21 - ](zrzuty_ekranu_sprawozdanie_3/21.png)
    
  - z odpiętą kartą sieciową

![Zrzut ekranu – 22 - ](zrzuty_ekranu_sprawozdanie_3/22.png)
![Zrzut ekranu – 23 - ](zrzuty_ekranu_sprawozdanie_3/23.png)

## **Zarządzanie stworzonym artefaktem**

Moim artefaktem z pipeline'u był plik binarny (wget.deb), zatem:
  - Pobrałem plik aplikacji na zdalną maszynę z dysku google za pomocą komendy:

```bash
wget --no-check-certificate "LINK DO DYSKU" -O wget.deb
```

![Zrzut ekranu – 24 - ](zrzuty_ekranu_sprawozdanie_3/24.png)

  - Stworzyłem kontener run_container.yml oraz Dockerfile przeznaczony do uruchomienia aplikacji
  - run_container.yml:

![Zrzut ekranu – 25 - ](zrzuty_ekranu_sprawozdanie_3/25.png)

  - Dockerfile:

![Zrzut ekranu – 26 - ](zrzuty_ekranu_sprawozdanie_3/26.png)
    
Niestety nie udało mi się do końca uruchomić tej aplikajci. Próbowałem na różne sposoby, z błedu wynika że po prostu nie zdajduje pliku wget.deb. Jednak run_container.yml, Dockerfile i wget.deb są w tym samym katalogu, więc nie ma to sensu. Pomyślałem, że może ten wget.deb jest jakiś stary, ale nawet jak pobrałem nową wersję wgeta to i tak był ten błąd. Ostatniego taska nie może zrobić: 

![Zrzut ekranu – 27 - ](zrzuty_ekranu_sprawozdanie_3/27.png)

Oczywiście zainstalowałem zależnosci, Pythona, dockera itd.

![Zrzut ekranu – 28 - ](zrzuty_ekranu_sprawozdanie_3/28.png)

![Zrzut ekranu – 29 - ](zrzuty_ekranu_sprawozdanie_3/29.png)

![Zrzut ekranu – 30 - ](zrzuty_ekranu_sprawozdanie_3/30.png)

![Zrzut ekranu – 31 - ](zrzuty_ekranu_sprawozdanie_3/31.png)

Jak stworzyłem obraz testwget to wget działa:

![Zrzut ekranu – 32 - ](zrzuty_ekranu_sprawozdanie_3/32.png)

![Zrzut ekranu – 33 - ](zrzuty_ekranu_sprawozdanie_3/33.png)

# **Pliki odpowiedzi dla wdrożeń nienadzorowanych** 

# **Cel** 

**Celem ćwiczenia było utworzenie źródła instalacji nienadzorowanej dla systemu operacyjnego hostującego nasze oprogramowanie oraz przeprowadzenie instalacji systemu, który po uruchomieniu rozpocznie hostowanie naszego programu**

## **Przygotowanie środowiska**

Z racji tego, że uzywałem wcześniej ubuntu, to musiłem zainstalować nową maszynę wirtualna Fedora. Użyłem obrazu: **Fedora-Server-netinst-x86_64-40-1.14.iso**

## **Pobranie pliku odpowiedzi (anaconda-ks.cfg)**

Z poprzedniej instalacji Fedory pobrałem plik /root/anaconda-ks.cfg za pomocą serwera HTTP:

```bash
python3 -m http.server 8000
```

Na hoście Windows uzyskałem dostęp do pliku przez:

```bash
http://192.168.56.1:8000/anaconda-ks.cfg
```

![Zrzut ekranu – 38 - ](zrzuty_ekranu_sprawozdanie_3/38.png)

## **Modyfikacja pliku Kickstart**

W pliku anaconda-ks.cfg wprowadziłem następujące zmiany:
  - Dodanie repozytoriów:
    ```bash
    url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-40&arch=x86_64
    ```
     ```bash
    repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f40&arch=x86_64
     ```
  - Wymuszenie czyszczenia dysku:
    ```bash
    clearpart --all --initlabel
    ```
  - Nadanie hostowi nazwy:
    ```bash
    network --hostname=fedora-unattended
    ```
  - Dodanie wymaganych pakietów:
    ```bash
    %packages
    @^server-product-environment
    @core
    wget
    tar
    zstd
    %end
    ```
    
## **Konfiguracja działania aplikacji w %post**

Dodałem do sekcji %post polecenia umożliwiające:
  - Pobranie programu (plik wget.deb lub gotowy wget)
  - Rozpakowanie i przeniesienie do /usr/local/bin/
  - Stworzenie usługi systemd uruchamiającej program
  - Automatyczne jej włączenie po starcie systemu

Moja sekcja %post:
```bash
%post --log=/root/post-install.log
set -e

mkdir -p /opt/myapp
cd /opt/myapp

# Pobranie .deb
wget --timeout=10 --tries=2 http://192.168.56.1:8000/wget.deb -O wget.deb

ar x wget.deb
tar -xf data.tar.* || echo "Nie udalo sie rozpakowac data.tar"

# Szukamy binarki i kopiujemy
find . -type f -name 'wget' -executable -exec cp {} /usr/local/bin/myapp \;
chmod +x /usr/local/bin/myapp

cat <<EOF > /etc/systemd/system/myapp.service
[Unit]
Description=My custom app
After=network.target

[Service]
ExecStart=/usr/local/bin/myapp --version
Type=oneshot
RemainAfterExit=yes
Restart=no

[Install]
WantedBy=multi-user.target
EOF

systemctl enable myapp
%end
```

## **Uruchomienie instalacji nienadzorowanej**

- Uruchomiłem nową maszynę wirtualną i wystartowałem instalator Fedora z ISO
- W menu GRUB edytowałem wpis Install Fedora (kliknąłem e) i na końcu linii linux dodałem:
  ```bash
  inst.ks=http://192.168.56.1:8000/anaconda-ks.cfg
  ```
- Instalacja rozpoczęła się automatycznie i przebiegła bez ingerencji

![Zrzut ekranu – 35 - ](zrzuty_ekranu_sprawozdanie_3/35.png)

![Zrzut ekranu – 36 - ](zrzuty_ekranu_sprawozdanie_3/36.png)

![Zrzut ekranu – 37 - ](zrzuty_ekranu_sprawozdanie_3/37.png)

## ** Weryfikacja po instalacji**

Po zainstalowaniu i restarcie:
  - Zalogowałem się na użytkownika kickstart
  - Sprawdziłem działanie usługi:
  ```bash
  systemctl status myapp
  ```
  ```bash
  journalctl -u myapp
  ```
  - Automatyczne Zweryfikowanie aplikacji:
  ```bash
  /usr/local/bin/myapp --version
  ```

Aplikacja uruchomiła się poprawnie, zakończyła działanie z kodem 0/SUCCESS, a systemctl wskazuje active (exited):

![Zrzut ekranu – 38 - ](zrzuty_ekranu_sprawozdanie_3/38.png)

![Zrzut ekranu – 39 - ](zrzuty_ekranu_sprawozdanie_3/39.png)

Zadanie zostało zrealizowane zgodnie z wytycznymi. System Fedora został zainstalowany nienadzorowanie, aplikacja została uruchomiona jako usługa systemd, a cały proces przebiegł automatycznie – bez ręcznej ingerencji po starcie maszyny.

Cały plik anaconda-ks.cfg:
  ```bash
  # Generated by Anaconda 40.22.3
# Generated by pykickstart v3.52
#version=DEVEL
# Use graphical install
graphical

url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-40&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f40&arch=x86_64

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

%packages
@^server-product-environment
@core
wget
tar
zstd
%end

%post --log=/root/post-install.log
set -e

mkdir -p /opt/myapp
cd /opt/myapp

# Pobranie .deb
wget --timeout=10 --tries=2 http://192.168.56.1:8000/wget.deb -O wget.deb

ar x wget.deb
tar -xf data.tar.* || echo "Nie udalo sie rozpakowac data.tar"

# Szukamy binarki i kopiujemy
find . -type f -name 'wget' -executable -exec cp {} /usr/local/bin/myapp \;
chmod +x /usr/local/bin/myapp

cat <<EOF > /etc/systemd/system/myapp.service
[Unit]
Description=My custom app
After=network.target

[Service]
ExecStart=/usr/local/bin/myapp --version
Type=oneshot
RemainAfterExit=yes
Restart=no

[Install]
WantedBy=multi-user.target
EOF

systemctl enable myapp
%end

firstboot --enable

# Generated using Blivet version 3.9.1
ignoredisk --only-use=sda
autopart
# Partition clearing information
clearpart --all --initlabel

network --hostname=fedora-unattended

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --iscrypted $y$j9T$3ENGnB/ZtJrLAAHSCVo5iwlq$46iVnSs2dbU992wgrqk.BnJ/0Mgn5xKW0T0g7n0HoU3
user --groups=wheel --name=kickstart --password=$y$j9T$mCl6BCUxsWaW16WGxUxp8ukI$F8gsIf.mo3rFdOn4lZZiuHmPvZbz/tJL3ztg6uG2B41 --iscrypted --gecos="Kickstart"

reboot
  ```
