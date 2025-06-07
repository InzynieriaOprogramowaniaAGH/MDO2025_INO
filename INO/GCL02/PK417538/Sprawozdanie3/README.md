# Raport laboratoryjny: Automatyzacja IT i orkiestracja kontenerów

## Laboratoria 8-11


# Lab 08 - Zarządzanie infrastrukturą z Ansible

## Zakres prac

Laboratorium koncentrowało się na wdrożeniu systemu automatycznego zarządzania serwerami przy użyciu Ansible:

-   Przygotowanie środowiska zarządzającego
-   Konfiguracja komunikacji między maszynami
-   Automatyzacja zadań administracyjnych
-   Konteneryzacja aplikacji przy użyciu Docker

## 1. Konfiguracja środowiska zarządzającego

### Przygotowanie infrastruktury

Zbudowano laboratoryjną infrastrukturę składającą się z dwóch maszyn wirtualnych:

-   **serwer** - węzeł kontrolny z Ansible
-   **ansible-target** - węzeł zarządzany

### Konfiguracja węzła zarządzanego

Skonfigurowano minimalną instalację Ubuntu 24.04 LTS z niezbędnymi usługami:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y tar openssh-server
sudo systemctl status ssh
sudo systemctl enable ssh
```

### Instalacja narzędzia automatyzacji

Na węźle kontrolnym zainstalowano Ansible:

```bash
sudo apt update && sudo apt install -y ansible
ansible --version
```

### Bezpieczna autoryzacja

Skonfigurowano uwierzytelnianie oparte na kluczach kryptograficznych:

```bash
ssh-keygen -t rsa -b 4096 -C "user@server"
ssh-copy-id user@192.168.56.101
ssh user@192.168.56.101
```
![obraz](https://github.com/user-attachments/assets/920c590e-94c6-4861-8f1b-83b8e5ccec71)

![obraz](https://github.com/user-attachments/assets/57cedd67-f022-4cd7-b998-795c3e1ecd06)

## 2. Rejestr hostów

### Aktualizacja rozdzielczości nazw

Zmodyfikowano lokalną bazę nazw w pliku `/etc/hosts`:

```bash
sudo nano /etc/hosts
```
![obraz](https://github.com/user-attachments/assets/65ed62fc-5388-4c60-b1e3-9265a7a1f7e4)

### Test łączności

Zweryfikowano komunikację sieciową między węzłami:

```bash
ping ansible-target
ping serwer
```

![obraz](https://github.com/user-attachments/assets/85c0c75c-5b93-461b-94d6-34e4c81770bc)

### Definicja inwentarza

Utworzono plik `inventory.ini` opisujący topologię infrastruktury:

```ini
[Orchestrators]
serwer ansible_connection=local

[Endpoints]
ansible-target ansible_host=ansible-target ansible_user=user
```

### Weryfikacja dostępności

Przetestowano komunikację z węzłami przez Ansible:

```bash
ansible -i inventory.ini all -m ping
```

![obraz](https://github.com/user-attachments/assets/88956cc4-d7c5-4c38-9248-fb7328a8d22d)

## 3. Automatyzacja procedur

### Podstawowy playbook testowy

Stworzono `ping.yml` do weryfikacji połączeń:

```yaml
---
- hosts: all
  gather_facts: false
  tasks:
    - name: Test connection with ping module
      ansible.builtin.ping:
```

Uruchomienie testu:

```bash
ansible-playbook -i inventory.ini ping.yml
```

![obraz](https://github.com/user-attachments/assets/a1c054fe-f4f9-4817-9fb4-81bcc8d04f9c)

### Dystrybucja plików

Opracowano playbook do rozprowadzania konfiguracji:

```
---
- hosts: Endpoints
	gather_facts: false
	tasks:
	- name: Copy inventory file to remote host
		copy:
			src: inventory.ini
			dest: /tmp/inventory.ini
			owner: user
			group: user
			mode: '0644'
