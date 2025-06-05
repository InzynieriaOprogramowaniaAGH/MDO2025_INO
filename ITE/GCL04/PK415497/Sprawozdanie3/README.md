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

