![obraz](https://github.com/user-attachments/assets/d5830849-8967-42cf-94ab-36c533fbd031)
![f14bb030-73a2-4796-b82b-a471267a9775](https://github.com/user-attachments/assets/ac04c644-c200-4568-ac05-b6bf99e7e9b3)
![obraz](https://github.com/user-attachments/assets/03214813-1488-4c03-9795-e1ecdc01c76a)
![obraz](https://github.com/user-attachments/assets/28521a1f-93e2-4317-866d-251786b96fc6)
![obraz](https://github.com/user-attachments/assets/58f65dc4-6658-4e76-a2ce-e7f3d4aea4a4)



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
# Wyłączenie SSH na węźle docelowym
sudo systemctl stop ssh.socket ssh

# Test reakcji systemu
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

### Konfiguracja parametrów rozruchu

W menu GRUB wprowadzono parametr wskazujący lokalizację skryptu:

```
inst.ks=https://tinyurl.com/mrstzyf2
```

### Przebieg instalacji nienadzorowanej

Proces instalacji odbywał się automatycznie zgodnie ze skryptem. Nie była potrzebna ingerencja użytkownika, wszystkie parametry ustawiły się samoczynnie.

----------
