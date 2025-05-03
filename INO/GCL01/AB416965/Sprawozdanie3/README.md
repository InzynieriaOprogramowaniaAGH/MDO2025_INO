# Sprawozdanie 3 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

- **Przedmiot: DevOps**
- **Kierunek: Inżynieria Obliczeniowa**
- **Autor: Adam Borek**
- **Grupa 1**

---

### 1. Instalacja zarządcy Ansible

#### Przygotowanie `ansible-target`

Utworzyłem nową maszynę wirtualną z tym samym systemem operacyjnym co główny host, czyli `Fedora 41`. Przydzieliłem jej 20 GB przestrzeni dyskowej — co może być wartością z zapasem, jednak dzięki zastosowaniu dynamicznego przydzielania przestrzeni nie zajmuje ona całości od razu.\
Podczas instalacji utworzyłem użytkownika `ansible` oraz ustawiłem nazwę komputera (hostname) na `ansible-target`.

![Utworzona druga maszyna wirtualna `ansible-target`](zrzuty8/zrzut_ekranu1.png)

Na maszynie zainstalowałem wymagane oprogramowanie poleceniem:

```bash
sudo dnf install -y tar openssh-server
```

![Instalacja tar i openssh-server na `ansible-target`](zrzuty8/zrzut_ekranu2.png)

Po ukończeniu konfiguracji wykonałem migawkę maszyny w VirtualBoxie, aby w razie potrzeby móc przywrócić ją do tego stanu.

#### Instalacja ansible

Na głównej maszynie (`fedora`) zainstalowałem Ansible, korzystając z oficjalnych repozytoriów Fedory, za pomocą prostego polecenia:

```bash
sudo dnf install -y ansible
```

![Instalacja ansible_1](zrzuty8/zrzut_ekranu3_1.png)

![Instalacja ansible_2](zrzuty8/zrzut_ekranu3_2.png)

![Instalacja ansible_3](zrzuty8/zrzut_ekranu3_3.png)

#### Ustanowienie połączenia

W celu umożliwienia komunikacji między maszynami po nazwach, przypisałem adresy IP w pliku `/etc/hosts`:

```
192.168.56.104 ansible-target
192.168.56.101 fedora
```

![Zmiana w /etc/hosts i pingowanie](zrzuty8/zrzut_ekranu4.png)

Następnie utworzyłem klucz SSH, dedykowany dla Ansible:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ansible -C "ansible key"
```

![Utworzenie klucza ssh](zrzuty8/zrzut_ekranu5.png)

Za pomocą `ssh-copy-id` przesłałem klucz publiczny na maszynę `ansible-target`, aby umożliwić bezhasłowe logowanie:

```bash
ssh-copy-id -i ~/.ssh/id_ansible.pub ansible@ansible-target
```

![Skopiowanie klucza ssh](zrzuty8/zrzut_ekranu6.png)

### Inwentaryzacja

#### Sprawdzenie łączności

Zanim przeszedłem do dalszej części zadania, musiałem rozwiązać problem związany z połączeniem SSH. Z nieznanego mi powodu system nie wykrywał przesłanego wcześniej klucza SSH (prawdopodobnie przez to, że posiadam kilka kluczy, z czego ten „główny”, zabezpieczony hasłem, nie był tu używany).

Aby to naprawić, zmodyfikowałem plik konfiguracyjny `~/.ssh/config`, wskazując tam bezpośrednio właściwy klucz oraz nazwy hostów:

`.ssh/config:`

```
Host ansible-target
    HostName ansible-target
    User ansible
    IdentityFile ~/.ssh/id_ansible
Host fedora
    HostName fedora
    User aborek
    IdentityFile ~/.ssh/id_ansible
```

#### Utworzenie pliku inwentaaryzacji

Po potwierdzeniu, że połączenie między maszynami działa poprawnie, utworzyłem plik inwentaryzacji zgodnie z oficjalną [dokumentacją Ansible](https://docs.ansible.com/ansible/latest/getting_started/get_started_inventory.html).

W katalogu `ansible_quickstart` utworzyłem plik `inventory.ini`, w którym — zgodnie z zaleceniami prowadzącego — zdefiniowałem dwie grupy: `Orchestrators` oraz `Endpoints`, przypisując do nich odpowiednio nazwy maszyn wirtualnych:

`inventory.ini`:

```csharp
[Orchestrators]
fedora

