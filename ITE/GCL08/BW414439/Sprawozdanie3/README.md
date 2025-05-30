# Ansible

## Tworzynmy nową maszynę (docelową)
Powinna ona mieć tą samą wersje co główna maszyna
![](images2/Pasted%20image%2020250527211756.png)

Dodajemy ssh
![](images2/Pasted%20image%2020250527211830.png)

### Stworzenie migawki w virtualbox

![](images2/Pasted%20image%2020250527221511.png)

## Instalacja Ansible (na maszynie zarządzającej)

`$ sudo apt install software-properties-common`
`$ sudo add-apt-repository --yes --update ppa:ansible/ansible`
`$ sudo apt install ansible`

![](images2/Pasted%20image%2020250527214305.png)

## Wymiana kluczy ssh

Jeżeli jeszcze nie posiadamy wygenerowanego klucza ssh to robimy to tak jak w pierwszym sprawozdaniu.

### Sprawdzamy ip maszyny docelowej

`$  ifconfig`

![](images2/Pasted%20image%2020250527222117.png)

### Wymiana kluczy ssh (na maszynie zarządzającej)

`$ ssh-copy-id ansible@ip-maszyny-docelowej`

![](images2/Pasted%20image%2020250527222429.png)

Test połączenia bez hasła

![](images2/Pasted%20image%2020250527222551.png)


### Dodanie nazw DNS

Sprawdzamy nazwy obu maszyn (ustawione podczas instalacji)

`$ hostnamectl`

Maszyna zarządzająca

![](images2/Pasted%20image%2020250527223021.png)

Maszyna docelowa

![](images2/Pasted%20image%2020250527223051.png)

Dodajemy adresy do /etc/hosts na maszynie zarządzającej

![](images2/Pasted%20image%2020250527224645.png)

Test ping z użyciem nazwy hosta

![](images2/Pasted%20image%2020250527225817.png)
![](images2/Pasted%20image%2020250527230215.png)
## Plik inwentaryzacji

Tworzymy plik inwentaryzacji, gdzie odpowiednio wpisujemy nasze nazwy hostów oraz użytkowników z których będzie korzystać Ansible.

> Dodatkowo, aby działało połączenie do masyzny lokalnej dodajemy odpowiedni dopisek

```ini
[Orchestrators]
mz ansible_user=adam ansible_connection=local

[Endpoints]
ansible-target ansible_user=ansible
```

Możemy sprawdzić poprawność pliku

`$ ansible-inventory -i inventory.ini --list`

![](images2/Pasted%20image%2020250527231917.png)

### Ping do maszyn za pomocą pliku inwentaryzacji
Aby wykonać operacje na wszystkich hostach jako grupę podajemy `all`

![](images2/Pasted%20image%2020250527231932.png)

## Playbook

### Ping
Tworzymy nowy playbook z rozrzeżeniem yaml
```yaml
- name: Ping
  hosts: all
  tasks:
   - name: Ping my hosts
     ansible.builtin.ping:
```

Uruchamiamy playbook

`$ ansible-playbook -i inventory.ini ping.yaml`

![](images2/Pasted%20image%2020250527232802.png)

### Skopiowanie pliku

```yaml
- name: Copy
  hosts: Endpoints
  tasks:
    - name: Copy
      copy:
        src: ./inventory.ini
        dest: /tmp/inventory.ini
```


#### Uruchomienie

`$ ansible-playbook -i inventory.ini file.yaml`

![](images2/Pasted%20image%2020250527233709.png)

Ponowne uruchomienie

![](images2/Pasted%20image%2020250527233825.png)

> Po ponownym uruchomieniu widzimy, że changed=0, ponieważ nic się nie zmieniło od czasu poprzedniego uruchomienia i ten sam plik jest już w miejscu docelowym.

### Aktualizacja pakietów

#### Dodanie uprawnień administratorskich użytkowniką
Aby ansible mógł korzystac z uprawnień roota, użytkoniwk którego używa musi je posiadać. Dodatkowo pozwalamy mu kożystać z nich bez wpisywania hasła.

`$ sudo visudo`

> Dodawana linijka musi być na końcu pliku, tak aby nadpisywała pozostałe wpisy

![](images2/Pasted%20image%2020250528003951.png)

Tak samo postępujemy na maszynie docelowej
![](images2/Pasted%20image%2020250528004130.png)

> Ważne aby użytkownik był także w grupie sudo
> `$ sudo usermod -aG sudo ansible`
> ![](images2/Pasted%20image%2020250528003407.png)

