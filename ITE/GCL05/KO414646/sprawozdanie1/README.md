# Lab 1

## obsługa kluczy ssh
pierwszym krokiem było utworzenie dwóch par kluczy ssh przy pomocy komedy ```ssh-keygen``` podając typ klucza i mail. następnie podano nazwy i hasła kluczy
![ssh1](sceendump/L1/1-key.PNG)

![ssh1](sceendump/L1/2-key2.PNG)

## dodanie kluczy do githuba

W opcjach, w zakładce SSH and GPG keys dodano jeden z utworzonych kluczy ssh
![sshklucz](sceendump/L1/11-githubssh.PNG)

## Klonowanie repozytorium przy użyciu SSH

sklonowano repozytorium przedmiotu

![ssh_cloning](sceendump/L1/3-cloneTokken.PNG)

## Przełączanie gałęzi

utworzono nową gałąź w gałęzi grupowej

![git_creating_branch](sceendump/L1/4-mybrnach.PNG)

## Tworzenie katalogu

![mkdir](sceendump/L1/5-newFoldre.PNG)

## Tworzenie git-hook'a

Tworzymy plik o nazwie commit-msg z poniższą treścią, aby wymusić żeby treść commitów zaczynała się od "KO414646"

![commit-msg](sceendump/L1/6-githook.PNG)

Aby git hook działał należy go umieścić w .git/hooks zaczynając od root'a repozytorium, a także dodać uprawnienia do wykonywania pliku.

- próba utworzenia nieprawidłowego commita

![bad-commit](sceendump/L1/9-gitHookTest.PNG)

## Pushowanie do zdalnego repozytorium

Aby dodać brancha do zdalenego repozytorium należy wykonac następującją komendę

```git push --set-upstream miejsce_odgałężenia gałąź```

![git-push](sceendump/L1/10-git-push.PNG)


# Lab2

## Pobranie Dockera
```sudo dnf install docker```

![dockerhub-register](sceendump/L2/2.1-pobieranie-dockera.PNG)

## Pobranie obrazów
używająć ```sudo docker pull <nazwa_obrazu>``` pobrano busybox, fedora, ubuntu i sql

![installing_images](sceendump/L2/2.2-pobieranie-obrazu.PNG)

## Odpalenia busybox

```docker run busybox``` uruchomia kontener, ale nie przydziela mu konsoli

![using_busybox](sceendump/L2/2.3-run-busybox-nothing.PNG)

dodanie flagi ```-it``` umożliwi sprawdzenie wersji w trybie interaktywnym po wpisaniu ```busybox``` wewnątrz kontenera

![busybox-fr](sceendump/L2/2.4-busybox-iteractive.PNG)

## Sprawdzanie procesów
Aby sprawdzić aktualne procesy, w kontenerze zainstalowano komende ps używając ```dnf install -y procps-ng``` i porównano jej wynik wewnątrz kontenera fedory i poza nim

![ps](sceendump/L2/2.5-ps-fed-ps-host-ps-dock.PNG)

## Wychodzenie
Aby wyjść z kontenera uzywamy komendy ```exit```.

![exit](sceendump/L2/2.6-exit.PNG)

## Tworzenie obrazu przy pomocy pliku dockerfile
Utworzono Dockerfile tworzący obraz fedory, zwierającej gita i repozytorium przedmiotowe

[dockerfile-lab2](../L2/dockerfile)

Następnie budujemy kontener.

![building](sceendump/L2/2.7-dockerbuid.PNG)

Odpalamy w trybie interaktywnym, oraz sprawdzamy czy repozytorium jest sklonowane.

![interactive](sceendump/L2/2.7-gitrepodocker.PNG)

## Usuwanie kontenerów
Aby wylistować kontenery, naley wywołać ```docker ps -a```
Usunąć kontenery można przy użyciu ```docker stop $(docker ps -aq)```
i następnie ```docker rm $(docker ps -aq)```

![delteing](sceendump/L2/2.8-cont_del.PNG)

## Usuwanie obrazów
Aby wylistować obrazy, naley wywołać ```docker images```
Usunąć obrazy można przy użyciu ```docker rmi -f $(docker images -q)```
![img_del](sceendump/L2/2.9-img-del.PNG)


# Lab3

