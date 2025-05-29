# Sprawozdanie z laboratoriów: 8 - 11
- Przedmiot: DevOps
- Kierunek: Inżynieria Obliczeniowa
- Autor: Filip Rak
- Data rozpoczęcia: 29/04/2025
- Data zakończenia: 29/05/2025

## Przebieg Ćwiczeń
### Zajęcia 8: Instalacja zarządcy Ansible
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
#### Inwentaryzacja
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
#### Zdalne wywoływanie procedur
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
#### Zarządzanie stworzonym artefaktem
- Utworzono nową role poleceniem `ansible-galaxy init cjson`:
  - *Zrzut ekranu struktury katalogów*:

    ![Zrzut ekranu struktury katalogów](media/m10_struct.png)
- Przeniesiono pliki `cjson-1.0.0.rpm` oraz `cjson_test.c` do nowo powstałego katalogu `cjson/files`.
- Zmodyfikowano zawartość pliku `cjson/tasks/main.yml`. Następuje:
  - Utworzenie katalogu roboczego.
  - Kopiowanie plików `.rpm` oraz `.c`.
  - Instalacja wymaganych zależności.
  - Instalacja dockera.
  - Uruchomienia dockera.
  - Uruchomienie kontenera bazującego na systemie fedora:41.
  - Instalacja narzedzi do instalacji pakieru `rpm` i kompilacji programu.
  - Rozpakowanie pakietu `rpm`.
  - Utworzenie symbolicznego powiązania do plików biblioteki.
  - Kompilacja kodu źródłowego.
  - Uruchomienie programu.
  - Wydruk wyniku.

  *cjson/tasks/main.yml*:
  ```
    - name: Create directory /home/ansible/cjson
      become: yes
      file:
        path: /home/ansible/cjson
        state: directory
        mode: '0755'
    
    - name: Copy files to endpoint
      copy:
        src: "files/{{ item }}"
        dest: /home/ansible/cjson
      loop:
        - test_cjson.c
        - cjson-1.0.0.rpm
    
    - name: Install python3-requests
      become: yes
      dnf:
        name: python3-requests
        state: present
    
    - name: Install Docker
      become: yes
      dnf:
        name: docker
        state: present
    
    - name: Ensure Docker is started
      become: yes
      service:
        name: docker
        state: started
        enabled: true
    
    - name: Start fedora container
      community.docker.docker_container:
        name: cjson
        image: fedora:41
        state: started
        command: sleep infinity
        volumes:
          - /home/ansible/cjson:/mnt:z
    
    - name: Install gcc and tools
      community.docker.docker_container_exec:
        container: cjson
        command: dnf install -y gcc make rpm2cpio cpio
    
    - name: Unpack RPM directly to root filesystem
      community.docker.docker_container_exec:
        container: cjson
        command: bash -c "cd / && rpm2cpio /mnt/cjson-1.0.0.rpm | cpio -idmv"
    
    - name: Create symlink libcjson.so.1 → libcjson.so
      community.docker.docker_container_exec:
        container: cjson
        command: ln -sf /usr/lib/libcjson.so /usr/lib/libcjson.so.1
    
    - name: Compile source file
      community.docker.docker_container_exec:
        container: cjson
        command: gcc /mnt/test_cjson.c -o /mnt/program -lcjson
    
    - name: Run program
      community.docker.docker_container_exec:
        container: cjson
        command: bash -c "LD_LIBRARY_PATH=/usr/lib /mnt/program"
      register: result
    
    - name: Print the result of the program
      debug:
        var: result.stdout
  ```
- Utworzono nowy playbook `playbook-cjson.yaml`.
  ```
    - name: Install & Run cJSON
      hosts: Endpoints
      become: yes
      roles:
        - cjson
  ```
  
- Udało się uzyskać poprawny wynik. [Pełny wydruk](coursework/ansible_print1.txt)
  - *Poprawna kompilacja*:

    ![poprawna kompilacja](media/m11_finally.png)
    
