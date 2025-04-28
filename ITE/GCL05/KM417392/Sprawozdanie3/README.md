# Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

Prace rozpoczęto od utworzenia drugiej maszyny wirtualnej, wyposażonej w ten sam system operacyjny i tę samą wersję co "główna" maszyna — Ubuntu Server 24.04.2.
Podczas instalacji nadano maszynie hostname **ansible-target** oraz utworzono w systemie użytkownika **ansible**.

- Główna maszyna: **kasiam@kasiam**
- Dodatkowa maszyna: **ansible@ansible-target**

### Połącznie SSH

a) Ustawienie połączenia bez konieczności podawania hasła

1. Wygenerowano parę kluczy SSH bez ustawiania hasła:
```
ssh-keygen
```
![obraz](KM/lab5/run-ocean.png)
2. Skopiowano klucz publiczny na maszynę docelową (ansible-target) dla użytkownika ansible:
```
ssh-copy-id ansible@IP_address
```
![obraz](KM/1.png)
3. Następnie nawiązano połączenie z maszyną ansible-target za pomocą adresu IP:
```
ssh ansible@IP_address
```
![obraz](KM/2.png)
Połączenie zostało ustanowione bez potrzeby podawania hasła.

b)  Ustawienie połączenia z użyciem nazwy zamiast adresu IP

1. Zedytowano plik /etc/hosts na głównej maszynie:
```
sudo nano /etc/hosts
```
![obraz](KM/4.png)
2. Dodano wpis odpowiadający maszynie docelowej:
```
IP_address   ansible-target
```
![obraz](KM/5.png)
3. Połączenie z maszyną zostało nawiązane poprzez nazwę hosta:
```
ssh ansible@ansible-target
```
![obraz](KM/3.png)
### Migawka maszyny wirtualnej
**Migawka** to pełne zapisanie stanu maszyny wirtualnej w danym momencie.
Gdy zostaje zrobiona migawka - system plików, pamięć RAM, ustawienia — wszystko zostaje "zamrożone".
Można w dowolnym momencie wrócić do tego punktu.

Warto kiedy - są robione duże zmiany i jeśli pójdzie coś nie tak -> przywracana zostaje migawka i stan maszyny jest taka jak wcześniej.

Virtualbox > ```Wybierz maszynę``` > ```Migawki``` > ```Zrób migawkę``` > ```Nadaj nazwe``` >> ```OK```
![obraz](KM/7.png)
### Eskport maszyny wirtualnej
Eksport oznacza pełne spakowanie maszyny wirtualnej do jednego pliku. Działa jak "backup" lub "przenośna wersja" maszyny.
Ekportowana zostaje maszyna -> można ją potem zaimportować gdzie indziej np. na innym komputerze.

Virtualbox > ```Eksportuj jako urządzenie wirtualne``` > ```Wybierz maszynę``` 
![obraz](KM/eks.png)
### Ansible
Na głównej maszynie wirtualnej, zainstalowano oprogramowanie Ansible
```
sudo apt install ansible -y
```
![obraz](KM/w1.png)
![obraz](KM/6.png)

- Sprawdzono również obecność programu ```tar``` oraz ```sshd```
![obraz](KM/tar.png)

## Inwentaryzacja
W ramach przygotowania środowiska sprawdzono obecność niezbędnych narzędzi oraz dokonano inwentaryzacji systemów. Celem było umożliwienie komunikacji pomiędzy maszynami wirtualnymi za pomocą nazw hostów, a następnie przygotowanie pliku inwentaryzacyjnego dla Ansible.
### Zmiana hostname
1. Na maszynie głównej zmieniono nazwę hosta:
Warto gdy masz np. ustawioną nazwę na ```localhost``` na bardziej czytelną.
```
sudo hostnamectl set-hostname orchestrator
```
![obraz](KM/11.png)
![obraz](KM/13.png)
![obraz](KM/14.png)
### Konfiguracja nazw DNS
(Wcześniej również był wspomniany ten temat)
1. Aby umożliwić komunikację za pomocą nazw zamiast adresów IP, zmodyfikowano plik /etc/hosts, dodając odpowiednie wpisy:
```
sudo nano /etc/hosts
```
2. Dodano linie mapujące IP na nazwy hostów:
```
IP_address_1   orchestrator
IP_address_2   ansible-target
```
### Weryfikacja łączności
Zweryfikowano poprawność komunikacji z maszyną ansible-target za pomocą polecenia ping:
```
ping ansible-target 
```
![obraz](KM/15.png)

### Przygotowanie pliku inwentaryzacji Ansible
Stworzono plik inventory.yml z podziałem na grupy:

- Orchestrators – zawiera maszynę główną.
- Endpoints – zawiera maszyny docelowe zarządzane przez Ansible.

1) Plik **inventory.yml**:
![obraz](KM/yaml.png)
- Wysłano polecenie ping do wszystkich maszyn zdefiniowanych w pliku inventory.yml
```
ansible all -i inventory.yml -u ansible -m ping
```
![obraz](KM/ping-pong.png)
Ansible nawiązał połączenie z ansible-target. Pojawił się błąd przy próbie połączenia z orchestrator, co jest normalne — użytkownik ansible nie istnieje lub nie ma odpowiedniej konfiguracji SSH na maszynie orchestrator.

2) Plik **inventory.yml** - Wysyłanie zapytania ping tylko do grupy Endpoints
![obraz](KM/18.png)
```
ansible Endpoints -i inventory.yml -m ping
```
Aby uniknąć problemu z orchestrator, przetestowano połączenie wyłącznie z maszynami docelowymi (Endpoints)
- wysłanie zapytania ping
![obraz](KM/success.png)
Ansible skutecznie połączył się z maszynami z grupy Endpoints, co potwierdza prawidłową konfigurację środowiska.



