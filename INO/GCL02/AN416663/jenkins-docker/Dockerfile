FROM jenkins/jenkins:lts
USER root
RUN apt-get update -o Acquire::Check-Valid-Until=false && apt-get install -y docker.io
USER jenkins
