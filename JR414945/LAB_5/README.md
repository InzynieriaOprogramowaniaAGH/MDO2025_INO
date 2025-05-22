[Jenkinsfile.txt](https://github.com/user-attachments/files/20228248/Jenkinsfile.txt)Sprawozdanie 2
--------------
Pracę zacząłem od przygotowania pliku docker-compose.yml, który tworzy wszystkie potrzebne kontenery, sieci, podpina woluminy i umożliwia pracę na dockerze z Jenkinsa:

[docker-compose.yml.txt](https://github.com/user-attachments/files/20228186/docker-compose.yml.txt)

Ten krok znacznie zwiększył wygodę pracy, ze względu na brak potrzeby wpisywanai wszystkiego od nowa przy restarcie maszyny. 

Następnym krokiem było zalogowanie się do jenkinsa na wcześniej utworzone konto. Z jenkinsem łączyłem się przez podanie swojego adresu ip i portu (8080), na którym Jenkins operuje
![image](https://github.com/user-attachments/assets/1d32d936-e840-4c04-ad8b-6687bdcb4feb)

Pomimo, że zainstalowałem wtyczkę blueocean, która była dedykowana do tego projektu, postanowiłem używać zwykłego Jenkinsa. 
![image](https://github.com/user-attachments/assets/08be8afa-acea-4095-a09f-b2993f48b657)

Aplikacja, którą wybrałem to nodejs-dummy. Jest to prosta webowa aplikacja, na której można dodawać zadania "TO-DO".
Licencja to Apache 2.0, która umożliwia mi swobodne korzystanie z kodu na potrzeby zajęć.
Fork repozytorium nie był potrzebny.


PROJEKTY TESTOWE

--------------------

1. Projekt do wyświetlania uname 
![image](https://github.com/user-attachments/assets/d0d10efd-fa8a-44e0-9b3c-f8b2a1b177b7)

3. Projekt sprawdzający parzystość godziny
![image](https://github.com/user-attachments/assets/9433c51b-93d6-4050-83e6-28d7d3b83a55)
![image](https://github.com/user-attachments/assets/5a62f577-a78a-4e00-9e7e-970e6d96cc09)
![image](https://github.com/user-attachments/assets/5840b8c6-311b-4b80-acb8-91c73a3d0e7b)

4. Projekt pobierający obraz ubuntu
W tym miejscu pojawiły się probilemy z dostępem do certyfikatów dockera i Jenkins nie mógł nad nim operować. W tamtym momencie powstał pomysł stworzenia docker-compose.yml
![image](https://github.com/user-attachments/assets/096e05ff-b31e-4177-baca-b13c7b41ba2f)
![image](https://github.com/user-attachments/assets/e0631297-a8be-43d4-9200-281695464676)

--------------------
PROJEKT GŁÓWNY - PIPELINE
--------------------

Utowrzyłem projekt typu Pipeline w Jenkinsie i napisałem Jenkinsfile, który wykonuje wszystkie kroki CI (Preparation, Build, Test, Deploy, Publish)

[Jenkinsfile.txt](https://github.com/user-attachments/files/20228254/Jenkinsfile.txt)

--------------------
ROZBICIE KROKÓW

Collect:
- Czyści folder roboczy
- Klonuje repo aplikacji
- Klonuje moją gałąź na której są pliki Dockerfile.test i Dockerfile.build
![image](https://github.com/user-attachments/assets/af15504c-43da-4f55-81e3-f617ca7c8c11)

Build:
- Tworzy obraz aplikacji na podstawie Dockerfile.build
![image](https://github.com/user-attachments/assets/2c34f96f-3aab-4c7d-9dbf-a0154316600f)

Test: 
- Tworzy obraz testowy na podstawie obrazu zbudowanego w kroku "Build"
- Uruchamia kontener testowy i przeprowadza testy
![image](https://github.com/user-attachments/assets/02c0ad4c-d786-443b-8517-5d44c8e56fed)
![image](https://github.com/user-attachments/assets/4b1f21bb-feaf-45b1-9589-910f53192398)

Deploy:
- Tworzy tymczasową sieć, przez którą kontener z obrazem aplikacji i kontener nodeapp_test_helper będą się porozumiewać
- Tworzy tymczaswoy kontener nodeapp_test_helper
- Uruchamia powłokę w kontenerze nodeapp_test_helper i sprawdza dostępność aplikacji
Kontener deploy jest tym samym kontenerm co build, ponieważ w trakcie budowania nie tworzą się żadne artefakty. Jedyną rzeczą potrzebną do deployu jest zbudowany obraz.
![image](https://github.com/user-attachments/assets/9167fc90-d3b5-4431-a01d-bbed1c775aad)
![image](https://github.com/user-attachments/assets/d5003808-6b23-4fb6-86f1-59d1aa7376b9)


Publish:
- Przesyła lokalne commity na zdalne repozytorium
- Aktualizuje historię zdalnego repozytorium
- Synchronizuje zmiany między lokalnym a zdalnym repozytorium
- Może tworzyć nowy branch na zdalnym repozytorium
![image](https://github.com/user-attachments/assets/5de7784a-b0bb-4723-85e1-8d6eeb7c574e)
![image](https://github.com/user-attachments/assets/bf441004-f0be-4093-b827-66a4432b87ed)
![image](https://github.com/user-attachments/assets/53344da7-12bf-4a80-9f4f-9eb7d2fef071)


Diagram aktywności
------------------------
![image](https://github.com/user-attachments/assets/32328b27-127b-4fee-b89a-3d2c8b0bc2c5)

Diagram wzdrożeniowy
-----------------------
![image](https://github.com/user-attachments/assets/c4e7b6b9-f9eb-4589-9f3f-763f6a1b306a)

DEFINITION OF DONE
-------------------
Po wypchnięciu obrazu na DockerHub:
- zrobiłem pulla obrazu na maszynę wirtualną
- stworzyłem kontner na podstawie tego obrazu
- stworzyłem sieć
- stworzyłem kontener pomocniczy z którego wykonałem zapytanie do kontenera z aplikacją, stworzonego na podstawie obrazu z DockerHub
![image](https://github.com/user-attachments/assets/7bea71b8-d9cf-45fc-a22b-893ec05000ca)


ANSIBLE
---------
1. Utworzyłem maszynę na podstawie obrazu fedora server (taki sam jak maszyna)
2. Ustawiłem hostname ansible-target
![image](https://github.com/user-attachments/assets/5b1fed46-da67-4f8d-a528-d8d6427e85bf)
3. Zainstalowałem potrzebne programy
4. Na głównej maszynie zainstalowałem ansible
5. Wygenerowałem klucz ssh
6. Przeprowadziłem ich wymianę

![image](https://github.com/user-attachments/assets/d587ef57-e8ac-40da-a2f5-2850ab1f064e)






