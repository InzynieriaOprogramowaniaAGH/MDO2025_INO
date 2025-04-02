sudo dnf install docker
docker version
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker

sudo docker image pull hello-world
sudo docker image pull busybox
sudo docker image pull ubuntu
sudo docker image pull mysql
docker image ls

sudo docker run -it --rm busybox -c "cat --help"
sudo docker run -it --rm ubuntu:latest bash -c "apt update && apt upgrade"
sudo docker ps
ps aux | grep docker

nano Dockerfile 
sudo docker build -t alpine-image .
docker run --rm -it alpine-git
docker ps

docker container prune
docker rmi -f $(docker images -aq)

# commit i push wykonano przy pomocy Source Control w VSCode ale można to zrobić tak
git status
git add -A
git commit -m "message"
git push origin
git status
git log