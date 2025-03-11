# Wybieramy oficjalny obraz Ubuntu jako bazowy
FROM ubuntu:20.04

# Ustawiamy zmienną środowiskową, aby nie pytano o wybór lokalizacji podczas instalacji
ENV DEBIAN_FRONTEND=noninteractive

# Instalujemy wymagane pakiety, w tym Git
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Tworzymy katalog roboczy w kontenerze
WORKDIR /app

# Skopiujemy lokalne repozytorium do kontenera
# (Załóżmy, że masz repozytorium Git w lokalnym folderze)
COPY . /app

# Uruchomimy kontener w trybie interaktywnym, aby sprawdzić działanie repozytorium
CMD ["/bin/bash"]