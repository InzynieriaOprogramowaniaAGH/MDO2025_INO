# Sprawozdanie 3
**Autor:** Paweł Socała  
**System:** Fedora  
**Wirtualizacja** VirtualBox

<br>
<br>

# Lab 8 - Ansible

<br>

## Instalacja zarządcy Ansible


<br>

Na początku utworzono nową maszyne wirtualną na obrazie Fedory. Podczas instalacji utworzono użytkownika o nazwie ansible.

![maszyna](lab_ansible/maszyna.png)

![użytkownik](lab_ansible/user.png)

<br>

---

Po instalacji uruchomiono maszynę dodano nazwę hosta oraz zainstalowano pakiety tar i openSSH. 


```bash
sudo hostnamectl set-hostname ansible-target
exec bash

sudo dnf install tar openssh
```

![tar](lab_ansible/tar.png)

<br>

---

Na końcu dodano migawkę, czyli zapisano obecny stan maszyny.

![migawka](lab_ansible/migawka.png)

<br>

---

W kolejnym etapie zainstalowano Ansible na głównej maszynie.

```bash
sudo dnf install ansible
```

![ansi](lab_ansible/install.png)

<br>

---

Wymiana kluczy:

Na początku wygenerowano klucze ssh na głównej maszynie.

```bash
ssh-keygen -f ~/.ssh/id_rsa_ansible
```

![ansi](lab_ansible/klucz.png)

<br>

Sprawdzono adres ip maszyny Ansible oraz dodano go do pliku `/etc/hosts`.

```bash
ip a
sudo nano /etc/hosts
```

![ansi](lab_ansible/ip_2.png)

![ansi](lab_ansible/etc.png)

<br>

Na końcu wykonano wymianę kluczy za pomocą polecena ssh-copy-id oraz połączono się poprzez ssh bez wpisywania hasła.

```bash
ssh-copy-id -i ~/.ssh/id_rsa_ansible.pub ansible@ansible-target

ssh ansible@ansible-target
```

![ansi](lab_ansible/ssh_copy.png)
![ansi](lab_ansible/połączenie.png)

<br>

## Inwentaryzacja


<br>

Zmiana nazwy głównej maszyny na `fedora-main`.
```bash
sudo hostnamectl set-hostname fedora-main
exec bash
```
![ansi](lab_ansible/nazwa.png)

<br>

Kolejno dodano jeszcze adres maszyny fedora-main do pliku `/etc/hosts`.

![ansi](lab_ansible/etc_3.png)

<br>

---
Utworzenie pliku inwetnaryzacji `inventory.ini`:

```bash
touch inventory.ini
nano inventory.ini
```

![ansi](lab_ansible/inventory.png)

Następnie wysłano ping do wszystkich hostów z pliku inventory.ini za pomocą modułu ping z ansible. Żądanie wyoknało się prawidłowo.

![ansi](lab_ansible/all.png)


<br>

## Zdalne wywoływanie procedur


<br>

Kolejnym etapem było utworzenie pliku `playbook.yml`.

```bash
touch playbook.yml
nano playbook.yml
```

<br>


![ansi](lab_ansible/playbook.png)

<br>

Piewrsze uruchomienie playbooka- błąd przy aktualizacji ponieważ sudo wymaga hasła.

```bash
ansible-playbook -i inventory.ini playbook.yml
```

![ansi](lab_ansible/run.png)

<br>

Drugie uruchomienie - dodano flagę -K, przez którą wpisujemy hasło do hosta na początku wykonania oraz zainstalowano pakiet rng na ansible-target.

```bash
ansible-playbook -i inventory.ini playbook.yml -K
```

![ansi](lab_ansible/drugie1.png)

<br>

Test maszyny z wyłączoną kartą sieciową na maszynie ansible-target. Ansible nie był w stanie nawiązać połączenia.

```bash
sudo systemctl stop sshd
ansible-playbook -i inventory.ini playbook.yml -K

sudo systemctl start sshd # ponowne włączenie sshd na ansible-target
```
![ansi](lab_ansible/stop.png)

![ansi](lab_ansible/stop_ssh.png)



<br>

## Zarządzanie stworzonym artefaktem

<br>

Moja aplikacja to irssi. Artefakt to paczka .deb.

Struktura plików .yml:

