FROM ubuntu:latest

LABEL maintainer="Jasiek <janrzadkosz2004@gmail.com>"

RUN apt update && apt install -y git

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /repo

WORKDIR /repo

CMD ["/bin/bash"]
