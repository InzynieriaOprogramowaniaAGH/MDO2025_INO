# Sprawozdanie 3

## Lab 8 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

### Cel:
Celem zajęć jest nabycie praktycznych umiejętności w zakresie automatyzacji konfiguracji i zdalnego zarządzania systemami za pomocą Ansible, w tym instalacji oprogramowania, wymiany kluczy SSH.

### 1. Przygotowanie maszyn wirtualnych

Stworzyliśmy drugą maszynę wirtualną z system Fedora. Maszyna ta została przygotowana w wersji minimalnej, czyli miała zainstalowany tylko pakiet *tar* oraz *sshd*.
![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 151623.png>)  

Na maszynie stworzono konto *root'a* oraz użytkowanika.
![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 151808.png>)

### 2. Instalacja Ansible

Na maszynie, której używaliśmy na wczęśniejszych zajęciach zainstalowaliśmy *Ansible*:

```
sudo dnf install ansible
```

![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 151950.png>)

### 3. Konfiguracja komunikacji SSH

Następnie wygenerowaliśmy klucze RSA:

```
ssh-keygen
```
Po czym używając poniższego polecenia przekazaliśmy klucz na maszynę utworozną na tych zajęciach


```
ssh-copy-id ansible@ansible-target
```

![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 161718.png>)

A następnie sprawdziliśmy czy maszyny się "widzą" i czy łączą się poprawnie

```
ssh ansible@ansible-target
```

![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 161817.png>)

Wykonując ten krok, pojawił się problem, ponieważ maszyny się nie widziały. Wiązało się to z faktem, że wykonuję te ćwiczenia, będąc podłączona do sieci w akademiku. Rozwiązanie tego problemu zostało przedsatawione podczas ćwiczeń. Trzeba było zmienić *NAT* na *Sieć NAT*.

### 4. Inwentaryzacja systemów

Na maszynie głownej ustawiliśmy hostname:

```
sudo hostnamectl set-hostname orchestrator
```
![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 162011.png>)

Edytowaliśmy plik */etc/hosts* dodając:

```
10.0.2.15 ansible-target
10.0.2.4 orchestrator
```

![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 162037.png>)


Następnie utworzyliśmy plik *inventory.ini*:


```
[Orchestrators]
orchestrator ansible_connection=local ansible_python_interpreter=/usr/bin/python3

[Endpoints]
ansible-target ansible_user=ansible ansible_python_interpreter=/usr/bin/python3
```

### 5. Test połączenia
Kolejnym krokiem było przetestowanie łączności z maszyną utworozną na tych zajęciach:

```
ansible-playbook -i inventory.ini manage_endpoints.yml -K
```

![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 170229.png>)

### 6. Zdalne operacje z użyciem Ansible

Końcowo utworzyliśmy *deploy.yml*:


```
- name: Deploy express app container on Fedora
  hosts: all
  become: true
  vars:
    container_name: express_app
    image_name: lucyferryt/express-app
    exposed_port: 3000

  tasks:
    - name: Zainstaluj Dockera (moby-engine + docker)
      dnf:
        name:
          - moby-engine
          - docker
        state: present
        update_cache: yes

    - name: Uruchom i włącz usługę Docker
      service:
        name: docker
        state: started
        enabled: true

    - name: Pobierz obraz z Docker Hub
      community.docker.docker_image:
        name: "{{ image_name }}"
        source: pull

    - name: Uruchom kontener z obrazem
      community.docker.docker_container:
        name: "{{ container_name }}"
        image: "{{ image_name }}"
        state: started
        restart_policy: always
        published_ports:
          - "{{ exposed_port }}:3000"

    - name: Poczekaj na odpowiedź HTTP z kontenera
      uri:
        url: "http://localhost:{{ exposed_port }}/"
        method: GET
        return_content: yes
        status_code: 200
      register: result
      retries: 10
      delay: 3
      until: result.status == 200

    - name: Wyświetl status HTTP
      debug:
        msg: "HTTP status: {{ result.status }}"

    - name: Wyświetl treść odpowiedzi HTTP (pierwsze 300 znaków)
      debug:
        msg: "{{ result.content[:300] }}"

    - name: Zatrzymaj kontener
      community.docker.docker_container:
        name: "{{ container_name }}"
        state: stopped

    - name: Usuń kontener
      community.docker.docker_container:
        name: "{{ container_name }}"
        state: absent
```

