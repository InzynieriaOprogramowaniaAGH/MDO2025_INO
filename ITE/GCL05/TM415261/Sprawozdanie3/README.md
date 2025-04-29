# Sprawozdanie 3
#### Tomasz Mandat ITE gr. 05

<br>

## Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

### Instalacja zarządcy Ansible
Na początku utworzyłem drugą maszynę wirtualną posiadającą ten sam system operacyjny, co "główna" maszyna (`Fedora 41`).

Podczas instalacji nadałem maszynie *hostname* `ansible-target` oraz utworzyłem użytkownika `ansible`.
![ss](./Lab8/screenshots/ss1.png)
![ss](./Lab8/screenshots/ss2.png)

Po pomyślnej instalacji zalogowałem się na nowo utworzoną maszynę.
![ss](./Lab8/screenshots/ss3.png)

Następnie zainstalowałem program `tar` oraz serwer `OpenSSH` (`shd`). Okazało się, że serwer jest już zainstalowany.
``` bash
sudo dnf install tar openssh-server -y
```
![ss](./Lab8/screenshots/ss4.png)

Po udanej instalacji zrobiłem migawkę maszyny.
![ss](./Lab8/screenshots/ss5.png)

Następny krok odbył się na głównej maszynie wirtualnej. Mianowicie zainstalowałem na niej oprogramowanie Ansible.
``` bash
sudo dnf install ansible -y
```
![ss](./Lab8/screenshots/ss6.png)

Instalacja zakończyła się sukcesem.
![ss](./Lab8/screenshots/ss7.png)

Następnie wymieniłem klucze SSH między użytkownikiem na głównej maszynie, a użytkownikiem `ansible`. Dzięki temu podczas logowania przez `ssh` nie będzie wymagane hasło.
Z racji, że klucz publiczny został już utworzony podczas laboratoriów nr 1, wymiana kluczy odbyła się jedynie poleceniem:
``` bash
ssh-copy-id ansible@ansible-target
```
![ss](./Lab8/screenshots/ss8.png)

Podczas próby logowania, hasło faktycznie nie było wymagane. To potwierdza skuteczność operacji.
![ss](./Lab8/screenshots/ss9.png)

<br>

### Inwentaryzacja
Następnie należało dokonać inwentaryzacji systemów. Zacząłem od ustalenia przewidywalnych nazw komputerów (maszyn wirtualnych) stosując `hostnamectl`.

Najpierw wykonałem to na głównej maszynie:
![ss](./Lab8/screenshots/ss10.png)

A następnie na nowej:

![ss](./Lab8/screenshots/ss11.png)

W kolejnym kroku zapewniłem możliwość wywoływania komputerów za pomocą nazw, a nie tylko adresów IP. W tym celu dopisałem adresy i nazwy hostów to pliku `/etc/hosts`. Jest to lokalna alternatywa dla `DNS`. Modyfikacja pliku nastąpiła na obydwu maszynach w identyczny sposób.

Główna maszyna:
![ss](./Lab8/screenshots/ss12.png)

Nowa maszyna:
![ss](./Lab8/screenshots/ss13.png)

Po zapisaniu zmodyfikowanych plików, zweryfikowałem łączność w obu kierunkach (stosując `ping`). Zamiast adresów używałem wcześniej ustawionych nazw.

Główna maszyna -> Nowa maszyna
![ss](./Lab8/screenshots/ss14.png)

Nowa maszyna -> Główna maszyna
![ss](./Lab8/screenshots/ss15.png)

W kolejnym kroku utworzyłem plik inwentaryzacji. Zawiera on sekcje `Orchestrators` (czyli maszyny, które zarządzają innymi) oraz `Endpoints` (maszyny docelowe). W odpowiednich sekcjach zostały dodane nazwy maszyn, ich adresy IP oraz nazwy użytkowników.

Plik [inventory.ini](./Lab8/inventory.ini):
``` ini
[Orchestrators]
MSI ansible_host=192.168.1.38 ansible_user=tmandat

[Endpoints]
ansible-target ansible_host=192.168.1.41 ansible_user=ansible
```

Teraz, za pomocą pliku inwentaryzacji, wysłałem żądanie `ping` do wszystkich maszyn. Operacja zakończyła się sukcesem.
![ss](./Lab8/screenshots/ss17.png)
