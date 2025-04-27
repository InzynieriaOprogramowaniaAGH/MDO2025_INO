### Lab 8
---
## Instalacja zarządcy Ansible
Zacząłem od postawienia nowej maszyny z systemem Fedora, w dokładnie takiej samej wersji jak poprzednia. Utworzylem uytkownika o nazwie `ansible`, zmieniłem hostname na `ansible-target` i zainstalowałem `tar` a następnie potwierdziłem obecność `sshd`. 
![nowa fedora](./lab7/nowa-fedora.png)

Utworzyłem snapshot maszyny.
![snapshot](./lab7/snapshot.png)

Na głównej maszynie zainstalowałem `ansible`
![ansible install main](./lab7/ansible-install-main.png)

A następnie wymieniłem klucze SSH między `userem` na głównej maszynie a `ansible` na nowej, oraz przetestowałem łączność bez hasła.
![wymiana kluczy](./lab7/wymiana-kluczy.png)

## Inwentaryzacja

Zmieniłem hostname's maszyn na `ansible-main` i `ansible-target`, oraz wpisałem je do `/etc/hosts/`. Zweryfikowałem łączność po nazwach przez `ping`.
![zmiana hostname main](./lab7/hostname-main.png)
![ping po hostname main -> target](./lab7/ping-nazwa-main.png)

![zmiana hostname target](./lab7/hostname-target.png)
![ping po hostname target -> main](./lab7/ping-nazwa-target.png)

Utworzyłem i uzupełniłem plik `inventory.ini`, oraz sprawdziłem działanie inventory ansible.

![inventory](./lab7/inventory.png)
![inventory](./lab7/inventory.ini)
![ansible ping all](./lab7/ansible-ping-test.png)

## Zdalne wywoływanie procedur

Utworzyłem playbook w pliku `ping_all.yml`, który pinguje wszystkie maszyny i sprawdziłem jego działanie.

![playbook](./lab7/ping-all.png)
![playbook](./lab7/ping_all.yml)
![playbook](./lab7/ping-all-playbook-test.png)

Utworzyłem playbook do kopiowania pliku `inventory` na maszyny z `endpoints`. Pierwsze uruchomienie:
![playbook copy](./lab7/copy-inv-playbook.png)
![playbook copy](./lab7/copy-inv-run-1.png)
![playbook copy](./lab7/copy-inv-target.png)

Podczas drugiego uruchomienia ansible sprawdził tylko czy kopiowany plik istnieje i jak zobaczył, ze tak to nie wprowadził w nim zadnych zmian.
![playbook copy run 2](./lab7/copy-inv-run-2.png)

Utworzyłem playbook do zaaktualizowania pakietów w systemie. Problemem były wymagane uprawnienia, rozwiązałem to dodając do uzytkownika `ansible` regułę `NOPASSWD: ALL`. Jest to rozwiązanie BARDZO niebezpieczne w środowisku produkcyjnym, lecz na potrzebę laboratoriów wystarczające.
![nopasswd](./lab7/target-nopasswd.png)
![update packages](./lab7/update-packages.png)
![update packages](./lab7/update-packages-run.png)

Utworzyłem playbook do zrestartowania usług `sshd` i `rngd`. Pierwsza usługa została zrestartowana ale `rngd` nie jest zainstalowane.
![restart services](./lab7/restart-services.png)
![restart services](./lab7/restart-services-run.png)

Na koniec sprawdziłem jak ansible zachowa się gdy w targecie wyłączone będzie ssh, lub odłączona będzie karta sieciowa. Po teście uruchomiłem sshd ponownie i ponownie podlaczylem karte sieciowa.
![ssh off](./lab7/stop-sshd.png)
![ssh off test](./lab7/ssh-off-test.png)

![wylaczenie karty](./lab7/wylaczenie-karty.png)
![wylaczenie karty](./lab7/wylaczenie-karty-test.png)

## Zarządzanie stworzonym artefaktem

Deployment mojego poprzedniego projektu nie zadziałał, więc jako alternatywę wybrałem `apache server`. Na maszynie docelowej zainstalowałem dockera za pomocą playbooka.

```yml
- name: Install Docker
  hosts: endpoints
  become: yes
  tasks:
    - name: Install dependencies
      dnf:
        name:
          - dnf-plugins-core
          - yum-utils
          - device-mapper-persistent-data
          - lvm2
        state: present

    - name: Add Docker repo
      get_url:
        url: https://download.docker.com/linux/fedora/docker-ce.repo
        dest: /etc/yum.repos.d/docker-ce.repo

    - name: Install Docker engine
      dnf:
        name:
          - docker-ce
          - docker-ce-cli
          - containerd.io
        state: latest

    - name: Enable and start Docker
      systemd:
        name: docker
        enabled: yes
        state: started

```

![install docker](./lab7/install-docker-run.png)

Następnie utworzyłem kolejnego playbooka do pobrania `httpd`, uruchomienia kontenera, sprawdzenia dostępności a na koniec zatrzymania i usunięcia kontenera. Konieczne było tez doinstalowanie wymaganych pakietów.

``` yml
- name: Run and test Apache container
  hosts: endpoints
  become: true

  tasks:
    - name: Install pip
      package:
        name: python3-pip
        state: present

    - name: Install packaging module (required by Docker collection)
      package:
        name: python3-packaging
        state: present

    - name: Install required Python packages (requests, docker)
      pip:
        name:
          - requests
          - docker
        executable: pip3

    - name: Pull Apache image
      community.docker.docker_image:
        name: httpd
        source: pull

    - name: Run Apache container
      community.docker.docker_container:
        name: apache
        image: httpd
        state: started
        ports:
          - "8080:80"

    - name: Wait for Apache to respond
      uri:
        url: http://localhost:8080
        return_content: yes
        status_code: 200
      register: apache_response
      retries: 5
      delay: 2
      until: apache_response.status == 200

    - name: Stop Apache container
      community.docker.docker_container:
        name: apache
        state: stopped

    - name: Remove Apache container
      community.docker.docker_container:
        name: apache
        state: absent
```
![run apache run](./lab7/run-apache-run.png)

Przeniosłem logikę z playbooka `run_apache` do roli za pomocą `ansible-galaxy`.

do `main.yml` w katalogu tasks:

``` yml
---
- name: Install pip
  package:
    name: python3-pip
    state: present

- name: Install packaging module (required by Docker collection)
  package:
    name: python3-packaging
    state: present

- name: Install required Python packages (requests, docker)
  pip:
    name:
      - requests
      - docker
    executable: pip3

- name: Pull Apache image
  community.docker.docker_image:
    name: httpd
    source: pull

- name: Run Apache container
  community.docker.docker_container:
    name: apache
    image: httpd
    state: started
    ports:
      - "8080:80"

- name: Wait for Apache to respond
  uri:
    url: http://localhost:8080
    return_content: yes
    status_code: 200
  register: apache_response
  retries: 5
  delay: 2
  until: apache_response.status == 200

- name: Stop Apache container
  community.docker.docker_container:
    name: apache
    state: stopped

- name: Remove Apache container
  community.docker.docker_container:
    name: apache
    state: absent
```


do `deploy_apache.yml`:

```yml
- name: Deploy Apache via role
  hosts: endpoints
  become: yes

  roles:
    - deploy_apache
```

![deploy apache run](./lab7/deploy-apache-run.png)