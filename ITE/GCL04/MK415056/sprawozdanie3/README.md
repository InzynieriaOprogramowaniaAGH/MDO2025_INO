#Sprawozdanie 3

## Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

### Instalacja zarządcy Ansible
Utworzenie nowej maszyny wirtualnej nazwanej `ansible-target` (w Hyper-V) oraz hostname `ansible-target`
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/a0.png)

Instalacja programu `Ansible` na maszynie hoście:
```
sudo dnf install ansible -y
```
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/a1.png)


Wymiana kluczy SSH między użytkownikiem na głównej maszynie a użytkownikiem ansible, w celu wyeliminowania konieczności podawania hasła podczas logowania przez SSH. Ponieważ klucz publiczny został już utworzony wcześniej, przeprowadzono wymianę kluczy za pomocą odpowiedniego polecenia. Powstał jednak problem, gdyż system nie rozpoznawał domyślnej lokalizacji pliku z kluczem SSH. W związku z tym konieczne okazało się ręczne wskazanie ścieżki do pliku z kluczem w parametrze komendy służącej do wymiany kluczy.
```
ssh-copy-id -i ~/GitHub/sshklucz.txt.pub ansible@ansible-target
```
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/a2.png)

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/a3.png)
### Inwentaryzacja

Sprawdzenie połączenia pomiędzy maszynami za pomocą polecenia `ping`:
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/a4.png)
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/a5.png)

Ustawienie nazw dla maszyn wirtualnych:
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/a6.png)

Utworzenie pliku inwentaryzacji zawierającego sekcje Orchestrators (maszyny zarządzające innymi) oraz Endpoints (maszyny docelowe). Dodano w odpowiednich sekcjach nazwy maszyn, ich adresy IP oraz nazwy użytkowników:
```
[Orchestrators]
[Endpoints]
ansible-target ansible_host=172.18.249.141 ansible_user=ansible-user
```
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/a7.png)


### Zdalne wywoływanie procedur
Utworzenie `playbooka`
```
- hosts: all
  become: yes
  tasks:
    - name: Ping machines
      ansible.builtin.ping:

    - name: Copy inventory file
      ansible.builtin.copy:
        src: ./inventory.ini
        dest: /tmp/inventory.ini

    - name: Update all packages
      ansible.builtin.dnf:
        name: '*'
        state: latest
        update_cache: yes

    - name: Restart sshd and rngd
      ansible.builtin.systemd:
        name: "{{ item }}"
        state: restarted
      loop:
        - sshd
        - rngd
```

Wykonanie komendy `ansible-playbook` wymagało opcji `--ask-become-pass` proszącej o hasło roota, by przeprowadzić niektóre z operacji.

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/a9.png)

Wyłączenie serwera `ssh`:
```
sudo systemctl stop sshd
```
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/a11.png)
### Zarządzanie stworzonym artefaktem
Zadanie wymagało zbudowania i uruchomienia kontenera z opublikowanego na Docker Hubie obrazu (będącego artefaktem z poprzedniego pipeline'u) oraz połączenia się z nim, wykorzystując do tego playbook Ansible.

Playbook:
```
---
- hosts: Endpoints
  become: yes
  tasks:
    - name: Install required system packages
      ansible.builtin.dnf:
        name:
          - python3-packaging
          - python3-pip
          - docker
          - redis
        state: present
        update_cache: yes

    - name: Install Python 'requests'
      ansible.builtin.pip:
        name: requests
        executable: pip3

    - name: Start and enable Docker service
      ansible.builtin.service:
        name: docker
        state: started
        enabled: yes

    - name: Download Docker image from DockerHub
      ansible.builtin.docker_image:
        name: marekkubi/pipeline-redis:latest
        source: pull

    - name: Run Docker container
      ansible.builtin.docker_container:
        name: pipeline-redis
        image: marekkubi/pipeline-redis:latest
        state: started
        ports:
          - "6379:6379"

    - name: Wait for the container to be ready
      ansible.builtin.wait_for:
        host: "ansible-target"
        port: 6379
        state: started
        delay: 10
        timeout: 60
        msg: "Redis is not available on port 6379"

    - name: Test connection to container
      command: redis-cli -h ansible-target -p 6379 ping
      register: redis_ping

    - name: Show Redis response
      debug:
        msg: "{{ redis_ping.stdout }}"

    - name: Stop and remove Docker container
      ansible.builtin.docker_container:
        name: pipeline-redis
        state: absent
        force_kill: yes
```

Playbook obejmuje instalację niezbędnych narzędzi (m.in. Redis), pobranie opublikowanego obrazu Dockerowego, uruchomienie kontenera, przetestowanie połączenia z zewnątrz, a na końcu – zatrzymanie i usunięcie kontenera.

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/a12.png)

Utworzenie nowej roli do zarządzania stworzonym kontenerem:
```
ansible-galaxy init deploy_container
```

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/a13.png)

Konfiguracja roli polegała na skopiowaniu zawartości [playbooka 2](./playbook2.yaml) do deploy_container/tasks/[main.yml](./deploy_container/tasks/main.yml). Część zmiennych została zastąpiona symbolicznymi nazwami zdefiniowanymi w deploy_container/defaults/[main.yml](./deploy_container/defaults/main.yml). Utworzono `play` korzystający z nowej roli.

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/a14.png)


