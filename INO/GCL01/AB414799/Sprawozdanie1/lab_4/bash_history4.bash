cd MDO2025_INO/INO/GCL01/AB414799/Sprawozdanie1
mkdir lab_4
cd lab_4

docker volume create input_vol
docker volume create output_vol
docker run -it -v input_vol:/input -v output_vol:/output ubuntu bash
# w kontenerze
apt update && apt install -y cmake gcc g++ make
apt update && apt install -y meson ninja-build
# exit

docker volume inspect input_vol
sudo git clone https://github.com/irssi/irssi.git /var/lib/docker/volumes/input_vol/_data
docker run -it -v input_vol:/input -v output_vol:/output ubuntu bash
# w kontenerze
cd input
meson Build
cd ..
cp -r /input /output
cd output 
ls
# exit

sudo ls /var/lib/docker/volumes/output_vol/_data
docker run -it -v input_vol:/input -v output_vol:/output ubuntu bash
# w kontenerze
apt update && apt install -y git
git clone https://github.com/irssi/irssi.git
# exit

docker run -d --name iperf_server -p 5201:5201 networkstatic/iperf3 -s
docker inspect iperf_server | grep IP
docker run --rm -it networkstatic/iperf3 -c 172.17.0.2
docker network create iperf_network
docker run -dit --name serv --network iperf_network networkstatic/iperf3 -s
docker run --rm --network iperf_network  networkstatic/iperf3 -c serv
docker stop iperf_server
docker rm iperf_server
docker run -d --name iperf_server -p 5201:5201 networkstatic/iperf3 -s
sudo dnf install -y iperf3
iperf3 -c localhost

.\iperf3.exe -c 192.168.56.1 # na Windows
docker logs iperf_server


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

nano Dockerfile
docker build -t myjenkins-blueocean:2.492.2-1 -f .

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


