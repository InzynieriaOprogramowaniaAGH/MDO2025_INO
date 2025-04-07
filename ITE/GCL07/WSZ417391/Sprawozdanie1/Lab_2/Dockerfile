FROM fedora:latest

RUN dnf install -y git && dnf clean all

WORKDIR /repozytorium

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git .

CMD ["/bin/bash"]