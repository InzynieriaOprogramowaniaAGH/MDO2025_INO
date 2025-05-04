FROM fedora:latest
WORKDIR /app
RUN dnf -y update && \
    dnf -y install git
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
ENTRYPOINT ["/bin/bash"]