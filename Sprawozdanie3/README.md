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
(screen)

Można zauważyć, że instalator Anaconda automatycznie generuje plik odpowiedzi  `anaconda-ks.cfg`.

Plik ten zawiera wszystkie odpowiedzi na pytania, które były udzielane ręcznie podczas procesu instalacji. Dzięki temu można go wykorzystać do stworzenia maszyny wzorcowej i przyspieszenia wdrażania systemu na wielu maszynach bez konieczności każdorazowego przechodzenia przez cały proces instalacji.



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

[](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/tree/KM417392/ITE/GCL05/KM417392/Sprawozdanie3#4-anaconda-kscfg)

-   [anaconda-ks.cfg](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/KM417392/ITE/GCL05/KM417392/Sprawozdanie3/kickstart/anaconda-ks.cfg)
```
#version=DEVEL
# Generated by Anaconda 41.35
# Modified for Fedora unattended install

# Źródła repozytoriów
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

# Układ klawiatury i język
keyboard --vckeymap=pl --xlayouts='pl'
lang pl_PL.UTF-8

# Sieć i nazwa hosta
network  --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate
network  --hostname=fedora-mruby.local

# Pakiety
%packages
@^server-product-environment
%end

# Setup Agent po starcie
firstboot --enable

# Dysk
ignoredisk --only-use=sda
autopart
clearpart --all --initlabel

# Strefa czasowa
timezone Europe/Warsaw --utc

# Hasła
rootpw haslo123 --plaintext
user --groups=wheel --name=kasiam --password=haslo123 --plaintext --gecos="kasiam"

# Post install
%post --log=/root/post-install.log
echo "Instalacja zakończona pomyślnie." > /root/sukces.txt
%end

# Restart po instalacji
reboot

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
user --groups=wheel --name=kasiam --password=haslo123 --plaintext --gecos="kasiam"

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

### Potwierdzenie działania

Po zakończeniu instalacji i automatycznym restarcie systemu jednostka `run-xz.service` została uruchomiona.

Logi systemd wskazują:

-   testowy plik `test.txt` został utworzony w katalogu `/opt`,
    
-   usługa `run-xz.service` uruchomiła skrypt `/usr/local/bin/run-xz.sh`,
    
-   skrypt wykonał polecenie kompresji `xz -z -k /opt/test.txt`,
    
-   wynikowy plik `test.txt.xz` został poprawnie wygenerowany.
    

Usługa zakończyła się bezbłędnie (`status=0/SUCCESS`) i ma status `enabled`, co oznacza, że uruchamia się przy każdym starcie systemu.

### Weryfikacja manualna

Aplikacja `xz` została zainstalowana lokalnie i uruchamiana poza kontenerem.  
W pliku odpowiedzi `ks.cfg` utworzono jednostkę `run-xz.service`, która automatycznie uruchamia komendę kompresji przy starcie systemu.

Aby zweryfikować działanie aplikacji, można wykonać następujące polecenie:
