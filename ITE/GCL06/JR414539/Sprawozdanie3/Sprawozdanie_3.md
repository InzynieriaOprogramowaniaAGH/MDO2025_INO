# Sprawozdanie 3 - Poznawanie Ansible, kickstart oraz kubernetes

---

# **Cel** 

---

**Celem ćwiczeń było nauczenie się podstaw ansible, kickstart oraz kubernetes**

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
  - Wprowadziłem nazwy DNS dla maszyn wirtualnych, edytując /etc/hosts - tak, aby możliwe było wywoływanie komputerów za pomocą nazw, a nie tylko adresów IP.
  - Plik /etc/hosts:
    
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

Plik inventory.ini:

```bash
[Orchestrators]
kuba123 ansible_host=kuba123 ansible_user=kuba123 ansible_ssh_private_key_file=~/.ssh/id_ansible

[Endpoints]
ansible-target ansible_host=ansible-target ansible_user=ansible ansible_ssh_private_key_file=~/.ssh/id_ansible
```

Plik ping.yml

```bash
- name: Ping all endpoints
  hosts: Endpoints
  tasks:
    - name: Ping
      ansible.builtin.ping:

- name: Update all packages
  hosts: Endpoints
  become: yes
  tasks:
    - name: Apt update
      ansible.builtin.apt:
        update_cache: yes
        upgrade: dist

- name: Restart services
  hosts: Endpoints
  become: yes
  tasks:
    - name: Restart sshd
      ansible.builtin.service:
        name: ssh
        state: restarted

    - name: Restart rng-tools-debian
      ansible.builtin.service:
        name: rng-tools-debian
        state: restarted

- name: Copy inventory to endpoint
  hosts: Endpoints
  become: yes
  tasks:

- name: Ensure /home/ansible directory exists
  ansible.builtin.file:
    path: /home/ansible
    state: directory
    owner: ansible
    group: ansible
    mode: '0755'

- name: Copy inventory
  ansible.builtin.copy:
    src: ./inventory.ini
    dest: /home/ansible/inventory.ini
    owner: ansible
    group: ansible
    mode: '0644'
```

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

```bash
- name: Build and run container with wget.deb
  hosts: Endpoints
  become: yes
  tasks:
    - name: Copy Dockerfile and wget.deb to target
      ansible.builtin.copy:
        src: "Dockerfile"
        dest: /opt/docker/Dockerfile
        mode: '0644'
      with_items:
        - ../wget.deb
        - Dockerfile

    - name: Install Docker SDK for Python
      ansible.builtin.pip:
        name: docker
        executable: pip3

    - name: Build docker image
      community.docker.docker_image:
        name: custom_wget
        tag: latest
        build:
          path: /opt/docker
          source: build

    - name: Run wget container
      community.docker.docker_container:
        name: wget_test
        image: custom_wget:latest
        state: started
        recreate: true
        pull: false
```

  - Dockerfile:

```bash
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y gdebi-core
COPY wget.deb /tmp/wget.deb
RUN gdebi -n /tmp/wget.deb || apt-get install -f -y
CMD ["wget", "--version"]
```
    
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

# **Wdrażanie na zarządzalne kontenery: Kubernetes (1)** 

## **Instalacja klastra Kubernetes**

Proces rozpocząłem od pobrania i instalacji narzędzia Minikube, które umożliwia uruchomienie lokalnego klastra Kubernetes na moim systemie Ubuntu w architekturze amd64. Do pobrania instalatora wykorzystałem polecenie:

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
```

a następnie zainstalowałem pakiet za pomocą:

```bash
sudo dpkg -i minikube_latest_amd64.deb
```

![Zrzut ekranu – 40 - ](zrzuty_ekranu_sprawozdanie_3/40.png)

Po instalacji Minikube konieczne było uruchomienie usługi Docker, która pełni funkcję backendu kontenerowego dla klastra. W tym celu skorzystałem z komendy:

```bash
sudo systemctl start docker
```

Gdy Docker był już aktywny, przystąpiłem do inicjalizacji klastra Kubernetes lokalnie, korzystając z polecenia:

```bash
minikube start
```

![Zrzut ekranu – 41 - ](zrzuty_ekranu_sprawozdanie_3/41.png)

Następnie utworzyłem alias do kubectl, który korzysta bezpośrednio z wersji dostarczanej przez Minikube. Dzięki temu mogłem wydawać polecenia kubectl bez konieczności instalowania go osobno.

```bash
alias kubectl="minikube kubectl --"
```

![Zrzut ekranu – 42 - ](zrzuty_ekranu_sprawozdanie_3/42.png)

Używając komendy:

```bash
minikube kubectl -- get po -A
```

sprawdziłem czy klaster działa poprawnie. Później wpisałem pierwszy raz polecenie:

```bash
minikube dashboard
```
które uruchomiło graficzny interfejs Kubernetes Dashboard, co umożliwiło wizualne zarządzanie klastrem i podgląd zasobów (pody, deploymenty, serwisy itp.).

![Zrzut ekranu – 43 - ](zrzuty_ekranu_sprawozdanie_3/43.png)

## **Analiza posiadanego kontenera oraz Uruchamianie oprogramowania**

Uruchomiłem pojedynczy pod z obrazem nginx, aby przetestować wdrożenie prostego kontenera bez użycia pliku YAML:

```bash
minikube kubectl -- run podnginx --image=nginx --port=80 --labels app=podnginx
```

Na tym screenie jeszcze widać, że sprawdziłem czy wdrożenie aplikacji zakończyło się sukcesem i wszystkie repliki zostały uruchomione poprawnie co jest późiejszym krokiem za pomocą polecenia:

```bash
kubectl rollout status deployment/moja-aplikacja
```

Sprawdziłem także czy pody działają poprawnie:

```bash
kubectl get pods
```

Aby połączyć się z aplikacją przez przeglądarkę na localhost:8083, użyłem poniższej komendy:

```bash
kubectl port-forward podnginx 8083:80
```

![Zrzut ekranu – 44 - ](zrzuty_ekranu_sprawozdanie_3/44.png)

![Zrzut ekranu – 45 - ](zrzuty_ekranu_sprawozdanie_3/45.png)

![Zrzut ekranu – 46 - ](zrzuty_ekranu_sprawozdanie_3/46.png)

![Zrzut ekranu – 47 - ](zrzuty_ekranu_sprawozdanie_3/47.png)

## **Przekucie wdrożenia manualnego w plik wdrożenia**

W celu przejścia z jednorazowego uruchomienia poda do bardziej zaawansowanego i skalowalnego wdrożenia, stworzyłem plik deployment.yaml, zawierający konfigurację obiektu typu Deployment z określoną liczbą replik:

- deployment.yaml:

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: moja-aplikacja
spec:
  replicas: 4
  selector:
    matchLabels:
      app: moja-aplikacja
  template:
    metadata:
      labels:
        app: moja-aplikacja
    spec:
      containers:
      - name: moja-aplikacja
        image: moja-aplikacja
        imagePullPolicy: Never
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: moja-aplikacja
spec:
  type: NodePort
  selector:
    app: moja-aplikacja
  ports:
    - port: 80
      targetPort: 80

```

Plik deployment.yaml definiuje zasoby Kubernetes niezbędne do uruchomienia aplikacji jako skalowalnego wdrożenia. Składa się z dwóch części:

- Deployment o nazwie moja-aplikacja uruchamia 4 repliki kontenera zbudowanego lokalnie (imagePullPolicy: Never). Każdy kontener nasłuchuje na porcie 80.

- Service typu NodePort eksponuje aplikację na zewnątrz klastra, umożliwiając dostęp do niej poprzez przypisany port węzła. Serwis kieruje ruch do podów oznaczonych etykietą app: moja-aplikacja.

Ponadto mam jeszcze Dockerfile'a oraz index.html:

- Dockerfile:

```bash
# Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
```

Dockerfile służy do zbudowania własnego obrazu kontenera na bazie nginx, w którym została podmieniona domyślna strona startowa na moją własną — index.html.

- index.html:

```bash
<!-- index.html -->
<!DOCTYPE html>
<html>
<head>
  <title>Moja strona na Nginx w Kubernetesie</title>
</head>
<body>
  <h1>Witaj z kontenera nginx!</h1>
  <h2>To prosty serwer HTML oparty o NGINX, dzialajacy w kontenerze K8s </h2> 
</body>
</html>
```

Index.html to prosta strona internetowa, która pełni rolę widocznej funkcjonalności aplikacji – jest serwowana przez nginx i pozwala potwierdzić, że kontener działa prawidłowo oraz że dostęp przez sieć działa zgodnie z założeniem.

