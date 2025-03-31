FROM ubuntu:latest

# Ustawienie autora obrazu (dobra praktyka)
LABEL maintainer="skwasny@student.agh.edu.pl"

RUN apt update && apt upgrade -y && apt install -y git

WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /app/repo

CMD ["/bin/bash"]
