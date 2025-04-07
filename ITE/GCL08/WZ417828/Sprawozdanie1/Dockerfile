FROM fedora:latest

RUN dnf upgrade -y && \
    dnf install -y git && \
    dnf clean all && rm -rf /var/cache/dnf

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["/bin/bash"]