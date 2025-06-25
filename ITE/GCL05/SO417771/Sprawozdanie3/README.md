# Zajęcia 08

---

## Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

Celem laboratorium jest zautomatyzowanie obsługi środowiska wielomaszynowego za pomocą Ansible. W ramach zadania skonfigurowano przynajmniej dwie maszyny wirtualne z dostępem SSH bez hasła, stworzono inwentarz systemów oraz przygotowano playbooki do wykonywania podstawowych operacji administracyjnych, takich jak pingowanie maszyn, aktualizacja pakietów, zarządzanie kontenerami Docker czy przesyłanie i uruchamianie aplikacji. Wszystkie te operacje zostały zawarte w rolach Ansible, co pozwala na ich automatyczne i wielokrotne uruchamianie, eliminując potrzebę ręcznego zarządzania maszynami i procesami wdrożeniowymi.

## Instalacja zarządcy Ansible

***Utworzenie nowej maszyny wirtualnej***

W VirtualBox utworzono maszynę z minimalnym zestawem oprogramowania, korzystając z tego samego systemu operacyjnego, co wcześniej używana maszyna. Dodatkowo zainstalowano programy 'tar' i 'sshd', a także ustawiono hostname na 'ansible-target' oraz użytkownika na 'ansible'.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.3.png)

Instalacja programu tar i OpenSSH

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.2.png)

Dodatkowo wykonano migawkę maszyny oraz jej eksport.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.4.png)

***Instalacja Ansible***

Na głównej maszynie zainstalowano oprogramowanie Ansible.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.5.png)

Wymieniono klucze SSH pomiędzy użytkownikami na maszynach, aby logowanie przez ssh nie wymagało wpisywania hasła.

```sh
ssh-keygen -f ~/.ssh/id_rsa_ansible
```

Powyższa komenda na głównej maszynie generuje klucz ssh.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.6.png)

```sh
sudo nano /etc/hosts
```

Powyższa komenda otworzy plik hosts do którego zostanie dodany adres IP hosta ansible-target wraz z dopiskiem jego nazwy.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.7.png)

```sh
ssh-copy-id -i ~/.ssh/id_rsa_ansible.pub ansible@ansible-target
```

Powyższa komenda kopiuje klucz ssh na maszynę ansible-target. Podczas przesyłania klucza ssh wymagane jest podanie hasła.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.9.png)

```sh
ssh ansible@ansible-target
```

Powyższa komenda łączy się po ssh z maszyną ansible-target. Pokazuje to tym samym, że nastąpiła poprawna wymiana kluczy i podawanie hasła nie jest wymagane.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.10.png)

## Inwentaryzacja

Zmieniono nazwe maszyny

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.11.png)

Wprowadzono nazwy DNS maszyn stosując 'etc/hosts' na obu maszynach.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.7.png)

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.8.png)

Dzięki temu możliwe jest wywoływanie komputerów za pomocą nazw zamiast używania tylko adresów IP. Łączność została zweryfikowana poprzez wzajemne wykonanie polecenia 'ping'.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.12.png)

Stworzono plik inwentaryzacji 'inventory.yaml' z sekcjami 'Orchestrators' oraz 'Endpoints'

```sh
Orchestrators:
  hosts:
    fedora:
      ansible_user: twinkle
      ansible_connection: local

Endpoints:
  hosts:
    ansible-target:
      ansible_user: ansible
```

Wysłano żądanie 'ping' do wszystkich maszyn w celu przetestowania łączności.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.14.png)

## Zdalne wywołanie procedur

Utworzenie pliku playbook.yml

```sh
- name: Playbook
  hosts: all
  gather_facts: yes
  tasks:
    - name: Ping do wszystkich maszyn
      ansible.builtin.ping:

- name: Skopiuj plik inventory.yaml na Endpoints
  hosts: Endpoints
  gather_facts: yes
  tasks:
    - name: Skopiuj plik inwentaryzacji
      ansible.builtin.copy:
        src: ./inventory.yaml
        dest: /tmp/inventory.yaml
```

