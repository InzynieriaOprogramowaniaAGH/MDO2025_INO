FROM fedora:latest

RUN dnf -y update && dnf -y install git && dnf clean all

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git .

CMD ["/bin/bash"]