# Bazowy obraz: Ubuntu
FROM ubuntu:latest

# Instalacja Git
RUN apt update && apt install -y git

# Ustawienie katalogu roboczego
WORKDIR /app

# Sklonowanie repozytorium
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

# Ustawienie domyślnej komendy
CMD ["bash"]

