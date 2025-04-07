# Bazowy obraz
FROM ubuntu:latest

# Ustawienie maintainera
LABEL maintainer="periclesathin <jan.kubicius@gmail.com>"

# Aktualizacja systemu i instalacja Git-a
RUN apt update && apt upgrade -y && apt install -y git

# Ustawienie katalogu roboczego
WORKDIR /app

# Klonowanie repozytorium (zamień URL na swoje repo)
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git

# Ustawienie domyślnej komendy
CMD ["/bin/bash"]
