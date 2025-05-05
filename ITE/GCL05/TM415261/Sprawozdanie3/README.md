# Sprawozdanie 3
#### Tomasz Mandat ITE gr. 05

<br>

## Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

### Instalacja zarządcy Ansible
Na początku utworzyłem drugą maszynę wirtualną posiadającą ten sam system operacyjny, co "główna" maszyna (`Fedora 41`).

Podczas instalacji nadałem maszynie *hostname* `ansible-target` oraz utworzyłem użytkownika `ansible`.
![ss](./Lab8/screenshots/ss1.png)
![ss](./Lab8/screenshots/ss2.png)

Po pomyślnej instalacji zalogowałem się na nowo utworzoną maszynę.
![ss](./Lab8/screenshots/ss3.png)

Następnie zainstalowałem program `tar` oraz serwer `OpenSSH` (`shd`). Okazało się, że serwer jest już zainstalowany.
``` bash
sudo dnf install tar openssh-server -y
```
![ss](./Lab8/screenshots/ss4.png)

Po udanej instalacji zrobiłem migawkę maszyny.
![ss](./Lab8/screenshots/ss5.png)

Następny krok odbył się na głównej maszynie wirtualnej. Mianowicie zainstalowałem na niej oprogramowanie Ansible.
``` bash
sudo dnf install ansible -y
```
![ss](./Lab8/screenshots/ss6.png)

Instalacja zakończyła się sukcesem.
![ss](./Lab8/screenshots/ss7.png)

Następnie wymieniłem klucze SSH między użytkownikiem na głównej maszynie, a użytkownikiem `ansible`. Dzięki temu podczas logowania przez `ssh` nie będzie wymagane hasło.
Z racji, że klucz publiczny został już utworzony podczas laboratoriów nr 1, wymiana kluczy odbyła się jedynie poleceniem:
``` bash
ssh-copy-id ansible@ansible-target
```
![ss](./Lab8/screenshots/ss8.png)

Podczas próby logowania, hasło faktycznie nie było wymagane. To potwierdza skuteczność operacji.
![ss](./Lab8/screenshots/ss9.png)

<br>

### Inwentaryzacja
Następnie należało dokonać inwentaryzacji systemów. Zacząłem od ustalenia przewidywalnych nazw komputerów (maszyn wirtualnych) stosując `hostnamectl`.

Najpierw wykonałem to na głównej maszynie:
![ss](./Lab8/screenshots/ss10.png)

A następnie na nowej:

![ss](./Lab8/screenshots/ss11.png)

W kolejnym kroku zapewniłem możliwość wywoływania komputerów za pomocą nazw, a nie tylko adresów IP. W tym celu dopisałem adresy i nazwy hostów to pliku `/etc/hosts`. Jest to lokalna alternatywa dla `DNS`. Modyfikacja pliku nastąpiła na obydwu maszynach w identyczny sposób.

Główna maszyna:
![ss](./Lab8/screenshots/ss12.png)

Nowa maszyna:
![ss](./Lab8/screenshots/ss13.png)

Po zapisaniu zmodyfikowanych plików, zweryfikowałem łączność w obu kierunkach (stosując `ping`). Zamiast adresów używałem wcześniej ustawionych nazw.

Główna maszyna -> Nowa maszyna
![ss](./Lab8/screenshots/ss14.png)

Nowa maszyna -> Główna maszyna
![ss](./Lab8/screenshots/ss15.png)

W kolejnym kroku utworzyłem plik inwentaryzacji. Zawiera on sekcje `Orchestrators` (czyli maszyny, które zarządzają innymi) oraz `Endpoints` (maszyny docelowe). W odpowiednich sekcjach zostały dodane nazwy maszyn, ich adresy IP oraz nazwy użytkowników.

Plik [inventory.ini](./Lab8/inventory.ini):
``` ini
[Orchestrators]
MSI ansible_host=192.168.1.38 ansible_user=tmandat

[Endpoints]
ansible-target ansible_host=192.168.1.41 ansible_user=ansible
```

Teraz, za pomocą pliku inwentaryzacji, wysłałem żądanie `ping` do wszystkich maszyn. Operacja zakończyła się sukcesem.
![ss](./Lab8/screenshots/ss17.png)

<br>

### Zdalne wywoływanie procedur

Po dokonaniu inwentaryzacji utworzyłem `playbook` odpowiedzialny za: 
* wysłanie żądania `ping` do wszystkich maszyn
* skopiowanie pliku inwentaryzacji na maszyny
* aktualizację pakietów w systemie
* restart usługi `sshd` i `rngd`

Treść [`playbooka`](./Lab8/playbook1.yaml):
``` yaml
- hosts: all
  become: yes
  tasks:
    - name: Ping machines
      ansible.builtin.ping:

    - name: Copy inventory file
      ansible.builtin.copy:
        src: ./inventory.ini
        dest: /tmp/inventory.ini

    - name: Update all packages
      ansible.builtin.dnf:
        name: '*'
        state: latest
        update_cache: yes

    - name: Restart sshd and rngd
      ansible.builtin.systemd:
        name: "{{ item }}"
        state: restarted
      loop:
        - sshd
        - rngd
```

