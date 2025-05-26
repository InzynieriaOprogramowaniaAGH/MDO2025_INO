# Kacper Mazur, 415588 - Inzynieria Obliczeniowa, GCL02
## Laboratorium 8 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible
### 1️⃣ Instalacja zarządcy Ansible:

Działania zaczynam od utworzenia nowej maszyny wirtualnej w Hyper-V. Insatluje na niej system fedora 41-1.4 (tzn ten sam system co na maszynie głównej) oraz konieczne pakiety - tar oraz ssh.

```bash
sudo dnf -y install tar openssh-server
```

Następnie sprawdzamy status usługi ssh (jeśli nie uruchomiona to uruchamiamy) oraz adres ip maszyny:

```bash
systemctl status sshd
#uruchomienie ssh
systemctl enable sshd
ip a
```

Wydruk w moim przypadku był następujący - widać, iż usługa uruchomiona:

![ssh-stat](./ansible/img/ssh_check.png)

Na maszynie głównej wykonujemy instalacje ansible oraz generujemy nowy klucz ssh (najlepiej ustawić bez hasła):

```bash
sudo dnf -y install ansible
#przykładowe polecenie generacji klucza
ssh-keygen -t ed25519 -C "ansible@fedora-master"
```

Następnie wymieniamy klucz publiczny z maszyną podrzedną (target):

```bash
ssh-copy-id ansible@ansible-target
#jeśli nie pdoziała to odwołujemy sie wcześniej zapisanym adresem ip maszyny target
ssh-copy-id ansible@192.168._._
```

W wyniku otrzymuje:

![ssh_share](./ansible/img/share_key.png)

Następnie łączymy się protokołem ssh z target-em - pierwsze połączenie może wymagać podania hasła, ale kolejne już nie.

![ssh-lacze](./ansible/img/bez_hasla.png)

Tożsamo tworzę druga maszynę wirtualną, którą nazywam ansible-target2 - **UWAGA** jeśli zapomnieliśmy podczas instalacji zmienić nazwę maszyny na inną możemy to wykoną w konsoli:

```bash
sudo hostnamectl set-hostname ansible-target2
```

### 2️⃣ Inwentaryzacja

Po zapewnieniu, iż każda z maszyn ma nadaną swoją nazwę - w moim przypadku master ma nazwe ansible-master, a pozostałe maszyny to ansible-target oraz ansible-target2, piszemy plik inwentaryzacjyny określajacy role w komunikacji przy wykorzystaniu ansible-playbook:

```ini
[orchestrators]
ansible-master ansible_host=ansible-master ansible_connection=local
[endpoints]
ansible-target ansible_host=ansible-target ansible_user=ansible ansible_become=true
ansible-target2 ansible_host=192.168.0.155 ansible_user=ansible2 ansible_become=true
```

przy ansible.host mozemy zarówno użyte nazwy, jak i adresy ip maszyn - w wypadku ansible-master można użyć jeszcze adres localhost (127.0.0.1), **ale jest to ryzykowne przedsięwzięcie, ponieważ każda maszyna ma ten sam adres localhost**. Kolejnym krokiem jest wysłanie żądania ping na wszytskie maszyny - wykonujemy to poniższym poleceniem:

```bash
ansible -i inventory.ini -m ping
```

W wyniku otrzymamy:

![ping_pong](./ansible/img/ping_pong.png)

Jak widzimy wszystkie maszyny zwróciły success.

### Zdalne wywoływanie procedur

Najpierw napiszemy, krótki playbook .yml w celu wykonania pingu na wszytskie maszyny:

```yml
- name: Ping all machines
  hosts: all
  tasks:
    - name: Ping test
      ansible.builtin.ping:
```

Przeanalizujmy po kolei co sie w takim pliku dzieje:
- name: Ping all machines
 jest nagłówekiem playbooka, który będzie wyświetlany w konsoli podczas uruchamiania

