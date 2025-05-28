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

_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________



# 📝 Sprawozdanie: Pliki odpowiedzi dla wdrożeń nienadzorowanych

## 🎯 Zagadnienie

Zadanie dotyczyło przygotowania automatycznego źródła instalacyjnego systemu Fedora 42 — przydatnego w środowiskach testowych, serwerowych lub IoT. Instalacja miała odbywać się w pełni automatycznie, dzięki zastosowaniu pliku odpowiedzi Kickstart.

---

## 🎯 Cel zadania

- Utworzenie pliku odpowiedzi `kickstart` do instalacji systemu.
- Zainstalowanie systemu Fedora 42 na maszynie wirtualnej w trybie nienadzorowanym.
- Upewnienie się, że system uruchamia się w pełni skonfigurowany i gotowy do hostowania aplikacji.

---

## 📦 Środowisko i narzędzia

- Oracle VirtualBox
- Obraz ISO Fedora 42 Everything Netinst
- Plik `anaconda-ks.cfg` z repozytorium GitHub
- Edytor nano, przeglądarka, TinyURL

---

## 🪜 Kroki realizacji

### 1. Uruchomienie instalatora z ISO

Na początku uruchomiłem maszynę wirtualną z obrazem instalacyjnym Fedora 42 w trybie “Test this media & install Fedora 42”.

📷 
![Opis](ss/201.png)
![Opis](ss/202.png)



---

### 2. Problem z długim linkiem i użycie TinyURL

Podczas konfiguracji GRUB okazało się, że nie mogę wkleić długiego linku do GitHub Raw z plikiem Kickstart. W związku z tym postanowiłem użyć serwisu [TinyURL](https://tinyurl.com) do skrócenia odnośnika.

![Opis](ss/203.png)
![Opis](ss/204.png)

Link do pliku Kickstart:
```
https://tinyurl.com/bdejyufr
```

---

### 3. Uruchomienie instalacji z pliku Kickstart

Instalator wykrył plik Kickstart i rozpoczął instalację automatyczną. W logach widać było, że używany jest tryb tekstowy, co potwierdza wykorzystanie `inst.ks`.


![Opis](ss/206.png)
![Opis](ss/207.png)


---

### 4. Wejście do Anaconda GUI

Choć instalacja była automatyczna, pojawiło się okno z podsumowaniem konfiguracji. Musiałem ręcznie dokończyć konfigurację użytkownika i konta root.

📷 ![Anaconda GUI - podsumowanie instalacji](./202.png)

---

### 5. Postęp instalacji

Po uzupełnieniu wymaganych danych, instalacja postępowała dalej, tworząc partycję rozruchową i systemową.

📷 ![Postęp instalacji - tworzenie biosboot](./203.png)

---

### 6. Zawartość pliku Kickstart

Po zakończeniu instalacji otworzyłem wygenerowany plik `/root/anaconda-ks.cfg` i sprawdziłem jego poprawność. Znajdują się w nim wszystkie kluczowe elementy:

- Repozytoria online
- Partycjonowanie i czyszczenie dysku
- Hasła i użytkownik
- Ustawienia strefy czasowej

📷 ![Plik Kickstart w nano](./204.png)

---

### 7. Porównanie z wersją z GitHuba

Porównałem lokalny plik z oryginałem znajdującym się w repozytorium GitHub. Pliki są zgodne.

📷 ![Kickstart z GitHub Raw](./205.png)

---

## ✅ Podsumowanie

Przygotowałem środowisko instalacyjne systemu Fedora 42, który uruchamia się automatycznie dzięki zastosowaniu pliku Kickstart. Dzięki temu rozwiązaniu możliwe jest szybkie i spójne wdrażanie środowisk testowych lub serwerowych. Problem z długim linkiem został rozwiązany przez użycie TinyURL.

