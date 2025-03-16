# Używamy obrazu Ubuntu jako bazowego
FROM ubuntu:latest

# Ustawiamy zmienną środowiskową, by uniknąć interakcji podczas instalacji
ENV DEBIAN_FRONTEND=noninteractive

# Instalujemy git i inne potrzebne narzędzia
RUN apt-get update && apt-get install -y git

# Tworzymy katalog roboczy
WORKDIR /workspace

# Sklonowanie repozytorium
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

# Zmieniamy katalog na pobrane repozytorium
WORKDIR /workspace/MDO2025_INO

# Uruchamiamy interaktywnie bash w kontenerze
CMD [ "bash" ]
