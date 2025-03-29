# Sprawozdanie 1

---
# Spis Treści

1. [Lab1](#Laboratorium 1)
2. - [Laboratorium 2 - Git, Docker](#laboratorium-2---git-docker)

## Laboratorium 2 - Git, Docker

Laboratoria dotyczyły zagadnień konteneryzacji przy użyciu Dockera, obejmujących pobieranie i budowanie obrazów, tworzenie plików Dockerfile oraz uruchamiania kontenerów. 

---

W systemie Fedora zaktualizowano system i zainstalowano Docker.  Następnie pobrano obrazy hello-world, busybox, fedora oraz mysql za pomocą polecenia `docker pull`. 

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20pull%20busybox.png?raw=true)

*Rys. 1 pobranie obrazu buysbox*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20pull%20fedora.png?raw=true)

*Rys. 2 pobranie obrazu fedora*

Polecenie `docker pull` pobiera obraz kontenera z zdalnego rejestru i zapisuje go lokalnie. Dzięki temu można później uruchamiać kontenery na podstawie pobranego obrazu.

W kolejnym kroku uruchomiono kontener z obrazem busybox w trybie interaktywnym i wyświetlono informację o wersji. Polecenie `docker run -it busybox sh` uruchamia nowy kontener na podstawie obrazu **busybox** i otwiera interaktywną sesję terminalową. Dzięki opcji `-it` można wykonywać polecenia w powłoce **sh** bezpośrednio w środowisku kontenera.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20busybox.png?raw=true)

*Rys. 3 uruchomienie kontenera w trybie interaktywnym (busybox)*

Następnie uruchomiono drugi kontener z obrazem fedora. Po wejściu do kontenera zaktualizowano pakiety systemowe za pomocą polecenia`dnf update`. Następnie wykonano `ps -ef` i wyświetlono proces PID1.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20fedora.png?raw=true)

*Rys. 4 uruchomienie kontenera w trybie interaktywnym (fedora)*

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/dnf%20upgrade%20-y.png?raw=true)

*Rys. 5 aktualizacja pakietów systemowych*

Kontener zbudowano przy użyciu pliku Dockerfile, który aktualizuje system i instaluje Git za pomocą menedżera pakietów dnf (`dnf -y upgrade && dnf -y install git`), czyści pamięć podręczną, a potem klonuje repozytorium git.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/Dockerfile.png?raw=true)

*Rys. 6 zbudowanie kontenera za pomocą Dockerfile*

Polecenie `sudo docker build -t fedora .` buduje obraz na podstawie instrukcji zawartych w pliku Dockerfile.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20build%20fedora.png?raw=true)

*Rys. 7 zbudowanie obrazu fedora*

Uruchomiono kontener w trybie interaktywnym poleceniem `sudo docker run -it fedora /bin/bash`, a następnie wyświetlono zawartość katalogu roboczego.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20-it%20fedora%20sh.png?raw=true)

*Rys. 8 uruchomienie kontenera w trybie interaktywnym*