[Endpoints]
ansible-target
```

Po zapisaniu pliku, wykonałem testowe zapytanie `ping` do wszystkich maszyn z użyciem polecenia:

```bash
ansible all -i inventory.ini -m ping
```

Co zakończyło się sukcesem:

![Ping ansible](zrzuty8/zrzut_ekranu7.png)

### Zdalne wywoływanie procedur

Korzystając z oficjalnej [instrukcji](https://docs.ansible.com/ansible/latest/getting_started/get_started_playbook.html), przeszedłem do utworzenia własnego playbooka w Ansible.

#### Prosty playbook

Zgodnie z krokami poradnika przygotowałem pierwszy testowy plik playbook.yaml w katalogu `ansible_quickstart`. Jego zadaniem było wysłanie żądania ping do wszystkich maszyn oraz wypisanie prostego komunikatu:

`playbook.yaml`:

```yaml
- name: My first play
  hosts: all
  become: true
  tasks:
   - name: Ping my hosts
     ansible.builtin.ping:

   - name: Print message
     ansible.builtin.debug:
       msg: Hello world
```

Polecenie użyte do uruchomienia playbooka:

```bash
asnible-playbook -i inventory.ini playbook.yaml
```

![Uruchomienie playbooka](zrzuty8/zrzut_ekranu8.png)

#### Pełny playbook

Powyższy playbook był jedynie testem poprawności połączenia oraz działania Ansible. Docelowy playbook miał zawierać:
- wysłanie żadania `ping` do wszystkich maszyn,
- skopiowanie pliku inwentaryzacji na maszynę `Endpoint`,
- aktualizację pakietów systemowych,
- restart usług `sshd` i `rngd`.

Pełny `playbook.yaml`:

```yaml
- name: My first play
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

Uruchomienie playbooka wyglądało analogicznie:

```bash
asnible-playbook -i inventory.ini playbook.yaml
```

![Uruchomienie playbooka](zrzuty8/zrzut_ekranu9.png)

> Usługa `rngd` nie została zrestartowana, ponieważ nie była zainstalowana na maszynie `ansible-target`.

> [Pełne logi](ansible_quickstart/playbook.log)

### Zarządzanie stworzonym artefaktem

W tej części zadania zainstalowałem bibliotekę przygotowaną na wcześniejszych zajęciach wewnątrz kontenera uruchomionego na maszynie `ansible-target`.\
Cały proces został zautomatyzowany przy użyciu playbooka Ansible oraz struktury [ról](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html), utworzonej za pomocą `ansible-galaxy`.

#### Utworzenie nowej roli

Korzystając z narzędzia `ansible-galaxy`, utworzyłem nową rolę o nazwie `cjson` w katalogu `ansible_quickstart`:

```bash
ansible-galaxy init cjson
```

![Utworzenie roli cjson](zrzuty8/zrzut_ekranu10.png)

Po utworzeniu struktury roli, do katalogu `cjson/files` przekopiowałem pliki `cjson.rpm` oraz `main.c` z poprzednich zajęć.

Następnie przeszedłem do modyfikacji pliku `main.yaml` znajdującego się w `cjson/tasks/`. Zadaniem tego pliku było:
- przesłanie artefaktów na `ansible-target`,
- instalacja Dockera i jego zależności,
- uruchomienie kontenera z systemem Fedora 41,
- instalacja biblioteki z pliku `.rpm`,
- kompilacja programu w C,
- oraz uruchomienie programu i pobranie wyniku.

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

#### Uruchomienie roli przez playbook

Do wykonania roli przygotowałem osobny playbook `playbook-cjson.yaml`:

`playbook-cjson.yaml`:

```yaml
- name: Deploy CJSON in container
  hosts: ansible-target
  become: true
  roles:
    - cjson
```

Uruchomienie playbooka:

```bash
asnible-playbook -i inventory.ini playbook-cjson.yaml
```

![Uruchomienie playbooka cjson](zrzuty8/zrzut_ekranu11.png)

> [Pełne logi z wykonania znajdują się tutaj](ansible_quickstart/playbook-cjson.log)