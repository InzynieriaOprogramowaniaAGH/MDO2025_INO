# Sprawozdanie 3 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

- **Przedmiot: DevOps**
- **Kierunek: Inżynieria Obliczeniowa**
- **Autor: Adam Borek**
- **Grupa 1**

---

## Ansible

### 1. Instalacja zarządcy Ansible

#### Przygotowanie `ansible-target`

Utworzyłem nową maszynę wirtualną z tym samym systemem operacyjnym co główny host, czyli `Fedora 41`. Przydzieliłem jej 20 GB przestrzeni dyskowej — co może być wartością z zapasem, jednak dzięki zastosowaniu dynamicznego przydzielania przestrzeni nie zajmuje ona całości od razu.\
Podczas instalacji utworzyłem użytkownika `ansible` oraz ustawiłem nazwę komputera (hostname) na `ansible-target`.

![Utworzona druga maszyna wirtualna `ansible-target`](zrzuty8/zrzut_ekranu1.png)

Na maszynie zainstalowałem wymagane oprogramowanie poleceniem:

```bash
sudo dnf install -y tar openssh-server
```

![Instalacja tar i openssh-server na `ansible-target`](zrzuty8/zrzut_ekranu2.png)

Po ukończeniu konfiguracji wykonałem migawkę maszyny w VirtualBoxie, aby w razie potrzeby móc przywrócić ją do tego stanu.

#### Instalacja ansible

Na głównej maszynie (`fedora`) zainstalowałem Ansible, korzystając z oficjalnych repozytoriów Fedory, za pomocą prostego polecenia:

```bash
sudo dnf install -y ansible
```

![Instalacja ansible_1](zrzuty8/zrzut_ekranu3_1.png)

![Instalacja ansible_2](zrzuty8/zrzut_ekranu3_2.png)

![Instalacja ansible_3](zrzuty8/zrzut_ekranu3_3.png)

#### Ustanowienie połączenia

W celu umożliwienia komunikacji między maszynami po nazwach, przypisałem adresy IP w pliku `/etc/hosts`:

```
192.168.56.104 ansible-target
192.168.56.101 fedora
```

![Zmiana w /etc/hosts i pingowanie](zrzuty8/zrzut_ekranu4.png)

Następnie utworzyłem klucz SSH, dedykowany dla Ansible:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ansible -C "ansible key"
```

![Utworzenie klucza ssh](zrzuty8/zrzut_ekranu5.png)

Za pomocą `ssh-copy-id` przesłałem klucz publiczny na maszynę `ansible-target`, aby umożliwić bezhasłowe logowanie:

```bash
ssh-copy-id -i ~/.ssh/id_ansible.pub ansible@ansible-target
```

![Skopiowanie klucza ssh](zrzuty8/zrzut_ekranu6.png)

### Inwentaryzacja

#### Sprawdzenie łączności

Zanim przeszedłem do dalszej części zadania, musiałem rozwiązać problem związany z połączeniem SSH. Z nieznanego mi powodu system nie wykrywał przesłanego wcześniej klucza SSH (prawdopodobnie przez to, że posiadam kilka kluczy, z czego ten „główny”, zabezpieczony hasłem, nie był tu używany).

Aby to naprawić, zmodyfikowałem plik konfiguracyjny `~/.ssh/config`, wskazując tam bezpośrednio właściwy klucz oraz nazwy hostów:

`.ssh/config:`

```
Host ansible-target
    HostName ansible-target
    User ansible
    IdentityFile ~/.ssh/id_ansible
Host fedora
    HostName fedora
    User aborek
    IdentityFile ~/.ssh/id_ansible
```

#### Utworzenie pliku inwentaaryzacji

Po potwierdzeniu, że połączenie między maszynami działa poprawnie, utworzyłem plik inwentaryzacji zgodnie z oficjalną [dokumentacją Ansible](https://docs.ansible.com/ansible/latest/getting_started/get_started_inventory.html).

W katalogu `ansible_quickstart` utworzyłem plik `inventory.ini`, w którym — zgodnie z zaleceniami prowadzącego — zdefiniowałem dwie grupy: `Orchestrators` oraz `Endpoints`, przypisując do nich odpowiednio nazwy maszyn wirtualnych:

`inventory.ini`:

```csharp
[Orchestrators]
fedora

