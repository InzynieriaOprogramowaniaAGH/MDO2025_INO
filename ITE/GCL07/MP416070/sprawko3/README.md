# Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible (^o^)/ 

Do przeprowadzenia laboratoriów utworzono drugą maszyne wirtualną ansible-target (na systemie Fedora) oraz przygotowano ją do pracy aby umożliwić komunikację pomiędzy maszynami wirtualnymi. Nadano obu maszynom hostame (ansible-target oraz ansible-controller). Następnie wygenerowano nowy klucz SSH, aby umożliwić bezhasłowe logowanie do maszyny ansible-target.

### Wygenerowanie nowego klucza SSH na maszynie głównej (ansible-controller)

```
ssh-keygen -t rsa -b 4096 -f ~/.ssh/nowy_klucz_ansible
```

### Skopiowanie klucza publicznego na maszynę docelową (ansible-target)

```
ssh-copy-id -i ~/.ssh/nowy_klucz_ansible.pub ansible@ansible-target
```

### Instalacja Ansible na ansible-controller

```
sudo apt update
sudo apt install ansible -y
```

Następnie wprowadzono nazwy DNS w pliku /etc/hosts na obu maszynach wirtualnych aby ułatwić komunikację i aby możliwe było używanie nazw hostów zamiast adresów IP. Wystatczy w pliku /etc/hosts dodać następującą linijke :

```
10.0.2.4   ansible-target
```

### Utworzenie pliku inventory z definicją hosta

Utworzono plik inventory aby zdefiniować target dla playbooków ansible.
Treść pliku wygląda następująco:

```
[targets]
ansible-target ansible_host=10.0.2.4 ansible_user=ansible ansible_ssh_private_key_file=~/.ssh/nowy_klucz_ansible
```
### Utworzenie pliku ping.yaml czyli prostego playbooka

Utworzono prosty plik aby przetestować czy host docelowy jest osiągalny przez ansible

```
- name: Ping test on ansible-target
  hosts: targets
  gather_facts: no
  tasks:
    - name: Ping the machine
      ansible.builtin.ping:
```
A następnie uruchomiono playbook jak i sprawdzono działanie.

```
ansible-playbook -i inventory ping.yaml
```

![alt text](screeny/ansible-ping.png)

### Skopiowanie pliku inventory na hosta docelowego 

Utworzono nowy playbook kopiujący plik inventory na hosta docelowego 

```
- name: Copy inventory file to remote machine
  hosts: targets
  tasks:
    - name: Copy inventory file to /tmp on ansible-target
      ansible.builtin.copy:
        src: inventory
        dest: /tmp/inventory_copy
```

Po uruchomieniu playbooka komendą:

```
ansible-playbook -i inventory copy_inventory.yml
```

Opercja zostaje wykonana pomyślnie a plik jest widoczony w katalogu docelowym na hoście - powtórne uruchominie playbooka ping również przechodzi pomyślnie.

![alt text](screeny/sc2.png)

Następnym krokiem było utworznie playbooka aktualizującego pakiety.  użytkownik ansible potrzebuje hasła, żeby użyć sudo, a Ansible nie może go podać. Aby rozwiązać ten problem możemy zezwolić użytkownikowi ansible na użycie sudo bez hasła, logujemy się na ansible-target: 

```
ssh ansible@ansible-target
```

Uruchamiamy plik visudo:

```
sudo visudo
```

oraz na końcu pliku dodajemy:

```
ansible ALL=(ALL) NOPASSWD: ALL
```

Oznacza to, że użytkownik ansible może używać sudo bez hasła – dokładnie tego potrzebuje Ansible.

Po aktualizacji playbook może zdalnie aktualizować pakiety.

```
ansible-playbook -i inventory update.yml
```

![alt text](screeny/sc3.png)

Następnie tworzymy playbook restartujący usługi sshd oraz rngd. Treść playbooka:

```
- name: Restart services on ansible-target
  hosts: targets
  become: true
  tasks:
    - name: Restart sshd
      ansible.builtin.service:
        name: sshd
        state: restarted

    - name: Restart rngd
      ansible.builtin.service:
        name: rngd
        state: restarted
        enabled: yes
```

![alt text](screeny/sc4.png)