#### Uruchomienie

`$ ansible-playbook -i inventory.ini update.yaml`

![](images2/Pasted%20image%2020250528004713.png)

### Restart sshd
Aby restartować serwisy systemowe także potrzebujemy uprawnienia administratorskie

```yaml
- name: Restart sshd and rngd
  hosts: all
  become: yes
  tasks:
    - name: Restart sshd
      ansible.builtin.systemd:
        name: sshd
        state: restarted
```


![](images2/Pasted%20image%2020250528010432.png)

#### Przy wyłączonej usłudze sshd na maszynie docelowej

Wyłączamy usługę na maszynie
`$ sudo service sshd stop`

![](images2/Pasted%20image%2020250528011256.png)

![](images2/Pasted%20image%2020250528011504.png)


#### Przy odpiętej karcie sieciowej
![](images2/Pasted%20image%2020250528011612.png)

![](images2/Pasted%20image%2020250528011811.png)

## Uruchomienie programu w kontenerze docker z użyciem roli

### Tworzymy odpowiednią strukture plików

![](images2/Pasted%20image%2020250528231106.png)

Plik `playbook.yaml` to nasz główny playbook, każda rola to zestaw zadań, które zostaną wykonane. Dla roli install_irssi potrzebujemy dać jej plik z naszą aplikacją, dlatego znajduje się ona tam w dodatkowym folderze `files`.

### Rola install_docker
Służy ona do upewnienia się, że docker jest zainstalowany i w przeciwnym razie dosinstalowaniem go.

Plik main.yaml
```yaml
- name: Check if Docker is installed
  command: which docker
  register: docker_check
  ignore_errors: true

- name: Install Docker using official Docker repository
  block:
    - name: Install prerequisites
      apt:
        name:
          - apt-transport-https
          - ca-certificates
          - curl
          - gnupg
          - lsb-release
        state: present
        update_cache: yes
  

    - name: Add Docker GPG key
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present

    - name: Add Docker repository
      apt_repository:
        repo: deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable
        state: present
  

    - name: Install Docker CE
      apt:
        name: docker-ce
        state: present
        update_cache: yes
  when: docker_check.rc != 0

- name: Ensure Docker service is started and enabled
  service:
    name: docker
    state: started
    enabled: true
```

### Rola install_irssi
Tworzy ona kontener w którym będzie uruchamiana aplikacja i uruchamia ją

Plik main.yaml
```yaml
- name: Send .deb application to remote
  copy:
    src: irssi_1.0-1_amd64.deb
    dest: /tmp/irssi_1.0-1_amd64.deb

- name: Remove existing container if exists
  command: docker rm -f irssi-cont || true

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

### Główny playbook

Plik playbook.yaml
```yaml
- name: Deploy docker and irssi
  hosts: Endpoints
  become: yes
  collections:
    - community.docker
  roles:
    - install_docker
    - install_irssi
```

### Uruchomienie

`$ ansible-playbook -i inventory.ini install_app/playbook.yaml`

![](images2/Pasted%20image%2020250528232001.png)
# Instalacja nienadzorowana

## Zdobycie pliku odpowiedzi

Kopiujemy plik anaconda-ks.cfg i dodajemy do repozytorium zdalnego z którego będzie kopiowany przez maszyne.
![](images2/Pasted%20image%2020250506202414.png)

Zawartość pliku
```cfg
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8
  

%packages
@^server-product-environment
  
%end
  
# Run the Setup Agent on first boot
firstboot --enable
  
# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
autopart
# Partition clearing information
clearpart --none --initlabel

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --iscrypted $y$j9T$TByzOrVpyPzIEXLtj6YYWe7X$QBrvDrJTNy/LKTCFByi5CgE5JJb/S5ZVQxPRSsDYzx8
user --groups=wheel --name=franek --password=$y$j9T$Bqpg7nsp0k3UaRrWTycl8Nt9$zV7P5XOBw.RnAUoLHtqQEdN.S2NkuHq8b9/bVpsZkR/ --iscrypted --gecos="franek"
```

### Modyfikujemy plik
```cfg
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL


# Repozytoria instalacyjne
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64"
repo --name=updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64"

# Partycjonowanie - wymuś czyszczenie całego dysku
ignoredisk --only-use=sda
clearpart --all --initlabel
autopart
  
# Nazwa hosta
network  --hostname=frankowa-domena

