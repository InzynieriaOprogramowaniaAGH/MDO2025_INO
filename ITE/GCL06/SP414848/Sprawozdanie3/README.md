# Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

## Instalacja zarządcy Ansible

W poniższych krokach przeprowadzono instalację i konfigurację systemu na nowej maszynie wirtualnej oraz zapeniono komunikację ssh pomiędzy maszynami. Na nowej maszynie będziemy wykonywać zdalne polecenia za pomocą ansible.

### Ustawienie nazwy hosta przy instalacji

W polu `Nazwa komputera:` (zakładka `SIEĆ I NAZWA KOMPUTERA`) wpisujemy nazwę unikalną hosta (np. na 'ansible-target') - w późniejszych krokach będziemy komunikować się pomiędzy hostami za pomocą nazw a nie adresów IP.

![](screens/lab8-1.png)

Również utworzono nowego użytkownika o nazwie `ansible` podczas instalacji.

### Utworzenie migawki

Sprawdzono obecność programu `tar` i usługi `sshd` (najzwyczajniej wpisując nazwę w terminalu), następnie utworzono migawkę maszyny wirtualnej.

Migawka to zapisany stan maszyny w określonym momencie - dzięki czemu możemy zapewnić że maszyna uruchomi się zawsze w tym samym stanie i z tą samą konfiguracją.

W VirtualBox'ie migawkę tworzymy pod zakładką `Maszyna`->`Zrób migawkę...`. Dalej podajemy nazwę migawki i klikamy `Ok`.

![](screens/lab8-2.png)

Widoczna migawka przy uruchomieniu maszyny:

![](screens/lab8-3.png)

### Zapewnienie komunikacji bezhasłowej ssh.

Aby umożliwić sshd zdalne logowanie bez hasła należy wymienić się kluczami ssh pomiędzy maszynami, w tym celu utworzono klucz rsa poleceniem `ssh-keygen`:

![](screens/lab8-4.png)

Następnie kopiujemy klucz na nową maszynę poleceniem `ssh-copy-id` wywołanym z hostem w formacie nazwa_użytkownika@adres_ip, po tagu `-i` podajemy ścieżkę do klucza.

![](screens/lab8-5.png)

Należy jeszcze dodać odpowiedni wpis do pliku konfiguracyjnego ssh (.ssh/config), który będzie wskazywał na utworzony klucz dla danego hosta.

![](screens/lab8-6.png)

Po `Host` podajemy adres IP i/lub nazwę dns hosta, po `User` nazwę użytkownika, a po `IdentityFile` - ścieżkę do klucza.

Pomyślne logowanie ssh bez podawania hasła:

![](screens/lab8-7.png)

## Inwentaryzacja

### Zapewnienie komunikacji za pomocą nazw DNS

Najpierw wypadałoby zmienić nazwę hosta głównej maszyny z localhost na unikalną nazwe (np. 'fedora-main').

![](screens/lab8-8.png)
![](screens/lab8-9.png)
![](screens/lab8-10.png)
![](screens/lab8-11.png)
![](screens/lab8-12.png)
![](screens/lab8-13.png)
![](screens/lab8-14.png)
![](screens/lab8-15.png)
![](screens/lab8-16.png)
![](screens/lab8-17.png)
![](screens/lab8-18.png)
![](screens/lab8-19.png)
![](screens/lab8-20.png)
![](screens/lab8-21.png)
![](screens/lab8-22.png)
![](screens/lab8-23.png)
![](screens/lab8-24.png)
![](screens/lab8-25.png)
![](screens/lab8-26.png)
![](screens/lab8-27.png)
![](screens/lab8-28.png)
![](screens/lab8-29.png)