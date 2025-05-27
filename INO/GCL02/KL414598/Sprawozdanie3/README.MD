# 🧰 Sprawozdanie z konfiguracji Ansible i zarządzania artefaktem (Docker)

## 📦 1. Instalacja zarządcy Ansible

### 🌵 Utworzenie drugiej maszyny wirtualnej
Utworzono maszynę `ansible-target` z minimalnym zestawem oprogramowania, co ograniczyło zbędne usługi i poprawiło wydajność.

### 🌵 Taki sam system operacyjny jak maszyna główna
Obie maszyny działają na systemie Ubuntu 24.04 LTS, co ułatwia zarządzanie i eliminuje problemy kompatybilności.

### 🌵 Instalacja `tar` i `sshd`
Zainstalowano `tar` i `openssh-server`, aby umożliwić obsługę archiwów i dostęp przez SSH.

### 🌵 Nadanie hostname `ansible-target`
Nazwa hosta została ustawiona już podczas instalacji systemu.

### 🌵 Utworzenie użytkownika `ansible`
Użytkownik `ansible` został stworzony w instalatorze i ma przyznane uprawnienia sudo.

https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/commit/27c9358ee28e5110374fb8a191858cabddb286d4#diff-f224caf14f91d9c293d9cbdcc0c98bef98026e8da7adfb649d8fb8243c05204f



### 🌵 Wykonanie migawki maszyny
Zrobiono migawkę w VirtualBoxie, co pozwala wrócić do stanu początkowego w razie problemów.

### 🌵 Instalacja Ansible na głównej maszynie
Na `server` zainstalowano Ansible za pomocą APT:
```bash
sudo apt update && sudo apt install -y ansible
```

### 🌵 Wymiana kluczy SSH
Na `server` wygenerowano parę kluczy SSH i przesłano je do `ansible@ansible-target`:
```bash
ssh-keygen
ssh-copy-id ansible@ansible-target
```

---

## 🗂️ 2. Inwentaryzacja

### 🌵 Ustawienie nazw hostów
Ustawiono `hostnamectl` na obu maszynach:
```bash
hostnamectl set-hostname server
hostnamectl set-hostname ansible-target
```

### 🌵 Dodanie wpisów do /etc/hosts
Na maszynie `server` wpisano:
```
192.168.100.10 ansible-target
192.168.100.11 server
```

### 🌵 Weryfikacja łączności
Sprawdzono połączenie:
```bash
ping ansible-target
ping server
```

### 🌵 Stworzenie pliku inwentaryzacji
Plik `inventory.ini`:
```ini
[Orchestrators]
server ansible_host=server ansible_user=krzysztof ansible_port=2222

[Endpoints]
ansible-target ansible_host=ansible-target ansible_user=ansible
```

### 🌵 Wysłanie ping przez Ansible
```bash
ansible -i inventory.ini all -m ping
```

### 🌵 Użyto dwóch maszyn wirtualnych
Projekt został przeprowadzony z wykorzystaniem dwóch maszyn: `server` i `ansible-target`.

### 🌵 Ponowna wymiana kluczy ssh-copy-id
Upewniono się, że użytkownik `ansible` ma poprawnie dodany klucz publiczny.

### 🌵 Weryfikacja bezhasłowego logowania
SSH działało bez potrzeby wpisywania hasła.

---

## ⚙️ 3. Zdalne wywoływanie procedur

### 🌵 Pingowanie z playbooka
Utworzono `ping.yml`:
```yaml
- hosts: all
  gather_facts: false
  tasks:
    - name: Ping
      ansible.builtin.ping:
```

### 🌵 Skopiowanie pliku inwentaryzacji na zdalną maszynę
```yaml
- hosts: Endpoints
  gather_facts: false
  tasks:
    - name: Copy inventory
      copy:
        src: ../inventory.ini
        dest: /home/ansible/inventory.ini
```

### 🌵 Porównanie wyników
Po skopiowaniu inventory na `ansible-target` uruchomiono test pingowy zdalnie — wynik był identyczny jak z `server`.

### 🌵 Aktualizacja systemu
```yaml
- hosts: Endpoints
  become: true
  tasks:
    - name: Update APT
      apt:
        update_cache: yes

    - name: Upgrade packages
      apt:
        upgrade: dist
```

### 🌵 Restart usług sshd i rngd
```yaml
- hosts: Endpoints
  become: true
  tasks:
    - name: Restart sshd
      service:
        name: ssh
        state: restarted

    - name: Restart rngd
      service:
        name: rngd
        state: restarted
      ignore_errors: true
```

### 🌵 Test awarii (SSH down, interfejs down)
Wyłączono `sshd` i kartę sieciową. Ansible zgłosił `UNREACHABLE` — zgodnie z oczekiwaniami.

---

## 🐳 4. Zarządzanie artefaktem (kontener)

### 🌵 Budowa i uruchomienie kontenera
W playbooku użyto obrazu `nginx:alpine`, który został uruchomiony na porcie 8080.

### 🌵 Pobranie z Docker Hub
Ansible pobrał oficjalny obraz `nginx:alpine` bez potrzeby budowania lokalnego obrazu.

### 🌵 Instalacja Dockera przez Ansible
Rola `deploy_container` automatycznie instalowała Dockera przez APT.

### 🌵 Weryfikacja działania aplikacji
Sprawdzono dostępność strony pod `http://localhost:8080` za pomocą modułu `uri`.

### 🌵 Usunięcie kontenera
Na koniec, kontener `hello-app` został usunięty z maszyny docelowej przez Ansible.

---

## ✅ 5. Podsumowanie

- 🖥️ Środowisko składa się z dwóch maszyn wirtualnych
- 🔐 Zrealizowano logowanie bez hasła
- 📂 Plik inwentaryzacji z grupami: `Orchestrators` i `Endpoints`
- ⚙️ Stworzono playbooki do pingu, kopiowania, aktualizacji, restartu usług
- 🐳 Wdrożono i przetestowano kontener aplikacji z Docker Hub
- 📦 Rolę stworzono przy użyciu `ansible-galaxy`

> Projekt wykonano w środowisku VirtualBox + Ubuntu 24.04  
> Autor: **[Twoje imię i nazwisko]**
