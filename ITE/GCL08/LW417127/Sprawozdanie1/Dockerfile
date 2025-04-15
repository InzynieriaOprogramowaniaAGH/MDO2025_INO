# Dockerfile
FROM ubuntu:20.04

# Instalacja Git
RUN apt-get update && apt-get install -y git

# Skopiuj nasze repozytorium
WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

CMD ["bash"]