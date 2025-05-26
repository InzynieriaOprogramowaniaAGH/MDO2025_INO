# Sprawozdanie 2
**Wojciech Starzyk gr. 8**
# Lab 8

**Laby rozpoczęto od instalacji nowej maszyny wirtualnej. Była to identyczna Fedora jak dotychczasowo główna maszyna. Po zainstalowaniu zmieniono jej hostname na "ansible-target" a maszyny głównej na "orchestrator".**

![alt text](<zdjecia/lab 8/Zrzut ekranu 2025-05-13 190821.png>)
![alt text](<zdjecia/lab 8/Zrzut ekranu 2025-05-13 192527.png>)

**Wystąpiła potrzeba dosinstalowania pakietów pythonowych do poprawniejszego działania pewnych elementów.**
![alt text](<zdjecia/lab 8/Zrzut ekranu 2025-05-13 190849.png>)

**Adres ip maszyny ansible.**
![alt text](<zdjecia/lab 8/Zrzut ekranu 2025-05-13 191550.png>)

**Dodano do etc/hosts adres ip ansible-target, a następnie wykonano wymianę kluczy ssh z wykorzystaniem ```ssh-copy-id```. Widać na dolnej części screena pomyślne połączenie się po ssh.**
![alt text](<zdjecia/lab 8/Zrzut ekranu 2025-05-13 191605.png>)
![alt text](<zdjecia/lab 8/Zrzut ekranu 2025-05-13 192536.png>)

**Następnie stworzono plik inventory.ini z podziałem na orchestartorów i endpointy. Wykonano również pomyślny ping.**
![alt text](<zdjecia/lab 8/Zrzut ekranu 2025-05-13 192821.png>)

**Wykonano playbook "manage_endpoints.yml" wykorzystujący wszystkie przygotowane elementy. Wykonuje on działania takie jak pingowanie maszyn, updatowanie pakietów itp. Wystąpił jedynie problem przy restarcie rngd którego nie wiedziałem jak rozwiązać:**

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
        src: /home/wstarzyk/git4/MDO2025_INO/ITE/GCL08/WS417336/Sprawozdanie3/inventory.ini
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

![alt text](<zdjecia/lab 8/Zrzut ekranu 2025-05-26 154744.png>)

**Następnie wykonano playbook "deploy.yml" który deployuje aplikację wcześniej wybraną:**

```
---
- name: Deploy express app container on Fedora
  hosts: all
  become: true
  vars:
    container_name: express_app
    image_name: zbogenza/express-app
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

**W tej implementacji pojawiły się pojedyncze problemy i ostrzeżenia jednakże aplikacja jest poprawnie deployowana:**
![alt text](<zdjecia/lab 8/Zrzut ekranu 2025-05-21 131041.png>)


**"Problemem" przy obu playbookach jest fakt potrzeby wywołania ich z flagą -K która pozwala na wpisanie hasło do sudo.**


# Lab 9

**Te laby wymagały stworzenia instalacji nienadzorowanej. Zaczęto od przekopiowania pliku instalacji anakonda-ks.cfg do folderu ze sprawozdaniem. Następnie potrzeba było dodać mu uprawnienia, dla ułatwienia użyto maksymalnego ```chmod 777 anaconda-ks.cfg```. Następnie edytowano plik tak aby spełniał założenia: wykorzystuje odpowiedniego mirrora fedory (w moim przypadku 41) oraz w sekcji %post dodano uruchomienie programu używanego na zajęciach dotychczas (u mnie express.js). Artefakt był w moim przypadku przesyłany na dockerhuba (zbogenza/express-app).**

```
#version=DEVEL
# System language
lang pl_PL.UTF-8

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'

# Timezone
timezone Europe/Warsaw --utc

# Network & hostname
network --hostname=fedora-docker-node

# Root user
rootpw --iscrypted --allow-ssh $y$j9T$BT0dYcpFq7wgHuNrYpBa3/O8$K.tSJXLkZv9cBS67kKVBGrna9W8E8I7L0WT6IBlcwH/

# User with sudo access
user --groups=wheel --name=wstarzyk --password=$y$j9T$MRuSJ6lvJaR6pRWX2WXBi4G9$anZCunEdWr2HO/EBwdK3wuGKZ7sE0WxnFycrA6mUxZ7 --iscrypted --gecos="Wojciech Starzyk"

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
docker pull zbogenza/express-app:latest

# Uruchom kontener w tle z mapowaniem portu
docker run -d --name express-app -p 3000:3000 zbogenza/express-app:latest

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

**Przy instalacji, na wyborze "Install Fedora 41", kliknąłem przycisk "e" zamiast "enter" aby dodać instrukcję "inst.ks" która wskazuje na mój plik anaconda-ks.cfg opublikowany na repozytorium przedmiotowym. Link został skrócony na stronie tinyurl, jest wersją "raw" tego pliku.**

![](<zdjecia/lab 9/Zrzut ekranu 2025-05-26 152924.png>)

**System po automatycznym zainstalowaniu się odpala aplikację która jest widoczna z wykorzystaniem systemctl. Wykonanie curl'a pokazuje skuteczne uruchomienie aplikacji przez system.**

![alt text](<zdjecia/lab 9/Zrzut ekranu 2025-05-21 134411.png>)
![alt text](<zdjecia/lab 9/Zrzut ekranu 2025-05-21 134512.png>)


# Lab 9

**Laby zaczęto od pobrania kubernetesa**

![alt text](<zdjecia/lab 10/Zrzut ekranu 2025-05-20 184047.png>)

**Oraz minikube**
![alt text](<zdjecia/lab 10/Zrzut ekranu 2025-05-20 184414.png>)

**Minikube jak widać startuje**
![alt text](<zdjecia/lab 10/Zrzut ekranu 2025-05-20 185514.png>)

**Działający dashboard**
![alt text](<zdjecia/lab 10/Zrzut ekranu 2025-05-20 185651.png>)

**Odpalono poda z aplikacją**
![alt text](<zdjecia/lab 10/Zrzut ekranu 2025-05-20 190210.png>)
![alt text](<zdjecia/lab 10/Zrzut ekranu 2025-05-20 190348.png>)

**Co się okazało błędnym wykonaniem - należało zmienić "image" na "zbogenza/express-app" aby poprawnie wskazywał na mój artefakt na dockerhubie.**

**Po tej zmianie działało prawidłowo**
![alt text](<zdjecia/lab 10/Zrzut ekranu 2025-05-20 190944.png>)

**Następnie stworzono plik wdrożenia dla nginx:**
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
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

```

![alt text](<zdjecia/lab 10/Zrzut ekranu 2025-05-20 191459.png>)
![alt text](<zdjecia/lab 10/Zrzut ekranu 2025-05-20 191525.png>)

**A następnie powtórzono to dla express-app:**

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

![alt text](<zdjecia/lab 10/Zrzut ekranu 2025-05-20 192304.png>)

**Do poprawnego działania tych programów należało wyeksponować porty w zakładce "ports" Visual Studio Code**
