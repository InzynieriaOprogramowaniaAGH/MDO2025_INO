# **Sprawozdanie 3** - Metodyki DevOps
  kod:
  ```bash
  ```

- [x] **podpunkt**
  - **podpunkt**

_________________________________________________________________________________________________________________________________________________________
## **LAB 8 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible** 

Celem ćwiczeń było przygotowanie pliku odpowiedzi i wykorzystanie go do przeprowadzenia nienadzorowanej instalacji systemu Fedora. Podczas zajęć skonfigurowałam instalator tak, aby system po uruchomieniu automatycznie zawierał wymagane repozytoria, zależności oraz uruchamiał moje oprogramowanie. Dzięki temu udało się w pełni zautomatyzować proces instalacji i wdrożenia środowiska testowego.

### Instalacja zarządcy Ansible
- [x] **🌵 Utwórz drugą maszynę wirtualną o **jak najmniejszym** zbiorze zainstalowanego oprogramowania**
  - **Zastosuj ten sam system operacyjny, co "główna" maszyna (najlepiej też w tej samej wersji)**
  - **Zapewnij obecność programu `tar` i serwera OpenSSH (`sshd`)**

Użyłam poniższych poleceń żeby się upenić że tar i sshd będą na maszynie:
```bash
sudo dnf install -y tar openssh-server
sudo systemctl enable sshd --now
```

  - **Nadaj maszynie *hostname* `ansible-target` (najlepiej jeszcze podczas instalacji)**

Ustawiłam hostname poleceniem `sudo hostnamectl set-hostname ansible-target`. Następnie zrestartowałam system w celu wprowadzenia zmian dzięki `sudo reboot`

  - **Utwórz w systemie użytkownika `ansible` (najlepiej jeszcze podczas instalacji)**

Stworzyłam użytkownika i stworzyłam do niego hasło
``` bash
sudo useradd ansible
sudo passwd ansible
```
Nadałam mu też uprawnienia komendą `sudo usermod -aG wheel ansible`.

  - **Zrób migawkę maszyny (i/lub przeprowadź jej eksport)**