```

Realizacja transferu:

```bash
ansible-playbook -i inventory.ini copy-inventory.yml
```

![obraz](https://github.com/user-attachments/assets/6c2f509c-7adc-45c3-937b-8a0079c28365)

### Automatyzacja aktualizacji

Przygotowano procedurę utrzymania systemu:

```yaml
---
- hosts: Endpoints
  become: true
  tasks:
    - name: Update APT package cache
      apt:
        update_cache: yes
        cache_valid_time: 3600

    - name: Upgrade all packages to latest version
      apt:
        upgrade: dist
        autoremove: yes
        autoclean: yes
```

Wykonanie aktualizacji:

```bash
ansible-playbook -i inventory.ini update-system.yml --ask-become-pass
```

### Zarządzanie usługami

Stworzono procedurę kontroli usług systemowych:

```yaml
---
- hosts: Endpoints
  become: true
  tasks:
    - name: Restart SSH service
      service:
        name: ssh
        state: restarted
      notify: SSH restarted

    - name: Restart rngd service (ignore if not present)
      service:
        name: rngd
        state: restarted
      ignore_errors: true
      
  handlers:
    - name: SSH restarted
      debug:
        msg: "SSH service has been restarted"
```

Restart usług:

```bash
ansible-playbook -i inventory.ini restart-services.yml
```

![obraz](https://github.com/user-attachments/assets/63d901b1-bd9f-4ec1-8a50-c9bc293bca27)

### Symulacja awarii

Sprawdzono zachowanie systemu podczas niedostępności węzła:

```bash
sudo systemctl stop ssh.socket ssh

ansible-playbook -i inventory.ini ping.yml
```

![obraz](https://github.com/user-attachments/assets/93acc993-296b-4f79-ac29-05b56aa1f9c6)

## 4. Konteneryzacja aplikacji

### Struktura roli automatyzacji

Utworzono wyspecjalizowaną rolę do zarządzania aplikacjami:

```bash
ansible-galaxy init manage_artifact
```

![obraz](https://github.com/user-attachments/assets/10316474-3b64-49fd-b816-8e00e33db5a6)

### Główna procedura wdrożenia

Przygotowano `playbook.yml` wykorzystujący utworzoną rolę:

```yaml
---
- hosts: Endpoints
  become: true
  roles:
    - manage_artifact
```

### Logika roli zarządzającej

W `roles/manage_artifact/tasks/main.yml` zdefiniowano kompletny proces:

```yaml
---
- name: Install Docker dependencies
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
    repo: "deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ ansible_distribution_release }} stable"
    state: present

- name: Install Docker
  apt:
    name: docker-ce
    state: present
    update_cache: yes

- name: Start and enable Docker service
  systemd:
    name: docker
    state: started
    enabled: yes

- name: Verify Docker installation
  command: docker --version
  register: docker_version

- name: Display Docker version
  debug:
    var: docker_version.stdout

- name: Create application directory
  file:
    path: /opt/myapp
    state: directory
    mode: '0755'

- name: Copy application files
  copy:
    src: "{{ item }}"
    dest: /opt/myapp/
  with_items:
    - app.py
    - requirements.txt

- name: Copy Dockerfile
  copy:
    src: Dockerfile
    dest: /opt/myapp/Dockerfile

- name: Build Docker image
  docker_image:
    name: myapp
    tag: latest
    source: build
    build:
      path: /opt/myapp

- name: Run application container
  docker_container:
    name: myapp-container
    image: myapp:latest
    state: started
    ports:
      - "5000:5000"
    restart_policy: always

```

### Realizacja wdrożenia

Uruchomiono automatyczne wdrożenie konteneryzowanej aplikacji:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

----------


# Lab 09 - Automatyczne instalacje systemów

## Zakres prac

Laboratorium dotyczyło tworzenia nienadzorowanych instalacji systemu Fedora 42 przy użyciu mechanizmu Kickstart, który eliminuje konieczność ręcznej interakcji podczas procesu instalacyjnego.

## Przygotowanie skryptu automatyzacji

Stworzono plik `fedora-auto.ks` ma podstawie pliku `anaconda-ks.cfg` z zainstalowanej fedory zawierający kompletną konfigurację:

```bash
# Generated by Anaconda 42.27.12
# Generated by pykickstart v3.62
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

network --hostname=fedora.local

