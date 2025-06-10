FROM fedora:latest

WORKDIR /app

RUN dnf install -y git

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

WORKDIR /app/MDO2025_INO

CMD ["/bin/bash"]