[Endpoints]
ansible-target
```

Po zapisaniu pliku, wykonałem testowe zapytanie `ping` do wszystkich maszyn z użyciem polecenia:

```bash
ansible all -i inventory.ini -m ping
```

Co zakończyło się sukcesem:

![Ping ansible](zrzuty8/zrzut_ekranu7.png)

### Zdalne wywoływanie procedur

Korzystając z oficjalnej [instrukcji](https://docs.ansible.com/ansible/latest/getting_started/get_started_playbook.html), przeszedłem do utworzenia własnego playbooka w Ansible.

#### Prosty playbook

Zgodnie z krokami poradnika przygotowałem pierwszy testowy plik playbook.yaml w katalogu `ansible_quickstart`. Jego zadaniem było wysłanie żądania ping do wszystkich maszyn oraz wypisanie prostego komunikatu:

`playbook.yaml`:

```yaml
- name: My first play
  hosts: all
  become: true
  tasks:
   - name: Ping my hosts
     ansible.builtin.ping:

   - name: Print message
     ansible.builtin.debug:
       msg: Hello world
```

Polecenie użyte do uruchomienia playbooka:

```bash
asnible-playbook -i inventory.ini playbook.yaml
```

![Uruchomienie playbooka](zrzuty8/zrzut_ekranu8.png)

#### Pełny playbook

Powyższy playbook był jedynie testem poprawności połączenia oraz działania Ansible. Docelowy playbook miał zawierać:
- wysłanie żadania `ping` do wszystkich maszyn,
- skopiowanie pliku inwentaryzacji na maszynę `Endpoint`,
- aktualizację pakietów systemowych,
- restart usług `sshd` i `rngd`.

Pełny `playbook.yaml`:

```yaml
- name: My first play
  hosts: all
  become: true
  tasks:
   - name: Ping my hosts
     ansible.builtin.ping:

   - name: Copy inventory to Endpoint
     ansible.builtin.copy:
      src: inventory.ini
      dest: /home/ansible/inventory_copied
     when: "'ansible-target' in inventory_hostname"

   - name: Ping after copy
     ansible.builtin.ping:

   - name: Update system packages
     ansible.builtin.dnf:
      name: "*"
      state: latest
     when: "'ansible-target' in inventory_hostname"

   - name: Restart sshd
     ansible.builtin.service:
      name: sshd
      state: restarted
     when: "'ansible-target' in inventory_hostname"

   - name: Restart rngd
     ansible.builtin.service:
      name: rngd
      state: restarted
     ignore_errors: yes 
     when: "'ansible-target' in inventory_hostname"
```

Uruchomienie playbooka wyglądało analogicznie:

```bash
asnible-playbook -i inventory.ini playbook.yaml
```

![Uruchomienie playbooka](zrzuty8/zrzut_ekranu9.png)

> Usługa `rngd` nie została zrestartowana, ponieważ nie była zainstalowana na maszynie `ansible-target`.

> [Pełne logi](ansible_quickstart/playbook.log)

### Zarządzanie stworzonym artefaktem

W tej części zadania zainstalowałem bibliotekę przygotowaną na wcześniejszych zajęciach wewnątrz kontenera uruchomionego na maszynie `ansible-target`.\
Cały proces został zautomatyzowany przy użyciu playbooka Ansible oraz struktury [ról](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html), utworzonej za pomocą `ansible-galaxy`.

#### Utworzenie nowej roli

Korzystając z narzędzia `ansible-galaxy`, utworzyłem nową rolę o nazwie `cjson` w katalogu `ansible_quickstart`:

```bash
ansible-galaxy init cjson
```

![Utworzenie roli cjson](zrzuty8/zrzut_ekranu10.png)

Po utworzeniu struktury roli, do katalogu `cjson/files` przekopiowałem pliki `cjson.rpm` oraz `main.c` z poprzednich zajęć.

Następnie przeszedłem do modyfikacji pliku `main.yaml` znajdującego się w `cjson/tasks/`. Zadaniem tego pliku było:
- przesłanie artefaktów na `ansible-target`,
- instalacja Dockera i jego zależności,
- uruchomienie kontenera z systemem Fedora 41,
- instalacja biblioteki z pliku `.rpm`,
- kompilacja programu w C,
- oraz uruchomienie programu i pobranie wyniku.

`cjson/tasks/main.yaml`:

```yaml
---
- name: Create artifacts directory
  become: yes
  file:
    path: /home/ansible/cjson
    state: directory
    owner: ansible
    group: ansible
    mode: '0755'

