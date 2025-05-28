# 🧰 Sprawozdanie z konfiguracji Ansible i zarządzania artefaktem (Docker)

## 📦 1. Instalacja zarządcy Ansible

### 🌵 Utworzenie drugiej maszyny wirtualnej
Utworzono maszynę `ansible-target` z minimalnym zestawem oprogramowania, co ograniczyło zbędne usługi i poprawiło wydajność.

### 🌵 Taki sam system operacyjny jak maszyna główna
Obie maszyny działają na systemie Ubuntu 24.04 LTS, co ułatwia zarządzanie i eliminuje problemy kompatybilności.

### 🌵 Instalacja `tar` i `sshd`
Zainstalowano `tar` i `openssh-server`, aby umożliwić obsługę archiwów i dostęp przez SSH.

### 🌵 Nadanie hostname `ansible-target`
Nazwa hosta została ustawiona już podczas instalacji systemu ale jeszcze się upewniłem.

![Opis](ss/1.jpg)


### 🌵 Wykonanie migawki maszyny
Zrobiono migawkę w VirtualBoxie, co pozwala wrócić do stanu początkowego w razie problemów.

![Opis](ss/20.png)

### 🌵 Instalacja Ansible na głównej maszynie
Na `server` zainstalowano Ansible za pomocą APT:
```bash
sudo apt update && sudo apt install -y ansible
```
![Opis](ss/21.png)



### 🌵 Wymiana kluczy SSH
Na `server` wygenerowano parę kluczy SSH i przesłano je do `ansible@ansible-target`:
```bash
ssh-keygen
ssh-copy-id ansible@ansible-target
```
![Opis](ss/6.png)

---

## 🗂️ 2. Inwentaryzacja

### 🌵 Ustawienie nazw hostów
Ustawiono `hostnamectl` na obu maszynach:
```bash
hostnamectl set-hostname server
hostnamectl set-hostname ansible-target
```
![Opis](ss/7.png)



### 🌵 Dodanie wpisów do /etc/hosts
Na maszynie `server` wpisano:
```
192.168.100.10 ansible-target
192.168.100.11 server
```
![Opis](ss/22.png)



### 🌵 Weryfikacja łączności
Sprawdzono połączenie:
```bash
ping ansible-target
ping server
```
![Opis](ss/23.png)



### 🌵 Stworzenie pliku inwentaryzacji
Plik `inventory.ini`:
```ini
[Orchestrators]
server ansible_host=server ansible_user=krzysztof ansible_port=2222

[Endpoints]
ansible-target ansible_host=ansible-target ansible_user=ansible
```
![Opis](ss/6,5.png)
![Opis](ss/8.png)


### 🌵 Wysłanie ping przez Ansible
```bash
ansible -i inventory.ini all -m ping
```
![Opis](ss/11.png)




### 🌵 Użyto dwóch maszyn wirtualnych
Projekt został przeprowadzony z wykorzystaniem dwóch maszyn: `server` i `ansible-target`.

### 🌵 Ponowna wymiana kluczy ssh-copy-id
Upewniono się, że użytkownik `ansible` ma poprawnie dodany klucz publiczny.

### 🌵 Weryfikacja bezhasłowego logowania
SSH działało bez potrzeby wpisywania hasła.

![Opis](ss/6.png)
---

## ⚙️ 3. Zdalne wywoływanie procedur

### 🌵 Pingowanie z playbooka
Utworzono `ping.yml`:
```yaml
- hosts: all
  gather_facts: false
  tasks:
    - name: Ping
      ansible.builtin.ping:
```
![Opis](ss/12.png)

![Opis](ss/13.png)


### 🌵 Skopiowanie pliku inwentaryzacji na zdalną maszynę
```yaml
- hosts: Endpoints
  gather_facts: false
  tasks:
    - name: Copy inventory
      copy:
        src: ../inventory.ini
        dest: /home/ansible/inventory.ini
```

![Opis](ss/14.png)

![Opis](ss/15.png)

### 🌵 Porównanie wyników
Po skopiowaniu inventory na `ansible-target` uruchomiono test pingowy zdalnie — wynik był identyczny jak z `server`.

### 🌵 Aktualizacja systemu
```yaml
- hosts: Endpoints
  become: true
  tasks:
    - name: Update APT
      apt:
        update_cache: yes

    - name: Upgrade packages
      apt:
        upgrade: dist
```

![Opis](ss/16.png)
![Opis](ss/17.png)

### 🌵 Restart usług sshd i rngd
```yaml
- hosts: Endpoints
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

![Opis](ss/18.png)
![Opis](ss/19.png)

### 🌵 Test awarii (SSH down, interfejs down)
Wyłączono `sshd` i kartę sieciową. Ansible zgłosił `UNREACHABLE` — zgodnie z oczekiwaniami.

---

## 🐳 4. Zarządzanie artefaktem (kontener)

### 🌵 Budowa i uruchomienie kontenera
W playbooku użyto obrazu `nginx:alpine`, który został uruchomiony na porcie 8080.

### 🌵 Pobranie z Docker Hub
Ansible pobrał oficjalny obraz `nginx:alpine` bez potrzeby budowania lokalnego obrazu.

### 🌵 Instalacja Dockera przez Ansible
Rola `deploy_container` automatycznie instalowała Dockera przez APT.

### 🌵 Weryfikacja działania aplikacji
Sprawdzono dostępność strony pod `http://localhost:8080` za pomocą modułu `uri`.

