docker volume create input-volume
docker volume create output-volume

docker run --rm -it --name kontener_bazowy -v input-volume:/input-volume -v output-volume:/output-volume node:alpine sh

docker run --rm -it -v input-volume:/input alpine
apk add --no-cache git
git clone https://github.com/devenes/node-js-dummy-test input/

mkdir repo
cp -r input-volume/* repo/
cd repo/node-js-dummy-test
npm install

cp -r repo/node-js-dummy-test/node_modules/* output-volume/node_modules

docker lab4_ss/image pull networkstatic/iperf3
docker run -d --name iperf-server -p 5201:5201 networkstatic/iperf3 -s

docker inspect iperf-server | grep IP
docker run --rm -it networkstatic/iperf3 -c 172.17.0.4

docker network create --driver bridge iperf-network

docker stop iperf-server
docker rm iperf-server

docker run -d --name iperf-server -p 5201:5201 --network iperf-network networkstatic/iperf3 -s
docker run --rm -it --name iperf-client --network iperf-network networkstatic/iperf3 -c iperf-server

sudo dnf install -y iperf3
docker inspect iperf-server | grep IP
iperf3 -c 172.18.0.2

# poza hostem
iperf3 -c 172.30.165.83

docker run -d --name iperf-server -p 5201:5201 --network iperf-network networkstatic/iperf3 -s --logfile /server.log
docker run --rm -it --name iperf-client --network iperf-network networkstatic/iperf3 -c iperf-server
iperf3 -c 172.18.0.2

# poza hostem
iperf3 -c 172.30.165.83

docker exec -it iperf-server sh 
    cat server.log


docker image pull docker:dind
docker network create jenkins
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

nano Dockerfile.jenkins
docker build -t myjenkins-blueocean:2.492.2-1 -f Dockerfile.jenkins .
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

# commit i push wykonano przy pomocy Source Control w VSCode ale można to zrobić tak
git status
git add -A
git commit -m "message"
git push origin
git status
git log