### Zajęcia 9: Pliki odpowiedzi dla wdrożeń nienadzorowanych
- Z systemu fedora będącego hostem skopiowano plik `anaconda-ks.cfg` znajdującego się w katalogu `root/`.
- Plik ten został zapisany na gałęzi `FR417273` w repozytorium przedmiotu.
- W celu umożliwienia automatycznej instalacji biblioteki `cJSON` poprzez wykorzystanie pliku kikstart wykonano następujące kroki.
  - Zainstalowano i uruchomiono usługę `httpd` w celu hostowania artefaktu `.rpm`.
  - Dodano wyjątek do zapory sieciowej systemu pozwalający na połączenia na porcie `80`.
  - Umieszczono artefakt w katalogu `/var/html/cjson`.
     - *Zrzut ekranu z przygotowania artefaktu*

       ![Zrzut ekranu przygotowania artefaktu](media/m12_httpd.png)

  - Z oprogramowaniem `createrepo_c` utworzono repozytorium w powyższym katalogu.
    - *Zrzut ekranu tworzenia repozytroium*

      ![Zrzut ekranu tworznie repozytorium](media/m13_repo.png)

  - Dostępność artefaktu zweryfikowano poprzez instalacje repo na drugiej maszynie wirtualnej będacej w tej samej sieci.
  - *Zrzut ekranu instalacji oraz weryfikacji plików*

    ![Zrzut ekranu przeglądarki](media/m14_access.png)
- Wprowadzono zmiany w pliku `anaconda-ks.cfg`:
  - Dodano repozytoria internetowe fedory oraz wcześniej utworzone repozytorium `cJSON`.
  - Do instalowanych pakietów dodano pakiet `cJSON`.
  - Dodano użytkownika systemowego z widoczny hasłem.
  - Na root ustawiono hasło jawne w postaciu czystego tekstu.
  - Ustawiono hasło hosta systemu na `biscuit`
  - Zapewniono format dysku poleceniem `clearpart --all`.
  - Dodano sekcji post, w której zweryfikowano obecność zainstalowanego artefaktu.
  - Dodano restart systemu po zakończeniu instalacji.
 
  ```
    # Generated by Anaconda 41.35
    # Generated by pykickstart v3.58
    #version=DEVEL
    
    # Keyboard layouts
    keyboard --vckeymap=pl2 --xlayouts='pl','us'
    # System language
    lang en_US.UTF-8
    
    # Repositories
    url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
    repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64
    repo --name=cjson --baseurl=http://192.168.1.102/cjson/
    
    # Network information
    network  --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate --hostname=Biscuit
    
    # Install packages
    %packages
    @core
    cjson
    %end
    
    # Run the Setup Agent on first boot
    firstboot --enable
    
    # Generated using Blivet version 3.11.0
    ignoredisk --only-use=sda
    autopart
    
    # Partition clearing information
    clearpart --all --initlabel
    
    # System timezone
    timezone Europe/Warsaw --utc
    
    # Users
    rootpw --allow-ssh abc
    user --password=abc --plaintext --groups=wheel --name=filip-rak --gecos="Filip Rak"
    
    # Display
    %post --interpreter /bin/bash
    echo "==== Confirming installation of cJSON ===="
    ls /usr/include/cjson
    ls /usr/lib/libcjson*
    echo "==== End ===="
    %end
    
    # Reboot the system
    reboot
  ```

