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

---

# Lab 9
---

Pobrałem plik `anaconda-ks.cfg` i dodałem do niego url do mirrora, nazwe hosta i sekcję post.

```ini
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

%packages
@^custom-environment

%end

# Run the Setup Agent on first boot
firstboot --enable

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
autopart
# Partition clearing information
clearpart --all

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --iscrypted --allow-ssh $y$j9T$sv/NneP/7bvCksr3Grj4eGYC$LKhLLz56YRopOiEtn2.E57I4y9cxBJ1bHs31sMo3mZ0
user --groups=wheel --name=user --password=$y$j9T$dEbPZxjAOm6DrXW0pHkYvc8i$9DB42o70wUkWqzoEfeYVrYlICxB7GiFUvJz7R3SatO9 --iscrypted --gecos="user"

# ISO url
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=aarch64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=aarch64

# Hostname
network --hostname=Fedora

# Post
%post

dnf -y install dnf-plugins-core
dnf config-manager --add-repo=https://download.docker.com/linux/fedora/docker-ce.repo

dnf install -y docker-ce docker-ce-cli containerd.io

systemctl enable docker

usermod -aG docker user

cat << 'EOF' > /etc/rc.d/rc.local

docker pull cumil/apache-basic:latest
docker run -d --name apache_container cumil/apache-basic:latest
EOF

%end
```

Uruchomiłem instalator i wrzuciłem plik odpowiedzi jako argument.
![instalacja dodanie configu](./lab9/image.png)

Po uruchomieniu kontener zadziałał i zwrócił plik index.html.
![result](./lab9/)