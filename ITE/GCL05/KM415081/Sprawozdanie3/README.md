# Zajęcia 08
## Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible
Celem laboratorium jest zautomatyzowanie zarządzania środowiskiem wielomaszynowym przy użyciu Ansible. W ramach zadania skonfigurowano co najmniej dwie maszyny wirtualne z bezhasłowym dostępem SSH, utworzono inwentarz systemów oraz przygotowano playbooki do wykonywania podstawowych operacji administracyjnych, takich jak pingowanie maszyn, aktualizacja pakietów, zarządzanie kontenerami Docker oraz przesyłanie i uruchamianie aplikacji. Wszystkie te działania zostały ujęte w rolę Ansible, co umożliwia ich powtarzalne i zautomatyzowane wykonywanie, eliminując konieczność ręcznego zarządzania poszczególnymi maszynami i procesami wdrożeniowymi.

### Instalacja zarządcy Ansible
#### Utworzenie nowej maszyny wirtualnej
W VirtualBox stworzono maszynę o jak najmniejszym zbiorze zainstalowanego oprogramowania, z tym samym systemem operacyjnym co uprzednio używana maszyna. Dodatkowo zapewniono obecność programu 'tar' i 'sshd', ustawiono hostname i użytkownika odpowiednio jako 'ansible-target' oraz 'ansible'.

![Opis obrazka](lab8/1.png)

Dodatkowo wykonano migawkę maszyny oraz jej eksport.

![Opis obrazka](lab8/2.png)

#### Instalacja Ansible
Na głównej maszynie zainstalowano oprogramowanie Ansible.
![Opis obrazka](lab8/3.png)

#### Wymieniono klucze SSH pomiędzy użytkownikami na maszynach, aby logowanie przez ssh nie wymagało wpisywania hasła.
![Opis obrazka](lab8/4.png)

### Inwentaryzacja
#### Dokonano następującej inwentaryzacji systemów
Po ustawieniu przewidywalnych nazw maszyn wirtualnych 'ansible-controller' oraz 'ansible-target' używając 'hostnamectl', wprowadzono nazwy DNS maszyn stosując 'etc/hosts' na obu maszynach.
![Opis obrazka](lab8/5.png)

![Opis obrazka](lab8/6.png)

Działanie to umożliwia wywoływanie komputerów za pomocą nazw, a nie tylko wykorzystywaniu adresów IP. Zweryfikowano łączność używając wzajemny 'ping'.
![Opis obrazka](lab8/7.png)

![Opis obrazka](lab8/8.png)

Stworzono plik inwentaryzacji 'inventory.ini' z sekcjami 'Orchestrators' oraz 'Endpoints'
```sh
[Orchestrators]
ansible-controller ansible_host=10.0.2.15 ansible_user=cadmus

[Endpoints]
ansible-target ansible_host=10.0.2.4 ansible_user=ansible
```
Na testa wysłano żądanie 'ping' do wszystkich maszyn.
![Opis obrazka](lab8/9.png)

### Zdalne wywołanie procedur
#### Utworzono pierwszy 'playbook.yaml'
```sh
- hosts: all
  become: true
  tasks:
    - name: Ping machines
      ansible.builtin.ping:

    - name: Copy inventory file (only to ansible-target)
      ansible.builtin.copy:
        src: ./inventory.ini
        dest: /tmp/inventory.ini
      when: inventory_hostname == 'ansible-target'

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
Playbook wysyła kolejno żądanie 'ping' do wszystkich maszyn, kopiuje plik inwentaryzacji na maszynę 'ansible-target', aktualizuje pakiety w systemie oraz restartuje usługi sshd oraz rngd. Pierw zainstalowano narzędzie 'rngd'.
![Opis obrazka](lab8/10.png)

Pierwsze uruchomienie playbooka:
![Opis obrazka](lab8/11.png)

Drugie uruchomienie playbooka:
![Opis obrazka](lab8/12.png)

Trzecie uruchomienie (z uprzednio wyłączonym serwerem SSH na maszynie 'ansible-target'):
![Opis obrazka](lab8/13.png)

![Opis obrazka](lab8/14.png)

### Zarządzanie stworzonym artefaktem
#### Artefaktem poprzednich zajęć był kontener
Pierw dodano obraz do repo na Docker Hub.
![Opis obrazka](lab8/15.png)

Kolejno stworzono rolę 'app', strukturę katalogów i plików dla roli Ansible. Dodano kolejne zadania w folderze 'app/tasks/':

install.yml - instaluje Dockera
```sh
- name: Install packages
  ansible.builtin.yum:
    name:
      - yum-utils
      - device-mapper-persistent-data
      - lvm2
    state: present

