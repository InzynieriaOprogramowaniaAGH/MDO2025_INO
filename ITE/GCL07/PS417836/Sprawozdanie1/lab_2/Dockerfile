FROM fedora:latest
LABEL maintainer="Pawel Socala"

RUN dnf update -y && \
    dnf install -y git && \
    dnf clean all

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /MDO2025_INO
WORKDIR /MDO2025_INO
CMD ["/bin/bash"]
