### 1. Stworzenie nowej wirtualnej maszyny z system Fedora i OpenSSH
![1](screeny/1.png)
![2](screeny/2.png)

### 3. Instalacja Ansible na glownej maszynie i zmiana nazwy hosta na ansible-main
![3](screeny/3.png)
![4](screeny/4.png)

### 5. Wygenerowanie klucza SSH i wymiana pomiedzy userami
![5](screeny/5.png)

### 6. Logowanie za pomoca ssh (nie jest wymagane haslo) 
![6](screeny/6.png)

### 8. Stworzenie plik "inventory.ini", ktory przeprowadza polecenie ping do wszystkich hostow w pliku
![8](screeny/8.png)

### 9. Utworzenie playbook w formacie YAML, ktory przeprowadza polecenie ping do wszystkich hostow w pliku 
![9](screeny/9.png)

### 10. Stworzenie pliku "copycat.yml", ktory kopiuje "inventory.ini" na zdale hosty. Uruchomienie pliku po raz kolejny, sprawdza czy plik juz istnieje
![10](screeny/10.png)

### 11. Plik restart.yml restartuje uslugi sshd oraz rngd
![11](screeny/11.png)

### 12. Uruchomienie z wylaczonym serwerem SSH
![12](screeny/12.png)

### 13. Utworzenie roli "deploy_docker_app", ktora pozwala na wdrozenie aplikacji
![13](screeny/13.png)

### 14. Uruchomienie roli w celu zdeployowania aplikacji
![14](screeny/14.png)

### 15. Pobranie pliku anaconda-ks.cfg z poprzedniej maszyny. Zmodyfikowano go, dodajac potrzebne pakiety i repozytorium. Nastepnie zainstalowano z tego pliku nowa maszyne
![15](screeny/15.png)

### 16. Automatyczna instalacja
![16](screeny/16.png)
![16](screeny/17.png)

### 17. Po instalacji uruchomiony kontener HTTP poprawnie serwowal plik index.html 

![17](screeny/18.png)

### 18. Uruchomiono pod i zweryfikowanie statusu

![18](screeny/19.png)
![18](screeny/20.png)

### 19. Zbudowane obrazy spushowane do Docker Hub

![19](screeny/21.png)
![19](screeny/22.png)
![19](screeny/23.png)

### 20. Deployement z 8 Podami
![20](screeny/24.png)

### 21. Deployment z zmieniona liczba podow z 8 na 1
![21](screeny/25.png)

### 22. Przeprowadzenie port-forwarding w celu uzyskania dostepu do serwowanej strony
![22](screeny/26.png)
![22](screeny/27.png)

### 23. Wesja druga obrazu
![23](screeny/28.png)
![23](screeny/29.png)

### 24. Port-forwarding
![24](screeny/30.png)
![24](screeny/31.png)

### 25. Wersja fail
![25](screeny/32.png)
![25](screeny/33.png)

### 26. Przywrocenie do poperzniej dzialajacej wersji
![26](screeny/34.png)
![26](screeny/35.png)

### 27. Kontrola wdrozenia
![27](screeny/36.png)

