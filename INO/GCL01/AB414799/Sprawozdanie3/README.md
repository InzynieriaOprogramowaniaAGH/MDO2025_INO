# Sprawozdanie 3

# Ósme zajęcia - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

## Instalacja zarządcy Ansible

### Utworzenie maszyny `ansible-target`

### Stworzyłem nową maszynę wirtualną z identycznym systemem operacyjnym jak na głównym hoście. Przydzieliłem jej 20 GB przestrzeni dyskowej, co może być nieco na wyrost, ale dzięki dynamicznemu przydziałowi miejsca nie jest ona od razu w pełni zajmowana. W trakcie instalacji skonfigurowałem użytkownika o nazwie `ansible` i nadałem maszynie nazwę `ansible-target`.

![1](screeny/8-1.png)

### Na tej maszynie pobrałem wymagane oprogramowanie komendą:

```bash
sudo dnf install -y tar openssh-server
```

![2](screeny/8-2.png)

### Po tej części została wykonana migawka maszyny na Virtualboxie

## Ansible - instalacja

### Na maszynie głównej został zainstalowany Ansible komendą

```bash
sudo dnf install -y ansible
```

![3](screeny/8-3.png)

![4](screeny/8-4.png)

![5](screeny/8-5.png)

### W celu możliwości komunikacji między maszynami, zmodyfikowałem plik `/etc/hosts` na maszynach

![6](screeny/8-6.png)

### Sygnał działa 

![7](screeny/8-7.png)

### Następnym krokiem było utworzenie kluczu SSH, specjalnie dla Ansible

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ansible -C "ansible key"
```

![8](screeny/8-8.png)

### I przy użyciu `ssh-copy-id` skopiowałem ten klucz na maszynę `ansible-target`

```bash
ssh-copy-id -i ~/.ssh/id_ansible.pub ansible@10.0.2.4
```

![9](screeny/8-9.png)

## Inwentaryzacja

### Stworzenie pliku inwentaryzacji

### Po upewnieniu się, że połączenie między maszynami działa prawidłowo, utworzyłem plik inwentaryzacji. W katalogu `ansible` stworzyłem plik inventory.ini, w którym — zgodnie z zaleceniami prowadzącego — zdefiniowałem dwie grupy: Orchestrators i Endpoints, przypisując do nich odpowiednie nazwy maszyn wirtualnych.

`inventory.ini`:

```
[Orchestrators]
Fedorka ansible_connection=local

[Endpoints]
ansible-target ansible_user=ansible ansible_ssh_private_key_file=~/.ssh/id_ansible ansible_become=yes ansible_become_method=sudo
```
Miałem jakiś problem z nim dlatego taka rozszerzona wersja.

### Testowe wykonanie zapytania `ping` do maszyn za pomocą komendy:

```bash
ansible all -i inventory.ini -m ping
```

### A tu jej wynik:

![10](screeny/8-10.png)

## Zdalne wykonanie procedur

### Mój pierwszy playbook testujący połączenie

`playbook.yaml`:

```yaml
- name: FirstPlaybook
  hosts: all
  become: true
  tasks:
   - name: Ping my hosts
     ansible.builtin.ping:

   - name: Print message
     ansible.builtin.debug:
       msg: HelloWorld
```

### Komenda wykonawcza

```bash
ansible-playbook -i inventory.ini playbook.yaml --ask-become-pass
```

![11](screeny/8-11.png)

### Docelowy playbook zawierający wszystkie wymagane rzeczy

```yaml
- name: FirstPlaybook
  hosts: all
  become: true
  tasks:
   - name: Ping my hosts
     ansible.builtin.ping:

   - name: Copy inventory to Endpoint
     ansible.builtin.copy:
      src: inventory.ini
      dest: /home/ansible/inventory_copied
     when: "'ansible-target' in inventory_hostname"

   - name: Ping after copy
     ansible.builtin.ping:

   - name: Update system packages
     ansible.builtin.dnf:
      name: "*"
      state: latest
     when: "'ansible-target' in inventory_hostname"

   - name: Restart sshd
     ansible.builtin.service:
      name: sshd
      state: restarted
     when: "'ansible-target' in inventory_hostname"

   - name: Restart rngd
     ansible.builtin.service:
      name: rngd
      state: restarted
     ignore_errors: yes 
     when: "'ansible-target' in inventory_hostname"