`name` -> definiuje nazwę operacji.

`hosts` -> określa, na jakich hostach operacja ma zostać wykonana.

`gather_facts` -> opcja, która umożliwia pobranie informacji o systemie (np. OS, RAM, CPU).

`task` -> sekcja, w której definiuje się konkretne zadanie do wykonania.

Pierwsze uruchomienie playbooka

```sh
ansible-playbook -i inventory.yaml playbook.yml
```

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.16.png)

Drugie uruchomienie playbooka

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.17.png)

Aktualizacja pakietów w systemie oraz restart usług

```sh
sudo dnf install rngd
```

Powyższa komenda została wykonana na maszynie ansible-target w celu zainstalowania narzędzia rngd.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.18.png)

```sh
- name: Playbook
  hosts: all
  gather_facts: yes
  tasks:
    - name: Ping do wszystkich maszyn
      ansible.builtin.ping:

- name: Skopiuj plik inventory.yaml na Endpoints
  hosts: Endpoints
  gather_facts: yes
  tasks:
    - name: Skopiuj plik inwentaryzacji
      ansible.builtin.copy:
        src: ./inventory.yaml
        dest: /tmp/inventory.yaml

- name: Aktualizacja systemu + restart usług
  hosts: Endpoints
  become: true
  tasks:
    - name: Aktualizacja pakietów
      ansible.builtin.package:
        name: "*"
        state: latest

    - name: Restart usługi sshd
      ansible.builtin.service:
        name: sshd
        state: restarted

    - name: Restart usługi rngd
      ansible.builtin.service:
        name: rngd
        state: restarted
```        

```sh
ansible-playbook -i inventory.yaml playbook.yml --ask-become-pass
```

Opcja --ask-become-pass spowoduje, że system poprosi o hasło roota. Po jego wprowadzeniu playbook zostanie uruchomiony. Playbook zakończył się pełnym powodzeniem.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.20.png)

Wykonanie operacji na maszynie, która ma wyłączony serwer SSH.

```sh
sudo systemctl stop sshd
```

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.21.png)

Ansible nie udało się nawiązać połączenia SSH. Host został oznaczony jako unreachable w sekcji PLAY RECAP, a zadania dla tej maszyny nie zostały wykonane.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.22.png)

```sh
sudo systemctl start sshd
```

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.23.png)

## Zarządzanie stworzonym artefaktem

Utworzenie szkieletu roli

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.24.png)

Komenda ta stworzy szkielet roli deploy-container w bieżącym katalogu. Po jej wykonaniu zostanie wygenerowana standardowa struktura katalogów i plików.

Najpierw dodano obraz do repozytorium na Docker Hub.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.25.png)

*Uruchomienie playbooka, który:*
1. Instaluje Dockera na maszynie,
2. Pobiera opublikowany obraz z Docker Hub,
3. Uruchamia kontener z pobranego obrazu,
4. Zatrzymuje kontener,
5. Usuwa kontener po zakończeniu.

```sh
---
- name: Deploy Docker container on endpoints
  hosts: Endpoints
  become: yes
  tasks:

    - name: Install Docker
      package:
        name: docker
        state: present

    - name: Ensure Docker service is running
      systemd:
        name: docker
        state: started
        enabled: yes


    - name: Pull the Docker image from Docker Hub
      docker_image:
        name: szyocie2/node-app
        source: pull


    - name: Run the Docker container
      docker_container:
        name: node-app
        image: szyocie2/node-app:latest
        state: started
        restart_policy: unless-stopped
        ports:
          - "3000:3000"


    - name: Wait for the container to be ready
      wait_for:
        host: localhost
        port: 3000
        delay: 5
        timeout: 30

    - name: Verify that the application is running
      uri:
        url: http://localhost:3000
        method: GET
        status_code: 200


    - name: Stop and remove the container
      docker_container:
        name: node-app
        state: absent
```

