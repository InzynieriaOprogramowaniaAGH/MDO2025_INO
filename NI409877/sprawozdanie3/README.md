# Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible
## Instalacja zarządcy Ansible
### Druga maszyna wirtualna
Na początku utworzono drugą maszynę wirtualną (ubuntu-22.04.4-live-server-amd64.iso) z tym samym systemem operacyjnym co główna maszyna, zapewniono obecność programu tar i serwera OpenSSH. Nadano jej hostname ansible-target i utworzono użytkownika ansible.

### Migawka maszyny
Migawka maszyny to zapis stanu maszyny wirtualnej w danym momencie. Obejmuje ona stan systemu operacyjnego, stan pamięci RAM, zawartość dysków wirtualnych, ustawienia maszyny wirtualnej. Stosuję się ją gdy wykonywane są duże zmiany w celu łatwego powrotu do stanu maszyny sprzed modyfikacji w przypadku niespodziewanych problemów.
Aby utworzyć migawkę wybrano: maszyna -> zrób migawkę.
![image](https://github.com/user-attachments/assets/983ad667-7b39-4598-8dab-78208fb45795)

### Połączenie ssh
Na głównej maszynie wirtualnej zainstalowano oprogramowanie ansible oraz wymieniono klucze SSH między użytkownikiem w głównej maszynie wirtualnej, a użytkownikiem ansible z nowej tak, by logowanie ssh ansible@ansible-target nie wymagało podania hasła. W tym celu wygenerowano parę kluczy SSH bez ustawiania hasła:
`ssh-keygen`
![image](https://github.com/user-attachments/assets/97cb0f78-0cf6-462e-8e90-c7a134511c23)

oraz skopiowano klucz publiczny na maszynę docelową dla użytkownika ansible
![image](https://github.com/user-attachments/assets/abcb62ce-bd7e-4f41-8abe-a339b7b580e7)

Następnie nawiązano połączenie z maszyną ansible-target przy pomocy adresu IP:
![image](https://github.com/user-attachments/assets/2407e4cf-d0c4-41f7-bee6-02c1893c006b)

Aby ustawić połączenie bez potrzeby podawania adresu IP edytowano plik etc/hosts na maszynie głównej:
`sudo nano /etc/hosts`
i dodano wpis odpowiadający maszynie ansible-target.
![image](https://github.com/user-attachments/assets/84951e81-e582-4ac4-87c9-e72cda1fbe6c)

Finalnie udało się nawiązać połączenie poprzez nazwę hosta:
![image](https://github.com/user-attachments/assets/668c0a7d-4326-41c4-97a9-489d91c10065)
![image](https://github.com/user-attachments/assets/e28e47b7-7b4b-449d-835c-b4be284d529d)

## Inwentaryzacja
### Ustawienie nazw hostów
Na każdej z maszyn wykonano polecenie:
`hostnamectl set-hostname <nazwa-maszyny>`
W celu ustalenia nazw maszyn: Ubuntu i ansible. Następnie poleceniem hostname sprawdzono czy nazwa została zapisana poprawnie.
![image](https://github.com/user-attachments/assets/1986544e-959c-4bfb-a217-ea1fca614bc3)
![image](https://github.com/user-attachments/assets/393bebce-0a14-4d76-a316-d0d022c10e21)

### Wprowadzenie nazw DNS
Aby umożliwić komunikację za pomocą nazw zamiast adresów IP zmodyfikowano plik /etc/host na maszynie głównej. Dodano wpisy IP i hostname.
![image](https://github.com/user-attachments/assets/2969d72a-5f78-489f-aad4-5d5593cc5d46)

### Weryfikacja łączności
Za pomocą polecenia ping sprawdzono poprawność komunikacji z maszyną ansible-target.
![image](https://github.com/user-attachments/assets/52d39d2f-0759-4e2a-9e10-98b978648a66)

### Plik inwentaryzacji
Następnie utworzono folder ansible/inventory, w którym utworzono plik inwentaryzacji ansible.
Plik ten służy do określenia, na jakich maszynach mają być wykonywane zadania, czyli gdzie Ansible ma się "logować" i działać. Określa on nazwy hostów, na których ansible ma działać, pozwala podzielić maszyny na grupy, można w nim ustawić indywidualne parametry logowania i jest przekazywany do poleceń Ansible przez -i. Są dwa rodzaje plików inwentaryzacji: prostszy plik INI i nowszy, bardziej zaawansowany plik yaml. Ja stworzyłam plik inventory.yml.
![image](https://github.com/user-attachments/assets/eeab1ef6-e881-4531-b543-c9c16ef14a39)

### Test połączenia
Wysłano polecenie ping do wszystkich maszyn zdefiniowanych w pliku.
![image](https://github.com/user-attachments/assets/5750e103-6d0a-45a4-8969-4f888ce9de22)

Udowodniono w ten sposób, że ansible nawiązał połączenie zarówno z maszyną ansible jak i Ubuntu.

## Zdalne wywoływanie procedur
### Playbook
Playbook to plik YAML (zwykle z rozszerzeniem .yaml lub .yml), który opisuje kroki (zadania), jakie Ansible ma wykonać na zdalnych maszynach.

### Ping do wszystkich maszyn
Obejmuje on sprawdzenie dostępności wszystkich maszyn.
![image](https://github.com/user-attachments/assets/cb7b7902-7092-4ad6-a771-613e9ac027f0)
![image](https://github.com/user-attachments/assets/f1507df6-9918-4f04-8cf5-324b0e482d50)

### Skopiowanie pliku inwentaryzacji na zdalne maszyny
W celu porównania różnic w wyjściu wykonano to działanie 2 razy.
![image](https://github.com/user-attachments/assets/285a1eee-479a-4bef-a8af-4db10d7de08d)

Pierwsza próba:
![image](https://github.com/user-attachments/assets/8773568d-83e9-4063-8c1b-91382dd43919)

Druga próba:
![image](https://github.com/user-attachments/assets/434a22a1-4077-4de1-baef-a57e89087e42)

Działanie zakończone sukcesem, plik inventory.yml pojawił się na drugiej maszynie wirtualnej.
![image](https://github.com/user-attachments/assets/a2b02c59-40cd-4bd8-a3fe-7a5d2c47403e)

### Aktualizacja pakietów w systemie
![image](https://github.com/user-attachments/assets/087a6d36-db2b-4984-a7f4-d3faddc42965)

### Restart usług ssh i rngd
![image](https://github.com/user-attachments/assets/e0a0577e-ba44-4923-854c-a1256dce1288)

![image](https://github.com/user-attachments/assets/d66f71ab-c78a-4e21-a491-65b6f323d47e)

Playbook został wykonany poprawnie na wszystkich maszynach. W przypadku restartu usługi rngd początkowo pojawiał się błąd związany z brakiem tej usługi na obu maszynach. Po próbie instalacji wystąpił błąd związany z brakiem dostępu do Internetu, gdyż korzystano z karty sieciowej host-only. Wówczas ustawiono dwie karty sieciowe NAT oraz host-only by zapewnić jednocześnie dostęp do Internetu oraz możliwość komunikacji pomiędzy maszynami wirtualnymi i hostem. Karta NAT pozwala maszynie wirtualnej łączyć się z Internetem za pośrednictwem systemu gospodarza, co jest niezbędne do instalowania pakietów, aktualizacji systemu czy pobierania z repozytoriów. Niestety, NAT działa tylko w jedną stronę – maszyna ma dostęp na zewnątrz, ale komputer hostujący oraz inne maszyny nie mogą połączyć się z nią bezpośrednio.
Z tego powodu dodaje się drugą kartę – Host-only. Tworzy ona wirtualną sieć lokalną, w której uczestniczą tylko host i maszyny wirtualne. Dzięki niej możliwa jest bezpośrednia komunikacja między maszynami oraz między hostem a maszyną, co jest kluczowe np. dla Ansible, który musi móc łączyć się po SSH z innymi maszynami w sieci. Następnie zainstalowano rngd I uruchomiono playbooka ponownie – tym razem wszystko zadziałało poprawnie.

### Operacja względem maszyny z wyłączonym serwerem SSH i odłączoną kartą sieciową
W celu wykonania tego zadania wyłączono serwer SSH na maszynie ansible-target za pomocą poleceń:
`sudo systemctl stop ssh`
`sudo systemctl disable ssh`
Aby sieć była całkowicie niedostępna wykonano również:
`sudo ip link set enp0s8 down`
![image](https://github.com/user-attachments/assets/5069cce7-c93b-4929-9eb6-fd9d8311d6c4)

Po ponownym uruchomieniu playbooka maszyna z wyłączonym SSH i siecią ma status UNREACHABLE.
![image](https://github.com/user-attachments/assets/5a5bcb36-d2e5-4ccd-a40f-60864eb622c3)

## Zarządzanie stworzonym artefaktem
### Struktura playbooka
W moim pipeline jenkinsowym tworzony był obraz kontenera zawierającego interpreter irssi. Za pomocą Ansible wykonano następujące kroki:
- zainstalowano Dockera na maszynie docelowej
- pobrano obraz z DockerHub: natalia232002/irssi-runtime
- uruchomiono kontener z tego obrazu
- dokonano weryfikacji potwierdzającej działanie kontenera
- zatrzymano i usunięto kontener
- całość opakowano w rolę Ansible stworzoną za pomocą ansible-galaxy init\

``` - hosts: all
  become: yes
  vars:
    image_name: natalia232002/irssi-runtime
    container_name: irssi-container

  tasks:
    - name: Zainstaluj wymagane pakiety (Docker + Python Docker)
      ansible.builtin.apt:
        name:
          - docker.io
          - python3-pip
          - python3-docker
        state: present
        update_cache: yes

    - name: Upewnij się, że usługa Docker działa
      ansible.builtin.service:
        name: docker
        state: started
        enabled: yes

    - name: Pobierz obraz z DockerHub
      community.docker.docker_image:
        name: "{{ image_name }}"
        source: pull

    - name: Uruchom kontener z obrazu
      community.docker.docker_container:
        name: "{{ container_name }}"
        image: "{{ image_name }}"
        state: started
        detach: true

    - name: Zweryfikuj, że kontener działa
      ansible.builtin.command: docker ps -f name={{ container_name }} --format "{{'{{.Status}}'}}"
      register: container_status

    - name: Pokaż status działania kontenera
      ansible.builtin.debug:
        var: container_status.stdout

    - name: Zatrzymaj i usuń kontener
      community.docker.docker_container:
        name: "{{ container_name }}"
        state: absent
        force_kill: true
```

### Rola ansible
W katalogu z playbookiem utworzono rolę ansible za pomocą polecenia:
`ansible-galaxy init deploy_runtime`
![image](https://github.com/user-attachments/assets/3939cacf-b84a-4619-ba91-9e0fbb19b5a4)

Struktura katalogów po utworzeniu roli wygląda następująco:
![image](https://github.com/user-attachments/assets/6eb8f16d-8dbc-4088-8420-85ead4745ade)

### Plik main.yml
W pliku main.yml został utworzony playbook Ansible spełniający wymagania zadania obejmujące następujące działania:
- instalacja Dockera,
- instalacja pakietów potrzebnych do dodania zewnętrznego repozytorium,
- pobranie klucza GPG potrzebnego do weryfikacji paczek z repozytorium Dockera,
- dodanie oficjalnego repozytorium Docker CE (Community Edition) do systemu, dzięki czemu apt znajduje najnowszą wersję Dockera,
- instalacja Dockera (pakiet docker-ce – wersja community),
- upewnienie się, że docker działa i włącza go automatycznie po restarcie,
- zarządzanie artefaktem (kontenerem),
- ściągnięcie obrazu natalia232002/irssi-runtime,
- stworzenie i uruchomienie kontenera o nazwie irssi_runtime_test, na podstawie pobranego obrazu. Flaga detach: false powoduje, że playbook czeka aż kontener się zakończy, co ma sens w przypadku command: --version,
- usunięcie kontenera (jeśli nadal działa – force_kill: true wymusza zatrzymanie). Spełnia warunek "zatrzymaj i usuń kontener".
![image](https://github.com/user-attachments/assets/595ca282-9845-49b8-a287-13f99848c59e)
![image](https://github.com/user-attachments/assets/4bf54388-7c94-4389-9e6a-701d8ed4a4ce)

### Plik deploy_runtime
Utworzono również playbook w katalogu inventory służący do wdrożenia obrazu Dockera irssi-runtime na zdalnych hostach. Zawiera on jedno główne zadanie opisane nazwą „Deployment obrazu irssi-runtime” i jest przeznaczony do wykonania na hostach należących do grupy Endpoints, która została wcześniej zdefiniowana w pliku inventory.yml. Dzięki opcji become: true, wszystkie operacje w ramach tego playbooka wykonywane są z uprawnieniami administratora, co jest niezbędne do instalacji Dockera oraz operacji na kontenerach.
Kluczowym elementem tego playbooka jest przypisanie roli deploy_runtime, co oznacza, że Ansible automatycznie szuka katalogu roles/deploy_runtime/, a w nim struktury wymaganej przez role, w szczególności pliku tasks/main.yml, w którym znajdują się wszystkie zadania. Rola ta pozwala na logiczne uporządkowanie zadań i ich ponowne użycie w różnych kontekstach.
Cały ten playbook uruchomiono poleceniem ansible-playbook, a jego działanie sprowadza się do automatycznego przygotowania środowiska kontenerowego i przetestowania działania aplikacji zbudowanej i opublikowanej wcześniej w pipeline.
![image](https://github.com/user-attachments/assets/c364d7b1-47f6-455e-b6e4-894179fbf2bf)

Po uruchomieniu kontenera za pomocą Ansible, logi wskazywały, że skrypt został wykonany poprawnie.
![image](https://github.com/user-attachments/assets/a096e9fa-07ad-4faf-a7e1-656cd22e05c3)
![image](https://github.com/user-attachments/assets/c4fec05a-a055-4ff6-8ba5-537e5cac1d70)


# Pliki odpowiedzi dla wdrożeń nienadzorowanych
## Automatyzacja instalacji Fedory z wykorzystaniem Kickstart
### Instalacja systemu Fedora
Pierwszym krokiem potrzebnym do wykonania następnego zadania była instalacja systemu Fedora (wcześniej korzystano z Ubuntu). W tym celu pobrano instalator sieciowy Fedora NetInstall i zainstalowano maszynę na Ubuntu.

### Plik anaconda-ks.cfg
Następnie zalogowano się na roota i znaleziono tam plik odpowiedzi anaconda-ks.cfg.
Plik anaconda-ks.cfg to plik Kickstart, który jest automatycznie generowany przez instalator Fedory (Anaconda) podczas instalacji systemu. To sposób na automatyzację instalacji systemu Linux. Zawiera instrukcje, jak ma zostać przeprowadzona instalacja tj. ustawienia języka, partycjonowanie dysku, użytkownicy, pakiety do zainstalowania, skrypty do wykonania po instalacji itp. Dzięki niemu można powtórzyć dokładnie taką samą instalację wielokrotnie, bez konieczności ręcznego klikania w instalator.

### Modyfikacja pliku ks.cfg
Plik ten zapisano na githubie pod nazwą ks.cfg:
[ks.cfg](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/NI409877/NI409877/sprawozdanie3/ks.cfg)

Dokonano w nim kilku kluczowych modyfikacji:
- dodano źródła pakietów
  `url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-40&arch=x86_64`
  `repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f40&arch=x86_64`
- zapewniono formatowanie całego dysku
  `clearpart --all –initlabel`
- ustawiono nazwę hosta na inną niż local host
  `network  --hostname=fedora-auto.local`
- ustawiono login i hasło użytkownika
  `rootpw root --plaintext`
  `user --groups=wheel --name=nataliaim --password=root --plaintext --gecos="nataliaim"`

### Instalacja nienadzorowana nowej maszyny wirtualnej
Po modyfikacji pliku można było wykonać instalację nienadzorowaną nowej maszyny wirtualnej. W tym celu utworzono  w VirtualBoxie nową maszynę  o nazwie fedora_nienadzorowana korzystając z wcześniej pobranego obrazu ISO Fedora Server. Zamiast typowego rozpoczęcia instalacji na ekranie wyboru GRUB wciśnięto klawisz e, aby edytować parametry bootowania. W linii zaczynającej się od Linux dodano na końcu:
`inst.ks=https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/refs/heads/NI409877/NI409877/Sprawozdanie3/ks.cfg`
Jest to link RAW do naszego pliku instalacyjnego. Oznacza to czysty, surowy plik tekstowy, bez interfejsu GitHuba dookoła, jakiego oczekuje system instalacyjny Fedora.
![image](https://github.com/user-attachments/assets/12720c92-ef9f-42bc-86e9-583e6c707413)

Następnie naciśnięto kombinację klawiszy CTRL+X, co uruchomiło instalator na podstawie naszego pliku.
![image](https://github.com/user-attachments/assets/cde8baa9-cf4d-4073-9c29-63ed09821d61)

Po zainstalowaniu uruchomiono system aby sprawdzić, czy wszystko przebiegło zgodnie z planem.
![image](https://github.com/user-attachments/assets/7f9532b0-65d8-4ac4-9590-cba19368d8ce)

## Rozszerzenie pliku odpowiedzi
### Plik ks2.cfg
Następnym etapem było rozszerzenie pliku ks.cfg o repozytoria i oprogramowanie potrzebne do uruchomienia programu, zbudowanego w ramach projektu - naszego pipeline'u. Moim projektem było oprogramowanie Irssi. Przygotowano plik, który wykonuje następujące działania:
- instaluje Dockera
- dodaje użytkownika natalia do grupy docker
- tworzy skrypt /usr/local/bin/natalia-irssi.sh, który uruchomi kontener
- tworzy usługę natalia-irssi.service, która uruchamia się przy starcie systemu
- uruchamia kontener natalia232002/docker-runtime w tle (-d)
- po instalacji systemu wykonuje reboot

Plik zapisano na githubie jako ks2.cfg.
[ks2.cfg](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/NI409877/NI409877/sprawozdanie3/ks2.cfg)
W tym momencie można było przeprowadzić kolejną instalację nienadzorowaną na tej samej zasadzie co poprzednio, korzystając z nowego pliku.

### Weryfikacja działania
Po zakończeniu instalacji uruchomiono status usługi aby sprawdzić czy kontener się uruchomił i obraz został dobrze pobrany.
`systemctl status natalia-irssi.service`
![image](https://github.com/user-attachments/assets/1a6ab0da-dfc9-4cd6-b7a2-e799b49749e8)

Logi pokazują, że obraz natalia-irssi został poprawnie pobrany z Docker Hub.


# Wdrażanie na zarządzalne kontenery: Kubernetes (1)
## Instalacja klastra Kubernates
### Minikube
Minikube to narzędzie, które pozwala uruchomić lokalny, jednowęzłowy klaster Kubernetes na komputerze. Jest idealne do nauki i testów.
Przed instalacją zadbano o odpowiednie wymagania systemowe dla minikube:
- środowisko wirtualizacji (w moim przypadku VirtualBox),
- minimalne zasoby: 2GB ramu i 2 CPU,
- przestrzeń dyskowa na obrazy i kontenery.
Binarkę pobrano za pomocą następującego polecenia:
`curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64`
Nadano jej uprawnienia wykonywalne:
`chmod +x minikube-linux-amd64`
Przeniesiono ją również do katalogu z binarkami, aby móc wpisywać minikube w terminalu z dowolnego miejsca, bez podawania ścieżki.
`sudo mv minikube-linux-amd64 /usr/local/bin/minikube`
W celu upewnienia się, że wszystko działa sprawdzono wersję minikube:
`minikube version`
![image](https://github.com/user-attachments/assets/1743bf14-15af-40b6-bb45-746e6cb12835)

### Instalacja kubectl
kubectl to oficjalne CLI do komunikacji z klastrem Kubernetes. 
Zaopatrzono się w polecenie kubectl w wariancie minikube:
`alias minikubectl="minikube kubectl --"`
![image](https://github.com/user-attachments/assets/061b170f-8362-4872-bf6e-c90f990b237b)

### Uruchomienie minikube
W celu uruchomienia minikube wpisano:
`minikube start`
Minikube pobiera niezbędne obrazy, uruchamia wirtualną maszynę i zakłada klaster. Po chwili powinieneś widzimy informacje o działającym klastrze. Minikube domyślnie alokuje 2 CPU i 2GB RAM – można to zmienić komendą start:
`minikube start --cpus=4 --memory=4096`
![image](https://github.com/user-attachments/assets/c5fdf017-fff3-4eeb-bf69-e867919f27c2)

Sprawdzono również stan działającego klastra.
![image](https://github.com/user-attachments/assets/8906faa9-45cc-47bf-9a21-8a2569d3388e)

### Uruchomienie i pokaz działającego kontenera
Od razu uruchomiono prosty kontener w klastrze:
`minikube kubectl -- run hello-minikube --image=k8s.gcr.io/echoserver:1.10 --port=8080`
Sprawdzono również działanie poda:
`minikube kubectl -- get pods`
![image](https://github.com/user-attachments/assets/c9c0d44e-849f-40e6-9543-bc5b4219a0e4)

### Problemy sprzętowe i ich mitygacja
Minikube wymaga maszyn wirtualnych i przydzielonych zasobów.
Jeśli komputer jest słaby (mało RAM, CPU), Minikube może nie działać płynnie lub wcale.
W takim wypadku należy rozważyć:
- zmniejszenie przydzielonych zasobów (np. 1 CPU, 1GB RAM),
- instalację Kubernetes na chmurze zamiast lokalnie,
- sprawdzenie czy istnieje działająca i poprawnie skonfigurowana wirtualizację (VT-x/AMD-V w BIOS).

### Uruchomienie Dashboarda Kubernetes
Dashboard to webowe GUI do zarządzania klastrem.
Włączono dashboard za pomocą polecenia:
`minikube dashboard`
![image](https://github.com/user-attachments/assets/892a59f5-ce25-4694-a6ec-e639e01a99ca)

Ta komenda automatycznie uruchomiła dashboard i otworzyła w przeglądarce jego UI.

### Podstawowe pojęcia Kubernetes
- Pod — podstawowa jednostka uruchomieniowa w Kubernetes, pojedynczy kontener lub zestaw kontenerów.
- Deployment — zarządza tworzeniem i aktualizacją Podów, pozwala ustawić replikację.
- Service — abstrakcja dostępu do Podów, zapewnia stabilny endpoint (adres IP i port).
- Namespace — izolacja zasobów w klastrze.
- kubectl — CLI do zarządzania Kubernetes.

## Analiza posiadanego kontenera
Obraz irssi nie spełnia wymagań zadania "Deploy to cloud", ponieważ jest to aplikacja terminalowa, która nie udostępnia żadnej funkcji przez sieć. Kubernetes oczekuje, że aplikacja w kontenerze będzie wystawiać serwis, np. przez HTTP, który można eksponować i skalować. Irssi działa interaktywnie w terminalu, więc nie spełnia tych założeń. Wybrano więc alternatywny projekt oparty na serwerze nginx, który działa jako usługowy kontener. Celem było zbudowanie i uruchomienie kontenera zawierającego prostą aplikację webową z własną stroną startową.

### Alternatywny projekt
W ramach przygotowania własnego obrazu kontenera utworzono prostą stronę internetową w pliku index.html, zawierającą komunikat „Testowanie Minikube”, który posłużył jako zawartość serwowaną przez serwer NGINX.
![image](https://github.com/user-attachments/assets/4a11ff32-eb6b-4905-a613-344862de891e)

Następnie utworzono plik Dockerfile, w którym jako bazowy obraz użyto oficjalnego nginx:latest. W tym pliku skonfigurowano polecenie COPY, które nadpisuje domyślny plik startowy serwera NGINX własną stroną HTML, kopiując lokalny plik index.html do katalogu /usr/share/nginx/html/ w obrazie.
![image](https://github.com/user-attachments/assets/2a82dd7d-9295-4d71-926c-1127dc8830cd)

Po przygotowaniu plików zbudowano nowy obraz Dockera za pomocą komendy:
`docker build -t moja-nginx-aplikacja .`
Następnie uruchomiono kontener na podstawie tego obrazu komendą
`docker run -d -p 8080:80 --name test-nginx moja-nginx-aplikacja`
która uruchamia kontener w tle, przekierowuje port 8080 z maszyny lokalnej na port 80 wewnątrz kontenera, na którym działa NGINX, i przypisuje mu nazwę „test-nginx”.
![image](https://github.com/user-attachments/assets/cee4a7d3-6749-45bf-af4c-0e0b6e7f6e14)

Po wykonaniu tych czynności możliwe było otwarcie przeglądarki i sprawdzenie działania aplikacji pod adresem localhost:8080, gdzie wyświetlała się przygotowana strona, co potwierdzało, że kontener działa prawidłowo i serwuje zawartość sieciową.
![image](https://github.com/user-attachments/assets/034bd2ec-7f69-4120-8266-2bbbeed15828)

## Uruchamianie oprogramowania
### Uruchomienie poda
Zadaniem było uruchomienie kontenera z obrazem ngix w Kubernates jako pojedynczego poda o nazwie nginx-pod z obrazem nginx, otwierając port 80.
Dodatkowo polecenie dodaje etykietę app=nginx-deployment, co pozwala później łatwo identyfikować ten pod.
![image](https://github.com/user-attachments/assets/659fe90d-76ad-4bfd-985c-4ab95d9c47f3)

Po uruchomieniu Dashboarda Minikube otwiera się graficzny interfejs, w którym można obserwować stan klastra. Pojawiające się kolorowe "kulki" przy zasobach (np. Podach, Deploymentach) wizualnie przedstawiają ich status — zielone oznaczają poprawne działanie, żółte lub czerwone sygnalizują błędy lub problemy z uruchomieniem.
![image](https://github.com/user-attachments/assets/e2b2e752-b686-4729-b3b9-a5fc907c1419)

### Utworeznie drugiego poda i przeskalowanie go do 12 instacji
Następnie w Minikube Dashboard utworzono kolejnego poda i przeskalowano go do 12 instancji za pomocą polecenia:
![image](https://github.com/user-attachments/assets/7304a6d9-47e5-44a9-9fb8-055a167c1c0d)
![image](https://github.com/user-attachments/assets/33919fcd-09eb-442c-bc35-0541791da65d)
![image](https://github.com/user-attachments/assets/fc52f039-d084-4a1c-8b13-1b383aca7306)

Dokonano forwardu portu, który przekierował lokalny port 8888 na port 80 w podzie nginx-pod.
`kubectl port-forward pod/nginx-pod 8888:80`
Po wejściu w przeglądarkę pod adres http://localhost:8888 można było zobaczyć domyślną stronę nginx co oznacza, że wszystko zadziałało poprawnie.
![image](https://github.com/user-attachments/assets/e4f068f0-d3fc-428a-8bcb-a3e5cf9d8398)

## Przekucie wdrożenia manualnego w plik wdrożenia
### Przygotowanie pliku .yaml
W tym kroku przygotowano plik YAML definiujący zasób typu Deployment, który tworzy jeden pod z kontenerem opartym o obraz nginx:latest. Kontener nasłuchuje na porcie 80. 
![image](https://github.com/user-attachments/assets/d3cac299-1e9d-4add-8210-57454dc184b2)

### Wdrożenie pliku .yaml
Wdrożenie zostało przeprowadzone poleceniem:
`minikube kubectl -- apply –filename=nginx-deployment.yaml`
Polecenie to powoduje, że konfiguracja opisana w pliku YAML jest przekazywana do klastra Kubernetes i wdrażana. Aby sprawdzić, czy deployment został poprawnie utworzony, wykorzystano komendę:
`minikube kubectl get deploy`
Wyświetla ona listę deploymentów, ich liczbę replik, status oraz inne szczegóły. Następnie użyto polecenia:
`minikube kubectl get pods`
Dzięki niemu można zweryfikować, czy pod został uruchomiony i czy działa prawidłowo. Po wykonaniu polecenia pojawił się pod o nazwie zaczynającej się od nginx ze statusem Running. W ten sposób potwierdza się, że kontener został poprawnie wdrożony w środowisku Kubernetes.
![image](https://github.com/user-attachments/assets/cb665d89-3298-4afb-a412-74fc496b3122)

### Rozszerzenie pliku yaml o 4 repliki
Zmodyfikowano plik .yaml dodając 4 repliki w następujący sposób:
```spec:
  replicas: 4
```
Następnie wykonano następujące polecenia:
![image](https://github.com/user-attachments/assets/653fbf2a-1642-48be-946f-771e4e0932e8)
![image](https://github.com/user-attachments/assets/9d36f5eb-a950-443c-9bef-40572ff288dd)

Polecenie
`minikube kubectl -- apply -filename=nginx-deployment.yaml `
pozwoliło na wdrożenie aplikacji nginx zdefiniowanej w pliku YAML, w którym określono uruchomienie czterech replik kontenerów. Następnie, za pomocą 
`minikube kubectl rollout status deployment/nginx`
monitorowano status wdrożenia, aby upewnić się, że wszystkie repliki zostały uruchomione poprawnie. Polecenie 
`minikube kubectl -- get pods -l app=nginx `
pozwoliło zaś na wyświetlenie listy uruchomionych podów oznaczonych odpowiednią etykietą, co umożliwiło weryfikację, czy wszystkie cztery repliki działają zgodnie z oczekiwaniami. Kolejno, komenda 
`kubectl expose deployment nginx --type=NodePort --port=80 --name=nginx-service`
utworzyła serwis typu NodePort, który wystawił aplikację na zewnątrz klastra Kubernetes, umożliwiając dostęp do niej na porcie 80. Na końcu zastosowano 
`kubectl port-forward service/nginx-service 8888:80`
które przekierowało lokalny port 8888 na port serwisu, co pozwoliło na dostęp do aplikacji nginx z poziomu lokalnej przeglądarki pod adresem http://localhost:8888. Dzięki temu cały proces wdrożenia i udostępnienia aplikacji został pomyślnie zakończony, umożliwiając łatwe testowanie i dostęp do uruchomionych kontenerów.
![image](https://github.com/user-attachments/assets/46532895-a40b-477a-b389-68fdf8e76174)
![image](https://github.com/user-attachments/assets/b4a8b5bd-3c55-4415-817a-a527b1e1bb59)
![image](https://github.com/user-attachments/assets/ce48e6be-2dfb-43bf-8e99-270b6ebee762)
![image](https://github.com/user-attachments/assets/b13f0664-4f38-40f2-b856-469bdb2430d6)


# Wdrażanie na zarządzalne kontenery: Kubernetes (2)
## Przygotowanie nowego obrazu
Utworzono plik Dockerfile i trzy katalogi httpd1, httpd2 i httpd3, a w każdym z nich zawarto pliki index.html, służące do budowy konkretnych obrazów.
### Dockerfile
![image](https://github.com/user-attachments/assets/4ef82b73-ae49-4faf-8aea-02407668c52e)

### Wersja 1
![image](https://github.com/user-attachments/assets/56f35a34-269b-4108-8e34-b4e0419797d4)

### Wersja 2
![image](https://github.com/user-attachments/assets/155eac6a-90ee-42ef-9db8-5593723168a9)

### Budowa obrazów i wypchcnięcie na DockerHub
#### Obraz 1
![image](https://github.com/user-attachments/assets/41f1b076-c14b-4692-9672-4681a15cc5dc)
![image](https://github.com/user-attachments/assets/98184d36-4b00-4967-83ee-fec1b9e00276)

#### Obraz 2
![image](https://github.com/user-attachments/assets/211c3ba3-443c-46eb-9fdf-733127d8d6e2)

### Wersja 3 - błędna
Celowo zmodyfikowano plik Dockerfile, aby nie działał poprawnie:
![image](https://github.com/user-attachments/assets/51945808-172f-466d-8bd8-88c32750095d)

Plik index.html dla błędnej wersji:
![image](https://github.com/user-attachments/assets/beb9657a-2a6d-4a60-98fd-de577d2443c7)

### Budowa i wypchcięcie na DockerHub błędnego obrazu
![image](https://github.com/user-attachments/assets/e50489e1-5e0d-4f8d-9c2e-c98e16decdec)
![image](https://github.com/user-attachments/assets/5bbbb3fb-0f5f-4837-b3f0-9123c38ffb80)

## Zmiany w deploymencie
### Dokonanie zmian w pliku deployment.yaml
Zaktualizowano plik YAML z wdrożeniem i przeprowadzono je ponownie po zwiększeniu replik do 8.
![image](https://github.com/user-attachments/assets/a0504f2a-c81f-4be2-a934-5c624703cb24)

Zastosowano zmiany i sprawdzono liczbę podów i deployment.
![image](https://github.com/user-attachments/assets/dd92817e-ab95-422f-8a0c-3bb86494a21f)
![image](https://github.com/user-attachments/assets/1575cdaa-b87a-4722-92c2-f3921a569da1)
![image](https://github.com/user-attachments/assets/26555204-c244-4817-a8ec-1204b8d3d6df)
![image](https://github.com/user-attachments/assets/ee151e95-8fad-4226-92d8-4b424bc58caa)

#### Zmniejszenie replik do 1
![image](https://github.com/user-attachments/assets/7ec1ee68-045a-4bdc-b58c-49fe540d38d5)
![image](https://github.com/user-attachments/assets/d04cc066-c2f2-461f-a4b4-f5e86a6ad031)

#### Zmniejszenie replik do 0
![image](https://github.com/user-attachments/assets/aa66467e-c5ba-440c-b909-3c1912ec64b5)
![image](https://github.com/user-attachments/assets/6cc8cce0-9f3a-4225-9f4e-2226eb18123a)

#### Zwiększenie replik do 4
![image](https://github.com/user-attachments/assets/f91b0867-22e6-4908-98a5-705a2b180216)
![image](https://github.com/user-attachments/assets/2d7cef2d-d0ee-498f-9498-23a7db82545a)

#### Porównanie nowej, starej i wadliwej wersji
Wadliwa wersja:
![image](https://github.com/user-attachments/assets/8035fd09-4c0f-48f7-8e55-99fd7005052a)
![image](https://github.com/user-attachments/assets/276429b0-235d-44a3-b454-81c6b17b069d)
![image](https://github.com/user-attachments/assets/514517c1-0dc5-409d-a04f-1582813759fc)
![image](https://github.com/user-attachments/assets/000b8a9d-9815-408e-ada0-cfd80811ffc0)
![image](https://github.com/user-attachments/assets/87cd3495-2130-48c7-9229-ae107e54554d)

## Kontrola wdrożenia
### Historia
![image](https://github.com/user-attachments/assets/4efdc574-b4f4-4c1d-8f74-4096ebf868b2)
![image](https://github.com/user-attachments/assets/06631b4f-ee0c-4e0a-a8f8-d107cc8a74b1)

### Powrót do poprzedniego stanu
![image](https://github.com/user-attachments/assets/255aa839-7b0f-444e-be99-a889354d0e07)

### Skrypt timeout 60 sekund
Utworzono skrypt w Bashu sprawdzający, czy deployment został poprawnie wdrożony w Kubernetesie (przez Minikube) w ciągu 60 sekund. Co 5 sekund sprawdza on, ile replik jest gotowych i porównuje je z liczbą zadeklarowaną. Dodatkowo analizuje status rollout’u. Jeśli wdrożenie się powiedzie, skrypt kończy się sukcesem. Jeśli po 60 sekundach nadal nie ma pełnej gotowości, wypisuje komunikat o błędzie i pokazuje szczegóły rollout’u.
![image](https://github.com/user-attachments/assets/a159620f-1a6f-44da-91cb-b8b7544d678b)

Nadano uprawnienia i uruchomiono skrypt.
`chmod +x check-deployment.sh`
`./check-deploy.sh`
![image](https://github.com/user-attachments/assets/da383f6f-a481-451f-bdf1-e4a9b744066e)

## Strategie wdrożenia
W celu przetestowania strategii wdrożeń w Kubernetes przygotowano trzy scenariusze:
- Recreate – aplikacja została całkowicie zatrzymana i uruchomiona ponownie w nowej wersji. Podejście ryzykowne, ale proste.
- RollingUpdate – stopniowe zastępowanie starych instancji nowymi. Zachowana ciągłość działania.
- Canary – równoczesne działanie dwóch wersji, gdzie tylko część użytkowników trafia na nową (eksperymentalną) wersję.

### Strategia 1: Recreate
- strategy: Recreate – najpierw usuwa wszystkie stare pody, a potem tworzy nowe,
- prosta i szybka, ale może być krótka przerwa w działaniu aplikacji.
![image](https://github.com/user-attachments/assets/d4b8824d-a3df-47c4-b023-c8eddf13c926)

### Strategia 2: Rolling update
- rollingUpdate: częściowa wymiana — np. 2 mogą być niedostępne, a 25% nowych tworzone ponad limit,
- dzięki temu aplikacja cały czas działa podczas aktualizacji.
![image](https://github.com/user-attachments/assets/8029d1ee-a106-4178-b6c5-a62d0a513921)

### Strategia #: Canary Deployment
W tym przypadku tworzymy dwa osobne Deploymenty:
- httpd-stable.yaml – wersja v1, 4 repliki,
- httpd-canary.yaml – wersja v2, 1 replika,
- wspólny Service, który kieruje ruch do obu.

- Oba deploymenty mają label: app=httpd, więc Service widzi oba
- httpd-stable (v1) ma 4 repliki, httpd-canary (v2) tylko 1 ⇒ ruch trafia w proporcji ok. 80% : 20%
- Dzięki temu można testować nową wersję na małym ruchu, zanim trafi do wszystkich

#### httpd-stable.yaml
![image](https://github.com/user-attachments/assets/fc559942-a52e-4241-96ef-7f91d8af6ba2)

#### httpd-canary.yaml
![image](https://github.com/user-attachments/assets/efeae0ac-6dea-4461-8f87-5d8cd3d79228)

#### service.yaml
![image](https://github.com/user-attachments/assets/fa24cc7c-3e09-4b44-b429-2a5ae1b771b8)

### Wdrażanie i sprawdzenie działania
![image](https://github.com/user-attachments/assets/f40b496f-98f5-4d55-950a-d244fa7e4418)
![image](https://github.com/user-attachments/assets/9c34d471-d62c-41ed-a9fd-bae5ddd5e7a6)

![image](https://github.com/user-attachments/assets/5931d162-3301-4f93-83a9-ef42a4353848)

![image](https://github.com/user-attachments/assets/eb6bc8e6-4599-4659-b081-67243392343e)
![image](https://github.com/user-attachments/assets/c128d7ad-4f30-40f3-a2f1-2a10fb01904f)
![image](https://github.com/user-attachments/assets/c6b0425c-fd03-4886-8a30-1b308f40bea3)

Po wdrożeniu serwisu typu NodePort za pomocą minikube service httpd-service --url uzyskano adres IP z portem, pod którym aplikacja jest dostępna.
Pod tym adresem można zweryfikować działanie serwisu poprzez przeglądarkę lub polecenie curl.
W przypadku Canary Deployment, testując kilka razy pod tym adresem, obserwujemy ruch rozdzielany pomiędzy stabilną a testową wersją aplikacji.

![image](https://github.com/user-attachments/assets/6247ca7e-5cea-45a2-b52b-6d417262f6ed)
![image](https://github.com/user-attachments/assets/d74e6831-9f01-4131-b02f-4a0ad02d1eed)
![image](https://github.com/user-attachments/assets/736a3c9c-06ad-48fe-91eb-60b7699e2643)

Kubernetes to nowoczesne narzędzie do zarządzania aplikacjami uruchamianymi w kontenerach. Ułatwia ich wdrażanie, automatyczne skalowanie oraz monitorowanie w środowiskach rozproszonych. Dzięki przejrzystej konfiguracji opartej na plikach YAML można łatwo kontrolować wersje aplikacji, planować aktualizacje oraz wybierać odpowiednie strategie wdrożeń (np. rolling update, recreate czy canary). Kubernetes pozwala precyzyjnie sterować cyklem życia aplikacji, co przekłada się na większą niezawodność i elastyczność całego systemu.