W Hyper-V w odpowiednim miejscu w ustawieniach kliknęłam stworzeni migawki (punktu kontrolnego) maszyny. 
![image](https://github.com/user-attachments/assets/0a1ff97f-9f44-4d7d-a75e-d1f65f96a325)

Zaś aby wykonać jej eksport musiałabym tak jak poniżej na wyłączonej maszynie kilkając prawym przyciskiem na maszynę wybrac miejsce docelwoe jej eksportowania i mogłabym się wówczas cieszyć zapisem mojej maszyny:

![image](https://github.com/user-attachments/assets/f42364e0-512b-49f5-a73b-abf3c1d259a0)

- [x] **🌵 Na głównej maszynie wirtualnej, zainstaluj oprogramowanie Ansible**

Na maszynie "Fedora" pobrałam ansible `sudo dnf install ansible -y`

- [x] **Wymień klucze SSH między użytkownikiem w głównej maszynie wirtualnej, a użytkownikiem `ansible` z nowej tak, by logowanie `ssh ansible@ansible-target` nie wymagało podania hasła**

Skorzystałam z polecenia  `ssh-copy-id ansible@ansible-target`, niestety coś poszło nie tak i połcząenie wymagało podania hasła:

![image](https://github.com/user-attachments/assets/ad564db3-eca1-4644-a6a4-f7e7f3dd8bcb)

Jak widać, miałam mały porblem z wymianą kluczy. Wystarczyło jednak ruchomić proces `ssh-agent (eval "$(ssh-agent -s)")`, a następnie dodałam do niego mój klucz prywatny (`ssh-add ~/.ssh/id_ed25519`). Agent SSH przechowuje klucz w pamięci i automatycznie go udostępnia przy każdej próbie połączenia, dzięki czemu polecenie
`ssh ansible@ansible-target` loguje się od razu – bez ponownego pytania o passphrase. Teraz wymiana kluczy między maszynami przebiegła poprawnie:

![image](https://github.com/user-attachments/assets/f5798d6d-f7dc-4047-9d3b-f4ff8a1cfc2a)

Sprawdziłam szybko połączenie, w tym celu w pliku */etc/ansible/hosts* dodałam linijkę 
```bash
[targets]
ansible-target
```
Rezultaty:
![image](https://github.com/user-attachments/assets/1347efd4-0cb9-4ee0-af5d-777b62c4ce67)

### Inwentaryzacja
- [x] **🌵 Dokonaj inwentaryzacji systemów**
  - **Ustal przewidywalne nazwy komputerów (maszyn wirtualnych) stosując `hostnamectl`, Unikaj `localhost`.**

Na maszynie głównej uruchomiłam `hostnamectl set-hostname ansible-orchestrator`, a dla maszyny docelowej pozostała nazwa *ansible-target*

![image](https://github.com/user-attachments/assets/b9fa36e8-5019-4a50-8452-477715e198a6)

  - **Wprowadź nazwy DNS dla maszyn wirtualnych, stosując `systemd-resolved` lub `resolv.conf` i `/etc/hosts`**

W pliku /etc/hosts dodałam wpisy przypisujące statyczne adresy IP do nazw maszyn wirtualnych. Dzięki temu możliwe jest odwoływanie się do komputerów za pomocą nazw (np. ansible-orchestrator, ansible-target), zamiast zapamiętywania adresów IP. 

![image](https://github.com/user-attachments/assets/9fca6e63-a822-42ab-b534-49a9fad4f84d)

  - **Zweryfikuj łączność**

W tym celu poprostu wykonałam *ping*:
![image](https://github.com/user-attachments/assets/1c0a4691-841c-48ca-a94c-f74276b3144d)


  - **Stwórz plik inwentaryzacji]**
  - **Umieść w nim sekcje `Orchestrators` oraz `Endpoints`. Umieść nazwy maszyn wirtualnych w odpowiednich sekcjach**

Utowrzyłam plik hosts.ini (INI to format pliku konfiguracyjnego - nazwa od "initialization")
hosts.ini:
```
[Orchestrators]
ansible-orchestrator ansible_user=kaoina

[Endpoints]
ansible-target ansible_user=ansible

```

  - **🌵 Wyślij żądanie `ping` do wszystkich maszyn**
Aby to zrobić wykonałam polecenie `ansible all -i hosts.ini -m ping`. Polecenie to wykorzystuje Ansible do wysłania żądania ping do wszystkich hostów (all) zdefiniowanych w pliku hosts.ini. Dzięki temu mogłam upewnić się, że maszyny są dostępne przez SSH, poprawnie rozpoznają się po nazwach
![image](https://github.com/user-attachments/assets/ad665af3-a1dc-49a5-8f1f-faf7a26dbf70)

- [x] **Zapewnij łączność między maszynami**
  - **Użyj co najmniej dwóch maszyn wirtualnych**
  - **Dokonaj wymiany kluczy między maszyną-dyrygentem, a końcówkami**

Aby zapewnić bezhasłową łączność SSH między maszyną-dyrygentem (ansible-orchestrator) a maszynami docelowymi (ansible-target oraz samym orchestrator), wygenerowałam parę kluczy SSH (jeśli jeszcze nie istniała), a następnie przesłałam klucz publiczny na maszyny docelowe przy użyciu polecenia ssh-copy-id. Operację wykonałam dla obu maszyn:
```bash
ssh-copy-id kaoina@ansible-orchestrator 
ssh-copy-id ansible@ansible-target
```
  - **Upewnij się, że łączność SSH między maszynami jest możliwa i nie potrzebuje haseł**
Aby upewnić się, że łączność SSH między maszynami nie wymaga podawania hasła, uruchomiłam agenta SSH poleceniem `eval "$(ssh-agent -s)"`. Następnie dodałam klucz prywatny do agenta za pomocą `ssh-add ~/.ssh/id_ed25519`. Po podaniu hasła do klucza klucz został załadowany i mogłam połączyć się z maszyną ansible-target poleceniem ssh ansible@ansible-target bez potrzeby podawania hasła do użytkownika.

![image](https://github.com/user-attachments/assets/8096a149-55b3-4263-bd8a-c6cd1e97d930)

### Zdalne wywoływanie procedur
Za pomocą playbooka Ansible:
  - [x] **🌵 Wyślij żądanie `ping` do wszystkich maszyn**
  - [x] **Skopiuj plik inwentaryzacji na maszyny/ę `Endpoints`**
  - [x] **Ponów operację, porównaj różnice w wyjściu**

Zawartość playbooka:
```bash
- name: Ping and copy inventory file
  hosts: all
  tasks:
    - name: Ping each host
      ansible.builtin.ping:

    - name: Copy hosts.ini to endpoints
      copy:
        src: ./hosts.ini
        dest: /tmp/hosts.ini
      when: "'ansible-target' in inventory_hostname"
```
Wywołanie playbooka komendą: ` ansible-playbook -i hosts.ini ping_and_copy.yml `
Następnie połączyłam się zdalnie z ansible-target, aby upewnić się, że plik został poprawnie skopiowany do */tmp/hosts.ini*:
![image](https://github.com/user-attachments/assets/bf58eee1-abd2-4d70-b84d-8a888ca375c3)

Pierwsze uruchomienie:
![image](https://github.com/user-attachments/assets/78e005c4-331e-40ab-81c1-4e0fbff07084)

Kolejne uruchomienie:
![image](https://github.com/user-attachments/assets/b162ff46-49c5-4507-a687-2d97534202e5)

Przy kolejnym uruchomieniu:
-	ping dalej działa
-	copy pokazuje ok zamiast changed
Przy ponownym uruchomieniu playbooka, zadanie ping nadal potwierdza łączność ze wszystkimi maszynami, natomiast zadanie kopiowania pliku zwraca ok zamiast changed, ponieważ zawartość pliku hosts.ini na maszynie docelowej nie uległa zmianie. To pokazuje, że Ansible nie wykonuje zmian, jeśli nie są potrzebne.

  - [x] **Zaktualizuj pakiety w systemie**

Aby zaktualizować wszystkie pakiety na maszynach docelowych, przygotowałam prosty playbook Ansible o nazwie update.yml. Playbook ten wykorzystuje moduł dnf do bezpiecznej aktualizacji wszystkich pakietów do najnowszych wersji:
```bash
- name: Update all packages on Endpoints
  hosts: Endpoints
  become: true
  tasks:
    - name: Update all packages (safe way)
      ansible.builtin.dnf:
        name: "*"
        state: latest
        update_cache: yes
```
Playbook uruchomiłam komendą ` ansible-playbook -i hosts.ini update.yml --ask-become-pass`. Ze względu na to, że aktualizacja pakietów wymaga uprawnień administratora, musiałam dodać opcję --ask-become-pass, aby Ansible zapytało o hasło do sudo.

![image](https://github.com/user-attachments/assets/c7748060-6cd8-4f54-a0dd-4580c4b13371)

  - [x] **Zrestartuj usługi `sshd` i `rngd`**

Aby zrealizować zadanie polegające na restarcie usług sshd i rngd na maszynach końcowych, przygotowałam playbook restart.yml, który wyglądał następująco:
plik *restart.yml*:
```bash
- name: Restart sshd and rngd services on Endpoints
  hosts: Endpoints
  become: true
  tasks:
    - name: Restart sshd
      ansible.builtin.service:
        name: sshd
        state: restarted

    - name: Restart rngd
      ansible.builtin.service:
        name: rngd
        state: restarted
```

Początkowo uruchomienie playbooka zakończyło się błędem
![image](https://github.com/user-attachments/assets/3a923204-5d2d-44da-89ef-58e68c370200)

Usługa rngd nie była dostępna na systemie ("Could not find the requested service rngd"). Sprawdziłam jej status (`systemctl status rngd`), a następnie zainstalowałam brakujący pakiet `sudo dnf install rng-tools`

![image](https://github.com/user-attachments/assets/db742689-6452-4ea0-ba85-779cfedbdc6d)

Ponowne wykonanie playbooka zakończyło się pełnym sukcesem. Dzięki temu oba demony (sshd i rngd) zostały zrestartowane automatycznie z poziomu Ansible.
![image](https://github.com/user-attachments/assets/e8c31f7c-ebab-4335-9741-af94d5f00faf)

  - [x] **Przeprowadź operacje względem maszyny z wyłączonym serwerem SSH, odpiętą kartą sieciową**
Po odłączeniu ssh na maszynie ansible (` sudo systemctl stop sshd`) otrzymaliśmy poniższy wynik:

![image](https://github.com/user-attachments/assets/4a59f249-c842-4fe4-ac15-ccb7cc9533c0)

### Zarządzanie stworzonym artefaktem
Za pomocą playbooka Ansible:

- [x] **Jeżeli artefaktem z Twojego *pipeline'u* był kontener:
  - **Zbuduj i uruchom kontener sekcji `Deploy` z poprzednich zajęć**
  - **Pobierz z Docker Hub aplikację "opublikowaną" w ramach kroku `Publish`**
  - **Na maszynie docelowej, **Dockera zainstaluj Ansiblem!**
  - **Zweryfikuj łączność z kontenerem**
  - **Zatrzymaj i usuń kontener**

W ramach zadania stworzyłam playbook do zarządzania kontenerem Docker, który jest efektem działania pipeline'u. Całość została zaimplementowana w postaci roli Ansible. Utworzyłam strukturę roli przy pomocy komendy ` ansible-galaxy init docker_artifact`

![image](https://github.com/user-attachments/assets/c56cb3b6-159c-4aa0-b4a9-86e537405131)

W pliku docker_artifact/tasks/main.yml umieściłam zadania odpowiedzialne za:
  * instalację i uruchomienie Dockera
  * pobranie kontenera kaoina666/redis_runtime:2 z Docker Hub
  * jego uruchomienie z odpowiednim przekierowaniem portu
  * sprawdzenie dostępności usługi Redis
  * a następnie jego zatrzymanie i usunięcie

```bash
- name: Install Docker
  ansible.builtin.dnf:
    name: docker
    state: present
  become: true

- name: Enable and start Docker
  ansible.builtin.service:
    name: docker
    state: started
    enabled: true
  become: true

- name: Pull Redis image from Docker Hub
  community.docker.docker_image:
    name: kaoina666/redis_runtime
    tag: "2"
    source: pull

- name: Run Redis container
  community.docker.docker_container:
    name: redis_test
    image: kaoina666/redis_runtime:2
    state: started
    restart_policy: always
    published_ports:
      - "6380:6379"

- name: Wait for Redis to respond on port 6380
  ansible.builtin.wait_for:
    host: "127.0.0.1"
    port: 6380
    timeout: 15

- name: Stop Redis container
  community.docker.docker_container:
    name: redis_test
    state: stopped

- name: Remove Redis container
  community.docker.docker_container:
    name: redis_test
    state: absent
```
Aby działało, muszą być zainstalowane wszystkie potrzebne kolekcje:
![image](https://github.com/user-attachments/assets/2dfacd4a-2637-48e1-99d3-68bab6b054b4)

Plik requirements.yml:
```bash
collections:
  - name: community.docker
```
Całość uruchomiłam przez playbook run_artifact.yml komendą ` ansible-playbook -i hosts.ini run_artifact.yml --ask-become-pass`

![image](https://github.com/user-attachments/assets/d2c868f8-b548-40d9-b078-ca5252966640)

Moje run artifact:
```
- name: Manage Redis container artifact
  hosts: Endpoints
  become: true

  roles:
    - docker_artifact
```
Po uruchomieniu playbook wykonał wszystkie zadania poprawnie: Redis został pobrany i uruchomiony, a następnie zatrzymany i usunięty.
_______________________________________________________________________
## **LAB 9 Pliki odpowiedzi dla wdrożeń nienadzorowanych (Kickstart)** 

Cel - 

### Zadanie
- [x] **podpunkt**
  - **podpunkt**
_________________________________________________________________
## **LAB 10 Wdrażanie na zarządzalne kontenery: Kubernetes (1)**

Cel - 

### Zadanie
- [x] **podpunkt**
  - **podpunkt**
_________________________________________________________________
## **LAB 11 Wdrażanie na zarządzalne kontenery: Kubernetes (2)**

Cel - 

### Zadanie
- [x] **podpunkt**
  - **podpunkt**
