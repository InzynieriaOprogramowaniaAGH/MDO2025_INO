# LAB 8 - Ansible

## Stworzyłem drugą maszynę wirtualną z hostname ansible-target i użytkownikiem ansible
![alt text](image.png)

## Dodałem ip maszyny do lokalnej listy hostów /etc/hosts
```
172.23.106.193 ansible-target
```

## Wymieniłem klucze ssh aby nie było wymaganego hasła poleceniem
```
ssh-copy-id ansible@asnible-target
```

## Dzięki temu można połączyć się bez hasła poleceniem
 ```
ssh ansible@ansible-target
```

![alt text](image-1.png)

## Utworzyłem plik inwentaryzacji
```ini
[Orchestrators]
ansible-controller ansible_user=user

[Endpoints]
ansible-target ansible_user=ansible
```

## Wysłałem żądanie ping do wszystkich maszyn
![alt text](image-2.png)

## Wykorzystując playbooka:

### Wysłałem żadanie ping do wszystkich maszyn:
```yml
- name: Ping all hosts
  hosts: all
  gather_facts: no
  tasks:
    - name: Ping test
      ansible.builtin.ping:
```
```
ansible-playbook -i inventory.ini ping.yml
```
![alt text](image-17.png)
### Skopiowałem plik inventory.ini na maszynę z sekcji Endpoints
```yml
- name: Copy inventory file to endpoints
  hosts: Endpoints
  tasks:
    - name: Copy inventory file
      ansible.builtin.copy:
        src: ./inventory.ini
        dest: /tmp/inventory.ini
```
```
ansible-playbook -i inventory.ini copy.yml
```
### Pierwsze wywołanie playbooka
![alt text](image-18.png)
### Drugie wywołanie playbooka, można zauważyć że ansible sprawdził jedynie czy taki plik istnieje, i nie wprowadza nowych zmian
![alt text](image-16.png)
### Restart usług sshd i rngd
```yml
- name: Restart sshd and rngd
  hosts: all
  become: yes
  tasks:
    - name: Restart sshd
      ansible.builtin.service:
        name: sshd
        state: restarted

    - name: Restart rngd
      ansible.builtin.service:
        name: rngd
        state: restarted

```
![alt text](image-19.png)
### Jednak napotkałem problem z wprowadzeniem hasła, ponieważ użytkownicy mają inne hasła. Gdyby były takie same, problem rozwiązałabo użycie --ask-become-pass, które pyta o hasło przed wykonaniem playbooka.

### Jednym z rozwiązań jest dopisanie do pliku inventory.ini ```ansible_become_pass=```, co mimo wszystko nie jest bezpieczną metodą dla środowisk innych niż testowe, przez brak szyfrowania
```ini
[Endpoints]
ansible-target ansible_user=ansible ansible_become_pass=ultra_secret_password
```

### Drugim rozwiązaniem jest stworzenie plików zaszyfrowanych za pomocą Ansible Vault, dzięki czemu plik wyglądający tak:
```
ansible_user=ansible ansible_become_pass=ultra_secret_password
```
### za pomocą polecenia:
```
ansible-vault encrypt host_vars/ansible-controller.yml
```
### wygląda tak:
```yml
$ANSIBLE_VAULT;1.1;AES256
36633861346437343436356635613533636264393735373739616566346466343530666239613262
...
...
...
```
### Dzięki temu dodając opcję ```--ask-vault-password``` możemy wykonać playbooka bez błędu
```
ansible-playbook -i inventory.ini restart.yml --ask-vault-password
```
![alt text](image-20.png)

### Próba pingu z wyłączonym serwerem ssh
```
ansible-playbook -i inventory.ini ping.yml
```
![alt text](image-21.png)

### Próba uruchomienia konteneru z aplikacją opublikowaną jako produkt pipelinu, natomiast przez błędy popełnionych na poprzednich zajęciach, aplikacja nie uruchamia się poprawnie i nie ma z nią połączenia

![alt text](image-23.png)

### Zmieniłem obraz na apache server, który będę wykorzystywać i opisywać w dalszej części sprawozdania i cały playbook wykonał się poprawnie, natomiast elementy które wymagały instalacji, po ponownym uruchomieniu zwracały status ok, zamiast changed

![alt text](image-24.png)

### Ubrałem całość w rolę:
### Inicjując poleceniem `ansible-galaxy init deploy_docker_app`

### Uzupełniając pliki:
```yml
#vars/main.yml
---
docker_image: cumil/apache-basic
container_name: myapp
container_port: 80
published_port: 80
```
```yml
#tasks/main.yml
---
- name: Zainstaluj wymagane pakiety
  dnf:
    name:
      - dnf-plugins-core
      - yum-utils
      - device-mapper-persistent-data
      - lvm2
    state: present

- name: Dodaj repozytorium Dockera
  get_url:
    url: https://download.docker.com/linux/fedora/docker-ce.repo
    dest: /etc/yum.repos.d/docker-ce.repo

- name: Zainstaluj Dockera
  dnf:
    name:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    state: latest

- name: Włącz i uruchom usługę Docker
  systemd:
    name: docker
    enabled: yes
    state: started

- name: Zainstaluj zależności Pythona dla Dockera
  package:
    name:
      - python3-pip
    state: present

- name: Zainstaluj systemową wersję python3-packaging
  package:
    name: python3-packaging
    state: present

- name: Zainstaluj moduł Python 'docker', 'requests'
  pip:
    name:
      - docker
      - requests
    executable: pip3

- name: Pobierz obraz z Docker Hub
  community.docker.docker_image:
    name: "{{ docker_image }}"
    source: pull

- name: Uruchom kontener z aplikacją
  community.docker.docker_container:
    name: "{{ container_name }}"
    image: "{{ docker_image }}"
    state: started
    restart_policy: always
    published_ports:
      - "{{ published_port }}:{{ container_port }}"

- name: Poczekaj aż aplikacja zacznie odpowiadać
  uri:
    url: "http://localhost:{{ published_port }}/"
    status_code: 200
    timeout: 20
  register: result
  retries: 5
  delay: 3
  until: result.status == 200

- name: Zatrzymaj kontener
  community.docker.docker_container:
    name: "{{ container_name }}"
    state: stopped

- name: Usuń kontener
  community.docker.docker_container:
    name: "{{ container_name }}"
    state: absent
```
### Po zmianie playbooka i uruchomieniu otrzymujemy taki sam output jak przy samym playbooku
```yml
---
- name: Instalacja Dockera i uruchomienie aplikacji z Docker Hub
  hosts: Endpoints
  become: true

  roles:
    - deploy_docker_app
```
```ansible-playbook -i inventory.ini deploy_app_docker.yml```
![alt text](image-25.png)


![alt text](image-3.png)

![alt text](image-4.png)

![alt text](image-5.png)

![alt text](image-7.png)

![alt text](image-8.png)

![alt text](image-9.png)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
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

![alt text](image-13.png)

![alt text](image-11.png)

![alt text](image-12.png)

![alt text](image-14.png)

![alt text](image-15.png)