Następnie użyłem polecenia:

```bash
eval $(minikube docker-env)
```

aby przełączyć Dockera na środowisko wewnątrz Minikube, dzięki czemu zbudowany obraz był widoczny dla klastra Kubernetes. 

Później zbudowałem obraz Dockera naszej aplikacji na podstawie Dockerfile'a, który później został użyty w wdrożeniu.

```bash
docker build -t moja-aplikacja .
```

Na samym końcu wykonałem wdrożenie oraz port-forward do serwisu tym razem:

```bash
kubectl apply -f deployment.yaml
```

```bash
kubectl port-forward service/moja-aplikacja 8082:80
```

![Zrzut ekranu – 48 - ](zrzuty_ekranu_sprawozdanie_3/48.png)

![Zrzut ekranu – 49 - ](zrzuty_ekranu_sprawozdanie_3/49.png)

![Zrzut ekranu – 50 - ](zrzuty_ekranu_sprawozdanie_3/50.png)

![Zrzut ekranu – 46 - ](zrzuty_ekranu_sprawozdanie_3/46.png)

![Zrzut ekranu – 52 - ](zrzuty_ekranu_sprawozdanie_3/52.png)

Na koniec mogę jeszcze pokazać wcześniejsze wdrożenie jakie zrobiłem z hello-minikube:

```bash
sudo snap install kubectl --classic
```

```bash
kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
```

```bash
kubectl expose deployment hello-minikube --type=NodePort --port=8080
```

```bash
kubectl get services hello-minikube
```

```bash
minikube service hello-minikube
```

![Zrzut ekranu – 51 - ](zrzuty_ekranu_sprawozdanie_3/51.png)

# **Wdrażanie na zarządzalne kontenery: Kubernetes (2)** 

## **Przygotowanie nowego obrazu**

Na początku utworzyłem trzy osobne wersje obrazu Dockera (v1, v2, v3), każdą z własnym Dockerfile i ewentualnie zmodyfikowanym index.html.
Dla wersji v3 celowo przygotowałem wadliwy obraz (błędny entrypoint), co powoduje błąd RunContainerError przy uruchomieniu(v3 nie ma index.html).
Wszystkie obrazy były budowane lokalnie, wewnątrz środowiska Dockera skonfigurowanego przez Minikube — bez potrzeby korzystania z Docker Huba.

Użyłem poniższych poleceń:

Przełączałem się na lokalne środowisko Dockera działające w Minikube:

```bash
eval $(minikube docker-env)
```
Budowanie działającej wersji (v1)

```bash
docker build -f Dockerfile_aplikacja_dzialajaca -t moja-aplikacja:v1 .
```

Budowanie poprawionej wersji (v2)

```bash
docker build -f Dockerfile_nowa_wersja_z_poprawka -t moja-aplikacja:v2 .
```

Budowanie wadliwej wersji (v3)

```bash
docker build -f Dockerfile_fail -t moja-aplikacja:v3 .
```

![Zrzut ekranu – 53 - ](zrzuty_ekranu_sprawozdanie_3/53.png)

![Zrzut ekranu – 54 - ](zrzuty_ekranu_sprawozdanie_3/54.png)

![Zrzut ekranu – 55 - ](zrzuty_ekranu_sprawozdanie_3/55.png)

Sprawdzenie czy wszystko działa(port-forwarding):

- moja-aplikacja:v1

![Zrzut ekranu – 56 - ](zrzuty_ekranu_sprawozdanie_3/56.png)

![Zrzut ekranu – 57 - ](zrzuty_ekranu_sprawozdanie_3/57.png)

- moja-aplikacja:v2

![Zrzut ekranu – 58 - ](zrzuty_ekranu_sprawozdanie_3/58.png)

![Zrzut ekranu – 59 - ](zrzuty_ekranu_sprawozdanie_3/59.png)

- moja-aplikacja:v3

![Zrzut ekranu – 60 - ](zrzuty_ekranu_sprawozdanie_3/60.png)

![Zrzut ekranu – 61 - ](zrzuty_ekranu_sprawozdanie_3/61.png)

![Zrzut ekranu – 62 - ](zrzuty_ekranu_sprawozdanie_3/62.png)

## **Zmiany w deploymencie**

