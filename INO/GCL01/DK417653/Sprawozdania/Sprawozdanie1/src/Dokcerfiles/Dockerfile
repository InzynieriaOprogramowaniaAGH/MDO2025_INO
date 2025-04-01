#System Image
FROM ubuntu:latest

#Git installation
RUN apt update && apt install -y git && \
    rm -rf /var/lib/apt/lists/*

#Information about author
LABEL maintainer="Dominik K"

#Clone Git repo
WORKDIR /repo
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

#Interaction setting
CMD ["/bin/bash"]

