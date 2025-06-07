# Sprawozdanie 3
Szymon Majdak
## Laboratorium nr 8 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible
Do tych zajęć wykorzystałem maszynę wirtualną stworzoną kickstartem na laboratoriach nr 9.

### Instalacja zarządcy Ansible

Na tej maszynie pobrałem oprogramowanie `tar` i `sshd`.

![1](https://github.com/user-attachments/assets/8b4c2a97-1ad2-422e-96a8-4052c087ad8c)

Następnie uruchomiłem `sshd`, stowrzyłem urzytkownika `ansible` oraz zmieniłem nazwę hosta na `ansible-target` komendami:

```sudo systemctl enable --now sshd```

```sudo useradd -m -s /bin/bash ansible```

```sudo passwd ansible```

```sudo hostnamectl set-hostname ansible-target```

![3](https://github.com/user-attachments/assets/944ec438-8b98-4bc4-9f62-fb2a81c5a376)

Po tym stworzyłem migawkę maszyny:

![4](https://github.com/user-attachments/assets/65238f78-6fe1-46d2-a5fb-a5af2aab9ead)

Następnie pobrałem oprogramowanie `ansible`:

![5](https://github.com/user-attachments/assets/9535a4bd-5829-47fb-bd22-3580b86e4454)

Finalnie wymieniłem klucze SSH między oboma maszynami tak, aby nie było wymagane podawanie hasła:

![6](https://github.com/user-attachments/assets/1bb621f9-28e1-40b4-8842-8958fb1af248)

![7](https://github.com/user-attachments/assets/290ac561-cde8-49be-844e-ca86b2f2a6e6)

Efekt:
![8](https://github.com/user-attachments/assets/b0128280-12e8-4493-bb6b-7ed97a04db8e)

### Inwentaryzacja

Ustawiłem nazwy hosta `orchestrator` oraz `endpoint1` za pomocą `hostnamectl`.

![9](https://github.com/user-attachments/assets/8859c952-8e8f-44c7-a4d5-4b16eac06e63)

![10](https://github.com/user-attachments/assets/ef5a5b3c-c8fe-496c-8ffa-654a3f2a2a19)

Wprowadziłem też nazwy DNS do maszyn wirtualnych, przez co mogłem wywoływać te maszyny po ich nazwach, a nie po adresach IP.

![11](https://github.com/user-attachments/assets/788de8a5-38ca-49e7-b48e-76ee75bae9d5)

Zweryfikowałem łączność:
![12](https://github.com/user-attachments/assets/21e75f69-fbb0-4166-98cd-7104db4ff2e4)

Następnie stworzyłem plik inwentaryzacji `inventory.ini`, do którego dodałem sekcje Orchestrators i Endpoint i uzupełniłem je moimi nazwami hostów.

Inventory.ini:
```
[Orchestrators]
orchestrator

[Endpoints]
endpoint1
```

Wysłałem pinga do Wszystkich Endpointów:

![14](https://github.com/user-attachments/assets/19094458-2715-40e5-a96b-e0c02ea5209b)

### Zdalne wywoływanie procedur

W tym kroku stworzyłem `playbook-ansible`, który:
- wysyła żądanie ping do wszystkich maszyn
- kopiuje plik `inventory.ini` na endpointy
- wyświetla zawartość `inventory.ini` na zdalnej maszynie
- wypisuje zawartość `inventory.ini`
- aktualizuje wszystkie pakiety
- restartuje usługę sshd
- restartuje usługę rngd

`playbook.yml`:
```
- name: Procedury zdalne
  hosts: Endpoints
  become: true

  tasks:
    - name: Test ping (czy host jest dostępny)
      ansible.builtin.ping:

    - name: Skopiuj plik inventory.ini na endpointy
      ansible.builtin.copy:
        src: ./inventory.ini
        dest: /home/ansible/inventory.ini
        owner: ansible
        group: ansible
        mode: '0644'

    - name: Wyświetl zawartość inventory.ini na zdalnej maszynie
      ansible.builtin.command: cat /home/ansible/inventory.ini
      register: inventory_cat

    - name: Wypisz zawartość inventory.ini
      ansible.builtin.debug:
        var: inventory_cat.stdout_lines

    - name: Aktualizuj wszystkie pakiety
      ansible.builtin.dnf:
        name: "*"
        state: latest
        update_cache: yes

    - name: Restartuj usługę sshd
      ansible.builtin.service:
        name: sshd
        state: restarted
        enabled: true

    - name: Restartuj usługę rngd
      ansible.builtin.service:
        name: rngd
        state: restarted
        enabled: true
```

Efekt uruchomienia `playbook.yml`

![15](https://github.com/user-attachments/assets/0f84dd1e-c448-4735-8e84-3afb7bd64661)

Następnie komendą `sudo systemctlstop sshd` zatrzymałem tą usługę i jeszcze raz uruchomiłem playbook:

![16](https://github.com/user-attachments/assets/f35c81f8-70cd-4ed1-b7ac-ad0c5f46a9e2)

Zgodnie z oczekiwaniem połączenia nie było.

### Zarządzanie stworzonym artefaktem

Ostatnim zadniem było stworzenie playbooka, który:
- buduje i urzuchamia kontener z redisem z poprzednich zajęć, który jest na DockerHubie
- zweryfikuje łączność z kontenerem
- zatrzyma i usunie kontener

`playbook-redis.yml`:
```
- name: Deploy docker container from Docker Hub
  hosts: Endpoints
  become: true

  vars:
    docker_package: docker
    docker_service: docker
    image_name: pszemo6/redis_runtime:4
    container_name: redis_runtime_test

  tasks:

    - name: Zainstaluj wymagane pakiety
      dnf:
        name: "{{ item }}"
        state: present
      loop:
        - dnf-plugins-core
        - docker
        - python3-docker

    - name: Włącz i uruchom usługę docker
      service:
        name: "{{ docker_service }}"
        state: started
        enabled: true

    - name: Pobierz obraz Dockera z Docker Hub
      community.docker.docker_image:
        name: "{{ image_name }}"
        source: pull

    - name: Uruchom kontener
      community.docker.docker_container:
        name: "{{ container_name }}"
        image: "{{ image_name }}"
        state: started
        restart_policy: unless-stopped
        ports:
          - "6379:6379"

    - name: Poczekaj chwilę na start kontenera
      wait_for:
        port: 6379
        delay: 2
        timeout: 10

    - name: Zweryfikuj, że kontener działa
      shell: docker ps --filter "name={{ container_name }}" --format "{{ '{{' }}.Status{{ '}}' }}"
      register: container_status

    - name: Pokaż status kontenera
      debug:
        msg: "Kontener działa: {{ container_status.stdout }}"

    - name: Zatrzymaj kontener
      community.docker.docker_container:
        name: "{{ container_name }}"
        state: stopped

    - name: Usuń kontener
      community.docker.docker_container:
        name: "{{ container_name }}"
        state: absent
```

Wynik:

![18](https://github.com/user-attachments/assets/af2dd360-2a4b-45ee-b453-8737b76dfaa1)

## Pliki odpowiedzi dla wdrożeń nienadzorowanych

Te zajęcia polegałe na zautomatyzowaniu tworzenia nowej maszyny wirtualnej. Takim ułatwieniem w Fedorze jest plik `anaconda-ks.cfg`, który zapisuje wstępne ustawienia systemu.

Pierwszym zadaniem było uruchomienie nowej maszyny wirtualnej z wykorzystaniem dostosowanego pliku `anacond-ks.cfg`.

Najpierw skopiowałem ten plik z maszyny wirtualnej i dodałem go do repozytorium.

W samym pliku dodałem takie linijki jak:
- linki do danej wersji Fedory
- dostosowaną wielkość dysku
- `clearpart --all --initlabel` formatowanie całości
- `reboot` po instalacji

`anaconda-ks.cfg`:
```
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

# Network information
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=Sombrero

%packages
@^server-product-environment

%end

# Run the Setup Agent on first boot
firstboot --enable

url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part /boot/efi --fstype="efi" --ondisk=sda --size=600 --fsoptions="umask=0077,shortname=winnt"
part /boot --fstype="ext4" --ondisk=sda --size=1024
part pv.48 --fstype="lvmpv" --ondisk=sda --size=8500
volgroup fedora_sombrero --pesize=4096 pv.48
logvol / --fstype="ext4" --grow --maxsize=71680 --size=1024 --name=root --vgname=fedora_sombrero

# System timezone
timezone Europe/Warsaw --utc

#Root password
rootpw --lock
user --groups=wheel --name=smajdak --password=$y$j9T$/bahs7W/A48Fb5cEsqnjNQA8$pTZq9vCbm6BxiOnnwluu5fxSp1t1I87suGAB8.9rlh9 --iscrypted --gecos="Szymon Majdak"

reboot
```

Aby skorzystać z tego pliku, podczas instalacji najechałem na przycisk do instalacji Fedory i nacisnąłem `E`. W otwrym oknie dopisałem skąd instalator ma wziąć plik:

![3](https://github.com/user-attachments/assets/009f5e02-dc6b-45fe-9b9e-2f41b3cf704e)

Wyniki:
![5](https://github.com/user-attachments/assets/8982916b-7b99-47f5-975a-366516c98097)

![7](https://github.com/user-attachments/assets/993516dd-158e-4fce-8286-96b47dd63d3f)

![8](https://github.com/user-attachments/assets/a6d12318-da3c-4888-8150-235a5e53e01d)

Drugą wersją tego zadania było uzupełnienie pliku `anaconda-ks.cfg` o pobranie i uruchomienie mojego kontenera z redisem z poprzednich zajęć.

`anaconda-ks-redis.cfg`:
```
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

# Network information
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=Sombrero

%packages
@^server-product-environment

%end

# Run the Setup Agent on first boot
firstboot --enable

url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64
repo --name=docker-ce --baseurl=https://download.docker.com/linux/fedora/41/x86_64/stable

%packages
@^server-product-environment
docker-ce
docker-ce-cli
containerd.io
%end

%post --log=/root/ks-post.log
systemctl enable docker

mkdir -p /opt/scripts

cat > /opt/scripts/start-redis.sh << 'EOF'
#!/bin/bash
sleep 10
docker run -d --name redis --restart=always -p 6379:6379 pszemo6/redis_runtime:4
EOF

chmod +x /opt/scripts/start-redis.sh

cat > /etc/systemd/system/start-redis-container.service << 'EOF'
[Unit]
Description=Start Redis container from Docker Hub
After=network-online.target docker.service
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/opt/scripts/start-redis.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl enable start-redis-container.service
%end

# Run the Setup Agent on first boot
firstboot --enable

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part /boot/efi --fstype="efi" --ondisk=sda --size=600 --fsoptions="umask=0077,shortname=winnt"
part /boot --fstype="ext4" --ondisk=sda --size=1024
part pv.48 --fstype="lvmpv" --ondisk=sda --size=8500
volgroup fedora_sombrero --pesize=4096 pv.48
logvol / --fstype="ext4" --grow --maxsize=71680 --size=1024 --name=root --vgname=fedora_sombrero

# System timezone
timezone Europe/Warsaw --utc

#Root password
rootpw --lock
user --groups=wheel --name=smajdak --password=$y$j9T$/bahs7W/A48Fb5cEsqnjNQA8$pTZq9vCbm6BxiOnnwluu5fxSp1t1I87suGAB8.9rlh9 --iscrypted --gecos="Szymon Majdak"

reboot
```

Wynik:
![image](https://github.com/user-attachments/assets/c1b8969a-65b5-4049-9f2f-032013b3b091)



