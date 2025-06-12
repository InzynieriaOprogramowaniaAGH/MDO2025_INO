# Sprawozdanie 3 - Tomasz Kurowski

## Laboratorium 8 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

### Instalacja zarządcy Ansible

Utworzono drugą maszynę wirtualną z Fedorą 41 Server z minimalnym zbiorem oprogramowania, zapewniono obecność programu tar i serwera OpenSSH (sshd). 

![Alt text](LAB8/screenshots/image4.png)

W trakcie instalacji nadano hostname ansible-target oraz utworzono użytkownika ansible.
Na koniec stworzono migawkę maszyny.

![Alt text](LAB8/screenshots/image5.png)

Na pierwotnej maszynie zainstalowano ansible.

```
sudo dnf install ansible -y
```

![Alt text](LAB8/screenshots/image1.png)

Sprawdzono wersję ansible:

```
ansible --version
```

![Alt text](LAB8/screenshots/image2.png)

Ustawiono hostname pierwotnej maszyny na orchestrator.

```
sudo hostnamectl set-hostname orchestrator
hostnamectl
```

![Alt text](LAB8/screenshots/image6.png)

### Inwentaryzacja

Sprawdzono adersy orchestratora i ansible-target:

hostname: ansible-target
ip: 172.20.10.12

hostname: orchestrator
ip: 172.31.116.202

Wprowadzono nazwy DNS dla maszyn wirtualnych tak aby możliwe było ich wywoływanie za pomocą nazw:

```
hostnamectl
sudo nano /etc/hosts
```

![Alt text](LAB8/screenshots/image8.png)

Dokonano wymiany kluczy SSH między użytkownikiem w głównej maszynie wirtualnej, a użytkownikiem ansible z nowej tak, by logowanie nie wymagało podania hasła.

```
ssh-keygen -t ed25519 -C "ansible@orchestrator"
mkdir -p ./ansible-project/{inventories,playbooks,roles}
```

![Alt text](LAB8/screenshots/image3.png)

Wymiana kluczy ssh:

```
ssh-copy-id ansible@ansible-target
```

![Alt text](LAB8/screenshots/image9.png)

```
ansible@ansible-target
```

![Alt text](LAB8/screenshots/image10.png)

Stworzono [`plik`](./LAB8/ansible-project/inventories/hosts) inwentaryzacji:

```
[Orchestrators]
orchestrator ansible_connection=local

[Endpoints]
ansible-target ansible_user=ansible
```

Wysłano żądanie ping do wszystkich maszyn:

```
ansible -i inventories/hosts all -m ping
```

![Alt text](LAB8/screenshots/image11.png)

### Zdalne wywoływanie procedur

Utworzono [`playbook`](./LAB8/ansible-project/playbooks/copy_inventory.yml) i skopiowano z jego pomocą plik inwentaryzacji na maszynę.

```yaml
# playbooks/copy_inventory.yml
- name: Copy inventory file
  hosts: Endpoints
  tasks:
    - name: Copy inventory file
      copy:
        src: ../inventories/hosts
        dest: /home/ansible/hosts
        owner: ansible
        group: ansible
        mode: '0644'
```

```
ansible-playbook -i inventories/hosts playbooks/copy_inventory.yml
```

![Alt text](LAB8/screenshots/image12.png)

Na zdalnej maszynie:

Za pomocą [`playbooka`](./LAB8/ansible-project/playbooks/update_restart.yml) ansible wykonano próbę aktualizacji pakietów w systemie oraz restartu usłyg sshd i rngd.

```yaml
# playbooks/update_restart.yml
- name: Update system and restart services
  hosts: Endpoints
  become: yes
  tasks:
    - name: Update all packages
      dnf:
        name: "*"
        state: latest
    - name: Restart sshd
      service:
        name: sshd
        state: restarted
    - name: Restart rngd
      service:
        name: rngd
        state: restarted
      ignore_errors: yes 
```

```
echo 'ansible ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/ansible
chmod 440 /etc/sudoers.d/ansible
```
```
ansible-playbook -i inventories/hosts playbooks/update_restart.yml
```

![Alt text](LAB8/screenshots/image13.png)

### Zarządzanie stworzonym artefaktem 

```
ansible-galaxy collection install community.docker
```

![Alt text](LAB8/screenshots/image14.png)

Za pomocą [`taska`](./LAB8/ansible-project/roles/deploy_docker/main.yml) ansible pobrano z Docker Hub aplikację oraz uruchomiono kontener.
Następnie zweryfikowano łączność i zatrzymano a potem usunięto kontener.

```yaml
- name: Ensure Docker is installed
  package:
    name: docker
    state: present
  become: true

- name: Ensure Docker service is running
  service:
    name: docker
    state: started
    enabled: true
  become: true

- name: Pull Docker image from Docker Hub
  community.docker.docker_image:
    name: "{{ docker_image }}"
    source: pull
    state: present

- name: Run container
  community.docker.docker_container:
    name: "{{ container_name }}"
    image: "{{ docker_image }}"
    state: started
    ports:
      - "8080:{{ container_port }}"

- name: Wait for container port to become available
  wait_for:
    port: 8080
    host: 127.0.0.1
    delay: 3
    timeout: 30

- name: Stop container
  community.docker.docker_container:
    name: "{{ container_name }}"
    state: stopped

- name: Remove container
  community.docker.docker_container:
    name: "{{ container_name }}"
    state: absent
```

