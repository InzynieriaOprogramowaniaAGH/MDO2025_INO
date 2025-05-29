FROM ubuntu:latest

# Unikaj interaktywnych promptów
ENV DEBIAN_FRONTEND=noninteractive

# Aktualizuj system i zainstaluj zależności
RUN apt-get update && \
    apt-get install -y \
    wget \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Skopiuj plik .deb
COPY deploy_redis/files/redis-deb.deb /tmp/

# Zainstaluj Redis z pliku .deb
RUN dpkg -i /tmp/redis-deb.deb || apt-get install -f -y

# Stwórz katalog dla danych Redis
RUN mkdir -p /data

# Eksponuj port Redis
EXPOSE 6379

# Uruchom Redis
CMD ["redis-server", "--protected-mode", "no", "--dir", "/data"]