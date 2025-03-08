FROM ubuntu:latest

LABEL maintainer="Jakub Robak"

RUN apt update && apt upgrade -y && \
    apt install -y git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

CMD ["/bin/bash"]