## Pliki odpowiedzi dla wdrożeń nienadzorowanych

Plik konfiguracyjny skopiowany z `/root/anaconda-ks.cfg`, formatuje całość swojego dysku, nazwa hosta jest ustawiona na `marekkubicki` oraz zawiera odnośniki do potrzebnych repozytoriów:
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/b1.png)

Wskazanie zdalnego pliku odpowiedzi w instalacji poprzez parametr `inst.ks=[adres URL do pliku Kickstart]` urzywając tinyurl.com

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/bt.png)

Zmodyfikowane parametry jądra:
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/af6fb38e24b54497e8247ba5115f116f75f352b1/ITE/GCL04/MK415056/sprawozdanie3/screanshots/b2.png)

Instalacja systemu:
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/b3.png)

Uruchomienie maszyny z pierwotnymi ustawieniami, niestety instalacja nie powiodła się. Z jakiegoś powodu niepoprawnie zaintaloawana została starsza wersja Fedory, która nie pozwalała na zalogowanie. Wykorzystany został ten sam plik .iso z wersją 41 co przy instalacji pierwszej maszyny jak i maszyny wykorzystywanej wcześniej do ansible:
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/3260a5f3cced966ea2995fe9f091a989f1aa4d4e/ITE/GCL04/MK415056/sprawozdanie3/screanshots/ups.png)

postanowiłem spróbować zaintalować maszynę z nowymi ustawieniami w pliku kikstartowym
[anaconda-ks-2](./anaconda-ks-new.cfg):
```
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

keyboard --vckeymap=pl --xlayouts='us'
lang pl_PL.UTF-8

network --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate
network --hostname=MSI

# Run the Setup Agent on first boot
firstboot --enable

url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
autopart

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --iscrypted --allow-ssh $y$j9T$Yi7lsex38AjxWT.W0XaJ6MnA$dUgiKpYzexSA3EgqEp9vO/PUVbn6bmx1Q80aB49ZEl3
user --groups=wheel --name=markubi --password=$y$j9T$Yi7lsex38AjxWT.W0XaJ6MnA$dUgiKpYzexSA3EgqEp9vO/PUVbn6bmx1Q80aB49ZEl3 --iscrypted --gecos="MarekKubicki"

%packages
@^server-product-environment
docker
wget
%end

%post --log=/root/ks-post.log --interpreter=/bin/bash

systemctl enable docker

cat << 'EOF' > /usr/local/bin/start-redis-app.sh
#!/bin/bash
until systemctl is-active --quiet docker; do
  sleep 1
done
if ! docker ps -a --format '{{.Names}}' | grep -q '^redis-app$'; then
  docker run -d --name redis-app -p 6379:6379 marekkubi/redis-app
fi
EOF

chmod +x /usr/local/bin/start-redis-app.sh

echo "[Unit]
Description=Start Redis container
After=network-online.target docker.service
Requires=docker.service

[Service]
ExecStart=/usr/local/bin/start-redis-app.sh
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/redis-container.service

systemctl enable redis-container.service

%end

reboot
```
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/b4.png)

## Kubernetes

### Instalacja klastra Kubernetes

Prace z Kubernetesem najlepiej jest wykonywać za pośrenitwem VS Code. VS Code potrafi automatycznie forwardować porty, których używa minikube.

Instalacja `minikube` jako paczka RPM dzięki komendom (pobranie oraz instalacja):
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm
```

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/1.png)

Alias dla kubectl, należy powtarzać przy ponownym uruchomieniu konsoli:
```
alias kubectl="minikube kubectl --"
```

Uruchomienie Kubernetesa
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k3.png)
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k4.png)

Uruchomienie Kubernetes dashboard

```
minikube dashboard
```

Wyświetlenie dashboardu w oknie przeglądarki
![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k5.png)


### Analiza posiadanego kontenera

Sprawdzenie działanie obrazu programu `Redis` publikowanego na `DockerHub`

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k6.png)

### Uruchamianie oprogramowania

Uruchomienie programu `Redis` i wykazanie działanie poprzez polecenie `kubectl get pods`:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k7.png)

Alternatywnie na Dashboard

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k8.png)

Przekierowanie portu

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k10.png)

Potwierdzenie połączenia przez `redis-cli`:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k9.png)

### Przekucie wdrożenia manualnego w plik wdrożenia

Przygotowanie pliku wdrożenia `redis-deplyment.yaml`:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pipeline-redis
spec:
  replicas: 4
  selector:
    matchLabels:
      app: pipeline-redis
  template:
    metadata:
      labels:
        app: pipeline-redis
    spec:
      containers:
        - name: redis-container
          image: marekkubi/pipeline-redis
          ports:
            - containerPort: 6379
```

Zwiększenie liczby replik w Deployment do 4 poprawia odporność aplikacji na awarie, zapewniając ciągłość działania. Dodatkowo umożliwia skalowanie i równoważenie obciążenia, rozkładając ruch użytkowników między wiele podów i zapobiegając przeciążeniu pojedynczych instancji.

