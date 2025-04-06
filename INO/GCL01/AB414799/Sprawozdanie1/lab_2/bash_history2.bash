sudo dnf install -y docker
docker --version
sudo systemctl status docker
sudo systemctl start docker
sudo systemctl status docker
sudo systemctl enable docker

docker pull hello-world
docker pull busybox
docker pull mysql
docker pull ubuntu
docker images

docker run busybox echo "Kontener busybox"
docker run -it busybox sh
busybox --help # w kontenerze
docker run -it ubuntu bash
ps aux # w kontenerze
apt update && apt upgrade -y # w kontenerze

nano Dockerfile
docker build -t new_image .
docker run -it new_image

docker ps -a
docker rm $(docker ps -aq)
docker images
docker rmi $(docker images -aq)

git add .
git status
git commit -m "AB414799: small changes and task2 completed"
git push origin AB414799