A także *manage_endpoints.yml*:
```
---
- name: Ping all machines
  hosts: all
  tasks:
    - name: Ping the target machine
      ansible.builtin.ping:

- name: Copy inventory file to target machines
  hosts: Endpoints
  tasks:
    - name: Copy the inventory file
      ansible.builtin.copy:
        src: /home/lwuls/MDO2025_INO/ITE/GCL08/LW417490/Sprawozdanie3/inventory.ini
        dest: /tmp/inventory.ini

- name: Ping the target machines again
  hosts: Endpoints
  tasks:
    - name: Ping the target machine again
      ansible.builtin.ping:

- name: Update packages on target machines
  hosts: Endpoints
  become: yes
  tasks:
    - name: Update all packages
      ansible.builtin.dnf:
        name: "*"
        state: latest

- name: Restart services on target machines
  hosts: Endpoints
  become: yes
  tasks:
    - name: Restart sshd service
      ansible.builtin.service:
        name: sshd
        state: restarted

    - name: Restart rngd service
      ansible.builtin.service:
        name: rngd
        state: restarted

- name: Wait for SSH to become available on a machine
  hosts: unreachable_endpoints
  tasks:
    - name: Wait for SSH port to become available
      ansible.builtin.wait_for:
        host: "{{Endpoints}}"
        port: 22
        delay: 60
        timeout: 600
```


### Podsumowanie

W ramach ćwiczenia skonfigurowano środowisko Ansible, przeprowadzono inwentaryzację, a następnie wykonano zdalne operacje na maszynie docelowej. Dodatkowo wdrożono i przetestowano aplikację Express w kontenerze Docker z użyciem *playbooka* Ansible, automatyzując cały proces od instalacji zależności po weryfikację działania aplikacji.


## Lab 9 – Pliki odpowiedzi dla wdrożeń nienadzorowanych

### Cel:
Celem ćwiczenia było przygotowanie pliku odpowiedzi Kickstart do automatycznej instalacji systemu Fedora oraz uruchomienie środowiska zawierającego wcześniej zbudowaną aplikację Express w kontenerze Docker.


### 1. Modyfikacja pliku odpowiedzi

Na początku pobraliśmy domyślny plik:

```
sudo cat /root/anaconda-ks.cfg
```
```
sudo cp /root/anaconda-ks.cfg ~/MDO2025_INO/ITE/GCL08/LW417490/Sprawozdanie3
```
![alt text](<Lab8-11/Zrzut ekranu 2025-05-06 190927.png>)
![alt text](<Lab8-11/Zrzut ekranu 2025-05-06 191421.png>)
![alt text](<Lab8-11/Zrzut ekranu 2025-05-06 191555.png>)

Następnie edytowaliśmy plik *anaconda-ks.cfg*:

```
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

# Network information
network  --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate

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
rootpw --iscrypted $y$j9T$Y2uNKEGKUh0c5wMOReuwJFGF$eZWDBrGuNEkfk0GaqdCLCrm1/VAVv7Cg/x38mzpNg3B
user --groups=wheel --name=lwuls --password=$y$j9T$y89ey4hKn6cPnCqRVnU1o21y$16PG868zQ70KxR5Em1IiEGIw0.TFdI8nurhKagmOT.2 --iscrypted --gecos="Lucja Wuls"

# Installation source
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

# System boot settings
firstboot --enable
reboot

# Partitioning
ignoredisk --only-use=sda
clearpart --all --initlabel
autopart

# Package selection
%packages
@^server-product-environment
@headless-management
docker
wget
%end

%post --log=/root/kickstart-post.log

# Skrypt, który pobierze obraz i uruchomi kontener
mkdir -p /opt/express_app
cat << 'EOF' > /opt/express_app/firstboot.sh
#!/bin/bash

# Uruchom docker (na wszelki wypadek)
systemctl start docker

# Pobierz obraz z Docker Huba
docker pull lucyferryt/express-app:latest

# Uruchom kontener w tle z mapowaniem portu
docker run -d --name express-app -p 3000:3000 lucyferryt/express-app:latest

# Wyłącz tę usługę po wykonaniu
systemctl disable express-app-firstboot.service
rm -f /etc/systemd/system/express-app-firstboot.service
rm -f /opt/express_app/firstboot.sh
EOF

chmod +x /opt/express_app/firstboot.sh

# Utwórz usługę systemd, która wykona ten skrypt raz po pierwszym starcie systemu
cat << 'EOF' > /etc/systemd/system/express-app-firstboot.service
[Unit]
Description=Pull and run express-app container on first boot
After=network.target docker.service
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/opt/express_app/firstboot.sh
RemainAfterExit=true
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Włącz usługę, aby odpalała się po starcie systemu
systemctl enable express-app-firstboot.service

# Włącz dockera, aby działał po starcie systemu
systemctl enable docker

%end
```

### 2. Uruchomienie instalacji nienadzorowanej

Kolejnym krokiem było uruchomienie maszyny wirtualnej z przygotownym ISO.
Proces zakończył się powodzeniem, system został zainstalowany automatycznie i skonfigurowany.