Uruchomienie playbooka

```sh
ansible-playbook -i inventory.yaml playbook_deploy.yml --ask-become-pass
```

Powyższa komenda uruchamia playbook. Opcja -i wskazuje plik inventory.yaml. Opcja --ask-become-pass spowoduje, że system poprosi o hasło roota.

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.26.png)

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.27.png)

Ponowne uruchomienie, ale tym razem playbooki są zgodne z architekturą ansible-galaxy

deploy-docker.yml

```sh
- name: Deploy Docker container on endpoints
  hosts: Endpoints
  become: yes
  vars:
    docker_image_name: "szyocie2/node-app"
    docker_image_tag: "latest"
    docker_container_name: "node-app"
    host_port: "3000"
    container_port: "3000"
  roles:
    - deploy-container
```

tasks/main.yml

```sh
---
- name: Install Docker
  package:
    name: docker
    state: present

- name: Ensure Docker service is running
  systemd:
    name: docker
    state: started
    enabled: yes

- name: Pull the Docker image from Docker Hub
  docker_image:
    name: "{{ docker_image_name }}"
    source: pull

- name: Run the Docker container
  docker_container:
    name: "{{ docker_container_name }}"
    image: "{{ docker_image_name }}:{{ docker_image_tag }}"
    state: started
    restart_policy: unless-stopped
    ports:
      - "{{ host_port }}:{{ container_port }}"

- name: Wait for the container to be ready
  wait_for:
    host: localhost
    port: "{{ container_port }}"
    delay: 5
    timeout: 30

- name: Verify that the application is running
  uri:
    url: http://localhost:{{ container_port }}
    method: GET
    status_code: 200

- name: Stop and remove the container
  docker_container:
    name: "{{ docker_container_name }}"
    state: absent
```

defaults/main.yml

```sh
defaults/main.yml:
docker_image_name: "szyocie2/node-app"
docker_image_tag: "latest"
docker_container_name: "node-app"
host_port: "3000"
container_port: "3000"
```

![Opis obrazka](../Sprawozdanie3/lab8/screenshots/lab8.28.png)


# Zajęcia 09

---

## Pliki odpowiedzi dla wdrożeń nienadzorowanych

Celem laboratorium było zdobycie praktycznych umiejętności w automatyzacji instalacji systemu operacyjnego przy pomocy plików Kickstart w systemie Fedora. Podczas zajęć opracowano i zmodyfikowano plik odpowiedzi, który umożliwia przeprowadzenie nienadzorowanej instalacji systemu, obejmując konfigurację użytkowników, repozytoriów, partycjonowania dysku oraz automatyczne uruchomienie kontenera Docker. Laboratorium pozwoliło na zdobycie doświadczenia w tworzeniu i modyfikowaniu plików Kickstart, dodawaniu nowych funkcjonalności oraz testowaniu instalacji z różnych źródeł, zarówno lokalnych, jak i zdalnych.

Skopiowanie pliku odpowiedzi na głownej maszynie oraz Nadanie uprawnień do odczytu pliku odpowiedzi - `sudo chmod +777 anaconda-ks.cfg`

![Opis obrazka](../Sprawozdanie3/lab9/lab9.1.png)

Edycja pliku odpowiedzi:

1. Dodanie wymaganych repozytoriów. Pierwsze repozytorium to główne repozytorium Fedory 41, które zawiera pakiety podstawowe. Drugie repozytorium to repozytorium aktualizacji, które oferuje najnowsze poprawki bezpieczeństwa oraz poprawki błędów dla Fedory 41.

```sh
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64
```

2. Założenie czystego dysku i formatowanie go w całości:
– `--all`: usuwa wszystkie istniejące partycje na wszystkich dyskach.
– `--initlabel`: tworzy nową etykietę dysku.