- name: Copy artifacts to target
  copy:
    src: "{{ item }}"
    dest: /home/ansible/cjson/
    mode: '0644'
  loop:
    - files/cjson.rpm
    - files/main.c

- name: Install python3-requests
  ansible.builtin.dnf:
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

- name: Add ansible to docker group
  user:
    name: ansible
    groups: docker
    append: true

- name: Start fedora container
  community.docker.docker_container:
    name: cjson
    image: fedora:41
    state: started
    command: sleep infinity
    volumes:
      - /home/ansible/cjson:/tmp:z

- name: Install gcc, cjson and tools
  community.docker.docker_container_exec:
    container: cjson
    command: dnf install -y gcc make /tmp/cjson.rpm

- name: Compile source file
  community.docker.docker_container_exec:
    container: cjson
    command: gcc -o /tmp/example /tmp/main.c -lcjson

- name: Run program
  community.docker.docker_container_exec:
    container: cjson
    command: bash -c "LD_LIBRARY_PATH=/usr/local/lib64 /tmp/example"
  register: result

- name: Print the result of the program
  debug:
    var: result.stdout

```

#### Uruchomienie roli przez playbook

Do wykonania roli przygotowałem osobny playbook `playbook-cjson.yaml`:

`playbook-cjson.yaml`:

```yaml
- name: Deploy CJSON in container
  hosts: ansible-target
  become: true
  roles:
    - cjson
