# Sprawozdanie 3
## Laboratorium 8 - Ansible

### 1. Instalacja zarządcy Ansible
Utworzenie drugiej maszyny wirtualnej z takim samym obrazem jak maszyna główna

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/1.0-druga-maszyna.png)

Utworzenie użytkownika `ansible`

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/1.1-ansible-user.png)

Zmiana nazwy maszyny

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/1.2-ansible-target.png)

Zainstalowanie `tar` i `OpenSSH`

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/1.3-tar-openssh.png)

Zrobienie migawki maszyny

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/1.4-migawka.png)

Zainstalowanie `ansible` na maszynie głównej poleceniem
```bash
sudo dnf install ansible
```

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/2.0-install-ansible.png)

Utworzenie kluczy ssh na maszynie głównej

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/3.0-keygen.png)

Sprawdzenie ip maszyny

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/3.1-target-ip.png)

Dodanie aliasu do `/etc/hosts`

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/3.2-alias.png)

Skopiowanie klucza

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/3.3-ssh-copy-id.png)

Dodanie polecenia używania konkretnego klucza

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/3.4-ssh-config.png)

Łączenie się po ssh bez konieczności podawania hasła

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/3.5-ssh.png)

### 2. Inwentaryzacja 

Zmiana nazwy maszyny

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/4.0-hostnamectl.png)

Dodanie klucza do kluczy zaufanych

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/5.0-cat-auth.png)

Dodanie aliasu głównej maszyny na drugiej maszynie

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/5.1-target-etc-hosts.png)

Sprawdzenie łączności wywoływania po nazwach

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/5.2-ping.png)

Utworzenie pliku inwentaryzacji 

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/6.1-inventory.png)

Wysłanie pinga do wszystkich maszyn

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/7.0-ansible-ping.png)

### Zdalne wywoływanie procedur

Utworzenie playbooka 

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/8.0-playbook.png)

Pierwsze uruchomienie playbooka

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/8.1-first-playbook-run.png)

Kolejne uruchomienie playbooka

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/8.2-second-playbook-run.png)

Przy pierwszym uruchomienie plik `inventory.ini` jeszcze nie istniał na `ansible-target` więc został skopiowany. Jednak przy kolejnym uruchomieniu ansible porównuje pliki, widzi że plik już jest na maszynie i nie musi nic robić - dlatego status `ok` 


Edycja playbooka w celu zaaktualizowania pakietów i zresetowania usług `sshd` i `rngd` 

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/9.1-playbook.png)

Zaaktualizowanie pakietów oraz restart usług jako root

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/9.2-playbook-run.png)

Operacje na maszynie z wyłączonym ssh

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/10.0-stop-ssh.png)

Po wyłączeniu ssh na maszynie `ansible-target` ansible nie był w stanie nawiązać połączenia, host został oznaczony jako `unreachable` a zadania dla niej nie zostały wykonane

### Zarządzanie stworzonym artefaktem

Utworzenie nowego pliku `playbook_deploy.yml`

```yml
- name: Instalacja i uruchomienie kontenera z Docker Huba
  hosts: Endpoints
  become: true
  gather_facts: yes

  vars:
    image_name: tygrysiatkomale/node-deploy
    image_tag: v3
    container_name: node_app
    port: 3000

  tasks:
    - name: Instalacja Dockera i docker-compose
      ansible.builtin.package:
        name:
          - docker
          - docker-compose
        state: present

    - name: Uruchomienie i włączenie usługi Docker
      ansible.builtin.service:
        name: docker
        state: started
        enabled: true

    - name: Pobranie obrazu z Docker Hub
      community.docker.docker_image:
        name: "{{ image_name }}"
        tag: "{{ image_tag }}"
        source: pull

    - name: Uruchomienie kontenera
      community.docker.docker_container:
        name: "{{ container_name }}"
        image: "{{ image_name }}:{{ image_tag }}"
        state: started
        restart_policy: always
        published_ports:
          - "{{ port }}:3000"

    - name: Weryfikacja działania aplikacji
      ansible.builtin.uri:
        url: "http://localhost:{{ port }}"
        return_content: yes
      register: response
      retries: 5
      delay: 3
      until: response.status == 200

    - name: Wyświetlenie odpowiedzi aplikacji
      debug:
        var: response.content

    - name: Zatrzymanie kontenera
      community.docker.docker_container:
        name: "{{ container_name }}"
        state: stopped

    - name: Usunięcie kontenera
      community.docker.docker_container:
        name: "{{ container_name }}"
        state: absent

```

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab8/11.0-deploy.png)



## Laboratorium 9 Pliki odpowiedzi dla wdrożeń nienadzorowanych

