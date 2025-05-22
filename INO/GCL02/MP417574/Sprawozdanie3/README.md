# Sprawozdanie 3
## Meg Paskowski
## Grupa: 2
## Zajecia 8-11
### Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible (lab 8)

Będziemy potrzebować drugiej maszyny wirtualnej. Dla oszczędności zasobów, musi być jak najmniejsza i jak najlżejsza.

- `fedora-main` – główna maszyna (zarządca / orchestrator)
- `ansible-target` – maszyna docelowa (endpoint)

Utworzenie drugiej maszyny wirtualnej z systemem `Fedora`. Przy najmniejszym zbiorze zainstalowanego oprogramowania.

Zmaiana nazwy hosta.

![host-name](IMG/Host-name.png)

Ustawienia użytkownika.

![user](IMG/User.png)

Sprawdzenie, czy na maszynie jest `tar` i `sshd`.

![tar_ssh](IMG/tar_ssh.png)

Utworzenie mikawki maszyny -> pełne spakowanie maszyny wirtualnej (dysk, konfiguracja) do pliku .ova (standard Open Virtualization Format). Dzięki temu jesteśmy w stanie:
- Skopiować maszynę na inny komputer,
- Udostępnić maszynę komuś innemu,
- Zachować backup na przyszłość.

Wybrałam na pasku `Maszyna` → `Narzędzia` → `Migawki` i następnie `Zrób`

![migawka1](IMG/migawka1.png)

![migawka2](IMG/migawka2.png)

Do wykonania eksportu maszyny `Plik` → `Eksportuj urządzenie wirtualne...`

![eksport](IMG/eksport.png)

Na maszynie głównej podbrałam `Ansible`.

```bash
sudo dnf install ansible -y

#Sprawdzenie
ansible --version

```

![ansible](IMG/ansible.png)

Następnie, aby zmienić klucze ssh tak, by logowanie `ssh ansible@ansible-target` nie wymagało podania hasła wykonalam następujące kroki:

Skopiowałam kod publiczny z maszyny głównej na `ansible-target`.

```bash
ssh-copy-id ansible@192.168.0.86
```

Edytowalam plik `sudo nano /etc/hosts` dodając `192.168.0.86 ansible-target`, `192.168.0.7 fedora-main` i sprawdziłam połaczenie przez ssh.

```bash
ssh ansible@ansible-target
```

![ansible-ssh](IMG/ssh_ansible.png)

Na głownej maszynie bylo należalo zmienic ustawienie `hostname` oraz dodac do pliku `/etc/hosts` → `192.168.0.7 fedora-main` i `192.168.0.86 ansible-target`.

```bash
sudo hostnamectl set-hostname fedora-main

#Edycja pliku hosts
sudo nano /etc/hosts

```
Naleźy rowniez skopiować klucz `ssh-copy-id mpaskowski@fedora-main` z maszyny głownej.


Na sam koniec zwerifikowałam `ping`.

Z maszyny `fedora-main`:

![ping-fedora-main](IMG/ping-fedora-main.png)

Z maszyny `ansible-target`:

![ping-ansible](IMG/ping-ansible.png)


Następnie utworzylam plik inwentaryzacji.
Plik inventory w Ansible to prosty plik tekstowy, który zawiera informacje o hostach, do których Ansible ma się połączyć i zarządzać nimi. W pliku inventory dodajee maszyny, które będą klasyfikowane w odpowiednich grupach, takich jak `Orchestrators` (maszyna główna) i `Endpoints` (maszyny docelowe) u mnie pod nazwą `TargetMachines`.
Zaczelam od utworzenia katalogu `ansible_1` w ktorym bedzie `inventory.ini` (`nano inventory`).

Zawartość pliku `inventory.ini`:
```
[TargetMachines]
ansible-target ansible_ssh_user=ansible 

[Orchestrators]
fedora-main ansible_ssh_user=mpaskowski 
```

W pliku `/etc/ansible/ansible.cfg ` ustawiłam ścieżkę dla pliku `inventory.ini`:

```bash
[defaults]
inventory = /home/mpaskowski/MDO2025_INO/INO/GCL02/MP417574/Sprawozdanie3/ansible_1/inventory.ini
```

Plik możemy przetestować za pomocą komendy ping.

