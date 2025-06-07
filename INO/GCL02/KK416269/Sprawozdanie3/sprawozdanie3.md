# **Sprawozdanie 3** - Metodyki DevOps
_________________________________________________________________________________________________________________________________________________________
## **LAB 8 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible** 

Celem ćwiczeń było przygotowanie pliku odpowiedzi i wykorzystanie go do przeprowadzenia nienadzorowanej instalacji systemu Fedora. Podczas zajęć skonfigurowałam instalator tak, aby system po uruchomieniu automatycznie zawierał wymagane repozytoria, zależności oraz uruchamiał moje oprogramowanie. Dzięki temu udało się w pełni zautomatyzować proces instalacji i wdrożenia środowiska testowego.

### Instalacja zarządcy Ansible
- [x] **Utwórz drugą maszynę wirtualną o **jak najmniejszym** zbiorze zainstalowanego oprogramowania**
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

- [x] **Na głównej maszynie wirtualnej, zainstaluj oprogramowanie Ansible**

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
- [x] **Dokonaj inwentaryzacji systemów**
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

  - **Wyślij żądanie `ping` do wszystkich maszyn**
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
  - [x] **Wyślij żądanie `ping` do wszystkich maszyn**
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

Tematem laboratorium było przygotowanie automatycznego źródła instalacji systemu operacyjnego Fedora z wykorzystaniem pliku odpowiedzi Kickstart. Celem było przeprowadzenie nienadzorowanej instalacji systemu oraz konfiguracja środowiska tak, aby po uruchomieniu system automatycznie uruchamiał nasze oprogramowanie. W ramach zadania należało także zadbać o odpowiednie repozytoria, zależności oraz sposób pobrania i instalacji aplikacji.

### Zadania do wykonania
Przeprowadź instalację nienadzorowaną systemu Fedora z pliku odpowiedzi z naszego repozytorium
- [x] **Zainstaluj system Fedora**
  * zastosuj instalator sieciowy (*Everything Netinst*) lub
  * zastosuj instalator wariantu *Server* z wbudowanymi pakietami, przyjmujący plik odpowiedzi (dobra opcja dla osób z ograniczeniami transferu internetowego)

- [x] **Pobierz plik odpowiedzi `/root/anaconda-ks.cfg`**

Za pomocą polecenia cat wyciągnęłam zawartość pliku *anaconda-ks.cfg* i skopiowałam go

