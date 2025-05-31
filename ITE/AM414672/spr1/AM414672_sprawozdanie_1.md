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

#0#
Repozytorium, które wybrałem to sds (simple dynamic string) do języka C.

Po pobraniu kompilujemy repozytorium w następujący sposób.

![gitting_sds](lab3/make_on_machine.png)

Następnie uruchamiamy testy.

![testing](lab3/running_tests_on_machine.png)

#1#
Tworzymy Docerfile.

![Dockerfile](lab3/dockerfile_without_repo.png)

Buildujemy kontener.

![building](lab3/building_docker_file.png)

Instalujemy potrzebne dependencies.

![installing](lab3/installing_gcc_make.png)

Po sklonowaniu repozytorium odpalamy make.

![making](lab3/make_in_docker.png)

A następnie testy.

![testing](lab3/running_test_in_docker.png)

#2#
Tworzymy 2 pliki Dockerfile.

![1st_file](lab3/dpckerfile_with_repo.png)

![2nd_file](lab3/dockrfile_to_run_tests.png)

Następnie je budujemy. Na początku nalezly zbudować plik tworzący kontener.

![1st_building](lab3/building_docker_file_wih_repo.png)

![2nd_build](lab3/building_test_dockerfile.png)

#3#
Aby zweryfikować, czy build przebiegł pomyślnie wchodzimy w kontener i odpalamy testy.

![test_time](lab3/verifing_test_dockerfile.png)

#extra#
Aby uprościć wszystko do 1 pliku, uywamy Docker compose w następujący sposób.

Tworzymy plik yml.
![ymling](lab3/creating_yml.png)

W środku powinna znaleźć się następująca zawartość.
![uilding](lab3/yml_contents.png)

Composujemy plik yml, co w tym wypadku automatycznie odpali take testy.

![testing](lab3/verifing_yml.png)


##Zajęcia 4

#1#
Tworzymy woluminy w następujący sposób.

![voluming](lab4/creating_entry_exit_volumes.png)

Klonujemy repozytorium na wolumin wejściowy.

![gitting](lab4/cloning_repo_to_entry_volume.png)

Teraz tworzymy dockerfile bez git'a, ale z wymaganymi dependencjami.

![gitless](lab4/creating_docker_file_without_git.png)

Następnie naley zbudować container.

![building](lab4/buildig_gitless_container.png)

Odpalamy container z podpiętymi woluminami.

![running](lab4/running_gitless_container_with_volumes.png)

Po uzyciu make kopiujemy zawartość woluminu wejściowego na wolumin wyjściowy, oraz container.

![exit_vol](lab4/copying_repo_to_exit_volume.png)

![cont](lab4/copying_repo_to_gitless_container.png)

Ponawiamy kroki, jednak tym razem klonujemy repozytorium wewnątrz kontenera, następnie wykonujemy make i kopiujemy zawartość.

![mak_n_cop](lab4/making_n_coping.png)

#2#

Pobieramy obraz iperf3.

![iperfing](lab4/pulling_iper3_image.png)

Odpalamy server i sprawdzamy jego ip.

![iperf_time](lab4/running_1st_iperf3_server.png)

![ip](lab4/getting_1st_server_ip.png)

Łączymy się z serwerem.

![connecting](lab4/connecting_to_1st_iperf_server.png)

Teraz nalęzy stworzyć sieć mostkową.

![bridging](lab4/iperf_bridge_creating.png)

Następnie nalezy dokonać połączenia mostkowego.

![bridging_time](lab4/iperf3_bridge_running.png)

Aby połączyć się z kontenerem spoza kontenera, najpierw tworzymy server.

![serving](lab4/creating_server_to_connect_to_from_host.png)

Teraz łączymy się po localhost'ie.

![conning](lab4/connecting_from_host.png)

Kolejnympoleceniem jest zapisać logi połączenia. Zaczynamy od stwrzenia odpowiednich woluminów.

![voling](lab4/iperf_log_volumes.png)

Teraz odpalamy połączenie z przekierowaniem wyników do woluminów.

![running](lab4/capturing_connection_on_volumes.png)

Wyświetlamy zawartość logów.

![1st](lab4/printing_vol_logs1.png)
![2nd](lab4/printing_vol_logs2.png)

#3#
Tworzymy sieć dla jenkins'a.

#[neting](lab4/creating_network_for_jenkins.png)

Odpalamy Server, wraz z dind.

![run](lab4/running_jenkins_with_dind.png)
![rin](lab4/running_jenkins.png)

Sprawdzamy hasło jenkinsa.

![pass](lab4/getting_jenkins_pass.png)

Upewniamy się, ze server pracuje.

![checking](lab4/verifing_if_jenkins_is_up.png)

Teraz w vs Code frwardujemy port, aby móc wyświetlić stronę na naszym komputerze.

![forwarding](lab4/forwarding_port.png)

Odpalamy stronę jenkins'a przez localhost i logujemy się hasłem z powyszego punktu.

![jenking](lab4/jenkins_mainpage.png)