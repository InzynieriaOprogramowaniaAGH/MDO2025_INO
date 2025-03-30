##Zajęcia 1

#1
#Instalacja git
Instalujemy git'a komentą 
sudo yum install/ apt-get install/ pacman -S (w zależności od dystrybucji linuxa) git

Opcjonolnie możemy dodać flage -y, tak aby automatycznie potwierdzić instalację.

Dobrą praktyką jest także ustawienie naszych danych. Robimy to przy pomocy komend:

git config --global user.name "imie" - ustawi globalnie imie osoby korzystającej z git'a na danej maszynie

git config --global user.email "mail" - ustawi globalnie mail osoby korzystającej z git'a na danej maszynie

Powyższe komendy zakładają, że będziemy korzystać z 1 konta na komputerze. W przeciwnym wybadku należy zmienić flagę global, na inną dającą pożadany efekt.

#2
#Klonowanie repozytorium przy użyciu https
Klonowanie repozytorium odbywa się w następujący sposób.

![git](lab1/git_clone_https.png)

#3
#Tworzenie kluczy SSH
Klucz SSH tworzymy poprzez wpisanie pokazanej niżej komendy w której specyfikujemy typ klucza, oraz mail dla którego ma zostać wygenerowany. Następnie podajemy nazwę i lokację klucza, a finalnie mamy opcję dodania hasła.

![sshklucz](lab1/klucz_ssh_haslo.png)

Drugi klucz dodajemy adekwatnie, jednak przy zapytaniu o hasło klikamy enter.

![sshnoklucz](lab1/klucz_ssh_no_haslo.png)

#Konfiguracja klucza SSH, jako dostęp do GitHub'a

Wpisujemy komendę 

ssh-add lokacja_klucza/klucz

Utworzony zostanie plik klucz.pub, którego zawartość należy skopiować, a nasepnie udać się na stronę GitHub.com, a następnie kliknąć ikonę proflu i wybrać opcję Settings.

![github_settings](lab1/github_settings.png)

Następnie wybieramy zakładkę SSH and GPG keys

![github_ssh_gpg](lab1/github_ssh_gpd.png)

Teraz w zakładce SSH keys wybieramy New SSH key

![github_add_ssh](lab1/github_add_ssh.png)

Teraz należy podać wybraną naze klucza, oraz wkleić klucz z wyższego punktu.

![github_add_ssh_2](lab1/github_add_ssh_2.png)

#Klonowanie repozytorium przy użyciu SSH

Wykonujemy podaną niżej komendę.

![ssh_cloning](lab1/git_cloning_ssh.png)

#4
#Przełączanie gałęzi

Po wejściu do repozytrium wyświtlamy gałęzie komendą

git branch -a

Flaga -a wyświetla wszystkie gałęzie, nie tylko dostępne lokalnie.

Aby przełączyć gałąż wykonujemy 

git checkout -b nazwagałęzi zdalnagałąź

Tworzenie własnej gałęzi odbywa się w podobny sposób

![git_creating_branch](lab1/git_creating_branch.png)

#6
#Tworzenie katalogu

Katalog tworzymy komendą

mkdir nazwaKatalogu

#Tworzenie git-hook'a

Tworzymy plik o nazwie commit-msg z poniższą treścią.

![commit-msg](lab1/commit-msg.png)

#umieszczanie git-hook'a w odpowiednim katalogu.

Aby git hook działał należy go umieścić w .git/hooks zaczynając od root'a repozytorium, a także dodać uprawnienia do wykonywania pliku.

#Pushowanie do zdalnego repozytorium

Aby dodać brancha do zdalenego repozytorium należy wykonac następującją komendę

git push --set-upstream miejsce_odgałężenia gałąź

#Test commit-msg

Ponieżej zamieszczono źle, oraz poprawnie zformułowane message dla commita.

![commit-msg-test](lab1/commit-msg_test.png)


##Zajęcia 2

#1#
Aby zainstalować korzystamy z wybranego manager'a pakietów (yum, apt, dnf, etc), oraz słowem docker, np. 

sudo yum install docker 

#2#
Dokonujemy rejestracji na stronie DockerHub.com. Po operacji powinniśmy zobaczyć taki obraz

![dockerhub-register](lab2/dockerhub_register.png)

#3#
Pobieramy obrazy w następujący sposób.

![installing_images](lab2/installing_images.png)

#4#
Odpalamy i sprawdzamy wersje busybox w następujący sposób.

![using_busybox](lab2/using_busybox.png)

#5#
#Załączanie dockera#
Odpalamy kontener w następujący sposób.

![running_container](lab2/running_ubuntu_docker.png)

#Sprawdzanie procesów
Aby sprawdzić aktualne procesy, uzywamy komendy top w następujący sposób.

![top](lab2/docker_processes.png)

Z kolei PID1 pokazujemy komendą podaną ponizej.

![pit](lab2/docker_pid_1.png)

#Aktualizowanie pakietów#
Aby zaktualizować pakiety wykonujemy następujące polecenie w terminalu.

![update](lab2/updating_docker_image.png)

#Wychodzenie#
Aby wyjść uzywamy komendy exit.

![exit](lab2/exiting_docker_image.png)

#6#
Tworzymy Dockerfile.

![creating_dockerfile](lab2/creatinga_dockerfile.png)

Następnie budujemy kontener.

![building](lab2/building_dockerfile.png)

Odpalamy w trybie interaktywnym, oraz sprawdzamy czy repozytorium jest sklonowane.

![interactive](lab2/running_dockerfile.png)

Upewniamy się, e git jest pobrany.

![git_check](lab2/dockerfile_verifing_git.png)

#7#
Aby wylistować kontenery, naley wywołać podaną nizej komendę.

![listing](lab2/listing_containers.png)

Usuwanie kontenerów odbywa się w następujący sposób.

![delteing](lab2/deleting_containers.png)

#8#
Aby usunąć obrazy, nalezy wykonać ponizsą komendę.

![img_del](lab2/deleting_images.png)

#9#
Plik Dockerfile znajduje się w podfolderze lab2.


##Zajęcia 3






##Zajęcia 4