Sprawozdanie 2
--------------
Pracę zacząłem od przygotowania pliku docker-compose.yml, który tworzy wszystkie potrzebne kontenery, sieci, podpina woluminy i umożliwia pracę na dockerze z Jenkinsa:
version: '3.8'

services:
  docker:
    image: docker:dind
    container_name: jenkins-docker
    privileged: true
    restart: always
    environment:
      DOCKER_TLS_CERTDIR: /certs
    networks:
      jenkins:
        aliases:
          - docker
    volumes:
      - jenkins-docker-certs:/certs/client
      - jenkins-data:/var/jenkins_home
    ports:
        - "2376:2376"

  jenkins:
    image: jenkins-with-docker
    container_name: jenkins-blueocean
    restart: always
    depends_on:
      - docker
    networks:
      - jenkins
    environment:
      DOCKER_HOST: tcp://docker:2376
      DOCKER_CERT_PATH: /certs/client
      DOCKER_TLS_VERIFY: "1"
    ports:
      - "8080:8080"
      - "50000:50000"
      - "3000:3000"
      - "3001:3001"
    volumes:
      - jenkins-data:/var/jenkins_home
      - jenkins-docker-certs:/certs/client:ro
volumes:
  jenkins-data:
  jenkins-docker-certs:

networks:
  jenkins:

Ten krok znacznie zwiększył wygodę pracy, ze względu na brak potrzeby wpisywanai wszystkiego od nowa przy restarcie maszyny. 


Następnym krokiem było zalogowanie się do jenkinsa na wcześniej utworzone konto. Z jenkinsem łączyłem się przez podanie swojego adresu ip i portu (8080), na którym Jenkins operuje
![image](https://github.com/user-attachments/assets/1d32d936-e840-4c04-ad8b-6687bdcb4feb)

Pomimo, że zainstalowałem wtyczkę blueocean, która była dedykowana do tego projektu, postanowiłem używać zwykłego Jenkinsa. 
![image](https://github.com/user-attachments/assets/08be8afa-acea-4095-a09f-b2993f48b657)

Aplikacja, którą wybrałem to nodejs-dummy. Jest to prosta webowa aplikacja, na której można dodawać zadania "TO-DO".


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










