#Sprawozdanie 3

## Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

### Instalacja zarządcy Ansible
Utworzenie nowej maszyny wirtualnej nazwanej `ansible` (w Hyper-V) oraz hostname `ansible-target`
![wirtualka ansible1](./screenshots/nmwa1.png)
![wirtualka ansible2](./screenshots/nmwa2.png)


Instalacja programu `tar` oraz `openssh-server` na maszynie `ansible`:
```
sudo dnf install tar openssh-server -y
```
![Tar sshserver](./screenshots/tar.png)

Instalacja programu `Ansible` na maszynie hoście:
```
sudo dnf install ansible -y
```
![ansible instal](./screenshots/ansibleinstal.png)


Wymiana kluczy SSH między użytkownikiem na głównej maszynie a użytkownikiem ansible, w celu wyeliminowania konieczności podawania hasła podczas logowania przez SSH. Ponieważ klucz publiczny został już utworzony wcześniej, przeprowadzono wymianę kluczy za pomocą odpowiedniego polecenia. Powstał jednak problem, gdyż system nie rozpoznawał domyślnej lokalizacji pliku z kluczem SSH. W związku z tym konieczne okazało się ręczne wskazanie ścieżki do pliku z kluczem w parametrze komendy służącej do wymiany kluczy.
```
ssh-copy-id -i ~/Github/sshklucz.txt.pub ansible@ansible-target
```
![ssh problem](./screenshots/sshproblem.png)
### Inwentaryzacja


Sprawdzenie połączenia pomiędzy maszynami za pomocą polecenia `ping`:
![Host - ansible](./screenshots/hostansible.png)
![Ansible - Host](./screenshots/ansiblehost.png)

### Zdalne wywoływanie procedur


### Zarządzanie stworzonym artefaktem


Playbook:
```
---
- hosts: Endpoints
  become: yes
  tasks:
    - name: Install required system packages
      ansible.builtin.dnf:
        name:
          - python3-packaging
          - python3-pip
          - docker
          - redis
        state: present
        update_cache: yes

    - name: Install Python 'requests'
      ansible.builtin.pip:
        name: requests
        executable: pip3

    - name: Start and enable Docker service
      ansible.builtin.service:
        name: docker
        state: started
        enabled: yes

    - name: Download Docker image from DockerHub
      ansible.builtin.docker_image:
        name: mlorenc4/pipeline-redis:latest
        source: pull

    - name: Run Docker container
      ansible.builtin.docker_container:
        name: pipeline-redis
        image: mlorenc4/pipeline-redis:latest
        state: started
        ports:
          - "6379:6379"

    - name: Wait for the container to be ready
      ansible.builtin.wait_for:
        host: "ansible-target"
        port: 6379
        state: started
        delay: 10
        timeout: 60
        msg: "Redis is not available on port 6379"

    - name: Test connection to container
      command: redis-cli -h ansible-target -p 6379 ping
      register: redis_ping

    - name: Show Redis response
      debug:
        msg: "{{ redis_ping.stdout }}"

    - name: Stop and remove Docker container
      ansible.builtin.docker_container:
        name: pipeline-redis
        state: absent
        force_kill: yes
```

## Pliki odpowiedzi dla wdrożeń nienadzorowanych



## Kubernetes

### Instalacja klastra Kubernetes



### Analiza posiadanego kontenera


### Uruchamianie oprogramowania


### Przekucie wdrożenia manualnego w plik wdrożenia


### Przygotowanie nowego obrazu


### Zmiany w deploymencie


### Kontrola wdrożenia


### Strategie wdrożenia