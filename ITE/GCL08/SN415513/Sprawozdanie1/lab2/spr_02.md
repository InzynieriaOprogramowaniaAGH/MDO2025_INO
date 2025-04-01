# Zajęcia 02

---

# Git, Docker

## Zadania do wykonania

## Zestawienie środowiska

1. Zainstaluj Docker w systemie linuksowym

```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
3. Pobierz obrazy `hello-world`, `busybox`, `ubuntu` lub `fedora`, `mysql`
```
sudo docker pull hello-world
sudo docker pull busybox
sudo docker pull ubuntu
sudo docker pull mysql
sudo docker images
```

```
docker login
```

4. Uruchom kontener z obrazu `busybox`
   - Pokaż efekt uruchomienia kontenera
   - Podłącz się do kontenera **interaktywnie** i wywołaj numer wersji

```
sudo docker run -d --name busybox busybox
sudo docker run -it --name busybox_it busybox
sudo docker ps -a
```


5. Uruchom "system w kontenerze" (czyli kontener z obrazu `fedora` lub `ubuntu`)
   - Zaprezentuj `PID1` w kontenerze i procesy dockera na hoście
   - Zaktualizuj pakiety
   - Wyjdź

```
sudo docker run -it --name ubuntu ubuntu /bin/bash
```

w kontenerze:
```
ps -p 1
apt update && apt upgrade -y
exit
```
procesy:
```
ps aux | grep docker
```


6. Stwórz własnoręcznie, zbuduj i uruchom prosty plik `Dockerfile` bazujący na wybranym systemie i sklonuj nasze repo.
   - Kieruj się [dobrymi praktykami](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
   - Upewnij się że obraz będzie miał `git`-a
   - Uruchom w trybie interaktywnym i zweryfikuj że jest tam ściągnięte nasze repozytorium

```
FROM ubuntu:latest

RUN apt-get update && apt-get install -y git

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```

```
sudo docker build . -t ubuntu_image
sudo docker run -it ubuntu_image
```


7. Pokaż uruchomione ( != "działające" ) kontenery, wyczyść je.
```
sudo docker ps -a
```

8. Wyczyść obrazy
```
sudo docker stop [nazwy obrazow]
sudo docker rm [nazwy obrazow]
```

10. Wystaw *Pull Request* do gałęzi grupowej jako zgłoszenie wykonanego

history
160  sudo apt update
  161  # Add Docker's official GPG key:
  162  sudo apt-get update
  163  sudo apt-get install ca-certificates curl
  164  sudo install -m 0755 -d /etc/apt/keyrings
  165  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  166  sudo chmod a+r /etc/apt/keyrings/docker.asc
  167  # Add the repository to Apt sources:
  168  echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  170  sudo docker pull hello-world
  171  sudo docker pull busybox
  172  sudo docker pull ubuntu
  173  sudo docker pull mysql
  174  sudo docker images
  175  docker
  176  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  177  sudo docker run hello-world
  178  sudo docker pull hello-world
  179  sudo docker pull busybox
  180  sudo docker pull ubuntu
  181  sudo docker pull mysql
  182  sudo docker images
  183  systemctl status docker
  184  docker login
  185  docker run -d --name busy busybox
  186  sudo docker run -d --name busy busybox
  187  docker ps -a
  188  sudo docker ps -a
  189  sudo usermod -aG docker $USER
  190  docker kill 2cee522a01ab
  191  sudo docker kill 2cee522a01ab
  192  docker stop busy
  193  sudo docker stop busy
  194  sudo docker ps -a
  195  sudo docker rm busy
  196  sudo docker ps -a
  197  sudo docker rm loving_blackwell
  198  sudo docker ps -a
  199  sudo docker run busybox
  200  sudo docker ps -a
  201  sudo docker rm stoic_neumann
  202  docker ps -a
  203  sudo docker ps -a
  204  docker run -d --name busybox busybox
  205  sudo docker run -d --name busybox busybox
  206  sudo docker run -it --name busybox_it busybox
  207  docker ps -a
  208  sudo docker ps -a
  209  history | tail 10
  210  history | tail -10
  211  docker run -it --name ubuntu ubuntu /bin/bash
  212  sudo docker run -it --name ubuntu ubuntu /bin/bash
  213  ps aux | grep docker
  214  sudo docker run -it --name ubuntu ubuntu /bin/bash
  215  duso docker ps -a
  216  sudo docker ps -a
  217  docker exec ubuntu
  218  sudo docker exec -it ubuntu /bin/bash
  219  sudo docker run -it --name ubuntu ubuntu /bin/bash
  220  ls
  221  sudo docker build . -t ubuntu_image
  222  docker run -it ubuntu_image
  223  sudo docker run -it ubuntu_image
  224  docker ps -a
  225  sudo docker ps -a
  226  sudo docker stop $(sudo docker ps -q)
  227  docker stop unruffled_mclean ubuntu busybox_it busybox
  228  sudo docker stop unruffled_mclean ubuntu busybox_it busybox
  229  sudo rm stop unruffled_mclean ubuntu busybox_it busybox
  230  sudo docker rm stop unruffled_mclean ubuntu busybox_it busybox
  231  docker ps -a
  232  sudo docker ps -a
  233  history