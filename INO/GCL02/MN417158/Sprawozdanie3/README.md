# Sprawozdanie nr 3

## Miłosz Nowak Inżynieria Obliczeniowa 29.05.2025r.

## Zajęcia 08 Ansible:

1. Wykonywania zadania rozpocząłem od instalacji nowej wirtualnej maszyny. Była to Fedora 42 w minimalnej wersji. Zapewniłem obecność programu ```tar ```
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

## Zajęcia 10 Kubernetes:

## Zajęcia 11 Kubernetes cd.:

## Korzystanie z narzędzi AI podczas wykonywania zadań

ChatGPT-4 w celu znalezienia najprostszego sposobu do wyświetlenia kolorowego napisu w konsoli Jenkinsa oraz do stworze>