### Przeprowadzenie operacji względem maszyny z wyłączonym serwerem SSH

Sprawdzamy działanie ansible, kiedy usługa sshd jest nieaktywna na hoścoe docelowym, w tym celu wyłączamy usługę sshd na ansible-target oraz przy pomocy playbooka próbujemy wykonać polecenie ping.

Otrzymujemy komunikat, że host jest nieosiągalny więc wszystko działa jak powinno.

![alt text](screeny/sc5.png)

### Zarządzanie stworzonym artefaktem przez ansible 

Utworzono nowe playbooki odpowiadające za:
 - Instalacja Dockera za pomocą Ansible
 - Uruchomienie kontenera z obrazu z Docker Hub
 - Zweryfikowanie łączności z kontenerem
 - Zatrzymanie i usunięcie kontenera

Zawartość plików prezentuje sie następująco :

```
- name: Install Docker on Fedora-based system
  hosts: targets
  become: true
  tasks:
    - name: Install required packages
      ansible.builtin.dnf:
        name:
          - dnf-plugins-core
          - device-mapper
          - device-mapper-persistent-data
          - lvm2
        state: present

    - name: Add Docker repo
      ansible.builtin.get_url:
        url: https://download.docker.com/linux/fedora/docker-ce.repo
        dest: /etc/yum.repos.d/docker-ce.repo

    - name: Install Docker
      ansible.builtin.dnf:
        name:
          - docker-ce
          - docker-ce-cli
          - containerd.io
        state: latest

    - name: Enable and start Docker
      ansible.builtin.service:
        name: docker
        state: started
        enabled: true

```

```
- name: Pull and run Docker container
  hosts: targets
  become: true
  tasks:
    - name: Pull Docker image
      community.docker.docker_image:
        name: bambusscooby/irssi-runtime
        tag: "11"
        source: pull

    - name: Run container
      community.docker.docker_container:
        name: irssi-container
        image: bambusscooby/irssi-runtime:11
        state: started
        detach: true

```
```
- name: Verify Docker container is running
  hosts: targets
  become: true
  tasks:
    - name: Get container info
      community.docker.docker_container_info:
        name: irssi-container
      register: container_info

    - name: Debug container state
      ansible.builtin.debug:
        var: container_info.container.State

```


```
- name: Stop and remove Docker container
  hosts: targets
  become: true
  tasks:
    - name: Stop container
      community.docker.docker_container:
        name: irssi-container
        state: stopped

    - name: Remove container
      community.docker.docker_container:
        name: irssi-container
        state: absent

```

Utworzono także plik Makefile który automatyzuje proces, przy pomocy komendy 'make full' uruchamia playbooki w kolejnosci:
Install_docker -> run_docker -> verify_container

Natomiast przy użyciu 'make clean' uruchamia playbook usuwający kontener.


![alt text](screeny/make1.png)

![alt text](screeny/make2.png)

![alt text](screeny/make3.png)

![alt text](screeny/make4.png)

(づ｡◕‿‿◕｡)づpozdrawiam(づ｡◕‿‿◕｡)づ

