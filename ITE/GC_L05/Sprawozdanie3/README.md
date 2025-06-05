# Zajęcia 08 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible


## Przygotowanie maszyn wirtualnych

Utworzono dwie maszyny wirtualne z systemem Fedora.

Na drugiej maszynie nadano hostname: ansible-target, utworzono użytkownika: ansible, zainstalowano: openssh-server, tar i wykonano migawkę maszyny.

## Instalacja Ansible i konfiguracja połączeń

Zainstalowano dwa podstawowe pakiety: tar oraz openssh-server:

```
sudo dnf -y install tar openssh-server
```

## Uruchomienie i włączenie SSH

Po instalacji, usługa SSH została aktywowana i ustawiona, by uruchamiała się automatycznie przy starcie systemu:

```
systemctl status sshd
systemctl enable sshd
ip a

```


---

# Zajęcia 09 - Pliki odpowiedzi dla wdrożeń nienadzorowanych

---

###  Cel zadania

Celem zadania było przygotowanie źródła instalacji nienadzorowanej systemu Fedora w środowisku maszyn wirtualnych lub serwerów fizycznych. Instalacja ta miała automatycznie przygotować system operacyjny hostujący oprogramowanie – działające poza kontenerem. 

---

### Modyfikacja pliku kickstart

Po ręcznej instalacji systemu Fedora plik odpowiedzi instalatora (/root/anaconda-ks.cfg) został skopiowany i zmodyfikowany tak, aby umożliwić w pełni zautomatyzowaną instalację systemu, który po uruchomieniu jest gotowy do hostowania aplikacji.

#### Skopiowanie pliku anaconda-ks.cfg

Po zalogowaniu się do systemu, wykonałam polecenia:

```
cp /root/anaconda-ks.cfg /home/amelia/fedora-auto.ks
chown amelia:amelia /home/amelia/fedora-auto.ks

```

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/root.png?raw=true)

W celu dalszej edycji, skopiowano plik instalacyjny `anaconda-ks.cfg` z katalogu `/root` do katalogu domowego użytkownika `amelia` jako `fedora-auto.ks`. 

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/before_modifications.png?raw=true)

####  Dodanie zdalnych repozytoriów pakietów

W pliku kickstart dodano następujące dyrektywy, odpowiadające wersji Fedora 41:

```
url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

```

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/add_comends.png?raw=true)

Dyrektywa url wskazuje podstawowy mirror Fedory z pakietami instalacyjnymi, a repo --name=updates zapewnia dostęp do najnowszych aktualizacji. Umieszczenie tych wpisów w pliku kickstart pozwala instalatorowi automatycznie pobrać wszystkie wymagane pakiety z sieci, niezależnie od zawartości obrazu ISO. 

#### Zapewnienie formatowania całego dysku – clearpart --all

Aby zapewnić, że instalacja systemu zawsze rozpocznie się na czystym dysku, zmodyfikowano sekcję partycjonowania w pliku Kickstart. Zamiast opcji --none, użyto polecenia:

```
clearpart --all --initlabel

```

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/change_on_all.png?raw=true)

Polecenie to wymusza usunięcie wszystkich istniejących partycji na wskazanym dysku oraz nadpisanie tablicy partycji (np. GPT lub MBR). 

#### Ustawienie niestandardowej nazwy hosta

Do pliku odpowiedzi kickstart dodano polecenie:

```
network --bootproto=dhcp --hostname=fedora-test-host

```

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/network_ks.png?raw=true)

Dzięki temu system po zakończonej instalacji automatycznie otrzymuje nazwę fedora-test-host, co ułatwia jego identyfikację w sieci oraz w środowiskach wirtualnych.

---

####  Użycie pliku Kickstart do przeprowadzenia instalacji nienadzorowanej

####  Rozszerzenie pliku Kickstart o oprogramowanie projektu

W sekcji %packages pliku Kickstart umieszczono niezbędne pakiety potrzebne do działania aplikacji, w tym narzędzia do pobierania, rozpakowywania oraz środowisko wykonawcze Javy:

```

%packages
wget
unzip
java-11-openjdk
%end

```

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/packages.png?raw=true)

Pakiety te są automatycznie instalowane przez instalator systemu podczas procesu nienadzorowanej instalacji.

