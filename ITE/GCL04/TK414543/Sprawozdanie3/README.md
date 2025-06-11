LAB8
sudo dnf install ansible -y
![Alt text](LAB8/screenshots/image1.png)

ansible --version
![Alt text](LAB8/screenshots/image2.png)

ssh-keygen -t ed25519 -C "ansible@orchestrator"


mkdir -p ./ansible-project/{inventories,playb
ooks,roles}

![Alt text](LAB8/screenshots/image3.png)

sudo hostnamectl set-hostname orchestrator
hostnamectl

![Alt text](LAB8/screenshots/image6.png)

root
root_pass

ansible
my_pass

ip a

hostname: ansible-target
ip: 172.20.10.12

ip a

hostname: orchestrator
ip: 172.31.116.202

![Alt text](LAB8/screenshots/image4.png)
![Alt text](LAB8/screenshots/image5.png)

hostnamectl

sudo nano /etc/hosts
![Alt text](LAB8/screenshots/image8.png)

wymiana kluczy ssh
ssh-copy-id ansible@ansible-target
![Alt text](LAB8/screenshots/image9.png)

ansible@ansible-target
![Alt text](LAB8/screenshots/image10.png)

ansible -i inventories/hosts all -m ping
![Alt text](LAB8/screenshots/image11.png)

ansible-playbook -i inventories/hosts playbooks/copy_inventory.yml

![Alt text](LAB8/screenshots/image12.png)

na zdalnej maszynie

echo 'ansible ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/ansible
chmod 440 /etc/sudoers.d/ansible

![Alt text](LAB8/screenshots/image13.png)

ansible-galaxy collection install community.docker

![Alt text](LAB8/screenshots/image14.png)

ansible-playbook -i inventories/hosts playbooks/deploy_container.yml

![Alt text](LAB8/screenshots/image15.png)

LAB9

![Alt text](LAB9/screenshots/image1.png)

[text](https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/TK414543/ITE/GCL04/TK414543/Sprawozdanie3/LAB9/anaconda-ks.cfg
)

![Alt text](LAB9/screenshots/image2.png)


inst.ks=https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/TK414543/ITE/GCL04/TK414543/Sprawozdanie3/LAB9/anaconda-ks.cfg


![Alt text](LAB9/screenshots/image3.png)


![Alt text](LAB9/screenshots/image4.png)


LAB10

sudo dnf install -y conntrack

![Alt text](LAB10/screenshots/image1.png)

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm

![Alt text](LAB10/screenshots/image2.png)

sudo rpm -Uvh minikube-latest.x86_64.rpm

![Alt text](LAB10/screenshots/image3.png)

minikube start --driver=docker --force

![Alt text](LAB10/screenshots/image4.png)

minikube kubectl -- get nodes

![Alt text](LAB10/screenshots/image5.png)

![Alt text](LAB10/screenshots/image6.png)

minikube dashboard

![Alt text](LAB10/screenshots/image7.png)

![Alt text](LAB10/screenshots/image8.png)

minikube kubectl -- run oceanbattle-webapi --image=docker.io/kurowskitomek/webapi:latest --port=80 --labels app=oceanbattle-webapi

![Alt text](LAB10/screenshots/image9.png)

minikube kubectl -- get pods

![Alt text](LAB10/screenshots/image10.png)

minikube kubectl -- describe pod oceanbattle-webapi

minikube kubectl port-forward pod/oceanbattle-webapi 8083:80
![Alt text](LAB10/screenshots/image12.png)

http://localhost:8083/api/auth/.well-known

![Alt text](LAB10/screenshots/image11.png)

minikube kubectl -- apply -f oceanbattle-deployment.yaml

![Alt text](LAB10/screenshots/image13.png)

minikube kubectl rollout status deployment/oceanbattle-webapi

![Alt text](LAB10/screenshots/image14.png)
![Alt text](LAB10/screenshots/image15.png)

![Alt text](LAB10/screenshots/image16.png)


LAB11


