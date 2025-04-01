FROM ubuntu:latest

RUN apt update && \
    apt upgrade -y && \
    apt install -y git && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

WORKDIR /MDO2025_INO

CMD ["/bin/bash"]