![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 142131.png>)
![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 142341.png>)

### 3. Weryfikacja działania systemu i kontenera

Po zakończeniu instalacji i pierwszym uruchomieniu systemu, usługa *express-app-firstboot.service* została aktywowana i uruchomiła kontener.

```
systemctl status express-app-firstboot.service
```

![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 145439.png>)

Po czym zweryfikowano działanie 

```
curl http://localhost:3000
```

![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 145510.png>)

### Podsumowanie

W ramach ćwiczenia przygotowano zautomatyzowaną instalację systemu Fedora Server z wykorzystaniem pliku Kickstart. System po pierwszym uruchomieniu automatycznie uruchamiał aplikację Express w kontenerze Docker.


## Lab 10 – Wdrażanie na zarządzalne kontenery: Kubernetes (1)

### Cel:
Celem laboratorium było uruchomienie klastra Kubernetes z użyciem Minikube, wdrożenie aplikacji kontenerowej oraz przetestowanie jej działania poprzez dashboard.

### 1. Instalacja Minikube i kubectl

Na maszynie lokalnej zainstalowaliśmy Minikube oraz klienta kubectl w wersji zgodnej z aktualną wersją Kubernetesa:

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm
```

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

Po instalacji uruchomiliśmy klaster:

```
minikube start
```

![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 170427.png>)
![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 171034.png>)


### 2. Uruchomienie dashboardu

Następnie uruchomiliśmy interfejs graficzny Kubernetesa:

```
minikube dashboard
```
Po czym otworzyliśmy dashboard w przeglądarce:

![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 171212.png>)


### 3. Uruchomienie aplikacji Express jako pojedynczy pod

Nastepnie uruchomiliśmy kontener z wcześniej przygotowanym obrazem aplikacji *Express*

```
minikube kubectl -- run express-app-pod \
  --image=lucyferryt/express-app \
  --port=3000 \
  --labels app=express-app 
```
```
minikube kubectl -- get pods -l app=express-app
```
![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 171310.png>)
![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 171330.png>)


### 4. Forwardowanie portów i test aplikacji

Kolejnym krokiem było przekierowanie portów:

```
minikube kubectl -- port-forward pod/express-app-pod 8080:3000
```
Po czym sprawdziliśmy poprawne działanie poprzez curl

```
curl http://localhost:3000/
```

![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 171542.png>)


### 5. Stworzenie pliku deploymentu YAML

Następnie przygotowaliśmy plik *express-app-deployment.yml*

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: express-app-deployment
spec:
  replicas: 4
  selector:
    matchLabels:
      app: express-app
  template:
    metadata:
      labels:
        app: express-app
    spec:
      containers:
        - name: express-app
          image: zbogenza/express-app:latest
          ports:
            - containerPort: 3000
```

Kolejno wdrożyliśmy plik:

```
minikube kubectl -- apply -f express-app-deployment.yml
minikube kubectl -- rollout status deployment/express-app-deployment
```

### 6. Eksponowanie serwisu

Po czym utworzono serwis typu *NodePort*:

```
minikube kubectl -- expose deployment express-app-deployment --type=NodePort --port=3000
```

Następnie wykonaliśmy forward:

```
minikube kubectl -- port-forward service/express-app-deployment 8888:3000
```


![alt text](<Lab8-11/Zrzut ekranu 2025-05-21 171744.png>)


### Podsumowanie

W ramach ćwiczenia uruchomiono klaster Minikube, wdrożono aplikację Express jako pojedynczy pod oraz jako deployment z czterema replikami. Przekierowano porty do aplikacji i potwierdzono jej dostępność. Skonfigurowano dashboard i wykonano pełny cykl wdrożenia z użyciem YAML-a.

## Lab 11 – Wdrażanie na zarządzalne kontenery: Kubernetes (2)

### Cel: 
Celem laboratorium było przeprowadzenie pełnego cyklu aktualizacji wdrożenia aplikacji kontenerowej w środowisku Kubernetes, w tym przygotowanie różnych wersji obrazu, testowanie skalowalności, weryfikacja poprawności działania oraz zarządzanie historią wdrożeń.

## 1. Przygotowanie obrazów Dockera

Stworzyliśmy trzy wersje aplikacji:

- *lucyferryt/express-app:1* – wersja bazowa
- *lucyferryt/express-app:2* – wersja stabilna z dodatkowymi danymi
- *lucyferryt/express-app:3* – wersja celowo błędna

Zbudowaliśjmy je przy pomocy poniższych komend:

```
docker build -f newdeploy.Dockerfile -t lucyferryt/express-app:2 .
docker build -f deployerror.Dockerfile -t lucyferryt/express-app:3 .
docker build -f Dockerfile.exppub -t lucyferryt/express-app:1 .
```
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 142533.png>)
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 143336.png>)

