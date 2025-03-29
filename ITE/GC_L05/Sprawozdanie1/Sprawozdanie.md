# Sprawozdanie

---

## Laboratorium 2 - Git, Docker

W systemie Fedora zaktualizowano system i zainstalowano Docker.  Następnie pobrano obrazy hello-world, busybox, fedora oraz mysql za pomocą polecenia docker pull.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20pull%20busybox.png?raw=true)

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20pull%20fedora.png?raw=true)

Uruchomiono kontener z obrazem busybox w trybie interaktywnym i wyświetlono informację o wersji.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20busybox.png?raw=true)

Uruchomiono kontener z obrazem Fedora przy użyciu polecenia `sudo docker run -it fedora sh`. Po wejściu do kontenera zaktualizowano pakiety systemowe za pomocą `dnf update`. Następnie wykonano `ps -ef` i wyświetlono proces PID1.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/docker%20run%20fedora.png?raw=true)

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/dnf%20upgrade%20-y.png?raw=true)

Następnie zbudowano kontener przy użyciu Dockerfile, który aktualizuje system i instaluje Git za pomocą menedżera pakietów dnf (`dnf -y upgrade && dnf -y install git`), czyści pamięć podręczną, a potem klonuje repozytorium git.

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/images/Dockerfile.png?raw=true)

Polecenie `sudo docker build -t fedora .` buduje obraz na podstawie instrukcji zawartych w pliku Dockerfile.