```

### Analogiczne uruchomienie

```bash
ansible-playbook -i inventory.ini playbook.yaml --ask-become-pass
```
![12](screeny/8-12.png)

## Zarządzanie stworzonym artefaktem

### W tej części zadania zainstalowałem bibliotekę przygotowaną podczas wcześniejszych zajęć wewnątrz kontenera działającego na maszynie ansible-target. Cały proces został zautomatyzowany za pomocą playbooka Ansible oraz wykorzystania struktury opartej na rolach.


### Utworzenie roli, korzystając z narzędzia `ansible-galaxy`, o nazwie `cjson` w katalogu `ansible`

```bash
ansible-galaxy init cjson
```

### Po utworzeniu struktury roli, do katalogu cjson/files skopiowałem dwa pliki z wcześniejszych zajęć: cjson.rpm oraz main.c, zawierające odpowiednio przygotowaną bibliotekę oraz kod źródłowy programu w języku C.

### Następnie przystąpiłem do edycji pliku main.yaml, znajdującego się w katalogu cjson/tasks/. Jego zadaniem było zautomatyzowanie całego procesu, który obejmował:

#### -przesłanie przygotowanych artefaktów (cjson.rpm i main.c) na maszynę ansible-target,

#### -instalację Dockera wraz z wymaganymi zależnościami,

### -uruchomienie kontenera z systemem Fedora,

#### -zainstalowanie biblioteki cjson z pliku .rpm wewnątrz kontenera,

#### -kompilację programu napisanego w języku C z użyciem tej biblioteki,

#### -uruchomienie skompilowanego programu oraz pobranie jego wyniku w celu weryfikacji działania.


### Całość operacji została przeprowadzona w sposób zautomatyzowany dzięki wykorzystaniu mechanizmu ról w Ansible.

`cjson/tasks/main.yaml`:

```yaml
---
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

### Uruchomienie roli za pomocą osobnego playbooka `playbook-cjson.yaml`:

```yaml
- name: Deploy CJSON in container
  hosts: ansible-target
  become: true
  roles:
    - cjson
```

### Uruchomienie playbooka

```bash
asnible-playbook -i inventory.ini playbook-cjson.yaml --ask-become-pass
```

![13](screeny/8-13.png)

# Dziewiąte zajęcia - Pliki odpowiedzi dla wdrożeń nienadzorowanych

## Kickstart

### Instalacja systemu

### Nie było potrzeby ponownej instalacji Fedory, ponieważ od początku semestru używałem jej jako głównego systemu operacyjnego na moim komputerze.

### Przygotowanie `anaconda-ks.cfg`

### Po zalogowaniu się na konto administratora skopiowałem plik odpowiedzi z lokalizacji /root/anaconda-ks.cfg do katalogu Sprawozdanie3, aby umożliwić jego wygodne udostępnienie na GitHubie. W dalszej kolejności wprowadziłem modyfikacje, uzupełniając go o niezbędne informacje dotyczące repozytoriów: 

```bash
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64
```

### Taki plik pomógł w pierwszej instalacji

## Instalacja fedory z kickstarta

### Tworząc nową maszynę wirtualną, w menu startowym instalatora wszedłem w tryb edycji GRUB, naciskając klawisz e, a następnie dodałem własny parametr instalacyjny do poleceń startowych:

```
inst.ks=http://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/AB414799/INO/GCL01/AB414799/Sprawozdanie3/anaconda-ks.cfg
```

![1](screeny/9-1.png)

### Instalator kontynuował pracę w trybie graficznym, jednak większość opcji była nieaktywna — ich wartości zostały wcześniej zdefiniowane w pliku kickstart, dlatego nie było możliwości ich edycji.

![2](screeny/9-2.png)

