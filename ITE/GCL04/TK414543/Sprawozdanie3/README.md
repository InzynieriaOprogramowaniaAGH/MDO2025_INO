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


LAB9

LAB10

LAB11