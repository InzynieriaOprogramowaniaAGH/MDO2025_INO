SPRAWOZDANIE 3

LAB 8 - Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible

Laboratoria zacząłem od zalogowania się przez SSH do maszyny Anisble z maszyny głównej Ansible-Controller
![image](https://github.com/user-attachments/assets/2ab0b1d3-2212-42b5-8244-d4fddaab3549)

Dodałem IP i nazwę maszyny głównej do pliku /etc/hosts w Ansible-Target
![image](https://github.com/user-attachments/assets/7157ec5f-8ba6-421d-a1cd-17b85010dec2)

Test łączoności z:
Ansible-Target:
![image](https://github.com/user-attachments/assets/0399ae91-b4a6-4142-b5aa-a0a3431494ed)
Ansible-Controller:
![image](https://github.com/user-attachments/assets/b28ea1e8-36de-4636-b763-de24f862e380)

Kolejnym krokiem bło stworzenie pliku inventory.ini, gdzie maszynę główną ustawiłem na ansible-controller,
a pozostałe dwie maszyny na Endpointy (stworzyłem dodatkową maszynę do testów, IP maszyny głównej rónież musiałem dodać do plików tej maszyny):
![image](https://github.com/user-attachments/assets/1b59f1f4-97d4-4fe5-9e38-c493c431d717)

Test działania:
![image](https://github.com/user-attachments/assets/beac5791-8f53-4380-bff0-7a6db4d58ad9)

Po tym pingu zdecydowałem się na używanie tylko dwóch maszyn, ponieważ przy trzech maszyna główna się crashowała.

Kolejnym etapem było napisanie Playbooka, który wygląda nasepująco:
![image](https://github.com/user-attachments/assets/a3e02820-a726-4875-a540-510dcb5351d7)

Przebieg Playbooka:
![image](https://github.com/user-attachments/assets/f16ce275-c0a3-4faa-aa02-fda5c74a69f6)

Potwierdzenie skopiowania pliku inwentaryzacji:
![image](https://github.com/user-attachments/assets/ea57339f-6e45-4286-8e21-eb4dfd1e0cd2)

Na potrzeby eksperymentu wyłączyłem kartę sieciową i SSH
![image](https://github.com/user-attachments/assets/7840f375-86f8-4daa-8ef2-c761840ae71b)
![image](https://github.com/user-attachments/assets/087d704d-c108-412e-b2eb-2fc300dcaeef)
![image](https://github.com/user-attachments/assets/74f03a96-ac1a-4e5d-8718-7a8e96fc407c)


Ustawienie podziału na role za pomocą ansible-galaxy:
![image](https://github.com/user-attachments/assets/c5ec88bb-7d1b-4dd2-9a4f-93f0ba253f0e)
![image](https://github.com/user-attachments/assets/b4fd31ac-a5ab-4197-8612-5d6ff9de3391)


LAB 9 - Nienadzorowana instalacja systemu

Pliki:
Plik ISO Fedora-Server-Edition-41
Plik anaconda-ks.cfg

Plik anaconda-ks.cfg został wypchnięty na githuba ze starej maszyny fedora, której wcześniej używałem, a następnie go zmodyfikowałem na potrzeby zajęć:
```bash
# mój kod