# Ustawienia klawiatury
keyboard --vckeymap=pl --xlayouts='pl'
# Język systemowy
lang pl_PL.UTF-8

# Strefa czasowa
timezone Europe/Warsaw --utc

# Hasło roota
rootpw --iscrypted $y$j9T$TByzOrVpyPzIEXLtj6YYWe7X$QBrvDrJTNy/LKTCFByi5CgE5JJb/S5ZVQxPRSsDYzx8

# Główny użytkownik
user --groups=wheel --name=franek --password=$y$j9T$Bqpg7nsp0k3UaRrWTycl8Nt9$zV7P5XOBw.RnAUoLHtqQEdN.S2NkuHq8b9/bVpsZkR/ --iscrypted --gecos="franek"

%packages
@^server-product-environment
%end
  
firstboot --enable
```

Zmodyfikowany plik dodajemy do repozytorium zdalnego.
## Dodawanie parametru aby uruchomić instalacje nienadzrowaną
Bootujemy się z medium instalacyjnego dla naszego systemu. Gdy uruchomi się menu wybierania opcji bootowania klikamy przycisk `e`

![](images2/Pasted%20image%2020250529003709.png)

Wchodzimy na github i znajdujemy nasz plik odpowiedzi, klikamy przycisk raw i kpiujemy link
![](images2/Pasted%20image%2020250529002913.png)

Teraz aby nie przepisywać całego linku wchodzimy na strone tinyurl.com i tworzymy krótszy link
![](images2/Pasted%20image%2020250529010845.png)

Teraz dopisujemy na końcu linkijki zaczynającej się na `linux /images`:

`inst.ks=https://nasz.link`

![](images2/Pasted%20image%2020250529005632.png)

Potem klikamy `Ctrl+X`

![](images2/Pasted%20image%2020250529005144.png)

Jeżeli wszystko poszło poprawnie po chiwili znajdziemy się na ekranie instalatora. Teraz czekamy, aż przemieli on to co muisi.

![](images2/Pasted%20image%2020250529010118.png)

I po jakimś czasie rozpocznie się instalacja

![](images2/Pasted%20image%2020250529010248.png)

![](images2/Pasted%20image%2020250529013032.png)

## Instalowanie własnej aplikacji

> W tym przypadku użyto aplikacji hostowanej i budowanej przez jenkinsa innej osoby, ponieważ z mojego pipeline powstaje pakiet .deb, którego nie da się zainstalować na fedorze z powodu brakujących bibliotek, które mimo zainstalowania nie są kompatybilne
![](images2/Pasted%20image%2020250529165352.png)

### Udostępnienie pobierania aplikacji z Jenkins

W dashboardzie Jenkins wchodzimy w Security
![](images2/Pasted%20image%2020250529150324.png)

A następnie tworzymy nowy token, za pomocą którego będziemy 
![](images2/Pasted%20image%2020250529150405.png)

### Modyfikacja pliku odpowiedzi
Dodajemy w sekcji `%packages` odpowiedzni paczki, aby dokonać instalacji oraz dodajemy sekcje `%post`

```cfg
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Repozytoria instalacyjne
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64"
repo --name=updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64"

# Partycjonowanie - wymuś czyszczenie całego dysku
ignoredisk --only-use=sda
clearpart --all --initlabel
autopart
  
# Nazwa hosta
network  --hostname=frankowa-domena


# Ustawienia klawiatury
keyboard --vckeymap=pl --xlayouts='pl'

# Język systemowy
lang pl_PL.UTF-8

# Strefa czasowa
timezone Europe/Warsaw --utc
  
# Hasło roota
rootpw --iscrypted $y$j9T$TByzOrVpyPzIEXLtj6YYWe7X$QBrvDrJTNy/LKTCFByi5CgE5JJb/S5ZVQxPRSsDYzx8

  
# Główny użytkownik
user --groups=wheel --name=franek --password=$y$j9T$Bqpg7nsp0k3UaRrWTycl8Nt9$zV7P5XOBw.RnAUoLHtqQEdN.S2NkuHq8b9/bVpsZkR/ --iscrypted --gecos="franek"

  
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
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --noninteractive -y flathub org.freedesktop.Platform//23.08
  
curl -u jaszczur:11f2234d11931d3c37ad0506e7d241dd82 -o /tmp/irssi.flatpak http://192.168.0.113:8080/job/Irssi/lastSuccessfulBuild/artifact/irssi-23.flatpak

flatpak install /tmp/irssi.flatpak -y

  
cat << 'EOF' >> /home/franek/.bash_profile
flatpak run com.example.irssi
EOF

%end

reboot
```


