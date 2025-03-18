# Bazowy obraz: Ubuntu najnowsza wersja
FROM ubuntu:latest

# Ustawienie autora obrazu (dobra praktyka)
LABEL maintainer="skwasny@student.agh.edu.pl"

# Zaktualizowanie pakietów i instalacja Git
RUN apt update && apt upgrade -y && apt install -y git

# Ustawienie katalogu roboczego wewnątrz kontenera
WORKDIR /app

# Klonowanie publicznego repozytorium przez HTTPS
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git /app/repo

# Ustawienie kontenera w trybie interaktywnym
CMD ["/bin/bash"]
