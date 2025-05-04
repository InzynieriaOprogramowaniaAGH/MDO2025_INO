# Użyj obrazu bazowego Fedora
FROM fedora:latest

# Zaktualizuj system i zainstaluj git
RUN dnf -y update && dnf -y install git

# Ustaw katalog roboczy
WORKDIR /app

# Skopiuj repozytorium z GitHuba (zmień na własne repozytorium)
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

# Ustaw domyślne polecenie, które zostanie uruchomione w kontenerze
CMD ["/bin/bash"]