### Uruchomienie instalacji
Teraz postępujemy dokładnie tak jak w poprzednim punkcie.

Instalacja
![](images2/Pasted%20image%2020250529205000.png)

System teraz automatycznie uruchamia się ponownie
![](images2/Pasted%20image%2020250529210608.png)

A po zalogowaniu się uruchamia się nasza aplikacja
![](images2/Pasted%20image%2020250529210659.png)

# Kubernetes

## Instalacja

```shell
$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
````

```shell
$ sudo dpkg -i minikube_latest_amd64.deb
```

![](images2/Pasted%20image%2020250530005724.png)

Dodatnie aliasu do komendy

`$ alias kubectl="minikube kubectl --"`

![](images2/Pasted%20image%2020250530010002.png)

## Uruchomienie minikube

`$ minikube start`

![](images2/Pasted%20image%2020250530013251.png)

#### Wykorzystanie zaleceń z konsoli i dodanie użytkonika do grupy docker

```shell
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
$ newgrp docker
```

![](images2/Pasted%20image%2020250530013636.png)

Jeżeli to nie pomaga, to należy także sprawdizić uprawnienia do socketu dockerowego (powinny być one dla użytkonika root i grupy docker)

`$ ls -l /var/run/docker.sock`

Aby naprawić:

```shell
$ sudo chown root:docker /var/run/docker.sock
$ sudo chmod 660 /var/run/docker.sock
```

![](images2/Pasted%20image%2020250530014042.png)

> Jeżeli dalej nie działa pomaga reboot systemu, aby docker się uruchomił ponownie

Teraz po uruchomieniu `$ minikube start`

![](images2/Pasted%20image%2020250530021924.png)

## Uruchomienie dashboard

`$ minikube dashboard`

![](images2/Pasted%20image%2020250530021801.png)

Po wejściu w podany link:
![](images2/Pasted%20image%2020250530021738.png)

> VS Code automatycznie przekierowywuje port z maszyny
> ![](images2/Pasted%20image%2020250530021902.png)

## Utworzenie pod'a nginx

`$ kubectl run nginx-pod --image=nginx --port=80 --labels app=nginx-pod

![](images2/Pasted%20image%2020250530162652.png)

Teraz widać go w dashboard
![](images2/Pasted%20image%2020250530161454.png)

Oraz porzez polecenie

`$ kubectl get pods`

![](images2/Pasted%20image%2020250530161523.png)

## Wyprowadzenie portu
W porcie wpisujemy `port na maszynie:port w podzie`

`$ minikube kubectl -- port-forward pod/nginx-pod 3000:80`

![](images2/Pasted%20image%2020250530162728.png)

Teraz w visual studio code dodajemy port do przekierowania (zakładka Ports i klikamy Add Port, a potem podajemy port aplikacji na maszynie)

![](images2/Pasted%20image%2020250530162824.png)

Teraz możemy wejść przez przeglądarke
![](images2/Pasted%20image%2020250530163000.png)

## Tworzenie pliku wdrożenia

Przykład pliku wdrażania możemy znaleźć na [stronie kubernetes](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment)

nginx-deply.yaml
```yaml
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

```

## Wdrożenie pliku

`$ kubectl apply -f ./nginx-deply.yaml`

![](images2/Pasted%20image%2020250530164417.png)

### Sprawdzenie deploymentu

Poprzez komende

`$ kubectl get deployments`

![](images2/Pasted%20image%2020250530164621.png)

W dashboard w zakładce Deplyments
![](images2/Pasted%20image%2020250530165944.png)