```

Uruchomienie playbooka:

```bash
asnible-playbook -i inventory.ini playbook-cjson.yaml
```

![Uruchomienie playbooka cjson](zrzuty8/zrzut_ekranu11.png)

> [Pełne logi z wykonania znajdują się tutaj](ansible_quickstart/playbook-cjson.log)

## Kickstart

### Instalacja systemu Fedora 41

Do wykonania tego zadania nie musiałem ponownie instalować Fedory, ponieważ korzystałem z niej jako systemu głównego (hosta) od początku trwania przedmiotu.

#### Przygotowanie pliku `anaconda-ks.cfg`

Będąc zalogowanym jako administrator, skopiowałem plik odpowiedzi znajdujący się w systemie pod ścieżką `/root/anaconda-ks.cfg` do folderu `Sprawozdanie3`, aby mógł być łatwo udostępniony za pomocą GitHuba.

Następnie zmodyfikowałem plik, dodając informacje o repozytoriach:

```kickstart
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64
```

Tak przygotowany plik został wypchnięty na GitHuba.

#### Instalacja feodry z kickstarta

Z racji korzystania z maszyn wirtualnych VirtualBox postanowiłem skrócić długi adres URL do pliku Kickstart z GitHuba za pomocą serwisu [TinyURL](https://tinyurl.com).

Ostateczny link:
```arduino
https://tinyurl.com/aborek
```

> **Uwaga**: VirtualBox nie pozwala na wklejanie linków na etapie instalatora — stąd konieczność użycia skracacza.

Podczas tworzenia nowej maszyny wirtualnej, w menu startowym instalatora kliknąłem `e`, aby wejść do trybu edycji poleceń GRUB i dopisałem dodatkowy parametr instalacyjny:

```ini
inst.ks=https://tinyurl.com/aborek
```

![Dodatkowe parametry](zrzuty9/zrzut_ekranu1.png)

Instalator uruchomił się dalej z interfejsem graficznym — jednak większość pól była wygaszona (nieedytowalna), ponieważ wartości zostały już określone w pliku `kickstart`.

![Ekran wyboru](zrzuty9/zrzut_ekranu2.png)

Po chwili rozpoczęła się właściwa instalacja:

![Instalacja](zrzuty9/zrzut_ekranu3.png)

Instalacja przebiegła pomyślnie. Po jej zakończeniu należało ponownie uruchomić system (`reboot` nie był jeszcze automatyczny):

![Po instalacji](zrzuty9/zrzut_ekranu4.png)

Po restarcie zalogowałem się do systemu — dane logowania były takie same jak na oryginalnej Fedorze, co potwierdza, że instalacja przebiegła poprawnie:

![Gotowy system](zrzuty9/zrzut_ekranu5.png)

#### Rozszerzenie pliku odpowiedzi o dodatkowe opcje

W kolejnym kroku rozszerzyłem `anaconda-ks.cfg`, dodając:

- `reboot` — aby system automatycznie uruchomił się ponownie po instalacji,
- `network --hostname=fedora.test` — aby nadać maszynie nazwę hosta,
- `clearpart --all --initlabel` — aby usunąć wszystkie partycje przed instalacją,
- `autopart` — aby automatycznie utworzyć nowe partycje.

Zaktualizowany plik ponownie wypchnąłem na GitHuba. Proces instalacji przeprowadziłem jeszcze raz, tym razem reboot wykonał się automatycznie.

Po zalogowaniu się do systemu sprawdziłem nazwę hosta:

```bash
hostname
```

Wynik:

```
feodra.test
```

![Ustawiona nazwa hosta](zrzuty9/zrzut_ekranu6.png)

### Instalacja biblioteki `cjson` w wykorzystaniem pliku odpowiedzi

#### Przygotowanie `cjson.rpm`

Na potrzeby testów zmieniłem nazwę pliku `cjson.rpm` na `mycjson.rpm`, aby uniknąć konfliktu nazw i ryzyka przypadkowego pobrania innej wersji biblioteki.

#### Utworzenie repozytorium HTTP

W celu udostępnienia biblioteki w formie repozytorium YUM, zainstalowałem serwer Apache oraz narzędzie `createrepo` poleceniem:

```bash
sudo dnf install -y httpd createrepo
```

![Instalacja httpd i createrepo](zrzuty9/zrzut_ekranu7.png)

Następnie utworzyłem katalog:

```bash
sudo mkdir -p /var/www/html/myrepo
sudo cp mycjson.rpm /var/www/html/myrepo/
cd /var/www/html/myrepo
createrepo .
```

![Utworzenie repozytorium](zrzuty9/zrzut_ekranu8.png)

Aby umożliwić dostęp HTTP, dodałem reguły do firewalla:

```bash
sudo firewall-cmd --permanent -add-service=http
sudo firewall-cmd --reload
```

![Wyłączenie firewalla](zrzuty9/zrzut_ekranu9.png)

Następnie w pliku `/etc/httpd/conf/httpd.conf` zmodyfikowałem konfigurację serwera Apache, aby umożliwić poprawne linkowanie zawartości repozytorium.

![Naprawa linkowania](zrzuty9/zrzut_ekranu10.png)

Po tych krokach repozytorium było dostępne pod adresem:

```arduino
http://192.168.56.101/myrepo/
```

![Gotowe repozytorium](zrzuty9/zrzut_ekranu11.png)

#### Modyfikacja pliku Kickstart

W pliku anaconda-ks.cfg dodałem własne repozytorium:

```kickstart
repo --name=myrepo --baseurl=http://192.168.56.101/myrepo/
```

W sekcji %packages wskazałem pakiety do zainstalowania:

```kickstart
%packages
@^custom-environment
mycjson
gcc
glibc
curl
%end
```

Dodatkowo utworzyłem sekcję `%post`, która odpowiadała za kompilację i uruchomienie programu po zakończeniu instalacji:

```
%post
mkdir -p /opt/example

chown aborek:aborek /opt/example

# Pobierz plik main.c z GitHuba
curl -o /opt/example/main.c https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/refs/heads/AB416965/INO/GCL01/AB416965/Sprawozdanie2/pipeline/main.c

