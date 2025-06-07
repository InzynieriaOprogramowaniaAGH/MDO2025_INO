## Laboratorium 8

Stworzenie nowej maszyny, ustawienie podanej nazwy użytkownika oraz nazwy hosta podczas instalacji

![](screenshoty/1.png)

![](screenshoty/2.png)

Instalacja Ansible

![](screenshoty/3.png)

Wystartowanie serwera SSH

![](screenshoty/4.png)

Ponowana instalacja i ponowienie powyższych kroków ze względu na to, że obie maszyny miały ten sam adres IP,
zmienienie karty sieciowej na mostkowaną kartę sieciową dla maszyny ansible-target

![](screenshoty/5.png)

![](screenshoty/6.png)

![](screenshoty/7.png)

Dodanie do pliku /etc/hosts na głównej maszynie IP maszyny ansible-target i aliasu, połączenie się do maszyny przez SSH bez podawania IP

![](screenshoty/8.png)

Wyeksportowanie maszyny

![](screenshoty/9.png)

Ustalenie przewidywalnych nazw komputerów

![](screenshoty/10.png)

Wysłanie pingu do wszystkich maszyn za pomocą stworzonego pliku inwentaryzacji
```
Orchestrators:
  hosts:
    master:
      ansible_user: pawel
      ansible_connection: local

Endpoints:
  hosts:
    ansible-target:
      ansible_user: ansible
```

![](screenshoty/11.png)

Uruchomienie playbooka, który wykonuje polecenia: wysyła ping, aktualizuje pakiety systemowe, restartuje usługi sshd i rngd 
```
---
- name: Restarty
  hosts: Endpoints
  become: yes
  tasks:

    - name: Ping do maszyny (test łączności)
      ansible.builtin.ping:

    - name: Skopiuj plik inwentaryzacji na endpointy
      ansible.builtin.copy:
        src: ./inventory.yml
        dest: /home/ansible/inventory.yml
        owner: ansible
        group: ansible
        mode: '0644'

    - name: Zaktualizuj pakiety systemowe
      ansible.builtin.yum:
        name: '*'
        state: latest
      when: ansible_facts['os_family'] == "RedHat"

    - name: Restartuj usługę sshd
      ansible.builtin.systemd:
        name: sshd
        state: restarted
        enabled: yes

    - name: Restartuj usługę rngd
      ansible.builtin.systemd:
        name: rngd
        state: restarted
        enabled: yes

```

![](screenshoty/14.png)

Uruchomienie playbooka, który instaluje Dockera, pobiera opublikowany obraz z DockerHuba, uruchamia kontener, a następnie go zatrzymuje oraz usuwa

```
---
- name: Deploy Docker container on endpoints
  hosts: Endpoints
  become: yes
  tasks:

    - name: Install Docker
      package:
        name: docker
        state: present

    - name: Ensure Docker service is running
      systemd:
        name: docker
        state: started
        enabled: yes


    - name: Pull the Docker image from Docker Hub
      docker_image:
        name: pawelk1234/nodeapp
        source: pull


    - name: Run the Docker container
      docker_container:
        name: nodeapp
        image: pawelk1234/nodeapp:latest
        state: started
        restart_policy: unless-stopped
        ports:
          - "3000:3000"


    - name: Wait for the container to be ready
      wait_for:
        host: localhost
        port: 3000
        delay: 5
        timeout: 30

    - name: Verify that the application is running
      uri:
        url: http://localhost:3000
        method: GET
        status_code: 200


    - name: Stop and remove the container
      docker_container:
        name: nodeapp
        state: absent

```

![](screenshoty/15.png)

![](screenshoty/16.png)

Analogiczne uruchomienie, tym razem playbooki są zgodne z architekturą ansible-galaxy

deploy_docker.yml:
```
- name: Deploy Docker container on endpoints
  hosts: Endpoints
  become: yes
  vars:
    docker_image_name: "pawelk1234/nodeapp"
    docker_image_tag: "latest"
    docker_container_name: "nodeapp"
    host_port: "3000"
    container_port: "3000"
  roles:
    - deploy_container
```

