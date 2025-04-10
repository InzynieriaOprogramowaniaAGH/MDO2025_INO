# Używamy najnowszej wersji Fedory jako bazowego obrazu
FROM fedora:latest

# Informacje o autorze
LABEL maintainer="Kaoina <kkurowska600@gmail.com>"

# Instalacja Git-a i usunięcie zbędnych plików cache
RUN dnf install -y git && dnf clean all

# Ustawienie katalogu roboczego
WORKDIR /app

# Sklonowanie repozytorium
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

# Domyślny tryb interaktywny (bash)
CMD ["/bin/bash"]
