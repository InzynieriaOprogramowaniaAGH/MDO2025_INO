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