- hosts: all - to specjalna grupa, która oznacza: wszystkie hosty z inventory. Możemy tu podać też inne grupy, np. Endpoints, Orchestrators, lub pojedynczy host.

- tasks: - rozpoczyna sekcję z listą zadań do wykonania (lista - name: i modułów).
 - name: Ping test  
 ansible.builtin.ping: - sekcja opisująca działanie zadania. Pierwsze to nazwa zadania, która wypisze sie w konsoli, natomiast drugie to komenda w nasztm wypadku jest to standardowy ping maszyn.

W wyniku działania polecenia 
```bash 
ansible-playbook -i inventory.ini ping.yml
```
otrzymamy:

![ping](./ansible/img/ping.png)

Kolejny playbook będzie kopiował na maszyny target plik inventory.ini z maszyny master, aktualizował pobrane pakiety oraz resetował usługi sshd i rngd:

```yml
- name: Zarządzanie maszynami końcowymi
  hosts: endpoints
  gather_facts: false
  become: true #uzyskiwanie uprawnień root
  tasks:
    - name: Ping test
      ansible.builtin.ping:
    - name: Skopiuj inventory.ini na hosta
      copy:
        src: inventory.ini
        dest: /home/{{ ansible_user }}/inventory.ini
        mode: '0644'
    - name: Aktualizuj pakiety systemowe
      package:
        name: "*"
        state: latest
      ignore_errors: yes
    - name: Restart sshd
      service:
        name: sshd
        state: restarted
      ignore_errors: yes
    - name: Restart rngd
      service:
        name: rngd
        state: restarted
      ignore_errors: yes
```

Jak widzimy w sekcji all zmieniamy teraz cele komunikacyjne na endpoints - oznacza to, że ansible wywoła swoje działanie wyłącznie na endpointach (w moim przypadku ansible-target i ansible-target2). Przeanalizujmy dalsze części:

| **Zadanie**                           | **Znaczenie**                                                                                                                                                           |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `copy:` <br> `src: inventory.ini`<br>`dest: /home/{{ansible_user}}/inventory.ini` <br> `mode: 0644` | kopiuje plik `inventory.ini` z maszyny master na endpointy do katalogów domowych; plik jest dostępny do odczytu przez wszystkich, modyfikowalny tylko przez właściciela przypisywanie dostępu tożsamo jak w chmod |
| `package:` <br>`name:"*"`<br>`state: latest`     | aktualizuje **wszystkie pakiety systemowe** do najnowszych wersji dostępnych w repozytoriach; pełny update systemu                                                      |
| `service:`<br> `name: sshd`<br>`state: restarted` | restartuje usługę **sshd** (serwer SSH), np. po zmianach konfiguracji; zapewnia, że logowanie zdalne działa zgodnie z aktualnymi ustawieniami                           |
| `service:`<br> `name: rngd`<br>`state: restarted` | restartuje usługę **rngd**, która dba o źródło entropii systemowej; szczególnie ważna na maszynach wirtualnych, gdzie brakuje losowości                                 |

Wywołujemy tożsamo do poprzedniego playbooka:

```bash
ansible-playbook -i inventory.ini ping_and_manage.yml
```

W wyniku:

![ping_man](./ansible/img/deploy_and_manage.png)

Następnie na obu mawszynach wirtualnych sprawdzamy poleceniem ls czy pojawił się on:

![is_in](./ansible/img/inventory_on_target.png)

Wykonujemy jeszcze raz playbook:

![ping_man2](./ansible/img/deploy_and_manage2.png)

Widzimy różnice między oboma wywołaniami — za pierwszym razem wystąpiły aż 4 operacje oznaczone jako `changed`, natomiast za drugim tylko 2. Ansible najpierw sprawdza, czy operacje muszą zostać wykonane (np. plik .ini już istnieje, a pakiety systemowe są zaktualizowane do najnowszych wersji), dlatego nie wykonuje ich ponownie.

Spróbujmy jeszcze przeprowadzić komunikacje z niedostępną maszyną - zasymulować to możemy na kilka sposobów:

