# Zajęcia 08 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

## Instalacja zarządcy Ansible




```
sudo dnf -y install tar openssh-server
```

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
sudo cp /root/anaconda-ks.cfg /home/amelia/fedora-auto.ks
sudo chown amelia:amelia /home/amelia/fedora-auto.ks

```
W celu dalszej edycji, skopiowano plik instalacyjny `anaconda-ks.cfg` z katalogu `/root` do katalogu domowego użytkownika `amelia` jako `fedora-auto.ks`. Następnie zmieniono właściciela pliku, aby użytkownik `amelia` mógł go modyfikować bez użycia uprawnień administratora.

####  Dodanie zdalnych repozytoriów pakietów

W pliku kickstart dodałem następujące dyrektywy, odpowiadające wersji Fedora 41:

```
url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64

```

Dyrektywa url wskazuje podstawowy mirror Fedory z pakietami instalacyjnymi, a repo --name=updates zapewnia dostęp do najnowszych aktualizacji. Umieszczenie tych wpisów w pliku kickstart pozwala instalatorowi automatycznie pobrać wszystkie wymagane pakiety z sieci, niezależnie od zawartości obrazu ISO. 

#### Zapewnienie formatowania całego dysku – clearpart --all

Aby zapewnić, że instalacja systemu zawsze rozpocznie się na czystym dysku, zmodyfikowano sekcję partycjonowania w pliku Kickstart. Zamiast opcji --none, użyto polecenia:

```
clearpart --all --initlabel

```

Polecenie to wymusza usunięcie wszystkich istniejących partycji na wskazanym dysku oraz nadpisanie tablicy partycji (np. GPT lub MBR). 

#### Ustawienie niestandardowej nazwy hosta

Do pliku odpowiedzi kickstart dodano polecenie:

```
network --bootproto=dhcp --hostname=fedora-test-host

```
Dzięki temu system po zakończonej instalacji automatycznie otrzymuje nazwę fedora-test-host, co ułatwia jego identyfikację w sieci oraz w środowiskach wirtualnych.

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

Następnie zastosowano polecenie:

```
kubectl scale deployment amelia-web --replicas=1 
```
czyli zredukowano liczbę działających podów do jednej instacji.

W kolejnym etapie użyto komendy 
```
kubectl scale deployment amelia-web --replicas=0 
```
Ta komenda usuwa wszystkie pody i powoduje tymaczsowe wyłączenie aplikacji.

 Polecenie 
 ```
 kubectl scale deployment amelia-web --replicas=4

 ```
 ponownie uruchomiło cztery instancje aplikacji, wszystkie osiągnęły stan „Running”.

