FROM ubuntu:latest

LABEL maintainer="Oliwia Wiatrowska"

RUN apt update && apt install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

CMD ["bash"]
