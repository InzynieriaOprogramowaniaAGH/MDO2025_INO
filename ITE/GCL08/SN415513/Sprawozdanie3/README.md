# LAB08

## Utworzenie maszyny
![](1.png)

## Nadanie nazwy użytkownika, hosta, oraz sprawdzenie działania sshd i tar
![](2.png)
![](2_5.png)

## Migawka maszyny i eksport
![](3.png)

## Instalacja ansible a gównej maszynie
![](4.png)

## Postawienie polaczenia ssh (ubuntu main -> ansible_target)

### Sprawdzenie adresu ip
![](5.png)

### Skopiowanie (już istniejących kluczy) na ansible-target
![](5_5.png)

### Połączenie się z głównej maszyny do targetu
![](5_6.png)

### Zezwolenie na logowanie bez hasła na configu fedory 
![](5_7.png)
  
## ustalenie nazw za pomocą hostnamectl
![](6_1.png)
![](6_2.png)

## Postawienie polaczenia ssh (ansible_target -> ubuntu_main)

### #Zapisanie ubuntu_main w /etc/hosts na ansible target
![](7_1.png)

### Zmiana configu ssh (/etc/ssh/sshd_config - na ubuntu_main)
![](7_2.png)

### Usunięcie hasła
![](7_3.png)

### Testowe połączenie niewymahgające wspisywania hasła
![](7_4.png)

## Utworzenie pliku .ini, uzupełnienie i ping
![](8.png)
```
[Orchestrators]
ubuntu_main  ansible_user=szymon

[Endpoints]
ansible-target ansible_user=ansible
```
## Playbook - procedury

### plik .yml
```
- name: Ping all hosts
  hosts: all
  gather_facts: no
  tasks:
    - name: Ping
      ansible.builtin.ping:

- name: Copy inventory file to Endpoints
  hosts: Endpoints
  gather_facts: no
  tasks:
    - name: Copy inventory file
      ansible.builtin.copy:
        src: inventory.ini
        dest: /tmp/inventory.ini

- name: Ping again to compare output
  hosts: all
  gather_facts: no
  tasks:
    - name: Ping after copy
      ansible.builtin.ping:

- name: Restart services on Fedora Endpoints
  hosts: Endpoints
  gather_facts: no
  tasks:
    - name: Restart sshd service
      ansible.builtin.service:
        name: sshd
        state: restarted
      ignore_errors: yes

    - name: Restart rngd service
      ansible.builtin.service:
        name: rngd
        state: restarted
      ignore_errors: yes
```
### 
![](9.png)
  
## Zarządzanie stworzonym artefaktem
 
Plik deploy_deb.yml definiujący instrukcje:
```
---
- name: Deploy binary in Docker container
  hosts: Endpoints
  become: yes
  vars:
    binary_file: "mypkg/usr/local/bin/weechat"
    deb_file: "weechat.deb"
    dest_dir: "/opt/weechat"        
    image_name: "ubuntu:22.04"
    container_name: "weechat_container"

  tasks:
    - name: Ensure Docker is installed
      become: true
      command: dnf install -y docker
      args:
        creates: /usr/bin/docker

    - name: Start Docker service
      ansible.builtin.service:
        name: docker
        state: started
        enabled: yes

    - name: Create directory on target host
      ansible.builtin.file:
        path: "{{ dest_dir }}"
        state: directory
        mode: '0755'

    - name: Copy binary to target host
      ansible.builtin.copy:
        src: "{{ binary_file }}"
        dest: "{{ dest_dir }}/weechat"
        mode: '0755'

    - name: Copy .deb file to target host
      ansible.builtin.copy:
        src: "{{ deb_file }}"
        dest: "{{ dest_dir }}/weechat.deb"
        mode: '0644'

    - name: Run container with mounted binary and install dependencies
      community.docker.docker_container:
        name: "{{ container_name }}"
        image: "{{ image_name }}"
        state: started
        volumes:
          - "{{ dest_dir }}:/weechat"
        command: >
          bash -c "apt update && apt install -y /weechat/weechat.deb && /weechat/weechat"
        command: sleep infinity
        tty: true
        detach: true
```

### Pomyśle wykonanie wszystkich kroków:
![](10.png)

### Weryfikacja poprawności załączenia voluminu na kontener i działania aplikacji
![](11.png)
![](12.png)