```sh
clearpart --all --initlabel
```

3. Ustawienie `hostname`

```sh
network --hostname=fedora3
```

4. Cały plik `anaconda-ks.cfg` po modyfikacjach:

```sh
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

# Network information
network --hostname=fedora3

url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

%packages
@^custom-environment

%end

# Run the Setup Agent on first boot
firstboot --enable

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
autopart
# Partition clearing information
clearpart --all --initlabel

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --iscrypted --allow-ssh $y$j9T$oNEvQnjmOFvMploCGg5QT6nn$q0hte1P56IoqbH6M/PFXp1MISfqHTwXXmCjY7NGSdl0
user --groups=wheel --name=twinkle --password=$y$j9T$oPCXPgnqH9SVzdLxXnDxGzyb$/5EdMRBjFYL17FVU.KwmDs8vDHfgjeoLGEnNuviDah3 --iscrypted --gecos="twinkle"
```

## Przeprowadzenie instalacji

Po wrzuceniu pliku odpowiedzi na swoją gałąź w repozytorium przedmiotowym, uruchomiono nową maszynę wirtualną z płyty ISO. Następnie, po naciśnięciu klawisza 'e' na ekranie GRUB, dokonano wpisu, który wskazuje na użycie pliku 'kickstart'.

![Opis obrazka](../Sprawozdanie3/lab9/lab9.2.png)

Przebieg instalacji:

![Opis obrazka](../Sprawozdanie3/lab9/lab9.3.png)

![Opis obrazka](../Sprawozdanie3/lab9/lab9.4.png)

Instalacja przebiegła poprawnie:

![Opis obrazka](../Sprawozdanie3/lab9/lab9.5.png)

## Rozszerzenie pliku odpowiedzi

1. Pakiety:

- Została dodana sekcja pakietów, w której poza grupą `custom-environment` dodano pakiety: `wget`, `curl` i `docker`.

```sh
%packages
@^custom-environment
wget
curl
docker
%end
```

2. Skrypty po instalacji (post-installation actions):

Wykonuje skrypty po instalacji:

- Ustawia i uruchamia Docker (`systemctl enable docker` oraz `systemctl start docker`).

- Dodaje użytkownika `szyocie2` do grupy `docker`.

- Pobiera kontener Node.js i uruchamia go jako usługę systemd (`node-app.service`).

- Otwiera port 3000 w zaporze i restartuje zaporę (`firewall-cmd --add-port=3000/tcp`).

```sh
%post --log=/root/post-install.log --interpreter=/bin/bash
echo "==> Setting up Docker..."
systemctl enable docker
systemctl start docker
usermod -aG docker szyocie2

echo "==> Deploying Node.js container..."
docker pull szyocie2/node-app:latest

cat <<EOF > /etc/systemd/system/node-app.service
[Unit]
Description=Node.js Application Container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --rm -p 3000:3000 --name node-app szyocie2/node-app:latest
ExecStop=/usr/bin/docker stop node-app

[Install]
WantedBy=multi-user.target
EOF

systemctl enable node-app.service
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload

echo "==> Node.js app deployment complete."
%end
```

3. Reboot:

- Po zakończeniu instalacji systemu, komputer zostanie zrestartowany.

4. Cały plik `anaconda-ks2.cfg` po rozszerzeniach:

