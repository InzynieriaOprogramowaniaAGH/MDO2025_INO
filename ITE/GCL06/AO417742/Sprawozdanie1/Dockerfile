# Wybór  obrazu bazowego (Ubuntu)
FROM ubuntu:22.04

# Ustawienie  obrazu
LABEL maintainer="aolech55@gmail.com"
LABEL description="Minimalny obraz Ubuntu z Git i klonowaniem repozytorium"

# Zaktualizowanie pakietów i instalacja git
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \    
    && rm -rf /var/lib/apt/lists/*

# Ustawienie katalogu roboczego
WORKDIR /repo
RUN update-ca-certificates

# Sklonowanie repozytorium 
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /repo

# Ustawienie ENTRYPOINT dla interaktywnego środowiska
ENTRYPOINT ["/bin/bash"]
