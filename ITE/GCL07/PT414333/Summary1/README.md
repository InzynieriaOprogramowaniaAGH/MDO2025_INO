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