```sh
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=pl --xlayouts='pl'
# System language
lang pl_PL.UTF-8

# Disk configuration
ignoredisk --only-use=sda
autopart
clearpart --all --initlabel

# System timezone
timezone Europe/Warsaw --utc

# Network information
network --hostname=fedora3

# Repositories
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

# Users
rootpw --iscrypted --allow-ssh $y$j9T$oNEvQnjmOFvMploCGg5QT6nn$q0hte1P56IoqbH6M/PFXp1MISfqHTwXXmCjY7NGSdl0
user --groups=wheel --name=twinkle --password=$y$j9T$oPCXPgnqH9SVzdLxXnDxGzyb$/5EdMRBjFYL17FVU.KwmDs8vDHfgjeoLGEnNuviDah3 --iscrypted --gecos="twinkle"

%packages
@^custom-environment
wget
curl
docker

%end

# Run the Setup Agent on first boot
firstboot --enable

%post --log=/root/post-install.log --interpreter=/bin/bash

echo "==> Setting up Docker..."
systemctl enable docker
systemctl start docker
usermod -aG docker szyocie2

echo "==> Deploying Node.js container..."
docker pull szyocie2/node-app:latest

cat <<EOF > /etc/systemd/system/node-app.service
[Unit]
Description=Node.js Application Container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --rm -p 3000:3000 --name node-app szyocie2/node-app:latest
ExecStop=/usr/bin/docker stop node-app

[Install]
WantedBy=multi-user.target
EOF

systemctl enable node-app.service
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload

echo "==> Node.js app deployment complete."
%end

reboot
```

![Opis obrazka](../Sprawozdanie3/lab9/lab9.6.png)

Weryfikacja działania:

![Opis obrazka](../Sprawozdanie3/lab9/lab9.7.png)


# Zajęcia 10

---

## Wdrażanie na zarządzalne kontenery: Kubernetes (1)

Celem laboratorium było zdobycie praktycznych umiejętności w zakresie wdrażania aplikacji na Kubernetesie przy użyciu Minikube. Podczas ćwiczeń zainstalowano i skonfigurowano lokalny klaster, przygotowano plik konfiguracyjny do wdrożenia, uruchomiono aplikację w kontenerach oraz przeprowadzono ekspozycję usług i testowanie komunikacji z aplikacją. Laboratorium umożliwiło nabycie doświadczenia w zarządzaniu zasobami Kubernetes oraz automatyzacji procesu wdrażania aplikacji kontenerowych.

Instalacja minikube

```sh
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm
```

Powyższe komendy instalują Minikube na systemie opartym na RPM.

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.1.png)

Uruchomienie Kubernesta

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.2.png)

Utworzenie aliasa oraz wyświetlenie listy wszystkich węzłów w klastrze Kubernetesa.

```sh
alias minikubectl='minikube kubectl --'
minikubectl get nodes
```

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.3.png)

Wyświetlenie stanu lokalnego klastra Kubernetesa uruchomionego przez Minikube.

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.4.png)

```sh
df -h
```

Powyższe polecenie wyświetli dostępne miejsce na dysku. W moim przypadku wynosi ono około 26 GB, co oznacza, że wymaganie dotyczące wolnego miejsca na dysku zostało spełnione.

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.5.png)

Uruchomienie Dashboard

```sh
minikube dashboard --url
```

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.6.png)

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.8.png)

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.7.png)

Na tej stronie zapoznano się z funkcjalnościami Kubernetesa.

## Analiza posiadanego kontenera

Wybrałem aplikację 'node-js-dummy-test', nad którą pracuję od początku zajęć. Uruchomiono aplikacje w konenerze:

```sh
docker run --name node-app -p 3000:3000 -dit szyocie2/node-app:latest
```

Powyższa komenda uruchomi kontener o nazwie `node-app` na bazie obrazu `szyocie2/node-app:latest` oraz przekieruje port 3000 kontenera na port 3000 maszyny wirtualnej.

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.9.png)

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.10.png)

## Uruchomienie oprogramowania

Uruchomienie aplikacji w kontenerze na stosie Kubernetesa

```sh
minikubectl run node-app-pod --image=szyocie2/node-app:latest --port=3000 --labels app=node-app-pod
```

oraz przedstawienie działania poda

```sh
minikubectl get pods
```

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.11.png)

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.12.png)

Wyprowadzenie portu celem eksponowania funkcjonalności

```sh
minikubectl port-forward pod/node-app-pod 3000:3000
```