Przetestowaliśmy działanie wersji *:2*:

```
docker run -dit --name test -p 3000:3000 lucyferryt/express-app:2
```
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 142745.png>)
```
curl localhost:3000
```
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 142859.png>)
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 142911.png>)

Następnie opublikowaliśmy je na Docker Hub:

```
docker push lucyferryt/express-app:1
docker push lucyferryt/express-app:2
docker push lucyferryt/express-app:3
```
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 143041.png>)

## 2. Wdrożenie do klastra Kubernetes

Kolejnym krokiem było uruchomienie klaster Minikube i dashboard:

```
minikube start
minikube dashboard
```

Aplikację wdrożyliśmy za pomocą pliku YAML:

```
minikube kubectl -- apply -f express-app-deployment.yml
```

## 3. Skalowanie deploymentu

Następna częścią ćwiczenia było testowanie różne wartości replik:

```
kubectl scale deployment express-app-deployment --replicas=8
kubectl scale deployment express-app-deployment --replicas=1
kubectl scale deployment express-app-deployment --replicas=0
kubectl scale deployment express-app-deployment --replicas=4
```

Zmiany były widoczne w dashboardzie. Jak widać pody poprawnie się aktualizowały.

W przypadku 8 replik:
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 145909.png>)
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 145945.png>)

W przypadku 1 repliki:
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 150004.png>)
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 150118.png>)

W przypadku 0 replik:
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 150142.png>)

W przypadku 4 replik:
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 150206.png>)
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 150223.png>)

W przypadku zmieny wersji z *2* na *1*:
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 150350.png>)

## 4. Wersja z błędem

Kolejnym krokiem było zmienienie wersji obrazu w pliku YAML na *:3*
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 150607.png>)

Nowe pody zgłaszały błędy, co potwierdziło wadliwą wersję kontenera.

## 5. Historia i rollback

Po czym sprawdziliśmy historię:

```
minikube kubectl -- rollout history deployment
```
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 150826.png>)

I wykonaliśmy rollback:

```
minikube kubectl -- rollout undo deployment
```
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 150916.png>)
Wersja *:2* została przywrócona i wdrożenie ponownie działało poprawnie.

## 6. Deploy

Następnie stworzyliśmy skrypt *deploy.sh* oraz go wykonaliśmy z uzyciem polecenia:

```
./deploy.sh
```

![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-03 151834.png>)

## 7. Strategie wdrożeń

Na koniec przygotowaliśmy pliki dla 3 różnych strategi wdrożeń

*Canary*:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: express-app-canary
  labels:
    app: express-app
    track: canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: express-app
      version: v2
  template:
    metadata:
      labels:
        app: express-app
        version: v2
    spec:
      containers:
        
name: express-app
        image: lucferryt/express-app:v2
        ports:
containerPort: 3000
```
*Recreate*:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: express-app-recreate
  labels:
    app: express-app
    strategy: recreate
spec:
  replicas: 4
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: express-app
      version: v1
  template:
    metadata:
      labels:
        app: express-app
        version: v1
    spec:
      containers:
        
name: express-app
        image: lucyferryt/express-app:v1
        ports:
containerPort: 3000
```

*Rolling*:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: express-app-rolling
  labels:
    app: express-app
    strategy: rolling
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 30%
  selector:
    matchLabels:
      app: express-app
      version: v1
  template:
    metadata:
      labels:
        app: express-app
        version: v1
    spec:
      containers:
        
name: express-app
        image: lucyferryt/express-app:v1
        ports:
containerPort: 3000
```

Po czym wykonaliśmy  wdrożenia:

```
minikube kubectl -- apply -f Canary.yaml
minikube kubectl -- apply -f Recreate.yaml
minikube kubectl -- apply -f Rolling.yaml
```

![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-04 000018.png>)
![](<Lab8-11/Lab11/Zrzut ekranu 2025-06-04 000253.png>)
![alt text](<Lab8-11/Lab11/Zrzut ekranu 2025-06-04 000419.png>)

A na koniec sprawdziliśmy status wdrożenia:

```
minikube kubectl rollout status deployment/express-app-canary
minikube kubectl rollout status deployment/express-app-recreate
minikube kubectl rollout status deployment/express-app-rolling
```

## Podsumowanie:
W trakcie ćwiczeń z powodzeniem przygotowaliśmy i wdrożyliśmy różne strategie aktualizacji aplikacji w Kubernetes, umożliwiające elastyczne zarządzanie cyklem życia kontenerów. Przeprowadzone testy skalowalności, rollbacków oraz walidacja błędnych wersji potwierdziły stabilność i kontrolę procesu wdrażania.