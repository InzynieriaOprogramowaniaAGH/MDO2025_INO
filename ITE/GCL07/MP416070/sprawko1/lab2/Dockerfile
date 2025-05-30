
FROM fedora:latest

# Autor obrazu (dobrze jest go dodać)
LABEL maintainer="Michal majkel@student.agh.edu.pl"

# Aktualizacja pakietów 
RUN dnf update -y && dnf install -y git

# Ustawiamy katalog roboczy wewnątrz kontenera
WORKDIR /app

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

CMD ["/bin/bash"]