Powyższa komenda eksportuje port `3000` poda na lokalnym porcie `3000`.

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.10.png)

## Przekucie wdrożenia manualnego w plik wdrożenia

`deploy.yaml`

```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-deployment
  labels:
    app: node
    environment: production

spec:
  replicas: 4
  selector:
    matchLabels:
      app: node-app
  template:
    metadata:
      labels:
        app: node-app
    spec:
      restartPolicy: Always
      containers:
      - name: node-app-container
        image: szyocie2/node-app:latest
        ports:
          - containerPort: 3000
            protocol: TCP
        env:
          - name: NODE_ENV
            value: "production"
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"

```

Plik YAML tworzy Deployment w Kubernetesie, który uruchamia 4 repliki kontenerów aplikacji Node.js. Kontenery korzystają z obrazu `szyocie2/node-app:latest`, nasłuchują na porcie `3000`, ustawiają zmienną środowiskową `NODE_ENV` na production, oraz mają określone limity i wymagania zasobów (64Mi RAM, 250m CPU dla requests, 128Mi RAM, 500m CPU dla limits). Kontenery będą zawsze restartowane w razie awarii.

Uruchomienie

```sh
minikubectl apply -f deploy.yaml
```

Powyższa komenda wdraża zasoby zdefiniowane w pliku deploy.yaml do klastra Kubernetes.

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.13.png)

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.14.png)

Zbadanie stanu:

```sh
minikubectl rollout status deployment/node-deployment
```

Wyeksponowanie wdrożenia jako serwis:

```sh
minikubectl expose deployment node-deployment --type=NodePort --port=3000
```

Powyższa komenda tworzy usługę w Kubernetes, która udostępnia Deployment na zewnątrz klastra przez port `3000`. Użycie opcji `--type=NodePort` pozwala na dostęp do aplikacji spoza klastra za pośrednictwem portu węzła.

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.15.png)

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.16.png)

Przekierowanie portu do serwisu:

```sh
minikubectl port-forward service/node-deployment 8080:3000
```

Komenda ta eksportuje port serwisu `3000` na lokalnym porcie `8080`.

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.17.png)

![Opis obrazka](../Sprawozdanie3/lab10/screenshots/lab10.18.png)


# Zajęcia 11

---

## Wdrażanie na zarządzalne kontenery: Kubernetes (2)

Celem laboratorium było zapoznanie się z zaawansowanymi technikami wdrażania aplikacji w środowisku Kubernetes. Podczas zajęć tworzono różne wersje obrazów aplikacji, realizowano aktualizacje i rollbacki, testowano różne strategie aktualizacji (Recreate, Rolling Update, Canary Deployment) oraz automatyzowano procesy sprawdzania poprawności wdrożenia. Laboratorium umożliwiło zdobycie praktycznych umiejętności w zakresie zarządzania cyklem życia aplikacji kontenerowych i rozwiązywania problemów podczas wdrożeń.

## Przygotowanie nowego obrazu

Do zadania wykorzystuję trzy wersje obrazów:

- :latest - obraz aplikacji pochodzący z pipeline Jenkins
- :v2.0 - drugi poprawny obraz
- :v3.0 - wadaliwy obraz (w polu command ustawiono wartość ["/bin/false"])

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.1.png)

## Zmiany w deploymencie

1. Zwiększenie replik do 8

Zrealizowano to poprzez zmianę wartości parametru `replicas` w pliku `deploy.yaml` z 4 na 8. Następnie wykonano poniższe polecenie, które wdraża zasoby określone w pliku `deploy.yaml` do klastra Kubernetes, w naszym przypadku dokonując aktualizacji o dodatkowe 4 repliki.

```sh
minikubectl apply -f deploy.yaml
```

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.2.png)

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.3.png)

2. Zmniejszenie replik do 1