- wyłączenie usługi ssh:
```bash
systemctl stop sshd
```  

- odłączenie karty sieciowej maszyny:  
w ustawieniach maszyny w Hyper-V przechodzimy do sekcji `Karta sieciowa` po czym sekcji `Przełącznik wirtualny` wybieramy opcje `Brak połączenia`

- wyłączenie maszyny:  
na logikę nie możemy się połączyć z maszyna, która nie działa.

Następnie możemy wywołać dowolny z playbooków - ja wywołałem ten tylko z ping-iem

![wyl_ssh](./ansible/img/wyl_ssh.png)

### 3️⃣ Zarządzanie stworzonym artefaktem

Wynikiem mojego pipeline-u na Jenkinsie jest plik .tar zawierający logi, przykładowy plik .js na ktorym możemy uruchomić testy oraz pliki konieczne do działania biblioteki chalk-pipe. Dlatego mój playbook zarządzający artefaktem będzie na endpointy pobierał artefakt z ostatniego udanego pipeline-u, rozpakowywał go i uruchamiał plik example.js - dodatkowo będzie wydruki przekierowywał do plików logów, ale również wyswietlał w konsoli master. Poniżej napisany przeze mnie plik deploy_collect.yml:

```yml
- name: Deploy aplikacji z artefaktu .tar.gz z Jenkinsa
  hosts: endpoints
  become: true
  vars: #zmienne używane w playbook-u
    artifact_url: "http://192.168.0.139:8080/job/Done_Pipe_Chalk/lastSuccessfulBuild/artifact/INO/GCL02/KM415588/Sprawozdanie_2/artifact_result.tar.gz"
    deploy_dir: /home/{{ ansible_user }}/artifact/chalk-pipe
  tasks:
    - name: Upewnij się, że katalog docelowy istnieje
      file:
        path: "{{ deploy_dir }}"
        state: directory
        mode: '0755'
    - name: Pobierz artefakt z Jenkinsa
      get_url:
        url: "{{ artifact_url }}"
        dest: "/tmp/artifact_result.tar.gz"
        mode: '0644'
    - name: Rozpakuj artefakt
      unarchive:
        src: "/tmp/artifact_result.tar.gz"
        dest: "{{ deploy_dir }}"
        remote_src: yes

    - name: Uruchom aplikację (przykładowy plik example.js)
      shell: "node {{ deploy_dir }}/lib/chalk-pipe/example.js > /tmp/app_output.log 2>&1 &"
      args:
        chdir: "{{ deploy_dir }}"
      async: 15
      poll: 0
    - name: Poczekaj chwilę na wygenerowanie logu
      wait_for:
        path: /tmp/app_output.log
        state: present
        timeout: 10
    - name: Odczytaj log działania aplikacji
      shell: cat /tmp/app_output.log
      register: app_output
      changed_when: false
    - name: Wyświetl wynik działania aplikacji
      debug:
        var: app_output.stdout_lines
    - name: Wyświetl zawartość katalogu
      command: ls -l {{ deploy_dir }}
      register: ls_output
    - name: Pokaż zawartość
      debug:
        var: ls_output.stdout_lines
```

