# Zajęcia 08

---

## Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

Celem laboratorium jest zautomatyzowanie obsługi środowiska wielomaszynowego za pomocą Ansible. W ramach zadania skonfigurowano przynajmniej dwie maszyny wirtualne z dostępem SSH bez hasła, stworzono inwentarz systemów oraz przygotowano playbooki do wykonywania podstawowych operacji administracyjnych, takich jak pingowanie maszyn, aktualizacja pakietów, zarządzanie kontenerami Docker czy przesyłanie i uruchamianie aplikacji. Wszystkie te operacje zostały zawarte w rolach Ansible, co pozwala na ich automatyczne i wielokrotne uruchamianie, eliminując potrzebę ręcznego zarządzania maszynami i procesami wdrożeniowymi.

## Instalacja zarządcy Ansible

***Utworzenie nowej maszyny wirtualnej***

W VirtualBox utworzono maszynę z minimalnym zestawem oprogramowania, korzystając z tego samego systemu operacyjnego, co wcześniej używana maszyna. Dodatkowo zainstalowano programy 'tar' i 'sshd', a także ustawiono hostname na 'ansible-target' oraz użytkownika na 'ansible'.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.3.png)

Instalacja programu tar i OpenSSH

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.2.png)

Dodatkowo wykonano migawkę maszyny oraz jej eksport.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.4.png)

***Instalacja Ansible***

Na głównej maszynie zainstalowano oprogramowanie Ansible.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.5.png)

Wymieniono klucze SSH pomiędzy użytkownikami na maszynach, aby logowanie przez ssh nie wymagało wpisywania hasła.

`ssh-keygen -f ~/.ssh/id_rsa_ansible`

Powyższa komenda na głównej maszynie generuje klucz ssh.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.6.png)

`sudo nano /etc/hosts`

Powyższa komenda otworzy plik hosts do którego zostanie dodany adres IP hosta ansible-target wraz z dopiskiem jego nazwy.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.7.png)

`ssh-copy-id -i ~/.ssh/id_rsa_ansible.pub ansible@ansible-target`

Powyższa komenda kopiuje klucz ssh na maszynę ansible-target. Podczas przesyłania klucza ssh wymagane jest podanie hasła.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.9.png)

`ssh ansible@ansible-target`

Powyższa komenda łączy się po ssh z maszyną ansible-target. Pokazuje to tym samym, że nastąpiła poprawna wymiana kluczy i podawanie hasła nie jest wymagane.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.10.png)

## Inwentaryzacja

Zmieniono nazwe maszyny

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.11.png)

Wprowadzono nazwy DNS maszyn stosując 'etc/hosts' na obu maszynach.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.7.png)

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.8.png)

Dzięki temu możliwe jest wywoływanie komputerów za pomocą nazw zamiast używania tylko adresów IP. Łączność została zweryfikowana poprzez wzajemne wykonanie polecenia 'ping'.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.12.png)

Stworzono plik inwentaryzacji 'inventory.yaml' z sekcjami 'Orchestrators' oraz 'Endpoints'

```sh
Orchestrators:
  hosts:
    fedora:
      ansible_user: twinkle
      ansible_connection: local

Endpoints:
  hosts:
    ansible-target:
      ansible_user: ansible
```

Wysłano żądanie 'ping' do wszystkich maszyn w celu przetestowania łączności.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.14.png)

## Zdalne wywołanie procedur

Utworzenie pliku playbook.yml

```sh
- name: Playbook
  hosts: all
  gather_facts: yes
  tasks:
    - name: Ping do wszystkich maszyn
      ansible.builtin.ping:

- name: Skopiuj plik inventory.yaml na Endpoints
  hosts: Endpoints
  gather_facts: yes
  tasks:
    - name: Skopiuj plik inwentaryzacji
      ansible.builtin.copy:
        src: ./inventory.yaml
        dest: /tmp/inventory.yaml
```

`name` -> definiuje nazwę operacji.

`hosts` -> określa, na jakich hostach operacja ma zostać wykonana.

`gather_facts` -> opcja, która umożliwia pobranie informacji o systemie (np. OS, RAM, CPU).