Zrealizowano to poprzez zmianę wartości parametru `replicas` w pliku `deploy.yaml` z 8 na 1. Następnie wykonano poniższe polecenie, które wdraża zasoby określone w pliku `deploy.yaml` do klastra Kubernetes, w naszym przypadku dokonując downgrade'u zasobów do jednej repliki.

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.4.png)

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.5.png)

3. Zmniejszenie replik do 0

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.6.png)

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.7.png)

4. Zwiększenie replik do 4

Zrealizowano to poprzez zmianę wartości parametru `replicas` w pliku `deploy.yaml` z 0 na 4. Następnie wykonano poniższe polecenie, które wdraża zasoby określone w pliku `deploy.yaml` do klastra Kubernetes, w naszym przypadku dokonując aktualizacji zasobów o dodatkowe 4 repliki.

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.8.png)

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.9.png)

5. Zastosowanie nowej wersji

Zmiana parametru image w pliku `deploy.yaml` z `szyocie2/node-app:latest` na `szyocie/node-app:v2.0` spowodowała wdrożenie nowych zasobów do klastra Kubernetes. Dzięki strategii `rolling update` nowe Pody są uruchamiane przed usunięciem starych, co zapewnia ciągłość działania aplikacji.

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.10.png)

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.11.png)

6. Zastosowanie starszej wersji

Zmiana parametru image w pliku `deploy.yaml` z `szyocie2/node-app:v2.0` na `szyocie2/node-app:latest` spowodowała wdrożenie nowych zasobów do klastra Kubernetes. Podczas zmiany obrazu na starszy Kubernetes traktuje to jako nowe wdrożenie, tworząc nowe Pody przed usunięciem starych, aby zachować ciągłość działania, zgodnie z strategią `rolling update`.

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.12.png)

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.13.png)

7. Zastosowanie "wadliwego" obrazu

Zmiana parametru image w pliku `deploy.yaml` z `szyocie2/node-app:latest` na `szyocie2/node-app:v3.0` spowodowała wdrożenie wadliwego obrazu. Kubernetes uruchamia nowe Pody zgodnie ze strategią `rolling update`, ale ponieważ nowe kontenery kończą działanie z błędem, przechodzą w stan `CrashLoopBackOff`, a stare Pody są usuwane dopiero po uznaniu nowych za gotowe, co w tym przypadku nigdy nie następuje.

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.14.png)

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.15.png)

**Przywrócenie poprzedniej wersji za pomocą poleceń**

```sh
minikubectl rollout history deployment/node-deployment
```

```sh
minikubectl rollout undo deployment/node-deployment
```

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.16.png)

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.17.png)

## Kontrola wdrożenia

```sh
minikubectl rollout history deployment/node-deployment --revision=4
```

Powyższa komenda wyświetla szczegóły konkretnej wersji rewizji. Z analizy danych wynika, że rewizja 4 działała na wadliwym obrazie `szyocie/node-app:v3.0`

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.18.png)

```sh
minikubectl describe deployment node-deployment
```

Powyższa komenda wyświetli szczegółowe informacje na temat obecnie działającego wdrożenia.

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.19.png)

Napisano skrypt `check.sh`, który sprawdza czy wdrożenie wykonało się w 60 sekund.

```sh
#!/bin/bash

TARGET_DEPLOY="node-deployment"
NS="default"
MAX_WAIT=60
CHECK_INTERVAL=5
ELAPSED_TIME=0

echo "Checking status of deployment: $TARGET_DEPLOY"


while [ $ELAPSED_TIME -lt $MAX_WAIT ]; do
    if minikube kubectl -- rollout status deployment/$TARGET_DEPLOY --namespace $NS --timeout=5s > /dev/null 2>&1; then
        echo "Deployment successful after ${ELAPSED_TIME}s"
        exit 0
    fi

    sleep $CHECK_INTERVAL
    ELAPSED_TIME=$((ELAPSED_TIME + CHECK_INTERVAL))
    echo "Retrying in ${CHECK_INTERVAL}s..."
done

echo "Timeout reached after $MAX_WAIT seconds"
exit 1
```

