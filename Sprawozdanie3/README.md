### Zajęcia 8 
## Instalacja zarządcy Ansible

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#instalacja-zarz%C4%85dcy-ansible)

### 1. Utworzenie drugiej maszyny wirtualnej

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#1-utworzenie-drugiej-maszyny-wirtualnej)

Prace rozpoczęto od utworzenia drugiej maszyny wirtualnej, wyposażonej w ten sam system operacyjny i tę samą wersję co "główna" maszyna — Ubuntu Server 24.04.2. Podczas instalacji nadano maszynie hostname  **ansible-target**  oraz utworzono w systemie użytkownika  **ansible**.
-   Główna maszyna:  **perykles@ubuntu**
-   Dodatkowa maszyna:  **ansible@ansible-target**
### 2. Konfiguracja połączenia SSH (bez hasła)

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#2-konfiguracja-po%C5%82%C4%85czenia-ssh-bez-has%C5%82a)

a) Połączenie za pomocą adresu IP

1.  Wygenerowanie pary kluczy SSH

```
ssh-keygen
```

2.  Skopiowanie klucza publicznego na maszynę  `ansible-target` wykonano poleceniem

```
ssh-copy-id ansible@IP_address
```

3.  Połączenie przez SSH bez hasła

```
ssh ansible@IP_address
```

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdrFMqz2O6LR2qlLB-PmdhgGRT8fVXXkjy0d-sd5LxbGRmtrVUWK1QX6aVI5sCtmxuIRIwROWF3__36VXYuO8FNfhks6RgVSLtQYqixLLhHKepkoDYM7l8sEk6kNTvrzvfjxaOw3w?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

b) Połączenie z użyciem nazwy hosta

1.  Edycja pliku  `/etc/hosts`

```
sudo nano /etc/hosts
```
2.  Dodanie wpisu w pliku /etc/hosts
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfd4e4AcBgyAEYvdyxPILl1J_vWBG9FYR76yUsi1CG7uDTQ8DdvBq3y0L0MRv1mniX5LADa-HFGsq7cnfGbmZ8CYamRCNmi9Jc8hywlR_9k0ISxQDhvT_wxjMm2uEZGwv1ebdLJrA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

3. Test połączenia
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdUXf6LJJ-6jnDRFgd8bL-cQBOiowbasCab9lUbGB61-7BQ7Us4sIqmVrSTLKQj-JVLHcKCG_c3LmCNCF_imbb6a3cIgYv6Uy8yHHU5J_typ_-O6Z4fAOBFx3GaB0fYYO_dG5kMcg?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### 3. Migawka maszyny wirtualnej

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#3-migawka-maszyny-wirtualnej)

Migawka zapisuje pełny stan maszyny (RAM, pliki, ustawienia). 

**Kroki (VirtualBox):**

`Wybierz maszynę`  >  `Migawki`  >  `Zrób migawkę`  >  `Nadaj nazwe`  >  `OK`

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfhGIU3dY4QN7D6yVzZniPQVUGdISI-oZBabJ8AtgvUMcsxI3CTtbhFGe7MOPQKGuSjBT61_SwNXwqdeIxzhiAhogZmLKtvpIRFGsGVeR1GelJVSMdpGjb8qqQm4Xej2B8ryn8_?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### 4. Eksport maszyny wirtualnej

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#4-eksport-maszyny-wirtualnej)

Eksport umożliwia backup.

**Kroki (VirtualBox):**

`Eksportuj jako urządzenie wirtualne`  >  `Wybierz maszynę`

### 5. Instalacja Ansible

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#5-instalacja-ansible)

Na maszynie głównej zainstalowano Ansible
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdXPp1silW5QI4yDNf-3mhP9YWl_H0x1AGRdJg2oBeKZNwCTHT7fveVjqGz8qZ6JEwbyN3AmWam9j08UGPlI5Jb5Bc37qLuS1EOIxhM7JDhYF1JyZkM4PT1NvkTnsdomHGfFF16zw?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

### 6. Weryfikacja narzędzi

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#6-weryfikacja-narz%C4%99dzi)

Sprawdzono obecność wymaganych programów  `tar`  oraz  `sshd`
```
which tar
which sshd
```
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdvpy9ZBTieqcvi_tp_R9GYd2xjd8isfoqIRtls2XbKZ8ZEYiH7eExgWonTZcQybPCYE21ra6xMBabCB746_SGY_nAGS_8zjYvLg8nNjD3FrvNyaVntUaDW0Mb88yHDqg9XfqcmIw?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
## Inwentaryzacja

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#inwentaryzacja)

### 1. Ustawienie nazw hostów

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#1-ustawienie-nazw-host%C3%B3w)

Na głównej maszynie zmieniono nazwę hosta na  `orchestrator`

**Przed:**
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXe3O2JdyZjuNLeHJl_44pspHgbrWrqXc4cjZq-C2H871bNrA9EndGYuYC3ap92ZqrUm_OAZ5en7tGQdjklaa0XbGOjkZGAMTDEDbnbk5V0UBDYnkFcNso7CHXalPIHbs-uuODjb?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
**Po:**
```
exec bash
```
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdzUs0wOUabH-XUUMm0EAClUC4FGQRu-ffEVYNRpsWzBUuwvw1ESSpnjtaRnbEZSQFGUOuO91mvUj0ZV-Em3OuvsYeMKKsqZP_nDWGB6BqnedfwyQWJZKA1bJ2LAr3kiPxBxqwt?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
Na dodatkowej maszynie hostname pozostał taki sam jak przy instalacji maszyny  `ansible-target`
### 2. Konfiguracja nazw DNS (plik  `/etc/hosts`)

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#2-konfiguracja-nazw-dns-plik-etchosts)

Aby umożliwić rozpoznawianie nazw hostów zamiast korzystania z adresów IP

### 2. Konfiguracja nazw DNS (plik  `/etc/hosts`)

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#2-konfiguracja-nazw-dns-plik-etchosts)

Aby umożliwić rozpoznawianie nazw hostów zamiast korzystania z adresów IP

