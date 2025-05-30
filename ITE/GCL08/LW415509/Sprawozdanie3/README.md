# Zajęcia 08
---
# Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

### Instalacja zarządcy Ansible

### Instalacja maszyny wirtualnej

Utworzono maszynę wirtualna i rozpoczęto proces instalacji.

![](images/Pasted%20image%2020250527114110.png)

Instalowanie tylko najbardziej niezbędnych zależności

![](images/Pasted%20image%2020250527114120.png)

Po zakończeniu instalacji należy ustawić hostname na ansible-target

```
sudo hostnamectl set-hostname ansible-target
```

![](images/Pasted%20image%2020250527114137.png)

Weryfikacja instalacji tar i sshd

```
which tar
```

```
which sshd
```

![](images/Pasted%20image%2020250527114156.png)

Uruchomienie serwera SSH

```
sudo systemctl enable sshd
sudo systemctl start sshd
```

Weryfikacja uruchomienia:
```
systemctl status sshd
```

![](images/Pasted%20image%2020250527114209.png)

Instalacja Ansible na maszynie głównej

```
sudo dnf install -y ansible
```

![](images/Pasted%20image%2020250527114221.png)

Weryfikacja instalacji

```
ansible --version
```

![](images/Pasted%20image%2020250527114233.png)

Wymiana kluczy SSH

Jeżeli na maszynie nie ma jeszcze klucza, należy wygenerować go poleceniem:

```
ssh-keygen
```

Jeżeli po wpisaniu tego wyskoczy zapytanie:
override (y/n)?

Oznacza to że klucz już istnieje i lepiej go nie nadpisywać bo może być używany gdzie indziej. W takiej sytuacji kopiujemy klucz na maszynę ansible. Aby było to możliwe musimy dodać jej adres do znanych hostów:

```
sudo nano /etc/hosts
```

Dopisujemy ostatnią linijkę tak jak na poniższym zrzucie ekranu.

![](images/Pasted%20image%2020250527114251.png)

Następnie kopiujemy klucz poleceniem:

```
ssh-copy-id -i ~/.ssh/id_ed25519.pub ansible@ansible-target
```

Weryfikujemy poprawność skopiowania poleceniem

```
ssh ansible@ansible-target
```

![](images/Pasted%20image%2020250527114313.png)  
### Inwentaryzacja
* Dokonaj inwentaryzacji systemów
  * Ustal przewidywalne nazwy komputerów (maszyn wirtualnych) stosując `hostnamectl`, Unikaj `localhost`.
Na maszynie bez ansible:
```
sudo hostnamectl set-hostname ansible-target
```
Na maszynie z ansible:
```
sudo hostnamectl set-hostname orchestrator
```
  * Wprowadź nazwy DNS dla maszyn wirtualnych, stosując `systemd-resolved` lub `resolv.conf` i `/etc/hosts` - tak, aby możliwe było wywoływanie komputerów za pomocą nazw, a nie tylko adresów IP
```
sudo nano /etc/hosts
```
![](images/Zrzut%20ekranu%202025-05-13%20191827.png)
![](images/Zrzut%20ekranu%202025-05-13%20192232.png)
  * Zweryfikuj łączność