```sh
chmod +x check-deploy.sh
```

Dzięki tej komendzie nadane zostały uprawnienia do uruchomienia skryptu.

Sprawdzenie działania skryptu:

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.20.png)

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.21.png)

## Strategie wdrożenia

1. *Recreate*

Strategia `Recreate` polega na usunięciu wszystkich starych Podów przed uruchomieniem nowych. Ustawienia tej strategii wprowadzono, dodając do pliku `deploy.yaml` polecenie `type: Recreate`.

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.22.png)

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.23.png)

2. *Rolling Update z parametrami*

Strategia `RollingUpdate` pozwala na stopniową aktualizację Podów, uruchamiając nowe przed usunięciem starych. Ustawiono `maxUnavailable: 2` (maksymalnie 2 niedostępne Pody) oraz `maxSurge: 25%` (dodatkowe Pody do 25% replicas). Konfigurację dodano w pliku `deploy.yaml` w sekcji strategy jako type: `RollingUpdate`.

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.24.png)

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.25.png)

3. *Canary Deployment*

Stworzono dwa pliki wdrożenia — `canary1.yaml` (nowa wersja) i `canary2.yaml` (stara wersja). Strategia `Canary Deployment` wprowadza nową wersję obok stabilnej w ograniczonej liczbie replik. Obie wersje mają różne etykiety `version` (canary i stable) oraz wspólną etykietę `role: node-app`, co umożliwia obsługę przez jeden serwis `node-service.yaml`, kierujący ruch proporcjonalnie do liczby replik.

`canary1.yaml`

```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-app-canary
  labels:
    role: node-app
    stage: canary
spec:
  replicas: 1
  selector:
    matchLabels:
      role: node-app
      stage: canary
  template:
    metadata:
      labels:
        role: node-app
        stage: canary
    spec:
      containers:
        - name: node-app-container
          image: szyocie2/node-app:latest
          ports:
            - containerPort: 3000
```

Wdrożenie nowej wersji aplikacji (canary) tworzy jeden pod z obrazem `szyocie2/node-app:latest`, oznaczony etykietami `role: node-app` i stage: canary. Takie podejście pozwala na wprowadzenie zmian na małej liczbie replik, minimalizując ryzyko i umożliwiając równoległe testowanie nowej wersji ze stabilną.

`canary2.yaml`

```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-app-production
  labels:
    role: node-app
    stage: stable
spec:
  replicas: 3
  selector:
    matchLabels:
      role: node-app
      stage: stable
  template:
    metadata:
      labels:
        role: node-app
        stage: stable
    spec:
      containers:
        - name: node-app-container
          image: szyocie2/node-app:v2.0
          ports:
            - containerPort: 3000
```

Ten manifest definiuje stabilne wdrożenie aplikacji, uruchamiając trzy repliki kontenera z obrazem `szyocie2/node-app:v2.0`. Pody mają etykiety `role: node-app` i stage: stable, co umożliwia łatwe rozróżnienie wersji. Stabilna wersja obsługuje większość ruchu, zapewniając ciągłość działania.

`node-service.yaml`

```sh
apiVersion: v1
kind: Service
metadata:
  name: node-app-service
spec:
  selector:
    role: node-app
  ports:
    - port: 80
      targetPort: 3000
  type: ClusterIP
```

Definicja usługi w Kubernetes, która łączy się z podami oznaczonymi etykietą `role: node-app`. Serwis nasłuchuje na porcie `80` i przekierowuje ruch na port `3000` w podach. Typ `ClusterIP` oznacza, że usługa jest dostępna tylko wewnątrz klastra, umożliwiając komunikację między komponentami.

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.26.png)

![Opis obrazka](../Sprawozdanie3/lab11/screenshots/lab11.27.png)