## Wybór repozytorium 
Wybrano sds (simple dynamic string) do języka C.

https://github.com/antirez/sds

## Tworzenie kontenera pomocniczego
![sds_run](sceendump/L3/3.1-getting-test-image.PNG)

Nastpępnie zaistalowano gita, w celu sklonowania repozytorium

![git-get](sceendump/L3/3.2-get-git.PNG)

Potrzeba również make'a

![make](sceendump/L3/3.3-get-make.PNG)

Make wymaga cc

![cc](sceendump/L3/3.4-get-cc.PNG)

Po zainstalowaniu wymaganych programów można zbudować i przetestować aplikacje

![make-workig](sceendump/L3/3.5-make-works.PNG)

![test-koneter](sceendump/L3/3.5-runrest.PNG)

## Tworzenie obrazów do budowania i testowania aplikacji

W oparciu u kontener pomocniczy utworzono dwa dockerfile'e, do budowania i testowania aplikacji. oba instalują gita, make'a, cc. Następnie klonują repozytorium i wykonują komende ```make``` w katalogu roboczym. obraz testowy wykonuje testy przy uruchomieniu kontenera

[dockerfile-run](L3/run/dockerfile)

[dockerfile-test](L3/test/dockerfile)

- tworzenie obrazu testowego

![build-test](sceendump/L3/3.6-buildtest.PNG)

# Lab4

## Cz 1 - woluminy
Tworzymy woluminy w następujący sposób.

![voluming](sceendump/L4/4.1-utworzenieVol.PNG)

Klonujemy repozytorium na wolumin wejściowy, przy pomocy kontenera pomocniczego

![gitting](sceendump/L4/4.3-kontener-clone.PNG)

![gitting2](sceendump/L4/4.4-getgit.PNG)

![cloning](sceendump/L4/4.5-getRepo.PNG)

Teraz tworzymy dockerfile bez git'a, ale z wymaganymi dependencjami.

![gitless](sceendump/L4/4.7-dockerfile-bieda.PNG)

Następnie należy utworzyć obraz.

![building](sceendump/L4/4.8-image-light.PNG)

Odpalamy container z podpiętymi woluminami.

![running](sceendump/L4/4.9-build-cont.PNG)

Po uzyciu make kopiujemy zawartość woluminu wejściowego na wolumin wyjściowy, oraz container.

![exit_vol](sceendump/L4/4.10-make.PNG)

![cont](sceendump/L4/4.11-cpv2.PNG)

Przy użyciu innego kontenera sprawdzamy czy operacje się powiodły

![check](sceendump/L4/4.12-checkifworks.PNG)

## Cz 2 - Docker Network

Odpalamy server i sprawdzamy jego ip.

![iperf_time](sceendump/L4/4b/4b-2-ipefkont.PNG)

![ip](sceendump/L4/4b/4b-3-findip.PNG)

Łączymy się z serwerem.

![connecting](sceendump/L4/4b/4b-4-connect.PNG)

Teraz nalęzy stworzyć sieć mostkową.

![bridging](sceendump/L4/4b/4b.1-utworzenieNetwork.PNG)

Tworzenie serwera w nowej sieci

![brridge-server](sceendump/L4/4b/4b-6-networkserw.PNG)

Łączenie siędo servera przy pomocy lokalnego DNS

![bridge-client](sceendump/L4/4b/4b-7-networkclient.PNG)

# Cz 3 - Jenkins
Tworzymy sieć dla jenkins'a.

![neting](sceendump/L4/4c/4c-1-network.PNG)

Odpalamy Server, wraz z dind.

![run](sceendump/L4/4c/4c-2-jenkinsrun.PNG)

![run2](sceendump/L4/4c/4c-4-jenkinsrun2.PNG)

Upewniamy się, ze server pracuje.

![checking](sceendump/L4/4c/4c-5-ps.PNG)

Sprawdzamy hasło jenkinsa.

![pass](sceendump/L4/4c/4c-6-pass.PNG)



Teraz w vs Code frwardujemy port, aby móc wyświetlić stronę na naszym komputerze.

![forwarding](sceendump/L4/4c/4c-7-forwardport.PNG)

Odpalamy stronę jenkins'a przez localhost i logujemy się hasłem z powyszego punktu.

![login](sceendump/L4/4c/4c-8-localhost.PNG)