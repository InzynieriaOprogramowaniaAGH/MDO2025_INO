Jakub Tyliński, Grupa 8, 416081

**Ansible**

Zajęcia poświecone narzędziu jakim jest Ansible rozpoczołem od przygotowania drugiej VM na tym samym obrazie co moja maszyna główna. Aby obie VM-ki się widziały dodałem kartę sieciową - sieć NAT z utworzoną wcześniej siecią NAT z zakresem IP 10.2.0.X/24. W celu uniknięcią problemów na na nowej VM-ce zmieniłem przypisany adres automatycznie adres IP. W przeciwnym wypadku dwie VM-ki w tej samej sieci miały by dokładnie ten sam adres - 10.2.0.15!

![alt text](image1.png)

Dalej zainstalowałem na nowej VM oprogramowanie tar oraz serwer OpenSSH:

![alt text](image2.png)

Następnie na maszynie głównej (mojaVM) dodałem dedykowanego użytkownika ansible. Nadałem mu od razu prawa sudo, co będzie przydatne przy uruchamianiu playbooków:

![alt text](image3.png)

Dalej zrobiłem migawkę utworzonej maszyny:

![alt text](image4.png)

Na maszynie głównej zainstalowałem oprogramowanie Ansible:

![alt text](image5.png)

Dalej wygenerowałem na maszynie głównej parę kluczy i przekazałem na maszynę ansible-taregt klucz publiczny w celu łączenia się po ssh bez konieczności podawania hasła

![alt text](image8.png)

![alt text](image9.png)

Ustawieniłem nazwy komputerów z wykorzystaniem hostnamectl:

![alt text](image6.png)

![alt text](image7.png)

W pliku etc/hosts dodałem adresy IP z nazwą DNS co umożliwiło łączenie się po nazwie

![alt text](image10.png)

![alt text](image11.png)

![alt text](image12.png)

Dalej stworzyłem plik inventory, w którym zdefiniowałem hosty, na których Ansible będzie reazlizował zdefiniowane później taski. W pliku inventory znalazły się dwie sekcje:
Orchestrators - gdzie umieszczamy hosty z których puszczamy ansiblowe playbooki, a więc w sekcji tej umieściłem moją główną maszynę - mojaVM
Endpoints - tutaj zwyczajowo ląduje reszta hostów, a wiec w sekcji tej umieściłem ansible-target

```
---
Orchestrators:
  hosts:
    mojaVM:
      ansible_connection: local

Endpoints:
  hosts:
    ansible-target:
      ansible_hosts: 10.0.2.4
      ansible_user: ansible
```

Definicja ansible-connection: local pozwoliła w łatwy wsposób wskazać, że dany playbook ma zostać wykonany dokładnie na tej maszynie, na której został uruchomiony

W dalszej części wysłałem ping do wszystkich maszyn w sposób inline:

![alt text](image13.png)

**Playbooki**

1. Playbook wysyłający żądanie ping do wszystkich maszyn

```
---
- name: Endpoint management
  hosts: Endpoints, Orchestrators
  become: true
  tasks:
    - name: Ping request
      ping:
```

![alt text](image14.png)

2. Playbook kopiujacy plik inventory na maszynę ansible-target

```
---
- name: Endpoint management
  hosts: Endpoints
  become: true
  tasks:
    - name: Coping inventory file
      copy:
        src: /home/jakub/MDO2025_INO/ITE/GCL08/JT416081/Sprawozdanie_3/Ansible/inventory/hosts.yaml
        dest: /tmp/hosts.yaml
        owner: ansible
        group: ansible
        mode: "0644"
```

![alt text](image15.png)

Jak widać przy drugim puszczeniu tego samego playbook task "Coping inventory file" zostaje pominięty ze wzgledu na fakt, że plik ten został już skopiowany do danej lokalizacji podczas pierwszego uruchomienia

3. Playbook aktualizujący pakiety

```
---
- name: Endpoint management
  hosts: Endpoints
  become: true
  tasks:
    - name: Package update
      dnf:
        name: "*"
        state: latest
        update_only: yes

![alt text](image16.png)
```

4. Playbook restartujący usługi sshd oraz rngd

```
---
- name: Endpoint management
  hosts: Endpoints
  become: true
  tasks:
    - name: Restart ssh
      service:
        name: sshd
        state: restarted
     
    - name: Restart RNG
      service:
        name: rngd
        state: restarted
```

![alt text](image17.png)

Próba uruchomienia tego samego playbooka, ale podczas wyłączenia na ansible-target serwera SSH. 

![alt text](image18.png)

![alt text](image19.png)

Próba oczywiście zakończona niepowedzeniem, ze wzgledu na fakt, iż Ansible łączy się z hostami właśnie z ssh

**Playbook z artefkatem**

Pracę rozpoczołem od wygenerowania struktury roli za pomocą ansible-galaxy:

![alt text](image20.png)

