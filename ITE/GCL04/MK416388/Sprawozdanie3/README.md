Sprawozdanie nr 1 z Przedmiotu DevOps

Kierunek: Informatyka Techniczna

Grupa 4

Marcin Król


## Zajecia 8

1.Utworzenie nowej maszyny wirtualnej z użytkownikiem o nazwie:ansible i hostname:ansible-target

![](ScreenySprawozdanie3/1.jpg)

2.Utworzenie jak najmniejszego zbioru zainstalowanego oprogramowania

![](ScreenySprawozdanie3/2.jpg)

3.Zainstalowanie oprogramowania Ansible na głównej maszynie

![](ScreenySprawozdanie3/3.jpg)

4.Reczne zaistalowanie tar i serwera OpenSSH

![](ScreenySprawozdanie3/4.jpg)

5.Po utworzeniu drugiej maszyny zmieniamy jej nazwę, a domyślnym użytkownikiem bedzie ansible

![](ScreenySprawozdanie3/5.jpg)

6.Zrobienie migawki

![](ScreenySprawozdanie3/6.jpg)

7.Na głównej maszynie generujemy klucze RSA potrzebne do połączenia się z drugą maszyną przez SSH

![](ScreenySprawozdanie3/7.jpg)

8.Wymieniono klucze SSH pomiędzy użytkownikami na maszynach, aby logowanie przez ssh nie wymagało wpisywania hasła

![](ScreenySprawozdanie3/8.jpg)

9.Na maszynie głównej dodajemy odpowiednie rzeczy w pliku /etc/hosts, aby maszyny mogły się nawzajem komunikować za pomocą nazw hostów

![](ScreenySprawozdanie3/9.jpg)

10.Podobnie na drugiej maszynie

![](ScreenySprawozdanie3/10.jpg)

11.Testujemy połaczenie SSH z kontrolera do targetu

![](ScreenySprawozdanie3/11.jpg)

12.Z maszyny głównej pingujemy ansible-target po nazwie

![](ScreenySprawozdanie3/12.jpg)

13.To samo na drugiej maszynie

![](ScreenySprawozdanie3/13.jpg)

14.Na początek przygotowujemy plik inwentaryzacyjny, który będzie zawierał sekcje orchestrators oraz endpoints

```
[Orchestrators]
vbox ansible_host=10.0.2.15 ansible_user=mkrol 
[Endpoints]
ansible-target ansible_host=192.168.0.188 ansible_user=ansible 
```

15.Na próbę wysyłamy zapytanie ping do wszystkich maszyn

![](ScreenySprawozdanie3/14.jpg)
![](ScreenySprawozdanie3/15.jpg)

16.Następnie instalujemy narzędzie rngd na obu maszynach

![](ScreenySprawozdanie3/16.jpg)

17.Uruchomienie playbooka, który wykonuje polecenia: wysyła ping, aktualizuje pakiety systemowe, restartuje usługi sshd i rngd

```
name: Restarty
  hosts: Endpoints
  become: yes
  tasks:

    - name: Ping do maszyny (test łączności)
      ansible.builtin.ping:

    - name: Skopiuj plik inwentaryzacji na endpointy
      ansible.builtin.copy:
        src: ./inventory.ini
        dest: /home/ansible/inventory.ini
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

18.Uruchomienie powyższego playbooka

![](ScreenySprawozdanie3/17.jpg)

19.Uruchomienie playbooka, który instaluje Dockera, pobiera opublikowany obraz z DockerHuba, uruchamia kontener
```
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
        name: pyonaaa/node-js-dummy-test
        source: pull

    - name: Run the Docker container
      docker_container:
        name: node-js-dummy-test
        image: pyonaaa/node-js-dummy-test:latest
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

```

![](ScreenySprawozdanie3/18.jpg)

![](ScreenySprawozdanie3/19.jpg)

20.Podobne uruchomienie, tym razem playbooki są dostosowane do struktury ansible-galaxy

deploy_docker.yml:

```
- name: Deploy Docker container on endpoints
  hosts: Endpoints
  become: yes
  vars:
    docker_image_name: "pyonaaa/node-js-dummy-test"
    docker_image_tag: "latest"
    docker_container_name: "node-js-dummy-test"
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
 ```

 defaults/main.yml


 ```
 docker_image_name: "pyonaaa/node-js-dummy-test"
