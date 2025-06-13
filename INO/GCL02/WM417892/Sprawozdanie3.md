# Sprawozdanie 8 – Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

Celem niniejszego sprawozdania jest przedstawienie procesu instalacji, konfiguracji oraz praktycznego zastosowania narzędzia Ansible do automatyzacji zadań administracyjnych w środowisku złożonym z wielu maszyn wirtualnych. W ramach ćwiczenia utworzono infrastrukturę składającą się z maszyny głównej pełniącej rolę zarządcy oraz co najmniej jednej maszyny docelowej. Następnie zrealizowano kolejne etapy, takie jak konfiguracja dostępu SSH, utworzenie pliku inwentaryzacji, testowanie łączności, uruchamianie zdalnych poleceń oraz wdrażanie aplikacji lub kontenerów z użyciem playbooków. Poniższe sekcje dokumentują wykonane działania i ich rezultaty.

## Instalacja Ansible oraz konfiguracja połączenia SSH

### Wersja Ansible

Na maszynie głównej zainstalowano Ansible w wersji `2.16.3`, co zostało potwierdzone za pomocą polecenia `ansible --version`. Dodatkowo przedstawiono lokalizacje modułów, plików konfiguracyjnych oraz wersję Pythona i bibliotek pomocniczych.


![1](https://github.com/user-attachments/assets/be6b7622-f4f4-4349-8899-180f39b29dc1)

### Generowanie klucza SSH

Następnie wygenerowano parę kluczy SSH (RSA 4096 bitów) dla użytkownika `Wojtek`, umożliwiając bezhasłowe logowanie się do zdalnych maszyn. Klucz zapisano w domyślnej lokalizacji `/home/Wojtek/.ssh/id_rsa`.

![2](https://github.com/user-attachments/assets/9701c3bd-4cce-4f4d-b72d-6c1be0c5b028)

### Wymiana kluczy SSH

Za pomocą polecenia `ssh-copy-id`, klucz publiczny został przesłany na maszynę docelową (adres IP `192.168.100.27`), gdzie zalogowano się na użytkownika `ansible`. Po zakończeniu operacji możliwe było nawiązywanie połączeń SSH bez potrzeby podawania hasła.

![3](https://github.com/user-attachments/assets/3bbe7421-fca7-417e-ba0e-a89775a79ae5)


## Weryfikacja połączenia i inwentaryzacja systemów

### Test połączenia SSH

Po skonfigurowaniu kluczy SSH wykonano próbę połączenia z maszyną `ansible-target` z poziomu maszyny zarządzającej. Logowanie odbyło się poprawnie bez potrzeby podawania hasła, co potwierdza prawidłową wymianę kluczy i działający serwer SSH.

![4](https://github.com/user-attachments/assets/50767955-7877-49ca-ba1e-750d3acca759)


### Plik inwentaryzacji Ansible

Został utworzony plik `hosts.ini`, zawierający sekcję `[targets]`, w której określono maszynę docelową wraz z jej adresem IP i użytkownikiem Ansible. Dzięki temu możliwe było wykonywanie poleceń zdalnych z użyciem aliasów zamiast adresów IP.

```ini
[targets]
ansible-target ansible_host=192.168.100.27 ansible_user=ansible
```

![5](https://github.com/user-attachments/assets/399a22ec-50ef-4167-a244-354738582e35)


### Weryfikacja łączności – moduł ping

W celu sprawdzenia komunikacji pomiędzy maszyną zarządzającą a docelową, użyto polecenia:

```bash
ansible -i hosts.ini targets -m ping
```

Zwrócona odpowiedź `pong` oznacza, że komunikacja przebiega prawidłowo i maszyna jest gotowa do dalszych operacji z użyciem Ansible.

![6](https://github.com/user-attachments/assets/5ba82f9b-a740-4933-ad61-15d245e24a35)


### Informacje systemowe i hostname

Polecenie `hostnamectl` zostało użyte do potwierdzenia nazw hostów i konfiguracji maszyn wirtualnych. Obie maszyny działają pod kontrolą systemu Ubuntu 24.04.2 LTS w środowisku VirtualBox, co zapewnia spójność środowiska testowego.

**Maszyna główna – Wojtek2**

![7 1](https://github.com/user-attachments/assets/100b44dc-fe95-4f65-bc58-dbfeb91fb55d)


**Maszyna docelowa – ansible-target**

![7 2](https://github.com/user-attachments/assets/a4fe0996-6aa2-4b62-bda9-22a02b773433)


### Ustawienie aliasów nazw w pliku /etc/hosts

W celu uproszczenia komunikacji sieciowej, w plikach `/etc/hosts` na obu maszynach zdefiniowano odpowiednie aliasy nazwowe dla adresów IP maszyn. Dzięki temu możliwa jest komunikacja za pomocą nazw hostów zamiast adresów IP.

![8](https://github.com/user-attachments/assets/63fd70e6-8f0e-44bf-b7ac-772d4dc15c3c)


### Testy łączności nazwowej (ping po hostname)

Przeprowadzono testy połączeń ICMP (`ping`) przy użyciu zdefiniowanych nazw hostów. Potwierdzono poprawne działanie komunikacji dwustronnej zarówno z `Wojtek2` do `ansible-target`, jak i odwrotnie.

![9 1](https://github.com/user-attachments/assets/366a3383-6a0f-4442-b658-15795038b4b4)

![9 2](https://github.com/user-attachments/assets/9b3242d8-d802-4d56-b829-e42d7f888551)



### Rozszerzony plik inwentaryzacji z podziałem na grupy

Stworzono plik `inventory.ini` zawierający grupy `Orchestrators` oraz `Endpoints`, w których przypisano odpowiednie maszyny. Pozwala to na bardziej przejrzyste i modularne zarządzanie zasobami z poziomu Ansible.

```ini
[Orchestrators]
wojtek2 ansible_host=wojtek2 ansible_user=Wojtek

[Endpoints]
ansible-target ansible_host=ansible-target ansible_user=ansible
```

![10](https://github.com/user-attachments/assets/94d998bd-092a-46d8-bb2a-f6107a1cfd60)


## Zdalne wywoływanie procedur

### Ping wszystkich maszyn – komenda `ansible`

Wykonano zdalne polecenie `ping` dla wszystkich maszyn zadeklarowanych w pliku `inventory.ini`, co potwierdziło gotowość środowiska do dalszych zautomatyzowanych działań.

![11](https://github.com/user-attachments/assets/8e7504e4-43ce-4e81-b94d-e1b3bd3da6b6)


### Ping wszystkich maszyn – playbook YAML

Utworzono playbook `ping.yml`, którego celem było wysłanie polecenia `ping` do wszystkich hostów.

```yaml
- name: Ping all hosts
  hosts: all
  tasks:
    - name: Ping host
      ansible.builtin.ping:
```

![12 1](https://github.com/user-attachments/assets/cfda2029-4398-451b-ae36-3681681adfe5)


### Uruchomienie playbooka

Playbook został wykonany za pomocą polecenia:

```bash
ansible-playbook -i inventory.ini ping.yml
```

Zadanie zakończyło się sukcesem dla obu maszyn – `wojtek2` i `ansible-target`.

![12 2](https://github.com/user-attachments/assets/614d0cae-e681-4438-8b16-5ef5164fce1e)


### Skopiowanie pliku inwentaryzacji na maszynę docelową

Utworzono playbook `copy_inventory.yml`, którego zadaniem było przesłanie pliku `inventory.ini` do katalogu `/tmp` na maszynie z grupy `Endpoints`.

```yaml
- name: Copy inventory file to Endpoints
  hosts: Endpoints
  tasks:
    - name: Copy inventory.ini to /tmp
      copy:
        src: inventory.ini
        dest: /tmp/inventory.ini
```

![13 1](https://github.com/user-attachments/assets/9085e5e6-305c-46da-8a2f-9c874e78fca0)


Uruchomienie playbooka zakończyło się sukcesem:

```bash
ansible-playbook -i inventory.ini copy_inventory.yml
```


![13 2](https://github.com/user-attachments/assets/08bd4c4b-a206-440f-b7b6-29dce9a45cde)

### Powtórne wykonanie playbooka ping po skopiowaniu inwentaryzacji

Po przesłaniu pliku inwentaryzacji ponownie wykonano `ping.yml`, aby sprawdzić, czy środowisko działa bez zmian.

![14](https://github.com/user-attachments/assets/f8959560-f290-4e9e-82ad-844248fa20e1)


### Aktualizacja pakietów w systemie

Został przygotowany playbook `upgrade.yml`, który aktualizuje listę pakietów oraz wykonuje pełną aktualizację systemu na maszynach `Endpoints`.

```yaml
- name: Update all packages
  hosts: Endpoints
  become: true
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes

    - name: Upgrade all packages
      apt:
        upgrade: dist
```
![15 1](https://github.com/user-attachments/assets/889c3d2d-fc69-42e6-bc7e-51fc6fe77a6e)


Uruchomienie aktualizacji:

```bash
ansible-playbook -i inventory.ini upgrade.yml
```

Zakończone powodzeniem:

![15 2](https://github.com/user-attachments/assets/43aad8c9-5341-46a0-9cdb-c6bf4490de00)


### Restart usług sshd i rngd

Utworzono playbook `restart_services.yml`, który restartuje usługę `sshd` oraz próbnie usługę `rngd`. W przypadku jej braku błąd jest ignorowany.

```yaml
- name: Restart services
  hosts: Endpoints
  become: true
  tasks:
    - name: Restart sshd
      service:
        name: ssh
        state: restarted

    - name: Restart rngd
      service:
        name: rngd
        state: restarted
      ignore_errors: true
```

![16 1](https://github.com/user-attachments/assets/b2015be4-0242-4abd-8359-bcfb2a9d274a)


Uruchomienie:

```bash
ansible-playbook -i inventory.ini restart_services.yml
```


![16 2](https://github.com/user-attachments/assets/eb05066a-d608-43a4-9e33-467ebbc8a51e)

### Symulacja niedostępności hosta (wyłączony sshd)

W celu przetestowania zachowania systemu w przypadku niedostępności, ręcznie zatrzymano i wyłączono usługę `ssh` na maszynie `ansible-target`, używając `systemctl` lub `sysv-init`, zależnie od dostępności polecenia:

![17 1](https://github.com/user-attachments/assets/b1c1ef26-734f-42cf-8a4f-decb13dd7c09)


Ponowne uruchomienie playbooka `ping.yml` spowodowało błąd łączności z `ansible-target`, zgodnie z oczekiwaniami:

![17 2](https://github.com/user-attachments/assets/82060cd9-9f4e-4146-bb9c-6741741a6c24)


### Wdrożenie aplikacji z wykorzystaniem Dockera

W kolejnym etapie przeprowadzono wdrożenie kontenera Docker zawierającego aplikację przygotowaną we wcześniejszych zajęciach. Cały proces został zautomatyzowany z użyciem trzech oddzielnych playbooków.

### Instalacja Dockera za pomocą Ansible

W pierwszej kolejności przygotowano playbook `install_docker.yml`, którego zadaniem była instalacja Dockera na maszynie docelowej `ansible-target`. W playbooku znalazły się kroki aktualizacji cache, instalacji zależności, dodania repozytorium Dockera oraz uruchomienia usługi Docker.

![18 1](https://github.com/user-attachments/assets/f0b525a2-9e87-434d-a43d-dfa8e29019fd)


Uruchomienie playbooka zakończyło się sukcesem, co potwierdziło poprawne działanie wszystkich zadań.

![18 2](https://github.com/user-attachments/assets/66bd355f-42fc-43ff-9103-b53ee1136e24)


### Wysyłka obrazu Docker (plik tar) na maszynę docelową

Następnie utworzono playbook `send_image.yml`, którego zadaniem było przesłanie obrazu Docker (plik `.tar`) na maszynę docelową do katalogu `/tmp`.

![19 1](https://github.com/user-attachments/assets/7031ddd2-b4c6-4c08-bd75-d732a07c639b)


Operacja zakończyła się poprawnie:

![19 2](https://github.com/user-attachments/assets/277fe0ea-72c2-4b43-8688-b96048cf9422)

### Załadowanie obrazu do Dockera na maszynie zdalnej

Ostatnim krokiem było załadowanie przesłanego obrazu do lokalnego rejestru Docker na `ansible-target` za pomocą polecenia `docker load`. W tym celu przygotowano playbook `load_image.yml`.

![20 1](https://github.com/user-attachments/assets/d597e59e-95b7-4c96-b4c9-113aca85aba6)


Uruchomienie zakończyło się sukcesem, obraz został poprawnie załadowany do Dockera:

![20 2](https://github.com/user-attachments/assets/44077109-5ae5-4c59-a8c5-4bedb3a45ea2)


### Uruchomienie kontenera z aplikacją

W kolejnym kroku utworzono playbook `run_container.yml`, który umożliwił uruchomienie aplikacji z załadowanego obrazu. W przypadku istniejącego kontenera o nazwie `ts-app`, został on najpierw zatrzymany i usunięty.

![21 1](https://github.com/user-attachments/assets/5bf0da45-eb61-4e79-a35b-45dfa5fac771)


Playbook zakończył się sukcesem, potwierdzając uruchomienie nowego kontenera:

![21 2](https://github.com/user-attachments/assets/041d14a5-3b7e-43d5-8bb1-48897facc2f8)


### Weryfikacja działania aplikacji

Po zalogowaniu się na maszynę `ansible-target` poleceniem `docker ps` potwierdzono, że kontener `ts-app` jest aktywny i nasłuchuje na porcie 3000.

![22](https://github.com/user-attachments/assets/f3610cb4-7c72-468c-b404-7b82d2242dcd)


### Zatrzymanie i usunięcie kontenera

Na potrzeby testów przygotowano playbook `cleanup_container.yml`, który odpowiada za zatrzymanie oraz usunięcie uruchomionego kontenera aplikacji.

![23 1](https://github.com/user-attachments/assets/c127f4e2-d221-47dd-bf51-4620cea8baa4)


Playbook wykonano z powodzeniem:

![23 2](https://github.com/user-attachments/assets/e092b12a-fc79-4f8b-bc53-9d4ad069b5d4)


### Utworzenie roli Ansible dla aplikacji

Za pomocą polecenia `ansible-galaxy init ts_app` wygenerowano szkielet roli. Plik obrazu aplikacji został umieszczony w katalogu `files`, a główna logika operacji w pliku `tasks/main.yml`. Rola zawiera kolejno: kopiowanie obrazu, jego załadowanie do Dockera oraz uruchomienie kontenera.

![24 1](https://github.com/user-attachments/assets/6a535022-321d-4633-834c-1686309d3506)

![24 2](https://github.com/user-attachments/assets/46d6a7b3-65a5-4d16-94d2-103974aa5a35)

![24 3](https://github.com/user-attachments/assets/5d197a88-365d-4929-a458-b4f71adf1d25)


### Test roli aplikacyjnej

Na koniec przygotowano playbook `test_role.yml`, w którym przypisano rolę `ts_app` do hosta `ansible-target`. Test wykonano z sukcesem, co potwierdza poprawność działania roli.

![25](https://github.com/user-attachments/assets/a79ed647-a511-4a74-b413-942179072d5a)



## Podsumowanie i wnioski

Zrealizowane ćwiczenie potwierdziło skuteczność i elastyczność narzędzia Ansible jako platformy do automatyzacji zadań administracyjnych w środowisku wielomaszynowym. W trakcie pracy przeprowadzono pełny cykl konfiguracji i zarządzania systemem zdalnym — od podstawowej konfiguracji po wdrożenie kontenera aplikacyjnego.

### Kluczowe osiągnięcia:
- **Bezhasłowa łączność SSH** została pomyślnie skonfigurowana, co umożliwiło całkowicie automatyczne wykonywanie poleceń na maszynie docelowej.
- Utworzono i skutecznie przetestowano **własne pliki inwentaryzacji**, zarówno w wersji uproszczonej, jak i zorganizowanej w grupy logiczne (`Orchestrators`, `Endpoints`), co ułatwiło zarządzanie infrastrukturą.
- **Zdalne wykonywanie poleceń** zostało zrealizowane poprzez zastosowanie modułów Ansible oraz dedykowanych playbooków YAML, które uruchamiały zadania w sposób powtarzalny i czytelny.
- Z sukcesem przeprowadzono **wdrożenie aplikacji kontenerowej z użyciem Dockera**, w tym:
  - Instalacja Dockera przy pomocy Ansible,
  - Transfer lokalnego obrazu `.tar` na maszynę zdalną,
  - Załadowanie i uruchomienie kontenera,
  - Weryfikacja działania i zarządzanie cyklem życia kontenera.
- **Testy awaryjności** (np. symulacja wyłączenia usługi `sshd`) umożliwiły weryfikację reakcji systemu na brak łączności oraz poprawność obsługi błędów w playbookach.
- Ostatecznym krokiem było utworzenie **roli Ansible (`ts_app`)** w zgodzie z dobrymi praktykami strukturyzowania kodu. Rola ta może być z łatwością wielokrotnie wykorzystywana lub modyfikowana, np. w dalszym ciągu pipeline’u CI/CD.

### Wnioski:
- Ansible to potężne narzędzie do automatyzacji, które przy relatywnie niskim progu wejścia pozwala na znaczne usprawnienie zarządzania środowiskami serwerowymi.
- Automatyzacja nawet prostych zadań (jak aktualizacja pakietów czy restart usług) zapewnia oszczędność czasu, powtarzalność i minimalizację błędów ludzkich.
- Użycie playbooków YAML w połączeniu z modularnym podejściem (role) pozwala na tworzenie skalowalnych i czytelnych rozwiązań do zarządzania aplikacjami i infrastrukturą.
- Praca z kontenerami w środowisku Ansible umożliwia przygotowanie niezależnych, przenośnych artefaktów aplikacyjnych, które mogą być wdrażane nawet w środowiskach bez dostępu do internetu (np. poprzez transfer `.tar`).
- Wiedza zdobyta podczas realizacji zadania jest nie tylko przydatna dydaktycznie, ale stanowi również solidną podstawę pod realne wdrożenia w projektach DevOps i administracji systemami.



# Sprawozdanie z zajęć 10: Wdrażanie na zarządzalne kontenery - Kubernetes (1)

## Wstęp

Celem niniejszego sprawozdania jest przedstawienie procesu instalacji i konfiguracji lokalnego klastra Kubernetes z wykorzystaniem narzędzia Minikube oraz wdrożenia przykładowej aplikacji kontenerowej. Dokument zawiera opis kolejnych kroków, takich jak uruchomienie klastra, instalacja Dashboardu, wdrożenie aplikacji w kontenerze, a także utworzenie i zastosowanie pliku manifestu YAML do zarządzania zasobami Kubernetes. Sprawozdanie ukazuje również komunikację z aplikacją przez odpowiednio przekierowane porty oraz omówienie podstawowych obiektów Kubernetes takich jak pod, deployment czy service.

W kolejnych sekcjach do dokumentu będą dodawane zrzuty ekranu oraz ich opisy, prezentujące wykonane etapy zadania.

---

## Instalacja Minikube

Do instalacji Minikube wykorzystano oficjalne źródło udostępniane przez Google. Proces składał się z następujących kroków:

1. Pobranie pliku binarnego Minikube:

   ```bash
   curl -Lo minikube-linux-amd64 https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
   ```
2. Nadanie uprawnień wykonywalnych:

   ```bash
   chmod +x minikube-linux-amd64
   ```
3. Przeniesienie pliku do katalogu binarnego systemu:

   ```bash
   sudo mv minikube-linux-amd64 /usr/local/bin/minikube
   ```
4. Sprawdzenie wersji zainstalowanego Minikube:

   ```bash
   minikube version
   ```

![3 1](https://github.com/user-attachments/assets/6f65ea6c-820a-4407-8e9f-0e7d5e9fe105)


## Instalacja kubectl

W celu zarządzania klastrem Kubernetes należy zainstalować klienta `kubectl`. Proces wyglądał następująco:

1. Ustawienie zmiennej środowiskowej z wersją:

   ```bash
   export KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
   ```
2. Pobranie odpowiedniej wersji klienta:

   ```bash
   curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
   ```
3. Nadanie uprawnień i przeniesienie pliku:

   ```bash
   chmod +x kubectl
   sudo mv kubectl /usr/local/bin/
   ```
4. Weryfikacja instalacji:

   ```bash
   kubectl version --client
   ```

![3 2](https://github.com/user-attachments/assets/97f22e24-990a-4432-93c9-45f73c71c5c7)


## Uruchomienie klastra Minikube

Następnie uruchomiono lokalny klaster Minikube z wykorzystaniem sterownika Docker i przypisanymi zasobami CPU oraz RAM:

```bash
minikube start --driver=docker --cpus=2 --memory=2048
```

Minikube pobrał obraz bazowy, zainicjował kontroler i przygotował potrzebne komponenty Kubernetes, w tym RBAC, certyfikaty oraz CNI.

![3 3](https://github.com/user-attachments/assets/65ede70c-c5a1-4ee1-b281-b61b468638e4)


## Weryfikacja działania klastra i bezpieczeństwa

Po starcie klastra sprawdzono jego status oraz stan węzła:

1. Polecenie sprawdzające status:

   ```bash
   minikube status
   ```
2. Informacje o węzłach:

   ```bash
   kubectl get nodes -o wide
   ```
   
![3 4](https://github.com/user-attachments/assets/d8e0d19d-418e-4f70-abae-7640cac777fd)



Dodatkowo dokonano weryfikacji obecności certyfikatów wykorzystywanych do zabezpieczenia komunikacji wewnętrznej:

```bash
minikube ssh
ls /var/lib/minikube/certs/
```

![3 5](https://github.com/user-attachments/assets/c9679dc9-0f48-4c48-891a-d97e64629d03)


## Uruchomienie Dashboardu Kubernetes

Dashboard został uruchomiony z wykorzystaniem polecenia:

```bash
minikube dashboard --url
```

Dostęp do panelu możliwy był lokalnie poprzez adres URL wskazany przez Minikube.

![3 6](https://github.com/user-attachments/assets/9955a7cc-237b-4ead-94e2-6f4129e42f6f)

## Uruchomienie aplikacji jako kontenera (pod)

Kolejnym krokiem było uruchomienie aplikacji kontenerowej `nginx` w postaci pojedynczego podu:

```bash
kubectl run moja-aplikacja \
  --image=nginx \
  --port=80 \
  --labels app=moja-aplikacja
```

Sprawdzono poprawność działania poleceniem:

```bash
kubectl get pods
```

![3 8](https://github.com/user-attachments/assets/c15849f2-1b0e-4343-ab98-51d7da5a82c1)


## Przekierowanie portu i test komunikacji

W celu przetestowania działania aplikacji przekierowano port z lokalnego hosta na port kontenera `nginx`:

```bash
kubectl port-forward pod/moja-aplikacja 8080:80
```

![3 9](https://github.com/user-attachments/assets/52442134-dd06-4c81-b6fd-d95026db8f9a)


Następnie wykonano zapytanie HTTP na przekierowany port, aby upewnić się, że aplikacja działa poprawnie:

```bash
curl http://127.0.0.1:8080
```

![3 10 1__](https://github.com/user-attachments/assets/522a8d61-8781-4e1f-b2f6-184ae315f665)


Działanie aplikacji zostało także potwierdzone przez przeglądarkę:

![3 10](https://github.com/user-attachments/assets/476b0e47-2991-4df6-b65e-55749c25b2bb)


## Monitoring działania i przygotowanie deploymentu

Aplikacja kontynuuje działanie, co potwierdzono obserwując stan podu oraz ponownie przekierowując port:

![3 11](https://github.com/user-attachments/assets/fd64aa60-1797-4f35-b9ed-89f2723c5bb4)


## Tworzenie pliku deploymentu YAML

Na potrzeby trwałego zarządzania zasobami klastra przygotowano plik `nginx-deployment.yml`, zawierający:

* deployment z 4 replikami kontenera nginx,
* serwis typu NodePort eksponujący port 30080.

Plik został utworzony i zapisany w edytorze tekstowym:

![3 12](https://github.com/user-attachments/assets/2366f165-6c0b-46ab-bfbe-5866361c015d)


## Wdrożenie z pliku YAML i rollout

Po utworzeniu pliku YAML wdrożenie zostało zrealizowane za pomocą:

```bash
kubectl apply -f nginx-deployment.yml
```

Stan rollout został sprawdzony za pomocą:

```bash
kubectl rollout status deployment/nginx-deployment
```

![3 13](https://github.com/user-attachments/assets/a80ffc34-ff00-4044-9e1b-f19ad8f5a5c8)


## Weryfikacja działania wdrożenia i usługi

Sprawdzono działające pody:

```bash
kubectl get pods
```

oraz utworzony serwis:

```bash
kubectl get svc nginx-service
```

Następnie wywołano polecenie:

```bash
minikube service nginx-service --url
```

w celu uzyskania adresu URL.

![3 14](https://github.com/user-attachments/assets/d93e08ec-cfd6-487d-bf33-3a56e217154d)


## Wizualizacja wdrożenia w Dashboardzie

Status wdrożenia oraz liczba aktywnych replik została zweryfikowana w Dashboardzie:

![3 16](https://github.com/user-attachments/assets/a15960c5-e0e6-4849-90e3-abdb8c11c106)


## Test końcowy – dostępność aplikacji

Ostatecznie sprawdzono dostępność aplikacji `nginx` za pomocą przeglądarki internetowej, używając podanego portu NodePort:


![3 17](https://github.com/user-attachments/assets/39e2f5fd-ef81-4e14-b403-ed45a27fb99a)

## Podsumowanie i wnioski

W trakcie realizacji zadania zapoznałem się z pełnym cyklem wdrażania aplikacji kontenerowej w środowisku Kubernetes, korzystając z lokalnego klastra Minikube. Pozwoliło mi to zrozumieć zarówno techniczne aspekty konfiguracji klastra, jak i koncepcje architektoniczne leżące u podstaw zarządzania kontenerami w K8s.

Nauczyłem się:

- jak zainstalować i skonfigurować narzędzia `minikube` oraz `kubectl`,
- w jaki sposób uruchomić lokalny klaster Kubernetes i monitorować jego stan,
- jak działają podstawowe obiekty Kubernetes: Pod, Deployment, Service,
- jak wykorzystywać port forwarding oraz typ `NodePort` do wystawiania usług na zewnątrz klastra,
- jak zbudować i zastosować plik YAML w celu deklaratywnego zarządzania zasobami,
- jak używać `kubectl` do kontrolowania cyklu życia aplikacji i rolloutów,
- w jaki sposób korzystać z Kubernetes Dashboard w celu wizualizacji i nadzorowania zasobów klastra.

Zajęcia te ugruntowały moją wiedzę na temat konteneryzacji i orkiestracji aplikacji. Zrozumiałem, że Kubernetes nie tylko automatyzuje uruchamianie i skalowanie aplikacji, ale też zapewnia elastyczne, bezpieczne i powtarzalne środowisko do ich utrzymania. Dzięki zdobytej wiedzy czuję się pewniej w zakresie zarządzania usługami w środowisku chmurowym oraz jestem gotowy do dalszej nauki i pracy z bardziej zaawansowanymi funkcjonalnościami K8s, takimi jak load balancing, persistent storage czy konfiguracja CI/CD.



# Sprawozdanie – Zajęcia 11: Kubernetes (2)

Celem zajęć było praktyczne pogłębienie wiedzy z zakresu zarządzania kontenerami w środowisku Kubernetes. W ramach ćwiczeń wykonano szereg operacji związanych z wdrażaniem aplikacji, ich wersjonowaniem, kontrolą stanu wdrożeń oraz testowaniem mechanizmów rollbacku. Dodatkowo przeanalizowano różne strategie wdrażania – w tym Recreate, Rolling Update oraz Canary Deployment. Wszystkie działania zostały przeprowadzone z wykorzystaniem własnych obrazów Docker, opublikowanych na prywatnym koncie Docker Hub.

W kolejnych sekcjach zamieszczono zrzuty ekranu oraz opisy kroków wykonanych podczas zajęć.

## Etap 1: Przygotowanie własnego obrazu Docker – Wersja v1

### Tworzenie katalogu i plików

Na pierwszym etapie utworzono strukturę katalogów potrzebną do budowy własnego obrazu Docker:

```bash
mkdir my-nginx && cd my-nginx
mkdir my-custom-content
```

Następnie przygotowano plik `index.html`, który stanowił zawartość strony serwowanej przez kontener Nginx:

```bash
echo '<h1>Hello, this is my custom Nginx page – Version 1!</h1>' > my-custom-content/index.html
```

![4 1](https://github.com/user-attachments/assets/6aa25456-f801-4c30-a783-9801ea38478e)


---

### Tworzenie pliku `Dockerfile`

Został utworzony plik `Dockerfile` zawierający instrukcje budowy obrazu:

```Dockerfile
FROM nginx:alpine

# Kopiowanie niestandardowej zawartości
COPY my-custom-content/ /usr/share/nginx/html/

# Ekspozycja portu
EXPOSE 80

# Komenda startowa
CMD ["nginx", "-g", "daemon off;"]
```

Obraz bazuje na lekkiej wersji Nginx (`nginx:alpine`), a zawartość statyczna kopiowana jest do katalogu domyślnego Nginx (`/usr/share/nginx/html/`).

![4 2](https://github.com/user-attachments/assets/e51dee51-df54-4fc1-a815-61fb35670790)


---

### Budowanie obrazu i logowanie do Docker Hub

Po przygotowaniu plików zbudowano obraz z tagiem `v1`:

```bash
docker build -t wojtek2004/my-nginx:v1 .
```


![4 3](https://github.com/user-attachments/assets/b24f4adc-b864-4d6c-b4e0-5c44b5de2851)

Następnie wykonano logowanie do Docker Hub za pomocą polecenia:

```bash
docker login -u wojtek2004
```

Proces logowania zakończył się sukcesem.

![4 4](https://github.com/user-attachments/assets/f8331a63-0c39-402d-afc8-c186d5f60007)

---

### Publikacja obrazów Docker na Docker Hub

Po zbudowaniu obrazu wersji `v1`, `v2` i `v3`, przesłano je do zewnętrznego rejestru Docker Hub.

#### Wersja v1:

```bash
docker push wojtek2004/my-nginx:v1
```

![4 5](https://github.com/user-attachments/assets/2cdea8c9-69e0-4db7-b833-e96c8d7b2b34)


#### Wersja v2:

Po modyfikacji zawartości strony (zaktualizowany tekst), zbudowano nową wersję obrazu i przesłano ją do rejestru:

```bash
echo '<h1>Hello, this is my custom Nginx page – Version 2 (Updated)!</h1>' > my-custom-content/index.html
docker build -t wojtek2004/my-nginx:v2 .
docker push wojtek2004/my-nginx:v2
```
![4 6](https://github.com/user-attachments/assets/9d87fa84-4714-4eac-aa99-feb03a695ea4)

#### Wersja v3 (wadliwa):

W celu przetestowania mechanizmów rollbacku, przygotowano wersję obrazu z celowo wadliwą konfiguracją nginx.conf:

Zmieniono `Dockerfile`, dodając kopiowanie pliku konfiguracyjnego do katalogu `/etc/nginx/conf.d/`:

```Dockerfile
COPY my-custom-content/nginx.conf /etc/nginx/conf.d/default.conf
```

![4 8](https://github.com/user-attachments/assets/bc946c8c-4155-4894-839e-ccc92ef9e6f4)




Obraz zbudowano i opublikowano:

```bash
docker build -t wojtek2004/my-nginx:v3 .
docker push wojtek2004/my-nginx:v3
```


![4 9](https://github.com/user-attachments/assets/d2459d6c-98fe-4098-9005-3a909d10bba3)

---

## Etap 2: Tworzenie i zastosowanie deploymentu

### Przygotowanie pliku `nginx-deployment.yaml`

Stworzono plik manifestu YAML zawierający definicję `Deployment` i `Service`. W pliku ustalono strategię aktualizacji jako `RollingUpdate` oraz początkową liczbę replik jako 3:

![4 10](https://github.com/user-attachments/assets/7ebe77d6-ee0d-4634-b837-02e3f77f41ff)


### Zastosowanie deploymentu

Plik YAML został zastosowany w klastrze:

```bash
kubectl apply -f nginx-deployment.yaml
```


![4 11](https://github.com/user-attachments/assets/3776f12f-1b75-4cb1-a9df-6fb02c366bfe)

Początkowo kontenery miały status `ContainerCreating`, po chwili ich stan zmienił się na `Running`, co oznaczało poprawne wdrożenie.

---

### Skalowanie deploymentu

#### Zwiększenie liczby replik do 8:

```bash
kubectl scale deployment my-nginx-deployment --replicas=8
```

![4 12](https://github.com/user-attachments/assets/76b38e4f-7c4b-4c2c-ba88-c143aecd77fb)

#### Zmniejszenie liczby replik do 1:

```bash
kubectl scale deployment my-nginx-deployment --replicas=1
```

![4 13](https://github.com/user-attachments/assets/73421619-330b-4659-9413-811c45c16eed)


#### Zmniejszenie liczby replik do 0:

```bash
kubectl scale deployment my-nginx-deployment --replicas=0
```
![4 14](https://github.com/user-attachments/assets/638bf5b6-7f35-4998-b7e4-9d8e320f278a)


#### Przywrócenie liczby replik do 4:

```bash
kubectl scale deployment my-nginx-deployment --replicas=4
```

Po kilku sekundach wszystkie nowe Pody osiągnęły status `Running`.

![4 15](https://github.com/user-attachments/assets/05b5a090-adbd-404c-b1f2-5a46697d3ce7)


---

## Etap 3: Zarządzanie wersjami obrazu

### Aktualizacja do wersji v2

Przeprowadzono aktualizację obrazu w deploymentcie do wersji `v2`:

```bash
kubectl set image deployment/my-nginx-deployment nginx=wojtek2004/my-nginx:v2
kubectl rollout status deployment/my-nginx-deployment
```

Nowe Pody zostały wdrożone, stare usunięte, a cała operacja zakończyła się sukcesem.

![4 16](https://github.com/user-attachments/assets/0ed3bf61-b98e-4eb9-a6a6-816119648429)


### Aktualizacja do wersji v1

Kolejno przywrócono obraz do wcześniejszej, stabilnej wersji `v1`:

```bash
kubectl set image deployment/my-nginx-deployment nginx=wojtek2004/my-nginx:v1
kubectl rollout status deployment/my-nginx-deployment
```

![4 17](https://github.com/user-attachments/assets/18ca4c3d-cc63-4d65-938c-607f41ae2c0a)


### Aktualizacja do wadliwej wersji v3

Na potrzeby testów wykonano aktualizację deploymentu do wersji `v3`, zawierającej błędny plik konfiguracyjny:

```bash
kubectl set image deployment/my-nginx-deployment nginx=wojtek2004/my-nginx:v3
kubectl rollout status deployment/my-nginx-deployment --timeout=60s
```

Nowe Pody nie mogły zostać uruchomione poprawnie — uzyskały status `Error`. Po osiągnięciu limitu czasu rollout zakończył się błędem.

![4 18](https://github.com/user-attachments/assets/9dad6abe-e016-4514-b3bb-7b368442271a)


---

## Etap 4: Rollback do poprzedniej wersji

Po nieudanej aktualizacji do wersji `v3` przywrócono wcześniejszy stabilny stan deploymentu:

```bash
kubectl rollout history deployment/my-nginx-deployment
kubectl rollout undo deployment/my-nginx-deployment
kubectl rollout status deployment/my-nginx-deployment
```

Stare działające Pody zostały przywrócone i deployment osiągnął stan `Running`.

![4 19](https://github.com/user-attachments/assets/2197cdd3-1543-44c2-9b81-ee893ff098f0)


---

## Etap 5: Weryfikacja rolloutu – skrypt automatyczny

W celu automatycznej weryfikacji, czy rollout zakończył się w ciągu 60 sekund, utworzono skrypt `check-rollout.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

DEPLOY=my-nginx-deployment
TIMEOUT=60s

echo "Waiting up to ${TIMEOUT} for ${DEPLOY} to finish rollout…"
if kubectl rollout status deployment/${DEPLOY} --timeout=${TIMEOUT}; then
  echo "✅ Deployment ${DEPLOY} finished within ${TIMEOUT}."
  exit 0
else
  echo "❌ Deployment ${DEPLOY} did NOT finish within ${TIMEOUT}." >&2
  exit 1
fi
```
![4 20](https://github.com/user-attachments/assets/e389c038-a192-4ee1-9034-61da96c2e875)

Skrypt wykonano po wdrożeniu działającej i wadliwej wersji:

* Przypadek udany zakończył się statusem `0`.
* Przypadek błędny zakończył się błędem `1`.
![4 21](https://github.com/user-attachments/assets/dfd7785d-e60d-463e-8ea3-59aeed71ca2f)

![4 22](https://github.com/user-attachments/assets/e60d18f1-2e10-4c6c-b531-f4af2ba60ff4)

---

## Etap 6: Strategie wdrażania (Recreate, RollingUpdate, Canary)

### Strategia Recreate

Przygotowano i zastosowano plik `nginx-deploy-recreate.yaml` zawierający strategię `Recreate`. Zastosowanie nowego obrazu `v2` powodowało usunięcie wszystkich starych Podów przed uruchomieniem nowych:

![4 23](https://github.com/user-attachments/assets/b968a4e1-5d90-4a19-9d00-24c6202f7ab4)

### Strategia Rolling Update z parametrami

Utworzono plik `nginx-deploy-rolling.yaml`, ustawiając `maxUnavailable=2`, `maxSurge=20%`. Wdrożenie odbywało się stopniowo, jednocześnie tworząc i usuwając Pody zgodnie z tymi ograniczeniami.


![4 24](https://github.com/user-attachments/assets/607b6d46-abc9-45b2-b152-b6304fac7870)


### Strategia Canary Deployment

W tej metodzie wydzielono dwie wersje deploymentu: `my-nginx-stable` i `my-nginx-canary`. Wersja `canary` odpowiadała tylko za część ruchu (pojedynczy Pod). Pozwoliło to na bezpieczne testowanie nowej wersji przed pełnym wdrożeniem.

![4 25](https://github.com/user-attachments/assets/d8161062-4e14-4f74-bf71-90536a77824e)

---
## Pliki YAML: Strategie wdrażania w Kubernetes

### `nginx-deploy-recreate.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-recreate
spec:
  replicas: 3
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: my-nginx
  template:
    metadata:
      labels:
        app: my-nginx
    spec:
      containers:
      - name: nginx
        image: wojtek2004/my-nginx:v1
        ports:
        - containerPort: 80
```

### `nginx-deploy-rolling.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-rolling
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 2
  selector:
    matchLabels:
      app: my-nginx
  template:
    metadata:
      labels:
        app: my-nginx
    spec:
      containers:
      - name: nginx
        image: wojtek2004/my-nginx:v1
        ports:
        - containerPort: 80
```

### `nginx-deploy-canary.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-stable
spec:
  replicas: 4
  selector:
    matchLabels:
      app: my-nginx
      version: stable
  template:
    metadata:
      labels:
        app: my-nginx
        version: stable
    spec:
      containers:
      - name: nginx
        image: wojtek2004/my-nginx:v1
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-nginx
      version: canary
  template:
    metadata:
      labels:
        app: my-nginx
        version: canary
    spec:
      containers:
      - name: nginx
        image: wojtek2004/my-nginx:v2
```

## Porównanie strategii wdrażania

### 1. Recreate

* W tej strategii wszystkie stare instancje są najpierw usuwane, a dopiero później uruchamiane są nowe.
* Powoduje to chwilową niedostępność aplikacji.
* Jest prosta, ale nie nadaje się do środowisk produkcyjnych wymagających wysokiej dostępności.

### 2. RollingUpdate (z `maxUnavailable=2`, `maxSurge=2`)

* Stare wersje są zastępowane nowymi w sposób stopniowy.
* Parametry `maxUnavailable` i `maxSurge` określają ilu podów może być niedostępnych lub ponad plan w trakcie aktualizacji.
* Zapewnia większą dostępność aplikacji podczas aktualizacji, ale wymaga więcej zasobów.

### 3. Canary

* Wdrażana jest nowa wersja tylko w jednej instancji (np. 1 replika), obok stabilnych.
* Pozwala na testowanie nowej wersji przy minimalnym ryzyku.
* W przypadku błędów łatwo jest usunąć wdrożenie canary bez wpływu na działające środowisko.
* Wymaga dodatkowego zarządzania (np. routing ruchem, metryki).

Każda z tych strategii ma swoje zastosowania zależnie od środowiska i poziomu ryzyka akceptowalnego podczas aktualizacji aplikacji.

 

## Podsumowanie

W ramach ćwiczenia przygotowano trzy wersje własnego obrazu Nginx, skonfigurowano deployment z różnymi strategiami wdrażania, przetestowano mechanizmy rollbacku oraz stworzono automatyczny skrypt do weryfikacji rolloutu.