tasks/main.yml:
```
---
- name: Install Docker
  package:
    name: docker
    state: present

- name: Ensure Docker service is running
  systemd:
    name: docker
    state: started
    enabled: yes

- name: Pull the Docker image from Docker Hub
  docker_image:
    name: "{{ docker_image_name }}"
    source: pull

- name: Run the Docker container
  docker_container:
    name: "{{ docker_container_name }}"
    image: "{{ docker_image_name }}:{{ docker_image_tag }}"
    state: started
    restart_policy: unless-stopped
    ports:
      - "{{ host_port }}:{{ container_port }}"

- name: Wait for the container to be ready
  wait_for:
    host: localhost
    port: "{{ container_port }}"
    delay: 5
    timeout: 30

- name: Verify that the application is running
  uri:
    url: http://localhost:{{ container_port }}
    method: GET
    status_code: 200

- name: Stop and remove the container
  docker_container:
    name: "{{ docker_container_name }}"
    state: absent
```

defaults/main.yml:
```
defaults/main.yml:
docker_image_name: "pawelk1234/nodeapp"
docker_image_tag: "latest"
docker_container_name: "nodeapp"
host_port: "3000"
container_port: "3000"
```

![](screenshoty/17.png)


## Laboratorium 9

Skopiowanie pliku odpowiedzi na głownej maszynie i nadanie kopii odpowiendich uprawnień

![](screenshoty/18.png)

Dodanie odpowiednich repozytoriów, skonfigurowanie czystego dysku, zapewnienie formatowania dysku, ustawienie nazwy hosta

![](screenshoty/19.png)

Po wprowadzeniu ISO dokonanie modyfikacji parametrów startowych w GRUB poprzez dodanie odpowiedniego parametru ks, wskazującego na plik odpowiedzi, plik został wypchnięty wcześniej na zdalne repozytorium

![](screenshoty/20.png)

![](screenshoty/21.png)

![](screenshoty/22.png)

Uruchomiony system po instalacji, z użytkownikiem i hasłem z pliku odpowiedzi

![](screenshoty/23.png)

Plik Kickstart instaluje Fedorę, dodaje repozytoria, pakiety Docker, wget, curl, konfiguruje sieć. W sekcji %post uruchamia Dockera, dodaje użytkownika"pawel" do grupy Docker, pobiera i uruchamia kontener pawelk1234/nodeapp:latest, tworzy serwis systemd, otwiera port 3000 w firewallu. Na koniec restartuje system i uruchamia środowisko produkcyjne bez interakcji.

```
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

repo --name=fedora --baseurl=http://download.fedoraproject.org/pub/fedora/linux/releases/41/Everything/x86_64/os/
repo --name=updates --baseurl=http://download.fedoraproject.org/pub/fedora/linux/updates/41/Everything/x86_64/

%packages
@^server-product-environment
wget
curl
docker

%end

# Run the Setup Agent on first boot
firstboot --enable
skipx

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
autopart
# Partition clearing information
clearpart --all  --initlabel
autopart

# System timezone
timezone Europe/Warsaw --utc

network --hostname=non-localhost

# Root password
rootpw --iscrypted --allow-ssh $y$j9T$rCIkYXX7i./4tV/vedaVXS3p$70lp/BwTtk4OAqfOGIrW6hna6E9CfdzaN35gqPhWBbB
user --groups=wheel --name=pawel --password=$y$j9T$k2.Yr0rehrIUuR5kCz/50aYl$Gg46.NQ49JSWjF6mx/g5PF5GjP2fxzzeE4lTJzR4YL. --iscrypted --gecos="pawel"


%post --log=/root/post-install.log --interpreter=/bin/bash

echo "Docker"
systemctl enable docker
systemctl start docker
usermod -aG docker pawel

echo "Deploy container"
docker pull pawelk1234/nodeapp:latest

cat <<EOF > /etc/systemd/system/nodeapp.service
[Unit]
Description=Node.js Application Container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --rm -p 3000:3000 --name nodeapp pawelk1234/nodeapp:latest
ExecStop=/usr/bin/docker stop nodeapp

[Install]
WantedBy=multi-user.target
EOF

systemctl enable nodeapp.service
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload

echo "deployment complete."
%end

reboot
```

![](screenshoty/24.png)

