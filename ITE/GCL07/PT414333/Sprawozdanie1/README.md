# Class 1
## Introduction, Git, Branches, SSH

## 1. Install Git

```sh
git -v
```
![alt text](class1/1.png)

## 2. Access Token

Create Personal Token at https://github.com/settings/tokens/new and use it to clone repo
![alt text](<class1/2 create token.png>)

Clone repository:
```sh
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
![alt text](<class1/2 clone-1.png>)

## 3. SSH keys
Create 2 SSH keys:
```sh
# with empty phrase
ssh-keygen -t ed25519 -C "patryk@twardosz.dev"

# with custom phrase 
ssh-keygen -t ed25519 -C "patryk@twardosz.dev"
```
![alt text](<class1/3 create.png>)


Add SSH key on site and to ssh manager: 
https://github.com/settings/keys
![alt text](<class1/3 add ssh key.png>)

```sh
eval "$(ssh-agent -s)"  # startup ssh agent
ssh-add ./devops_ssh_1  # add ssh
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
![alt text](<class1/3 add ssh key 2.png>)

Add 2FA: https://github.com/settings/security
![alt text](<class1/3 add 2FA.png>)

## 4. Swtich branch:
```sh
git branch          # check current branch
git checkout main   # switch to `main` branch
git branch          # check current branch
git fetch           # update remote repo
git checkout GCL07  # swithc to `GCL07` branch
```
![alt text](class1/4.png)

## 5. Own branch
```sh
git checkout -b PT414333
```
![alt text](class1/5-1.png)

## 6. Git Hooks
Create direcotry:
`./ITE/GCL07/PT414333/`

Craete Git Hook (file: commit-msg)"
```sh commit-msg
#!/bin/sh
FILE=$1
MSG=$(cat "$FILE")

if [[ ! $MSG =~ ^PT414333 ]]; then
    echo "ERROR: Invalid commit message. It has to begin with 'PT414333'."
    exit 1
fi
```

Add Git hook:
```sh
chmod +x ITE/GCL07/PT414333/commit-msg
git config --local core.hooksPath ITE/GCL07/PT414333/
```

Test:

```sh
git add .
git commit -m "Test"
git commit -m "PT414333: Git Hook"
```
![Relut of test](class1/6.png)

## 7. Push to remote
Push to remote repository
```sh
git push --set-upstream origin PT414333
```
Result:

![alt text](class1/7.png)

# Class 2
## Git, Docker

## 1. Install Docker

Instructions:
https://docs.docker.com/engine/install/

For ArchLinux:
```sh
sudo pacman -S docker # Arch
```
![alt text](class2/1.png)

## 2. Create DockerHub account

Link:
https://app.docker.com/signup

Reslut:

![alt text](class2/2.png)

## 3. Pull images

```sh
docker pull hello-world
docker pull busybox
docker pull ubuntu
docker pull mysql
```

![alt text](class2/3.png)

## 4. Run container

```sh
docker run -i -d --name Test busybox # run contaienr dettached
docker attach Test                   # attach std io

# inside container
busybox | head -1
```

![alt text](class2/4.png)

## 5. "System in container"

```sh
docker run -i -t -d --name Ubuntu ubuntu  # create new container
docker attach Ubuntu

# Inside contaienr
ps -fe

exit # exit from contaienr
```

![alt text](class2/5.png)

```sh
# On host
ps -fe
```

![alt text](class2/5.2.png)

## 6. Create custom image

Create file: `Dockerfile` with content:
```Dockerfile
FROM ubuntu

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
```
In `Dockerfile`'s directory:
```sh
docker build . -t test-image
```

![alt text](class2/6.1.png)
![alt text](class2/6.2.png)

```sh
docker run -i -t -d --name Test test-image
docker attach Test

# Inside container
ls
```

![alt text](class2/6.3.png)

## 7. Running containers
```sh
docker ps -la     # List all contaienrs

docker rm Test    # Remove container Test
docker rm Ubuntu  # Remove contaienr Ubuntu

docker ps -la
```

![alt text](class2/7.png)

## 8. Images cleanup

```sh
docker image prune
```
![alt text](class2/8.png)


# Class 3


