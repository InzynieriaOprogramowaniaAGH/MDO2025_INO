# LAB8 ANSIBLE

## 1. Instalacja zarządcy Ansible
1.1 Utwórzyłem drugą maszynę wirtualną:
System: Taki sam jak na maszynie głównej (np. Fedora Server, Ubuntu Server)
Nazwa hosta: ansible-target (u mnie początkowo ansible ale potem zmieniłem na ansible-target)
```sh
sudo hostnamectl set-hostname ansible-target
```
1.2 Zainstalowałem wymagane pakiety
```sh
sudo dnf install tar openssh-server -y
```
1.3 Utwórzyłem użytkownika ansible

## 2. Instalacja Ansible na maszynie głównej
2.1 Instalacja Ansible
```sh
sudo dnf install ansible -y
```
w naszym przypadku już mamy ansible więc tylko sprawdzamy
```sh
ansible --version
```
2.2 Klucze
Kolejny krok to generowanie klucz lecz ponownie my już klucze mamy także robimy tylko
```sh
ssh-copy-id ansible@ansible
```
2.3 Sprawdź połączenie:
```sh
ssh ansible@ansible
```
2.4 Sprawdzenie połaczenia poprzez ping
```sh
ping ansible-target
```
## 3 Inwentaryzacja systemów
3.1 Ustawienia hostname:
Na każdej maszynie:
```sh
hostnamectl set-hostname NAZWA
```
3.2 Wprowadź wpisy DNS / hostów:
Na każdej maszynie edytuj /etc/hosts:
   
3.3 Skopiowanie klucza na nowej maszynie
```sh
ssh-copy-id rusekdawid@server
```
3.4 Podłączenie się z głownej maszyny na nową 
```sh
ssh rusekdawid@server
```
3.5 Plik inwentaryzacji (inventory.ini):
```sh
[Orchestrators]
orchestrator

[Endpoints]
ansible-target
```
## 4. Zdalne wywoływanie procedur
4.1 Ping playbook:
```sh
# ping.yml
- hosts: all
  tasks:
    - name: Test ping
      ping:
```
```sh
ansible-playbook -i inventory.ini ping.yml
```
4.2 Skopiuj plik:
```sh
# copy_inventory.yml
- hosts: Endpoints
  tasks:
    - name: Copy inventory
      copy:
        src: ./inventory.ini
        dest: /home/ansible/inventory.ini
```
4.3 Aktualizacja pakietów:
```sh
# update.yml
- hosts: Endpoints
  become: true
  tasks:
    - name: Update packages
      package:
        name: "*"
        state: latest
```
4.4 Restart usług:
```sh
# restart_services.yml
- hosts: Endpoints
  become: true
  tasks:
    - name: Restart sshd
      service:
        name: sshd
        state: restarted

    - name: Restart rngd
      service:
        name: rngd
        state: restarted
```