## Deployment 4 replik
Aby zmienić ilość replik zmieniamy wartość replicas (została też zmieniona nazwa na prostszą)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-dep
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
```

Wdrożenie

`$ kubectl apply -f ./nginx-deply.yaml`

![](images2/Pasted%20image%2020250530165023.png)

## Sprawdzenie stanu wdrożenia

`$ kubectl rollout status deployment/nginx-dep`

![](images2/Pasted%20image%2020250530165132.png)

Widać go także w dashboardzie

![](images2/Pasted%20image%2020250530165210.png)

> Ponieważ została zmieniona nazwa został stworzony jako nowy deployment. Teraz gdy zwiększymy ilość replik do 5 i ponownie wdrożymy plik, zostanie dodany dodatkowy pod do deploymentu.
> ![](images2/Pasted%20image%2020250530165358.png)
> ![](images2/Pasted%20image%2020250530165450.png)


## Stworzenie serwisu

Teraz tworzymy serwis z wdrożenia, dzięki któremu dostaniemy uniwersalny interfejs, aby kożystać  z naszego deploymentu.

`$ kubectl expose deployment nginx-dep --port=3001 --target-port=80`

![](images2/Pasted%20image%2020250530171156.png)

Możemy zobaczyć że serwis jest uruchomiony

`$ kubectl get service`

![](images2/Pasted%20image%2020250530171309.png)

## Eksponujemy serwis

`$ kubectl port-forward service/nginx-dep 3002:3001`

![](images2/Pasted%20image%2020250530171825.png)

Dodajemy port forwarding w VS Code
![](images2/Pasted%20image%2020250530171852.png)

![](images2/Pasted%20image%2020250530171906.png)

# Skalowanie kubernetes i wdrażanie

## Naszykowanie nowych kontenerów

Jako obraz bazowy będize użyta wersja `nginx:1.14.2`, jako nowa wersja zostanie użyta wersja `nginx:1.27.5`, a jako niedziałająca zostanie wykorzystany prosty kontener z entrypoint jako polecenie `false`.

### Tworzenie niedziałającego kontenera

Tworzymy Dockerfile:

```Dockerfile
FROM nginx:latest

ENTRYPOINT ["false"]
```

Budujemy obraz:

`$ docker build -t nginx:bad -f Dockerfile.bad .`

![](images2/Pasted%20image%2020250530205506.png)

Teraz stworzony obraz wgrywany do minikube

`$ minikube image load nginx:bad`

![](images2/Pasted%20image%2020250530211409.png)

Teraz możemy zobaczyć czy nasz obraz załadował się do minikube

`$ minikube image load nginx:bad`

![](images2/Pasted%20image%2020250530211520.png)

## Testowanie skalowania
Skalować możeby bezpośrednio z dashboarda. Wchodzimy w nasz deployment, klikamy w prawym górnym rogu iknonke edytownia, zmieniamy potrzebne wartości i klikamy Update

![](images2/Pasted%20image%2020250530212256.png)
![](images2/Pasted%20image%2020250530212233.png)
### Skalowanie do 8 replik

![](images2/Pasted%20image%2020250530213233.png)

![](images2/Pasted%20image%2020250530213253.png)

### Skalowanie w dół do 1 repliki
![](images2/Pasted%20image%2020250530212759.png)

Z czasem wszyskie pody zostają usunięte poza jednym.

### Skalowanie do 0

Mimo 0 replik deployment dalej istnieje
![](images2/Pasted%20image%2020250530212941.png)
![](images2/Pasted%20image%2020250530212928.png)

### Skalowanie do 4 replik

![](images2/Pasted%20image%2020250530213113.png)
![](images2/Pasted%20image%2020250530213138.png)

## Testowanie zmiany wersji obrazu

### Zmiana na nowszą wersje

Możemy to robić podobnie jak zmnienianie ilości replik w dashboardzie
![](images2/Pasted%20image%2020250530213542.png)


Możemy zaobserwować, że powstają kontenery z nową wersją i powoli zastępują one stare kontenery.

![](images2/Pasted%20image%2020250530213617.png)

![](images2/Pasted%20image%2020250530213736.png)

Aż zostają tylko kontenery z nową wersją
![](images2/Pasted%20image%2020250530213849.png)

### Powrót do starszej wersji
![](images2/Pasted%20image%2020250530214009.png)

Widzimy takie samo zachowanie jak przy zmienianiu wersji w góre, dodawane są nowe kontenery, które zastępują stare

![](images2/Pasted%20image%2020250530214126.png)

### Zmiana wersji na nie działającą
![](images2/Pasted%20image%2020250530214225.png)


Nowe kontenery zaczynają się wdrażać
![](images2/Pasted%20image%2020250530214248.png)

Jednak są one zepsuje, więc stare kontenery nie są usuwane i dalej pozostają działające

![](images2/Pasted%20image%2020250530214413.png)

Oraz możemy zobaczyć że deployment jest oznaczony jako nieudany oraz niedziałające pody zostają.

![](images2/Pasted%20image%2020250530214616.png)

Ale zostaje zachowana 100% dostępność aplikacji, poniewaz pozostają działające pody z poprzedniego deploymentu, które nie zostały jeszcze zabite.

![](images2/Pasted%20image%2020250530214944.png)

## Cofanie deploymentu

### Sprawdzenie historii deploymentów

`$ kubectl rollout history deployment myapp`

![](images2/Pasted%20image%2020250530215227.png)

### Cofanie ostatniego deploymentu

`$ kubectl rollout undo deployment nginx-dep`

![](images2/Pasted%20image%2020250530215342.png)

Zostają usunięte pody z nieudanego deploy'a i przywrócone te, które zostały usunięte.

![](images2/Pasted%20image%2020250530215542.png)

## Skrypt do monitorowania depploymentu

```bash
#!/bin/bash
echo "Wdrożenie w trakcie..."