# Generated using Blivet version 3.12.1
ignoredisk --only-use=sda
clearpart --all --initlabel
autopart

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw fedora

# User account
user --groups=wheel --name=fedora --password=fedora --gecos="fedora"
```

![obraz](https://github.com/user-attachments/assets/d5830849-8967-42cf-94ab-36c533fbd031)

![obraz](https://github.com/user-attachments/assets/a558e391-437b-4cdb-8954-e45b6eadfe9b)

## Realizacja instalacji automatycznej


### Optymalizacja dostępu do konfiguracji

Zastosowano usługę skracania linków TinyURL:

Link oryginalny:

```
https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/refs/heads/PK417538/INO/GCL02/PK417538/Sprawozdanie3/fedora-auto.ks
```

Link zoptymalizowany:

```
https://tinyurl.com/mrstzyf2
```

![obraz](https://github.com/user-attachments/assets/c6e3fb88-069f-4b51-abf3-68e46c8a35fd)

### Konfiguracja parametrów rozruchu

W menu GRUB wprowadzono parametr wskazujący lokalizację skryptu:

```
inst.ks=https://tinyurl.com/mrstzyf2
```

![obraz](https://github.com/user-attachments/assets/03214813-1488-4c03-9795-e1ecdc01c76a)

### Przebieg instalacji nienadzorowanej

Proces instalacji odbywał się automatycznie zgodnie ze skryptem. Nie była potrzebna ingerencja użytkownika, wszystkie parametry ustawiły się samoczynnie.

![obraz](https://github.com/user-attachments/assets/28521a1f-93e2-4317-866d-251786b96fc6)

![obraz](https://github.com/user-attachments/assets/58f65dc4-6658-4e76-a2ce-e7f3d4aea4a4)

----------
# Lab 10 - Wprowadzenie do orkiestracji kontenerów

## Zakres prac

Laboratorium wprowadzało do zarządzania kontenerami w środowisku rozproszonym poprzez:

-   Konfigurację lokalnego klastra orkiestracyjnego
-   Wdrażanie pierwszej aplikacji kontenerowej
-   Zapoznanie z podstawowymi obiektami orkiestracji
-   Wykorzystanie interfejsu graficznego do zarządzania

## Instalacja platformy orkiestracyjnej

### Wybór technologii

Wykorzystano Minikube - lokalną implementację Kubernetes, umożliwiającą pełne testowanie funkcjonalności bez infrastruktury chmurowej.

### Pozyskanie i instalacja

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```
```bash
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube version
```