```bash
ansible -i inventory.ini -m ping TargetMachines

ansible -i inventory.ini -m ping Orchestrators
```

![ping](IMG/results_ping.png)


#### Zdalne wywoływanie procedur
Utworzyłam katalog `` w którm znajdować się będą wszytkie playbook'i.

1. Utworzyłam plik `ping_all_machines.yml` → mająct na celu wysłanie żądania ping'u do wszystkich maszyn.
Zawartość pliku:

```yml
---
- name: Pingowanie wszystkich maszyn
  hosts: all        # Odwołanie do wszystkich maszyn z inventory
  tasks:
    - name: Wykonaj ping do wszystkich maszyn
      ansible.builtin.ping:

```

Aby uruchomić:

```bash
nsible-playbook ping_all_machines.yml -i /home/mpaskowski/MDO2025_INO/INO/GCL02/MP417574/Sprawozdanie3/ansible_1/inventory.ini
```

![ping_all](IMG/ping_all.png)

2. Plik `copy_inventory.yml` → który będzie kopiować plik inwentaryzacji na maszyne `Endpoints` (u mnie `TargetMachines`).

```yml
---
- name: Skopiowanie pliku inwentaryzacji na maszyny Endpoints
  hosts: TargetMachines   # Grupa maszyn, do ktrych kopiujemy pliki
  tasks:
    - name: Skopiowanie pliku inventory.ini na maszynę
      copy:
        src: /home/mpaskowski/MDO2025_INO/INO/GCL02/MP417574/Sprawozdanie3/ansible_1/inventory.ini  # Ścieżka do pliku lokalnego
        dest: /home/ansible/ # Ścieżka docelowa na maszynach z grupy Endpoints
        mode: '0644'  #Uprawnienia
```

Aby uruchomić:

```bash
ansible-playbook -i /home/mpaskowski/MDO2025_INO/INO/GCL02/MP417574/Sprawozdanie3/ansible_1/inventory.ini copy_inventory.yml
```

![copy_1](IMG/copy_1.png)

Po ponownym uruchomieniu:

![copy_2](IMG/copy_2.png)

3. Plik `upadte.yml` → dokonuje aktualizacji pakietów w systemie.
Zawartość pliku `upadte.yml`:

```yml
---
- name: Zaktualizuj pakiety w systemie
  hosts: all
  become: yes  # Wymaga podniesienia uprawnień do roota
  tasks:
    - name: Zaktualizuj wszystkie pakiety
      ansible.builtin.dnf:
        name: '*'
        state: latest

```

Aby uruchomić:

```bash
ansible-playbook -i /home/mpaskowski/MDO2025_INO/INO/GCL02/MP417574/Sprawozdanie3/ansible_1/inventory.ini update.yml --ask-become-pass
```

![Update](IMG/update.png)

4. Plik `restart_services.yml` → restartuje usługi `ssh` i `rngd`.

Zawartość pliku ` restart_services.yml`:

```yml
---
- name: Zrestartuj usługi sshd i rngd
  hosts: all
  become: yes 
  tasks:
    - name: Zrestartuj usługę sshd
      ansible.builtin.systemd:
        name: sshd
        state: restarted

    - name: Zrestartuj usługę rngd
      ansible.builtin.systemd:
        name: rngd
        state: restarted

```

Aby uruchomić:

```bash
ansible-playbook -i /home/mpaskowski/MDO2025_INO/INO/GCL02/MP417574/Sprawozdanie3/ansible_1/inventory.ini restart_services.yml --ask-become-pass
```

![restart_services](IMG/restart_services.png)

Wszytkie te polecenia mogą zostać uwgzlędnione w jednym pliku → `all_tasks.yml`.

```bash
ansible-playbook -i /home/mpaskowski/MDO2025_INO/INO/GCL02/MP417574/Sprawozdanie3/ansible_1/inventory.ini all_tasks.yml --ask-become-pass
```

![all_tasks](IMG/all_tasks.png)

5. Przeprowadziłam operacje względem maszyny z wyłączonym serwerem SSH, odpiętą kartą sieciową.

Wyłączenie serwera SSH i odłączenie karty sieciowej ma na celu zasymulowanie sytuacji, w której maszyna jest "nieosiągalna" zdalnie. Jest to użyteczne w kontekście testowania scenariuszy awarii lub konfiguracji systemu, które wymagają interakcji z maszyną, która nie jest dostępna w normalny sposób.

