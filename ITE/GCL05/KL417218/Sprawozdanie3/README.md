# Sprawozdanie 2

### Ansible

#### Na ubsrv:

```sh
sudo apt install ansible
ssh-copy-id ansible@10.0.2.15
ssh ansible@10.0.2.15
# <sudo nano by dodac do /etc/hosts>
mkdir ansible
nano ansible/inventory.yml
```

[`inventory.yml`](./ansible/inventory.yml)

```sh
ansible all -i ansible/inventory.yml -m ping
```

[`playbook.yml`](./ansible/playbook.yml)

```sh
ansible-playbook -i inventory.yml playbook.yml 
```

[`main_playbook.yml`](./ansible/main_playbook.yml)

```sh
# Na ansible-target:
sudo apt install rng-tools

# Następnie na ubsrv:
ansible-playbook -i inventory.yml main_playbook.yml --ask-become-pass
```

```sh
ansible-galaxy init deploy_redis
ansible-playbook -i inventory.yml redis_playbook.yml --ask-become-pass
```

### Kickstart

### Minikube

```sh
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
minikube kubectl
```

```sh
# Dodano do ./bashrc
alias kubectl="minikube kubectl --"
```

```sh
minikube start
```

```sh
minikube dashboard
```

```sh
minikube kubectl run -- nxginx-pod --image=nginx --port=80 --labels app=nginx-pod
kubectl port-forward pod/nxginx-pod 8081:80
```

[`deployment.yml`](./minikube/deployment.yml)

```sh
kubectl apply -f deployment.yml
kubectl get deployments
kubectl expose deployment nginx-dep --type=NodePort --name=nginx-service --port=8082 --target-port=80 ???
```