### 🌵 Usunięcie kontenera
Na koniec, kontener `hello-app` został usunięty z maszyny docelowej przez Ansible.

---

## ✅ 5. Podsumowanie

- 🖥️ Środowisko składa się z dwóch maszyn wirtualnych
- 🔐 Zrealizowano logowanie bez hasła
- 📂 Plik inwentaryzacji z grupami: `Orchestrators` i `Endpoints`
- ⚙️ Stworzono playbooki do pingu, kopiowania, aktualizacji, restartu usług
- 🐳 Wdrożono i przetestowano kontener aplikacji z Docker Hub
- 📦 Rolę stworzono przy użyciu `ansible-galaxy`

__________________________________________________________________________________________________________________________________________

# 📝 Sprawozdanie: Pliki odpowiedzi dla wdrożeń nienadzorowanych

## 🎯 Zagadnienie

Tematem mojego zadania było przygotowanie źródła instalacyjnego systemu Fedora 42 w wersji nienadzorowanej, przeznaczonego do uruchomienia na maszynie wirtualnej. Takie źródła są szczególnie przydatne w środowiskach testowych oraz przy wdrażaniu oprogramowania, które nie działa w kontenerach, lecz wymaga pełnego systemu operacyjnego.

---

## 🎯 Cel zadania

Celem było:
- utworzenie pliku odpowiedzi (`kickstart`), który automatyzuje instalację systemu,
- przeprowadzenie rzeczywistej instalacji Fedora 42 na maszynie wirtualnej,
- zapewnienie, że system po instalacji będzie gotowy do hostowania oprogramowania.

---

## 📌 Etapy realizacji

### 1. Wybór instalatora

Do realizacji zadania wybrałem obraz **Fedora 42 Everything Netinst**, który pobrałem i uruchomiłem w środowisku **Oracle VirtualBox**.

---

### 2. Przygotowanie pliku odpowiedzi

Plik `anaconda-ks.cfg` został pobrany z repozytorium GitHub, a jego treść została zmodyfikowana zgodnie z poniższymi wymaganiami:

- dodanie repozytoriów dla pobrania pakietów:
  ```kickstart
  url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-42&arch=x86_64
  repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f42&arch=x86_64
  ```

- zapewnienie formatowania całego dysku:
  ```kickstart
  clearpart --all --initlabel
  ```

- ustawienie własnej nazwy hosta:
  ```kickstart
  network --hostname=fedora42-host
  ```

- stworzenie użytkownika z uprawnieniami sudo oraz ustawienie hasła root:
  ```kickstart
  rootpw --iscrypted <zakodowane_haslo>
  user --groups=wheel --name=user --password=haslohaslo --plaintext --iscrypted --gecos="user"
  ```

📷 *Miejsce na zrzut ekranu z podglądem pliku Kickstart*

---

### 3. Uruchomienie instalacji z Kickstart

W konfiguracji GRUB instalatora Fedora dodałem parametr:

```
inst.ks=https://tinyurl.com/bdejyufr
```

Dzięki temu instalator zaciągnął mój plik Kickstart z internetu i uruchomił się całkowicie automatycznie.

📷 *Miejsce na zrzut ekranu z GRUB i linkiem TinyURL*

---

### 4. Proces instalacji

Instalacja rozpoczęła się automatycznie, bez konieczności mojej ingerencji. Instalator przeszedł przez kolejne etapy:

- sprawdzenie konfiguracji dysku,
- tworzenie partycji (w tym `biosboot`),
- instalacja wybranych pakietów.

📷 *Miejsce na zrzut ekranu z logów instalatora Anaconda*
📷 *Miejsce na zrzut ekranu z postępu instalacji*

---

### 5. Weryfikacja po instalacji

Po zakończonej instalacji system uruchomił się poprawnie. Sprawdziłem:

- że użytkownik `user` został utworzony i ma dostęp do `sudo`,
- że hostname został ustawiony zgodnie z plikiem Kickstart,
- że strefa czasowa i język są poprawne,
- że wszystkie partycje zostały utworzone od nowa.

📷 *Miejsce na zrzut ekranu z działającego systemu po instalacji*

---

## ✅ Podsumowanie

Zrealizowałem pełny proces instalacji nienadzorowanej systemu Fedora 42 z użyciem pliku Kickstart. System został poprawnie zainstalowany i jest gotowy do działania jako host dla przyszłego oprogramowania. Rozwiązanie to pozwala zaoszczędzić czas i zapewnić spójne środowisko testowe w przyszłości.