Kroki które wyonaam przed uruchomieniem poprzednich zadań (na maszynie docelowej - `asimble-target`):

```bash
#Odlaczenie serwera SSH
sudo systemctl stop sshd

#Wylaczenie karty sieciowej
sudo ifconfig eth0 down
```

Następnie uruchomiam wcześniej przeprowadzone zadania.

![test](IMG/test.png)

Podczas wykonywania playbooka Ansible napotkano problem z połączeniem do maszyny ansible-target. Przyczyną błędu było wyłączenie serwera SSH na tej maszynie oraz odłączenie interfejsu sieciowego, co uniemożliwiło nawiązanie połączenia zdalnego. Aby rozwiązać ten problem, przywrócono serwis SSH do działania oraz ponownie aktywowano interfejs sieciowy, co pozwoliło na poprawne wykonanie kolejnych operacji.

#### Zarządzanie stworzonym artefaktem
Moim artefaktem w projekcie z poprzednich zajęć by kontener.
W celu zautomatyzowania procesu użyłam playbooka Ansible oraz struktury ról, utworzonej za pomocą `ansible-galaxy`.
[role](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html)


Uworzyłam nową role `cjson-role`:

```bash
ansible-galaxy init cjson-role
```

![CJSON-role](IMG/cjson-role.png)

Po utworzeniu roli skopiowałam pliki `cjson.rpm` i `main.c` oraz edytowałam plik `main.yaml` tak, aby:
- przesyłał artefakty na `ansible-target`,
- instaluje Dockera oraz jego zależności,
- uruchamia kontener,
- instaluje biblioteki z pliku `.rpm`
- kompuluje program,
- uruchamia program i pobiera wynik.

Zawartość pliku `main.yaml`. Plik znajduje w folderze `cjson/tasks` w stworzonej roli `cjson-role`.

```yaml
---
# tasks file for cjson-role
- name: Create artifacts directory
  become: yes
  file:
    path: /home/ansible/cjson
    state: directory
    owner: ansible
    group: ansible
    mode: '0755'

- name: Copy artifacts to target
  copy:
    src: "{{ item }}"
    dest: /home/ansible/cjson/
    mode: '0644'
  loop:
    - files/cjson.rpm
    - files/main.c

- name: Install python3-requests
  ansible.builtin.dnf:
    name: python3-requests
    state: present

- name: Install Docker
  become: yes
  dnf:
    name: docker
    state: present
  
- name: Ensure Docker is started
  become: yes
  service:
    name: docker
    state: started
    enabled: true

- name: Add ansible to docker group
  user:
    name: ansible
    groups: docker
    append: true

- name: Start fedora container
  community.docker.docker_container:
    name: cjson
    image: fedora:41
    state: started
    command: sleep infinity
    volumes:
      - /home/ansible/cjson:/tmp:z

- name: Install gcc, cjson and tools
  community.docker.docker_container_exec:
    container: cjson
    command: dnf install -y gcc make /tmp/cjson.rpm

- name: Compile source file
  community.docker.docker_container_exec:
    container: cjson
    command: gcc -o /tmp/example /tmp/main.c -lcjson

- name: Run program
  community.docker.docker_container_exec:
    container: cjson
    command: bash -c "LD_LIBRARY_PATH=/usr/local/lib64 /tmp/example"
  register: result

- name: Print the result of the program
  debug:
    var: result.stdout
```

Uruchomienie roli przez playbook-cjson.yaml.

Zawartość pliku `playbook-cjson.yaml`:

```yaml
- name: Deploy CJSON
  hosts: ansible-target
  become: true
  roles:
    - cjson-role
```

Uruchomienie:

```bash
ansible-playbook /home/mpaskowski/MDO2025_INO/INO/GCL02/MP417574/Sprawozdanie3/ansible_playbooks/playbook-cjson.yaml -i /home/mpaskowski/MDO2025_INO/INO/GCL02/MP417574/Sprawozdanie3/ansible_1/inventory.ini --ask-become-pass
```

![wynik_1](IMG/result_1.png)


Inny sposób - za pomocą playbooka Ansible.


Zbudowałam playbooka Ansible, który:
1. Buduje i uruchomia kontener sekcji `Deploy` z poprzednich zajęć.
2. Pobiera z `Docker Hub` aplikację w ramach kroku `Publish`
3. Weryfikuje łączność z kontenerem
4. Zatrzymuje i usuwa kontener