- name: Add Docker repository
  ansible.builtin.yum_repository:
    name: docker-ce
    description: Docker CE Repo
    baseurl: https://download.docker.com/linux/centos/7/x86_64/stable/
    gpgcheck: yes
    gpgkey: https://download.docker.com/linux/centos/gpg
    enabled: yes

- name: Install Docker
  ansible.builtin.yum:
    name: docker-ce
    state: latest

- name: Docker service
  ansible.builtin.service:
    name: docker
    state: started
    enabled: true
```

container.yml - pobranie obrazu i uruchomienie kontenera
```sh
- name: Pull image
  ansible.builtin.docker_image:
    name: cadmusinho/nodedeploy
    source: pull

- name: Run container
  ansible.builtin.docker_container:
    name: deploy-container
    image: cadmusinho/nodedeploy
    state: started
    restart_policy: always
    ports:
      - "3000:3000"
```

verify_container.yml - weryfikacja działania kontenera
```sh
- name: Test HTTP
  ansible.builtin.shell: "curl -s -o /dev/null -w '%{http_code}' http://localhost:3000"
  register: curl_result

- name: HTTP status code
  ansible.builtin.debug:
    var: curl_result.stdout
```

clean.yml - zatrzymanie i usunięcia kontenera
```sh
- name: Stop container
  ansible.builtin.docker_container:
    name: deploy-container
    state: stopped
    force_kill: true

- name: Remove container
  ansible.builtin.docker_container:
    name: deploy-container
    state: absent
```

install_py.yml - instalacja biblioteki 'requests' (dodany po pierwszym (błędnym) uruchomieniu)
```sh
- name: Install python3-requests on target
  ansible.builtin.yum:
    name: python3-requests
    state: present
  become: yes
```

main.yml - główne zadanie odpalające te wcześniejsze
```sh
---
# tasks file for app

- name: Install Docker on target host
  import_tasks: install.yml

- name: Install python3-requests on target
  import_tasks: install_py.yml

- name: Deploy container from Docker Hub
  import_tasks: container.yml

- name: Verify container
  import_tasks: verify_container.yml

- name: Clean container
  import_tasks: clean.yml
```

Dodano jeszcze plik run_app.yaml który wykorzystuje rolę 'app'.
run_app.yaml - playbook
```sh
---
- hosts: Endpoints
  become: yes
  roles:
    - app
```

Zadania w playbooku podzielono na moduły dzięki czemu kod jest bardziej przejrzysty i łatwiej go utrzymać. Instalacja zależności, jak python3-requests, została wyodrębniona, co zapobiega błędom związanym z brakującymi bibliotekami potrzebnymi do działania modułów Ansible. Sprawdzenie działania aplikacji przez test HTTP pozwala automatycznie potwierdzić sukces wdrożenia, a końcowe usunięcie kontenera utrzymuje porządek i oszczędza zasoby.

Pierwsze uruchomienie (błedne) playbooka:
![Opis obrazka](lab8/16.png)

Ostatnie (poprawne) uruchomienie playbooka:
![Opis obrazka](lab8/18.png)

# Zajęcia 09
## Pliki odpowiedzi dla wdrożeń nienadzorowanych
Celem ćwiczenia było praktyczne opanowanie automatycznego instalowania Fedory za pomocą plików Kickstart. W trakcie zajęć stworzono i dostosowano plik odpowiedzi, który pozwala na bezobsługową instalację systemu, w tym konfigurację użytkowników, repozytoriów, partycjonowanie dysku oraz automatyczne uruchomienie kontenera Docker.

### Utworzono nową maszynę Fedora
![Opis obrazka](lab9/8.png)

### Plik 'anaconda-ks.cfg'
Na starej maszynie pobrano ten plik odpowiedzi i nadano mu uprawnienia do odczytu.
![Opis obrazka](lab9/1.png)

### Edycja pliku odpowiedzi
Po zapoznaniu się z dokumentacją wykonano kolejno czynności:
- dodanie potrzebnych repozytoriów
- założenie czystego dysku i formatowania całości
- ustawiono hostname

anaconda-ks.cfg
```sh
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
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

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
autopart
# Partition clearing information
clearpart --all  --initlabel
autopart