Wykorzystano [`playbook`](./LAB8/ansible-project/playbooks/deploy_container.yml).

```yaml
- name: Deploy container artifact from Docker Hub
  hosts: Endpoints
  become: true
  roles:
    - deploy_docker
```

```
ansible-playbook -i inventories/hosts playbooks/deploy_container.yml
```

![Alt text](LAB8/screenshots/image15.png)

## Laboratorium 9 - Pliki odpowiedzi dla wdrożeń nienadzorowanych

![Alt text](LAB9/screenshots/image1.png)

![Alt text](LAB9/screenshots/image2.png)

```
inst.ks=https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/TK414543/ITE/GCL04/TK414543/Sprawozdanie3/LAB9/anaconda-ks.cfg
```

![Alt text](LAB9/screenshots/image3.png)


![Alt text](LAB9/screenshots/image4.png)


## Laboratorium 10 - Wdrażanie na zarządzalne kontenery: Kubernetes (1)

```
sudo dnf install -y conntrack
```

![Alt text](LAB10/screenshots/image1.png)

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
```

![Alt text](LAB10/screenshots/image2.png)

```
sudo rpm -Uvh minikube-latest.x86_64.rpm
```

![Alt text](LAB10/screenshots/image3.png)

```
minikube start --driver=docker --force
```

![Alt text](LAB10/screenshots/image4.png)

```
minikube kubectl -- get nodes
```

![Alt text](LAB10/screenshots/image5.png)

![Alt text](LAB10/screenshots/image6.png)

```
minikube dashboard
```

![Alt text](LAB10/screenshots/image7.png)

![Alt text](LAB10/screenshots/image8.png)

```
minikube kubectl -- run oceanbattle-webapi --image=docker.io/kurowskitomek/webapi:latest --port=80 --labels app=oceanbattle-webapi
```

![Alt text](LAB10/screenshots/image9.png)

```
minikube kubectl -- get pods
```

![Alt text](LAB10/screenshots/image10.png)

```
minikube kubectl -- describe pod oceanbattle-webapi
minikube kubectl port-forward pod/oceanbattle-webapi 8083:80
```

![Alt text](LAB10/screenshots/image12.png)

http://localhost:8083/api/auth/.well-known

![Alt text](LAB10/screenshots/image11.png)

```
minikube kubectl -- apply -f oceanbattle-deployment.yaml
```

![Alt text](LAB10/screenshots/image13.png)

```
minikube kubectl rollout status deployment/oceanbattle-webapi
```

![Alt text](LAB10/screenshots/image14.png)

![Alt text](LAB10/screenshots/image15.png)

![Alt text](LAB10/screenshots/image16.png)

```
minikube kubectl --  apply -f oceanbattle-service.yaml
```

![Alt text](LAB10/screenshots/image17.png)

```
minikube kubectl port-forward service/oceanbattle-service 8084:80
```

![Alt text](LAB10/screenshots/image18.png)

## Laboratorium 11 - Wdrażanie na zarządzalne kontenery: Kubernetes (2)

![Alt text](LAB11/screenshots/image1.png)

```
docker build -f Dockerfile.deploy -t oceanbattle-deploy .
docker run --rm oceanbattle-deploy
```

Stworzono kontener generujący błąd

Zwiększono liczbę replik do 8

![Alt text](LAB11/screenshots/image2.png)

Zmniejszono liczbę replik do 1

![Alt text](LAB11/screenshots/image3.png)

Zmniejszono liczbę replik do 0

![Alt text](LAB11/screenshots/image4.png)

Przeskalowano liczbę replik w górę do 4

![Alt text](LAB11/screenshots/image5.png)

Zmieniono z nowej wersji na starą

![Alt text](LAB11/screenshots/image6.png)

Wykonano powrót do najnowszej wersji:

```
minikube kubectl rollout history deployment oceanbattle-webapi
minikube kubectl -- rollout undo deployment/oceanbattle-webapi --to-revision=1
```

![Alt text](LAB11/screenshots/image7.png)


Napisano [`skrypt`](./LAB11/verify-rollout.sh) sprawdzający czy wdrożenie zdążyło się wykonać.

```bash
#!/bin/bash
deployment_name="oceanbattle-webapi"
timeout=60
interval=5
elapsed=0

while [ $elapsed -lt $timeout ]; do
  status=$(minikube kubectl -- rollout status deployment/$deployment_name)
  echo "$status"
  if [[ "$status" == *"successfully rolled out"* ]]; then
    echo "Deployment successful"
    exit 0
  fi
  sleep $interval
  elapsed=$((elapsed + interval))
done

echo "Deployment did not finish in time"
exit 1
```

Nadano uprawnienia dla skryptu:

```
chmod +x verify-rollout.sh
```

Zastosowanie skryptu:

```
minikube kubectl -- apply -f ../LAB10/oceanbattle-deployment.yaml
./verify-rollout.sh
```

![Alt text](LAB11/screenshots/image8.png)

### Strategie wdrożenia

* Rolling Update

```
minikube kubectl -- apply -f oceanbattle-deployment-rolling.yaml
```

![Alt text](LAB11/screenshots/image9.png)

* Recreate

```
minikube kubectl -- apply -f oceanbattle-deployment-recreate.yaml
```

![Alt text](LAB11/screenshots/image10.png)

* Canary

```
minikube kubectl -- apply -f oceanbattle-deployment-canary.yaml
```

![Alt text](LAB11/screenshots/image11.png)