Plik `project.yml`:
```yml
---
- name: Zbudowanie, uruchomienie, weryfikacja i usunięcie kontenera
  hosts: all
  become: yes
  vars_files:
    - /home/mpaskowski/MDO2025_INO/INO/GCL02/MP417574/Sprawozdanie3/ansible_playbooks/vars.yml
  tasks:

    # Krok 1: Zalogowanie do Docker Hub
    - name: Zaloguj się do Docker Hub
      docker_login:
        registry: "docker.io"
        username: "icharne2"
        password: "{{ docker_password }}"  # Przechowuj hasło w zmiennej

    # Krok 2: Pobierz obraz z Docker Hub
    - name: Pobierz obraz z Docker Hub
      docker_image:
        name: "icharne2/cjson-deploy"
        source: pull

    # Krok 3: Zbudowanie i uruchomienie kontenera
    - name: Zbuduj kontener Docker z aplikacją
      docker_container:
        name: "cjson-deploy"
        image: "icharne2/cjson-deploy"
        state: started
        restart_policy: no  # Zapobiegamy automatycznemu restartowi kontenera
        command: "sh -c './example && sleep 9999'"  # Uruchamiamy aplikację 'example' i zatrzymujemy kontener na kilka godzin

    # Krok 4: Weryfikacja, czy aplikacja działa
    - name: Sprawdzenie, czy aplikacja działa
      command: "docker exec cjson-deploy /bin/bash -c './example'"
      register: result
      failed_when: result.rc != 0  # Jeśli aplikacja zakończy się błędem, playbook się nie powiedzie

    # Krok 5: Zatrzymanie kontenera
    - name: Zatrzymanie kontenera cjson-deploy
      docker_container:
        name: "cjson-deploy"
        state: stopped

    # Krok 6: Usunięcie kontenera
    - name: Usunięcie kontenera cjson-deploy
      docker_container:
        name: "cjson-deploy"
        state: absent
```

Uruchomienie:

```bash
ansible-playbook project.yml -i /home/mpaskowski/MDO2025_INO/INO/GCL02/MP417574/Sprawozdanie3/ansible_1/inventory.ini --ask-become-pass
```

![result](IMG/project_result.png)

Przedstawiono sposób wykorzystania Ansible do zdalnego zarządzania systemami operacyjnymi. Wykonane działania obejmowały przygotowanie środowiska, konfigurację dostępu między maszynami, stworzenie pliku inwentaryzacji oraz realizację wybranych operacji administracyjnych za pomocą playbooków.

Zadanie pokazało, że Ansible pozwala na centralne sterowanie wieloma systemami jednocześnie, bez konieczności ręcznego logowania się na każdą maszynę. Dzięki temu możliwe było wykonanie operacji takich jak aktualizacja pakietów, kopiowanie plików czy zarządzanie kontenerami. 

### Pliki odpowiedzi dla wdrożeń nienadzorowanych - Kickstart
Do wykonania zadania skorzystałam z pliku systemu Fedora 41 z poprzenic zajęć. Jako administrator skopiowałam plik pod scieżką `/root/anaconda-ks.cfg` do folderu `Sprawozdanie3`.

Następnie zmodyfikowałam plik `anaconda-ks.cfg` dodając informację o repozytoriach oraz zmieniająć nazwę użytkownika.

Dodane roepozytoria:

```conf
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64
```