if minikube kubectl -- rollout status deployment nginx-dep -n default --timeout=60s; then
  echo "Wdrożenie zakończone sukcesem"
else
  echo "Wdrożenie nie powiodło się w ciągu 60 sekund"
  exit 1
fi
```

Teraz uruchamiamy wdrożenie, a następnie uruchamiamy skrypt.

> Ważne aby dodach możliwość uruchamiania skryptu `$ chmod +x deploy.sh`

```shell
$ kubectl apply -f ./nginx-deply.yaml
$ ./deploy.sh
```

![](images2/Pasted%20image%2020250530220811.png)

## Różne strategie wdrażania

### Recreate

Dodajemy strategie do naszego pliku wdrożenia oraz dodajemy label.

> Aby dobrze zobaczyć różnice zmieniamy także wersje obrazu

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-dep
  labels:
    app: nginx
    strategy: recreate
spec:
  replicas: 4
  strategy:
    type: Recreate
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
        image: nginx:1.27.5.2
        ports:
        - containerPort: 80
```

Teraz wdrażamy plik

`$ kubectl apply -f ./nginx-deply.yaml`

Wszystkie pody zostają usunięte
![](images2/Pasted%20image%2020250530230433.png)

A potem powstają nowe
![](images2/Pasted%20image%2020250530230616.png)

### Rolling update

Modyfikujemy strategie

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-dep
  labels:
    app: nginx
    strategy: recreate
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 25%
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
        image: nginx:1.26.0
        ports:
        - containerPort: 80
```


Seriami powstają nowe pody i zastępują stare
![](images2/Pasted%20image%2020250530231110.png)

![](images2/Pasted%20image%2020250530231252.png)

### Canary

Tworzymy nowy plik z deploymentem, dla innej wersji naszej aplikacji (dodatkowo dajemy mu label `track: canary`, aby było wiadomo czym jest i kubernetes mógł go filtrować) i standardowo wdrażamy go.

> Ważne dajemy temy wdrożeniu inną nazwe!

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-dep-canary
  labels:
    app: nginx
    track: canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
      track: canary
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.27.5
          ports:
	      - containerPort: 80
```

Teraz widzimy, że działają pody z deploymentu z starszej wersji i nowszej
![](images2/Pasted%20image%2020250530234037.png)

Oraz instnieją 2 wdrożenia
![](images2/Pasted%20image%2020250530234101.png)

Jednak gdy wejdziemy w zakładkę Service, to widzimy, że jest tam nadal jeden serwis, ale są pod nim wszystkie nasze pody, ponieważ serwis filtruje pody na podstawie labeli (tutaj jest stosowany label `app: nginx`).
![](images2/Pasted%20image%2020250530234157.png)

![](images2/Pasted%20image%2020250530235101.png)
![](images2/Pasted%20image%2020250530234213.png)

## Podsumowanie rodzaji wdrożeń

- Recreate
	Usuwa wszystkie kontenery jednocześnie, po czym tworzy nowe
- Rolling update
	 Seriami usuwa ilość kontenerów zdefiniowaną przez `maxUnavaiable` i tworzy nowe w ilości takiej samej jak została usunięta plus `maxSurge` (czyli procent z maksynalnej liczby replik (jeżeli mamy 4 repliki i maxSurge na 25%, to maksymalnie zostanie utworzony 1 dodatkowy pod w każdej serii)), aż wszystkie zostaną zastąpione nową wersją. Zapewnia to ciągłą dostępność naszej aplikacji w trakcie wdrażania.
- Canarry
	Jest to metoda w której dodajemy wdrożenie z nową wersją aplikacji, ale zwierajacą niewiele replik. Powoduje to, że cześć naszch użytkowników będzie widziała nową aplikajce, a cześć starą co pozwala na testowanie na skali. Jeżeli obserwujemy, że nasza aplikacja działa dobrze, możemy ją w pełni wdrożyć.