docker_image_tag: "latest"
docker_container_name: "node-js-dummy-test"
host_port: "3000"
container_port: "3000"
```

![](ScreenySprawozdanie3/20.jpg)

## Zajecia 9

1.Skopiowanie pliku z odpowiedzi na główną maszynę i przypisanie odpowiednich uprawnień do kopii

![](ScreenySprawozdanie3/21.jpg)

2.Dodanie wymaganych repozytoriów, skonfigurowanie nowego dysku, zapewnienie jego formatowania oraz ustawienie nazwy hosta

![](ScreenySprawozdanie3/22.jpg)

3.Dodanie odpowiednich repozytoriów, skonfigurowanie czystego dysku, zapewnienie formatowania dysku, ustawienie nazwy hosta

![](ScreenySprawozdanie3/23.jpg)

4.plik anaconda-ks.cfg
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
rootpw --iscrypted $y$j9T$crVz62v3kzp0Rp3iZuj8c6jt$nse1YNvMC5q.grehgHovKwGQnth8ZHgRt28lvwbhTGA
# User account
user --groups=wheel --name=mkrol --password=$y$j9T$7xQaOvhOAYJEexNAKS4wXH0d$EX6UnztKWwJUE7oQs4d9xZpdbzKwby8G1nbz1cYYj24 --iscrypted --gecos="Marcin Król"
```

5.Plik kickstart dodaje repozytoria, ustawia czysty dysk i zapewnia jego formatowanie przed podziałem na partycje. Zmieniamy nazwę hosta na my_custom_hostname, żeby nie było domyślnego localhost. Na końcu tworzymy użytkownika mkrol z odpowiednimi uprawnieniami i zaszyfrowanym hasłem

![](ScreenySprawozdanie3/24.jpg)

![](ScreenySprawozdanie3/25.jpg)

6.Uruchomiony system po instalacji, z użytkownikiem i hasłem z pliku odpowiedzi

![](ScreenySprawozdanie3/26.jpg)

7.Plik Kickstart instaluje system Fedora, dodaje źródła pakietów, instaluje pakiety takie jak Docker, wget i curl, oraz konfiguruje ustawienia sieciowe. W sekcji %post uruchamia serwis Docker, dodaje użytkownika "mkrol" do grupy Docker, pobiera oraz uruchamia kontener pyonaaa/node-js-dummy-test, tworzy jednostkę systemd, otwiera port 3000 w zaporze sieciowej. Na końcu wykonuje restart systemu i uruchamia środowisko produkcyjne bez potrzeby interakcji użytkownika


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
rootpw --iscrypted $y$j9T$crVz62v3kzp0Rp3iZuj8c6jt$nse1YNvMC5q.grehgHovKwGQnth8ZHgRt28lvwbhTGA
# User account
user --groups=wheel --name=mkrol --password=$y$j9T$7xQaOvhOAYJEexNAKS4wXH0d$EX6UnztKWwJUE7oQs4d9xZpdbzKwby8G1nbz1cYYj24 --iscrypted --gecos="Marcin Król"

%post --log=/root/post-install.log --interpreter=/bin/bash

echo "Docker"
systemctl enable docker
systemctl start docker
usermod -aG docker marcin

echo "Deploy container"
docker pull pyonaaa/node-js-dummy-test:latest

cat <<EOF > /etc/systemd/system/node-js-dummy-test.service
[Unit]
Description=Node.js Application Container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --rm -p 3000:3000 --name nodeapp pyonaaa/node-js-dummy-test:latest
ExecStop=/usr/bin/docker stop node-js-dummy-test

[Install]
WantedBy=multi-user.target
EOF

systemctl enable node-js-dummy-test.service
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload

echo "deployment complete."
%end

reboot
```

![](ScreenySprawozdanie3/27.jpg)

![](ScreenySprawozdanie3/28.jpg)