# Pliki odpowiedzi dla wdrożeń nienadzorowanych
(╯°□°）╯︵ ┻━┻
## Cel zadania
Utworzyć źródło instalacji nienadzorowanej dla systemu operacyjnego hostującego nasze oprogramowanie
Przeprowadzić instalację systemu, który po uruchomieniu rozpocznie hostowanie naszego programu

W pierwszym kroku zainstalowano system Fedora Server, a następnie po 'czystej' instalacji pobrano plik odpowiedzi z lokalizacji '/root/anaconda-ks.cfg`, który następnie zmodyfikowano o :

### Wzmiankę o repo oraz skąd je pobrać:
```
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64

repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64
```

### Zapewnienie że plik odpowiedzi formatuje dysk 

```
clearpart --all
```

### Ustawienie hostaname na inny niż domyślny

Całościowy plik odpowiedzi po modyfikacji wygląda następująco:

```
# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'

# System language
lang pl_PL.UTF-8

# Instalation source (Fedora 38 mirrors)
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64
# Updates repository
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64

# Network information
network --bootproto=dhcp --ipv6=auto --activate --hostname=harambe.localdomain


# Partitioning
ignoredisk --only-use=sda
clearpart --all --initlabel        
autopart                           

# System timezone
timezone Europe/Warsaw --utc

# Run the Setup Agent on first boot
firstboot --enable

# Root password (zaszyfrowany)
rootpw --iscrypted --allow-ssh $y$j9T$k3bQKxtopLwWyUKwD0BDo46H$QhGDBD...
# Użytkownik zwykły
user --groups=wheel --name=user --gecos="user"

%packages
@^server-product-environment
%end

```

Następnie na podstawie utworzonego pliku odpowiedzi utworzono pomocniczy obraz .iso za pomocą komedy:
```
genisoimage -output ks.iso -volid KS -joliet -rock ks.cfg
```

Oraz w VirtualBoxie dodano ten pomocniczy plik .iso

![alt text](screeny/dodanie2Iso.png)

Następnie uruchomiono maszynę wirtualną, w menu instalacyjnym należy wybrać „Install Fedora Server 38…” i nacisnąć klawisz "e" to przeniesie nas do edycji wpisu GRUB-a. Należy zmodyfikować ten wpis - w linijce zaczynającej się  od linux albo linuxefi na końcu lini należy dodać:

```
inst.ks=hd:sr1:/ks.cfg
```
lub podobny wpis zależnie od tego jak zamotowaliśmy nasze pomocnicze .iso.

![alt text](screeny/install1.png)

Po wykonaniu tych kroków i rozpoczęciu instlacji przez Ctrl + X, instalacja przebiega automatycznie bez konieczności dalszej ingerencji ze strony administratora - bardzo przyjemne i wygodne swoją drogą.

### Dodanie do pliku odpowiedzi repozytoria i oprogramowanie potrzebne do uruchomienia programu, zbudowanego w ramach projektu - naszego pipeline'u.

(ಥ﹏ಥ)(ಥ﹏ಥ)
Rozbudowujemy plik odpowiedzi, aby mieć w pełni nienadzorowaną instalację Fedory z Dockerem i automatycznym startem utworzonego w ramach pipeline'u obrazu. Dokonujemy modyfikacji pliku odpowiedzi, plik wygląda następująco :

```
# ---------------------------------------------------------------------------
# Fedora 38 Server – Kickstart z Docker CE i autostartem kontenera
# ---------------------------------------------------------------------------
keyboard --vckeymap=pl --xlayouts='pl'
lang pl_PL.UTF-8


url  --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64


repo --name=docker-ce --baseurl=https://download.docker.com/linux/fedora/38/x86_64/stable

network --bootproto=dhcp --ipv6=auto --activate --hostname=harambe.localdomain


ignoredisk --only-use=sda
clearpart --all --initlabel
autopart

timezone Europe/Warsaw --utc


rootpw  --iscrypted --allow-ssh $y$j9T$k3bQKxtopLwWyUKwD0BDo46H$QhGDBDB0PK1l...
user    --groups=wheel --name=user --gecos="user"

# 1. Pakiety (Dockera + zależności dorzucamy tutaj)
%packages
@^server-product-environment
dnf-plugins-core
device-mapper
device-mapper-persistent-data
lvm2
docker-ce
docker-ce-cli
containerd.io
%end

# 2. Konfiguracje po zainstalowaniu plików 
%post --log=/root/ks-post.log --interpreter=/usr/bin/bash --erroronfail

cat >/etc/yum.repos.d/docker-ce.repo <<'EOF'
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://download.docker.com/linux/fedora/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF

# ---  Instalacja / aktualizacja Dockera ---------------
dnf -y install docker-ce docker-ce-cli containerd.io

# ---  Włączenie usługi ----------------------
systemctl enable --now docker.service

# ---  Skrypt first-boot --------------------------------
cat >/usr/local/bin/setup-container.sh <<'EOSH'
#!/usr/bin/env bash
set -euo pipefail

/usr/bin/docker pull bambusscooby/irssi-runtime:11
/usr/bin/docker run -d --name irssi-container --restart=unless-stopped bambusscooby/irssi-runtime:11

systemctl disable firstboot-container.service
EOSH
chmod +x /usr/local/bin/setup-container.sh
restorecon -v /usr/local/bin/setup-container.sh  # SELinux

# ---  Jednostka systemd one-shot -------------------
cat >/etc/systemd/system/firstboot-container.service <<'EOUNIT'
[Unit]
Requires=docker.service
After=docker.service network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/setup-container.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOUNIT

systemctl enable firstboot-container.service

%end

reboot
```

W drugiej wersji pliku kickstartowego w pierwszej kolejności ustawiamy klawiature, język, czas, sieć, partycje i tworzymy użytkowników. Następnie instalujemy paczki na podstawie podanego wcześniej źródla pakietów bazowach (url, repo) oraz z repozytorium Dockera - konieczne do uruchomienia aplikacja z pipeline'u. 

Sekcja %post zawiera polecenia powłoki (bash), które zostaną wykonane zaraz po zakończeniu instalacji pakietów, ale jeszcze przed pierwszym uruchomieniem systemu.

Można tam: kopiować pliki, pisać własne skrypty, instalować dodatkowe rzeczy, przygotować konfigurację systemu. W tym przypadku :
dodajemy plik repozytorium Docker CE - tworzymy plik .repo, który mówi systemowi, gdzie znaleźć i jak pobierać pakiety Dockera z internetu. Dzięki temu dnf wie, skąd ściągać Dockera. Po tym upewnimy się, że Docker jest aktualny:

```
dnf -y update docker-ce docker-ce-cli containerd.io 
```
Przez systemctl zapewniamy włączenia Dockera przy każdym starcie systemu:
```
systemctl enable docker
```
Po uruchomieniu systemu Docker uruchomi się automatycznie. Tworzymy skrypt który uruchomi się tylko przy pierwszym starcie systemu, skrypt poczeka aż Docker się uruchomi => pobierze kontener z DockerHub => uruchamia go z odpowiednimi parametrami => dezaktywuje się aby więcej się nie uruchamiać.
```
cat >/usr/local/bin/setup-container.sh <<'EOSH'
...
EOSH
chmod +x /usr/local/bin/setup-container.sh
```

Skrypt tworzy jednostkę systemową (service) 
```
cat >/etc/systemd/system/firstboot-container.service <<'EOUNIT'
...
EOUNIT
```
w systemd (czyli systemie, który zarządza uruchamianiem wszystkiego po starcie systemu). Ta jednostka uruchomi skrypt raz, przy pierwszym starcie systemu. Skrypt włącza tę jednostkę:
```
systemctl enable firstboot-container.service
```
tak aby wystartowała automatycznie przy pierwszym starcie systemu.

Czyli idąc krok po kroku:

1. System startuje
2. Docker się uruchamia
3. firstboot-container.service widzi, że Docker już działa
4. firstboot-container.service uruchamia skrypt który:
  1. Pobiera obraz kontenera z DockerHub
  2. uruchamia go w tle
  3. dezaktywuje jednostkę systemd, żeby więcej nie uruchamiała się przy starcie.

Sekcja %post to kluczowy element dla pliku kickstartowego przy automatyzacji instalacji aplikacji z pipeline'u.

┬─┬ ノ( ゜-゜ノ)

# Wdrażanie na zarządzalne kontenery: Kubernetes (1)
(^o^)/ 
## Instalacje minikube

![alt text](screeny/curl_minikube.png)
## Uruchomienie klastra
Uruchamiamy klaster Kubernetes za pomocą polecenia minikube start, co powoduje uruchomienie środowiska gotowego do wdrażania kontenerów.
![alt text](<screeny/minikube start.png>)
## Zaopatrzenie się w polecenie kubectl oraz dodanie aliasu
Instalujemy narzędzie kubectl służące do zarządzania klastrem Kubernetes oraz definiujemy alias, aby wygodniej używać tego polecenia.
![alt text](screeny/alias.png)
![alt text](screeny/daszboard1.png)
![alt text](screeny/daszboard2.png)

## Uruchamianie oprogramowania
Polecenie uruchamia kontener z obrazem nginx w Kubernetes jako pojedynczy pod o nazwie nginx-pod, wystawiając go na porcie 80 i przypisując mu etykietę app=nginx-deployment.
```
minikube kubectl -- run nginx-pod --image=nginx --port=80 --labels app=nginx-deployment
```

Utworzony zostaje pod oraz następnie jest skalowany do 12 instancji, przez zakładke deployments w dashboard minikube.
![alt text](screeny/pods1.png)
![alt text](screeny/scale.png)
![alt text](screeny/podsyskalowane.png)

![alt text](screeny/workloads.png)

## Wyprowadzenie portu

![alt text](screeny/portFoward.png)

![alt text](screeny/ngixDZIAŁĄAAAAAA.png)

## Utworzenie pliku yaml oraz kubectl apply

```
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
          image: nginx:latest
          ports:
            - containerPort: 80

```

![alt text](screeny/yaml1.png)

## Rozszerzenie pliku yaml o 4 repliki 

Zmieniamy część pliku replicas następująco :

```
spec:
  replicas: 4
```

Oraz wykonujemy następującą konfiguracje 

![alt text](screeny/yaml2konfiguracja.png)

![alt text](screeny/yaml2testdziałania.png)

Jak widać konfiguracja została przeprowadzona poprawnie.

# Wdrażanie na zarządzalne kontenery: Kubernetes (2)
(¬‿¬)(⌒ω⌒)(¬‿¬)
Stworzenie obrazów na podstawie httpd oraz jednego obrazu który kończy się błędem oraz wypchnięcie na DockerHub.

```
<html>
    <body>
        <h1>Sprawdzenie działania</h1>
    </body>
</html>
```

```
FROM httpd:2.4
COPY ./index.html /usr/local/apache2/htdocs/index.html

```

```
FROM httpd:2.4
COPY ./broken.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
```

![alt text](screeny/dbuild1.png)

![alt text](screeny/dbuild2.png)

![alt text](screeny/dockerPush.png)

Po wypchnięciu utworzono pliki .yaml dla obu wersji httpd:v1 oraz httpd:v2

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd-deployment          # nowa nazwa
  labels:
    app: httpd
spec:
  replicas: 4                     # zostawiasz lub zmieniasz wg potrzeb
  selector:
    matchLabels:
      app: httpd                  # musi się zgadzać z template.metadata.labels
  template:
    metadata:
      labels:
        app: httpd
    spec:
      containers:
        - name: httpd             # dowolna przyjazna nazwa kontenera
          image: bambusscooby/httpd-custom:v1   # ← tu wskazujesz swój obraz
          ports:
            - containerPort: 80   # Apache domyślnie słucha na 80



```

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd-deployment          # nowa nazwa
  labels:
    app: httpd
spec:
  replicas: 4                     # zostawiasz lub zmieniasz wg potrzeb
  selector:
    matchLabels:
      app: httpd                  # musi się zgadzać z template.metadata.labels
  template:
    metadata:
      labels:
        app: httpd
    spec:
      containers:
        - name: httpd             # dowolna przyjazna nazwa kontenera
          image: bambusscooby/httpd-custom:v2   # ← tu wskazujesz swój obraz
          ports:
            - containerPort: 80   # Apache domyślnie słucha na 80

```

## 🌵 Aktualizacja pliku YAML z wdrożeniem i przeprowadzenie je ponownie po zastosowaniu następujących zmian

#### Stworzenie pierwszej wersji
Tworzona jest początkowa wersja deploymentu, która uruchamia 4 instancje aplikacji HTTPD.

![alt text](screeny/httpd4.png)

#### Zwiększenie do 8
Następuje skalowanie liczby instancji aplikacji z 4 do 8 replik, aby zwiększyć dostępność i obsłużyć większy ruch.
![alt text](screeny/httpd8.png)
#### Zmniejszenie do 1
Liczba instancji jest redukowana z 8 do 1 repliki, minimalizując zużycie zasobów klastra Kubernetes.
![alt text](screeny/httpd1.png)
#### Zmniejszenie do 0
Wszystkie instancje aplikacji zostają zatrzymane poprzez skalowanie deploymentu do 0, co powoduje całkowity brak dostępności aplikacji.
![alt text](screeny/httpd0.png)
#### Zwiększenie do 4
Ponownie uruchamiane są 4 instancje aplikacji, przywracając deployment do pierwotnej konfiguracji.
![alt text](screeny/httpd4.png)
![alt text](screeny/httpdv1-komendy.png)

## Uruchomienie wadliwego obrazu
Wdrożony zostaje wadliwy obraz aplikacji, co prowadzi do niepowodzenia uruchomienia podów i przejścia deploymentu w stan błędu.
![alt text](screeny/wadliwyHttpd.png)

![alt text](screeny/wadliwyKubernetes.png)

## Sprawdzenie history rollout'ów oraz przywrócenie do działającej wersji 
Za pomocą historii rollout sprawdzane są poprzednie wersje wdrożenia, a następnie deployment jest cofany (rollback) do ostatniej poprawnie działającej wersji aplikacji.
![alt text](screeny/rolloutHistory.png)

![alt text](screeny/rolloutUndo.png)

# Strategie wdrożenia 

### Skrypt weryfikujący wdrożenia 

```
#!/bin/bash

DEPLOYMENT_NAME="httpd-custom"
NAMESPACE="default"
TIMEOUT=60

echo "Sprawdzam rollout '$DEPLOYMENT_NAME' (maks. $TIMEOUT sek)..."

start_time=$(date +%s)

while true; do
    status=$(kubectl rollout status deployment/$DEPLOYMENT_NAME --namespace $NAMESPACE --timeout=5s 2>&1)

    if echo "$status" | grep -q "successfully rolled out"; then
        echo "Wdrożenie zakończone sukcesem!"
        exit 0
    fi

    if echo "$status" | grep -q "error"; then
        echo "Błąd rolloutu:"
        echo "$status"
        exit 1
    fi

    now=$(date +%s)
    elapsed=$((now - start_time))

    if [ $elapsed -ge $TIMEOUT ]; then
        echo "Timeout: rollout nie zakończył się w ciągu $TIMEOUT sekund"
        kubectl get pods -l app=$DEPLOYMENT_NAME
        exit 2
    fi

    sleep 3
done
```

## Wersje Wdrożeń

### Wdrożenie typu recreate

1. Strategia Recreate (odtworzenie):
Na czym polega?

Stara wersja aplikacji jest najpierw całkowicie zatrzymywana.

Dopiero gdy poprzednia wersja jest całkowicie usunięta, uruchamiana jest nowa wersja.
Powoduje krótką przerwę w dostępności aplikacji.

Idealna dla aplikacji, które nie mogą działać jednocześnie w dwóch różnych wersjach (np. baza danych z niekompatybilnymi wersjami).

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-recreate
spec:
  replicas: 3
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: demo
      version: v1
  template:
    metadata:
      labels:
        app: demo
        version: v1
    spec:
      containers:
      - name: httpd
        image: bambusscooby/httpd-custom:v1
        ports:
        - containerPort: 80
```

2. Strategia Rolling Update:
Stopniowo zastępuje stare instancje aplikacji nowymi.

Pozwala uniknąć całkowitej niedostępności aplikacji. Kluczowe parametry obejmują:

available: liczba podów, które mogą być jednocześnie niedostępne podczas aktualizacji. Jeśli ustawimy > 1, zezwalamy na jednoczesne zatrzymanie kilku podów.

maxSurge: dodatkowe pody uruchamiane ponad liczbę docelową podczas aktualizacji. Wartość > 20% pozwala przyspieszyć wdrożenie, uruchamiając więcej podów niż standardowa liczba.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-rolling
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 50%
  selector:
    matchLabels:
      app: demo
      version: v1
  template:
    metadata:
      labels:
```

![alt text](screeny/apply&&rollout.png)

![](screeny/strategieWdrożenie_kubernetes.png)

![alt text](screeny/kubectlpods.png)

| Cecha                  | Recreate                               | Rolling Update               | Canary Deployment                                    |
| ---------------------- | -------------------------------------- | ---------------------------- | ---------------------------------------------------- |
| Przestój aplikacji     | Tak                                    | Nie                          | Nie                                                  |
| Kontrola ryzyka        | Niska                                  | Średnia                      | Wysoka (pełna kontrola)                              |
| Złożoność konfiguracji | Niska                                  | Średnia                      | Wysoka (wymaga dodatkowych narzędzi)                 |
| Zastosowanie           | Bazy danych, aplikacje niekompatybilne | Większość aplikacji webowych | Aplikacje krytyczne, wymagające szczególnej kontroli |