![obraz](https://github.com/user-attachments/assets/1bc460f4-c25f-4915-bc25-8afb12e0e6c8)

### Inicjalizacja klastra

```bash
minikube start --driver=docker --cpus=2 --memory=2048
```

-   Sterownik Docker jako środowisko wykonawcze
-   Alokacji 2 rdzeni CPU i 2GB pamięci RAM
-   Automatyczne pobieranie obrazów systemowych

![obraz](https://github.com/user-attachments/assets/e1392a81-af1d-4af6-aa25-8a68acb10818)

### Weryfikacja środowiska

```bash
minikube kubectl -- get namespaces

minikube kubectl -- get clusterrolebindings
```

![obraz](https://github.com/user-attachments/assets/dbbb2a99-1e92-49a4-979f-d31ec199508c)

### Inspekcja certyfikatów bezpieczeństwa

```bash
minikube ssh

ls /var/lib/minikube/certs/
```


![obraz](https://github.com/user-attachments/assets/f9353629-762d-4968-a410-f7550ca1e8fa)

## Panel administracyjny

### Uruchomienie interfejsu webowego

```bash
minikube dashboard
```

![obraz](https://github.com/user-attachments/assets/84c7359e-cab1-45b8-9c81-3e18e4f15279)

### Interfejs zarządzania

![obraz](https://github.com/user-attachments/assets/2a401952-e292-4076-a7ef-50d1c9ec83df)




## Pierwsze wdrożenie aplikacji

### Utworzenie instancji kontenerowej

```bash
minikube kubectl -- run moja-aplikacja --image=nginx --port=80 --labels app=moja-aplikacja
```

### Monitorowanie stanu

```bash
minikube kubectl -- get pods
```
Kontener został utworzony i znajduje się w stanie "Running", co oznacza poprawne działanie aplikacji nginx.

### Udostępnienie aplikacji

```bash
minikube kubectl -- port-forward pod/moja-aplikacja 8080:80
```

![obraz](https://github.com/user-attachments/assets/3849f6c0-d3d9-4ceb-966e-1577e456e54d)

### Weryfikacja dostępności

Aplikacja została przetestowana przez otwarcie adresu `http://localhost:8080`:

Aplikacja nginx odpowiada poprawnie, potwierdzając funkcjonowanie przekierowania portów i komunikacji z kontenerem.

![obraz](https://github.com/user-attachments/assets/999ec6af-9114-4e04-a8a5-feec1a7bd1fb)

## Zaawansowane obiekty orkiestracji

### Przygotowanie manifestu

Stworzono plik `nginx-deployment.yml` definiujący zaawansowane wdrożenie:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
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
        image: nginx:latest
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080

```

### Aplikacja konfiguracji

```bash
minikube kubectl -- apply -f nginx-deployment.yml
```
Deployment i Service zostały pomyślnie utworzone, co potwierdza status "created".

![obraz](https://github.com/user-attachments/assets/e0f7aa9b-4b08-49e2-83cc-453a1ffef71d)

### Monitorowanie procesu wdrożenia

```bash
minikube kubectl -- rollout status deployment/nginx-deployment
```
Wdrożenie zakończono pomyślnie - wszystkie 4 repliki są funkcjonalne i gotowe do obsługi ruchu.

![obraz](https://github.com/user-attachments/assets/824efa38-01f4-4441-b443-c02bda30f631)

### Weryfikacja środowiska produkcyjnego

```bash
minikube kubectl -- get pods

minikube kubectl -- get services

minikube service nginx-service --url
```
-   Wszystkie 4 kontenery są aktywne
-   Usługa nginx-service jest dostępna na porcie 30080
-   Load balancer działa poprawnie między replikami

![obraz](https://github.com/user-attachments/assets/b48d5609-a72f-4590-aeb0-489917f09f9e)

### Test usługi load balancingowej

Aplikacja jest osiągalna przez Service, co potwierdza poprawne funkcjonowanie rozproszenia ruchu między kontenerami.

![obraz](https://github.com/user-attachments/assets/0c50a147-3e05-497f-b9ca-fa9077412157)

----------
# Lab 11 - Zaawansowane techniki deploymentu

## Zakres prac

Laboratorium koncentrowało się na zaawansowanych aspektach zarządzania aplikacjami:

-   Kontrola wersji aplikacji w środowisku produkcyjnym
-   Różne strategie aktualizacji systemów
-   Mechanizmy przywracania poprzednich wersji
-   Monitorowanie i diagnostyka wdrożeń

## Przygotowanie repozytorium obrazów

### Organizacja projektu

```bash
mkdir my-nginx && cd my-nginx
mkdir my-custom-content
```

### Definicja kontenera

Stworzono `Dockerfile` z niestandardową konfiguracją:

```dockerfile
FROM nginx:alpine

COPY my-custom-content/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

```

![obraz](https://github.com/user-attachments/assets/cbe9d9b3-f84c-4bf6-afda-4644453b8f6b)

### Budowa wersji pierwszej

```bash
echo "<h1>Hello, this is my custom Nginx page - Version 1!</h1>" > my-custom-content/index.html

docker build -t kefireczek/my-nginx:v1 .

docker login

docker push kefireczek/my-nginx:v1
```

![obraz](https://github.com/user-attachments/assets/5e637e67-5ff4-4087-a8df-731dcf18aba4)

Pierwsza wersja aplikacji została pomyślnie zbudowana i opublikowana w Docker Hub.

### Rozwój wersji drugiej

```bash
echo "<h1>Hello, this is my custom Nginx page - Version 2 (Updated)!</h1>" > my-custom-content/index.html

docker build -t iogougou/my-nginx:v2 .
docker push iogougou/my-nginx:v2
```
Druga wersja z zaktualizowaną zawartością została udostępniona w rejestrze.

![obraz](https://github.com/user-attachments/assets/a125f159-13b2-41cd-b791-9891f514851b)

### Symulacja wersji problemowej

```bash
echo "invalid_nginx_config_directive_error" > my-custom-content/nginx.conf

docker build -t iogougou/my-nginx:v3 .
docker push iogougou/my-nginx:v3
```
Trzecia wersja została celowo przygotowana z defektami do testowania procedur naprawczych.

![obraz](https://github.com/user-attachments/assets/812524c8-83e9-42ac-986a-b1c5fcd753de)

## Zarządzanie cyklem życia aplikacji

### Manifest wdrożeniowy

Przygotowano `nginx-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-deployment
  labels:
    app: my-nginx
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: my-nginx
  template:
    metadata:
      labels:
        app: my-nginx
    spec:
      containers:
      - name: nginx
        image: iogougou/my-nginx:v1
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
---
apiVersion: v1
kind: Service
metadata:
  name: my-nginx-service
spec:
  selector:
    app: my-nginx
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30081
```

### Inicjalne wdrożenie

```bash
kubectl apply -f nginx-deployment.yaml
```

![obraz](https://github.com/user-attachments/assets/77ac6f05-2d68-4fc8-85eb-dffaec03d1fb)

### Aktualizacja do wersji stabilnej

```bash
kubectl set image deployment/my-nginx-deployment nginx=iogougou/my-nginx:v2

kubectl rollout status deployment/my-nginx-deployment
```

Aktualizacja do drugiej wersji przebiegła pomyślnie z wykorzystaniem strategii stopniowej wymiany.

### Test wdrożenia problematycznego

```bash
kubectl set image deployment/my-nginx-deployment nginx=iogougou/my-nginx:v3

kubectl rollout status deployment/my-nginx-deployment
```

### Analiza historii wdrożeń

```bash
kubectl rollout history deployment/my-nginx-deployment
```

Historia dokumentuje wszystkie wykonane aktualizacje z możliwością powrotu do dowolnej wersji.

### Procedura naprawcza

```bash
kubectl rollout undo deployment/my-nginx-deployment

kubectl rollout status deployment/my-nginx-deployment
```
Procedura naprawcza przywróciła aplikację do stabilnej wersji v2, eliminując problemy z v3.

![obraz](https://github.com/user-attachments/assets/17c7ab9c-c9cd-45c7-8cf2-2d4ef70d8081)

## Operacje eksploatacyjne

### Skalowanie aplikacji

```bash
kubectl scale deployment my-nginx-deployment --replicas=5

kubectl get pods
```

![obraz](https://github.com/user-attachments/assets/a8e9b047-19c8-4591-a78e-759c1bf4b49f)
![obraz](https://github.com/user-attachments/assets/5c13dc60-3759-4eda-9b05-7fc286b944fb)
![obraz](https://github.com/user-attachments/assets/9bd81baa-8540-4f1a-bd86-d66fff0776da)

### Skrypt do automatycznej kontroli wdrożenia

Przygotowano plik verify-deployment.sh, który umożliwia szybkie i zautomatyzowane sprawdzenie, czy wszystkie zasoby aplikacji funkcjonują prawidłowo.

```bash
#!/bin/bash

echo "1. Aktualny status Deploymentu:"
kubectl get deployment my-nginx-deployment

echo "2. Aktywne pody:"
kubectl get pods -l app=my-nginx

echo "3. Informacje o serwisie:"
kubectl get service my-nginx-service

echo "4. Test połączenia HTTP z aplikacją:"
MINIKUBE_IP=$(minikube ip)
SERVICE_PORT=$(kubectl get service my-nginx-service -o jsonpath='{.spec.ports[0].nodePort}')
curl -s http://$MINIKUBE_IP:$SERVICE_PORT | head -1
```

```
chmod +x verify-deployment.sh
./verify-deployment.sh
```

![obraz](https://github.com/user-attachments/assets/afc2eced-ab3b-4e13-96ab-4f685716d69c)

## Strategie wdrożenia

### Strategia 1: Recreate
Przygotowano plik `Recreate.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-recreate
  labels:
    app: nginx-recreate
spec:
  replicas: 3
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nginx-recreate
  template:
    metadata:
      labels:
        app: nginx-recreate
    spec:
      containers:
      - name: nginx
        image: iogougou/my-nginx:v1
        ports:
        - containerPort: 80
```

**Opis strategii Recreate**:
- Zanim zostaną uruchomione nowe instancje aplikacji (pody), wszystkie dotychczasowe są najpierw całkowicie usuwane.
- Nowe pody zostają utworzone dopiero po zakończeniu usuwania starych.
- Może to skutkować chwilowym wyłączeniem dostępności aplikacji.
- Dzięki temu unika się problemów związanych z jednoczesnym działaniem różnych wersji aplikacji.

### Strategia 2: RollingUpdate
Przygotowano plik `RollingUpdate.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-rolling-update
  labels:
    app: nginx-rolling
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: nginx-rolling
  template:
    metadata:
      labels:
        app: nginx-rolling
    spec:
      containers:
      - name: nginx
        image: iogougou/my-nginx:v1
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
```

**Opis strategii RollingUpdate**:
- Aktualizacja aplikacji odbywa się płynnie poprzez sukcesywne zastępowanie starych podów nowymi.
- Aplikacja jest dostępna przez cały proces wdrażania.
- Ustawienia maxUnavailable i maxSurge definiują, ile podów może być niedostępnych lub więcej niż zadeklarowano w czasie aktualizacji.
- Jest to domyślny sposób wdrażania zmian w Kubernetes.

### Strategia 3: Canary Deployment
Przygotowano plik `Canary.yaml` z dwoma deploymentami:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-canary-main
  labels:
    app: nginx-canary
    version: stable
spec:
  replicas: 9
  selector:
    matchLabels:
      app: nginx-canary
      version: stable
  template:
    metadata:
      labels:
        app: nginx-canary
        version: stable
    spec:
      containers:
      - name: nginx
        image: iogougou/my-nginx:v1
        ports:
        - containerPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-canary-new
  labels:
    app: nginx-canary
    version: canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-canary
      version: canary
  template:
    metadata:
      labels:
        app: nginx-canary
        version: canary
    spec:
      containers:
      - name: nginx
        image: iogougou/my-nginx:v2
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-canary-service
spec:
  selector:
    app: nginx-canary
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30082
```


**Opis strategii Canary**:
- Nowa wersja aplikacji jest wdrażana tylko dla wybranej części użytkowników.
- Pozwala to na przetestowanie aktualizacji w środowisku produkcyjnym przy minimalnym ryzyku.
- Gdy działanie nowej wersji okaże się stabilne, ruch użytkowników jest stopniowo kierowany do niej w coraz większym zakresie
- Taki proces wymaga dodatkowej konfiguracji m.in. dla serwisów i trasowania ruchu.

### Zastosowanie wszystkich strategii
```bash
kubectl apply -f Recreate.yaml

kubectl apply -f RollingUpdate.yaml

kubectl apply -f Canary.yaml

kubectl get deployments -n default
```

![obraz](https://github.com/user-attachments/assets/8e1b01b6-343a-48a1-afdf-960089c16479)
![obraz](https://github.com/user-attachments/assets/f859db56-d26a-4d03-86c4-880662869d75)

| Strategia       | Opis                                                                 | Czas niedostępności | Bezpieczeństwo wdrożenia | Stopniowe wdrażanie | Cofnięcie zmian (Rollback) |
|------------------|----------------------------------------------------------------------|----------------------|---------------------------|----------------------|-----------------------------|
| **Recreate**     | Najpierw usuwa stare instancje, potem wdraża nowe                   | ✅ Tak               | ❌ Ryzykowne               | ❌ Nie               | ❌ Trudne lub niemożliwe     |
| **RollingUpdate**| Stopniowo zastępuje stare instancje nowymi                         | ❌ Brak              | ✅ Umiarkowane              | ✅ Tak               | ✅ Możliwe                  |
| **Canary**       | Wdraża nową wersję do części użytkowników, potem zwiększa udział    | ❌ Brak              | ✅ Wysokie                  | ✅ Tak               | ✅ Łatwe i bezpieczne       |