# Skrypt uruchamiany po zalogowaniu (tekstowo)
cat << 'EOF' > /etc/profile.d/run_example.sh
#!/bin/bash
if [ ! -f /opt/example/.compiled ]; then
    echo "Kompiluję program z main.c" >> /opt/example/autostart.log
    gcc /opt/example/main.c -o /opt/example/example -lcjson -I/usr/local/include/cjson -L/usr/local/lib64
    if [ -f /opt/example/example ]; then
        echo "Uruchamiam program:" >> /opt/example/autostart.log
        LD_LIBRARY_PATH=/usr/local/lib64 /opt/example/example >> /opt/example/autostart.log 2>&1
    else
        echo "Kompilacja nie powiodła się" >> /opt/example/autostart.log
    fi
    touch /opt/example/.compiled
fi
EOF

chmod +x /etc/profile.d/run_example.sh
%end
```

#### Weryfikacja po instalacji

Po zakończeniu instalacji zalogowałem się na swoje konto i sprawdziłem log działania skryptu:

```bash
cat /opt/example/autostart.log
```

![Logi uruchomienia](zrzuty9/zrzut_ekranu12.png)

Następnie zweryfikowałem ścieżki plików zainstalowanych przez pakiet:

```bash
rpm -ql mycjson
```

![Lokalizacja plików zainstalowanej biblioteki](zrzuty9/zrzut_ekranu13.png)

Ostatecznie uruchomiłem program ręcznie:

```bash
LD_LIBRARY_PATH=/usr/local/lib64 /opt/example/example
```

![Uruchomienie programu](zrzuty9/zrzut_ekranu14.png)

## Wdrażanie na zarządzalne kontenery: Kubernetes

### Instalacja klastra Kubernetesa

#### Instalacja minikube

Instalacja Minikube została przeprowadzona zgodnie z oficjalną dokumentacją, dostępną pod adresem: [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download).

Wybrałem wersję dla architektury x86-64 systemu Linux, w formacie `.rpm`.

Instalacja nie wymagała zmian systemowych poza dodaniem ścieżki do zmiennych środowiskowych.\
Nie zaobserwałem modyfikacji polityk bezpieczeństwa systemu, reguł firewalla ani nieautoryzowanej aktywności sieciowej po stronie instalatora.

![Pobranie i instalacja minikube](zrzuty10/zrzut_ekranu1.png)

#### Instalacja kubectl

Podążając za oficjalną instrukcją Minikube, przeszedłem do dokumentacji Kubernetes dotyczącej instalacji `kubectl`: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

Zdecydowałem się na instalację binarną, rozpoczynając od pobrania pliku poleceniem:

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

![Pobranie kubectl](zrzuty10/zrzut_ekranu2.png)

Następnie pobrałem plik kontrolny do weryfikacji integralności binarki i sprawdziłem jej poprawność:

![Pobranie pliku kontrolnego dla kubectl i sprawdzenie poprawności](zrzuty10/zrzut_ekranu3.png)

Po pozytywnej weryfikacji, zainstalowałem `kubectl` poleceniem:

```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

![Instalacja kubectl](zrzuty10/zrzut_ekranu4.png)

#### Uruchomienie minikube

Do uruchomienia klastra Kubernetes wykorzystałem polecenie:

```
minikube start
```

![Uruchomienie minikube](zrzuty10/zrzut_ekranu5.png)

Minikube uruchomił się w kontenerze Docker:

![Minikube w kontenerze](zrzuty10/zrzut_ekranu6.png)

#### Wymagania sprzętowe i ich spełnienie

Zgodnie z dokumentacją Minikube, minimalne wymagania to:

```
2 CPUs or more
2GB of free memory
20GB of free disk space
Internet connection
Container or virtual machine manager, such as: Docker, QEMU, Hyperkit, Hyper-V, KVM, Parallels, Podman, VirtualBox, or VMware Fusion/Workstation
```

Mój system spełnia wszystkie powyższe wymagania.\
Minikube działa w środowisku Docker, który posłużył jako driver kontenerowy.\
Nie było konieczności zmiany ustawień BIOS ani wprowadzania modyfikacji sprzętowych.

#### Uruchomienie dashboarda

Do uruchomienia dashboarda wykorzystałem polecenie:

```bash
minikube dashboard
```

W terminalu pojawił się adres URL, który następnie wkleiłem do przeglądarki, aby uzyskać dostęp do panelu.

![Uruchomienie dashboarda](zrzuty10/zrzut_ekranu7.png)

