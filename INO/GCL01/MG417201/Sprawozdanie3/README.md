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

#### Konfiguracja vm, żeby można się było między nimi łączyć

- Dodanie drugiego adaptera sieciowego w Virtual Boxie (dla obu maszyn)

<div align="center"> 
    <img src="screens8/15.png">
</div>

- Sprawdzenie nazwy dodanego interfejsu (`enp0s8`)

<div align="center"> 
    <img src="screens8/16.png">
</div>

- Wyświetlenie listy połączeń

<div align="center"> 
    <img src="screens8/17.png">
</div>

- Modyfikacja połączenia 

    - Dla głównej vm

    <div align="center"> 
    <img src="screens8/18.png">
    </div>

    - Dla drugiej vm

    <div align="center"> 
    <img src="screens8/19.png">
    </div>

- Restart połączenia 

<div align="center"> 
    <img src="screens8/20.png">
</div>

- Sprawdzenie adresu IP interfejsu `enp0s8`

    - Dla głównej vm

    <div align="center"> 
    <img src="screens8/21.png">
    </div>

    - Dla drugiej vm

    <div align="center"> 
    <img src="screens8/22.png">
    </div>

- Dodanie `ansible-target` do `/etc/hosts` na głównej vm

<div align="center"> 
    <img src="screens8/23.png">
</div>

- Utworzenie pliku `~/.shh/config`, aby ułatwić połączenie z vm `ansible-target`

<div align="center"> 
    <img src="screens8/24.png">
</div>

- Treść pliku `~/.shh/config`:
    ```
    Host ansible-target
        HostName 192.168.56.11
        User ansible
        IdentityFile ~/.ssh/id_ed25519_ansible
    ```
    - Dzięki temu plikowi podczas łączenia się z `ansible-target` za pomocą ssh wystarczy wpisać `ssh ansible-target`, pomijając nazwę użytkownika oraz plik z kluczem ssh.

#### Wymiana kluczy SSH

- Wygenerowanie klucza SSH na głównej maszynie

<div align="center"> 
    <img src="screens8/25.png">
</div>

- Skopiowanie klucza ssh na vm `ansible-target`

<div align="center"> 
    <img src="screens8/26.png">
</div>

- Połączenie się za pomocą ssh z `ansible-target`

<div align="center"> 
    <img src="screens8/27.png">
</div>

### Inwentaryzacja

#### Ustawienie nazw komputerów

- Na głównej vm

<div align="center"> 
    <img src="screens8/28.png">
</div>

- Na `ansible-target`

<div align="center"> 
    <img src="screens8/29.png">
</div>

#### Wprowadzenie nazw DNS dla vm

##### Główna VM

- Dla głównej vm zostało to już wykonane wcześniej, zmodyfikowałem jedynie plik `~/.ssh/config`, aby odzwierciedlał obecną nazwę drugiej vm


##### Ansible-target

- Edycja pliku /etc/hosts

<div align="center"> 
    <img src="screens8/30.png">
</div>

- Utworzenie pliku `~/.shh/config`

<div align="center"> 
    <img src="screens8/31.png">
</div>

- Teść tego pliku:

```
Host orchestrator
    HostName 10.0.2.2
    Port 2222
    User mati
```

### Zdalne wywoływanie procedur



### Zarządzanie stworzonym artefaktem



## Zajęcia 9



## Zajęcia 10

### Instalacja klastra Kubernetes



### Analiza posiadanego kontenera



### Uruchamianie oprogramowania



### Przekucie wdrożenia manualnego w plik wdrożenia (wprowadzenie)



## Zajęcia 11