(Szczegóły:  [Połączenie z użyciem nazwy hosta](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#po%C5%82%C4%85czenie-z-u%C5%BCyciem-nazwy-hosta))

1.  Zmodyfikowano plik  `/etc/hosts`

```
sudo nano /etc/hosts
```

2.  Dodano wpisy przypisujące IP do nazw hostów
```
IP_address_1   orchestrator
IP_address_2   ansible-target
```
### 3. Weryfikacja łączności[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#3-weryfikacja-%C5%82%C4%85czno%C5%9Bci)
Sprawdzono możliwość komunikacji między naszynami za pomocą polecenia  `ping`
```
ping ansible-target
```
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfuJyoq3qABy6pPXEEAdsgffXtDyCRLKGQyHfLDrayIaRiak2ubq9h_AYb7h8qw5FNPoDApncZ_8GFp7hOU52qxWd5uqxlpeEtjY0GJCBTTaPeCNsTBzTBKeYFdRH_empXQcUFg3A?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

### 4. Przygotowanie pliku inwentaryzacyjnego Ansible

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#4-przygotowanie-pliku-inwentaryzacyjnego-ansible)

Utworzono plik  `inventory.yml`  z podziałem na grupy maszyn:

-   `Orchestrators`  - zawiera maszynę główną (zarządzającą)
-   `Endpoints`  - zawiera maszyny docelowe (zarządzane przez Ansible)

Zawartość pliku  `inventory.yml`
```
[Orchestrators]
ubuntu ansible_host=10.0.2.15 ansible_user=perykles

[Endpoints]
ansible-target ansible_host=10.200.4.4 ansible_user=ansible
```
### 5. Test połączenia (Ansible ping)

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#5-test-po%C5%82%C4%85czenia-ansible-ping)

a) Ping do wszystkich maszyn:

```
ansible all -i inventory.yml -m ping
```
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcuMsVZUJglMSeOqVoScU_JbvLeilVrKXGExQt2scbXrfgDDRjTJliMia04wSCFB5d4NdywSfQYYs_Y_Km1lrBbMgGyLpgHOGe-cRRkbmfLP-dbvFYJyZerRMMIKPGdyadKk3OHGA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

## **Zdalne wywoływanie procedur za pomocą Ansible**

W ramach tego zadania przygotowano oraz uruchomiono serię procedur z wykorzystaniem playbooków Ansible, których celem było zdalne zarządzanie maszynami końcowymi (Endpoints). Operacje wykonano zgodnie z instrukcją, a ich przebieg został udokumentowany poniżej.

### **1. Skopiowanie pliku inwentaryzacji na zdalne maszyny**

Utworzono playbook `copy_inventory.yml`, który kopiuje lokalny plik `inventory` do katalogu `/tmp` na wszystkich maszynach docelowych:
```
- name: Copy inventory file to Endpoints
  hosts: Endpoints
  tasks:
    - name: Copy inventory file to /tmp directory
      ansible.builtin.copy:
        src: ~/inventory
        dest: /tmp/inventory
```
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXckjPBaG3EBZYRNhk9aVBvVBniAqybOJhzGIReRtlAGTLi2tvHMIptKhbIsb8V14cW1pHDXXgDRFFQ7rP4vxxpqp_rmNeIU2m_EZKthUwxpnvsUuK1f70LFgUucW0oHk__KDEUP3A?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### **3. Ponowne wykonanie operacji kopiowania (test idempotencji)**

Po pierwszym wykonaniu playbooka `copy_inventory.yml`, plik został skopiowany (status `changed`). Przy ponownym uruchomieniu, Ansible nie wprowadził zmian (status `ok`), co potwierdza jego idempotentność – czyli wielokrotne wywołanie nie zmienia systemu, jeśli nie ma takiej potrzeby.
![Uploaded image](https://files.oaiusercontent.com/file-7kqyRvsCJeS8C4oF3SkMuJ?se=2025-05-30T13%3A32%3A21Z&sp=r&sv=2024-08-04&sr=b&rscc=max-age%3D299%2C%20immutable%2C%20private&rscd=attachment%3B%20filename%3Db9fe3b3a-6979-41ea-a912-2ad8bcc35f9b.png&sig=da25I4YIzWiLODh7TOcipj93KMnEb9fTjoZZsceKAnE%3D)
### **4. Aktualizacja wszystkich pakietów**

Kolejnym krokiem była aktualizacja pakietów systemowych na wszystkich maszynach. W tym celu stworzono playbook `update_packages.yml`, który używa modułu `apt` z odpowiednimi opcjami:
```
- name: Update all packages on Endpoints
  hosts: Endpoints
  become: true
  tasks:
    - name: Update and upgrade packages
      ansible.builtin.apt:
        upgrade: dist
        update_cache: yes
```
### **5. Restart usług `sshd` i `rngd`**

W kolejnym kroku przygotowano playbook `restart_services.yml`, który ma na celu restartowanie usług systemowych na maszynach docelowych. Poniżej widoczna jest część odpowiadająca za restart `sshd`:

```
- name: Restart sshd service on all Endpoints
  hosts: Endpoints
  become: yes
  tasks:
    - name: Restart sshd
      ansible.builtin.systemd:
        name: ssh
        state: restarted
```
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdlO-4PGoFaA1S5LwcnXY6cv4cFIyoEa8KsfrC3T99m9USCAM7Mks-yT70sU7O3JeL8YIV7UUFLBWWidCXHro1QnOyzxZ53QatoTqxZ1w_IJ1bHToLiJGXLKifqlILnwXI0U-F-4A?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

### **6. Test z maszyną niedostępną (brak SSH / brak sieci)**

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#operacja-wzgl%C4%99dem-maszyny-z-wy%C5%82%C4%85czonym-serwerem-ssh-i-od%C5%82%C4%85czon%C4%85-kart%C4%85-sieciow%C4%85)

1.  Wyłączenie serwera SSH Na maszynie  `ansible-target`  wykonano

```
sudo systemctl stop ssh
```

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeT-iiLDJ0eukaXSPZ4-cmBWwDx1DWSVV-rLxhIGqTZJOj5tYzCavbLt4cBGedS_ZYedFuQUSTgZZL8PmP6tJGJE3LOyDUVl9whXyKPoVtg3XVJSv0ZytL6yZNHnpaLWl341vLgJw?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXf2PvEy5aDdYiKhMoKTsd9WcN61QBVwRpd5rM0TIEZweQC6UnT0pL0EoXhfwHfz0mu15ZX5sL_BbSSx7RQH3T79uwizPYzOt7IhPMbUc5yQ1bcXYfkckNybcKX7nszfxadA9-67?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
Spowodowało to dezaktywację usługi `sshd` oraz mechanizmu automatycznego nasłuchiwania (ssh.socket). W rezultacie, podczas kolejnego uruchomienia playbooka, Ansible nie był w stanie nawiązać połączenia z hostem i oznaczył go jako `UNREACHABLE`.

## Zarządzanie stworzonym artefaktem
W moim pipeline'ie budowany był artefakt w postaci pliku binarnego i Dockerfile umożliwiającego uruchomienie aplikacji **XZ** w kontenerze. W ramach zadania celem było przygotowanie playbooka Ansible, który automatycznie skonfiguruje środowisko na zdalnej maszynie, przeniesie artefakt, zbuduje i uruchomi kontener z aplikacją.

### **1. Struktura playbooka**

Na potrzeby realizacji zadania przygotowałem strukturę katalogową roli przy użyciu narzędzia `ansible-galaxy`:

ansible-galaxy init manage_artifact
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcyhl3wZV-TlUacC5CepEg21JOQg_BLBVeHHileUzW6b30wVaahD7VxwascxCsV7JAriGmPKhHO1k00Ufe-nMJs9DO-6vBdfNb-56MA2tji0T5RPXyNNHSFv5uM6sFKafltethd?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### **2. Główne zadania roli**

W pliku `tasks/main.yml` zostały zaimplementowane zadania:

-   Instalacja Dockera
    
-   Upewnienie się, że Docker działa
    
-   Skopiowanie artefaktu `xz.tar.gz`, pliku źródłowego `deploy.c` oraz `Dockerfile`
    
-   Budowa obrazu kontenera z aplikacją XZ
    
-   Uruchomienie kontenera
    
-   Zatrzymanie i usunięcie kontenera po zakończeniu pracy

```
- name: Zainstaluj Dockera
  ansible.builtin.apt:
    name: docker.io
    update_cache: yes
    state: present

- name: Upewnij się, że Docker działa
  ansible.builtin.systemd:
    name: docker
    state: started
    enabled: true

- name: Skopiuj artefakt
  ansible.builtin.copy:
    src: xz.tar.gz
    dest: /home/ansible/xz.tar.gz

- name: Skopiuj deploy.c
  ansible.builtin.copy:
    src: deploy.c
    dest: /home/ansible/deploy.c

- name: Skopiuj Dockerfile
  ansible.builtin.copy:
    src: Dockerfile
    dest: /home/ansible/Dockerfile

- name: Zbuduj obraz Docker
  community.docker.docker_image:
    name: xz-runtime
    tag: latest
    source: build
    build:
      path: /home/ansible

- name: Uruchom kontener z aplikacją
  community.docker.docker_container:
    name: artifact-app
    image: xz-runtime:latest
    state: started
    detach: true
    tty: true

- name: Zatrzymaj kontener
  community.docker.docker_container:
    name: artifact-app
    state: stopped

- name: Usuń kontener
  community.docker.docker_container:
    name: artifact-app
    state: absent
```

### **3. Plik inwentarza (inventory)**

Zawiera definicję hosta zdalnego:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcoIM7Brmj8nJIxEmOKVX7ksdJyCelnGtX2EUm7OjPt1bIFYlIsIOOqvXKz1QssF8LG_OfA1or1YNF-e1GydB4-9Y81vSQstdzGXwwaWS2PAUC7M3A5_-2zVpYzMhJaLURKsbZU?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### 4. Playbook główny (`playbook.yml`)
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeZmB-1e8ESJDHjrI4OCzYnsu421PEaTMFdyCj24qEgo5zWBepGQZV2WZTYn3Ea1dpih8xPezGEYwMO9rNatKj-luTVSy1ie0o3Jh-NOiIXw0XpbrIwHOKbQaATJ2iJooxu8U6WZQ?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### **5. Weryfikacja działania**

Po uruchomieniu playbooka komendą:

`ansible-playbook -i inventory playbook.yml` 

Ansible wykonał wszystkie kroki z sukcesem:

-   Docker został poprawnie zainstalowany
    
-   Obraz został zbudowany z plików źródłowych i artefaktu
    
-   Kontener z aplikacją został uruchomiony, a następnie zatrzymany i usunięty
    

Zrzut ekranu z podsumowaniem `PLAY RECAP` potwierdza, że wszystkie zadania zakończyły się powodzeniem (`ok=10`, `failed=0`).

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfNRkGiuz4l1jKz4XA5YF9bMkr9iJS3T2C1UhQk8rU44lKEqNBAFhsvTXRo36ho3VFelxdFUo92Z-j0fkALjtryMYUmKss7aAgRUpSj3oPrdMOz0WW--OQZPR9kUuh5OA2QTNQc?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### Struktura katalogu roles
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXezziL7RPPj09s1wDh2wpZyzzMvBU1o9IBxiYDNdCiqoiS9jEWbKS-bh9IiHes4CLRhEjhtuoR8JzXEU7LnncLdTLwJ8zbe6QPXiFQ4x9iWGssTHh_izgYOWIglGsMvKjXpXlr_iA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
# Zajęcia9 
Pliki odpowiedzi dla wdrożeń nienadzorowanych

## Automatyzacja instalacji Fedory z wykorzystaniem Kickstart

### 1. Pobranie i przygotowanie środowiska

Pracę rozpoczęto od pobrania instalatora sieciowego Fedora NetInstall i zainstalowania maszyny wirtualnej na VirtualBox.

### 2. Sprawdzenie pliku odpowiedzi Anaconda

Po zakończeniu instalacji przełączono się na konto roota i sprawdzono zawartość katalogu domowego roota:
```
sudo su
ls -l /root
```

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdgAtNPDTXZGf5Ver-Mx9oOwijG-TD-4AjbHe4G6hxz_qCFfu8OH8Q92XIqi2Gji5D661fLpfmCkwcwounZzgxMJDMLhyThjTmqp8V6ASpzRcM9jRN2bKTtBsx3GE-JsmgncyN_fA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

Można zauważyć, że instalator Anaconda automatycznie generuje plik odpowiedzi  `anaconda-ks.cfg`.

Plik ten zawiera wszystkie odpowiedzi na pytania, które były udzielane ręcznie podczas procesu instalacji. Dzięki temu można go wykorzystać do stworzenia maszyny wzorcowej i przyspieszenia wdrażania systemu na wielu maszynach bez konieczności każdorazowego przechodzenia przez cały proces instalacji.

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXd3I08kCh4qFC068FyBOeh7ajGY65R-9oWwtduuFaX5mXSTjS26eD5QbQPu8GIZu8klnfTn-ExGtcFTFBbY5fFxSoPSrlG3UuV9GNbOVf6tY4O7Ugy9UOR5ka8icdolOoDXCHCD?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

### 3. Modyfikacja pliku KickStart

Plik został dodany do repozytorium, delikatnie go zmodyfikowano:

-   dodano konfigurację źródeł repozytoriów:

```
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

```

-   zapewniono, że zawsze będzie formatować całość

```
clearpart --all --initlabel

```

-   ustawiono hostname na inny niż domyślny  `localhost`

```
network --hostname=fedora-mruby.local
```
### 4. anaconda-ks.cfg
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXd3I08kCh4qFC068FyBOeh7ajGY65R-9oWwtduuFaX5mXSTjS26eD5QbQPu8GIZu8klnfTn-ExGtcFTFBbY5fFxSoPSrlG3UuV9GNbOVf6tY4O7Ugy9UOR5ka8icdolOoDXCHCD?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
```

### 5. Automatyczna instalacja z użyciem Kickstart

Następnie stworzono nową maszynę wirtualną, korzystając z wcześniej pobranego obrazu ISO Fedora Server.

Zamiast standardowego rozpoczęcia instalacji:

1.  Na ekranie wyboru GRUB naciśnięto klawisz  `e`  w celu edycji parametrów rozruchu.
2.  Dodano na końcu linii zaczynającej się od linux parametr:
```
inst.ks=https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/JK414562/lab9/anaconda-ks.cfg
```
3.  Następnie naciśnięto kombinację klawiszy  `Ctrl`  +  `X`, co uruchomiło instalator z podanym plikiem odpowiedzi.

Instalator automatycznie rozpoczął instalację zgodnie z przepisami zawartymi w pliku Kickstart.
(screen)

## Rozszerzenie pliku odpowiedzi

Po wykonaniu testowej instalacji z użyciem domyślnego pliku `anaconda-ks.cfg`, utworzono nowy plik `ks.cfg`, który automatyzuje cały proces wdrożenia systemu Fedora oraz kompiluje i uruchamia aplikację stworzoną w ramach projektu xz.

Zgodnie z wymaganiami, rozszerzono plik odpowiedzi o:

-   instalację narzędzi do kompilacji oraz zależności projektu xz,
    
-   konfigurację użytkownika oraz przygotowanie testowego pliku tekstowego,
    
-   automatyczne pobranie, zbudowanie i uruchomienie programu `xz` po pierwszym starcie systemu,
    
-   pełne repozytoria i reboot po instalacji.

### Plik ks.cfg
```
#version=DEVEL
# Generated by Anaconda 41.35
# Modified to install and run xz project from GitHub

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'

# System language
lang pl_PL.UTF-8

# Network configuration
network --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate
network --hostname=fedora-xz.local

# System timezone
timezone Europe/Warsaw --utc

# Root password and user
rootpw haslo123 --plaintext
user --groups=wheel --name=perykles --password=perykles123 --plaintext --gecos="perykles"

# Disk partitioning
ignoredisk --only-use=sda
autopart
clearpart --all --initlabel

# Package selection
%packages
@^server-product-environment
git
gcc
make
autoconf
automake
libtool
wget
%end

# Setup agent
firstboot --enable

# Installation sources
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

# Post-installation script
%post --log=/root/ks-post.log --interpreter=/bin/bash

# Klonowanie i budowanie projektu xz
mkdir -p /opt/xz
cd /opt/xz
git clone https://github.com/tukaani-project/xz.git
cd xz
./autogen.sh
./configure
make
make install

# Tworzenie testowego pliku do kompresji
echo "To jest testowy plik XZ" > /opt/test.txt

# Tworzenie skryptu uruchamiającego XZ
cat << 'EOF' > /usr/local/bin/run-xz.sh
#!/bin/bash
xz -z -k /opt/test.txt
EOF

chmod +x /usr/local/bin/run-xz.sh

# Tworzenie usługi systemd, która uruchomi xz przy starcie
cat << 'EOF' > /etc/systemd/system/run-xz.service
[Unit]
Description=Run XZ compression test at boot
After=network-online.target

[Service]
ExecStart=/usr/local/bin/run-xz.sh
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Włącz usługę
systemctl enable run-xz.service

%end

# Reboot after installation
reboot
```
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcfyyPepRVqIsWGoy6kBRTyV-VB8bJoKc5OHxv3Yaf4uedMUx0QOHOL-dUMi7_03KtQcs05ngLYx3eXWi3NIu-9xt-RsFtupY3JIctmNPdC4LF4qS0HTZvMgNQL_zUcJ6ohlmBdsA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)** 
### Potwierdzenie działania

Po zakończeniu instalacji i automatycznym restarcie systemu jednostka `run-xz.service` została uruchomiona.

Logi systemd wskazują:

-   testowy plik `test.txt` został utworzony w katalogu `/opt`,
    
-   usługa `run-xz.service` uruchomiła skrypt `/usr/local/bin/run-xz.sh`,
    
-   skrypt wykonał polecenie kompresji `xz -z -k /opt/test.txt`,
    
-   wynikowy plik `test.txt.xz` został poprawnie wygenerowany.
    
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfldlG1NmkOdw024DSTTGPu0Z4OoHCOE6JO3OgOFFDxl0o-2fJHDwVy27iJfGSN0C2Q6meSv_SuuBGRueFhAbIer92jZqtYSpVKuZrL5U0s1a0EvV7s2uaAmijAyqIpWJoCarDK7g?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
Usługa zakończyła się bezbłędnie (`status=0/SUCCESS`) i ma status `enabled`, co oznacza, że uruchamia się przy każdym starcie systemu.

### Weryfikacja manualna

Aplikacja `xz` została zainstalowana lokalnie i uruchamiana poza kontenerem.  
W pliku odpowiedzi `ks.cfg` utworzono jednostkę `run-xz.service`, która automatycznie uruchamia komendę kompresji przy starcie systemu.

Aby zweryfikować działanie aplikacji, można wykonać następujące polecenie:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfX3luMWCgyjx3ZEHo73zmOhTmfZyMmYn3NpJBwCXwBwZ_fQH5juNBMrbnYpDj0ixW8n4BvZn65y6fO53neo_OYLUK0siErAYbiRIhysMPcvoMtnpyE-AVyEL8PIgYfpYfFq-HMJg?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**


# Zajęcia10::Wdrażanie na zarządzalne kontenery: Kubernetes (1)

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#zaj%C4%99cia10wdra%C5%BCanie-na-zarz%C4%85dzalne-kontenery-kubernetes-1)

## Instalacja klastra Kubernetes


### 1. Pobranie i instalacja Minikube

Instalator został pobrany bezpośrednio z oficjalnego źródła i zainstalowany poleceniem:

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb

```

### 2. Uruchomienie klastra Kubernates

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#2-uruchomienie-klastra-kubernates)

Minikube domyślnie uruchamia klaster lokalnie w maszynie wirtualnej. Start klastra odbywa się przy pomocy polecenia

```
minikube start
```
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfAoETzlrdVIUfOoMhHJrbGgwK_3EjJRoWa4dZYBZ2C2kE2F_NNSpDd6H6P0-4V5rL8Wh0nRPxXZQCNrgfNvY7ZUWIPGwlwihz8yZCMT-infgHQZ7qoMFxBJmsRD9CGXnllQMqU6Q?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### 3. Uruchomienie Dashboard

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#3-uruchomienie-dashboard)

Aby ułatwić wizualne zarządzanie klastrem, uruchomiono wbudowany Kubernetes Dashboard, dostępny z poziomu przeglądarki

```
minikube dashboard
```

To polecenie otwiera lokalny panel graficzny w nowym oknie przeglądarki i jednocześnie uruchamia lokalne tunelowanie portów:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXc55Nt-u8tghowTNECePiemj44fvdl8XF30tvc-3v0KVv2_CNBkCKG_TqPfeCF_SIieXgKPtuqA88gHc2hp2tKyxqKcOwYjZEdkNIg16oQxebWcFMsEK1ZTGqNhm6agIy8VAHts?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
_Zalecane jest korzystanie z VS Code, z powodu automatycznego przekierowywania portów z maszyny wirtualnej do hosta_

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfztUUj--RcCUiC91IlQxINiGosjtWfqzK4mbCcKxitCJU-HwwB3ulRHFSkG4xvfR9fILRGpgVbo92cDSEw9oicEHf37VuCflip-L9AETbSnUV2zdKjmI0GUUYVjQP3fECf_RGpJA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

### 4. Konfiguracja  `kubectl`  (alias dla Minikube)

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#4-konfiguracja-kubectl--alias-dla-minikube)

Zaopatrzono się w polecenie  `kubectl`  w wariancie minikube

```
alias kubectl="minikube kubectl --"
```
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeCnkAJ84yA2AUqD_O5kljq5syCvWJL2kx6e7fgI0ksrqXOrrP7bjdp1jB-y5jdeoGrPC7qJs3vtcwx5XmaTDRTCq7MK2B5en0vMrIwTh2MvDRWzH-HDiGd_EX8tncipkI-HINRYw?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

### 5. Działający klaster - weryfikacja

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#5-dzia%C5%82aj%C4%85cy-klaster---weryfikacja)

Działanie klastra można potwierdzić poprzez
```
kubectl get nodes
kubectl get pods -A
```


### 6. Problemy sprzętowe i sposoby ich ograniczenia

Aby uruchomić klaster Minikube, wymagane jest podstawowe środowisko do wirtualizacji oraz odpowiednie zasoby sprzętowe, które zazwyczaj są dostępne na współczesnych komputerach. Zgodnie z oficjalną dokumentacją Minikube, minimalne wymagania to:

- przynajmniej **2 rdzenie CPU**,
- co najmniej **2 GB pamięci RAM**,
- około **20 GB wolnego miejsca na dysku**,
- zainstalowany **menedżer kontenerów lub maszyn wirtualnych**, taki jak:  
  **Docker**, **VirtualBox**, **Podman** lub **KVM**.
    

### 7. Podstawowe obiekty Kubernetesa

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#7-podstawowe-obiekty-kubernetesa)

W ramach pracy z Minikube i Dashboardem zapoznano się z podstawowymi komponentami K8s:

-   Pod – najmniejsza jednostka wdrożeniowa, zawierająca jeden lub więcej kontenerów
    
-   Deployment – definiuje strategię wdrażania i skalowania podów
    
-   Service – zapewnia stały adres dostępu do grupy podów
    
-   Namespace – logiczne grupowanie zasobów
    

Dashboard pozwala na łatwą eksplorację tych zasobów i podgląd ich stanu w czasie rzeczywistym.

### Analiza posiadanego kontenera

#### Projekt: Deploy to cloud

Obraz znajdujący się w repozytorium **XZ** zawiera aplikację, która uruchamia się poprawnie, jednak nie spełnia wymagań zadania **"Deploy to cloud"**, ponieważ:

- kontener kończy działanie zaraz po starcie (Pod otrzymuje status `Completed`),
- nie udostępnia żadnego interfejsu sieciowego – brak portów, brak możliwości użycia `kubectl expose` czy `kubectl port-forward`.

#### Test – deploy i analiza własnego obrazu z repozytorium XZ

**Etap 1 – przygotowanie aplikacji**

Wykorzystana aplikacja została odpowiednio umieszczona w obrazie Docker. Po uruchomieniu kontenera, aplikacja wykonuje swoją funkcję i natychmiast się kończy, bez dalszego działania.
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXevT-OkYjBYQ3VN2U06sq0y-Xd31hwBMamPN8ZebA3l6fJdYfZayjk_8ac5pKj1-3kAdQVW5gY5V5Q4N_mUYOIWu3E-PtFXboD4NEEhOnlSqP8MEr1jmGtqD0KMuWdNrZL8t43T3A?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

**Etap 2 – uruchomienie Poda**

Utworzono plik `xz-pod.yaml`, definiujący pojedynczy Pod uruchamiający kontener z obrazem aplikacji:

```
kubectl apply -f xz-pod.yaml
```
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXegkRs5OHz5amRHJDypo2c7PinQ4hNq8auHWk-yHRRKrcxaZVadWJvc-mpyeQcnbS-rDsC_FC9ABDNz4HCDHdHOFVKRncKzNcg5Fo0R2xdlNX3o51tBAHAJKrqGl5PLHPB5WPweTA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
**Etap 3 – weryfikacja działania kontenera**

Po uruchomieniu:

`kubectl get pods` 

Kontener natychmiast osiąga status `Completed`. 

#### Wnioski

Obraz z repozytorium **XZ** działa poprawnie, ale nie jest odpowiedni do wdrożenia w chmurze jako trwała usługa – nie posiada mechanizmu komunikacji przez sieć. Dlatego zdecydowano się na zmianę projektu na inną aplikację również z repozytorium **XZ**, która spełnia wymagania zadania – umożliwia interakcję przez interfejs sieciowy i może działać jako kontenerowa usługa w Kubernetes.

## Alternatywny projekt: Deploy aplikacji jako usługowego kontenera

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#alternatywny-projekt-deploy-aplikacji-jako-us%C5%82ugowego-kontenera)

Na potrzeby zadania wybrano alternatywny projekt oparty na serwerze NGINX, który działa jako usługowy kontener. Celem było zbudowanie i uruchomienie kontenera zawierającego prostą aplikację webową z własną stroną startową.

### 1. Obraz Dockera

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#1-obraz-dockera)

Do budowy obrazu wykorzystano oficjalny obraz  `nginx:latest`  jako bazę. Do katalogu serwowanego przez NGINX (/usr/share/nginx/html) dodano własny plik  `index.html`  z niestandardową zawartością, potwierdzającą poprawne wdrożenie kontenera.

**Zawartość  `Dockerfile`**

```
FROM nginx:latest
COPY custom-index.html /usr/share/nginx/html/index.html
```
**Zawartość  `index.html`**
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXd9qlKRImIShvpRsMto6z4OIDiDpDjdb0XH2fFhNk3LP4T3-vjTAKfjCHH8FH8arigcpK3xb22uf-EKvs6VfsYaTP8XYMBFa3ARYx_n9jMGjRFSBrhBNrhMw1Ux3qnj7MxlyHfkWw?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### 2. Budowa i uruchomienie kontenera

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#2-budowa-i-uruchomienie-kontenera)

-   Obraz został zbudowany poleceniem:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdfq2KlvAw-nHYYRzyBxWF8nH77rnOSg7bDXdbd_gldkvQ3LJUIOREonI6qvB2hQ5ebxBqKwSLbHIL3aD0xfBRvKbLUTCoyjj7Ptc7EXBSZH0uKaXg_v14nAuVcUlBYLBoqWMPpPg?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
-   Kontener został uruchomiony w tle:
```
kubectl run nginx-custom-pod --image=nginx-custom --port=80 --image-pull-policy=Never
```

-   dostęp to aplikacji w przeglądarce:
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeI5TseCjCzqR43vTYWrc0hYtZfSyG7osR02sD9rUGHB3r_Ue8DQn8qE7PzISVBIAUK4Njyjmcq5h4wR7H6mPSNjW0XFuwUsgqBJAEhKMfsU8FLPFiYuTPTp13QXTHTG4dgEc6ZMw?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
## Przekucie wdrożenia manualnego w plik wdrożenia
Ręczne uruchomienie aplikacji zostało przekształcone w deklaratywne wdrożenie Kubernetes za pomocą pliku perykles-nginx-deploy.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080

```
### 1. Wdrożenie aplikacji z pliku YAML
Polecenie użyte do wdrożenia oraz jego wynik:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfjkYZH2KnUcvB6U7SzzkMpzNG6AMA9NrLyB3uzcSpbiHdCsc1YjBBQNXaq7Vl6u58_J5JeKt1emBaNXwa6RotLY8gU-gGbtnk37tzJ7QIrG_82OVHi21WkM7Wwe9ve9RYDDrns?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
Wdrożenie wykonałem komendą:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcDnJYwMpM3zceSutiPg3-r0F-AaigrAsiRxo5qLALQLsnQ6D1Sgcz3vacwv02-DUDyCvBa9KLi8rmmskn52LYsY_h4_VF4QPZVJKC1oUKWYN5yrZO2hkBlIO5S2bh78Fhw9Rcl?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
Monitoring rolloutu

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#2-monitoring-rolloutu)

Aby upewnić się, że wdrożenie zostało przeprowadzone poprawnie, użyto:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdyQpS-3Kr1m_Q9BRbuSz0ByTWXj4CoxHNwZea657qxaV8vrECOjvGVsyCaST2JPNkB5LfYJ7vmdYko9bC9PxIehcLFcSvm9YPeoRaafEo-ppnbZh8UpxnQoUZdAesDSBES-lus3Q?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
Wszystkie 4 repliki zostały poprawnie uruchomione i działają bez błędów.

### 3. Eksponowanie aplikacji

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#3-eksponowanie-aplikacji)

Aby udostępnić aplikację na zewnątrz klastra, wykonano:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdmzPlTJDjpzPeUxxPsVTJPfhunTDyfDXYiDdc9Jfeicpf9bzOKpzzhSgJSYgB9J-hLEx-W6dmw--4jDqJwoZt397toeAiwNDqEWwoGENHPDhUeo0B1cEVtAHu3y3eFgQXK4_oAEg?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### 4. Przekierowanie portu do serwisu

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#4-przekierowanie-portu-do-serwisu)

Aplikacja została wystawiona lokalnie poprzez przekierowanie portu z serwisu:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXctaYGqUMrSiVc0c9tBewHWxBXTxOuwxQ-1jZwPuEdoJJ5Sud0i4dH_cAiAU0MDTwX6Cw060tLpkYe80pX225beLeG8UsoQqNq-DunMPGNZufLRN15q5WaDNJK5VTnhx2jdeeXM?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### Dashboard – Weryfikacja wizualna

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#dashboard--weryfikacja-wizualna)

Do weryfikacji działania aplikacji i zarządzania zasobami klastra wykorzystano Dashboard Minikube.

1.  **Workload Status**

Pokazuje ogólny stan zasobów wdrożonych w klastrze:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeEIcQwqneX1Iqk1j6ckEfk5jJ2yQ5zrUoPX7SIzyWMaZXSaZMNR5t9Deq-tBqtx-yjlic8-L6IpzziMKIaglgoRTivpxNMo8k0wEKRMavO91GnEvv_VwKSWtAg6PwUwUtx5LvVvA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
2.  **Pods**

Widoczne są wszystkie 4 repliki poda  `nginx-deployment`:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXe4caEo7kF3YCUtvCNQD4yoMWC6jmu-FS6auChYJkiYG1BQ_YUep9DQDVGkNrMEPkHG31mRqfSkzexiK1lFI4c3tHP9KRJ4BtUDGCMdj5nfqb4kyWqeJAFRT4FmKat4z3FIlMOIDQ?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
3.  **Deployments**

Pokazuje aktywne wdrożenie z nazwą  `nginx-deployment`:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcdAndO7HvS6kFwA-VPgWf5Mim6TjgCxh_EaGsub060WjOFR95C3Fgfhp00WKjP1PC4rebjer8nnkEp5qqEGQt7UWI0k18dW1-nvzhYOWm4nL3lyynd13FDD1-bPWzZQ-D5H1VeFw?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**


# Zajęcia10::Wdrażanie na zarządzalne kontenery: Kubernetes (1)

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#zaj%C4%99cia10wdra%C5%BCanie-na-zarz%C4%85dzalne-kontenery-kubernetes-1)

## Instalacja klastra Kubernetes

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#instalacja-klastra-kubernetes)

### 1. Pobranie i instalacja Minikube

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#1-pobranie-i-instalacja-minikube)

Instalator został pobrany bezpośrednio z oficjalnego źródła i zainstalowany poleceniem:

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb

```

### 2. Uruchomienie klastra Kubernates

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#2-uruchomienie-klastra-kubernates)

Minikube domyślnie uruchamia klaster lokalnie w maszynie wirtualnej. Start klastra odbywa się przy pomocy polecenia

```
minikube start
```
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfAoETzlrdVIUfOoMhHJrbGgwK_3EjJRoWa4dZYBZ2C2kE2F_NNSpDd6H6P0-4V5rL8Wh0nRPxXZQCNrgfNvY7ZUWIPGwlwihz8yZCMT-infgHQZ7qoMFxBJmsRD9CGXnllQMqU6Q?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### 3. Uruchomienie Dashboard

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#3-uruchomienie-dashboard)

Aby ułatwić wizualne zarządzanie klastrem, uruchomiono wbudowany Kubernetes Dashboard, dostępny z poziomu przeglądarki

```
minikube dashboard
```

To polecenie otwiera lokalny panel graficzny w nowym oknie przeglądarki i jednocześnie uruchamia lokalne tunelowanie portów:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXc55Nt-u8tghowTNECePiemj44fvdl8XF30tvc-3v0KVv2_CNBkCKG_TqPfeCF_SIieXgKPtuqA88gHc2hp2tKyxqKcOwYjZEdkNIg16oQxebWcFMsEK1ZTGqNhm6agIy8VAHts?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
_Zalecane jest korzystanie z VS Code, z powodu automatycznego przekierowywania portów z maszyny wirtualnej do hosta_

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfztUUj--RcCUiC91IlQxINiGosjtWfqzK4mbCcKxitCJU-HwwB3ulRHFSkG4xvfR9fILRGpgVbo92cDSEw9oicEHf37VuCflip-L9AETbSnUV2zdKjmI0GUUYVjQP3fECf_RGpJA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

### 4. Konfiguracja  `kubectl`  (alias dla Minikube)

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#4-konfiguracja-kubectl--alias-dla-minikube)

Zaopatrzono się w polecenie  `kubectl`  w wariancie minikube

```
alias kubectl="minikube kubectl --"
```
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeCnkAJ84yA2AUqD_O5kljq5syCvWJL2kx6e7fgI0ksrqXOrrP7bjdp1jB-y5jdeoGrPC7qJs3vtcwx5XmaTDRTCq7MK2B5en0vMrIwTh2MvDRWzH-HDiGd_EX8tncipkI-HINRYw?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

### 5. Działający klaster - weryfikacja

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#5-dzia%C5%82aj%C4%85cy-klaster---weryfikacja)

Działanie klastra można potwierdzić poprzez
```
kubectl get nodes
kubectl get pods -A
```


### 6. Problemy sprzętowe i sposoby ich ograniczenia

Aby uruchomić klaster Minikube, wymagane jest podstawowe środowisko do wirtualizacji oraz odpowiednie zasoby sprzętowe, które zazwyczaj są dostępne na współczesnych komputerach. Zgodnie z oficjalną dokumentacją Minikube, minimalne wymagania to:

- przynajmniej **2 rdzenie CPU**,
- co najmniej **2 GB pamięci RAM**,
- około **20 GB wolnego miejsca na dysku**,
- zainstalowany **menedżer kontenerów lub maszyn wirtualnych**, taki jak:  
  **Docker**, **VirtualBox**, **Podman** lub **KVM**.
    

### 7. Podstawowe obiekty Kubernetesa

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#7-podstawowe-obiekty-kubernetesa)

W ramach pracy z Minikube i Dashboardem zapoznano się z podstawowymi komponentami K8s:

-   Pod – najmniejsza jednostka wdrożeniowa, zawierająca jeden lub więcej kontenerów
    
-   Deployment – definiuje strategię wdrażania i skalowania podów
    
-   Service – zapewnia stały adres dostępu do grupy podów
    
-   Namespace – logiczne grupowanie zasobów
    

Dashboard pozwala na łatwą eksplorację tych zasobów i podgląd ich stanu w czasie rzeczywistym.

### Analiza posiadanego kontenera

#### Projekt: Deploy to cloud

Obraz znajdujący się w repozytorium **XZ** zawiera aplikację, która uruchamia się poprawnie, jednak nie spełnia wymagań zadania **"Deploy to cloud"**, ponieważ:

- kontener kończy działanie zaraz po starcie (Pod otrzymuje status `Completed`),
- nie udostępnia żadnego interfejsu sieciowego – brak portów, brak możliwości użycia `kubectl expose` czy `kubectl port-forward`.

#### Test – deploy i analiza własnego obrazu z repozytorium XZ

**Etap 1 – przygotowanie aplikacji**

Wykorzystana aplikacja została odpowiednio umieszczona w obrazie Docker. Po uruchomieniu kontenera, aplikacja wykonuje swoją funkcję i natychmiast się kończy, bez dalszego działania.
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXevT-OkYjBYQ3VN2U06sq0y-Xd31hwBMamPN8ZebA3l6fJdYfZayjk_8ac5pKj1-3kAdQVW5gY5V5Q4N_mUYOIWu3E-PtFXboD4NEEhOnlSqP8MEr1jmGtqD0KMuWdNrZL8t43T3A?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

**Etap 2 – uruchomienie Poda**

Utworzono plik `xz-pod.yaml`, definiujący pojedynczy Pod uruchamiający kontener z obrazem aplikacji:

```
kubectl apply -f xz-pod.yaml
```
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXegkRs5OHz5amRHJDypo2c7PinQ4hNq8auHWk-yHRRKrcxaZVadWJvc-mpyeQcnbS-rDsC_FC9ABDNz4HCDHdHOFVKRncKzNcg5Fo0R2xdlNX3o51tBAHAJKrqGl5PLHPB5WPweTA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
**Etap 3 – weryfikacja działania kontenera**

Po uruchomieniu:

`kubectl get pods` 

Kontener natychmiast osiąga status `Completed`. 

#### Wnioski

Obraz z repozytorium **XZ** działa poprawnie, ale nie jest odpowiedni do wdrożenia w chmurze jako trwała usługa – nie posiada mechanizmu komunikacji przez sieć. Dlatego zdecydowano się na zmianę projektu na inną aplikację również z repozytorium **XZ**, która spełnia wymagania zadania – umożliwia interakcję przez interfejs sieciowy i może działać jako kontenerowa usługa w Kubernetes.

## Alternatywny projekt: Deploy aplikacji jako usługowego kontenera

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#alternatywny-projekt-deploy-aplikacji-jako-us%C5%82ugowego-kontenera)

Na potrzeby zadania wybrano alternatywny projekt oparty na serwerze NGINX, który działa jako usługowy kontener. Celem było zbudowanie i uruchomienie kontenera zawierającego prostą aplikację webową z własną stroną startową.

### 1. Obraz Dockera

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#1-obraz-dockera)

Do budowy obrazu wykorzystano oficjalny obraz  `nginx:latest`  jako bazę. Do katalogu serwowanego przez NGINX (/usr/share/nginx/html) dodano własny plik  `index.html`  z niestandardową zawartością, potwierdzającą poprawne wdrożenie kontenera.

**Zawartość  `Dockerfile`**

```
FROM nginx:latest
COPY custom-index.html /usr/share/nginx/html/index.html
```
**Zawartość  `index.html`**
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXd9qlKRImIShvpRsMto6z4OIDiDpDjdb0XH2fFhNk3LP4T3-vjTAKfjCHH8FH8arigcpK3xb22uf-EKvs6VfsYaTP8XYMBFa3ARYx_n9jMGjRFSBrhBNrhMw1Ux3qnj7MxlyHfkWw?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### 2. Budowa i uruchomienie kontenera

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#2-budowa-i-uruchomienie-kontenera)

-   Obraz został zbudowany poleceniem:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdfq2KlvAw-nHYYRzyBxWF8nH77rnOSg7bDXdbd_gldkvQ3LJUIOREonI6qvB2hQ5ebxBqKwSLbHIL3aD0xfBRvKbLUTCoyjj7Ptc7EXBSZH0uKaXg_v14nAuVcUlBYLBoqWMPpPg?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
-   Kontener został uruchomiony w tle:
```
kubectl run nginx-custom-pod --image=nginx-custom --port=80 --image-pull-policy=Never
```

-   dostęp to aplikacji w przeglądarce:
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeI5TseCjCzqR43vTYWrc0hYtZfSyG7osR02sD9rUGHB3r_Ue8DQn8qE7PzISVBIAUK4Njyjmcq5h4wR7H6mPSNjW0XFuwUsgqBJAEhKMfsU8FLPFiYuTPTp13QXTHTG4dgEc6ZMw?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
## Przekucie wdrożenia manualnego w plik wdrożenia
Ręczne uruchomienie aplikacji zostało przekształcone w deklaratywne wdrożenie Kubernetes za pomocą pliku perykles-nginx-deploy.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080

```
### 1. Wdrożenie aplikacji z pliku YAML
Polecenie użyte do wdrożenia oraz jego wynik:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfjkYZH2KnUcvB6U7SzzkMpzNG6AMA9NrLyB3uzcSpbiHdCsc1YjBBQNXaq7Vl6u58_J5JeKt1emBaNXwa6RotLY8gU-gGbtnk37tzJ7QIrG_82OVHi21WkM7Wwe9ve9RYDDrns?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
Wdrożenie wykonałem komendą:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcDnJYwMpM3zceSutiPg3-r0F-AaigrAsiRxo5qLALQLsnQ6D1Sgcz3vacwv02-DUDyCvBa9KLi8rmmskn52LYsY_h4_VF4QPZVJKC1oUKWYN5yrZO2hkBlIO5S2bh78Fhw9Rcl?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
Monitoring rolloutu

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#2-monitoring-rolloutu)

Aby upewnić się, że wdrożenie zostało przeprowadzone poprawnie, użyto:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdyQpS-3Kr1m_Q9BRbuSz0ByTWXj4CoxHNwZea657qxaV8vrECOjvGVsyCaST2JPNkB5LfYJ7vmdYko9bC9PxIehcLFcSvm9YPeoRaafEo-ppnbZh8UpxnQoUZdAesDSBES-lus3Q?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
Wszystkie 4 repliki zostały poprawnie uruchomione i działają bez błędów.

### 3. Eksponowanie aplikacji

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#3-eksponowanie-aplikacji)

Aby udostępnić aplikację na zewnątrz klastra, wykonano:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdmzPlTJDjpzPeUxxPsVTJPfhunTDyfDXYiDdc9Jfeicpf9bzOKpzzhSgJSYgB9J-hLEx-W6dmw--4jDqJwoZt397toeAiwNDqEWwoGENHPDhUeo0B1cEVtAHu3y3eFgQXK4_oAEg?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### 4. Przekierowanie portu do serwisu

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#4-przekierowanie-portu-do-serwisu)

Aplikacja została wystawiona lokalnie poprzez przekierowanie portu z serwisu:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXctaYGqUMrSiVc0c9tBewHWxBXTxOuwxQ-1jZwPuEdoJJ5Sud0i4dH_cAiAU0MDTwX6Cw060tLpkYe80pX225beLeG8UsoQqNq-DunMPGNZufLRN15q5WaDNJK5VTnhx2jdeeXM?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### Dashboard – Weryfikacja wizualna

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#dashboard--weryfikacja-wizualna)

Do weryfikacji działania aplikacji i zarządzania zasobami klastra wykorzystano Dashboard Minikube.

1.  **Workload Status**

Pokazuje ogólny stan zasobów wdrożonych w klastrze:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeEIcQwqneX1Iqk1j6ckEfk5jJ2yQ5zrUoPX7SIzyWMaZXSaZMNR5t9Deq-tBqtx-yjlic8-L6IpzziMKIaglgoRTivpxNMo8k0wEKRMavO91GnEvv_VwKSWtAg6PwUwUtx5LvVvA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
2.  **Pods**

Widoczne są wszystkie 4 repliki poda  `nginx-deployment`:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXe4caEo7kF3YCUtvCNQD4yoMWC6jmu-FS6auChYJkiYG1BQ_YUep9DQDVGkNrMEPkHG31mRqfSkzexiK1lFI4c3tHP9KRJ4BtUDGCMdj5nfqb4kyWqeJAFRT4FmKat4z3FIlMOIDQ?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
3.  **Deployments**

Pokazuje aktywne wdrożenie z nazwą  `nginx-deployment`:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcdAndO7HvS6kFwA-VPgWf5Mim6TjgCxh_EaGsub060WjOFR95C3Fgfhp00WKjP1PC4rebjer8nnkEp5qqEGQt7UWI0k18dW1-nvzhYOWm4nL3lyynd13FDD1-bPWzZQ-D5H1VeFw?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**


# Zajęcia11 Wdrażanie na zarządzalne kontenery: Kubernetes (2)
## Przygotowanie nowego obrazu

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#przygotowanie-nowego-obrazu)

Jako bazę wykorzystano oficjalny obraz  `httpd:alpine`. Do katalogu serwującego treści /usr/local/apache2/htdocs dodano własne pliki index.html z różną zawartością. Zbudowano i opublikowano trzy wersje obrazu:
### Wersja 1: Działająca 
**Plik index-v1.html**
```<!DOCTYPE html>
<html>
<head><title>PeryklesAthin HTTPD v1</title></head>
<body><h1>Wersja 1 – Działa!</h1></body>
</html>
```



### Wersja 2: Działająca v2

**Plik index-v2.html**
```
<!DOCTYPE html>
<html>
<head><title>PeryklesAthin HTTPD v2</title></head>
<body><h1>Wersja 2 dzialajaca rowniez</h1></body>
</html>

```


### Wersja błędna: kontener kończy się błędem exit 1 zaraz po starcie

**Plik index-v3.html**
```
<!DOCTYPE html>
<html>
<head><title>Perykles Blad</title></head>
<body><h1>Wersja bledna</h1></body>
</html>
```
### Dockerfile
**Plik Dockerfile**
```
FROM httpd:alpine
COPY index.html /usr/local/apache2/htdocs/index.html
CMD ["httpd-foreground"]
```
### Dockerfile

**Plik Dockerfile**
```
FROM httpd:alpine
COPY index.html /usr/local/apache2/htdocs/index.html
CMD ["sh", "-c", "echo Błąd uruchomienia && exit 1"]
```

Każda wersja została ręcznie zbudowana i wypchnięta do Docker Hub.

```
docker build -t periclesathin/index-v1 .
docker push periclesathin/custom-httpd:v2

```

-   budowanie poprawnej wersji
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXc7qFhdVaccWhsM8b33fdHMRUdvaeVn0tp7mCQWDxWRLgvafjyZa3GURug02xhaPrlyTuiReff872UlNHrjXc5N8RBfjF7vQ36jFgwXrOq45S1uUSU1__7BJ5f0FUSfsdsAKeSRSQ?key=xa3PLGIWh5Jf6oqWZQDg0GXU)
-   budowanie niepoprawnej wersji
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfh19hAvbizYOecpnvm6owTRuqkN1CqEChG83EEpIkfCgND8a0Q1veAwS5D7LZt5_5o377jGf5fTmLF2XJiyAzZYsVhKur_SZg7JqI_ok7BUMq23tDxjsf7EQcsNHhhMLFkaaLc?key=xa3PLGIWh5Jf6oqWZQDg0GXU)


-   wypychanie na Docker Hub
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdqfeILrGZ_xbL4tpo6cqyi114M4LjAakqiroWdQqYel5nCZFuzLMUZZGjBzq8o4aGbuWAuEcjfI-JjjWAEP8e-V7RRKE0Sqb0D-OV8tnCsKHx12N1gb85Ch0BLokKpMgXEW41AhA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdqeckKSfgn9N49Be7ajDfB0i4l2HISSSs3tqar-LdpDzjhMOAp6v9aqUpQWtrwgi4pdBMHcAuuGT0fVZ1pogeMWbefatNf-DfpeVD_dUaPQvkstB7mCK6meO2yRKx09xvkdnvWCA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)

## Zmiany w deploymencie
**Plik deployment.yaml**
```
	
apiVersion: apps/v1
kind: Deployment
metadata:
  name: periclesathin-index
spec:
  replicas: 8
  selector:
    matchLabels:
      app: periclesathin-index
  template:
    metadata:
      labels:
        app: periclesathin-index
    spec:
      containers:
        - name: index
          image: periclesathin/index:v1
          ports:
            - containerPort: 80
```

### Skalowanie: Zwiększenie replik do 8

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#skalowanie-zwi%C4%99kszenie-replik-do-8)

1.  **Zastosowanie zmian**

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdONtk1Kx2QM2ohSC35vjYc6A3b3ZB14JmCDyeNxRkUfFbDdPGsPV7cLhGOmYWwN1bS03HIb9IPXxcoaG3xStuvNFDCFi8sw2iGCw3UBarv_Zm3lv_vz7ES5dau4Wz-spNJZkDu?key=xa3PLGIWh5Jf6oqWZQDg0GXU)

2.  **Sprawdzenie liczby podów i deployment**
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfHiMfs7XS1x3quyPBGv0iuqkontKdT2sblKHz2TeVLBB2PpUBTFHio6tJIUBU2txjEPBb9VBLieEKPN-WkPjS_JceAQg-GuHYbxV9NcmSV-FcNeyUzR2xf_p_2IYa-_3i_tpXXTg?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXccB4ax2PpKts1pWq9wsMpNlLM9YIXCbk946YGx8dlkuikAQcFOfVZAvHJEAAra73enfI3nY-8LBxG650CpCon-0uiJzmHsUhHVvB0Ekk4-vHE4sn8XpCXcBggR3DISDgEtGMmb7w?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
### Skalowanie: Zmniejszenie do 1 repliki

1.  **Sprawdzenie liczby podów i deployment**
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdf1fEjmpJOmqs8ZNbetWoRQaS7HFzLpC0YWXdpmm5KgRIVbfjXs95rUz0xlbWDZfIyOVu29ntk1o_W-RY9r9616O0_a5d6cvSzWiwTY8ZVL-vpDb11j8UYHh8fkft6mHNJ-m6qLA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

 #### Zmiany w deploymencie

-   Wprowadzano szereg zmian w deploymencie, ustawiano ilość replik kolejno na: 8, 1, 0, 4
    
    -   _Zrzut ekranu zmian_:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXerY4P-dFPU8jsO2vtzv8irlSMhyfZgVD0hXziZ8dJXgNPuNu0svEW961DfgtdMrN3BHW6nIT6X6sjyVXl8WLN7EBh_GgwYEuHvOX6G8TULmyJZG6KJ2Mdah8dZ3PILVTi2uJBs?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
Zmiany liczby replik nie są zapisywane jako nowe wersje w historii rolloutów, ponieważ nie modyfikują szablonu podów (`spec.template`). W historii pozostają jedynie te rewizje, które wprowadzały rzeczywiste zmiany w konfiguracji kontenerów, np. obrazu.

Użyto deploymentu o nazwie `periclesathin-index`, którego historia była analizowana. Zmiany liczby replik w pliku `deployment.yaml` (np. 1 → 8 → 0 → 4) nie wpływały na historię rolloutów. W celu wyzerowania historii usunięto deployment poleceniem `kubectl delete deployment periclesathin-index` i ponownie zastosowano jego definicję YAML (`kubectl apply -f deployment.yaml`).
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeyiDgH35gATdkp3dTnxq9tFqVlr7FUQzdvaxG15-CGuvcNZo2fOQJhZCyPkpE9wALFUCMy2JSnQvS9bil4hD8nrpFQVBogd-JLncHOalgdb7ceXkGrDwt-hEaKprI0KSmjmUrt3g?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**
Przeprowadzono rollout nowej wersji obrazu i zweryfikowano powodzenie zmiany obrazu poleceniem
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcNroFpOXg_aYwgDzOMzadEv4bPRFfsqSNHNRXys9Mf7keZhk4CTy0Sn0pHihJfZOGxuM25fCpbiQxs_9w2KDTeQQX9_CSxabqcHFNIOsLVTQi5-g-KbMeRRB1BACyXM9UHQPeHeA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

-   Napisano skrypt weryfikujący czy proces wdrażania zakończył się w ciągu 60 sekund

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeKeI-fDxAvWmp_X0BS3U8mMkz6Y8hcmHlQcpetscVM3ARRXq-AUfqC0lFYG0_BjLkHRt2JuQJCY_u8HL8F38bFG7SXFQJCSe0UhD9d_iM-5gIOFTvZ2zu7KdADfxelSuTHBx0FNA?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

### Strategie wdrożenia

### Plik: `recreate-deployment.yaml`

`strategy:  type:  Recreate` 

Aby przetestować strategię Recreate, zmodyfikowano deployment `periclesathin-index`, dodając strategię typu `Recreate`. 

### Opis:

-   W tej strategii stare pody są najpierw usuwane, zanim pojawią się nowe.
    
-   Powoduje to potencjalną przerwę w dostępności aplikacji.
    

### Obserwacja:

-   Na screenie widoczne są 4 pody `periclesathin-recreate-XXXX`, wszystkie w stanie `Running`.
    
-   W trakcie rolloutu mogła wystąpić chwilowa luka między usunięciem starych a utworzeniem nowych podów.

RollingUpdate
```
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 2
    maxSurge: 25%
```

### Opis:

-   Strategia domyślna, w której aktualizacja następuje stopniowo.
    
-   `maxUnavailable: 2` – do 2 podów może być niedostępnych w trakcie aktualizacji.
    
-   `maxSurge: 25%` – może zostać tymczasowo uruchomiony jeden dodatkowy pod (25% z 4).
### Obserwacja:

-   Pody z nazwą `periclesathin-rolling-XXXX` (4 szt.) działają równolegle.
    
-   Aktualizacja odbyła się bez przerwy w dostępności.


## Canary Deployment

### Konfiguracja:

-   `periclesathin-stable.yaml`: 3 repliki wersji v1
    
-   `periclesathin-canary.yaml`: 1 replika wersji v2
Etykiety:

`labels:  
	app:  periclesathin  
	version:  stable`
``
labels:
  app: periclesathin
  version: canary``

### Opis:

-   Dwie wersje aplikacji działają równocześnie.
    
-   Umożliwia testowanie nowej wersji (v2) na małej części użytkowników bez wpływu na stabilną wersję.
    

### Obserwacja:

-   4 pody z nazwą `periclesathin-stable-XXXX` w stanie `Running`.

## Screen – `kubectl get pods`

Zrzut ekranu pokazuje:

-   `periclesathin-recreate` – 4 pody
    
-   `periclesathin-rolling` – 4 pody
    
-   `periclesathin-stable` – 4 pody
    

Wszystkie pody są w stanie `Running`, co oznacza poprawne zakończenie rolloutów.

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcoXS3LyAT5dnJXe0OzM4FPVEjjVNfIiIJ885zy5nzU7q08xYG6Wrb-JPPwf8zJLFkqwTqjAtO9Ws-XsivfI13o4xQiiPSuSYfSnx_9S6SEB4czPdLev2aD5WiNw5mL_JqaNdZZMw?key=xa3PLGIWh5Jf6oqWZQDg0GXU)**

### 📊 Porównanie strategii wdrożenia w Kubernetes

| Strategia         | Opis działania                                                             | Dostępność podczas wdrożenia | Zalety                                             | Wady                                                  | Zastosowanie typowe            |
|-------------------|------------------------------------------------------------------------------|-------------------------------|----------------------------------------------------|--------------------------------------------------------|---------------------------------|
| **Recreate**      | Najpierw usuwa wszystkie stare pody, potem tworzy nowe                     |  Może być przerwa            | Prosta, szybka, łatwa do zrozumienia               | Przestój w działaniu aplikacji                         | Środowiska testowe/dev         |
| **RollingUpdate** | Stopniowo podmienia stare pody nowymi z limitem równoczesnych operacji     |  Tak                         | Bez przestoju, elastyczna konfiguracja             | Wolniejsze wdrożenie, więcej zasobów podczas przejścia | Produkcja, wymagania ciągłości |
| **Canary**        | Nowa wersja działa równolegle z obecną (część ruchu kierowana do niej)     |  Tak                         | Możliwość testowania nowych wersji bez ryzyka      | Wymaga więcej konfiguracji (etykiety, usługi)          | A/B testy, wersjonowanie       |