![Dashboard w przeglądarce](zrzuty10/zrzut_ekranu8.png)

#### Podstawowe obiekty Kubernetes

- **Pod** – najmniejsza jednostka wykonawcza w Kubernetesie. Uruchamia jeden lub więcej kontenerów, które współdzielą sieć i system plików.
- **Deployment** – obiekt zarządzający tworzeniem i utrzymywaniem replik podów. Pozwala na aktualizacje, rollbacki oraz skalowanie aplikacji.
- **Service** – abstrahuje dostęp do podów, zapewniając stabilny adres IP i nazwę DNS. Umożliwia komunikację wewnętrzną i zewnętrzną w klastrze.

### Analiza posiadanego kontenera

#### Przygotowanie kontenera

W poprzednich zadaniach pracowałem z biblioteką `cJSON`, którą budowałem i pakowałem do archiwum. Efektem końcowym był artefakt w formacie `.rpm`.
Na potrzeby tego zadania zdecydowałem się wykorzystać aplikację NGINX z drobną modyfikacją własnej konfiguracji.

W tym celu utworzyłem katalog `my-nginx`, w którym umieściłem plik `nginx.conf` oraz `Dockerfile`.

Plik `Dockerfile` bazuje na oficjalnym obrazie `nginx:alpine` i podmienia domyślną konfigurację serwera na moją własną.

Plik `nginx.conf`:

```yaml
events {}

http {
    server {
        listen 80;
        location / {
            return 200 'Hello from my custom NGINX config!\n';
        }
    }
}
```

Plik `Dockerfile`:

```Dockerfile
FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
```

![Zbudowanie własnego NGINX-a](zrzuty10/zrzut_ekranu9.png)

Następnie zbudowałem obraz i uruchomiłem go lokalnie z przekierowaniem portu 8080, aby sprawdzić poprawność działania:

```bash
docker run -d -p 8080:80 --name test-nginx my-nginx-custom
```

![Uruchomienie kontenera z NGINX-em](zrzuty10/zrzut_ekranu10.png)

Działanie konfiguracji potwierdziłem poleceniem:

```bash
curl localhost:8080
```

![Test konfiguracji poprzez curl](zrzuty10/zrzut_ekranu11.png)

#### Umieszczenie obrazu na Docker Hubie

Po pomyślnym teście lokalnym przystąpiłem do przygotowania obrazu do wdrożenia w środowisku Kubernetes.\
Aby móc z niego skorzystać w klastrze, opublikowałem go w publicznym rejestrze Docker Hub.

W pierwszym kroku nadałem mu odpowiedni tag (`frigzer/my-nginx-custom`) z użyciem polecenia `docker tag`:

```bash
docker tag my-nginx-custom frigzer/my-nginx/custom
```

Następnie przesłałem obraz do Docker Hub za pomocą polecenia `docker push`:

```bash
docker push frigzer/my-nginx-custom
```

![Umieszczenie obrazu na Docker Hubie](zrzuty10/zrzut_ekranu12.png)

Na koniec potwierdziłem obecność obrazu w moim repozytorium, logując się na Docker Hub przez przeglądarkę:

![Potwierdzenie publikacji obrazu](zrzuty10/zrzut_ekranu13.png)

Dzięki tak przygotowanemu i opublikowanemu obrazowi mogłem przejść do jego wdrożenia w klastrze Kubernetes.

### Uruchamianie oprogramowania

#### Deployment aplikacji w klastrze Kubernetes

Na podstawie oficjalnej dokumentacji Minikube przygotowałem wdrożenie własnej aplikacji (NGINX z niestandardową konfiguracją) do klastra Kubernetes.
W tym celu użyłem polecenia:

```bash
kubectl create deployment my-nginx-deploy --image=frigzer/my-nginex-custom
```

Następnie utworzyłem obiekt `Service` typu `LoadBalancer`, który umożliwia zewnętrzny dostęp do aplikacji na porcie 80:

```bash
kubectl expose deployment my-nginx-deploy --type=LoadBalancer --port=80
```

![Umieszczenie kontenera na klastrze](zrzuty10/zrzut_ekranu14.png)

W panelu Dashboard Kubernetes pojawił się odpowiedni Deployment. (Na liście widoczny jest również oryginalny NGINX, używany wcześniej do testów lokalnych.)

