# Sprawozdanie nr 3

## Miłosz Nowak Inżynieria Obliczeniowa 29.05.2025r.

## Zajęcia 08 Ansible:

1. Wykonywanie zadania rozpocząłem od instalacji nowej wirtualnej maszyny. Była to Fedora 42 w minimalnej wersji. Zapewniłem obecność programu ```tar ```
i serwera ```sshd```
Maszynie nadałem nazwę hosta ```ansible-target``` i utworzyłem użytkownika ```ansible```
Następnie utworzyłem migawkę maszyny w oknie VirtualBoxa.
 
![Zrzut1](screenshots/Zrzut1.png)

2. Przeprowadziłem instalację Ansible na głównej maszynie poleceniem ```sudo dnf install ansible```
![Zrzut2](screenshots/Zrzut2.png)

3. Następnie poleceniem ```ssh-copy-id ansible@192.168.100.111```
wymieniłem klucze SSH pomiędzy użytkownikiem w głównej maszynie wirtualnej, a użytkownikiem ansible. Dzięki logowanie nie wymaga hasła.

![Zrzut3](screenshots/Zrzut3.png)

4. Kolejnym krokiem była inwertaryzacja systemów. Ustawiłem nowe nazwy maszyn poleceniami:
```sudo hostnamectl set-hostname orchestrator1```
```sudo hostnamectl set-hostname ansible-target1```
5. Ustawiłem nazwy DNS maszyn za pomocą ```sudo nano /etc/hosts```
![Zrzut4](screenshots/Zrzut-A4.jpg)

6. Zweryfikowałem połaczenie poleceniem ```ping```
![Zrzut5](screenshots/Zrzut-A5.jpg)

7. Utworzyłem plik inwentaryzacji ```inventory.ini```

![Zrzut6](screenshots/Zrzut-A6.jpg)

8. Ponownie przetestowałem połączenie korzystając z utworzonego pliku za pomocą polecenia ```ansible all -i inventory.ini -u ansible -m ping```
![Zrzut7](screenshots/Zrzut-A7.png)
 
9. Następnie utworzyłem playbook Ansible [copy_inventory.yml](files/copy_inventory.yml)
![Zrzut8](screenshots/Zrzut-A8.png)
I wykonałem polecenie ```ansible-playbook -i inventory.ini -u ansible --become copy_inventory.yml```
**Wydruk ukazuje poprawne połączenie z maszyną ansible-target1, utworzenie katalogu i skopiowanie do niego pliku inwertaryzującego:**
![Zrzut9](screenshots/Zrzut-A9.png)

10. W celu zaktualizowania pakietów i zrestartowania usług sshd oraz rngd utworzyłem nowy playbook [update_and_restart.yml](files/update_and_restart.yml)
**Wydruk ukazuje poprawne zaktualizowanie pakietów, restart sshd oraz rngd**
![Zrzut10](screenshots/Zrzut-A10.png)

11. Ostatnim krokiem było przeprowadzenie operacji względem maszyny z wyłączonym serwerem SSH. Na maszynie docelowej poleceniem
```
sudo systemctl stop sshd
sudo systemctl disable sshd
```
Wyłączyłem SSH. Następnie na maszynie dyrygencie uruchomiłem ponownie plik inwentaryzacyjny ```ansible -i inventory.ini -u ansible -m ping ansible-target1```
**Błąd połączenia- komunikat UNREACHABLE**
![Zrzut11](screenshots/Zrzut-A11.png)

## Zajęcia 09 Kickstart:

1. Do wykonania zadanie użyłem instalatora sieciowego Netinst Everything systemu Fedora 41. Utworzyłem nową maszynę wirtualną.

2. Przed jej uruchomieniem na głównej maszynie z tym samym systemem pobrałem plik odpowiedzi ```/root/anaconda-ks.cfg```

3. Następnie edytowałem go według potrzeb. Dodałem wzmiankę o potrzebnych repozytoriach i pakietach przed informacjami o dysku.
```
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-42&arch=x86_64
repo --name=update --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f42&arch=x86_64
```

4. Ustawiłem formatowanie całości dysku za pomocą ```clearpart --all```
Utworzyłem nowego użytkownika i ustawiłem hostname.

5. Po wysłaniu nowego pliku na github, uruchomiłem nową maszynę wirtualną. W ekranie wyboru sposobu instalacji nacisnąłem przycisk "e" na klawiaturze. Umożliwia to wskazanie instalatorowi pkiku odpowiedzi z którego zostanie przeprowadzona instalacja nienadzorowana.
W pliku należy dopisać ```inst.ks=```
A następnie wstawić link do [Pliku odpowiedzi w wersji Raw na Github](https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/refs/heads/MN417158/INO/GCL02/MN417158/Sprawozdanie3/anaconda-ks.cfg)

6. Uruchomiłem instalację.

![Zrzut12](screenshots/Zrzut ekranu 2025-05-13 175528.png)

7. Po zakończeniu instalacji edytowałem plik odpowiedzi aby ustawić automatyczne uruchomienie ponowne po instalacji. Na końcu pliku dodałem polecenie ```reboot```

 


## Zajęcia 10 Kubernetes:

## Zajęcia 11 Kubernetes cd.:

## Korzystanie z narzędzi AI podczas wykonywania zadań

ChatGPT-4 w celu znalezienia najprostszego sposobu do wyświetlenia kolorowego napisu w konsoli Jenkinsa oraz do stworze>

