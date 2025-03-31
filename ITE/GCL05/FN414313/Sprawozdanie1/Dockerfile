FROM fedora:latest

LABEL maintainer="Filnaw <filipnaw@student.agh.edu.pl>"

ENV DEBIAN_FRONTEND=noninteractive

RUN dnf update -y && dnf install -y git && dnf clean all

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /app

CMD ["/bin/bash"]