| **Zadanie (skrót YAML)** | **Opis działania** |
|---------------------------|--------------------|
| `file:`<br>`path:{{ deploy_dir }}, state=directory, mode='0755'` | Tworzy katalog docelowy dla aplikacji, jeśli nie istnieje. Ustawia uprawnienia `rwxr-xr-x`. |
| `get_url:`<br>`url={{ artifact_url }}, dest=/tmp/artifact_result.tar.gz` | Pobiera artefakt `.tar.gz` z Jenkinsa na zdalną maszynę do katalogu `/tmp`. Ustawia uprawnienia na `rw-r--r--`. |
| `unarchive:`<br>`src=/tmp/artifact_result.tar.gz, dest={{ deploy_dir }}` | Rozpakowuje pobrany artefakt do wcześniej utworzonego katalogu. `remote_src: yes` oznacza, że plik znajduje się już na maszynie docelowej. |
| `shell:`<br>`node {{ deploy_dir }}/lib/chalk-pipe/example.js > /tmp/app_output.log &`<br>`async: 15, poll: 0` | Uruchamia aplikację w tle. Wyjście przekierowywane jest do pliku `/tmp/app_output.log`. Dzięki `async` i `poll: 0` Ansible kontynuuje działanie bez oczekiwania na zakończenie zadania. |
| `wait_for:`<br>`path=/tmp/app_output.log, state=present, timeout=10` | Czeka maksymalnie 10 sekund, aż plik logu aplikacji zostanie utworzony. Zapobiega próbie jego odczytu, gdy jeszcze nie istnieje. |
| `shell:`<br>`cat /tmp/app_output.log`<br>`register: app_output, changed_when: false` | Odczytuje zawartość pliku logu i zapisuje ją do zmiennej `app_output`. Flaga `changed_when: false` informuje, że zadanie nie zmienia stanu systemu. |
| `debug:`<br>`var: app_output.stdout_lines` | Wyświetla zawartość logu aplikacji linia po linii (dokładnie to zapisanej zmiennej app_output). Pozwala zweryfikować, czy aplikacja działa poprawnie. |
| `command:`<br>`ls -l {{ deploy_dir }}`<br>`register: ls_output` | Wykonuje listowanie plików w katalogu aplikacji i zapisuje wynik do zmiennej `ls_output`. |
| `debug:`<br>`var: ls_output.stdout_lines` | Wyświetla zawartość katalogu aplikacji – pliki i ich uprawnienia. Umożliwia weryfikację struktury wdrożenia. |

Wynik uruchomienia:

![wyn_ans](./ansible/img/deploy_collect.png)

Jak widzimy wszystko przechodzi prawidłowo. jeśli przejdizmey do wybranego z endpointów i uruchomimy plik example.js (`node example.js`) otrzymamy:

![deploy_target](./ansible/img/deploy_target.png)

## Laboratorium 9 - Pliki odpowiedzi dla wdrożeń nienadzorowanych

Na początku należy dostać się do pliku konfiguracyjnego wygenerowanego przez system podczas instalacji. Można to wykonać na dowolnej maszynie - ja wybrałem do tego moją główną maszynę. Plik anaconda_ks.cfg znajduje się w katalogu root, do którego nie możemy wejść, ale przy użyciu sudo lub zalogowaniu na root możemy wyświetlać pliki które się tam znajdują. Możemy więc wykonać przykładowe polecenie:

```bash
sudo less /root/anaconda_ks.cfg
```

Wyświetli się nam poniższy plik (w repo origina_ks.cfg):

```cfg
# Generated by Anaconda 41.35
# Generated by pykickstart v3.58
#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang pl_PL.UTF-8

%packages
@^custom-environment

%end

# Run the Setup Agent on first boot
firstboot --enable
# Do not configure the X Window System
skipx

# Generated using Blivet version 3.11.0
ignoredisk --only-use=sda
# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
autopart
# Partition clearing information
clearpart --all --initlabel --drives=sda

# System timezone
timezone Europe/Warsaw --utc

# Root password
rootpw --iscrypted $y$j9T$D/mD9mTlViOdMffZYKfWmAxA$H.FZzHKGrLqqbG116VQ59Ui48i7gKwsrCprV8L9DzF9
user --groups=wheel --name=kmazur --password=$y$j9T$ig8mzamRlSafku6bcoOJDbYc$VKfk57IziXfdvbkVOga5auS4bPL2BeZlbHryzFTJAm3 --iscrypted --gecos="Kacper Mazur"
```

Pochylmy się najpierw nad każdą z sekcji:

| **Sekcja**                                   | **Opis**                                                                                                                                                            |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `# Generated by Anaconda...`                 | Informacja, że plik został wygenerowany automatycznie przez instalator graficzny (Anaconda).                                                                        |
| `keyboard --vckeymap=us --xlayouts='us'`     | Ustawia układ klawiatury: fizyczny (`vckeymap`) i graficzny (`xlayouts`) – w tym przypadku: **US**.                                                                 |
| `lang pl_PL.UTF-8`                           | Język systemu: **polski (pl\_PL)** z kodowaniem UTF-8.                                                                                                              |
| `%packages` / `%end`                         | Lista grup i pakietów do zainstalowania. Tu: grupa środowiskowa `@^custom-environment`, czyli niestandardowe środowisko bazowe.                                     |
| `firstboot --enable`                         | Włącza „firstboot” – kreator ustawień, który uruchomi się po pierwszym starcie systemu (chyba że go później wyłączysz).                                             |
| `skipx`                                      | Pomija instalację systemu graficznego X11 (czyli system bez GUI – tryb tekstowy).                                                                                   |
| `ignoredisk --only-use=sda`                  | Instalator ma ignorować wszystkie inne dyski oprócz `/dev/sda`.                                                                                                     |
| `bootloader --location=mbr --boot-drive=sda` | Instalacja bootloadera GRUB w głównym rekordzie rozruchowym dysku `/dev/sda`.                                                                                       |
| `autopart`                                   | Automatyczne partycjonowanie – bez ręcznego ustawiania partycji.                                                                                                    |
| `clearpart --all --initlabel --drives=sda`   | Usuwa wszystkie istniejące partycje na `/dev/sda`, tworzy nową etykietę partycji (ostrzeżenie: **czyści cały dysk**!).                                              |
| `timezone Europe/Warsaw --utc`               | Ustawia strefę czasową: **Warszawa (UTC)**.                                                                                                                         |
| `rootpw --iscrypted ...`                     | Hasło root w postaci zaszyfrowanej (`--iscrypted`).                                                                                                                 |
| `user --groups=wheel --name=kmazur ...`      | Tworzy użytkownika `kmazur`, dodaje go do grupy `wheel` (czyli umożliwia `sudo`), ustawia jego hasło (również zaszyfrowane) oraz pełną nazwę użytkownika (`gecos`). |

Możemy teraz po przesłaniu tego plika na repo i zapisaniu linku do pliku raw, możemy uruchomić instalacje, a kiedy włącza nam się ekran GRUB klikamy klawisz e i dopisujemy `inst.ks=link_do_pliku_raw` - przykładowo:

![grub](./09/img/GRUB.png)

Po uruchomieniu instalacji klikając `CTRL+X` włącza się instalator ale i tak musimy przejść przez okno graficzne instalacji, a po wykonaniu się instalacji musimy kliknąć na końcu przycisk `reboot`. Możemy jednak dopisać do pliku .cfg komendy, które spowodują uruchomienie terminala instalacji (a nie okna graficznego) oraz komende powodującą automatyczny `reboot`.

```cfg
...
version=...
text #dopisek uruchamiający terminal

...
...

reboot #komenda resetu po instalacji
```

Przez `...` rozumiem już znajdujązy się tam kod do którego dopisuję tylko te dwie linijki. Po ponownym uruchomieniu instalacji nie uruchomi się okno graficzne, a po zainstalowaniu systemu wykona się automtyczne ponowne uruchomienie. Kolejnym zadaniem jest dostanie się do artefaktu pipeline-u i uruchomienie aplikacji - w tym celu posłużymy się sekcją `%post`. Dodatkowo musimy zadbać aby aplikacja uruchamiała się w dowolny sposób po uruchomieniu systemu. Najpierw skupmy się jakie pakiety są konieczne w przypadku mojego pipeline-u:

- tar - do rozpakowania artefaktu
- wget - do pobrania artefaktu
- nodejs - do uruchomienia przykładowego programu example.js

Dołączamy je w sekcji `%packages` - prezentować się będzie ona następująco:

```cfg
%packages
@^custom-environment
wget
tar
nodejs
%end
```

