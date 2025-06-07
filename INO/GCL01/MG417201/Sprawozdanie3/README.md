# Sprawozdanie 3

## Zajęcia 8

### Instalacja zarządcy Ansible

#### Utworzenie nowej maszyny wirtualnej

- Z racji, że VM z ansible miał być na tym samym systemie i wersji, co główny VM, pobrałem obraz Fedory server w wersji 41.

##### Instalacja VM

- Ustawienie nazwy hosta i włączenie interfejsu sieciowego

<div align="center"> 
    <img src="screens8/1.png">
</div>

- Utworzenie konta root

<div align="center"> 
    <img src="screens8/2.png">
</div>

- Utworzenie użytkownika ansible

<div align="center"> 
    <img src="screens8/3.png">
</div>

- Ustawnienie czasu systemowego

<div align="center"> 
    <img src="screens8/4.png">
</div>

- Wybór oprogramowania

<div align="center"> 
    <img src="screens8/5.png">
</div>

- Podsumowanie instalacji

<div align="center"> 
    <img src="screens8/6.png">
</div>

##### Setup nowej VM

- Uruchomienie sshd

<div align="center"> 
    <img src="screens8/7.png">
</div>

- Sprawdzenie, czy tar i sshd są zainstalowane

<div align="center"> 
    <img src="screens8/8.png">
</div>

- Zmiana nazwy hosta (pomyliłem się przy instalacji)

<div align="center"> 
    <img src="screens8/9.png">
</div>

#### Utworzenie migawki maszyny wirtualnej

<div align="center"> 
    <img src="screens8/10.png">
</div>

<div align="center"> 
    <img src="screens8/11.png">
</div>

<div align="center"> 
    <img src="screens8/12.png">
</div>

#### Instalacja Ansible na głównej maszynie

<div align="center"> 
    <img src="screens8/13.png">
</div>

<div align="center"> 
    <img src="screens8/14.png">
</div>

#### Utworzenie dwóch kopii `ansible-target` - `ansible-target2` i `ansible-target3`

<div align="center"> 
    <img src="screens8/15.png">
</div>

> Dla `ansible-target3` należy wykonać dokładnie te same kroki, zmieniając jedynie nazwę maszyny

#### Konfiguracja vm, żeby można się było między nimi łączyć

- Dodanie drugiego adaptera sieciowego w Virtual Boxie (dla wszystkich maszyn)

<div align="center"> 
    <img src="screens8/16.png">
</div>

- Sprawdzenie nazwy dodanego interfejsu (`enp0s8`)

<div align="center"> 
    <img src="screens8/17.png">
</div>

- Wyświetlenie listy połączeń

<div align="center"> 
    <img src="screens8/18.png">
</div>

- Modyfikacja połączenia 

    - Dla głównej vm

    <div align="center"> 
    <img src="screens8/19.png">
    </div>

    - Dla pozostałych vm należało użyć tych samych poleceń, zmieniając `ipv4.addresses` na odpowiednio:
        - `ansible-target` - 192.168.56.11
        - `ansible-target2` - 192.168.56.12
        - `ansible-target3` - 192.168.56.13

- Restart połączenia 

<div align="center"> 
    <img src="screens8/20.png">
</div>

- Sprawdzenie adresu IP interfejsu `enp0s8`

    - Dla głównej vm

    <div align="center"> 
    <img src="screens8/21.png">
    </div>

    - Dla `ansible-target`

    <div align="center"> 
    <img src="screens8/22.png">
    </div>

    - Dla `ansible-target`

    <div align="center"> 
    <img src="screens8/23.png">
    </div>

    - Dla `ansible-target`

    <div align="center"> 
    <img src="screens8/24.png">
    </div>

- Dodanie pozostałych maszyn do `/etc/hosts` na głównej vm

<div align="center"> 
    <img src="screens8/25.png">
</div>

- Utworzenie pliku `~/.shh/config`, aby ułatwić połączenie z pozostałymi vm 

<div align="center"> 
    <img src="screens8/26.png">
</div>