```
install_irssi/
├── playbook.yml
└── roles/
    ├── install_docker/
    │   └── tasks/
    │       └── main.yml
    └── install_irssi/
        └── tasks/
            └── main.yml
```

<br>

Install docker `main.yml`:

Ten playbook sprawdza, czy Docker jest zainstalowany na maszynie docelowej, wykonując polecenie which docker. Jeśli Docker nie jest znaleziony (kod wyjścia różny od 0), to instaluje wymagane pakiety dnf-plugins-core i docker za pomocą menedżera pakietów dnf. Następnie niezależnie od tego, czy Docker był wcześniej zainstalowany, upewnia się, że usługa Docker jest uruchomiona i włączona do autostartu. Na koniec wykonuje polecenie docker --version, aby potwierdzić poprawną instalację i działanie Dockera.

```bash
- name: Check if Docker is installed
  command: which docker
  register: docker_check
  ignore_errors: true

- name: Install Docker on Fedora
  block:
    - name: Install required packages
      dnf:
        name:
          - dnf-plugins-core
          - docker
        state: present
        update_cache: true
  when: docker_check.rc != 0

- name: Ensure Docker service is started and enabled
  service:
    name: docker
    state: started
    enabled: true

- name: Verify Docker installation
  command: docker --version

```

<br>

Install irssi `main.yml`:

Ten playbook kopiuje pakiet irssi na maszynę zdalną, usuwa istniejący kontener o nazwie irssi-cont, a następnie tworzy nowy kontener z obrazem Ubuntu, w którym instaluje aplikację z przesłanego pakietu .deb. Po instalacji sprawdza, czy program działa poprawnie, wywołując jego wersję. Dzięki temu irssi jest uruchomione w środowisku kontenera Docker.

```bash
- name: Send .deb application to remote
  copy:
    src: irssi_1.0-1_amd64.deb
    dest: /tmp/irssi_1.0-1_amd64.deb

- name: Remove existing container if exists
  shell: docker rm -f irssi-cont || true

- name: Create container
  command: docker run -dit --name irssi-cont ubuntu:latest sleep infinity

- name: Update apt
  command: docker exec irssi-cont apt-get update


- name: Copy .deb file into the container
  command: docker cp /tmp/irssi_1.0-1_amd64.deb irssi-cont:/tmp/app.deb


- name: Install .deb app inside the container
  command: docker exec irssi-cont bash -c "dpkg -i /tmp/app.deb || apt-get install -f -y"


- name: Run application
  command: docker exec irssi-cont irssi --version
  register: app_status
  failed_when: app_status.rc != 0
  changed_when: false
```


Główny plik `playbook.yml`:

Ten playbook uruchamia zadania na grupie hostów Endpoints, wykonując je z podwyższonymi uprawnieniami (become: yes). Korzysta z kolekcji community.docker, co umożliwia używanie modułów związanych z Dockerem. Playbook wywołuje dwie role: install_docker oraz install_irssi. Dzięki temu cały proces wdrożenia Dockera oraz aplikacji jest zautomatyzowany i uporządkowany.

```bash
- name: Deploy docker and irssi
  hosts: Endpoints
  become: yes
  collections:
    - community.docker
  roles:
    - install_docker
    - install_irssi
```

<br>

Uruchomienie playbooka:

```bash
ansible-playbook -i inventory.ini install_irssi/playbook.yml -K
```

![ansi](lab_ansible/irssi.png)

<br>
<br>

# Lab 9 - Pliki odpowiedzi dla wdrożeń nienadzorowanych
<br>

## Plik odpowiedzi

Na początku skopiowano plik odpowiedzi do folderu Sprawozdanie3 oraz nadano uprawnienia do modyfikacji tego pliku.

```bash
sudo cp /root/anaconda-ks.cfg /home/psocala/MDO2025_INO/ITE/GCL07/PS417836/Sprawozdanie3

sudo chmod +777 anaconda-ks.cfg
```

<br>

Modyfikacje:

Dodanie repozytoriów Fedory:

```bash
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64
```

Założenie czystego dysku i formatowanie całości:

```bash
clearpart --all --initlabel
```
Ustawienie hostname:

```bash
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate --hostname=host-p-odpowiedzi
```

<br>

Cały plik anaconda-ks.cfg po modyfikacjach:

```bash
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate --hostname=host-p-odpowiedzi

url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

%packages
@^custom-environment

%end

# Run the Setup Agent on first boot
firstboot --enable

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
autopart
# Partition clearing information
clearpart --all --initlabel

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --iscrypted --allow-ssh $y$j9T$EdlH0qTbCbkj9gMAkuj5uRDm$IiKbwuXZzs4aMwX82qfx4BsD3c0HCTeK0YOtfNw8wy0
```

<br>

Po dodaniu pliku do repozytorium przedmiotowego znajdujemy go i kopiujemy jego link. Następnie za pomocą narzędzie tinyurl zmniejszamy go aby łatwiej było wpisać go w virtualbox'ie.

```bash
https://tinyurl.com/44f7zd8y
```

<br>

---
Proces instalacji systemu:

Na początku standardowo rozpoczynamy instalacje maszyny z obrazem Fedory. Kolejno w oknie bootownia wybieramy klawisz e i wpisujemy skrócony link naszego pliku.

![ansi](lab_anakonda/install1.png)

<br>

Ukończona instalacja systemu.

![ansi](lab_anakonda/koniec.png)

![alt text](lab_anakonda/login.png)

<br>

## Instalacja własnej aplikacji

<br>

Na początku utworzono token w Jenkins aby można było użyć flatpak.

![alt text](lab_anakonda/flat.png)

<br>

Opis zmian pliku anaconda-ks:

Plik Kickstart automatyzuje instalację systemu Fedora 41, ustawiając polskie środowisko, sieć i użytkownika psocala z odpowiednimi uprawnieniami. Po zainstalowaniu podstawowych pakietów, w tym flatpak, pobiera on z serwera Jenkins plik instalacyjny Irssi w formacie Flatpak, wykorzystując do tego uwierzytelnienie loginem i tokenem API. Następnie instaluje ten pakiet oraz dodaje do pliku startowego użytkownika polecenie automatycznego uruchamiania Irssi po zalogowaniu. Całość kończy się automatycznym restartem systemu, co pozwala na szybkie i powtarzalne wdrożenie gotowego środowiska z preinstalowanym i działającym programem Irssi.

<br>

Plik anaconda-ks.cfg po modyfikacjach:

```bash
#version=DEVEL
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58

keyboard --vckeymap=pl --xlayouts='pl'
lang pl_PL.UTF-8

url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

ignoredisk --only-use=sda
clearpart --all --initlabel
autopart

network  --hostname=anacondatest

timezone Europe/Warsaw --utc

rootpw --iscrypted --allow-ssh $y$j9T$EdlH0qTbCbkj9gMAkuj5uRDm$IiKbwuXZzs4aMwX82qfx4BsD3c0HCTeK0YOtfNw8wy0
user --groups=wheel --name=psocala --password=$y$j9T$DKKrBZ/DTxGfL3nY47qmyLG9$4SuT5/d/Fnol7AFh/LhKFTwQW7fVMY.bII6hFc6YK57 --iscrypted --gecos="Paweł Socała"

%packages
@^server-product-environment
flatpak
xdg-utils
dbus
fuse
wget
systemd
%end

firstboot --enable

%post
set -x

# Dodanie repozytorium Flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Pobranie pliku flatpak z Jenkins 
curl -u psocala123:117ce25d6ce85c17ed3126f230f30e9d6a \
  -o /tmp/irssi.flatpak \
  "http://192.168.0.25:8080/job/irssi_pipeline_v2/lastSuccessfulBuild/artifact/irssi-23.flatpak"

# Instalacja flatpaka
flatpak install --noninteractive -y /tmp/irssi.flatpak

# Dodanie autostartu irssi w .bash_profile użytkownika psocala
cat << 'EOF' >> /home/psocala/.bash_profile
flatpak run com.example.irssi
EOF

chown psocala:psocala /home/psocala/.bash_profile

# Usunięcie pobranego pliku
rm -f /tmp/irssi.flatpak

%end

reboot
```

<br>
<br>

# Lab 10 - Wdrażanie na zarządzalne kontenery: Kubernetes (1)
<br>

## Instalacja klastra Kubernetes

Na początku pobrano implementacje minikube oraz przeprowadzono instalację. 

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb

sudo dpkg -i minikube_latest_amd64.deb
```

![alt text](lab_kubernetes_1/curl2.png)

<br>

---
Następnie uruchomiono minikube oraz zainstalowano klienta kubernetes.

```bash
minikube start --driver=docker
```
![alt text](lab_kubernetes_1/start.png)

![alt text](lab_kubernetes_1/klient.png)

<br>

---

Kolejnym krokiem było uruchomineie dashboard w przeglądarce.

```bash
minikube dashboard
```

![alt text](lab_kubernetes_1/dash.png)

<br>

Możemy zauważyć że polecenie dashboard powoduje automatyzczne przekierowanie portu.

![alt text](lab_kubernetes_1/port.png)

![alt text](lab_kubernetes_1/first.png)

<br>

---

Kolejnym krokiem było utworzenie pod'a nginx ponieważ moją wybraną aplikacją było irssi która nie posiada interfejsu graficznego.

```bash
kubectl run nginx-pod --image=nginx --port=80 --labels app=nginx-pod
```

![alt text](lab_kubernetes_1/pod.png)

<br>

Teraz po uruchomieniu dashboarda widać nasz pod nginx. Można go zoabczyć równieć po wpisaniu polecenia poniżej.

```bash
kubectl get pods
```

![alt text](lab_kubernetes_1/pod2.png)

![alt text](lab_kubernetes_1/kube.png)

<br>

## Wyprowadzenie portu

Kolejnym krokiem było uworzenie tunelu przekierowując porty. Po ucuhomieniu poniższego polecenia dodano port w visual studio oraz uruchomiono nginx w przeglądarce.

```bash
minikube kubectl -- port-forward pod/nginx-pod 3000:80
```

![alt text](lab_kubernetes_1/w.png)

![alt text](lab_kubernetes_1/3000.png)

![alt text](lab_kubernetes_1/ng.png)


## Przekucie wdrożenia manualnego w plik wdrożenia (wprowadzenie)

Na początku stworzono plik wdrożenia `nginx-deploy.yaml`, a następnie wdrożono plik.

```bash
#plik

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80

# wdrożenie
kubectl apply -f ./nginx-deploy.yaml
```

![alt text](lab_kubernetes_1/d.png)

<br>

---
Sprawdzenie deploymentu:

1) Za pomocą polecenia:
```bash
kubectl get deployments
```

![alt text](lab_kubernetes_1/p.png)

<br>

2) W dashboard

![alt text](lab_kubernetes_1/deploy_das.png)

<br>

## Deployment 4 replik

Aby zmienić ilość replik wystarczy zmienić wartość w linii: replicas: 4 oraz nazwę wdrożenia. 

Poprawiony plik .yaml:

```bash
# plik

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment-2
  labels:
    app: nginx
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80

# wdrożenie
kubectl apply -f ./nginx-deploy.yaml
```

![alt text](lab_kubernetes_1/dep2.png)

<br>

---
 
Sprawdzenie stanu nowego wdrożenia za pomocą rollout status oraz sprawdzenie dashboard.

```bash
kubectl rollout status deployment/nginx-deployment-2
```

![alt text](lab_kubernetes_1/rol.png)

![alt text](lab_kubernetes_1/dash3.png)

<br>

## Wyeksportowanie wdrożenia jako serwis

W tym etapie tworzymy serwis z naszego wdrożenia, aby uzyskąć uniwersalny interfejs.

```bash
kubectl expose deployment nginx-dep --port=3001 --target-port=80
```

![alt text](lab_kubernetes_1/serwis.png)

<br>

Teraz za pomocą polecenia sprawdzamy czy seriws jest uruchomiony.

```bash
kubectl get service
```

![alt text](lab_kubernetes_1/s.png)

<br>

---
Teraz eksponujemy serwis za pomocą port-forwarding. Po uruchomieniu polecenia dodajemy port w visual studio oraz sprawdzamy czy adres działa w przeglądarce.

```bash
kubectl port-forward service/nginx-dep 3002:3001
```

![alt text](lab_kubernetes_1/eks.png)

![alt text](lab_kubernetes_1/kub2.png)

![alt text](lab_kubernetes_1/kub.png)


<br>
<br>

# Lab 11 - Wdrażanie na zarządzalne kontenery: Kubernetes (2)
<br>