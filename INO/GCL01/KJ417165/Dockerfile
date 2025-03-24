# Wybór obrazu bazowego
FROM fedora:latest

# Instalacja wymaganych pakietów
RUN dnf update -y && dnf install -y git

# Ustawienie katalogu roboczego
WORKDIR /app

# Sklonowanie całego repozytorium
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /app

# Domyślne polecenie po uruchomieniu kontenera
CMD ["bash"]

