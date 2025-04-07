FROM fedora:latest

RUN dnf -y update && dnf install -y git && dnf clean all

WORKDIR /workspace

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["/bin/bash"]