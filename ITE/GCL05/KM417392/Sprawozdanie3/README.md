# Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

- Prace rozpoczęto od utworzenia drugiej maszyny wirtualnej, wyposażonej w ten sam system operacyjny i tę samą wersję co "główna" maszyna — Ubuntu Server 24.04.2.
Podczas instalacji nadano maszynie hostname **ansible-target** oraz utworzono w systemie użytkownika **ansible**.

Główna maszyna: **kasiam@kasiam**
Dodatkowa maszyna: **ansible@ansible-target**

### Połącznie SSH

a) Ustawienie połączenia bez konieczności podawania hasła

1. Wygenerowano parę kluczy SSH bez ustawiania hasła:
```
ssh-keygen
```
2. Skopiowano klucz publiczny na maszynę docelową (ansible-target) dla użytkownika ansible:
```
ssh-copy-id ansible@IP_address
```
3. Następnie nawiązano połączenie z maszyną ansible-target za pomocą adresu IP:
```
ssh ansible@IP_address
```
Połączenie zostało ustanowione bez potrzeby podawania hasła.

b)  Ustawienie połączenia z użyciem nazwy zamiast adresu IP

1. Zedytowano plik /etc/hosts na głównej maszynie:
```
sudo nano /etc/hosts
```
2. Dodano wpis odpowiadający maszynie docelowej:
```
IP_address   ansible-target
```
3. Połączenie z maszyną zostało nawiązane poprzez nazwę hosta:
```
ssh ansible@ansible-target
```
### Migawka maszyny wirtualnej
**Migawka** to pełne zapisanie stanu maszyny wirtualnej w danym momencie.
Gdy zostaje zrobiona migawka - system plików, pamięć RAM, ustawienia — wszystko zostaje "zamrożone".
Można w dowolnym momencie wrócić do tego punktu.

Warto kiedy - są robione duże zmiany i jeśli pójdzie coś nie tak -> przywracana zostaje migawka i stan maszyny jest taka jak wcześniej.

Virtualbox > ```Wybierz maszynę``` > ```Migawki``` > ```Zrób migawkę``` > ```Nadaj nazwe``` >> ```OK```

### Eskport maszyny wirtualnej
Eksport oznacza pełne spakowanie maszyny wirtualnej do jednego pliku. Działa jak "backup" lub "przenośna wersja" maszyny.
Ekportowana zostaje maszyna -> można ją potem zaimportować gdzie indziej np. na innym komputerze.

Virtualbox > ```Eksportuj jako urządzenie wirtualne``` > ```Wybierz maszynę``` 

## Inwentaryzacja






