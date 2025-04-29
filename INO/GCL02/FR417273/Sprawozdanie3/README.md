# Sprawozdanie z laboratoriów: Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible
- Przedmiot: DevOps
- Kierunek: Inżynieria Obliczeniowa
- Autor: Filip Rak
- Data: 29/04/2025

## Przebieg Ćwiczeń
### Instalacja zarządcy Ansible
- Utworzono nową maszynę wirtualną oparta na tym samym systemie co host - `Fedora 41`.
- Na nowej maszynie pobrano oprogramowanie `tar` oraz `sshd`, poleceniem `sudo dnf install tar sshd`.
    - *Zrzut ekranu instalacji*:
 
      ![Zrzut ekranu instalacji](media/m1_dnf.png)
- Nowej maszynie ustawiono nazwę hosta: `ansible-target` oraz utworzono użytkownika `ansible`.
    - *Zrzut ekranu nazw użytkownika i hosta*:
 
      ![Zrzut ekranu nazw użytkownika i hosta](media/m2_hostname.png)
- Na maszynie głównej pobrano oprogramowanie `ansible`, zgodnie z instruckjami z [poradnika](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-fedora-linux). Wykorzystano polecenie `sudo dnf install ansible`.
  - *Zrzut ekranu instalacji*:

    ![Zrzut ekranu instalacji](media/m3_ansible.png)
### Inwentaryzacja
- Na maszynie głównej, w pliku `/etc/hosts` zmapowano adresy `IP` obu maszyn do nazw `cracker` dla maszyny głównej i `cookie` dla nowej maszyny.
  - *Zrzut ekranu zawartości pliku i wywołania polecenia ping*:

    ![Zrzut ekranu zawartości pliku i wywołania polecenia ping](media/m4_hosts.png)
- Z perspektywy maszyny głównej (`cracker`), wymieniono klucz ssh z obiema maszynami: `cookie` i `cracker`.
    - *Zrzut ekranu wymiany klucza cracker z cracker*:
 
      ![Zrzut ekranu wymiany klucza cracker z cracker](media/m5_ssh-copy.png)
- W obecnym stanie połączenie przez `SSH` nie wymaga żadnego hasła.
    - *Połączenie z cracker do cookie*:

      ![Połączenie z cracker do cookie](media/m6_ssh.png)
- Dla zachowania spójności zmieniono nazwę hosta maszyny głównej z `fedora` na `cracker`. **Kilka następnych screenów jest jeszcze ze starą nazwą hosta**.
- Utworzono prosty plik inwentaryzacji `inventory.ini`:
    ```
    [Orchestrators]
    cracker
    
    [Endpoints]
    cookie ansible_user=ansible
    ```
- Wysłano żadanie `ping` wszystkim maszynom.
  - *Zrzut ekranu ping*:

    ![Zrzut ekranu ping](media/m7_ping.png)
### Zdalne wywoływanie procedur
- Utworzono playbook `playbook.yaml`, którego zadaniem jest:
    - Wysłanie żadania `ping` do wszystkich maszyn.
    - Kopia pliku `inventory.ini` na maszyny `Endpoints`.
    - Ponowna operacja `ping`.
    - Aktualizacja pakietów w systemie
    - Restart usług `sshd` oraz `rngd`.
    
    ```
    - name: Ping all devices
      hosts: all
      tasks:
        - name: Ping
          ansible.builtin.ping:
    
    - name: Copy inventory to endpoints
      hosts: Endpoints
      tasks:
        - name: Copy inventory.ini
          ansible.builtin.copy:
            src: ./inventory.ini
            dest: /tmp/inventory.ini
    
    - name: Secondary Ping
      hosts: all
      tasks:
        - name: Ping after copy
          ansible.builtin.ping:
    
    - name: Update packages
      hosts: all
      become: yes
      tasks:
        - name: Update packages
          ansible.builtin.dnf:
            name: "*"
            state: latest
    
    - name: Restart services
      hosts: all
      become: yes
      tasks:
        - name: Restart SSHD
          ansible.builtin.service:
            name: sshd
            state: restarted
    
        - name: Restart RNGD
          ansible.builtin.service:
            name: rngd
            state: restarted
          ignore_errors: yes
    ```
    - Niektóre z zadania wymagały użycia uprawnień administratorskich do realizacji, z tego względu użyto funkcji eskalacji uprawnień `become`, umożliwiającej tymczasowe podniesienie uprawnień użytkownika do poziomu administracyjnego `root`. Ponadto, ze względu na brak obecności usługi `rngd` na obu komputerach, zastosowano mechanizm `ignore_errors` w ostatnim zadaniu playbooka.
    - Do egzekucji zadań użyto polecenia `ansible-playbook playbook.yaml --ask-become-pass` z opcją pozwalającą na podanie hasła administracyjnego.
      - *Uzyskany wynik*:
        
        ![Uzyskany wynik](media/m8_playbook.png)
    - Ponownie spróbowano wykonać playbook, tym razem jednak bez połączenia do maszyny `cookie`.
    - Niestety pierwsze próby okazały się zatrzymywać wykonanie playbooka na nieokreślony czas, ze względu na to utworzono podstawowy plik konfiguracyjny `ansible.cfg`, w którym ograniczono czas oczekiwania na nawiązanie połączenia `ssh` do 5 sekund.
      ```
      [defaults]
      inventory = inventory.ini
      timeout = 5
      gathering = smart
      forks = 5
        
      [ssh_connection]
       ssh_args = -o ConnectTimeout=5
      ```
      - Następnie wykonano playbook poleceniem `ansible-playbook playbook.yaml --ask-become-pass`.
        - *Uzyskany wynik*:

          ![Uzyskany wynik](media/m9_bookplay.png)
