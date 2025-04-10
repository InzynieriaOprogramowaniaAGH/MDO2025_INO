# Używamy najnowszej wersji Fedory jako bazowego obrazu
FROM fedora:latest

# Informacje o autorze (opcjonalnie)
LABEL maintainer="Karolina <kkurowska600@gmail.com>"

# Instalacja Git-a i usunięcie zbędnych plików cache (dobre praktyki)
RUN dnf install -y git && dnf clean all

# Ustawienie katalogu roboczego
WORKDIR /app

# Sklonowanie repozytorium (zmień na właściwy adres!)
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO

# Domyślny tryb interaktywny (bash)
CMD ["/bin/bash"]
