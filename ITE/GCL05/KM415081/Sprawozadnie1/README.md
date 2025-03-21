# Zajęcia 01

1. Zainstalowano klienta Git i obsługę kluczy SSH.

2. Sklonowano repozytorium za pomocą HTTPS i personal access token.
![Opis obrazka](lab1_screenshots/clone_https.PNG)

3. Utworzono dwa klucze SSH, inne niż RSA, w tym co najmniej jeden zabezpieczony hasłem. Skonfigurowano klucz SSH jako metodę dostępu do GitHuba. Sklonowano repozytorium z wykorzystaniem protokołu SSH oraz skonfigurowano 2FA.
![Opis obrazka](lab1_screenshots/clone_ssh.PNG)

4. Przełączono się na gałąź main, a następnie na gałąź grupową GCL05 po czym utworzono nową gałąź.
![Opis obrazka](lab1_screenshots/switch_branches.PNG)

5. Praca na nowej gałęzi.
- w katalogu właściwym dla grupy utworzono nowy katalog
- napisano Git hooka oraz dodano go do stworzonego wcześniej katalogu po czym skopiowano go we właściwe miejsce, tak by uruchamiał się za każdym razem kiedy wykonywany jest commit.
- dodano plik ze sprawozdaniem
- dodano zrzuty ekranu
- wysłano zmiany

Treść githooka
```sh
#!/usr/bin/sh

EXPECTED_PREFIX="KM415081"
COMMIT_MSG=$(cat "$1")

if [[ "$COMMIT_MSG" != $EXPECTED_PREFIX* ]]; then
    echo "Błąd: Commit message musi zaczynać się od \"$EXPECTED_PREFIX\"!"
    exit 1
fi

exit 0
```
![Opis obrazka](lab1_screenshots/pwd.PNG)

![Opis obrazka](lab1_screenshots/commit-msg_location.PNG)

![Opis obrazka](lab1_screenshots/hook_check.PNG)

6. Próba wciągnięcia gałęzi do gałęzi grupowej.
![Opis obrazka](lab1_screenshots/merge.png)

# Zajęcia 02

1. Zainstalowano Docker.

![Opis obrazka](lab2_screenshots/docker_install.png)

2. Zarejestrowano się w DockerHub.

3. Pobrano obrazy: hello-world, busybox, fedora, mysql.

![Opis obrazka](lab2_screenshots/download.png)

4. UruchomIONO kontener z obrazu busybox.

![Opis obrazka](lab2_screenshots/busybox.png)

5. Uruchomiono "system w kontenerze".

![Opis obrazka](lab2_screenshots/update.png)

![Opis obrazka](lab2_screenshots/pid1.png)

6. Stworzono własny Dockerfile, który następnie zbudowano i uruchomiono.

![Opis obrazka](lab2_screenshots/docker.png)

Treść Dockerfile
```sh
FROM fedora:latest

RUN dnf update -y && \
    dnf install -y git && \
    dnf clean all

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["/bin/bash"]
```
7. Pokazano uruchomione kontenery, po czym je wyczyszczono wraz z obrazami.

![Opis obrazka](lab2_screenshots/containers.png)

![Opis obrazka](lab2_screenshots/images.png)

# Zajęcia 03

1. Sklonowano przesłane przez prowadzącego zajęcia repozytorium, przeprowadzono build programu, doinstalowano wymagane zależności i uruchomiono testy jednostkowe dołączone do repozytorium.

![Opis obrazka](lab_3_dockerfile/1_1.png)

![Opis obrazka](lab_3_dockerfile/1_2.png)

![Opis obrazka](lab_3_dockerfile/1_3.png)

2. Wykonano kroki build i test wewnątrz wybranego kontenera bazowego.
- uruchomiono kontener
- podłączono do niego TTY celem rozpoczęcia interaktywnej pracy
- sklonowano repozytorium
- skonfigurowano środowisko i uruchomiono build
- uruchomiono testy

![Opis obrazka](lab_3_dockerfile/2_1.png)

![Opis obrazka](lab_3_dockerfile/2_2.png)

![Opis obrazka](lab_3_dockerfile/2_3.png)

3. Stworzono dwa pliki Dockerfile automatyzujące kroki powyżej i wykazano działanie kontenera.

Dockerfile.nodebld
```sh
FROM node:22.14.0

RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test
RUN npm install
CMD ["npm", "start"]
```

Dockerfile.nodetest
```sh
FROM nodebld
RUN npm test
```

![Opis obrazka](lab_3_dockerfile/2_4.png)

![Opis obrazka](lab_3_dockerfile/2_5.png)

![Opis obrazka](lab_3_dockerfile/hfajksdgfhksdjaghfk.png)
   
4. Ujęto kontenery w kompozycję.
   
![Opis obrazka](lab_3_dockerfile/3_1.png)

![Opis obrazka](lab_3_dockerfile/3_2.png)

![Opis obrazka](lab_3_dockerfile/3_3.png)