Skopiowanie i zmiana uprawnień pliku odpowiedzi

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab9/1.0-copy.png)

Edycja pliku `anaconda-ks.cfg` zgodnie z wymaganiami

```ini
#version=DEVEL
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64

lang en_US.UTF-8
keyboard --vckeymap=us --xlayouts='us'
timezone Europe/Warsaw --utc

# Sieć
network --bootproto=dhcp --hostname=ansible-autoinstall

# Partycjonowanie
clearpart --all --initlabel
autopart --type=lvm

# Użytkownicy
rootpw --lock
user --groups=wheel --name=jakswie --password=$y$j9T$Mr0XK7071huZ9auLoqF71tE5$cG7Z/uXHucp8Mmc9B2sTxvMo6Zl.iQumpbaaYlH3Rl5 --iscrypted --gecos="jakswie"

# Pakiety
%packages
@^server-product-environment
docker
wget
%end

# Konfiguracja po instalacji
%post
echo "=== Pobieram i uruchamiam kontener aplikacji ==="
systemctl enable docker

# Pobranie i uruchomienie kontenera po pierwszym uruchomieniu
cat > /etc/systemd/system/node-app.service <<EOF
[Unit]
Description=Start Node.js To-Do App
After=docker.service
Requires=docker.service

[Service]
ExecStart=/usr/bin/docker run --rm -p 3000:3000 tygrysiatkomale/node-deploy:v3
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable node-app
%end

# Autoreboot
reboot

```

Po umieszczeniu pliku kickstart w zdalnym repozytorium, na nowej maszynie wirtualnej — utworzonej na bazie tego samego obrazu ISO co maszyna bazowa — należy podczas uruchamiania instalatora przejść do edycji parametrów GRUB

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab9/1.1-grub.png)

Po zbootowaniu systemu kontener jest już uruchomiony

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab9/1.2-docker-ps.png)

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab9/1.3-curl.png)


## Laboratorium 10 - Wdrażanie na zarządzalne kontenery: Kubernetes

### Instalacja klastra Kubernetes

Instalacja minikube

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/1.0-minikube.png)

Dodanie aliasu do `.bashrc`

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/1.1-bashrc.png)

Uruchimienie Kubernetesa

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/2.0-minikube-start.png)

Sprawdzenie statusu

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/2.1-status.png)

W dokumentacji widać że `minikube` wymaga:

- RAM: min. 2 GB (zalecane 4+)
- CPU: min. 2 vCPU (zalecane 4+)
- Dysk: min. 20 GB

U mnie widać że mam 19GB a lokalny klaster Kubernetesa na domyślnych ustawieniach uruchomił się z CPUs=2 i Memory=2200MB

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/3.0-df-h.png)

Uruchomienie dashboardu

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/4.0-dashboard.png)

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/4.1-dashboard-web.png)

### Analiza posiadanego kontenera

```bash
docker run -p 3000:3000 tygrysiatkomale/node-deploy:v3
```

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/5.0-docker-run.png)

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/5.1-dummy.png)

### Uruchamianie oprogramowania

Uruchomienie kontenera aplikacji na stosie Kubernetesa

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/6.0-minikube-run.png)

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/6.1-web-pod.png)

Wyprowadzenie portu celem eksponowania funkcjonalności

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/7.0-port-forward.png)

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/7.1-web.png)

### Przekucie wdrożenia manualnego w plik wdrożenia

Plik wdrożenia

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: todo-deployment
  labels:
    app: todo-deployment
spec:
  replicas: 4
  selector:
    matchLabels:
      app: todo
  template:
    metadata:
      labels:
        app: todo
    spec:
      containers:
      - name: todo-containers
        image: tygrysiatkomale/node-deploy:v3
        ports:
          - containerPort: 3000
            protocol: TCP
```

Uruchomienie

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/8.0-deployment.png)

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/8.1-deployment-web.png)

Zbadanie stanu 

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/9.0-status.png)

Wyeksponowanie wdrożenia jako serwis

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/10.0-service.png)

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/10.1-service-web.png)

Przekierowanie portu do serwisu

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/11.0-forward.png)

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab10/11.1-forward-web.png)

## Laboratorium 11 - Wdrażanie na zarządzalne kontenery: Kubernetes

Wersje aplikacji

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab11/1.0-dockerhub.png)

Przygotowanie nowych obrazów:
 
- v3 - podstawowa wersja uzyskana na poprzednich laboratoriach
- v5 - wersja aplikacji z pokazaną wersją
- v6 - niedziałająca wersja w której w `Dockerfile.deploy` zmieniono `CMD ["npm", "start"]` na `CMD ["/bin/false"]`

![](/ITE/GCL07/JS415943/Sprawozdanie3/lab11/1.1-v5.png)