#### Automatyczne pobieranie i uruchamianie aplikacji (%post)

W sekcji %post dodano skrypt, który pobiera aplikację z serwera HTTP, ustawia prawa do uruchomienia binarki i tworzy usługę systemd.

```

%post --log=/root/ks-post.log

wget http://192.168.1.100/projekt.zip -O /tmp/app.zip
unzip /tmp/app.zip -d /usr/local/bin/
chmod +x /usr/local/bin/myapp

cat <<EOF > /etc/systemd/system/myapp.service
Description=Moja Aplikacja
After=network.target
ExecStart=/usr/local/bin/myapp
Restart=always
WantedBy=multi-user.target
EOF
systemctl enable myapp.service
%end


```

####  Wyświetlanie komunikatów z sekcji %post na ekranie

Dodano do sekcji %post poniższe opcje:

```
%post --interpreter=/bin/bash --log=/root/ks-post.log

set -x  
exec > /dev/tty3 2>&1  


```

#### Wskazanie pliku Kickstart z nośnika lub z sieci




# Zajęcia 10 - Wdrażanie na zarządzalne kontenery: Kubernetes (1)

## Instalacja klastra Kubernetes

Zainstalowano  lokalny klaster Kubernetes z użyciem polecenia minikube.

```
minikube start

```

Następnie uruchomiono dashboard poleceniem:

```
minikube dashboard

```

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/minikube_dashboad.png?raw=true)

## Analiza posiadanego kontenera

---

## Uruchamianie oprogramowania

Uruchomiono jako pojedynczy pod:

```
minikube kubectl -- run nginx-demo --image=nginx-custom --port=80 --labels app=nginx-demo

```

Sprawdzono czy pod działa:

```
kubectl get pods

```

## Udostępnienie funkcjonalności za pomocą kubectl port-forward

W celu przetestowania działania aplikacji uruchomionej w kontenerze, wykonano polecenie:

```
kubectl port-forward pod/nginx-test 8080:80

```

Dzięki temu aplikacja, która nasłuchuje wewnątrz klastra, została przekierowana na port lokalny maszyny deweloperskiej, umożliwiając bezpośredni dostęp z przeglądarki lub narzędzi typu curl, httpie, Postman itp.

## Weryfikacja działania aplikacji

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/localhost8080-Amelia-Nawrot.png?raw=true)

## Przekucie wdrożenia manualnego w plik wdrożenia (wprowadzenie)

Utworzono plik nginx-deployment.yml:

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/nginx-deploy.png?raw=true)

---

# Zajęcia 11 - Wdrażanie na zarządzalne kontenery: Kubernetes (2)

---

## Przygotowanie nowego obrazu

W ramach realizacji zadania przygotowano dwa obrazy Dockera z aplikacją frontendową. Jako bazę wykorzystano publiczne repozytorium `Amelia_Nawrot_Web_Wroclaw`.

```
git clone https://github.com/LadyAmely/Amelia_Nawrot_Web_Wroclaw.git

```

Następnie zbudowano dwie wersje obrazu. Wersja pierwsza (v1) po zbudowaniu została załadowana bezpośrednio do klastra Kubernetes za pomocą polecenia:

```
minikube image load ladyamely/amelia-web:v1
minikube image load ladyamely/amelia-web:v2

```
Wersja druga (v2) została przygotowana celowo z błędem — poprzez modyfikację pliku Dockerfile. Tę wersję również załadowano do klastra Minikube.


Oba obrazy zostały oznaczone odpowiednimi tagami (v1 i v2) i użyte w definicji deploymentu Kubernetes. 

## Zmiany w deploymencie

W pierwszym kroku wykonano komendę:
```
kubectl scale deployment amelia-web --replicas=8
```
Polecenie uruchomiło 8 podów aplikacji w stanie „Running”.

![8 replicas screenshot](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/8%20replicas.png?raw=true)

Następnie zastosowano polecenie:

```
kubectl scale deployment amelia-web --replicas=1 
```
czyli zredukowano liczbę działających podów do jednej instacji.

![1 replicas screenshot](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/1%20replicas.png?raw=true)

W kolejnym etapie użyto komendy 
```
kubectl scale deployment amelia-web --replicas=0 
```
Ta komenda usuwa wszystkie pody i powoduje tymaczsowe wyłączenie aplikacji.