- Wykorzystano serwis [tinyurl.com](https://tinyurl.com) w celu skrócenia adresu pliku `anaconda-ks.cfg` znajdującego się w repozytorium przedmiotu.
- W trakcie instalacji systemu fedora na nowej maszynie wirtualnej, klikając klawisz `e`, przeszliśmy do linii poleceń kernela.
- Wewnątrz skryptu dodaliśmy parametr startowy jądra `inst.ks=tinyurl.com/34uj22hp`. Wykorzystując wcześniej wygenerowany [adres](https://tinyurl.com/34uj22hp).
    - *Zrzut ekranu z modyfikacji parametrów*
 
      ![Zrzut ekranu GRUB](media/m15_GRUB.png)
  
- Klikając kombinacje klawiszy `ctrl` + `x`, przeszliśmy do instalacji systemu, która była zautomatyzowana poprzez realizacje konfiguracji z pliku.
- Po zakończeniu instalacji i ponownym uruchomieniu systemu zweryfikowano obecność pakietu oraz plików, instalowanej podczas instalacji systemu, biblioteki `cJSON`.
  - *Weryfikacja obecności pakietu*:
 
    ![Zrzut ekranu weryfikacji obecności pakietu](media/m16_verify.png)

- Aby móc dalej zautomatyzować proces stawiania maszyny wirtualnej, w oprogramowaniu `VirtualBox`, koniecznnym było zmodyfikowanie obrazu `.iso` instalatora systemu, ze względu na to, że automatyczne wprowadzanie adresu do parametrów startowych, podczas instalacji, jest w tym oprogramowaniu praktycznie niemożliwe.
- W związku z tym podjęto następujące kroki aby zautomatyzować proces tworzenia maszyny z plikiem kickstart.
    - Rozpakowano obraz `.iso` i zmodyfikowano plik `boot/grub2/grub.cfg`.
        - Manulanie wprowadzono parametr `inst.ks=https://tinyurl.com/34uj22hp` do opcji `Install Fedora 41`.
        - Pozbyto się innych opcji instalacji / użytku.
        - Ustawiono domyślną opcje jako `set default="0"`.
        - Ustawiono `set timeout=0`, aby instalacja rozpoczynała się od razu.
        - Zmieniono label na "Fedora-KS"
        - *Zawarość pliku*:
          ```
            set default="0"
            
            function load_video {
              insmod all_video
            }
            
            load_video
            set gfxpayload=keep
            insmod gzio
            insmod part_gpt
            insmod ext2
            insmod chain
            
            set timeout=0
            ### END /etc/grub.d/00_header ###
            
            search --no-floppy --set=root -l 'Fedora-KS'
            
            ### BEGIN /etc/grub.d/10_linux ###
            menuentry 'Install Fedora 41' --class fedora --class gnu-linux --class gnu --class os {
            	linux /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=Fedora-E-dvd-x86_64-41 inst.ks=https://tinyurl.com/34uj22hp quiet
            	initrd /images/pxeboot/initrd.img
            }
          ```
    - Utworzono folder współdzielony pomiędzy maszyną wirtualną Fedora (cracker) a hostem Windows 10.
    - Pozowlono w ten sposób systemowi Fedora na no ponowne utworzenie bootowalnego `.iso` ze zmodyfikowanym konfigiem `gtub.cfg`.
        - Potrzebnym było zapotrzenie się w oprogramowanie `xorriso`, uzyskane przez `sudo dnf install xorriso`.
        - Następnie wykorzystując polecenie: `xorriso -as mkisofs -o ~/Fedora-Kickstart.iso -J -R -V "FedoraKS" .` utworzono nowy obraz `.iso`.
        - Następnie zauważono, że mozna było tak właściwie utworzyć obraz od razu w katalogu współdzielonym pomiędzy systemami, następnie przeniesiono do tego katalogu obraz.
        - *Zrzut ekranu z budowania obrazu na systemie Fedora*:
     
          ![Zrzut ekranu z pracy na systemie Fedora](media/m17_build-iso.png)

    - Następnie na hoście (Windows) napisano skrypt instalacyjny (Powershell Script), którego zadaniem było utworzenie maszyny z nowo utworzonego obrazu:
      ```
        # Vars
        $vmName     = "fedora-auto"
        $isoPath    = "D:\System ISOs\kickstart\burned\Fedora-Kickstart.iso"
        $diskFolder = "C:\Users\Filip\VirtualBox VMs\$vmName"
        $diskPath   = "$diskFolder\$vmName.vdi"
        $VBoxManage = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
        $memory     = 2048
        $cpus       = 1
        
        # Create VM
        & $VBoxManage createvm --name $vmName --ostype Fedora_64 --register
        
        # Config VM
        & $VBoxManage modifyvm $vmName --memory $memory --cpus $cpus --boot1 dvd --firmware efi
        
        # Create Disk
        New-Item -ItemType Directory -Path $diskFolder -Force | Out-Null
        & $VBoxManage createhd --filename "$diskPath" --size 2000
        
        # Add controllers
        & $VBoxManage storagectl $vmName --name "SATA Controller" --add sata --controller IntelAhci
        & $VBoxManage storageattach $vmName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$diskPath"
        
        & $VBoxManage storagectl $vmName --name "IDE Controller" --add ide
        & $VBoxManage storageattach $vmName --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$isoPath"
        
        # Start VM
        & $VBoxManage startvm $vmName --type gui
      ```
      - Skrypt uruchomiono prawym przyciskiem myszy, opcją `run with powershell`.
      - *Zrzut ekranu uruchomienia skryptu*:

        ![Zrzut ekranu z uruchomienia skryptu](media/m18_run.png)

      - Po uruchomieniu skrypt wykonał następujące czynności:
          - Utworzył nową maszynę.
          - Sonfigurował podstawowe ustawienia: CPU, pamięc itd.
          - Utworzył dysk do zapisu danych.
          - Utworzył kontolery `IDE` oraz `SATA` i prydzielił im plik `.iso` oraz `.vdi`.
          - Następnie uruchomił maszynę.

       - W okienku `Oracle VirtualBox Manager` w międzyczasie pojawiło się nowe wejście, reprezentujące utworzoną maszynę.
         - *Zrzut ekranu z okienka*:
        
         ![Zrzut ekranu z okienka](media/m19_effect.png)

       - Bootloader następnie przeszedł do automatycznego wykonywania wskazanego pliku kickstart.
         - *Zrzut ekranu instalacji*:
           
          ![Zrzut ekranu instalacji](media/m20_install.png)
### Zajęcia 10: Wdrażanie na zarządzalne kontenery: Kubernetes (1)
#### Instalacja Klasatra Kubernetes:
- Znaleziono implementacje stosu k8s, **minikube** pod [adresem](https://minikube.sigs.k8s.io/docs/start/) wskazanym w instrukcji.
- Pakiet **RPM** pobrano na systemie **Fedora** poleceniem: `curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm`.
- Nastepnie zainstalowano pakiet poleceniem: `sudo rpm -Uvh minikube-latest.x86_64.rpm`.
  - *Zrzut ekranu instalacji*:

  ![Zrzut ekranu instlacji](media/m21_install.png)

- Wykazano poziom bezpieczeństwa instalacji:
  - Kubernetes z Minikube ma domyślnie włączoną kontrolę dostępu. Potwierdzono to poleceniem: `minikube kubectl -- get clusterrolebindings`.
    - *Fragment wydruku*:
      
    ![Fragment wydruku](media/m22_cluster.png)

  - Kubernetes domyślnie wykorzystuje przestrzenie nazw do separacji zasobów. Możemy je zobaczyć poleceniem: `minikube kubectl -- get namespaces`.
    - *Wydruk*:

    ![Wydruk](media/m23_namespaces.png)

  - Komunikacja między komponentami klastra odbywa się za pomocą certyfikatów TLS. Można to potwierdzić, przeglądając certyfikaty w systemie Minikube. Wykorzystano polecenia `minikube ssh` oraz `ls /var/lib/minikube/certs/`
    - *Wydruk*:

    ![Wydruk](media/m24_ssh.png)
- Zainstalowano pakiet `kubectl` oraz utworzono alias `minikubectl`.
  - *Zrzut ekranu instalacji*:

  ![Zrzut ekranu instalacji](media/m25_kubectl.png)
- Uruchomiono **Kubernetes** poleceniami: `minikube start` i `minikubctl get nodes`.
- *Zrzut ekranu uruchomienia*:

![Zrzut ekranu uruchomienia](media/m26_start.png)

##### Porównanie wymagań Minikube z konfiguracją maszyny wirtualnej
W poniższej tabeli umieszczono wymagania **Minikube** porównane z zasobami udostępnionymi maszynie wirtualnej
| **Parametr**              | **Wymagania**                        | **Konfiguracja VM**                |
|---------------------------|--------------------------------------|------------------------------------|
| **CPU**                   | 2 CPU lub więcej                     | 4 CPU                              |
| **RAM**                   | 2 GB wolnej pamięci                  | 6144 MB (6 GB)                     |
| **Miejsce na dysku**      | 20 GB wolnej przestrzeni             | 40 GB                              |
| **Połączenie internetowe**| Wymagane                             | Dostępne                           |
| **VM Manager**            | VirtualBox, Docker, KVM itd.         | VirtualBox z KVM Paravirtualization|

Przydzielone zasoby spełniają minimalne wymagania oprogramowania. Nie odnotowano żadnych problemów, które mogłyby wynikać z niadekwatnej konfiguracji.

- Uruchomiono Dashboard poprzez polecenie: `minikube dashboard`.
  - *Zrzut erkanu uruchomienia*:

  ![Zrzut ekranu uruchomienia](media/m27_dashboard.png)
- Uzyskany adres skopiowano. Następnie, na hoście maszyny, wykorzystując polecenie: `ssh -L 8082:127.0.0.1:34907 filip-rak@192.168.1.102` przekierowano port na `8082`.
  - *Zrzut ekranu przekierowania*:
 
  ![Zrzut ekranu przekierowania](media/m28_forward.png)
- Następnie, na hoście, odwiedzono dashboard pod przekierowanym portem.
  - *Zrzut ekranu z przeglądarki*:

 ![Zrzut ekranu z przeglądarki](media/m29_browser.png)
- Zapoznano się z [koncepcjami](https://kubernetes.io/docs/concepts/) wprowadzanymi przez Kubernetes. Wybrane pozycje:
    - **Pod**: najmniejsza jednostka zawierająca jeden lub więcej kontenerów.
    - **Deployment**: obiekt zarządzający automatycznym tworzeniem i aktualizowaniem replik podów. Ułatwia wdrażanie aplikacji, aktualizacje bez przestojów, rollback i skalowanie.
    - **Service**: definiuje sposób komunikacji z aplikacjami działającymi w podach. Umożliwia stabilny dostęp do aplikacji niezależnie od zmian w konkretnych podach.
    - **ReplicaSet**: zapewnia określoną liczbę identycznych replik poda.
    - **Namespace**: Logicznie dzieli podział zasobów w klastrze.
    - **Node**: fizyczna lub wirtualna maszyna w klastrze, która uruchamia Pody.
 
#### Analiza posiadanego kontenera
Ze względu na to, że ówczensy projekt to biblioteka `cJSON`, zdecydowano się, na potrzeby zadania, na zmianę projektu na prostą stronę internetową w `nginx`.

- Utworzono prosty plik `index.html`
    ```
    <!DOCTYPE html>
    <html>
      <head><title>417273: nginx</title></head>
      <body>
        <h1>Windows->VM->minikube->nginx-custom</h1>
      </body>
    </html>
    ```
- Utworzono prosty plik `Dockerfile`, który kopiuje plik `index.html` do katalogu uzywanego przez `nginx`.
    ```
    FROM nginx:latest
    COPY index.html /usr/share/nginx/html/index.html
    ```

- Zbudowano obraz jako `nginx-custom`, poleceniem: `docker build -t nginx-custom .`.
    - *Zrzut ekranu budowania*:

      ![Zrzut ekranu budowania](media/m30_build.png)

- Obraz dodano do minikube poleceniem: `minikube image load nginx-custom`.

#### Uruchamianie oprogramowania
- Uruchomiono obraz poleceniem: `minikubctl run nginx-custom-pod --image=nginx-custom --port=80 --image-pull-policy=Never`.
  ` *Zrzut ekranu uruchamiania*:

  ![Zrzut ekranu uruchamiania](media/m31_run.png)
  *Zrzut ekranu w dashboardzie*:

  ![Zrzut ekranu w dashboardzie](media/m32_dash.png)
- Przekierowano port aplikacji, z portu 80 na port 8081, poleceniem: `minikubctl port-forward pod/nginx-custom-pod 8081:80`.
  *Zrzut ekranu przekierowania*:

  ![Zrzut ekranu przekierowania](media/m33_forward.png)
- Zrobiono tunel z maszyny wirtualnej na hosta poleceniem: `ssh -L 8083:127.0.0.1:8081 filip-rak@192.168.1.102`, przekierowując z portu 8081 na 8083.
  - *Zrzut ekranu przekierowania*:
  
  ![Zrzut ekranu przekierowania](media/m34_further.png)
- Udało się otworzyć witrynę `nginx` pod adresem `127.0.0.1` na porcie `8083`.
  - *Zrzut ekranu witryny*:

  ![Zrzut ekranu witryny](media/m35_8083.png)

#### Przekucie wdrożenia manualnego w plik wdrożenia (wprowadzenie)

- Przygotowano plik wdrożenia `nginx-deploy.yaml`:
    ```
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-custom-deployment
      labels:
        app: nginx-custom
    spec:
      replicas: 4
      selector:
        matchLabels:
          app: nginx-custom
      template:
        metadata:
          labels:
            app: nginx-custom
        spec:
          containers:
          - name: nginx-custom
            image: nginx-custom
            ports:
            - containerPort: 80
            imagePullPolicy: Never
    ```
- Następnie wdrożono plik poleceniem: `minikubctl apply -f nginx-deploy.yaml`.
- Zweryfikowano stan rollout'u poleceniem: `minikubctl rollout status deployment/nginx-custom-deployment`.
  - *Zrzut ekranu z wdrażania i weryfikacji rollout'u*:

  ![Zrzut ekranu z wdrażania i weryfikacji rollout'u](media/m36_apply.png)
- Wyeksponowano wzdrożenie jako serwis, poleceniem: `minikubctl expose deployment nginx-custom-deployment --type=ClusterIP --port=80 --name=nginx-custom-service`.
  - *Zrzut ekranu wydruku*:

  ![Zrzut ekranu wydruku](media/m37_expose.png)
- Poleceniem `minikubctl port-forward service/nginx-custom-service 8085:80` przekierowano port serwisu na `8085`.
  - *Zrzut ekranu z przekierowania*:

    ![Zrzut ekranu przekierowania](media/m38_forward.png)
- Następnie utworzono tunel z maszyny wirtualnej na hosta, poleceniem: `ssh -L 8085:127.0.0.1:8085 filip-rak@192.168.1.102` na porcie `8085`.
  - *Zrzut ekranu z tworzenia tunelu*:

    ![Zrzut ekranu z tworzenia tunelu](media/m39_tunnel.png)
- Następnie w przeglądarce zweryfikowano dostęp do serwisu pod adresem `127.0.0.1` na porcie `8085`.
  - *Zrzut ekranu z przeglądarki*:

  ![Zrzut ekranu z przeglądarki](media/m40_service.png)
  - *Zrzut ekranu z panelu dashboard*:

  ![Zrzut ekranu z panelu dashboard](media/m41_dash.png)
      
### Zajęcia 10: Wdrażanie na zarządzalne kontenery: Kubernetes (2)
#### Przygotowanie nowego obrazu
- Utworzono dwa takie same obrazy **nginx** otagowane wersjami `v1` i `v2`. poleceniami: `docker build -t custom-nginx:v1 .` i `docker build -t custom-nginx:v2 .`
```
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
```
- *Budowa jednego z obrazów*:

  ![Budowa jednego z obrazów](media/m42_build.png)

- Utworzono trzeci obraz ze zmodyfikowanym plikiem `Dockerfile.false` gdzie zapewniono iż obraz nie uruchomi się poprawnie.
```
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
CMD ["false"]
```
- Na jego podstawie zbudowano obraz w wersji trzeciej, poleceniem: `docker build -t custom-nginx:v3 .`.
    - *Zrut ekranu budowania*:
 
      ![Zrzut ekranu budowania](media/m43_false.png)

- Utworzone obrazy załadowano do minikube poleceniem `minikube image load <nazwa obrazu>`.
  - *Zrzut ekranu wczytania obrazów*:

    ![Wczytanie obrazów](media/m44_load.png)

#### Zmiany w deploymencie
- Wprowadzano szereg zmian w deploymencie, ustawiano ilość replik kolejno na: 8, 1, 0, 4
  - *Zrzut ekranu zmian*:
 
    ![Zrzut ekranu zmian](media/m45_rep.png)

- Zmiany weryfikowano w dashboard'zie. Poniżej kompilacja zrzutów ekranu przedstawiająca historie zmian.
    ![Zmiany](media/m53_pods.png)

    Zmiany replik nie definiują historii wdrożenia przez co historia rolloutu nie została zmieniona. Oba rekordy były w historii przed zmianą ilości replik.
- Upewniono się, że polecenie kubectl korzysta poprawnego kontekstu

    ![Kontekst](media/m46_context.png)
- **Zresetowano historie** poprzez usunięcie aktywnego deploymenta i ponowne jego wprowadzenie poleceniami: `kubectl delete deployment nginx-custom-deployment` i `kubectl apply -f nginx-deploy.yaml`.

    ![Zrzut ekranu](media/m47_reset.png)

- Przeprowadzono rollout nowej wersji obrazu i zweryfikowano powodzenie zmiany obrazu poleceniem `kubectl describe deployment nginx-custom-deployment | grep Image:`.
    ![Zrzut ekranu](media/m48_update.png)

  Jak widać w historii deploymentu pojawił się nowy rekord.

- Przeprowadzono rollout trzeciej, uszkodzonej, wersji obrazu.
    ![Zrzut ekranu](media/m49_v3.png)

- Zweryfikowano niepoprawność w dashboard'zie.
    ![Zrzut ekranu](media/m50_failure.png)

- Następnie przeprowadzono rollback do poprzedniej wersji (v2).
    ![Zrzut ekranu](media/m51_rollback.png)

- Stan replik po wszystkich zmianach:
    ![Zrzut ekranu](media/m52_replica.png)

- Napisano skrypt weryfikujący czy proces wdrażania zakończył się w ciągu 60 sekund
```
#!/bin/bash

DEPLOYMENT_NAME="nginx-custom-deployment"
NAMESPACE="default"
TIMEOUT=60

echo "Waiting for deployment '$DEPLOYMENT_NAME' (limit: ${TIMEOUT}s)..."

# Wait TIMEOUT for the deployment to happen
if kubectl rollout status deployment "$DEPLOYMENT_NAME" --timeout=${TIMEOUT}s -n "$NAMESPACE"; then
    echo "Deployment succesfull"
    exit 0
else
    echo "Deployment failed to happen in ${TIMEOUT}s"
    exit 1
fi
```

- Przykład użycia skryptu:
  ![Skrypt](media/m54_script.png)

#### Strategie wdrożenia
- Utworzono prosty serwis poleceniem `kubectl apply -f nginx-service.yaml`.
    
    ```
    apiVersion: v1
    kind: Service
    metadata:
      name: nginx-service
    spec:
      selector:
        app: nginx-custom
      ports:
        - port: 80
          targetPort: 80
      type: NodePort
    ```
    
    ![Zrzut ekranu](media/m55_service.png)

    - *Perpsektywa z dashbordu*:
 
      ![Zrzut ekranu](media/m56_dashboard.png)

- Przetestowano różne strategie wdrożen:
    - Recreate.
        - W tej strategii kubernetes usuwa wszystkie pody zanim uruchomi nowe co oznacza, że pojawi się pewien downtime
        - Plik `nginx-deploy-recreate.yaml`
          ```
            apiVersion: apps/v1
            kind: Deployment
            metadata:
              name: nginx-custom-deployment
              labels:
                app: nginx-custom
            spec:
              replicas: 4
              strategy:
                type: Recreate
              selector:
                matchLabels:
                  app: nginx-custom
              template:
                metadata:
                  labels:
                    app: nginx-custom
                spec:
                  containers:
                  - name: nginx-custom
                    image: custom-nginx:v1
                    ports:
                    - containerPort: 80
                    imagePullPolicy: Never
          ```
        - *Połączone zrzuty ekranu strategii recreate*:
         
         ![Recreate](media/m57_recreate.png)

- RollingUpdate. Stopniowa aktualizacja podów co pozwala na uniknięcie braku dostępu do usługi.
    - `maxUnavailable: 2` -> maksymalnie dwa pody będa niedostępne.
    - `maxSurge: 20%` -> maksymalnie może zostać tyle tymczasowych podów. 20% z 4 = 0.8, zaokrąglane w górę czyli 1.
    - Plik `nginx-deploy-rollingupdate.yaml`
      ```
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: nginx-custom-deployment
          labels:
            app: nginx-custom
        spec:
          replicas: 4
          strategy:
            type: RollingUpdate
            rollingUpdate:
              maxUnavailable: 2
              maxSurge: 20%
          selector:
            matchLabels:
              app: nginx-custom
          template:
            metadata:
              labels:
                app: nginx-custom
            spec:
              containers:
              - name: nginx-custom
                image: custom-nginx:v2
                ports:
                - containerPort: 80
                imagePullPolicy: Never   
      ```
      
        - *Połączone zrzuty ekranu strategii rolling update*:
         
         ![Recreate](media/m58_rolling.png)

- Canary. Pozwala na bezpośrednią kontrole nad procesem poprzez utworzenie dwóch niezależnych zestawów podów na obu wersjach aplikacji. `Service` z odpowiednim selektorem etykiet umożliwia równoczesne kierowanie ruchu do obu wersji.
    - Do skalowania użyto polecenia `kubectl scale deployment <nazwa deploymentu> --replicas=<liczba replik>`. Gdzie stopniowo zwiększano liczbe replik w deploymencie *v1* i zmniejszano tą liczbę w deploymencie *v2*.
    - Plik `nginx-deploy-canary-v1.yaml` obsługujący wersje oryginalną:
      ```
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: nginx-canary-v1
          labels:
            app: nginx-custom
        spec:
          replicas: 3
          selector:
            matchLabels:
              app: nginx-custom
              version: v1
          template:
            metadata:
              labels:
                app: nginx-custom
                version: v1
            spec:
              containers:
              - name: nginx-custom
                image: custom-nginx:v1
                ports:
                - containerPort: 80
                imagePullPolicy: Never
      ```
      
    - Plik `nginx-deploy-canary-v2.yaml` obsługujący nową wersje:
      ```
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: nginx-canary-v2
          labels:
            app: nginx-custom
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: nginx-custom
              version: v2
          template:
            metadata:
              labels:
                app: nginx-custom
                version: v2
            spec:
              containers:
              - name: nginx-custom
                image: custom-nginx:v2
                ports:
                - containerPort: 80
                imagePullPolicy: Never
      ```

        - *Połączone zrzuty ekranu strategii canary*:
         
         ![Recreate](media/m59_canary.png)

##### Porównanie strategii
| Strategia       | Opis działania                                                                 | Zalety                                      | Wady                                       |
|-----------------|----------------------------------------------------------------------------------|---------------------------------------------|--------------------------------------------|
| Recreate        | Usuwa wszystkie stare Pody, a dopiero potem uruchamia nowe                     | Prosta, szybka                              | Wprowadza downtime |
| Rolling Update  | Stopniowo podmienia stare Pody na nowe                                          | Bez przerw w działaniu, automatyczna        | Mniej kontroli nad procesem                 |
| Canary          | Uruchamia równolegle dwa Deploymenty i rozdziela ruch ręcznie     | Duża kontrola, możliwość testu nowej wersji przed pełną migracją | Wymaga ręcznego skalowania i zarządzania   |



## Wykorzystanie Sztucznej Intelginecji w ramach zajęć
- W ramach zajęć korzystano z modelu `GPT-4o` w celach konsultacji związanych z teorią składnią oraz weryfikacji spełnienia założeń zadań.
- Sztuczna inteligencja była zaopatrzona w ogólny kontekst poleceń oraz środowiska.
- Odpowiedzi AI nie były weryfikowane, zapytany o źródła, GPT by je zwyczajnie wymyślił :)
- Bot za każdym razem musiał wszystko wyjaśnić (w przypadku sugerowanych poleceń będą to m.i.n wszystkie opcje i działanie) oraz przedstawić swój tok 'myślenia'.
- Nie kopiowano niczego od SI. Wszelkie zwrócone polecenia były intepretowane i ręcznie pisane z uwagą na własne potrzeby i preferencje.
