# Sprawozdanie 2

### Ansible

#### Na ubsrv:

```bash
sudo apt install ansible
ssh-copy-id ansible@10.0.2.15
ssh ansible@10.0.2.15
# <sudo nano by dodac do /etc/hosts>
mkdir ansible
nano ansible/inventory.yml
```

[`inventory.yml`](./ansible/inventory.yml)

```bash
ansible all -i ansible/inventory.yml -m ping
```

[`playbook.yml`](./ansible/playbook.yml)

```bash
ansible-playbook -i inventory.yml playbook.yml 
```

[`main_playbook.yml`](./ansible/main_playbook.yml)

```bash
# Na ansible-target:
sudo apt install rng-tools

# Następnie na ubsrv:
ansible-playbook -i inventory.yml main_playbook.yml --ask-become-pass
```

```bash
ansible-galaxy init deploy_redis
ansible-playbook -i inventory.yml redis_playbook.yml --ask-become-pass
```

