# Sprawozdanie 3

## Lab 8 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

### Cel:
Celem zajęć jest nabycie praktycznych umiejętności w zakresie automatyzacji konfiguracji i zdalnego zarządzania systemami za pomocą Ansible, w tym instalacji oprogramowania, wymiany kluczy SSH.

### 1. Przygotowanie maszyn wirtualnych

Stworzyliśmy drugą maszynę wirtualną z system Fedora. Maszyna ta została przygotowana w wersji minimalnej, czyli miała zainstalowany tylko pakiet *tar* oraz *sshd*.
![alt text](<Lab8-10/Zrzut ekranu 2025-05-21 151623.png>)  

Na maszynie stworzono konto *root'a* oraz użytkowanika.
![alt text](<Lab8-10/Zrzut ekranu 2025-05-21 151808.png>)

### 2. Instalacja Ansible

Na maszynie, której używaliśmy na wczęśniejszych zajęciach zainstalowaliśmy *Ansible*:

```
sudo dnf install ansible
```

![alt text](<Lab8-10/Zrzut ekranu 2025-05-21 151950.png>)

### 3. Konfiguracja komunikacji SSH

Następnie wygenerowaliśmy klucze RSA:

```
ssh-keygen
```
Po czym używając poniższego polecenia przekazaliśmy klucz na maszynę utworozną na tych zajęciach


```
ssh-copy-id ansible@ansible-target
```

![alt text](<Lab8-10/Zrzut ekranu 2025-05-21 161718.png>)

A następnie sprawdziliśmy czy maszyny się "widzą" i czy łączą się poprawnie

```
ssh ansible@ansible-target
```

![alt text](<Lab8-10/Zrzut ekranu 2025-05-21 161817.png>)

Wykonując ten krok, pojawił się problem, ponieważ maszyny się nie widziały. Wiązało się to z faktem, że wykonuję te ćwiczenia, będąc podłączona do sieci w akademiku. Rozwiązanie tego problemu zostało przedsatawione podczas ćwiczeń. Trzeba było zmienić *NAT* na *Sieć NAT*.

### 4. Inwentaryzacja systemów

Na maszynie głownej ustawiliśmy hostname:

```
sudo hostnamectl set-hostname orchestrator
```
![alt text](<Lab8-10/Zrzut ekranu 2025-05-21 162011.png>)

Edytowaliśmy plik */etc/hosts* dodając:

```
10.0.2.15 ansible-target
10.0.2.4 orchestrator
```

![alt text](<Lab8-10/Zrzut ekranu 2025-05-21 162037.png>)


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

![alt text](<Lab8-10/Zrzut ekranu 2025-05-21 170229.png>)

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


## Lab 9 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

### Cel:
Celem zajęć jest nabycie praktycznych umiejętności w zakresie automatyzacji konfiguracji i zdalnego zarządzania systemami za pomocą Ansible, w tym instalacji oprogramowania, wymiany kluczy SSH.