`task` -> sekcja, w której definiuje się konkretne zadanie do wykonania.

Pierwsze uruchomienie playbooka

`ansible-playbook -i inventory.yaml playbook.yml`

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.16.png)

Drugie uruchomienie playbooka

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.17.png)

Aktualizacja pakietów w systemie oraz restart usług

`sudo dnf install rngd`

Powyższa komenda została wykonana na maszynie ansible-target w celu zainstalowania narzędzia rngd.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.18.png)

```sh
- name: Playbook
  hosts: all
  gather_facts: yes
  tasks:
    - name: Ping do wszystkich maszyn
      ansible.builtin.ping:

- name: Skopiuj plik inventory.yaml na Endpoints
  hosts: Endpoints
  gather_facts: yes
  tasks:
    - name: Skopiuj plik inwentaryzacji
      ansible.builtin.copy:
        src: ./inventory.yaml
        dest: /tmp/inventory.yaml

- name: Aktualizacja systemu + restart usług
  hosts: Endpoints
  become: true
  tasks:
    - name: Aktualizacja pakietów
      ansible.builtin.package:
        name: "*"
        state: latest

    - name: Restart usługi sshd
      ansible.builtin.service:
        name: sshd
        state: restarted

    - name: Restart usługi rngd
      ansible.builtin.service:
        name: rngd
        state: restarted
```        

`ansible-playbook -i inventory.yaml playbook.yml --ask-become-pass`

Opcja --ask-become-pass spowoduje, że system poprosi o hasło roota. Po jego wprowadzeniu playbook zostanie uruchomiony. Playbook zakończył się pełnym powodzeniem.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.20.png)

Wykonanie operacji na maszynie, która ma wyłączony serwer SSH.

`sudo systemctl stop sshd`

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.21.png)

Ansible nie udało się nawiązać połączenia SSH. Host został oznaczony jako unreachable w sekcji PLAY RECAP, a zadania dla tej maszyny nie zostały wykonane.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.22.png)

`sudo systemctl start sshd`

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.23.png)

## Zarządzanie stworzonym artefaktem

Utworzenie szkieletu roli

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.24.png)

Komenda ta stworzy szkielet roli deploy-container w bieżącym katalogu. Po jej wykonaniu zostanie wygenerowana standardowa struktura katalogów i plików.

Najpierw dodano obraz do repozytorium na Docker Hub.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.25.png)

*Uruchomienie playbooka, który:*
1. Instaluje Dockera na maszynie,
2. Pobiera opublikowany obraz z Docker Hub,
3. Uruchamia kontener z pobranego obrazu,
4. Zatrzymuje kontener,
5. Usuwa kontener po zakończeniu.

```sh
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
        name: szyocie2/node-app
        source: pull


    - name: Run the Docker container
      docker_container:
        name: node-app
        image: szyocie2/node-app:latest
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
        name: node-app
        state: absent
```

Uruchomienie playbooka

`ansible-playbook -i inventory.yaml playbook_deploy.yml --ask-become-pass`

Powyższa komenda uruchamia playbook. Opcja -i wskazuje plik inventory.yaml. Opcja --ask-become-pass spowoduje, że system poprosi o hasło roota.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.26.png)

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.27.png)

Ponowne uruchomienie, ale tym razem playbooki są zgodne z architekturą ansible-galaxy

deploy-docker.yml

```sh
- name: Deploy Docker container on endpoints
  hosts: Endpoints
  become: yes
  vars:
    docker_image_name: "szyocie2/node-app"
    docker_image_tag: "latest"
    docker_container_name: "node-app"
    host_port: "3000"
    container_port: "3000"
  roles:
    - deploy-container
```

tasks/main.yml

```sh
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

defaults/main.yml

```sh
defaults/main.yml:
docker_image_name: "szyocie2/node-app"
docker_image_tag: "latest"
docker_container_name: "node-app"
host_port: "3000"
container_port: "3000"
```

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.28.png)


# Zajęcia 09

---

## Pliki odpowiedzi dla wdrożeń nienadzorowanych