Edytowałem plik deployment2.yaml, modyfikując wartość replicas: kolejno do 8, 1, 0 i 4 dla poszczególnych wersji: v1, v2, v3 i sprawdzałem czy wszystko działa prawidłowo.
Po każdej zmianie wykonywałem kubectl apply, a następnie kubectl get pods, by obserwować efekty:

```bash
kubectl apply -f deployment2.yaml
```

```bash
kubectl get pods
```

Przeglądałem historię wdrożeń:

```bash
kubectl rollout history deployment moja-aplikacja
```

Cofałem się do poprzedniej wersji za pomocą:

```bash
kubectl rollout undo deployment moja-aplikacja
```

- Wersja moja-aplikacja:v1 (działająca):

  - replicas: 8
 
![Zrzut ekranu – 63 - ](zrzuty_ekranu_sprawozdanie_3/63.png)

  - replicas: 1

![Zrzut ekranu – 64 - ](zrzuty_ekranu_sprawozdanie_3/64.png)

  - replicas: 0

![Zrzut ekranu – 65 - ](zrzuty_ekranu_sprawozdanie_3/65.png)

  - replicas: 4

![Zrzut ekranu – 66 - ](zrzuty_ekranu_sprawozdanie_3/66.png)

- Wersja moja-aplikacja:v2 (alternatywna):

  - replicas: 8
 
![Zrzut ekranu – 67 - ](zrzuty_ekranu_sprawozdanie_3/67.png)

  - replicas: 1

![Zrzut ekranu – 68 - ](zrzuty_ekranu_sprawozdanie_3/68.png)

  - replicas: 0

![Zrzut ekranu – 69 - ](zrzuty_ekranu_sprawozdanie_3/69.png)

  - replicas: 4

![Zrzut ekranu – 70 - ](zrzuty_ekranu_sprawozdanie_3/70.png)

- moja-aplikacja:v3 (wadliwa – celowy błąd):

  - replicas: 8
 
![Zrzut ekranu – 71 - ](zrzuty_ekranu_sprawozdanie_3/71.png)

  - replicas: 1

![Zrzut ekranu – 72 - ](zrzuty_ekranu_sprawozdanie_3/72.png)

  - replicas: 0

![Zrzut ekranu – 73 - ](zrzuty_ekranu_sprawozdanie_3/73.png)

  - replicas: 4

![Zrzut ekranu – 74 - ](zrzuty_ekranu_sprawozdanie_3/74.png)

## **Kontrola wdrożenia**

Przeglądałem listę rewizji Deploymentu moja-aplikacja za pomocą:

```bash
kubectl rollout history deployment moja-aplikacja
```

Komendą z --revision=XX sprawdzałem szczegóły konkretnej wersji:

```bash
kubectl rollout history deployment moja-aplikacja --revision=XX
```

![Zrzut ekranu – 75 - ](zrzuty_ekranu_sprawozdanie_3/75.png)

![Zrzut ekranu – 76 - ](zrzuty_ekranu_sprawozdanie_3/76.png)

Przygotowałem skrypt weryfikujący wdrożenie (do 60 sekund):

- check_deploy.sh:

```bash
#!/bin/bash

DEPLOYMENT="moja-aplikacja"
NAMESPACE="default"
TIMEOUT=60

echo "Czekam aż deployment \"$DEPLOYMENT\" osiągnie pełną gotowość..."

for ((i=1; i<=$TIMEOUT; i++)); do
  READY=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o=jsonpath='{.status.readyReplicas}')
  EXPECTED=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o=jsonpath='{.spec.replicas}')

  if [[ "$READY" == "$EXPECTED" && "$READY" != "" ]]; then
    echo "✔️  Deployment gotowy po $i sekundach."
    exit 0
  fi

  sleep 1
done

echo "❌ Deployment NIE gotowy po $TIMEOUT sekundach."
kubectl get pods -n "$NAMESPACE"
exit 1

```

Skrypt pozwala automatycznie ocenić, czy wdrożenie się powiodło w rozsądnym czasie – co spełnia wymagania zadania.

- Powodzenie:

![Zrzut ekranu – 77 - ](zrzuty_ekranu_sprawozdanie_3/77.png)

- Fail:

![Zrzut ekranu – 78 - ](zrzuty_ekranu_sprawozdanie_3/78.png)

## **Strategie wdrożenia**