![0 replicas screenshot](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/0%20replicas.png?raw=true)

 Polecenie 
 ```
 kubectl scale deployment amelia-web --replicas=4

 ```
 ponownie uruchomiło cztery instancje aplikacji, wszystkie osiągnęły stan „Running”.

 ![4 replicas screenshot](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/4%20replicas.png)

Zastosowanie starszej wersji obrazu:

```
kubectl set image deployment amelia-web amelia-web=ladyamely/amelia-web:v1

```

![older version img](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/older%20image%20version.png?raw=true)

Zastosowanie wadliwego obrazu:

```
kubectl set image deployment amelia-web amelia-web=ladyamely/amelia-web:v2

```
![faulty version img](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/new%20image%20version%20.png?raw=true)

```
kubectl rollout history deployment amelia-web
```
![rollback history](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/rollout%20history.png?raw=true)

```
kubectl rollout undo deployment amelia-web
kubectl describe pod amelia-web
```
![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/undo%20v1.png?raw=true)

## Kontrola wdrożenia

W celu kontroli przebiegu wdrożeń, wykorzystano polecenie `kubectl rollout history`.
Wersja v2 zawierała błędną konfigurację i spowodowała, że pody wchodziły w stan CrashLoopBackOff. Kubernetes automatycznie przerwał rollout i nie kontynuował wdrażania pozostałych replik. Wdrożenie zakończyło się niepowodzeniem.

## Strategie wdrożenia

### Recreate

```

apiVersion: apps/v1
kind: Deployment
metadata:
  name: amelia-recreate
spec:
  replicas: 3
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: amelia
      version: recreate
  template:
    metadata:
      labels:
        app: amelia
        version: recreate
    spec:
      containers:
      - name: amelia-web
        image: ladyamely/amelia-web:v1
        ports:
        - containerPort: 80

```

### Rolling Update (z parametrami maxUnavailable > 1, maxSurge > 20%)

```

apiVersion: apps/v1
kind: Deployment
metadata:
  name: amelia-rolling
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 50%
  selector:
    matchLabels:
      app: amelia
      version: rolling
  template:
    metadata:
      labels:
        app: amelia
        version: rolling
    spec:
      containers:
      - name: amelia-web
        image: ladyamely/amelia-web:v1
        ports:
        - containerPort: 80


```

### Canary Deployment workload - v1

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: amelia-canary-v1
spec:
  replicas: 3
  selector:
    matchLabels:
      app: amelia
      version: v1
  template:
    metadata:
      labels:
        app: amelia
        version: v1
    spec:
      containers:
      - name: amelia-web
        image: ladyamely/amelia-web:v1
        ports:
        - containerPort: 80

```

### Canary Deployment workload - v2

```

apiVersion: apps/v1
kind: Deployment
metadata:
  name: amelia-canary-v2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: amelia
      version: canary
  template:
    metadata:
      labels:
        app: amelia
        version: canary
    spec:
      containers:
      - name: amelia-web
        image: ladyamely/amelia-web:v2
        ports:
        - containerPort: 80


```

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/all%20deployments.png?raw=true)

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/all%20get%20pods.png?raw=true)

---

### Porównanie

#### Rolling

Deployment amelia-rolling używa strategii RollingUpdate z parametrami maxUnavailable=2, maxSurge=50%. Podczas aktualizacji pody były stopniowo zastępowane nową wersją, a aplikacja była cały czas dostępna. W dashboardzie widać, że wszystkie 4 pody działają poprawnie.

#### Recreate

Deployment amelia-recreate zastosował strategię Recreate. Wszystkie stare pody zostały usunięte, zanim uruchomiono nowe. Mimo że aktualnie wszystkie 3 pody działają, ta strategia może powodować krótkotrwały brak dostępności. W czasie zmiany obrazu aplikacja przez chwilę była niedostępna.

#### Canary Deployment

Canary Deployment został zrealizowany za pomocą dwóch osobnych deploymentów: amelia-canary-v1 i amelia-canary-v2. Deployment v1 działa poprawnie. Natomiast v2 zawiera błędny obraz lub konfigurację — pod nie wystartował (0/1, status: Failed). 

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/labels.png?raw=true)

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/minikube%20service.png?raw=true)