Dalej w sekcji `%post` musimy napisać logike koniecznego działania. Po kolei musimy wykonać następujące czynności:

- utworzenie folderu w ścieżce `/usr/local/bin/`, do którego rozpakujemy nasz artefakt
- pobranie artefaktu przy użyciu `wget`
- rozpakowanie artefaktu i nadanie odpowiednich praw użytkownikom
- zapewnienie uruchomienie w dowolny sposób usługi - po analizie stwierdziłem, iż stworzę mojego ezmaple.js serwis, który będzie się raz uruchamiał przy uruchomieniu, ale nie będzie nic robił (możemy zbadać czy podziałało poleceniem `systemctl status`) ale dodatkowo wpiszę do pliku `.bash_profile` aby przy zalogowaniu się do systemu wypisywało się w programie działanie example.js.

Majac plan działania możemy przystąpić do pisania sekcji `%post`:

```cfg
%post --log=/var/log/ks-post.log
echo ">>> Rozpoczynam pobieranie artefaktu z Jenkinsa..."
# Katalog docelowy
mkdir -p /usr/local/bin/chalk-pipe
# Pobierz artefakt (ostatni build)
wget -O /tmp/artifact_result.tar.gz "http://192.168.0.139:8080/job/Done_Pipe_Chalk/lastSuccessfulBuild/artifact/INO/GCL02/KM415588/Sprawozdanie_2/artifact_result.tar.gz"
# Rozpakuj do katalogu
tar -xzf /tmp/artifact_result.tar.gz -C /usr/local/bin/chalk-pipe
# Prawa wykonania
chmod +x /usr/local/bin/chalk-pipe/lib/chalk-pipe/example.js
# Utwórz plik jednostki systemd
cat <<EOF > /etc/systemd/system/chalk-pipe.service
[Unit]
Description=Start chalk-pipe example.js
After=network.target
[Service]
Type=oneshot
ExecStart=/usr/bin/node /usr/local/bin/chalk-pipe/lib/chalk-pipe/example.js
WorkingDirectory=/usr/local/bin/chalk-pipe/lib/chalk-pipe
RemainAfterExit=yes
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target
EOF
cat <<'EOF' >> /home/kmazur/.bash_profile
echo ""
echo ">>> Uruchamiam chalk-pipe (example.js):"
echo "----------------------------------------"
node /usr/local/bin/chalk-pipe/lib/chalk-pipe/example.js
echo ">>> Zakończono działanie example.js"
echo ""
EOF
chown kmazur:kmazur /home/kmazur/.bash_profile
systemctl enable chalk-pipe.service
echo ">>> Instalacja zakończona."
%end
```

Analizując każdą z sekcji:

| **Kod (skrót)** | **Opis działania** |
|------------------|--------------------|
| `%post --log=/var/log/ks-post.log` | Rozpoczyna sekcję postinstalacyjną. Wszystkie wyjścia i błędy z tego bloku zostaną zapisane do logu `/var/log/ks-post.log`. |
| `echo ">>> Rozpoczynam pobieranie artefaktu z Jenkinsa..."` | Komunikat informacyjny – sygnalizuje rozpoczęcie pobierania aplikacji. |
| `mkdir -p /usr/local/bin/chalk-pipe` | Tworzy katalog docelowy, do którego zostanie rozpakowany artefakt. Flaga `-p` sprawia, że nie wystąpi błąd, jeśli katalog już istnieje. |
| `wget -O /tmp/artifact_result.tar.gz "http://..."` | Pobiera artefakt `.tar.gz` z ostatniego udanego buildu Jenkinsa i zapisuje go tymczasowo jako `/tmp/artifact_result.tar.gz`. |
| `tar -xzf /tmp/artifact_result.tar.gz -C /usr/local/bin/chalk-pipe` | Rozpakowuje archiwum `.tar.gz` do katalogu `/usr/local/bin/chalk-pipe`. Flagi `xzf` oznaczają: wypakuj, gzip, plik. |
| `chmod +x ...example.js` | Nadaje plikowi `example.js` prawo do uruchamiania (execute), aby Node.js mógł go wykonać. |
| `cat <<EOF > /etc/systemd/system/chalk-pipe.service`<br>(...) | Tworzy plik jednostki systemd do uruchamiania aplikacji `example.js` jako usługi. Usługa będzie typu `oneshot`, czyli wykona się jednorazowo i zakończy. |
| `WorkingDirectory=...` | Określa katalog roboczy dla procesu – ma znaczenie dla względnych ścieżek wewnątrz aplikacji. |
| `RemainAfterExit=yes` | Pozwala, by usługa pozostała w stanie „active (exited)” po zakończeniu działania – nie jest oznaczana jako „dead”. |
| `cat <<'EOF' >> /home/kmazur/.bash_profile`<br>(...) | Dodaje do `.bash_profile` użytkownika `kmazur` kod, który automatycznie uruchamia aplikację po zalogowaniu (i wypisuje jej wynik na ekran). |
| `chown kmazur:kmazur /home/kmazur/.bash_profile` | Zapewnia, że użytkownik `kmazur` ma pełne prawa do pliku `.bash_profile`, aby mógł go wykonać po zalogowaniu. |
| `systemctl enable chalk-pipe.service` | Rejestruje usługę `chalk-pipe` do automatycznego uruchomienia przy starcie systemu. |
| `echo ">>> Instalacja zakończona."` | Końcowy komunikat potwierdzający zakończenie działania `%post`. |
| `%end` | Kończy sekcję `%post` – obowiązkowa składnia w pliku Kickstart. |

Po zakończonej instalacji i zrebootowaniu systemu loguje się na użytkownika kmazur i otrzymuje następujący wydruk:

![wydruk](./09/img/po_log.png)

Po wpisaniu komendy `systemctl status chalk-pipe.service` otrzymuje:

![service](./09/img/drug_status.png)

Przechodząc do folderu `/usr/local/bin/chalk-pipe...` i wykonaniu `node example.js` otrzymuje:

![wydruk2](./09/img/recznie.png)

## Laboratorium 10 - Wdrażanie na zarządzalne kontenery: Kubernetes (1)

### 1️⃣ Pobranie i przygotowanie minikube
Na początku zajęć pobieramy `minikube`:

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

Dalej dodałem alias do pliku `~./bashrc` aby ułatwić korzystanie z kubectl:

```bash
echo 'alias kubectl="minikube kubectl --"' >> ~/.bashrc
source ~/.bashrc
```

Następnie wywołuje:

```bash
minikube start
```

Jeśli wyskakuje error, iż nie może dostać się do dockera należy dodać użytkownika do grupy docker jeśli wcześniej nie było to zrobione:

```bash
#najpierw spradźmy czy jest
groups $USER_NAME
#jeśli nie ma go w grupie dockerowej to:
sudo usermod -aG docker $USER_NAME
#dla zrestartowania i wprowadzenia zmian można otworzyć nowe okno terminala bądź
newgrp docker
```

Następnie uruchamiamy jeszcze raz minikube i powinniśmy otrzymać:

![mini_start](./kubernetes/img/minkube_start.png)

Dalej przetestujmy działanie aliasu kubectl:

```bash
kubectl get po -A
```

Jeśli zwróci poniższy error:

![err](./kubernetes/img/error_kubectl.png)

Musimy ustawić kontekst kubectl na minikube poleceniem:

```bash
kubectl config use-context minikube
```

Przetestujmy jeszcze raz i powinniśmy dostać:

![suc_kub](./kubernetes/img/suc_kubectl.png)

Przejdźmy teraz do minikube dashboard poleceniem:

```bash
minikube dashboard
```

Jeśli nie przeniesie nas bezpośrednio należy wprowadzić link w error - przykładowo w moim wypadku `http://127.0.0.1:35743/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/` wyświetli nam się następująca strona:

![kube_dash_start](./kubernetes/img/kub_disp.png)