Strategia Recreate powoduje, że stare pody są usuwane przed utworzeniem nowych. 

- Plik deployment-recreate.yaml:

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: moja-aplikacja-recreate
spec:
  replicas: 4
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: moja-aplikacja
  template:
    metadata:
      labels:
        app: moja-aplikacja
    spec:
      containers:
      - name: moja-aplikacja
        image: moja-aplikacja:v1
        imagePullPolicy: Never
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: moja-aplikacja
spec:
  type: NodePort
  selector:
    app: moja-aplikacja
  ports:
    - port: 80
      targetPort: 80

```

Komendy do deployu:

```bash
kubectl apply -f deployment-recreate.yaml
```

```bash
kubectl get pods -l app=moja-aplikacja 
```

```bash
kubectl rollout history deployment moja-aplikacja-recreate
```

![Zrzut ekranu – 79 - ](zrzuty_ekranu_sprawozdanie_3/79.png)

Strategia Rolling Update (z maxUnavailable > 1, maxSurge > 20%). Rolling Update aktualizuje pody stopniowo, pozwalając utrzymać usługę online. maxUnavailable: 2 – maks. 2 pody mogą być jednocześnie niedostępne.
maxSurge: 2 – mogą być uruchomione maksymalnie 2 dodatkowe pody. Lepsza dostępność niż w Recreate, choć większe zużycie zasobów.

- Plik deployment-rolling.yaml:

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: moja-aplikacja-rolling
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 30%
  selector:
    matchLabels:
      app: moja-aplikacja
  template:
    metadata:
      labels:
        app: moja-aplikacja
    spec:
      containers:
      - name: moja-aplikacja
        image: moja-aplikacja:v2
        imagePullPolicy: Never
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: moja-aplikacja
spec:
  type: NodePort
  selector:
    app: moja-aplikacja
  ports:
    - port: 80
      targetPort: 80
```

Komendy do deployu:

```bash
kubectl apply -f deployment-rolling.yaml
```

```bash
kubectl get pods -l app=moja-aplikacja
```

```bash
kubectl rollout history deployment moja-aplikacja-rolling deployment.apps/moja-aplikacja-rolling
```

![Zrzut ekranu – 80 - ](zrzuty_ekranu_sprawozdanie_3/80.png)

Strategia Canary Deployment. Wdrożyłem wersję testową (canary) obok wersji stabilnej, obie wersje są obecne w systemie. Możliwość testowania nowych funkcji bez wpływu na wszystkich użytkowników.
Można zastosować oddzielne serwisy (np. canary-service) do ich kierowania.

- Plik deployment-canary.yaml:

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: moja-aplikacja-canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: moja-aplikacja
      version: canary
  template:
    metadata:
      labels:
        app: moja-aplikacja
        version: canary
    spec:
      containers:
      - name: moja-aplikacja
        image: moja-aplikacja:v3
        imagePullPolicy: Never
        ports:
        - containerPort: 80
```

Komendy do deployu:

```bash
kubectl apply -f deployment-canary.yaml
```

```bash
kubectl get pods -l app=moja-aplikacja
```

```bash
kubectl rollout history deployment moja-aplikacja-canary deployment.apps/moja-aplikacja-canary
```

![Zrzut ekranu – 81 - ](zrzuty_ekranu_sprawozdanie_3/81.png)

Wyświetliłem wszystkie wdrożenia za pomocą komendy:

```bash
kubectl get deployments
```

![Zrzut ekranu – 82 - ](zrzuty_ekranu_sprawozdanie_3/82.png)

Wynik wszystkich wdrożeń w dashboardzie:

![Zrzut ekranu – 83 - ](zrzuty_ekranu_sprawozdanie_3/83.png)

W każdym z deploymentów zastosowano etykietę:

```bash
labels:
  app: moja-aplikacja
  version: canary / stable
```

Dzięki temu możliwa jest selekcja konkretnych podów:

```bash
kubectl get pods -l app=moja-aplikacja
```

```bash
kubectl get pods -l version=canary
```

W plikach yaml dodawałem:

```bash
---
apiVersion: v1
kind: Service
metadata:
  name: moja-aplikacja
spec:
  type: NodePort
  selector:
    app: moja-aplikacja
  ports:
    - port: 80
      targetPort: 80
```

Sprawia to, że serwis równoważy ruch między wszystkimi replikami, niezależnie od strategii.