# System timezone
timezone Europe/Warsaw --utc

network --hostname=trzecia

url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

#Root password
rootpw --lock
user --groups=wheel --name=cadmus --password=$y$j9T$1jYL4ytD050gFyYG9rFmnFNe$FHz/mlvsMtaON1Ul31paOJ0QxphttD/YamQjJwJIjr3 --iscrypted --gecos="Kacper Mierzwa"

firstboot --enable
```

### Przeprowadzenie instalacji
Po wrzuceniu pliku odpowiedzi na soją gałąź w repozytorium przedmiotowym, uruchomiono nową maszynę z płyty ISO i po naciśnięciu klawisza 'e' na ekranie GRUB dokonano wpisu do używania pliku 'kickstart'. 
![Opis obrazka](lab9/2.png)

Przebieg instalacji:
![Opis obrazka](lab9/3.png)

![Opis obrazka](lab9/4.png)

![Opis obrazka](lab9/5.png)

![Opis obrazka](lab9/6.png)

### Rozszerzenie pliku odpowiedzi
anaconda-ks2.cfg
```sh
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

# Disk configuration
ignoredisk --only-use=sda
autopart
clearpart --all --initlabel

# System timezone
timezone Europe/Warsaw --utc

# Network
network --hostname=trzecia

# Repositories
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

# Users
rootpw --lock
user --groups=wheel --name=cadmus --password=$y$j9T$1jYL4ytD050gFyYG9rFmnFNe$FHz/mlvsMtaON1Ul31paOJ0QxphttD/YamQjJwJIjr3 --iscrypted --gecos="Admin User"

%packages
@^server-product-environment
wget
curl
docker
%end

firstboot --enable

%post --log=/root/post-install.log --interpreter=/bin/bash

echo "==> Setting up Docker..."
systemctl enable docker
systemctl start docker
usermod -aG docker cadmus

echo "==> Deploying Node.js container..."
docker pull cadmusinho/nodedeploy:latest

cat <<EOF > /etc/systemd/system/nodedeploy.service
[Unit]
Description=Node.js Application Container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --rm -p 3000:3000 --name nodedeploy cadmusinho/nodedeploy:latest
ExecStop=/usr/bin/docker stop nodedeploy

[Install]
WantedBy=multi-user.target
EOF

systemctl enable nodedeploy.service
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload

echo "==> Node.js app deployment complete."
%end

reboot
```

Ten rozszerzony plik instalacyjny Fedora Kickstart umożliwia w pełni automatyczną, nienadzorowaną instalację systemu z konfiguracją sieciową, użytkownikami i repozytoriami niezbędnymi do działania projektu. Sekcja %packages dopina niezbędne pakiety, w tym Dockera, wget i curl, zapewniając pełne środowisko do późniejszego wdrożenia kontenera. W sekcji %post uruchamiane są skrypty powłoki, które konfigurują i uruchamiają usługę Dockera, dodają użytkownika cadmus do grupy docker oraz pobierają i uruchamiają kontener cadmusinho/nodedeploy:latest. Aby zapewnić automatyczny start aplikacji Node.js po restarcie systemu, tworzony jest i aktywowany systemdowy serwis nodedeploy.service, który zarządza cyklem życia kontenera. Dodatkowo otwierany jest port 3000 w firewallu, co umożliwia dostęp do aplikacji z zewnątrz. Całość kończy się poleceniem restartu systemu, które pozwala na pełne wdrożenie konfiguracji i uruchomienie środowiska produkcyjnego bez żadnej interakcji użytkownika.

Weryfikacja działania:
![Opis obrazka](lab9/7.png)