![image](https://github.com/user-attachments/assets/cb34927f-e1a9-4e76-8548-76ab9bfd1b82)


- [x] **Zapoznaj się z dokumentacją pliku odpowiedzi i zmodyfikuj swój plik:**
  - **Plik odpowiedzi może nie zawierać wzmianek na temat potrzebnych repozytoriów. Jeżeli Twoja płyta instalacyjna nie zawiera pakietów, dodaj wzmiankę o repozytoriach skąd je pobrać. Na przykład, dla systemu Fedora 38:
      * `url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64`
      * `repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64`
  - **Plik odpowiedzi może zakładać pusty dysk. Zapewnij, że zawsze będzie formatować całość, stosując `clearpart --all`**
  - **Ustaw *hostname* inny niż domyślny `localhost`**
  
Na podstawie dokumentacji Kickstarta oraz wymagań zadania, wprowadziłam następujące zmiany w pliku anaconda-ks.cfg:

  * Dodanie repozytoriów internetowych – umożliwia pobranie pakietów:
```bash
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64
```
 
  * Ustawienie niestandardowej nazwy hosta
```bash
network --hostname=NowyHostKaoiny
```
(Uwaga: początkowo użyłam Nowy_host_Kaoiny, ale znak _ powodował błąd – został usunięty.)

  * Dodanie wyczyszczenia wszystkich partycji – zapewnia, że instalator nadpisze cały dysk i nie zostaną żadne dane
``` bash
clearpart --all --initlabel
```

  * Dodanie automatycznego restartu systemu po instalacji:
`reboot`


```bash
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

# Repozytoria i źródło instalacji
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

# Network information
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=Nowy_host_Kaoiny

%packages
@^server-product-environment

%end

# Run the Setup Agent on first boot
firstboot --enable

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part pv.159 --fstype="lvmpv" --ondisk=sda --size=8500
part /boot --fstype="ext4" --ondisk=sda --size=1024
part /boot/efi --fstype="efi" --ondisk=sda --size=600 --fsoptions="umask=0077,shortname=winnt"
volgroup fedora_kaoinafedora --pesize=4096 pv.159
logvol / --fstype="ext4" --grow --maxsize=71680 --size=1024 --name=root --vgname=fedora_kaoinafedora

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --lock
user --groups=wheel --name=kaoina --password=$y$j9T$Za.bEcfmtiXOZcJwU4ZjeVc3$J1zgPRZWQk29WsCQCxdmuuGHUw3fkISdkP1RJfpqYQ6 --iscrypted --gecos="Kaoina"

reboot
```

- [x] **Użyj pliku odpowiedzi do przeprowadzenia instalacji nienadzorowanej**
  - **Uruchom nową maszynę wirtualną z płyty ISO i wskaż instalatorowi przygotowany plik odpowiedzi stosowną dyrektywą**

W celu uruchomienia nienadzorowanej instalacji, przygotowany plik Kickstarta umieściłam w repozytorium GitHub, a następnie, podczas startu maszyny wirtualnej z obrazu ISO Fedory, nacisnęłam klawisz e w menu i dopisałam do linii startowej jądra parametr `inst.ks=<link_do_pliku_ks>`, gdzie <link_do_pliku_ks> wskazywał bezpośredni link do wersji Raw pliku Kickstarta w repozytorium.

![image](https://github.com/user-attachments/assets/6171688c-1edb-4a48-bc6b-57f841c2b86f)

Skąd link do pliku odpowiedzi(Raw File):

![image](https://github.com/user-attachments/assets/7d857342-bfb3-42a5-aec8-13d8ef6776a7)

Bład z powodu znaku "_":C

![image](https://github.com/user-attachments/assets/195cdb53-f057-4808-8f05-42d6e47cffd6)


Instalacja rozpoczęła się automatycznie i zakończyła sukcesem, bez konieczności dalszej ingerencji z mojej strony. Maszyna została poprawnie skonfigurowana, zainstalowana i zrestartowana – zgodnie z zawartością przygotowanego pliku .ks.

![image](https://github.com/user-attachments/assets/f92c53fd-6fca-4fcc-9367-5ff64409687e)
![image](https://github.com/user-attachments/assets/33e1a1be-e6e3-4c9b-9618-d72f555779b4)


---
- [x] **Rozszerz plik odpowiedzi o repozytoria i oprogramowanie potrzebne do uruchomienia programu, zbudowanego w ramach projektu - naszego *pipeline'u*.**
  - **W przypadku kontenera, jest to po prostu Docker.
      - **Utwórz w sekcji `%post` mechanizm umożliwiający pobranie i uruchomienie kontenera
      - **Jeżeli efektem pracy pipeline'u nie był kontener, a aplikacja samodzielna - zainstaluj ją
    - **Pamiętaj, że **Docker zadziała dopiero na uruchomionym systemie!** - nie da się wdać w interakcję z Dockerem z poziomu instalatora systemu: polecenia `docker run` nie powiodą się na tym etapie. Nie zadziała też `systemctl start` (ale `systemctl enable` już tak)

W ramach poprzednich laboratoriów korzystałam z kontenera Dockera zawierającego Redis. W związku z tym, aby system po instalacji automatycznie pobierał i uruchamiał ten kontener, wykonałam następujące modyfikacje w pliku *anaconda*:

  * Dodanie repozytorium Dockera – umożliwia instalację Dockera
```bash
repo --name=docker-ce --baseurl=https://download.docker.com/linux/fedora/41/x86_64/stable
```
  * Dodanie pakietów Dockera w sekcji %packages – wymagane komponenty do uruchamiania kontenerów
```bash
docker-ce
docker-ce-cli
containerd.io
```
  * Konfiguracja w sekcji %post

    * Włączono usługę Docker przy starcie:
      
    ```bash
    systemctl enable docker
    ```
    
    * Utworzono katalog */opt/scripts* i plik *start-redis.sh*, który uruchamia kontener Redis:
    
    ```bash
    cat > /opt/scripts/start-redis.sh << 'EOF'
    #!/bin/bash
    sleep 10
    docker run -d --name redis --restart=always -p 6379:6379 kaoina666/redis_runtime:2
    EOF

    chmod +x /opt/scripts/start-redis.sh
    ```
    
    * Utworzono usługę *systemd start-redis-container.service*, która uruchamia skrypt:
  
    ```bash
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
    ```



Zmodyfikowany plik:
```bash
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

# Repozytoria i źródło instalacji
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64
repo --name=docker-ce --baseurl=https://download.docker.com/linux/fedora/41/x86_64/stable

# Network information
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=NowyHostKaoiny

%packages
@^server-product-environment
docker-ce
docker-ce-cli
containerd.io
%end

%post --log=/root/ks-post.log
# Docker do uruchamiania przy starcie
systemctl enable docker

# Pobranie i przygotowanie Redisa (własny kontener z Docker Huba)
mkdir -p /opt/scripts

cat > /opt/scripts/start-redis.sh << 'EOF'
#!/bin/bash
# Start dockera
sleep 10
# Uruchom kontener redis z dockerhub
docker run -d --name redis --restart=always -p 6379:6379 kaoina666/redis_runtime:2
EOF

chmod +x /opt/scripts/start-redis.sh

# Jednostka systemd do uruchamiania kontenera przy starcie
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

# Jednostka systemd
systemctl enable start-redis-container.service
%end

# Run the Setup Agent on first boot
firstboot --enable

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part pv.159 --fstype="lvmpv" --ondisk=sda --size=8500
part /boot --fstype="ext4" --ondisk=sda --size=1024
part /boot/efi --fstype="efi" --ondisk=sda --size=600 --fsoptions="umask=0077,shortname=winnt"
volgroup fedora_kaoinafedora --pesize=4096 pv.159
logvol / --fstype="ext4" --grow --maxsize=71680 --size=1024 --name=root --vgname=fedora_kaoinafedora

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --lock
user --groups=wheel --name=kaoina --password=$y$j9T$Za.bEcfmtiXOZcJwU4ZjeVc3$J1zgPRZWQk29WsCQCxdmuuGHUw3fkISdkP1RJfpqYQ6 --iscrypted --gecos="Kaoina"

reboot
```

Uruchamianie i konfiguracja maszyny:

![image](https://github.com/user-attachments/assets/0f83c469-8c14-4d7e-8474-c79c4c8adf37)


- [x] **Zadbaj o automatyczne ponowne uruchomienie na końcu instalacji**

Za automatyczny restart systemu po zakończeniu instalacji odpowiada ostatnia linijka w pliku: `reboot`

- [x] **Zapewnij, by od razu po pierwszym uruchomieniu systemu, oprogramowanie zostało uruchomione (w dowolny sposób)**

1. Czy Docker działa?
`systemctl status docker`
Docker.service ma status active (running)
![image](https://github.com/user-attachments/assets/f7d7b1ec-a3eb-4768-af4e-ab4bae495930)

2. Czy kontener Redis działa?
`docker ps`
Widoczny kontener Redis z STATUS: Up 
![image](https://github.com/user-attachments/assets/c6712ff9-bff4-46a5-b805-66f7ee5ae659)

3. Czy Redis nasłuchuje?
`ss -lntp | grep 6379`
Widoczny proces nasłuchujący na porcie 6379.
![image](https://github.com/user-attachments/assets/944a4a2c-6e54-496a-b969-e96712b87f9b)

4. Czy usługa systemd działa?
`systemctl status start-redis-container.service`
Usługa start-redis-container.service działała i zakończyła się sukcesem:
![image](https://github.com/user-attachments/assets/f8fc7bc9-adc4-4801-a4ae-1941ea5247d0)

_________________________________________________________________
## **LAB 10 Wdrażanie na zarządzalne kontenery: Kubernetes (1)**

Celem tych laboratoriów było zapoznanie się z podstawami działania Kubernetesa oraz nauczenie się, jak uruchamiać i zarządzać aplikacjami kontenerowymi w lokalnym klastrze za pomocą Minikube. W ramach ćwiczeń zainstalowałam Minikube, uruchomiłam Dashboard, wdrożyłam własny kontener oraz przygotowałam plik YAML opisujący deployment z replikacją. 
     
### Instalacja klastra Kubernetes
- [x] **Zaopatrz się w implementację stosu k8s: minikube**

Zainstalowałam Minikube, korzystając z wersji RPM package, zgodnie z instrukcją na stronie

![image](https://github.com/user-attachments/assets/450d2659-a3fa-4d25-b80c-fb995d861c5f)

- [x] **Przeprowadź instalację, wykaż poziom bezpieczeństwa instalacji**

Aby zainstalować Minikube, wykonałam następujące komendy:

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm
```

![image](https://github.com/user-attachments/assets/226e2b91-e9ec-48f2-980a-fca29f9c259a)

Po instalacji, aby sprawdzić stan klastra, użyłam komend:
``` bash
minikube kubectl -- get pods -A -o wide
```
Ta komenda pozwala uzyskać szczegółowe informacje o podach systemowych. Na podstawie wyników mogłam zweryfikować poprawność działania aplikacji na klastrze.
![image](https://github.com/user-attachments/assets/3d61c98b-e8b6-4223-abba-4c1b46f0214b)

Ponadto, aby uzyskać dodatkowe informacje o poszczególnych podach, skorzystałam z komendy:
```bash
minikube kubectl -- describe pod <nazwa> -n kube-system
```
Wynik tej komendy pozwolił mi upewnić się, że wszystkie pody działają zgodnie z oczekiwaniami.
![image](https://github.com/user-attachments/assets/29ae13b2-ba75-4b09-8b63-41606c6d5f95)


- [x] **Zaopatrz się w polecenie `kubectl` w wariancie minikube, może być alias `minikubctl`, jeżeli masz już "prawdziwy" `kubectl`**

Zgodnie z instruckją na stornie 
![image](https://github.com/user-attachments/assets/175523b4-6e8c-404b-b43a-ebdb1dc95872)

Uruchomiłam dwie poniższe komendy aby używać narzędzia kubectl
```bash
minikube kubectl -- get po -A
alias kubectl="minikube kubectl --"
```

![image](https://github.com/user-attachments/assets/b99989cb-7ccf-42ca-8ce9-e581879ef064)

- [x] **Uruchom Kubernetes, pokaż działający kontener/worker**

Aby uruchomić klaster Kubernetes, użyłam komendy
```minikube start```

![image](https://github.com/user-attachments/assets/627e5c21-b6ed-4b1c-8b8d-1401f539dc91)

Po uruchomieniu klastra Minikube sprawdziłam jego stan komendą `minikube kubectl -- get nodes` 

![image](https://github.com/user-attachments/assets/5b60c2a4-8442-410c-ad8b-7181b952a1a1)

Wynik pokazuje, że węzeł o nazwie minikube ma status Ready, pełni rolę control-plane i działa od kilku minut, co potwierdza poprawne uruchomienie klastra Kubernetes. Następnie sprawdziłam działające pody systemowe w przestrzeni nazw kube-system, korzystając z polecenia `minikube kubectl -- get pods -A`.

![image](https://github.com/user-attachments/assets/841c83ab-fa24-4ce5-ac4c-aed92b0cd0e5)

Wszystkie pody są w stanie Running, co oznacza, że komponenty systemowe Kubernetesa działają poprawnie.

- [x] **Zmityguj problemy wynikające z wymagań sprzętowych lub odnieś się do nich (względem dokumentacji)**

Podczas uruchamiania klastra Minikube napotkałam na problem związany z pamięcią RAM. Minikube domyślnie przydziela określoną ilość pamięci wirtualnej maszynie, co może być niewystarczające w przypadku komputerów o ograniczonych zasobach. Aby rozwiązać ten problem, dostosowałam ilość przydzielonej pamięci, wykorzystując opcję --memory podczas uruchamiania klastra. Na przykład `minikube start --memory 4096`

- [x] **Uruchom Dashboard, otwórz w przeglądarce, przedstaw łączność**

Uruchomiłam Dashbord poleceniem `minikube dashboard`, co umożliwiło mi też zarządzanie prze zinterface webowy.
![image](https://github.com/user-attachments/assets/0ccd28ea-92bd-4615-a372-ba7cef1437e9)

- [x] **Zapoznaj się z koncepcjami funkcji wyprowadzanych przez Kubernetesa (*pod*, *deployment* itp)**

  * Pod to najmniejsza jednostka w Kubernetes, która może zawierać jeden lub więcej kontenerów, działających w tym samym środowisku.
  * Deployment umożliwia zarządzanie aplikacjami w Kubernetes, zapewniając skalowanie i aktualizowanie kontenerów w sposób automatyczny.
  * Service pozwala na tworzenie stałych punktów dostępu do aplikacji działających w klastrze, umożliwiając komunikację z kontenerami.

 
### Analiza posiadanego kontenera
- [x] **Zdefiniuj krok "Deploy" swojego projektu jako "Deploy to cloud":**
  - **Deploy zbudowanej aplikacji powinien się odbywać "na kontener"**
  - **Przygotuj obraz Docker ze swoją aplikacją - sprawdź, że Twój kontener Deploy na pewno **pracuje**, a nie natychmiast kończy pracę! 😎**
  - **Wykaż, że wybrana aplikacja pracuje jako kontener

Ja miałam już gotowy ten etap dzieki wcześniejszym laboratoriom. Kontener z aplikacją Redis miałam już zdeployowany na DockerHubie (przygotowany obraz Docker kaoina666/redis_runtime:2).

### Uruchamianie oprogramowania
- [x] **Uruchom kontener ze swoją/wybraną aplikacją na stosie k8s**
- [x] **Kontener uruchomiony w minikubie zostanie automatycznie "ubrany" w *pod*.**
- [x] **```minikube kubectl run -- <nazwa-jednopodowego-wdrożenia> --image=<obraz-docker> --port=<wyprowadzany port> --labels app=<nazwa-jednopodowego-wdrożenia>```**

Uruchomienie za pomocą `kubectl run redis-deployment --image=kaoina666/redis_runtime:2 --port=6379 --labels app=redis-deployment`. Kubectl run służy do uruchamiania pojedynczego poda z określonym obrazem Docker oraz konfiguracją portów i etykiet. 

![image](https://github.com/user-attachments/assets/e2c0048a-29a1-46ec-9f38-ab0f6533e41d)

- [x] **Przedstaw że *pod* działa (via Dashboard oraz `kubectl`)**

dzięki `kubectl get pods` możemy w terminalu zoabczyć, że *redis-deployment* jest aktywnym podem
![image](https://github.com/user-attachments/assets/f2271ddc-af73-4cd9-86a6-e1c6b7aa4843)

również w webowej aplikacji widoczny będzie nasz pod

![image](https://github.com/user-attachments/assets/4a631cd5-21d4-4a1c-bfc6-89e930523f74)

  
- [x] **Wyprowadź port celem dotarcia do eksponowanej funkcjonalności**
- [x] **```kubectl port-forward pod/<nazwa-wdrożenia> <LO_PORT>:<PODMAIN_CNTNR_PORT> ```**

`kubectl port-forward pod/redis-deployment 6379:6379`
Komenda ta przekierowuje port 6379 z kontenera Redis (uruchomionego w podzie o nazwie redis-deployment) na lokalny port 6379 na maszynie. Przekierowanie portów pozwala na dostęp do usługi Redis, działającej wewnątrz klastra Kubernetes, poprzez lokalny port na komputerze użytkownika.

Po wykonaniu komendy, terminal zwrócił komunikat: 
![image](https://github.com/user-attachments/assets/48f9516a-2db5-4338-b6c3-f24a0c38b08c)

- [x] **Przedstaw komunikację z eskponowaną funkcjonalnością**
W celu weryfikacji poprawności działania, użyto klienta Redis, łącząc się za pomocą następującej komendy: `redis-cli -h 127.0.0.1 -p 6379`.

![image](https://github.com/user-attachments/assets/25fb98d4-8e6e-4ca9-83e5-3f4247a5212e)

Port forwarding działa poprawnie, a usługa Redis jest dostępna lokalnie na porcie 6379.


### Przekucie wdrożenia manualnego w plik wdrożenia (wprowadzenie)
- [x] **Zapisz wdrożenie jako plik YML**
- [x] **Przeprowadź próbne wdrożenie przykładowego *deploymentu***
  - **Wykonaj ```kubectl apply``` na pliku**
  - **Upewnij się, że posiadasz wdrożenie zapisane jako plik**
  - **Wzbogać swój *deployment* o 4 repliki**
  - **Rozpocznij wdrożenie za pomocą ```kubectl apply```**
  - **Zbadaj stan za pomocą ```kubectl rollout status```**
- [x] **Wyeksponuj wdrożenie jako serwis**
- [x] **Przekieruj port do serwisu (tak, jak powyżej)**

W ramach tego zadania stworzyłam plik redis.yaml, który umożliwia wdrożenie aplikacji Redis w Kubernetes. Celem tego wdrożenia było utworzenie instancji Redis, którą można będzie wystawić na zewnątrz klastra. Aby uruchomić to wdrożenie, użyłam komendy kubectl apply -f redis.yaml.

Oto zawartość pliku redis.yaml:

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
spec:
  replicas: 4
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: kaoina666/redis_runtime:2
        ports:
        - containerPort: 6379
---
apiVersion: v1
kind: Service
metadata:
  name: redis-service
spec:
  selector:
    app: redis
  type: NodePort
  ports:
    - port: 6379
      targetPort: 6379
      nodePort: 30079
```

Po uruchomieniu tego pliku utworzyły się cztery pody, co mogłam zweryfikować, sprawdzając status wdrożenia (`kubectl get pods`)
![image](https://github.com/user-attachments/assets/3ce1a97d-ae98-4f94-b245-5d97509009c0)

Aby upewnić się, że wdrożenie poszło pomyślnie, użyłam komendy `kubectl rollout status deployment/redis-deployment`. Zgodnie z oczekiwaniami, proces zakończył się sukcesem, a wszystkie repliki zostały uruchomione:
![image](https://github.com/user-attachments/assets/3950cd09-ecf5-4d30-9214-5e992918f858)

Na końcu, zgodnie z planem, przekierowałam port do serwisu, używając komendy `kubectl port-forward svc/redis-service 6379:6379`. Aby sprawdzić, czy wszystko działa, połączyłam się z Redisem, używając *redis-cli* komendą `redis-cli -h localhost -p 6379`. Rezultat:

![image](https://github.com/user-attachments/assets/7fb51887-a4fa-433c-847b-fe4febdb1bb9)

_________________________________________________________________
## **LAB 11 Wdrażanie na zarządzalne kontenery: Kubernetes (2)**

Celem tych laboratoriów było przygotowanie i zarządzanie wersjami obrazów kontenerów w Dockerze oraz wdrażanie w środowisku Kubernetes. W trakcie zajęć skoncentrowałam się na aktualizowaniu, skalowaniu oraz przywracaniu poprzednich wersji aplikacji, a także na monitorowaniu wdrożeń przy użyciu różnych strategii, takich jak Recreate, Rolling Update czy Canary Deployment. Dodatkowo, zapoznałam się z automatyzacją procesów za pomocą skryptów.

### Przygotowanie nowego obrazu
- [x] **Zarejestruj nową wersję swojego obrazu `Deploy`**
- [x] **Upewnij się, że dostępne są dwie co najmniej wersje obrazu z wybranym programem**
- [x] **Będzie to wymagać**
  - **przejścia przez *pipeline* dwukrotnie**

Aby uzyskać nową wersję mojego obrazu skorzystałam z mojego gotowego pipeline w Jenkinsie. Odpaliłam go po raz drugi i uzyskałam dzięki temu na DockerHubie oczekiwany efekt:

![image](https://github.com/user-attachments/assets/76a4c835-a79e-4615-b84e-e2cc4d60331f)

### Zmiany w deploymencie
- [x] **Aktualizuj plik YAML z wdrożeniem i przeprowadzaj je ponownie po zastosowaniu następujących zmian:**
  - **zwiększenie replik np. do 8**
  - **zmniejszenie liczby replik do 1**
  - **zmniejszenie liczby replik do 0**
  - **ponowne przeskalowanie w górę do 4 replik (co najmniej)**
  - **Zastosowanie nowej wersji obrazu**
  - **Zastosowanie starszej wersji obrazu**
  - **Zastosowanie "wadliwego" obrazu**
- [x] **Przywracaj poprzednie wersje wdrożeń za pomocą poleceń**
  - **```kubectl rollout history```**
  - **```kubectl rollout undo```**
     
Aby wykonać tą cześć ćwiczenia korzystałam ze stworoznego przeze mnie pliku *redis-deploy.yaml*:

```bash
# redis-deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis-container
        image: kaoina666/redis_runtime:3 #zmiana z 2
        ports:
        - containerPort: 6379
```

W zarządzaniu zmianami pomagały komendy: 
`kubectl rollout undo deployment redis-app` - cofnięcie do poprzedniej wersji	
`kubectl rollout history deployment redis-app` - pokazuje historię rewizji przed rollbackiem, do śledzenia zmian

![image](https://github.com/user-attachments/assets/3042b1a6-7d24-4faf-ad43-87c4692813d9)

Jednym z zadań była kilkukrotna zmiana ilości replik naszej apliakcji. Aby zwiększyć bądź zmniejszyć ilość replik należało zmieniać parametr ` replicas: x` - w miejsce x wstawiałam odpowiednią ilość replik jaką należało uzyskać, a następnie aplikowałam zmiany przez `kubectl apply -f redis-deploy.yaml`. Ilość podów redis-app (ignorujmy te z 10 dni temu) sprawdzałam znanym dobrze `kubectl get pods`.

8 podów:
![image](https://github.com/user-attachments/assets/335fcbe6-0235-4b24-97cc-987596eaa8c1)

1 pod:
![image](https://github.com/user-attachments/assets/b4ed9eb1-5930-46b1-8311-677bee673a2f)

0 podów: 
![image](https://github.com/user-attachments/assets/58263ac8-a2ad-42ea-9540-38a9a2bd11f6)

4 pody:
![image](https://github.com/user-attachments/assets/9a2d24d6-2b1d-405c-871c-77bf2159d0d0)

Kolejnym z zadań była zmiana wersji naszego obrazu, wystarczyło podmienić tag z `2` na `3`. Efekty były dobrze zauważalne np w dashbordzie:

![image](https://github.com/user-attachments/assets/647f5fb4-d896-4cca-b971-847a8b97d35f)


Aby cofnąć spowrotem do wersji tagu `2` cofnęłam się poleceniem `kubectl rollout undo deployment redis-app`, i wszystko jakby cofnęło się w czasie, co odnotowałam w dashbordzie jak poniżej:
![image](https://github.com/user-attachments/assets/49b8f376-60ab-4230-ae18-1216fcc10d39)
![image](https://github.com/user-attachments/assets/82d014d4-aae5-4a92-902d-914b5e218e8c)

Kolejnym zadaniem była próba zastosowania wadliwego obrazu. w tym celu w pliku wdrożeniowym zamiast poprawnego tagu wybrałam taki który nie istnieje (w moim przypadku `:bad`).

![image](https://github.com/user-attachments/assets/424baf2b-763c-4bb9-84f9-575874681cac)

Jak widać odrazu po zmianie barw, wystąpiły błędy. Kubernetes spróbował wdrożyć nową wersję, ale rollout się nie powiódł. W takich przypadkach właśnie znowu przydaje się ‘kubectl rollout undo deployment redis-app’, dzięki czemu wszsytko spowrotem działa:

![image](https://github.com/user-attachments/assets/9e9d443c-aa92-449d-8639-d69c73abcf27)
![image](https://github.com/user-attachments/assets/0d63cd3e-c1b3-42ba-9413-b4f72d4555a7)



### Kontrola wdrożenia
- [x] **Zidentyfikuj historię wdrożenia i zapisane w niej problemy, skoreluj je z wykonywanymi czynnościami**

Poleceniem `kubectl describe deployment redis-app` mogłam przejrzeć historię wdrożenia.

![image](https://github.com/user-attachments/assets/909680fa-d735-49b1-ad54-9abefe9fa886)

Widać, że obecna wersja (:2) działa poprawnie, wszystkie 4 Pody są gotowe . Były również przynajmniej 3 różne zestawy replik (czyli zmieniany był obraz lub konfiguracja). W zakładce events widzimy jak wyglądały momenty skalowania np. z 3 → 8 → 0 → 4 

- [x] **Napisz skrypt weryfikujący, czy wdrożenie "zdążyło" się wdrożyć (60 sekund)**

Utworzyłam skrypt check_deploy.sh, który automatycznie weryfikuje, czy wdrożenie aplikacji redis-app w Kubernetesie zostało zakończone pomyślnie w określonym czasie (60 sekund). Skrypt monitoruje liczbę gotowych replik aplikacji, porównując ją z liczbą replik określoną w specyfikacji wdrożenia. Jeśli liczba dostępnych replik równa się liczbie replik pożądanych i jest różna od pustej wartości, skrypt informuje o sukcesie wdrożenia. Jeśli po upływie 60 sekund wdrożenie nadal nie jest gotowe, skrypt wypisuje komunikat o przekroczeniu czasu oczekiwania.

Przed uruchomieniem `./check_deploy.sh` nadałam prawa `chmod +x check_deploy.sh`.

``` bash
#!/bin/bash

DEPLOYMENT_NAME="redis-app"
NAMESPACE="default"
TIMEOUT=60

echo "Sprawdzam wdrożenie: $DEPLOYMENT_NAME (maksymalnie ${TIMEOUT}s)..."

for ((i=1;i<=TIMEOUT;i++)); do
  READY=$(minikube kubectl -- get deploy $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.readyReplicas}')
  DESIRED=$(minikube kubectl -- get deploy $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.replicas}')
  
  if [[ "$READY" == "$DESIRED" && "$READY" != "" ]]; then
    echo "✅ Wdrożenie zakończone sukcesem: $READY/$DESIRED replik gotowych."
    exit 0
  fi

  echo "⏳ [$i/$TIMEOUT] Czekam... ($READY/$DESIRED gotowych)"
  sleep 1
done

echo "❌ Timeout: wdrożenie nie zakończone w $TIMEOUT sekund."
exit 1
```

Działanie (W trakcie testu wdrożenie zakończyło się sukcesem w czasie poniżej 60 sekund.):

![image](https://github.com/user-attachments/assets/50c9e204-32ab-4a9d-9655-2c669be3a102)

 
### Strategie wdrożenia
- [x] **Przygotuj wersje wdrożeń stosujące następujące strategie wdrożeń**
  - **Recreate**
  - **Rolling Update (z parametrami `maxUnavailable` > 1, `maxSurge` > 20%)**
  - **Canary Deployment workload**
- [x] **Zaobserwuj i opisz różnice**
- [x] **Uzyj etykiet**

1. Recreate strategy - wyłącza wszystkie stare Pody, dopiero potem uruchamia nowe (na raz). W rollingUpdate stare pody są usuwane i zasępowane **stopniowo** Aby to sprawdzić najpierw uruchomiłam plik z wersją tagu 2, a następnie 3. Po zmianie wersji obrazu wszystkie stare Pody zostały usunięte i dopiero wtedy zostały utworzone nowe. W dashboardzie obserwujemy tylko Pody z nowym obrazem, co potwierdza, że wdrożenie było "czyste", bez równoległego działania starych i nowych instancji. Strategia Recreate powoduje chwilową niedostępność usługi, ale wdrożenie jest proste i szybkie.

Dla 2: 

![image](https://github.com/user-attachments/assets/495932e9-4dcb-4405-9212-28b8ee699780)

Dla 3:

![image](https://github.com/user-attachments/assets/c783f4d3-0a75-4f15-b976-6464d68dfa0b)


redis-recreate.yaml:
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-recreate
spec:
  replicas: 3
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: redis-recreate
  template:
    metadata:
      labels:
        app: redis-recreate
    spec:
      containers:
      - name: redis
        image: kaoina666/redis_runtime:3
        ports:
        - containerPort: 6379
```

2. RollingUpdate z parametrami (maxUnavailable: 2, maxSurge: 50%) - stopniowo podmienia Pody, z wyraźnymi ustawieniami, ile można mieć niedostępnych lub nadmiarowych jednocześnie

Uruchomienie:
![image](https://github.com/user-attachments/assets/4cfc2810-b9a5-4888-a72a-7206108f1d28)

Podczas zmiany wersji obrazu wszystkie Pody były podmieniane stopniowo. Obserwacja kubectl get pods -w oraz dashboardu potwierdziła, że żadne Pody nie były jednocześnie w stanie niedostępności (Unavailable = 0). Wdrożenie zakończyło się sukcesem, a aplikacja nie była niedostępna ani przez moment.

redis-rolling.yaml:
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-rolling
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 50%
  selector:
    matchLabels:
      app: redis-rolling
  template:
    metadata:
      labels:
        app: redis-rolling
    spec:
      containers:
      - name: redis
        image: kaoina666/redis_runtime:2
        ports:
        - containerPort: 6379
```

3. Canary Deployment - uruchamia 2 równoległe wersje aplikacji (np. 90% stabilna, 10% testowa)

W celu przetestowania stworzyam aż 3 pliki yaml:
redis-canary-stable.yaml
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-stable
spec:
  replicas: 3
  selector:
    matchLabels:
      app: redis
      version: stable
  template:
    metadata:
      labels:
        app: redis
        version: stable
    spec:
      containers:
      - name: redis
        image: kaoina666/redis_runtime:2
        ports:
        - containerPort: 6379
```


redis-canary-experimental.yaml
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
      version: canary
  template:
    metadata:
      labels:
        app: redis
        version: canary
    spec:
      containers:
      - name: redis
        image: kaoina666/redis_runtime:3
        ports:
        - containerPort: 6379

```

redis-service.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: redis-service
spec:
  selector:
    app: redis
  ports:
  - protocol: TCP
    port: 6379
    targetPort: 6379
```

Wdrożyłam Canary Deployment poprzez utworzenie dwóch niezależnych Deploymentów: redis-stable (obraz :2, 3 repliki) oraz redis-canary (obraz :3, 1 replika). Oba posiadają wspólną etykietę app=redis, co umożliwia połączenie ich pod wspólnym Service. Dzięki temu 75% ruchu trafia do stabilnej wersji, a 25% do wersji eksperymentalnej. Pozwala to na testowanie nowej wersji aplikacji w środowisku produkcyjnym z minimalnym ryzykiem.

Efekty:
![image](https://github.com/user-attachments/assets/82f23937-a17c-45bf-b1fa-30b93b3c3ddf)