```
ping orchestrator
```
![](images/Pasted%20image%2020250527114709.png)****
  * Stwórz [plik inwentaryzacji](https://docs.ansible.com/ansible/latest/getting_started/get_started_inventory.html). Umieść w nim sekcje `Orchestrators` oraz `Endpoints`. Umieść nazwy maszyn wirtualnych w odpowiednich sekcjach
Na maszynie z Ansible:
```
nano inventory.ini
```
Treść pliku inventory.ini
```
[orchestrators]
orchestrator ansible-user=lukasz
[endpoints]
ansible-target ansible-user=ansible
```
![](images/Zrzut%20ekranu%202025-05-13%20194421.png)
  * Wyślij żądanie `ping` do wszystkich maszyn
```
ansible endpoints -i inventory.ini -m ping
```

### Zdalne wywoływanie procedur
Za pomocą [*playbooka*](https://docs.ansible.com/ansible/latest/getting_started/get_started_playbook.html) Ansible:
  * Wyślij żądanie `ping` do wszystkich maszyn
Utworzenie playbooka
```
nano ping_playbook.yml
```

```
---

- name: Ping all machines

  hosts: all

  gather_facts: no

  

  tasks:

    - name: Ping (pierwsze podejście)

      ansible.builtin.ping:

  
  

- name: Copy inventory file to endpoints

  hosts: endpoints

  gather_facts: no

  

  tasks:

    - name: Copy inventory.ini to remote endpoints

      ansible.builtin.copy:

        src: inventory.ini

        dest: /home/{{ ansible_user }}/inventory.ini

        mode: '0644'

  
  

- name: Ping all machines again for comparison

  hosts: all

  gather_facts: no

  

  tasks:

    - name: Ping - second time

      ansible.builtin.ping:

  
  

- name: Upgrade system packages

  hosts: endpoints

  remote_user: ansible

  

  tasks:

    - name: Upgrade all packages

      ansible.builtin.dnf:

        name: '*'

        state: latest

      become: true

  
  

- name: Restart critical services

  hosts: endpoints

  become: yes

  

  tasks:

    - name: Restart sshd

      ansible.builtin.service:

        name: sshd

        state: restarted

  

    - name: Restart rngd

      ansible.builtin.service:

        name: rngd

        state: restarted

      ignore_errors: yes
```

  * Skopiuj plik inwentaryzacji na maszyny/ę `Endpoints`
  * Ponów operację, porównaj różnice w wyjściu
  * Zaktualizuj pakiety w systemie (⚠️ [uwaga!](https://github.com/ansible/ansible/issues/84634) )
  * Zrestartuj usługi `sshd` i `rngd`

W celu uruchomienia playbooka używamy polecenia:
```
ansible-playbook -i inventory.ini ping_playbook.yml --ask-become-pass
```

Musimy podać flagę --ask-become-pass aby możliwe było podanie hasła roota dla hostów w celu przeprowadzenia aktualizacji pakietów.
![](images/Pasted%20image%2020250527131622.png)

![](images/Pasted%20image%2020250527131252.png)

Możemy zauważyć że przy pierwszym uruchomieniu playbooka w sekcji changed dla maszyny z którą się łączymy wartość wynosi 2 a przy kolejnym tylko jeden. Wynika to z faktu że plik inventory.ini został już na tę maszynę skopiowany więc operacja kopiowania nie została ponownie wykonana.

![](images/Pasted%20image%2020250527131946.png)

Błąd przy próbie restartu usługi rngd wynika z faktu iż nie jest ona zainstalowana na maszynie docelowej.
### Zarządzanie stworzonym artefaktem
Za pomocą [*playbooka*](https://docs.ansible.com/ansible/latest/getting_started/get_started_playbook.html) Ansible:

* Jeżeli artefaktem z Twojego *pipeline'u* był kontener:
  * Zbuduj i uruchom kontener sekcji `Deploy` z poprzednich zajęć
  * Pobierz z Docker Hub aplikację "opublikowaną" w ramach kroku `Publish`
  * Na maszynie docelowej, **Dockera zainstaluj Ansiblem!**
  * Zweryfikuj łączność z kontenerem
  * Zatrzymaj i usuń kontener

Nowo utworzony playbook uruchamiamy poleceniem:
```
ansible-playbook -i inventory.ini docker_playbook.yml --ask-become-pass
```

Otrzymujemy następujący rezultat działania playbooka

![](images/Pasted%20image%2020250527133722.png)

Jak widać aplikacja uruchamia się poprawnie i otrzymujemy odpowiedź z kontenera.

```
- name: Deploy Docker container

  hosts: endpoints

  become: yes

  tasks:

  

    - name: Add Docker CE repo

      ansible.builtin.yum_repository:

        name: docker-ce

        description: Docker CE Stable - $basearch

        baseurl: https://download.docker.com/linux/centos/7/$basearch/stable

        enabled: yes

        gpgcheck: yes

        gpgkey: https://download.docker.com/linux/centos/gpg

  

    - name: Install Docker

      become: true

      ansible.builtin.package:

        name: docker-ce

        state: present

  

    - name: Start and enable Docker service

      become: true

      ansible.builtin.service:

        name: docker

        state: started

        enabled: true

  

    - name: Pull Docker image elwilk/myapp

      become: true

      community.docker.docker_image:

        name: elwilk/myapp

        source: pull

  

    - name: Run container

      become: true

      community.docker.docker_container:

        name: myapp_container

        image: elwilk/myapp

        state: started

        ports:

          - "80:3000"

  

    - name: Wait for app to respond

      ansible.builtin.uri:

        url: http://localhost:80

        status_code: 200

        timeout: 10

      register: result

      until: result.status == 200

      retries: 5

      delay: 3

  

    - name: Run curl to fetch app homepage

      ansible.builtin.command:

        cmd: curl -s http://localhost:80

      register: curl_result

      failed_when: curl_result.rc != 0

  

    - name: Display curl output

      ansible.builtin.debug:

        msg: "Wynik curl:\n{{ curl_result.stdout }}"    

  

    - name: Stop container

      become: true

      community.docker.docker_container:

        name: myapp_container

        state: stopped

  

    - name: Remove container

      become: true

      community.docker.docker_container:

        name: myapp_container

        state: absent
```

Ubierz powyższe kroki w [*rolę*](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html), za pomocą szkieletowania `ansible-galaxy`

W celu utworzenia roli używamy polecenia:

```
ansible-galaxy init docker-app
```

Utworzy ono katalog z folderami:

![](images/Pasted%20image%2020250527134318.png)

Wszystkie kroki z uruchamiania kontenera przenosimy do pliku /docker_app/tasks/main.yml
Następnie tworzymy prosty playbook który uruchomi naszą rolę:

```
- name: Deploy Dockerized app using role

  hosts: endpoints

  become: yes

  

  roles:

    - docker-app
```

Uruchamiamy go poleceniem:

```
ansible-playbook -i inventory.ini docker_role.yml --ask-become-pass
```

![](images/Pasted%20image%2020250527135218.png)
# Zajęcia 09
---
# Pliki odpowiedzi dla wdrożeń nienadzorowanych

Przeprowadź instalację nienadzorowaną systemu Fedora z pliku odpowiedzi z naszego repozytorium

* Pobierz plik odpowiedzi `/root/anaconda-ks.cfg`
```
sudo cp /root/anaconda-ks.cfg .
```

![](images/Pasted%20image%2020250527111717.png)

Skopiowany plik został umieszczony na zdalnym repozytorium github w celu umożliwienia pobrania go podczas instalacji nienadzorowanej systemu fedora.
* Użyj pliku odpowiedzi do przeprowadzenia [instalacji nienadzorowanej](https://docs.fedoraproject.org/en-US/fedora/f36/install-guide/advanced/Kickstart_Installations/)
![](images/Zrzut%20ekranu%202025-05-13%20140233.png)
Podczas instalacji należało kliknąć przycisk e aby przejść do menu GRUB, gdzie należało podać opcję inst.ks = link do pliku .ks na githubie, skąd został on pobrany i użyty do przeprowadzenia instalacji nienadzorowanej.

![](images/Zrzut%20ekranu%202025-05-13%20140318.png)
![](images/Zrzut%20ekranu%202025-05-13%20140324.png)
![](images/Zrzut%20ekranu%202025-05-13%20140811.png)
---
* Rozszerz plik odpowiedzi o repozytoria i oprogramowanie potrzebne do uruchomienia programu, zbudowanego w ramach projektu - naszego *pipeline'u*. 
  * W przypadku kontenera, jest to po prostu Docker.
![](images/Pasted%20image%2020250527112531.png)
Sekcja %post - sekcja poinstalacyjna, definiuje akcje które będą wykonane po zainstalowaniu systemu
Włączenie dockera:
```
systemctl enable docker
```
Stworzenie własnej usługi systemd która ma za zadanie uruchomić kontener z obrazem aplikacji utworzonej poprzez pipeline.
```
cat > /etc/systemd/system/dummytest.service <<EOF
[Unit]
Description=Run dummytest Docker container
After=network-online.target docker.service
Requires=docker.service
[Service]
Restart=always
ExecStart=/usr/bin/docker run --name dummytest -p 80:3000 elwilk/myapp
ExecStop=/usr/bin/docker stop dummytest
```
* Zadbaj o automatyczne ponowne uruchomienie na końcu instalacji
![](images/Pasted%20image%2020250527112921.png)

Po pierwszym uruchomieniu systemu nasz obraz pracuje i możemy otrzymać odpowiedź od aplikacji

```
sudo systemctl status docker
```

![](images/Zrzut%20ekranu%202025-05-13%20140852.png)
```
curl http://localhost
```
![](images/Zrzut%20ekranu%202025-05-13%20144142.png)
```
sudo docker ps
```
![](images/Zrzut%20ekranu%202025-05-13%20144152.png)

```
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8
network --hostname=fedora-dummytest

%packages
@^server-product-environment
docker
wget
%end

%post --log=/root/ks-post.log --interpreter=/bin/bash
systemctl enable docker
cat > /etc/systemd/system/dummytest.service <<EOF
[Unit]
Description=Run dummytest Docker container
After=network-online.target docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --name dummytest -p 80:3000 elwilk/myapp
ExecStop=/usr/bin/docker stop dummytest

[Install]
WantedBy=multi-user.target
EOF

systemctl enable dummytest.service
%end

# Run the Setup Agent on first boot
firstboot --disable
reboot

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
autopart
# Partition clearing information
clearpart --all --initlabel

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --iscrypted --allow-ssh $y$j9T$DuC67R8NjjYMfGwWVPSXO03C$N0ZmKnvzxeT6T6rFkxqU0f3W08y7lGTmJGIw3Ec5c93
user --groups=wheel --name=lukasz --password=$y$j9T$vn1hw6HOva7luKZR7e7dLHqU$waRkKfYGAmQ9BMziH85weVlAB0i17oEHREuW43cieI9 --iscrypted --gecos="lukasz"
```
# Zajęcia 10

# Wdrażanie na zarządzalne kontenery: Kubernetes (1)

## Zadania do wykonania
### Instalacja klastra Kubernetes
 * Zaopatrz się w implementację stosu k8s: [minikube](https://minikube.sigs.k8s.io/docs/start/)
 * Przeprowadź instalację, wykaż poziom bezpieczeństwa instalacji
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm
```
![](images/Zrzut%20ekranu%202025-05-20%20184355.png)
 * Zaopatrz się w polecenie `kubectl` w wariancie minikube, może być alias `minikubctl`, jeżeli masz już "prawdziwy" `kubectl`
```
alias kubectl="minikube kubectl --"
```
![](images/Pasted%20image%2020250527150335.png)
 * Uruchom Kubernetes, pokaż działający kontener/worker
 W celu umożliwienia uruchomienia kontenera minikube należało dodać użytkownika do grupy docker
```
sudo usermod -aG docker lukasz && newgrp docker
```
Następnie uruchamiamy kontener poleceniem:
```
minikube start
```
 * Uruchom Dashboard, otwórz w przeglądarce, przedstaw łączność
```
minikube dashboard
```

![](images/Pasted%20image%2020250527150521.png)
![](images/Pasted%20image%2020250527150530.png)
### Uruchamianie oprogramowania
 * Uruchom kontener ze swoją/wybraną aplikacją na stosie k8s
```
kubectl run myapp-js --image=elwilk/myapp --port=3000 --labels app=myapp
```
![](images/Pasted%20image%2020250527151425.png)
![](images/Pasted%20image%2020250527151438.png)
 * Wyprowadź port celem dotarcia do eksponowanej funkcjonalności
```
kubectl port-forward pod/myapp-js 8888:3000
```
![](images/Pasted%20image%2020250527151737.png)
 Po wyprowadzeniu portu 8888 z maszyny możemy zobaczyć działającą aplikację w przeglądarce.
 ![](images/Pasted%20image%2020250527152115.png)
### Przekucie wdrożenia manualnego w plik wdrożenia (wprowadzenie)
 * Zapisz [wdrożenie](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) jako plik YML
```
apiVersion: apps/v1

kind: Deployment

metadata:

  name: myapp

spec:

  replicas: 4

  selector:

    matchLabels:

      app: myapp

  template:

    metadata:

      labels:

        app: myapp

    spec:

      containers:

      - name: myapp

        image: elwilk/myapp

        ports:

        - containerPort: 3000
```
 * Przeprowadź próbne wdrożenie przykładowego *deploymentu*
   * Wykonaj ```kubectl apply``` na pliku
```
kubectl apply -f myapp-deployment.yaml
```
   * Zbadaj stan za pomocą ```kubectl rollout status```
```
kubectl rollout status deployments/myapp
```
![](images/Pasted%20image%2020250527152957.png)
 * Wyeksponuj wdrożenie jako serwis
 * Przekieruj port do serwisu (tak, jak powyżej) 
```
kubectl expose deployment myapp --type=NodePort --port=8889 --target-port=3000 --name=myapp-service
```
![](images/Pasted%20image%2020250527154517.png)
![](images/Pasted%20image%2020250527154528.png)
![](images/Pasted%20image%2020250527154540.png)

Kiedy serwis działa przekierowujemy jego port.
```
kubectl port-forward deployment/myapp 8889:3000
```

![](images/Pasted%20image%2020250527154644.png)
Następnie przekierowujemy port w visual studio code aby uruchomić aplikację w przeglądarce.

![](images/Pasted%20image%2020250527154725.png)

# Zajęcia 11

# Wdrażanie na zarządzalne kontenery: Kubernetes (2)

## Zadania do wykonania

### Przygotowanie nowego obrazu
 * Zarejestruj nową wersję swojego obrazu `Deploy` (w Docker Hub lub lokalnie+przeniesienie)
 * Upewnij się, że dostępne są dwie co najmniej wersje obrazu z wybranym programem
Dostępna jest domyślna wersja aplikacji wyprodukowana pipelinem. Utworzono nową wersję ze zmienionymi stylami css w pliku .ejs.
![](images/Pasted%20image%2020250529151354.png)
![](images/Pasted%20image%2020250529151404.png)
Nowa wersja została wyprodukowana przy użyciu pipeline'u Jenkins.
 * Przygotuj kolejną wersję obrazu, którego uruchomienie kończy się błędem
W celu utworzenia wersji której uruchomienie kończy się błędem należy dokonać zmian w pliku Dockerfile.deploy w linijce CMD podając nieistniejący skrypt do uruchomienia.
![](images/Pasted%20image%2020250529151830.png)
Następnie zbudowano obrazy lokalnie i spushowano je na zdalne repozytorium dockerhub
```
docker build -f Dockerfile.build -t myapp-build:latest .
docker build -f Dockerfile.deploy -t elwilk/myapp:1.1.0-error .
docker login
docker push elwilk/myapp:1.1.0-error
```
![](images/Pasted%20image%2020250529153119.png)
### Zmiany w deploymencie
 * Aktualizuj plik YAML z wdrożeniem i przeprowadzaj je ponownie po zastosowaniu następujących zmian:
   * zwiększenie replik np. do 8
![](images/Pasted%20image%2020250529155011.png)
   * zmniejszenie liczby replik do 1
![](images/Pasted%20image%2020250529155042.png)
   * zmniejszenie liczby replik do 0
![](images/Pasted%20image%2020250529155104.png)
   * ponowne przeskalowanie w górę do 4 replik (co najmniej)
![](images/Pasted%20image%2020250529155141.png)
   * Zastosowanie nowej wersji obrazu
![](images/Pasted%20image%2020250529155351.png)
   * Zastosowanie starszej wersji obrazu
![](images/Pasted%20image%2020250529155420.png)
   * Zastosowanie "wadliwego" obrazu
![](images/Pasted%20image%2020250529155742.png)

 * Przywracaj poprzednie wersje wdrożeń za pomocą poleceń
   * ```kubectl rollout history```
   * ```kubectl rollout undo```

### Kontrola wdrożenia
 * Zidentyfikuj historię wdrożenia i zapisane w niej problemy, skoreluj je z wykonywanymi czynnościami
```
kubectl rollout history deployment myapp
```
![](images/Pasted%20image%2020250529155948.png)
Ostatnie wdrążenie spowodowało błędy, aby to naprawić można wrócić do poprzedniego działającego wdrążenia używając polecenia
```
kubectl rollout undo deployment myapp
```
![](images/Pasted%20image%2020250529160228.png)
 * Napisz skrypt weryfikujący, czy wdrożenie "zdążyło" się wdrożyć (60 sekund)
```
#!/bin/bash

  

DEPLOYMENT_NAME="myapp"

NAMESPACE="default"

TIMEOUT=60

INTERVAL=5

ELAPSED=0

  

echo "Sprawdzam status wdrożenia: $DEPLOYMENT_NAME w namespace: $NAMESPACE"

  

while [ $ELAPSED -lt $TIMEOUT ]; do

  AVAILABLE_REPLICAS=$(minikube kubectl -- get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o=jsonpath="{.status.availableReplicas}")

  DESIRED_REPLICAS=$(minikube kubectl -- get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o=jsonpath="{.spec.replicas}")

  

  AVAILABLE_REPLICAS=${AVAILABLE_REPLICAS:-0}

  DESIRED_REPLICAS=${DESIRED_REPLICAS:-0}

  

  echo "[$ELAPSED/$TIMEOUT] dostępne: $AVAILABLE_REPLICAS / oczekiwane: $DESIRED_REPLICAS"

  

  if [ "$AVAILABLE_REPLICAS" -eq "$DESIRED_REPLICAS" ] && [ "$DESIRED_REPLICAS" -ne 0 ]; then

    echo "Wdrożenie zakończone sukcesem po ${ELAPSED}s"

    exit 0

  fi

  

  sleep $INTERVAL

  ELAPSED=$((ELAPSED + INTERVAL))

done

  

echo "Wdrożenie NIE zakończyło się sukcesem w ciągu ${TIMEOUT}s"

exit 1
```

Aby sprawdzić działanie skryptu należy najpierw uruchomić deployment:
```
minikube kubectl -- apply -f myapp-deployment.yaml
```

A następnie uruchomić skrypt
```
./check_deploy.sh
```
### Strategie wdrożenia
 * Przygotuj wersje [wdrożeń](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) stosujące następujące strategie wdrożeń
   * Recreate
```
apiVersion: apps/v1

kind: Deployment

metadata:

  name: myapp-recreate

spec:

  replicas: 4

  strategy:

    type: Recreate

  selector:

    matchLabels:

      app: myapp-recreate

  template:

    metadata:

      labels:

        app: myapp-recreate

    spec:

      containers:

      - name: myapp

        image: elwilk/myapp:1.0.31

        ports:

        - containerPort: 3000
```

Uruchamiamy poleceniem
```
kubectl apply -f myapp-recreate.yaml
```

![](images/Pasted%20image%2020250529172915.png)

Strategia Recreate powoduje usunięcie wszystkich podów przed wdrążeniem nowych, co może powodować przestoje.

   * Rolling Update (z parametrami `maxUnavailable` > 1, `maxSurge` > 20%)
```
apiVersion: apps/v1

kind: Deployment

metadata:

  name: myapp-rolling

spec:

  replicas: 4

  strategy:

    type: RollingUpdate

    rollingUpdate:

      maxUnavailable: 2

      maxSurge: 30%

  selector:

    matchLabels:

      app: myapp-rolling

  template:

    metadata:

      labels:

        app: myapp-rolling

    spec:

      containers:

      - name: myapp

        image: elwilk/myapp:1.0.31

        ports:

        - containerPort: 3000
```
![](images/Pasted%20image%2020250529173216.png)
```
kubectl apply -f myapp-rolling.yaml
```

Strategia ta polega na płynnym podmienianiu replik po kolei każda. Parametr maxUnavailable określa liczbę podów które mogą być niedostępne, a parametr maxSurge określa ilosć podów które mogą być dodatkowo uruchomione podczas aktualizacji.
   * Canary Deployment workload
```
apiVersion: apps/v1

kind: Deployment

metadata:

  name: myapp

spec:

  replicas: 3

  selector:

    matchLabels:

      app: myapp

  template:

    metadata:

      labels:

        app: myapp

    spec:

      containers:

      - name: myapp

        image: elwilk/myapp:1.0.31

        ports:

        - containerPort: 3000
```

```
apiVersion: apps/v1

kind: Deployment

metadata:

  name: myapp-canary

spec:

  replicas: 1

  selector:

    matchLabels:

      app: myapp

      version: canary

  template:

    metadata:

      labels:

        app: myapp

        version: canary

    spec:

      containers:

      - name: myapp

        image: elwilk/myapp:1.0.31

        ports:

        - containerPort: 3000
```

Polecenia do uruchomienia obu plików yaml:

```
kubectl apply -f myapp-stable.yaml
kubectl apply -f myapp-canary.yaml
```

Strategia Canary Deployment polega na wypuszczeniu nowej wersji tylko do części replik np.: na jedną i testowanie jej, zanim nastąpi pełny deploy  z pozostałymi podami.