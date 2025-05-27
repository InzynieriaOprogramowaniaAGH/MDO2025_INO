# 🧰 Sprawozdanie z konfiguracji Ansible i zarządzania artefaktem (Docker)

## 📦 1. Wprowadzenie

Celem projektu było skonfigurowanie środowiska do zarządzania zdalnymi maszynami za pomocą **Ansible** oraz wdrażanie aplikacji jako kontenera Docker. Projekt wykonałem na dwóch maszynach wirtualnych z systemem **Ubuntu 24.04 LTS**, pracujących w środowisku VirtualBox. Maszyny komunikują się przez sieć wewnętrzną.

---

## 🖥️ 2. Przygotowanie maszyn wirtualnych

### Maszyna główna (`server`)
- System: Ubuntu 24.04 LTS
- Użytkownik: `krzysztof`
- Ansible zainstalowany z repozytorium APT
- Interfejs sieciowy z adresem `192.168.100.11`
- Hostname ustawiony na `server`

### Maszyna zdalna (`ansible-target`)
- Minimalna instalacja Ubuntu 24.04
- Użytkownik: `ansible` (utworzony podczas instalacji)
- Zainstalowane tylko wymagane pakiety: `openssh-server`, `tar`
- Interfejs sieciowy z adresem `192.168.100.10`
- Hostname ustawiony na `ansible-target`

---

## 🔐 3. Konfiguracja dostępu i połączenia

### Ustawienie hostów
Na maszynie `server`, w pliku `/etc/hosts`, dodano:

```
192.168.100.10 ansible-target
192.168.100.11 server
```

### Logowanie SSH bez hasła

Na `server`:
```bash
ssh-keygen
ssh-copy-id ansible@ansible-target
```

Po tej operacji `server` może logować się do `ansible-target` bez podawania hasła.

---

## 📁 4. Plik inwentaryzacji Ansible

Utworzyłem plik `inventory.ini`:

```ini
[Orchestrators]
server ansible_host=server ansible_user=krzysztof ansible_port=2222

[Endpoints]
ansible-target ansible_host=ansible-target ansible_user=ansible
```

---

## ⚙️ 5. Tworzenie i uruchamianie playbooków

### 🔄 Pingowanie wszystkich hostów

```yaml
- hosts: all
  gather_facts: false
  tasks:
    - name: Sprawdzenie łączności
      ansible.builtin.ping:
```

### 📤 Kopiowanie pliku inwentaryzacji na `ansible-target`

```yaml
- hosts: Endpoints
  gather_facts: false
  tasks:
    - name: Kopiuj inventory.ini
      copy:
        src: ../inventory.ini
        dest: /home/ansible/inventory.ini
```

### 📦 Aktualizacja systemu (zdalnie)

```yaml
- hosts: Endpoints
  become: true
  tasks:
    - name: Aktualizacja cache APT
      apt:
        update_cache: yes

    - name: Uaktualnienie pakietów
      apt:
        upgrade: dist
```

### 🔁 Restartowanie usług `sshd` i `rngd`

```yaml
- hosts: Endpoints
  become: true
  tasks:
    - name: Restart SSH
      service:
        name: ssh
        state: restarted

    - name: Restart RNGD
      service:
        name: rngd
        state: restarted
      ignore_errors: true
```

### 🧪 Symulacja błędów

Wyłączono SSH i/lub interfejs sieciowy na `ansible-target`, a następnie sprawdzono, czy Ansible poprawnie zgłasza `UNREACHABLE`. Dzięki temu potwierdzono, że system poprawnie reaguje na awarie.

---

## 🐳 6. Zarządzanie aplikacją w kontenerze

### Tworzenie roli `deploy_container`

```bash
ansible-galaxy init roles/deploy_container
```

`roles/deploy_container/tasks/main.yml`:

```yaml
- name: Zainstaluj Dockera
  become: true
  apt:
    name:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    state: latest
    update_cache: yes

- name: Uruchom Dockera
  become: true
  service:
    name: docker
    state: started
    enabled: true

- name: Uruchom kontener aplikacji
  become: true
  docker_container:
    name: hello-app
    image: nginx:alpine
    state: started
    ports:
      - "8080:80"

- name: Zweryfikuj dostępność aplikacji
  uri:
    url: http://localhost:8080
    status_code: 200
```

### Uruchomienie roli

`playbooks/deploy.yml`:

```yaml
- hosts: Endpoints
  roles:
    - deploy_container
```

---

## 🧹 7. Czyszczenie — usuwanie kontenera

```yaml
- hosts: Endpoints
  become: true
  tasks:
    - name: Usuń kontener aplikacji
      docker_container:
        name: hello-app
        state: absent
```

---

## ✅ 8. Podsumowanie

- 🛠️ Środowisko Ansible skonfigurowane na dwóch maszynach
- 🔐 Logowanie SSH bez hasła
- 🧪 Działające playbooki do:
  - Pingowania
  - Aktualizacji
  - Restartowania usług
  - Kopiowania plików
- 🐳 Zdalne wdrażanie aplikacji w kontenerze
- 📄 Użycie roli stworzonej za pomocą `ansible-galaxy`
- ✅ Ansible poprawnie wykrywa awarie hostów i przerywa operacje

---

> Projekt wykonany w środowisku testowym VirtualBox  
> Autor: **Twoje imię i nazwisko**