### Po krótkiej chwili zaczęła się instalacja

![3](screeny/9-3.png)

### Po ponownym uruchomieniu systemu zalogowałem się, używając tych samych danych, co na pierwotnej instancji Fedory. 

![4](screeny/9-4.png)

### W kolejnym etapie rozbudowałem plik anaconda-ks.cfg, wprowadzając następujące elementy:

-reboot — by system automatycznie uruchamiał się ponownie po zakończeniu instalacji,

-network --hostname=fedora.local — w celu nadania maszynie własnej nazwy hosta,

-clearpart --all --initlabel — aby przed instalacją usunąć wszystkie istniejące partycje,

-autopart — by umożliwić automatyczne utworzenie nowego układu partycji.

### Sprawdzenie nazwy hosta

![5](screeny/9-5.png)

## Instalacja cJSON z wykorzystaniem pliku rpm

### Utworzenie repozytorium HTTP poprzez udostępnienie biblioteki w formie repozytorium YUM

### Do tego było potrzebny serwer Apache oraz narzędzie `createrepo`

```bash
sudo dnf install -y httpd createrepo
```

![6](screeny/9-6.png)

### Utworzenie katalogu

```bash
sudo mkdir -p /var/www/html/myrepo
sudo cp mycjson.rpm /var/www/html/myrepo/
cd /var/www/html/myrepo
createrepo .
```

![7](screeny/9-7.png)

### Reguły firewalla

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

![8](screeny/9-8.png)

### Kolejnym krokiem była modyfikacja pliku /etc/httpd/conf/httpd.conf, w którym dostosowałem konfigurację serwera Apache, tak aby poprawnie obsługiwał linkowanie i udostępnianie zawartości lokalnego repozytorium.

```bash
<Directory"/var/www/html">
    Options +Indexes
    AllowOverride None
    Require all granted
<Directory>    
```

### Gdy już to zostało wykonane, repozytorium było już gotowe pod adresem:
```bash
http://localhost:8080/myrepo/
```

![9](screeny/9-9.png)

### Teraz trzeba było przerobić plik kickstart tak aby zawietał potrzebne nam rzeczy

### Własne repo:

```
repo --name=myrepo --baseurl=http://10.0.2.15:8080/myrepo/
```

### Pakiety:

```
%packages
@^custom-environment
gcc
curl
glibc
cjson
%end
```

### Dodatkowo utworzone sekcja `%post`, w której jest kompilacja i uruchomienie

```
%post --log=/tmp/postinstall.log --interpreter /bin/bash
exec > /dev/tty3 2>&1
chvt 3
echo "Start postinstall"
mkdir -p /opt/example

chown abaca:abaca /opt/example

#main.c z GitHuba
curl -o /opt/example/main.c https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/refs/heads/AB414799/INO/GCL01/AB414799/Sprawozdanie2/Complete_pipeline/main.c

# Skrypt po zalogowaniu
cat << 'EOF' > /etc/profile.d/run_example.sh
#!/bin/bash
if [ ! -f /opt/example/.compiled ]; then
    echo "Kompilacja main.c" >> /opt/example/autostart.log
    gcc /opt/example/main.c -o /opt/example/example -lcjson -I/usr/local/include/cjson -L/usr/local/lib64
    if [ -f /opt/example/example ]; then
        echo "Uruchamienie:" >> /opt/example/autostart.log
        LD_LIBRARY_PATH=/usr/local/lib64 /opt/example/example >> /opt/example/autostart.log 2>&1
    else
        echo "Brak powodzenia" >> /opt/example/autostart.log
    fi
    touch /opt/example/.compiled
fi
EOF

chmod +x /etc/profile.d/run_example.sh
%end
```

### Po zakończeniu instalacji zalogowałem się na utworzone konto użytkownika, a następnie przeanalizowałem log, aby upewnić się, że skrypt wykonał się poprawnie.

![10](screeny/9-10.png)

# Dziesiąte zajęcia - Wdrażanie na zarządzalne kontenery: Kubernetes (1)