Podczas wykonania pojawił się problem - brak `rngd` na maszynach. Aby operacja przebiegła poprawnie, ręcznie doinstalowałem program:
``` bash
sudo dnf install rng-tools
```

Przy uruchomieniu `playbooka` dodałem opcję `--ask-become-pass`, która na wstępie prosi o podanie hasła użytkownika wykonującego polecenia z uprawnieniami roota, wymaganego do przeprowadzenia operacji wymagających wyższych uprawnień.

Efekt pierwszego (działającego) uruchomienia `playbooka`:
![ss](./Lab8/screenshots/ss18.png)

Ponowne uruchomienie `playbooka`:
![ss](./Lab8/screenshots/ss19.png)

Różnica, jaka pojawiła się między pierwszym a drugim uruchomieniem to dodatkowa operacja ze statusem `changed` (przy kopiowaniu pliku inwentaryzacji do nowej maszyny). 

Następnie sprawdziłem, jak `ansible` poradzi sobie w przypadku braku połączenia do jednej z maszyn docelowych. W tym celu wyłączyłem serwer `ssh` oraz odpiąłem karte sieciową z nowej maszyny. Serwer `ssh` wyłączyłem poleceniem:
``` bash
sudo systemctl stop sshd
```
Po tym upewniłem się, że serwer jest wyłączony:
![ss](./Lab8/screenshots/ss20.png)

Oto efekt uruchomienia:
![ss](./Lab8/screenshots/ss21.png)

Jak możemy zauważyć, `ansible-target` został oznaczony jako `unreachable`, więc żadna operacja na nowej maszynie się nie wykonała. Nie uniemożliwiło to jednak poprawnego wykonania operacji na osiągalnej maszynie. Jest to zaleta `ansible`, który nie wstrzymuje działania całego `playbooka` w przypadku takiego błędu.

<br>

### Zarządzanie stworzonym artefaktem

Z racji, że artefaktem z mojego `pipeline`'u z poprzednich zajęć był kontener, zadanie polegało na zbudowaniu i uruchomieniu kontenera opublikowanego na DockerHubie oraz połączeniu się z nim. Całość odbywa się za pomocą `playbooka`.

Pełna treść [`playbooka`](./Lab8/playbook2.yaml):
``` yaml
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
        name: tomaszek03/redis-app:latest
        source: pull

    - name: Run Docker container
      ansible.builtin.docker_container:
        name: redis-app
        image: tomaszek03/redis-app:latest
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
        name: redis-app
        state: absent
        force_kill: yes
```
Na początku pobierane są wszystkie programy potrzebne do poprawnego wykonania zadania. Następnie pobierany jest opublikowany w ramach kroku `Publish` w `pipeline` obraz, uruchamiany jest kontener i sprawdzane jest połączenie z serwerem z zewnątrz kontenera (stąd jednym z potrzebnych programów do zainstalowania jest `redis`). Na koniec kontener jest zatrzymywany i usuwany.

Efekt uruchomienia:
![ss](./Lab8/screenshots/ss22.png)

Ostatnim zadaniem w ramach tego laboratorium było ubranie kroków dotyczących zarządzania stworzonym kontenerem w rolę.

Utworzyłem nową rolę o nazwie `deploy_container` poleceniem:
``` bash
ansible-galaxy init deploy_container
```
![ss](./Lab8/screenshots/ss23.png)

Konfiguracja roli odbyła się następująco:
* skopiowałem treści zadań poprzedniego `playbooka` do *deploy_container/tasks/[*main.yml*](./Lab8/deploy_container/tasks/main.yml)*
    ``` yml
    ---
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
        name: "{{ redis_image }}"
        source: pull

    - name: Run Docker container
    ansible.builtin.docker_container:
        name: "{{ redis_container_name }}"
        image: "{{ redis_image }}"
        state: started
        ports:
        - "{{ redis_port }}:{{ redis_port }}"

    - name: Wait for the container to be ready
    ansible.builtin.wait_for:
        host: "ansible-target"
        port: "{{ redis_port }}"
        state: started
        delay: 10
        timeout: 60
        msg: "Redis is not available on port {{ redis_port }}"

    - name: Test connection to container
    command: redis-cli -h ansible-target -p {{ redis_port }} ping
    register: redis_ping

    - name: Show Redis response
    debug:
        msg: "{{ redis_ping.stdout }}"

    - name: Stop and remove Docker container
    ansible.builtin.docker_container:
        name: "{{ redis_container_name }}"
        state: absent
        force_kill: yes
    ```

* zauważyć można, że niektóre zmienne zostały zastąpione symbolicznymi nazwami, a nie konkretnymi wartościami - nazwy te zostały zdefiniowane w *deploy_container/defaults/[*main.yml*](./Lab8/deploy_container/defaults/main.yml)*
    ``` yml
    ---
    redis_image: "tomaszek03/redis-app:latest"
    redis_container_name: "redis-app"
    redis_port: 6379
    ```
* utworzyłem [`playbook`](./Lab8/playbook3.yaml), który korzysta z utworzonej roli
    ``` yaml
    ---
    - hosts: Endpoints
    become: yes
    roles:
        - deploy_container
    ```

Aby skorzystać z utworzonej roli, wystarczyło uruchomić `playbooka`, który z niej korzysta.
![ss](./Lab8/screenshots/ss24.png)