Plik po dokonanych zmian został przesłany na Githuba. Następnie skopiowałam link do pliku `Raw` w pliku na Githubie oraz skróciam link za pomocą [TinyURL](https://tinyurl.com/). Uzyskany link `https://tinyurl.com/3ehberxn`.

Podczas instalcji nowej maszyny, w menu statorym instalatora kliknełam `e`, aby wejść do trybu edycji poleceń GRUB. Edytowałam parametry instalacyjne.

![Instalacja](IMG/Lab9/instalacja.png)

Zapisuje zmiany `Crtl-X`.

Instalator uruchomiony w trybie graficznym:

![Instalacja2](IMG/Lab9/instalacja2.png)

Wszytkie informacje po poprawnym odczytaniu pliku powinny się automatycznie załadować.
Po chwili instalator przeszedł dalej.

![Instalacja3](IMG/Lab9/instalacja3.png)

Po zakończeniu należało ponownie urucomić system oraz odpiąć plik `iso`.

![Instalacja4](IMG/Lab9/instalacja4.png)

#### Rozszerzenie pliku odpowiedzi o dodatkowe opcje

W kolejnym kroku rozszerzyłam plik `anaconda-ks.cfg`, dodając:

- `reboot` — aby system automatycznie uruchomił się ponownie po zakończeniu instalacji,  
- `network --hostname=fedora.test` — aby przypisać maszynie nową nazwę hosta,  

Zaktualizowany plik ponownie umieściłam na GitHubie. Przeprowadziłam proces instalacji jeszcze raz — tym razem system samodzielnie wykonał restart po zakończeniu.

Zmieniony plik:

```
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Network information
network --bootproto=dhcp --device=enp0s3 --hostname=fedora.test --ipv6=auto --activate

# Repository Added
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

%packages
@^server-product-environment

%end

# Run the Setup Agent on first boot
firstboot --enable

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda

#Automatic partitioning
autopart

# Partition clearing information
clearpart --none --initlabel

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --iscrypted --allow-ssh $y$j9T$f42zTKc8FiEAXyECki5fEwka$TuNUxPrCp2i9fdDQZY3W7TDOMG9aGTdtVCupZdfmsJ4
user --groups=wheel --name=kickstart --password=$y$j9T$eKgdXsLTmrSEuSPjMoYgokYv$EzoYQqbicne4onhOqzWeVa420g3u.59tCdlzzVbTSb8 --iscrypted --gecos="kickstart"

reboot
```

Wynik sprawdzenie nazwy hosta po ponownej instalacji.

![Hostname](IMG/Lab9/hostname.png)

#### Instalacja biblioteki cjson w wykorzystaniem pliku odpowiedzi

Do wykonania zadania przebudowałam pliki służace do sorprzenia pliku `rpm` z poprzednich zajęć.
W celu udustępnienia biblioteki w formie repozytorium YUM, pobrałam serwer `Apache` i narzędzie `createrepo `.

```bash
sudo dnf install -y httpd createrepo policycoreutils-python-utils
```

Uruchomłam i włączłam HTTPD oraz otworzyłam port 80 

```bash
sudo systemctl enable --now httpd

sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

Następnie utworzyłam katalog `/var/www/html/cjson`.

```bash
sudo mkdir -p /var/www/html/cjson
sudo cp cjson.rpm /var/www/html/cjson/
```

Nadałam poprawny kontekst SELinux i odświeżyłam oraz wygenerowalam metadane RPM

```bash
sudo semanage fcontext -a -t httpd_sys_content_t "/var/www/html/cjson(/.*)?"
sudo restorecon -Rv /var/www/html/cjson

sudo createrepo /var/www/html/cjson
```

Sprawdzenie poprawności dzialania:

```bash
curl -I http://192.168.0.7/cjson/repodata/repomd.xml
curl -s  http://192.168.0.7/cjson/ | grep '\.rpm'
```
Sprawdzenie z przeglądarki, czy działa:

![Resut-www](IMG/Lab9/repo_cjson.png)

Instalacja weryfikująca poprawne pobranie artefaktu z utworzonego repozytorium `cjson`. 

![Resut-www](IMG/Lab9/repo_cjson_inst1.png)

Edycja pliku `anaconda-ks.cfg`:

```
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Network information
network --bootproto=dhcp --device=enp0s3 --hostname=fedora.test --ipv6=auto --activate

# Repository Added
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64
repo --name=cjson --baseurl=http://192.168.0.7/cjson/

%packages
@core
cjson
gcc
glibc
curl
%end

# Run the Setup Agent on first boot
firstboot --enable

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda

#Automatic partitioning
autopart

# Partition clearing information
clearpart --none --initlabel

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --iscrypted --allow-ssh $y$j9T$f42zTKc8FiEAXyECki5fEwka$TuNUxPrCp2i9fdDQZY3W7TDOMG9aGTdtVCupZdfmsJ4
user --groups=wheel --name=kickstart --password=$y$j9T$eKgdXsLTmrSEuSPjMoYgokYv$EzoYQqbicne4onhOqzWeVa420g3u.59tCdlzzVbTSb8 --iscrypted --gecos="kickstart"

# Display result
  %post --interpreter /bin/bash
  echo "Confirming installation..."
  ls /usr/include/cjson
  ls /usr/lib/libcjson*
  %end

reboot
```

Zmiany wprowadzone do pliku:
- Potrzebne pakiety `%packages` między innymi pakiet `cJSON`,
- Repozytorium `cjson`,
- W sekcji `%post` zweryfikowano obecność artefaktu.

Sprawdzenie, czy wszytko przebiegło pomyśłnie:

![Resut](IMG/Lab9/add_repo_cjson.png)

W celu zautomatyzowania procesu można utworzyć bootowalny `.iso`.
Aby tego dokonać należy zmodyfikować obraz instalatora systemu.

Na sam poczatek utworzylam katalog wspoldzielony miedzy Fedora a systemem Windows.

Rozpakowanie `.iso`:

```bash
sudo dnf install -y xorriso

mkdir ~/iso-raw  
cd ~/iso-raw  
xorriso -osirrox on -indev /ścieżka/do/Fedora-41.iso -extract / .  
```

Edycja pliku `boot/grub2/grub.cfg`:

```
  set default="0"
  
  function load_video {
    insmod all_video
  }
  
  load_video
  set gfxpayload=keep
  insmod gzio
  insmod part_gpt
  insmod ext2
  insmod chain
  
  set timeout=0
  ### END /etc/grub.d/00_header ###
  
  search --no-floppy --set=root -l 'Fedora-E-dvd-x86_64-41'
  
  ### BEGIN /etc/grub.d/10_linux ###
  menuentry 'Install Fedora 41' --class fedora --class gnu-linux --class gnu --class os {
  	linux /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=Fedora-E-dvd-x86_64-41 inst.ks=https://tinyurl.com/3ehberxn quiet
  	initrd /images/pxeboot/initrd.img
  }
```

Zawartość pliku: 
- dodanie plik konfiguracji poprzez adres `inst.ks=https://tinyurl.com/3ehberxn`,
- Domyślna opcja - `set default="0"`,
- Aby instalacja rozpoczeła się od razu `set timeout=0`,
- Zmiana etykiety na `Fedora-KickStart`

Uruchomienie w katalogu `~/iso-raw`:

```bah
cd ~/iso-raw
xorriso -as mkisofs \
  -o /media/sf_ShareISO/Fedora-Kickstart.iso \
  -J -R -V "Fedora-Kickstart" \
  .
```

![Instal_Resut](IMG/Lab9/instal.png)

![Instal_Resut_2](IMG/Lab9/fedoraiso.png)

Skryp Powershell Script na systemie Windows - utworzenie maszyny z nowo utworzonego obrazu.

```bash
  $vmName     = "Fedora-instalation"
  $isoPath    = "C:\Users\Meg Paskowski\Desktop\ShareISO\Fedora-Kickstart.iso"
  $diskFolder = "C:\Users\Meg Paskowski\VirtualBox VMs\$vmName"
  $diskPath   = "$diskFolder\$vmName.vdi"
  $VBoxManage = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
  $memory     = 3048
  $cpus       = 2
  
  & $VBoxManage createvm --name $vmName --ostype Fedora_64 --register
  
  & $VBoxManage modifyvm $vmName --memory $memory --cpus $cpus --boot1 dvd --firmware efi
  
  New-Item -ItemType Directory -Path $diskFolder -Force | Out-Null
  & $VBoxManage createhd --filename "$diskPath" --size 2048
  
  & $VBoxManage storagectl $vmName --name "SATA Controller" --add sata --controller IntelAhci
  & $VBoxManage storageattach $vmName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$diskPath"
  
  & $VBoxManage storagectl $vmName --name "IDE Controller" --add ide
  & $VBoxManage storageattach $vmName --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$isoPath"
  
  & $VBoxManage startvm $vmName --type gui
```

Odpalenie skrypu:

![Skrypt](IMG/Lab9/skrypt.png)

Skrypt utworzył maszyne o podanej nazwie, dysk, kontrolery, podtsawowe ustawienie CPU, pamięci i uruchomił maszynę.

Automatyczna instalacja:

![Instal_final](IMG/Lab9/Instalacja_100.png)

### Wdrażanie na zarządzalne kontenery
#### Instalacja Kubernetes 



### 