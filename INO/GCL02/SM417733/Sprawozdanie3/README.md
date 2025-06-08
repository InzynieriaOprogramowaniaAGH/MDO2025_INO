# Sprawozdanie 3
Szymon Majdak
## Laboratorium nr 8 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible
Do tych zajęć wykorzystałem maszynę wirtualną stworzoną kickstartem na laboratoriach nr 9.

### Instalacja zarządcy Ansible

Na tej maszynie pobrałem oprogramowanie `tar` i `sshd`.

![1](https://github.com/user-attachments/assets/8b4c2a97-1ad2-422e-96a8-4052c087ad8c)

Następnie uruchomiłem `sshd`, stowrzyłem urzytkownika `ansible` oraz zmieniłem nazwę hosta na `ansible-target` komendami:

```sudo systemctl enable --now sshd```

```sudo useradd -m -s /bin/bash ansible```

```sudo passwd ansible```

```sudo hostnamectl set-hostname ansible-target```

![3](https://github.com/user-attachments/assets/944ec438-8b98-4bc4-9f62-fb2a81c5a376)

Po tym stworzyłem migawkę maszyny:

![4](https://github.com/user-attachments/assets/65238f78-6fe1-46d2-a5fb-a5af2aab9ead)

Następnie pobrałem oprogramowanie `ansible`:

![5](https://github.com/user-attachments/assets/9535a4bd-5829-47fb-bd22-3580b86e4454)

Finalnie wymieniłem klucze SSH między oboma maszynami tak, aby nie było wymagane podawanie hasła:

![6](https://github.com/user-attachments/assets/1bb621f9-28e1-40b4-8842-8958fb1af248)

![7](https://github.com/user-attachments/assets/290ac561-cde8-49be-844e-ca86b2f2a6e6)

Efekt:
![8](https://github.com/user-attachments/assets/b0128280-12e8-4493-bb6b-7ed97a04db8e)

### Inwentaryzacja

Ustawiłem nazwy hosta `orchestrator` oraz `endpoint1` za pomocą `hostnamectl`.

![9](https://github.com/user-attachments/assets/8859c952-8e8f-44c7-a4d5-4b16eac06e63)

![10](https://github.com/user-attachments/assets/ef5a5b3c-c8fe-496c-8ffa-654a3f2a2a19)

Wprowadziłem też nazwy DNS do maszyn wirtualnych, przez co mogłem wywoływać te maszyny po ich nazwach, a nie po adresach IP.

![11](https://github.com/user-attachments/assets/788de8a5-38ca-49e7-b48e-76ee75bae9d5)

Zweryfikowałem łączność:
![12](https://github.com/user-attachments/assets/21e75f69-fbb0-4166-98cd-7104db4ff2e4)

Następnie stworzyłem plik inwentaryzacji `inventory.ini`, do którego dodałem sekcje Orchestrators i Endpoint i uzupełniłem je moimi nazwami hostów.

Inventory.ini:
```
[Orchestrators]
orchestrator

[Endpoints]
endpoint1
```

Wysłałem pinga do Wszystkich Endpointów:

![14](https://github.com/user-attachments/assets/19094458-2715-40e5-a96b-e0c02ea5209b)

### Zdalne wywoływanie procedur

W tym kroku stworzyłem `playbook-ansible`, który:
- wysyła żądanie ping do wszystkich maszyn
- kopiuje plik `inventory.ini` na endpointy
- wyświetla zawartość `inventory.ini` na zdalnej maszynie
- wypisuje zawartość `inventory.ini`
- aktualizuje wszystkie pakiety
- restartuje usługę sshd
- restartuje usługę rngd

`playbook.yml`:
```
- name: Procedury zdalne
  hosts: Endpoints
  become: true

  tasks:
    - name: Test ping (czy host jest dostępny)
      ansible.builtin.ping:

    - name: Skopiuj plik inventory.ini na endpointy
      ansible.builtin.copy:
        src: ./inventory.ini
        dest: /home/ansible/inventory.ini
        owner: ansible
        group: ansible
        mode: '0644'

    - name: Wyświetl zawartość inventory.ini na zdalnej maszynie
      ansible.builtin.command: cat /home/ansible/inventory.ini
      register: inventory_cat

    - name: Wypisz zawartość inventory.ini
      ansible.builtin.debug:
        var: inventory_cat.stdout_lines

    - name: Aktualizuj wszystkie pakiety
      ansible.builtin.dnf:
        name: "*"
        state: latest
        update_cache: yes

    - name: Restartuj usługę sshd
      ansible.builtin.service:
        name: sshd
        state: restarted
        enabled: true

    - name: Restartuj usługę rngd
      ansible.builtin.service:
        name: rngd
        state: restarted
        enabled: true
```

Efekt uruchomienia `playbook.yml`

![15](https://github.com/user-attachments/assets/0f84dd1e-c448-4735-8e84-3afb7bd64661)

Następnie komendą `sudo systemctlstop sshd` zatrzymałem tą usługę i jeszcze raz uruchomiłem playbook:

![16](https://github.com/user-attachments/assets/f35c81f8-70cd-4ed1-b7ac-ad0c5f46a9e2)

Zgodnie z oczekiwaniem połączenia nie było.

### Zarządzanie stworzonym artefaktem

Ostatnim zadniem było stworzenie playbooka, który:
- buduje i urzuchamia kontener z redisem z poprzednich zajęć, który jest na DockerHubie
- zweryfikuje łączność z kontenerem
- zatrzyma i usunie kontener

`playbook-redis.yml`:
```
- name: Deploy docker container from Docker Hub
  hosts: Endpoints
  become: true

  vars:
    docker_package: docker
    docker_service: docker
    image_name: pszemo6/redis_runtime:4
    container_name: redis_runtime_test

  tasks:

    - name: Zainstaluj wymagane pakiety
      dnf:
        name: "{{ item }}"
        state: present
      loop:
        - dnf-plugins-core
        - docker
        - python3-docker

    - name: Włącz i uruchom usługę docker
      service:
        name: "{{ docker_service }}"
        state: started
        enabled: true

    - name: Pobierz obraz Dockera z Docker Hub
      community.docker.docker_image:
        name: "{{ image_name }}"
        source: pull

    - name: Uruchom kontener
      community.docker.docker_container:
        name: "{{ container_name }}"
        image: "{{ image_name }}"
        state: started
        restart_policy: unless-stopped
        ports:
          - "6379:6379"

    - name: Poczekaj chwilę na start kontenera
      wait_for:
        port: 6379
        delay: 2
        timeout: 10

    - name: Zweryfikuj, że kontener działa
      shell: docker ps --filter "name={{ container_name }}" --format "{{ '{{' }}.Status{{ '}}' }}"
      register: container_status

    - name: Pokaż status kontenera
      debug:
        msg: "Kontener działa: {{ container_status.stdout }}"

    - name: Zatrzymaj kontener
      community.docker.docker_container:
        name: "{{ container_name }}"
        state: stopped

    - name: Usuń kontener
      community.docker.docker_container:
        name: "{{ container_name }}"
        state: absent
```

Wynik:

![18](https://github.com/user-attachments/assets/af2dd360-2a4b-45ee-b453-8737b76dfaa1)

## Pliki odpowiedzi dla wdrożeń nienadzorowanych

Te zajęcia polegałe na zautomatyzowaniu tworzenia nowej maszyny wirtualnej. Takim ułatwieniem w Fedorze jest plik `anaconda-ks.cfg`, który zapisuje wstępne ustawienia systemu.

Pierwszym zadaniem było uruchomienie nowej maszyny wirtualnej z wykorzystaniem dostosowanego pliku `anacond-ks.cfg`.

Najpierw skopiowałem ten plik z maszyny wirtualnej i dodałem go do repozytorium.

W samym pliku dodałem takie linijki jak:
- linki do danej wersji Fedory
- dostosowaną wielkość dysku
- `clearpart --all --initlabel` formatowanie całości
- `reboot` po instalacji

`anaconda-ks.cfg`:
```
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

# Network information
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=Sombrero

%packages
@^server-product-environment

%end

# Run the Setup Agent on first boot
firstboot --enable

url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part /boot/efi --fstype="efi" --ondisk=sda --size=600 --fsoptions="umask=0077,shortname=winnt"
part /boot --fstype="ext4" --ondisk=sda --size=1024
part pv.48 --fstype="lvmpv" --ondisk=sda --size=8500
volgroup fedora_sombrero --pesize=4096 pv.48
logvol / --fstype="ext4" --grow --maxsize=71680 --size=1024 --name=root --vgname=fedora_sombrero

# System timezone
timezone Europe/Warsaw --utc

#Root password
rootpw --lock
user --groups=wheel --name=smajdak --password=$y$j9T$/bahs7W/A48Fb5cEsqnjNQA8$pTZq9vCbm6BxiOnnwluu5fxSp1t1I87suGAB8.9rlh9 --iscrypted --gecos="Szymon Majdak"

reboot
```

Aby skorzystać z tego pliku, podczas instalacji najechałem na przycisk do instalacji Fedory i nacisnąłem `E`. W otwrym oknie dopisałem skąd instalator ma wziąć plik:

![3](https://github.com/user-attachments/assets/009f5e02-dc6b-45fe-9b9e-2f41b3cf704e)

Wyniki:
![5](https://github.com/user-attachments/assets/8982916b-7b99-47f5-975a-366516c98097)

![7](https://github.com/user-attachments/assets/993516dd-158e-4fce-8286-96b47dd63d3f)

![8](https://github.com/user-attachments/assets/a6d12318-da3c-4888-8150-235a5e53e01d)

Drugą wersją tego zadania było uzupełnienie pliku `anaconda-ks.cfg` o pobranie i uruchomienie mojego kontenera z redisem z poprzednich zajęć.

`anaconda-ks-redis.cfg`:
```
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

# Network information
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=Sombrero

%packages
@^server-product-environment

%end

# Run the Setup Agent on first boot
firstboot --enable

url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64
repo --name=docker-ce --baseurl=https://download.docker.com/linux/fedora/41/x86_64/stable

%packages
@^server-product-environment
docker-ce
docker-ce-cli
containerd.io
%end

%post --log=/root/ks-post.log
systemctl enable docker

mkdir -p /opt/scripts

cat > /opt/scripts/start-redis.sh << 'EOF'
#!/bin/bash
sleep 10
docker run -d --name redis --restart=always -p 6379:6379 pszemo6/redis_runtime:4
EOF

chmod +x /opt/scripts/start-redis.sh

cat > /etc/systemd/system/start-redis-container.service << 'EOF'
[Unit]
Description=Start Redis container from Docker Hub
After=network-online.target docker.service
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/opt/scripts/start-redis.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl enable start-redis-container.service
%end

# Run the Setup Agent on first boot
firstboot --enable

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part /boot/efi --fstype="efi" --ondisk=sda --size=600 --fsoptions="umask=0077,shortname=winnt"
part /boot --fstype="ext4" --ondisk=sda --size=1024
part pv.48 --fstype="lvmpv" --ondisk=sda --size=8500
volgroup fedora_sombrero --pesize=4096 pv.48
logvol / --fstype="ext4" --grow --maxsize=71680 --size=1024 --name=root --vgname=fedora_sombrero

# System timezone
timezone Europe/Warsaw --utc

#Root password
rootpw --lock
user --groups=wheel --name=smajdak --password=$y$j9T$/bahs7W/A48Fb5cEsqnjNQA8$pTZq9vCbm6BxiOnnwluu5fxSp1t1I87suGAB8.9rlh9 --iscrypted --gecos="Szymon Majdak"

reboot
```

Wynik:
![image](https://github.com/user-attachments/assets/c1b8969a-65b5-4049-9f2f-032013b3b091)

## Wdrażanie na zarządzalne kontenery: Kubernetes (1)

### Instalacja klastra Kubernetes

Najpierw zaopatrzyłem się w `minikube`, korzystając z instrukcji dostępnej na oficjalnej stronie.

![7](https://github.com/user-attachments/assets/26c96d7b-bf13-4e9c-8cb4-a64ff070b173)

![8](https://github.com/user-attachments/assets/be3d92f3-1f5f-469f-ba08-b4897ecca3ae)

Aby korzystać z polecenia `kubectl` używłem aliasu:

```
alias kubectl="minikube kubectl  --"
```

Następnie uruchomiłem `minikube` komendą `minikube start` i sprawdziłem czy działa:

![10](https://github.com/user-attachments/assets/360d2f50-9a12-412b-b300-936f1f7f5a28)

![11](https://github.com/user-attachments/assets/912d2cb2-219a-46d2-b8b3-f99945e0b727)

![13](https://github.com/user-attachments/assets/908a5969-9437-4614-9244-3b819707d23f)

![14](https://github.com/user-attachments/assets/96afb47a-bc61-4926-9d42-9433832f0287)

Nastepnie uruchomiłem Dashboard:

![15](https://github.com/user-attachments/assets/56dc3351-e264-4962-934b-528c0f7c2d44)

### Analiza posiadanego kontenera

Tą sekcję zrealizowałem już w ramach poprzedniego sprawozdania, ponieważ mój redis jest już w kontenerze na DockerHubie.

### Uruchamianie oprogramowania

Zaaplikowałem go komendą `kubectl run` i sprawdziłem czy poprawnie się uruchomił na dashboardzie i za pomocą kubectl:

![image](https://github.com/user-attachments/assets/252b72df-877d-45ab-821e-49cf18e53568)

![image](https://github.com/user-attachments/assets/980c2a5d-e913-4bc8-9987-331c5cd2dd63)

Następnie wyprowadziłem port celem do eksponowania funkcjonalności:

![18](https://github.com/user-attachments/assets/3d9b32f7-fc0e-49d4-aab1-b0887f22cecd)

Aby przedstawić komunikację z redisem, musiałem najpierw uzyskać do niego dostęp nadając mu hasło dostępu:

![19](https://github.com/user-attachments/assets/5bca9787-d07f-4091-a393-54a36fc36134)

Po tym mogłem użyć `ping`:

![20](https://github.com/user-attachments/assets/4a42233c-9a8f-4243-8e34-8b68d23c31f5)

### Przekucie wdrożenia manualnego w plik wdrożenia (wprowadzenie)

Stworzyłem plik konfiguracyjny dla deploymentu i service redisa:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-app2
spec:
  replicas: 4
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
        - name: redis
          image: pszemo6/redis_runtime:4
          ports:
            - containerPort: 6379
```

```
apiVersion: v1
kind: Service
metadata:
  name: redis-service
spec:
  selector:
    app: redis
  type: NodePort
  ports:
    - port: 6379
      targetPort: 6379
      nodePort: 30079
```

Wdrożyłem te pliki za pomocą `kubectl apply`, a nastepnie zbadałem stan za pomocą `kubectl rollout status` i ponownie przekierowałem port i sprawdziłem działanie.

![21](https://github.com/user-attachments/assets/54034365-9dd8-4a33-8ad1-cac52db7db5a)

## Wdrażanie na zarządzalne kontenery: Kubernetes (2)

### Przygotowanie nowego obrazu

Na poczatek zarejestrowałem dwie nowe wersje redisa, jedna działająca, a druga zwracająca błąd. Błąd wywołałem zwykłym `exit 1`. v1 to wersja działająca, v2 nie działająca.

![image](https://github.com/user-attachments/assets/fa4229c8-8602-4e41-8852-68c6388645f8)

### Zmiany w deploymencie

W tej części sprawdzałem różne wersje przeskalowania: 8, 1, 0 i 4 repliki.

![1](https://github.com/user-attachments/assets/dd6d8953-e570-41f7-8594-bb212fd83e30)

![2](https://github.com/user-attachments/assets/02165a11-ba6c-40bd-8259-462fbe18f64d)

![3](https://github.com/user-attachments/assets/95fa08a4-be09-44b8-a3fd-6c0b8d409bf9)

![4](https://github.com/user-attachments/assets/11d3d01e-e522-4f6c-b090-f40e838c4beb)

![5](https://github.com/user-attachments/assets/f50fa432-34e1-4a98-819a-47f177cc0161)

![6](https://github.com/user-attachments/assets/c0326490-ce55-483c-bcc7-a395184c266b)

![7](https://github.com/user-attachments/assets/49eb68e3-7a13-4ef2-809c-dd67401efa7b)

Następnie zmieniłem wersję na wadliwą:

![8](https://github.com/user-attachments/assets/d267e176-0d4d-4868-8869-0ba063ef0023)

Wersja druga działająca:

![9](https://github.com/user-attachments/assets/7c7e46f1-06e7-44fb-84c5-db3416014e62)

Przywróciłem poprzednie wersje wdrożeń:

![10](https://github.com/user-attachments/assets/79595b10-a598-45b6-8397-d05afd4b6248)

![11](https://github.com/user-attachments/assets/913429ef-a315-4f29-a9dd-2d08eeb3a416)

### Kontrola wdrożenia

W tej części przeprowadziłem kontrolę wdrożenia, czyli skrypt, który sprawdza, czy wdrożenie zdążyło się wdrożyć w ciągu 60 sekund.

`check-deployment.sh`:

```
#!/bin/bash

DEPLOYMENT="xz-deployment"
NAMESPACE="default"
TIMEOUT=60
INTERVAL=5
elapsed=0

while [ $elapsed -lt $TIMEOUT ]; do
  status=$(kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE --timeout=1s 2>&1)
  if echo "$status" | grep -q "successfully rolled out"; then
    echo "Deployment zakończony sukcesem."
    exit 0
  fi
  sleep $INTERVAL
  elapsed=$((elapsed + INTERVAL))
done

echo "Timeout: Deployment nie zakończył się w ciągu $TIMEOUT sekund."
exit 1
```

![13](https://github.com/user-attachments/assets/f577f6ad-090c-4400-8217-6dd55fe83f91)

### Strategie wdrożenia

Ostatnim punktem było przygotowanie różnych wersji wdrożeń stosując nastepujące wersje wdrożeń: `Recreate`, `Rolling Update`, `Canary Deployment`. Dla każdego z nich zapisałem osobny plik `.yaml`, a przy wdrożeniu dla każdego korzystałem z `kubectl apply`. W większej ilości replik używałem `service`.

`redis-recreate.yaml`:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-recreate
  labels:
    app: redis
spec:
  replicas: 3
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
        - name: redis
          image: pszemo6/redis_runtime:4
          ports:
            - containerPort: 6379
```

`redis-rolling.yaml`:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-rolling
  labels:
    app: redis
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 50%
      maxUnavailable: 2 
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
        - name: redis
          image: pszemo6/redis_runtime:4
          ports:
            - containerPort: 6379
```

`redis-canary.yaml`:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-canary
  labels:
    version: canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
      version: canary
  template:
    metadata:
      labels:
        app: redis
        version: canary
    spec:
      containers:
        - name: redis
          image: pszemo6/redis_runtime:4
          ports:
            - containerPort: 6379
```

`redis-service.yaml`:
```
apiVersion: v1
kind: Service
metadata:
  name: redis-service
spec:
  selector:
    app: redis
  ports:
    - protocol: TCP
      port: 6379
      targetPort: 6379
```

![17](https://github.com/user-attachments/assets/e31bbc61-8378-4a6e-a80b-db65c4010129)

![15](https://github.com/user-attachments/assets/778950c5-db2a-4959-a812-02b245d2f4f2)

![18](https://github.com/user-attachments/assets/81241116-5cf9-47e8-9336-edde44157a98)

Recreate:
- w tej strategii stare pody są najpierw usuwane, a następnie tworzone są nowe
- może to spowodować przerwę w funkcjonowaniu oprogramowania

Rolling:
- domyślna strategia
- aktualizacja oprogramowania nastepuje stopniowo
- maxUnavailible - ile podów może być niedostepnych w trakcie aktualizacji
- maxSurge - ile podów może zostać tymczasowo dodatkowo uruchomionych

Canary:
- ta strategia zapewnia dwie wersje działające równolegle
- jedna z nich jest bardziej eksperymentalna i działa dla mniejszej liczby użytkowników
- druga jest stabilna i powszechnie dostępna