## 1. Build & run tests in temporart container
```sh
docker run -i -t -d --name Ubuntu ubuntu
docker attach Ubuntu

# Inside container
apt -y update
apt -y install git meson gcc libglib2.0-dev libssl-dev libncurses-dev libutf8proc-dev libperl-dev

git clone https://github.com/irssi/irssi.git
cd irssi

meson Build
ninja -C Build && ninja -C Build test
```
![alt text](class3/3.png)

## 2. Create Dokerfiles for build & test

Create build [Dockerfile.irssi_b](class3/Dockerfile.irssi_b)
```Dockerfile
FROM ubuntu

RUN apt -y update && \
    apt -y install git meson gcc libglib2.0-dev libssl-dev libncurses-dev libutf8proc-dev libperl-dev

RUN git clone https://github.com/irssi/irssi.git
WORKDIR /irssi

RUN meson Build
RUN ninja -C Build
```

Create image:
```sh
docker build -f Dockerfile.irssi_b -t irssi-build .
```
![alt text](class3/2.png)

Create test [Dockerfile.irssi_t](class3/Dockerfile.irssi_t)
```Dockerfile
FROM irssi-build

WORKDIR /irssi

RUN ninja -C Build test
```
Create image:
```sh
docker build -f Dockerfile.irssi_t --no-cache -t irssi-tests .
```
![alt text](class3/1.png)

# Class 4
## 1. State persistance

Create [Dockerfile.build](class4/Dockerfile.build)
```Dockerfile
FROM ubuntu

RUN apt -y update && \
    apt -y install meson gcc libglib2.0-dev libssl-dev libncurses-dev libutf8proc-dev libperl-dev

WORKDIR /app
```

Build image from it.
```sh
docker build -f Dockerfile.build -t build .
```
![alt text](class4/1.png)


Create new volumes
```sh
docker volume create build-in
docker vloume create build-out
```
![alt text](class4/2.png)

Clone repository to `build-in` volume
```sh
cd /var/lib/docker/volumes/build-in/_data
git clone https://github.com/irssi/irssi.git .
```
![alt text](class4/3.png)


Create build container
```sh
docker run -it -v build-in:/app -v build-out:/app-out --name Build build

# Inside docker
meson ../app-out && ninja -C ../app-out
```
![alt text](class4/4.png)

In order to provide srource code into container I mounted 2 volumes and cloned repository into input volume.  

## 2. Port exposing
Create iperf-server container:
```sh
docker pull networkstatic/iperf3
docker run -it -d --name iperf3-server -p 5201:5201 networkstatic/iperf3 -s
```
![alt text](class4/5.png)

Connection create client container
```sh
docker run -it --name iperf3-client networkstatic/iperf3 -c 127.17.0.3
```
![alt text](class4/6.png)

Create iperf network
```sh
docker network create iperf3-network
```
![alt text](class4/7.png)

Create new containers in custom network
```sh
docker run -d --name iperf3-server-net -p 5201:5201 --network iperf3-network networkstatic/iperf3 -s
docker run -it --name iperf3-client-net --network iperf3-network networkstatic/iperf3 -c iperf3-server-net
```
![alt text](class4/8.png)

Test from host
```sh
iperf3 -c localhost
```
![alt text](class4/9.png)


Get logs from iperf server.
```sh
docker logs iperf3-server-net
```
![alt text](class4/10.png)

## 3. Jenkins setup

Create jenkins network
```sh
docker network create jenkins
```
![alt text](class4/11.png)

DIND container startup
```sh
docker run \
  --name jenkins-docker \
  --rm \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind \
  --storage-driver overlay2
```
![alt text](class4/12.png)

Create custom Jenkins image [Dockerfile.jenkins](class4/Dockerfile.jenkins)
```sh
cd ITE/GCL07/PT414333/Summary1/class4
docker build -f Dockerfile.jenkins -t myjenkins-blueocean:2.492.2-1 .
```
![alt text](class4/13.png)

Run Jenkins container
```sh
docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.492.2-1
```
![alt text](class4/14.png)
![alt text](class4/15.png)


Open Jenkins in browser
![alt text](class4/16.png)

Get initail admin password
```sh
cat /var/lib/docker/volumes/jenkins-data/_data/secrets/initialAdminPassword
```
![alt text](class4/17.png)
![alt text](class4/18.png)