- Treść pliku `~/.shh/config`:
    ```
    Host ansible-target
        HostName 192.168.56.11
        User ansible
        IdentityFile ~/.ssh/id_ed25519_ansible

    Host ansible-target2
        HostName 192.168.56.12
        User ansible
        IdentityFile ~/.ssh/id_ed25519_ansible

    Host ansible-target3
        HostName 192.168.56.13
        User ansible
        IdentityFile ~/.ssh/id_ed25519_ansible
    ```
    - Dzięki temu plikowi podczas łączenia się z np. `ansible-target` za pomocą ssh wystarczy wpisać `ssh ansible-target`, pomijając nazwę użytkownika oraz plik z kluczem ssh.

#### Wymiana kluczy SSH

- Wygenerowanie klucza SSH na głównej maszynie

<div align="center"> 
    <img src="screens8/27.png">
</div>

- Skopiowanie klucza ssh na vm `ansible-target`

<div align="center"> 
    <img src="screens8/28.png">
</div>

> Aby skopiować klucz ssh na pozostałe vm należy użyć tego samego polecenia, zmieniając nazwę maszyny, do której się łączymy

- Połączenie się za pomocą ssh z `ansible-target`

<div align="center"> 
    <img src="screens8/29.png">
</div>

> Aby połączyć się za pomocą ssh z pozostałymi vm należy użyć tego samego polecenia, zmieniając nazwę maszyny, do której się łączymy

### Inwentaryzacja

#### Ustawienie nazw komputerów

- Na głównej vm

<div align="center"> 
    <img src="screens8/30.png">
</div>

- Na `ansible-target`

<div align="center"> 
    <img src="screens8/31.png">
</div>

> Na pozostałych dwóch vm należało zrobić to samo zmieniając nazwy na odpowiednio `endpoint2` i `endpoint3`, nazwa `ansible-target` także została zmieniona z `endpoint` na `endpoint1`

#### Wprowadzenie nazw DNS dla vm

##### Główna VM

- Dla głównej vm zostało to już wykonane wcześniej, zmodyfikowałem jedynie pliki `~/.ssh/config` oraz `/etc/hosts`, aby odzwierciedlały obecną nazwę hosta oraz reszty vm

    - `/etc/hosts`

    <div align="center"> 
    <img src="screens8/32.png">
    </div>

    - `~/.ssh/config`

    ```
    Host endpoint1
        HostName 192.168.56.11
        User ansible
        IdentityFile ~/.ssh/id_ed25519_ansible

    Host endpoint2
        HostName 192.168.56.12
        User ansible
        IdentityFile ~/.ssh/id_ed25519_ansible

    Host endpoint3
        HostName 192.168.56.13
        User ansible
        IdentityFile ~/.ssh/id_ed25519_ansible
    ```

##### Ansible-target

- Edycja pliku /etc/hosts

<div align="center"> 
    <img src="screens8/33.png">
</div>

> Plik `/etc/hosts` ma na każdej z czterech vm tą samą treść

- Utworzenie pliku `~/.shh/config`

<div align="center"> 
    <img src="screens8/34.png">
</div>

- Teść ogólna tego pliku, dla każdej maszyny pomijana jest ona sama:

```
Host orchestrator
	HostName 192.168.56.10
	User mati

Host endpoint1
    HostName 192.168.56.11
    User ansible
    IdentityFile ~/.ssh/id_ed25519_ansible

Host endpoint2
    HostName 192.168.56.12
    User ansible
    IdentityFile ~/.ssh/id_ed25519_ansible

Host endpoint3
    HostName 192.168.56.13
    User ansible
    IdentityFile ~/.ssh/id_ed25519_ansible
```

#### Test łączności

##### Główna vm (orchestrator)

<div align="center"> 
    <img src="screens8/35.png">
</div>

##### Druga vm (endpoint1)

<div align="center"> 
    <img src="screens8/36.png">
</div>

#### Utworzenie pliku inwentaryzacji

### Zdalne wywoływanie procedur



### Zarządzanie stworzonym artefaktem



## Zajęcia 9



## Zajęcia 10

### Instalacja klastra Kubernetes



### Analiza posiadanego kontenera



### Uruchamianie oprogramowania



### Przekucie wdrożenia manualnego w plik wdrożenia (wprowadzenie)



## Zajęcia 11