![Deployment widoczny w dashboardzie](zrzuty10/zrzut_ekranu15.png)

Sprawdzenie działania poda:

```bash
kubectl get pods
```

![Sprawdzenie działania poda](zrzuty10/zrzut_ekranu18.png)

#### Przekierowanie portu

Aby umożliwić dostęp do aplikacji z poziomu hosta, przekierowałem lokalny port 8080 na port 80 w Podzie:

```bash
kubectl port-forward pod/my-nginx-deploy-8f58cfc94-vxfnt 8080:80
```

![Komenda przekierowania i widoczna obsługa połączeń](zrzuty10/zrzut_ekranu16.png)

Po wpisaniu `http://localhost:8080` w przeglądarce pojawia się mój własny komunikat serwowany przez aplikację – `"Hello from my custom NGINX config!"`.

> Nie jest to kontener lokalny – wcześniej usunąłem lokalną wersję po przesłaniu obrazu do Docker Hub.\
> Aplikacja działa w pełni w środowisku Kubernetes.

![Mój NGINX widoczny w przeglądarce](zrzuty10/zrzut_ekranu17.png)

### Przekucie wdrożenia manualnego w plik wdrożenia (wprowadzenie)

#### Wdrożenie Deploymentu

Korzystając z oficjalnej dokumentacji dotyczącej [Deploymentów w Kubernetesie](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) utworzyłem plik `nginx-deployment.yaml`, który zawiera konfigurację dla aplikacji NGINX.

Plik `nginx-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

Do uruchomienia konfiguracji użyłem polecenia `kubectl apply`, które umożliwia deklaratywne wdrażanie lub aktualizowanie zasobów w klastrze Kubernetes:

```bash
kubectl apply -f nginx-deployment.yaml
```

Następnie sprawdziłem stan wdrożenia komendą:

```bash
kubectl apply -f deployment/nginx-deployment
```

![Przygotowanie wdrożenia deploymentu](zrzuty10/zrzut_ekranu19.png)

W Dashboardzie Kubernetes potwierdziłem, że Deployment został poprawnie utworzony i że widoczna jest pełna liczba replik:

![Potwierdzenie deploymentu w dashboardzie](zrzuty10/zrzut_ekranu20.png)

#### Wdrożenie service

Analogicznie do wcześniejszych etapów, utworzyłem plik `nginx-service.yaml`, który definiuje obiekt `Service` typu `LoadBalancer`, eksponujący aplikację na porcie 80. Zastosowano etykiety zgodne z Deploymentem (`app: nginx`), aby poprawnie powiązać usługę z uruchomionymi podami.

Plik `nginx-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  labels:
    app: nginx
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
```

Polecenie użyte do wdrożenia:

```bash
kubectl apply -f nginx-service.yaml
```

![Wdrożenie service](zrzuty10/zrzut_ekranu21.png)

Po wdrożeniu sprawdziłem obecność i konfigurację usługi w Dashboardzie:

![Widoczne service w dashboardzie](zrzuty10/zrzut_ekranu22.png)

#### Przekierowanie portu i test aplikacji

Aby umożliwić dostęp do aplikacji z przeglądarki, wykonałem przekierowanie portu lokalnego 8080 do portu 80 w usłudze:

```bash
kubectl port-forward service/nginx-service 8080:80
```

![Przekierowanie portu](zrzuty10/zrzut_ekranu23.png)

Po wpisaniu `localhost:8080` w przeglądarce, otrzymałem stronę domyślną serwera NGINX, co potwierdza, że aplikacja działa prawidłowo w klastrze Kubernetes:

![Localhost:8080 w przeglądarce](zrzuty10/zrzut_ekranu24.png)

#### Podsumowanie

W ramach tego etapu wdrożenie aplikacji zostało w pełni opisane za pomocą plików YAML i uruchomione w sposób deklaratywny z wykorzystaniem `kubectl apply`.\
Dzięki temu możliwe jest łatwe powtórzenie, modyfikowanie i wersjonowanie konfiguracji — co jest kluczowym aspektem pracy z Kubernetesem i zgodne z podejściem „Infrastructure as Code”.