Nowy deployment:

Sprawdzenie stanu (zakończony sukcesem)

Eksportowanie portu, by program działał z zewnątrz

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k11.png)

Przekierowanie portu do serwisu

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k13.png)

Sprawdzenie działania poprzez polecenie `ping`:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k12.png)

Utworzony Deployment w Dashboardzie (Workload Status, Deployments oraz Pods):

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k14.png)

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k15.png)

### Przygotowanie nowego obrazu

Niedziałający `redis`:
```
FROM redis
ENTRYPOINT ["false"]
```

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k16.png)

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k17.png)

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k18.png)

### Zmiany w deploymencie

Wprowadzanie zmian w deploymencie poprzez Dashboard

Zwiększenie liczby do 8:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k19.png)

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k20.png)
Pewien czas na dodanie replik

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k21.png)

Zmniejszenie do 1:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k23.png)

Zmniejszenie do 0:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k22.png)

Zwiększenie do 4:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k29.png)

Nowy obraz w podzie:
```
      containers:
        - name: redis-container
          image: marekkubi/redis-app:v1.0.20
          ports:
```

Historia deploymentu i Wadliwy deplyoment:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k24.png)

Błąd deploymentu:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k28.png)

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k26.png)

Przywrócenie poprzedniej działającej wersji komendą:
```
kubectl rollout undo deployment/redis-app
```

Działanie podów na starej wersji:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k27.png)


### Kontrola wdrożenia

Informacje o konkretnym wdrożeniu:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k30.png)

Skrypt weryfikujący czas wdrażania, uruchamiany zaraz po `kubectl apply`:
```
#!/bin/bash

DEPLOY_NAME=$1
TIMEOUT=60

echo "Waiting for deployment $DEPLOY_NAME to be ready..."
minikube kubectl -- wait --for=condition=available --timeout=${TIMEOUT}s deployment/${DEPLOY_NAME}
if [ $? -ne 0 ]; then
    echo "Deployment $DEPLOY_NAME did not become available within ${TIMEOUT} seconds."
    exit 1
fi
echo "Deployment $DEPLOY_NAME is now available."
```

Sprawdzenie czasu wdrażania:

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k32.png)


### Strategie wdrożenia

Recreate
Strategia Recreate polega na całkowitym usunięciu starej wersji aplikacji przed wdrożeniem nowej. W efekcie, przez krótki czas usługa jest niedostępna, ponieważ żadne pody nie działają. Ta metoda uniemożliwia współistnienie starych i nowych wersji, co może być przydatne w przypadku niezgodności między wersjami, ale powoduje krótką przerwę w działaniu. Żeby niej skorzystać trzeba w pliku `redis-deplyoment.yaml` dodać:

```
strategy:
  type: Recreate
```

Rolling Update

RollingUpdate to domyślna strategia wdrażania, w której nowe wersje podów są stopniowo uruchamiane, zastępując stare. Ta strategia minimalizuje przestoje, zachowując ciągłość działania usługi. Aby dostosować jej parametry, należy w konfiguracji Deploymentu określić:
```
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 2  # Maksymalna liczba niedostępnych podów podczas aktualizacji  
    maxSurge: 30%      # Maksymalny dodatkowy bufor podów powyżej docelowej liczby replik  
```

Canary Deployment workload
Aby wdrożyć tę strategię, należy utworzyć nowy Deployment z zaktualizowaną wersją obrazu, ustawiając znacząco mniejszą liczbę replik niż w stabilnej wersji aplikacji. Takie podejście pozwala na stopniowe udostępnienie nowej funkcjonalności jedynie części użytkowników, umożliwiając wczesne wychwycenie potencjalnych problemów przed pełnym wdrożeniem. Warunkiem poprawnego działania jest nadanie obu Deploymentom wspólnej etykiety, co zapewni, że będą one współdzielić ten sam Service i ruch będzie automatycznie rozkładany między obie wersje aplikacji.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-app-canary
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 30%
  selector:
    matchLabels:
      app: pipeline-redis
  template:
    metadata:
      labels:
        app: pipeline-redis
    spec:
      containers:
        - name: redis-container
          image: marekkubi/pipeline-redis:v1.0.20
          ports:
            - containerPort: 6379
```


W ramach jednego serwisu działają równolegle dwa deploymenty, gdzie 6 podów obsługuje starą wersję aplikacji, a 2 nowszą, co umożliwia stopniowe testowanie w środowisku produkcyjnym poprzez kierowanie około 25% ruchu na zaktualizowaną wersję. Taka strategia pozwala na wczesne wykrycie ewentualnych problemów przez ograniczoną grupę użytkowników pełniących rolę testerów, minimalizując ryzyko poważniejszych awarii przy pełnym wdrożeniu. Dzięki temu można bezpiecznie zweryfikować nową wersję w rzeczywistych warunkach przed jej ostatecznym wdrożeniem na pełną skalę.

![Alt text](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/a3a84e17b85b6f556a1f0859a857c017f523225b/ITE/GCL04/MK415056/sprawozdanie3/screanshots/k32.png)
